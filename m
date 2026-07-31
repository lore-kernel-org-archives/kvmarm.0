Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544104499B8;
	Fri, 31 Jul 2026 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785518290; cv=none; b=BXJVyiREhRKPSj7AATsbxVikzgaQN9rhY5Oco5BoB0LaL8nrWBH3860nFINv98U1CP42ANMUxujcVOGKDGYj7ki6XFRZSf8jCB6uluJG34jbMuC9QuiSiifdzXbWGXLjHQnhK5az3TZCCnJ1hNALDlsWBvb8AMpfCE4RyxbuiOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785518290; c=relaxed/simple;
	bh=08s9E6ka3dFOAJcXYZ5mzc7bo8l76a3hNsjYgpcE6Yc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CzkT2s+7qfuGL/OtZtJVuHyKfY1RTOIikCAL+oeDG57c5qizBM2qxXHTWvWgg2XSym9Zk9xKE8gb6DdMHuoLxOzr+gnDFqgPcR1rAO3JKJQlQg/JJdckDWMB2z8mA6Lszm0+EnuCMrtrzNAkhwTXNvOAR1QfELu057CrO9/F3Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkfUQsVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkfUQsVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51731F00AC4;
	Fri, 31 Jul 2026 17:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785518289;
	bh=BFR3+HDgiAMrK9bfd6XM2NF4MmQluEWmZ+rtRVJs8Jo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GkfUQsVDCcteWJ/BrkoxeP8h51GMQnIG0CF/u+FcT0cvVQ0AGig09Fk4LkWfa6DK9
	 aaHDpJ+arWkF/pT9ZOv0MspUOSXy4g6DijfAjNrD+0ScsaQCvtzaXSu09lcIYhagPn
	 QYmorE6/0A3+X+mzOYsMoyArqEMd4xa4SV1R6q9jHMu7WBqr6IneI5BXNW8O7CiTLo
	 0dnLBLvZHcNPmw/v3PsPHUOze4lB/0FQgDS+XfS9FbqScaJTjq/EWlsxy8HxzGc8oi
	 nJDWhhD0YmC+VgCIkZPGR3dYMYT0CMHgbjEw+LWs2cnw01EKgHXV4ZID/Je+rBeR1P
	 jyzT7o98LI0vg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/12] KVM: selftests: Add KVM syscall wrappers for
 pthread_{cancel,join}()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260731170619.2620845-10-seanjc@google.com>
References: <20260731170619.2620845-1-seanjc@google.com>
 <20260731170619.2620845-10-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 17:18:08 +0000
Message-Id: <20260731171808.A51731F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `kvm_pthread_join` and `kvm_pthread_cancel` wrappers are def=
ined using the `__KVM_SYSCALL_DEFINE` macro, which incorrectly assumes the =
wrapped function sets the thread-local `errno` variable on failure.
--

--- Patch [9]: [PATCH v2 09/12] KVM: selftests: Add KVM syscall wrappers fo=
r pthread_{cancel,join}() ---
commit b9978e67ef4ca95fc0d3b87b0d80bdb48e623a21
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Add KVM syscall wrappers for pthread_{cancel,join}()

This commit adds kvm_pthread_join() and kvm_pthread_cancel() wrappers to
KVM selftests. These wrappers automatically assert that the underlying pthr=
ead
functions succeed, removing the need for manual error checking across multi=
ple
tests.

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
Will this produce misleading error messages on test failures?

Pthread functions like pthread_join and pthread_cancel return their error
codes directly and do not set the thread-local errno variable.

Since these wrappers use the __KVM_SYSCALL_DEFINE macro, if the underlying
pthread function fails, the __KVM_SYSCALL_ERROR macro will format the
error message using the stale errno instead of the returned error code. This
could result in test assertions printing an incorrect errno (e.g., "Success=
")
rather than the actual error string.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731170619.2620=
845-1-seanjc@google.com?part=3D9
