Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31C33A1D02;
	Fri, 31 Jul 2026 17:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785518412; cv=none; b=UEsWY/KVYtMZgQoPRCklGvruX4JKVvV34aIRKZOF0vWWwPZw0Fdc08P0h7VV/gaLCgI0i8aNdjTj6SFfrvNAHGX22eXpJl5lJJ/YDS8BiGntgrckMy0kJ/QiplXt1x05uVl+zrSiOPVWz/n4c4hXC4O5rlfvIavNAFwqmBXeuyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785518412; c=relaxed/simple;
	bh=56EQ3wY0w5NW8FUm5LrKM07hS0VFaj6hZt8OTHEB7uM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mJmm668BSWHPwfCfzMB/J4mehGYIl22JP0mQG5OH2aVLBNBF7H8jJMG6R3CJI7xzSOFFCCW5FcGljx+ErNJEpWnOiCQQEq/Ewl+BK7RZhd8jh5QFcP5K2Lpb1G8iFdrbUZXqvlSIzSYIGz7EWmlrYC83yCo2UhJrsa0PYave3+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mni4y9Nl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mni4y9Nl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419501F00AC4;
	Fri, 31 Jul 2026 17:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785518411;
	bh=Miy1Oqk30qBKPYaAcQLu77bS5G8/M3dvs2FXN1XXZB8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mni4y9Nl80QyhN0WjmQgWIHfg+7rJ1S73GpjbllIi6tjUlM4TlsS+H73gKUJKwGBg
	 JU9LspEsWUaEMsce+rMchl7Te79bbOWYJL1ijL+wU33DuUMimD/DVXMRpbNMaR4ac2
	 gnWFGMDWrvsZa0qNSyOqQCXVszyAO8zyjpcWh5tXcRVxEAlKj23uKjZNq28x/ZdKGI
	 Frs7SjcWw5M7Javsh/a5YTrzCwwVK/VaRQ9bUUfpyaE5VQXr4TtEQAzJCUDE5KZJRn
	 ig+xrQl4bOBHEhTfGjIo4LuoY0G9/BYyw22XvxuUE58QpZd5uMn3ZJsyv9xtOX+mlu
	 yK+K4ofmP8fjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/12] KVM: selftests: Add KVM syscall wrapper for
 pthread_create()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260731170619.2620845-9-seanjc@google.com>
References: <20260731170619.2620845-1-seanjc@google.com>
 <20260731170619.2620845-9-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 17:20:10 +0000
Message-Id: <20260731172011.419501F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Using `__KVM_SYSCALL_DEFINE` to wrap `pthread_create` results in mi=
sleading error messages on failure, as it logs `errno` instead of the retur=
ned error code.
--

--- Patch [8]: [PATCH v2 08/12] KVM: selftests: Add KVM syscall wrapper for=
 pthread_create() ---
commit dca849bcf7bfa248030e1f22bebefccde9e01db3
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Add KVM syscall wrapper for pthread_create()

This commit adds a wrapper for the pthread_create() syscall to the KVM
selftests. It replaces manual error checking across the selftests with the
new wrapper which automatically asserts success.

[ ... ]
> diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/t=
esting/selftests/kvm/include/kvm_syscalls.h
> index 01dca99009c2f..e75be83787798 100644
> --- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
> +++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
[ ... ]
> @@ -97,6 +98,10 @@ __KVM_SYSCALL_DEFINE(madvise, 3, void *, addr, size_t,=
 length, int, advice);
>  __KVM_SYSCALL_DEFINE(sched_getaffinity, 3, pid_t, pid, size_t, cpusetsiz=
e, cpu_set_t *, mask);
>  __KVM_SYSCALL_DEFINE(sched_setaffinity, 3, pid_t, pid, size_t, cpusetsiz=
e, cpu_set_t *, mask);
> =20
> +typedef void *(*pthread_fn_t)(void *);
> +__KVM_SYSCALL_DEFINE(pthread_create, 4, pthread_t *, thread,
> +		     const pthread_attr_t *, attr, pthread_fn_t, fn, void *, arg);
> +

[Severity: Low]
Does this wrapper format the error message correctly on failure?

The __KVM_SYSCALL_DEFINE macro uses __KVM_SYSCALL_ERROR to format the error
string, which reads errno and uses strerror(errno).

However, POSIX specifies that pthread_create returns the error code directly
and does not set errno.

If pthread_create fails, wouldn't this print a stale errno, or print "Succe=
ss"
if errno happened to be zero, rather than reporting the actual returned err=
or
code?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731170619.2620=
845-1-seanjc@google.com?part=3D8
