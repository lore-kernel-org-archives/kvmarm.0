Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA1E2AE68;
	Fri, 31 Jul 2026 20:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785528343; cv=none; b=ivjZzi63Wc7C04pDxV999zwTqhb9aw7OH+jtrnBlnM/9k7TGZObvEt1KlnFRO3j3bJQ4IynunfVJvZL9ayF6mQrfW2o3XrFJZQHnxCZIjla1/OIekCFV164Q6T7Y6TWaIo/sJfNr4g3iJVdhw2yvvLXoYFP24QB4p3AWo4JIqZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785528343; c=relaxed/simple;
	bh=zo56Gnd1AQzJe+MKAELMxizFxj8IzCHAcwvlKn0Oh2w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Zrk+rqHHcVenLpfmCpDvJmUssyuC5R+e4+BuEkMxxJz8r5ewF/U1VMrSueYt+04gYoiRjmQjr8W80mija7NXleYVDoDO1TqA0GN7C9aLoCBs4OvsNh4hliZEHoXLRgGd70jhB5ix+4DvCAtj8V5HYi6ESNKI4nT8LTDP4X/rcpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSOo+m9H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSOo+m9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC90E1F00AC4;
	Fri, 31 Jul 2026 20:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785528342;
	bh=fscBRLpahpY/cZ7dSQqNQTwjkFM8uGa5YbAsWof7DM4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WSOo+m9HOR1c/Emt4WIAe2c4/xSvtCIj0JDNZC+rLfGrtnsn/nS6C5kDv2oe35wpf
	 U8Pk7teD/rRu8vB8HH+jkpXjQ6oC0UCqVKr+60ZHTY7K4StrUgEjRtDPgHGZooVVM9
	 89cdmV7E/N17hQCwKo8q0eS5/nzR6EHkxwLWuXRzhre5sTFbPGzu2lIhPQLq1MIyJU
	 kn9MY9rh4bfGH5Fnswg37QDvhqv5spHrRuQq92NE62Cbr0JcEtXx3P48ShB7cermXI
	 BGGb2fnHr0qi6Kc2cdkFi7/5jM/kAnM9j9aZhisdt+WTH1JRngG2qMqs0M2ltY54Zn
	 79FW9Fdmi6yZQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/12] KVM: selftests: Add KVM syscall wrapper for
 pthread_create()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260731195612.2697986-9-seanjc@google.com>
References: <20260731195612.2697986-1-seanjc@google.com>
 <20260731195612.2697986-9-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 20:05:41 +0000
Message-Id: <20260731200541.CC90E1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `kvm_pthread_create` wrapper incorrectly uses `errno` for er=
ror reporting, which `pthread_create` does not set.
--

--- Patch [8]: [PATCH v3 08/12] KVM: selftests: Add KVM syscall wrapper for=
 pthread_create() ---
commit d35383198b73b658a7a90f8c3560d48c6d71d62b
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Add KVM syscall wrapper for pthread_create()

This commit adds a wrapper for pthread_create() in KVM selftests to
automatically assert success. It converts various manual checks across
multiple tests to use the new kvm_pthread_create() wrapper.

> diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/t=
esting/selftests/kvm/include/kvm_syscalls.h
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

[Severity: Medium]
Since pthread_create() returns the error code directly rather than setting
errno, will this __KVM_SYSCALL_DEFINE wrapper print stale or zero errno val=
ues
on failure?

The __KVM_SYSCALL_DEFINE macro relies on __KVM_SYSCALL_ERROR, which formats
the error using errno:

#define __KVM_SYSCALL_ERROR(_name, _ret) \
    "%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(er=
rno)

If pthread_create() fails, should it be handled differently to ensure the
actual returned error code is passed to strerror() instead of the unmodified
errno?

>  #define kvm_free_fd(fd)		\
>  do {				\
>  	kvm_close(fd);		\

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731195612.2697=
986-1-seanjc@google.com?part=3D8
