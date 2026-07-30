Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C7144AB64;
	Thu, 30 Jul 2026 19:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785439850; cv=none; b=ew07X7//iY0kktCSXgCmf7YZzfQW58pqCvu0i7gJSZmfdiM370bzUvJoS4Z8MlsqmE5wp3yckmvIE0uArie0E4HETDVZ0TUueyRKTsTPeC2jWKhncsqSiIo2VU+Grbm3pgKtyML4iL8xO3ZNr51JdQGdQ/yXn+LwWWISWMTK37E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785439850; c=relaxed/simple;
	bh=8VRZ39JjW+LnTnhUyTEBevaTR9oofWRnqiZVVL0QE+E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fxVnbP5ViWhQNeDVZKPkDg2Utc/8impyEdfIVqjVTj5JMo//5WZIPiOJgCvnu7mzbZ8i4U1YXZW2o7VpBpGwR+w9k3PtJE0C/jjA09t3VkSVxzS2n0XTyAkPCx74mpZesnf3ewW5VpcZwc4dryQ17WMtEdeSE6xqHSIvPFFgf/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HyLg9Wnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HyLg9Wnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7461F000E9;
	Thu, 30 Jul 2026 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785439847;
	bh=ox5sZGQ//BQnwB1WVHF9fNTVmApRVXCe/kQVAmkGFIs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HyLg9Wnf7Id0QAA9EITRpPdZClIeCJo5RQvoa2V22GwcUBVdSf23eJ9db3tbFVYwu
	 DopRFydVzX48gcv3CxpuM4Q8oajX8WlgSfkceV1t09o8vyHN8srS0WkYUfVDvzF0TZ
	 oYPRUNx89Ct00yE/MIF0nWo1ajRki6e/fVTVHt9k8WL/uYh442AcqZVHvZB53CaqFA
	 FxSH30CXXaSNhFKPw7gzFnHlM3ziFsWRNKkMbjvtDc3hc/dKhkwr4+MFpq7lE7n0SO
	 r86yu7S/YXmDa4Q1IzDQzbq92Sbo+tPz7eCtgi+GQuEZmlZ6n9ML02+5wZVkNTP9g0
	 dS4naurTreJ8w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/9] KVM: selftests: Add KVM syscall wrapper for
 pthread_create()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260730191908.2084803-6-seanjc@google.com>
References: <20260730191908.2084803-1-seanjc@google.com>
 <20260730191908.2084803-6-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 19:30:46 +0000
Message-Id: <20260730193047.3E7461F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Misleading error reporting when pthread_create fails due to relianc=
e on errno.
--

--- Patch [5]: [PATCH 5/9] KVM: selftests: Add KVM syscall wrapper for pthr=
ead_create() ---
commit c5c266b1e7b797f8b82c5a3cecf097ba6720b060
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Add KVM syscall wrapper for pthread_create()

This commit adds a KVM wrapper for pthread_create() to eliminate manual
success assertions in selftests. It replaces direct calls to pthread_create=
()
with kvm_pthread_create() across multiple test files.

> diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/t=
esting/selftests/kvm/include/kvm_syscalls.h
> --- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
> +++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h

[ ... ]

> @@ -96,6 +97,10 @@ __KVM_SYSCALL_DEFINE(ftruncate, 2, unsigned int, fd, o=
ff_t, length);
>  __KVM_SYSCALL_DEFINE(madvise, 3, void *, addr, size_t, length, int, advi=
ce);
>  __KVM_SYSCALL_DEFINE(sched_getaffinity, 3, pid_t, pid, size_t, cpusetsiz=
e, cpu_set_t *, mask);
> =20
> +typedef void *(*pthread_fn_t)(void *);
> +__KVM_SYSCALL_DEFINE(pthread_create, 4, pthread_t *, thread,
> +		     const pthread_attr_t *, attr, pthread_fn_t, fn, void *, arg);

[Severity: Low]
Does this lead to misleading error messages on failure?

The __KVM_SYSCALL_DEFINE macro seems to assume the wrapped function sets er=
rno
on failure, which gets printed when the test asserts via __KVM_SYSCALL_ERRO=
R.=20
However, pthread_create() returns its error code directly rather than setti=
ng
errno.=20

If thread creation fails, it looks like the test framework might print a
misleading message containing "errno: 0 (Success)" alongside the actual
non-zero return code. Should this use a different wrapper or assert strategy
that handles direct error returns?

> +
>  #define kvm_free_fd(fd)		\
>  do {				\
>  	kvm_close(fd);		\

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260730191908.2084=
803-1-seanjc@google.com?part=3D5
