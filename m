Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8503264C8
	for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 20:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785443065; cv=none; b=XTleKmEkaEoejJNJt4YyZDsAGqPB329vCo2yVnHZeq6a38o5uCVA2j+xYmS6G8qQJ3jTCwEXr01YfAxDduyZb2+Z8m4RTPDudoFn9Me2YkW7LwI6RJNWAXpi424fkxDb2j2JIDxgsGqNdOxXpt6/d3iI8YhCr3kuA6KXMv9Xeco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785443065; c=relaxed/simple;
	bh=gXSPYdsXecirkIEGeu3WOkr+wc9b/nFJSCR/RoTgme4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=olrjLKa5dFazKwCEi+z801nTauhi7gzLoPIrGt7Ydnul9LFH2wyNTzLSz4Qtdtvxt6QAPs8mtp6TbpJ+PZq/B9Nx+6oWYz1K95GMtVhMo+dha5gkQSbMWuv0Zub23f0rot5acoOwPgp+ZxOEdttxxcFbOpty2MdkcQQ6nM8uaig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LV8FpPB7; arc=none smtp.client-ip=209.85.210.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LV8FpPB7"
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-848860def2cso278071b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 30 Jul 2026 13:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785443064; x=1786047864; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TrtiBmboLLsPIIH2ER5IgQHpTzlTWLaZtWKiYKxuQYo=;
        b=LV8FpPB7d+y6abJqHvfsPaI8b7iXI/d0+y1W7Rf3+iVEm0GXF03FgfzaDToldbYFnP
         uVkYWNA3IZqc4JlLWNYJNwz2aie3xNPN0L7biY50f7i7EOLHpTz0J/YyXCRnuKYKARDS
         RXGe1uvoAM488gskbItD8EiqRIDBgdEHnNXEaAUQiufNH+icocVdxLh8qyifmijqZQiB
         dZSv+fOvjNWh4M6QgdG/QjmVxfhPR6iKvracgcYlCmIAby/jGabjcDX1N5ykh+oZUIGH
         9p6xAP6Mmg37//lebJua1yG6ZZMeXbYfGyWRkYGnRakqGnjusgWyA/HGXBVbJnq3oMmL
         ASnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785443064; x=1786047864;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TrtiBmboLLsPIIH2ER5IgQHpTzlTWLaZtWKiYKxuQYo=;
        b=kNzI8QninAALitRaC08VZWo+uIWCz+cLJ54BidhluhjOn/qyv8gagRBs8DE+fnBenk
         U+8bcjXIuP9RligbJ2h0SX3eaCPHkuPPl1VL3nvqdE//XGGqgsghnH0FcI6CHszee5i8
         LoMAUJcW0JFZtjUtulXiKieY42HULAHRIYQJQxxuAUMdDbdkrVIIGGAwVAnAA0JEjAmX
         MyPKKoPX0yYnAOZK23ZF9A6uvrrScwbHYnf6ZsIAMiqo6AYrNoWAKaQLHzZ8WfYlEDBr
         liDSoZKBtsZBkPGRmFPm1aBLuV/CrqU/OZlmXWIqYUJy/3Z8RdHD8OCVlwjP/WeQXruG
         tzIw==
X-Forwarded-Encrypted: i=1; AHgh+RqVcL9LCU5p5UdKVrl6DE2JGCKnyo3MREWwZuG8wgAykKCwDDpu24IvW5M7WjUTER5TQTKTk5I=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzq7dNtWWC309DhPTpDvMf1E/w1cCG4AY7RmyDBTjhSByq7ukzN
	IUXkLXKkA2V5oh9FjrNdCdK5Ww1B9lRgYAg2bWXHyzsuQ9tpv0dUMmcjxrifASvaPE4OhJ+xlxR
	sdJViEg==
X-Received: from pfx52.prod.google.com ([2002:a05:6a00:a474:b0:84a:6b32:7768])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:929e:b0:848:82f0:679a
 with SMTP id d2e1a72fcca58-84ebc3e247dmr3708347b3a.52.1785443063292; Thu, 30
 Jul 2026 13:24:23 -0700 (PDT)
Date: Thu, 30 Jul 2026 13:24:22 -0700
In-Reply-To: <20260730192929.ACE681F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260730191908.2084803-1-seanjc@google.com> <20260730191908.2084803-9-seanjc@google.com>
 <20260730192929.ACE681F000E9@smtp.kernel.org>
Message-ID: <amuy9j7XHfyAXMac@google.com>
Subject: Re: [PATCH 8/9] KVM: selftests: Add KVM syscall wrappers for pthread_{g,s}etaffinity_np()
From: Sean Christopherson <seanjc@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 30, 2026, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] KVM syscall wrappers for pthread functions produce misleading error messages on failure.
> --
> 
> --- Patch [8]: [PATCH 8/9] KVM: selftests: Add KVM syscall wrappers for pthread_{g,s}etaffinity_np() ---
> commit 9fc7623d339b95135fb5ecb9685356bc8dff9829
> Author: Sean Christopherson <seanjc@google.com>
> 
> KVM: selftests: Add KVM syscall wrappers for pthread_{g,s}etaffinity_np()
> 
> This commit adds KVM wrappers for pthread_getaffinity_np() and 
> pthread_setaffinity_np() to simplify selftest code. It removes the need 
> to manually check for success or supply the size of cpu_set_t in the tests.
> 
> [ ... ]
> 
> > diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/testing/selftests/kvm/include/kvm_syscalls.h
> > index 002b5a4e59eb2..3d82351bef92e 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
> > @@ -97,6 +97,22 @@ __KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, off_t, length);
> >  __KVM_SYSCALL_DEFINE(madvise, 3, void *, addr, size_t, length, int, advice);
> >  __KVM_SYSCALL_DEFINE(sched_getaffinity, 3, pid_t, pid, size_t, cpusetsize, cpu_set_t *, mask);
> >  
> > +__KVM_SYSCALL_DEFINE(pthread_getaffinity_np, 3, pthread_t, thread,
> > +		     size_t, cpusetsize, cpu_set_t *, cpuset);
> > +__KVM_SYSCALL_DEFINE(pthread_setaffinity_np, 3, pthread_t, thread,
> > +		     size_t, cpusetsize, const cpu_set_t *, cpuset);
> 
> [Severity: Medium]
> Will these pthread wrappers print misleading error messages on failure?
> 
> The pthread_* functions return positive error codes directly on failure 
> rather than returning -1 and setting errno. If __KVM_SYSCALL_DEFINE formats 
> its failure messages assuming errno is set, failing to set affinity could 
> result in printing a stale or unrelated error string (such as "Success") 
> alongside the return code, which might impede debugging.

Empirically, no.  Just because they _also_ return an exact error code doesn't
make errno invalid.

==== Test Assertion Failure ====
  include/kvm_syscalls.h:117: !r
  pid=155681 tid=155681 errno=11 - Resource temporarily unavailable
  pthread_create failed, rc: 11 errno: 11 (Resource temporarily unavailable)
