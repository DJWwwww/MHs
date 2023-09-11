function Mi = nor(x)
maxi=max(x);
mini=min(x);
Mi=(x-mini+eps)./(maxi-mini+eps);