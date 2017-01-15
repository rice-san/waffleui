update_mt = {
  __newindex = function(t,k,v)
    rawset(t,k,v)
    UIStatus.needsUpdate = true
  end
}
