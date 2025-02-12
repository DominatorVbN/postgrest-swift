struct NoParams: Encodable {}

public final class PostgrestRpcBuilder: PostgrestBuilder {
  /// Perform a function call with params.
  /// - Parameter params: The function params.
  func rpc<U: Encodable>(
    params: U,
    head: Bool = false,
    count: CountOption? = nil
  ) -> PostgrestTransformBuilder {
    // TODO: Support `HEAD` method
    // https://github.com/supabase/postgrest-js/blob/master/src/lib/PostgrestRpcBuilder.ts#L38
    assert(head == false, "HEAD is not currently supported yet.")

    method = "POST"
    if params is NoParams {
      // noop
    } else {
      body = params
    }

    if let count = count {
      if let prefer = headers["Prefer"] {
        headers["Prefer"] = "\(prefer),count=\(count.rawValue)"
      } else {
        headers["Prefer"] = "count=\(count.rawValue)"
      }
    }

    return PostgrestTransformBuilder(self)
  }
}
