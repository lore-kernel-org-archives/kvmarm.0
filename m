Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1DD37DEA3;
	Fri, 31 Jul 2026 20:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785528689; cv=none; b=hha7TtNX0WQgaTL+guhF6WI9pkB/ntzlvxSKzmRIUBndaIeMxhodLbGcDXzJ+n+arqfHiOrZSmOjTDzYZMEOKfxFJo75QHD/D+zxT/pzJZUbukrzUWVNrES+TnmQ8BLAqeEymd5EPDy8ioSiyxtBtsPflBj40gdEArLinAqV0/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785528689; c=relaxed/simple;
	bh=ahkOah4SzBQodcWS+iZEr57NZUeRX94AiYXyoNQRBT4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=e0jhiSdVqTM1IftIaREO2LhEclKpP2YjJcZdD71sUK6OJ/DYBxs6+OVZ19GrX8b41cWy9s/nMG0eAXaPn5TTBeX1hj9QksSsvu2QVarV+jYNr7PYg85nNhaDwWUegW6ErvPxiDV06+xEzzmLn4RGGkUMbT45AV5Uu+vTppMd/nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ve6cPVT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ve6cPVT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5ED1F00AC4;
	Fri, 31 Jul 2026 20:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785528688;
	bh=TIjWn4VkS7rnoU21qYp4qmqMhcs8nrJq5ed5MDecRJ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ve6cPVT44jl/OIe4wnNGe0khowcPtI2eieXjNxSr16f+MZ4R1gpNQsEbeGZDDb3F/
	 1+st0brkEhe3RpX1S9CPsaPGUJXv2+ecqXv/bghPjVWsAMthX/j9EP4ennp66KByGJ
	 QHeCdv+BljWm3errGp+G9RGHrhNNH99/SEFBavvzPQTwDPE2xbVegxx+O2/e0zqqg2
	 xx0kscjn60eMWl4TmRqt+JSaJIJ7k/81g6ZzYNj7ZSRD8mFkZzKdQq3Zgw1baJTCW7
	 f84tLdUFoSroY+2YPyaOBxO7AUACYS/jtKgCTAiKk9g5T3GP8kAV5SAYwyeaow4Scv
	 5/uuensxoqxtA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/12] KVM: selftests: Add KVM syscall wrappers for
 pthread_{cancel,join}()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260731195612.2697986-10-seanjc@google.com>
References: <20260731195612.2697986-1-seanjc@google.com>
 <20260731195612.2697986-10-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 20:11:27 +0000
Message-Id: <20260731201127.BE5ED1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `kvm_pthread_join` and `kvm_pthread_cancel` wrappers generat=
e misleading error messages on failure because they use `__KVM_SYSCALL_ERRO=
R`, which prints `errno` and `strerror(errno)`. However, `pthread_join` and=
 `pthread_cancel` return error numbers directly and do not set `errno`.
--

--- Patch [9]: [PATCH v3 09/12] KVM: selftests: Add KVM syscall wrappers fo=
r pthread_{cancel,join}() ---
commit 26558313a1f5853d420a8a8544d24882f9b4835b
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Add KVM syscall wrappers for pthread_{cancel,join}()

This commit adds and uses wrappers for pthread_cancel() and pthread_join()
across KVM selftests. The wrappers aim to automatically assert on failure,
removing the need for manual assertions in the test code.

> diff --git a/tools/testing/selftests/kvm/include/kvm_syscalls.h b/tools/t=
esting/selftests/kvm/include/kvm_syscalls.h
> index e75be83787798..d6c18e13b9c8b 100644
> --- a/tools/testing/selftests/kvm/include/kvm_syscalls.h
> +++ b/tools/testing/selftests/kvm/include/kvm_syscalls.h
> @@ -101,6 +101,8 @@ __KVM_SYSCALL_DEFINE(sched_setaffinity, 3, pid_t, pid=
, size_t, cpusetsize, cpu_s
>  typedef void *(*pthread_fn_t)(void *);
>  __KVM_SYSCALL_DEFINE(pthread_create, 4, pthread_t *, thread,
>  		     const pthread_attr_t *, attr, pthread_fn_t, fn, void *, arg);
> +__KVM_SYSCALL_DEFINE(pthread_join, 2, pthread_t, thread, void **, thread=
_return);
> +__KVM_SYSCALL_DEFINE(pthread_cancel, 1, pthread_t, thread);

[Severity: Medium]
Will this generate misleading error messages if the thread functions fail?

The pthread_join() and pthread_cancel() functions return their error codes
directly rather than setting errno. If the __KVM_SYSCALL_DEFINE macro
uses errno for its error reporting, it could log an unrelated error
string instead of the actual failure reason.

> =20
>  #define kvm_free_fd(fd)		\
>  do {				\

[ ... ]

> diff --git a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c b/tools/te=
sting/selftests/kvm/x86/xen_shinfo_test.c
> index 20f518fe24506..3ec5e67b21efa 100644
> --- a/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
> +++ b/tools/testing/selftests/kvm/x86/xen_shinfo_test.c
> @@ -948,11 +947,8 @@ int main(int argc, char *argv[])
>  				TEST_ASSERT(!evtchn_irq_expected,
>  					    "Expected event channel IRQ but it didn't happen");
> =20
> -				ret =3D pthread_cancel(thread);
> -				TEST_ASSERT(ret =3D=3D 0, "pthread_cancel() failed: %s", strerror(re=
t));
> -
> -				ret =3D pthread_join(thread, 0);
> -				TEST_ASSERT(ret =3D=3D 0, "pthread_join() failed: %s", strerror(ret)=
);
> +				kvm_pthread_cancel(thread);
> +				kvm_pthread_join(thread, 0);

[Severity: Medium]
Does this change replace an accurate error message with a potentially
misleading one?

The original code correctly used strerror(ret) because these functions
return the error code directly. If the new wrappers rely on errno, they
might print an unrelated error string when these functions fail.

>  				goto done;
> =20
>  			case TEST_GUEST_SAW_IRQ:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731195612.2697=
986-1-seanjc@google.com?part=3D9
