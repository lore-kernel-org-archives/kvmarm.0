Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11197149C6F;
	Fri, 26 Jun 2026 21:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782510250; cv=none; b=bXP8seflD37Vkz5FvjRHwg1jnWtr941sVdHHOdHrA5PVuOyqjuMt/gAxcb8pHCrxfwI+VG0CRY5cpb78okY44rhzcogyE4tYhs+Dqkgtznsb1hn0PCYMv20UQL9oJJjpNl/DPV+gv94WTIA5s5YKJO8YRDHn//fxFTSYPa0spsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782510250; c=relaxed/simple;
	bh=fkgk6kTXgkW0J8FpjxZiqSzT1HvzM8QdDEDgho5sgDM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TfLFU5EXhxaLC7w9MmpXdmB6UsrcCoOJU1Rv7ee1D7c0XtRW44c6/SbBP9YloD0UEs6RbVabW78wE8J8BAlSX2ldYTRR8N5Ix/Ye0OzMyycVeROqka8w+omTiPIYiH1D7BqYHSRUrITl9kKQ3C7KcSjs5VG0cThv84/7QFJGhr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lW/cPbOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lW/cPbOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370E01F000E9;
	Fri, 26 Jun 2026 21:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782510248;
	bh=xYd53HsDuusi1nLJxxqqcbrQuItKKQC97tAzWhJQcaM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lW/cPbOLxnZRx4SNd2WEOFiQ4z+tIv8MWsCwnZrHtW03hhUTzG2knSX8RRjxDeUED
	 K8/6a/DLoxI+2TDQFwSYw9YTlhnnJURu+B3Ycga/UwdJgOfKngRL2pj2QlmQ4xDTNB
	 VtwnEa/traF+vy8I9qsP+fbCAbUOR0MiX+6DILf7KUVm1bzrP6kA7QNkBny3VrcAMo
	 SbIdtUBhTJywdJ3sw93aLdeWEBU7LiKzurjYH1Eve2I7VIiD9BFaEFyKy6Xdu2+UB1
	 UmXyEIqdnavZWMCRJf+pYhtDc9jyOK8OU/gCisXKjkssU/UWAG2BaS4c9WgVKmSqiX
	 IrwsK/koFTRow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 01/20] KVM: selftests: Build and link
 selftests/vfio/lib into KVM selftests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260626213534.3866178-2-seanjc@google.com>
References: <20260626213534.3866178-1-seanjc@google.com>
 <20260626213534.3866178-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 21:44:07 +0000
Message-Id: <20260626214408.370E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The use of `dirname` with multiple arguments in `libvfio.mk` is a G=
NU-ism that breaks the build on POSIX/BSD systems.
--

commit 070d3095b74eed8d9c8207b3141eb0bb2449cb39
Author: David Matlack <dmatlack@google.com>

KVM: selftests: Build and link selftests/vfio/lib into KVM selftests

This commit includes libvfio.mk into the KVM selftests Makefile and links it
into all KVM selftests by adding it to LIBKVM_OBJS. This lays the groundwork
for future changes to utilize VFIO devices to verify IRQ bypass in KVM
selftests.

> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/sel=
ftests/kvm/Makefile.kvm
> index 4ace12606e937..ae0dfd67dd31e 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -259,6 +259,7 @@ OVERRIDE_TARGETS =3D 1
>  # which causes the environment variable to override the makefile).
>  include ../lib.mk
>  include ../cgroup/lib/libcgroup.mk
> +include ../vfio/lib/libvfio.mk

[Severity: Low]
Does including libvfio.mk here break the build for KVM selftests on
environments with a non-GNU dirname?

Looking at tools/testing/selftests/vfio/lib/libvfio.mk, it contains:

    LIBVFIO_O_DIRS :=3D $(shell dirname $(LIBVFIO_O) | uniq)

Passing multiple arguments to dirname is a GNU extension. On POSIX or BSD
systems, this command fails and returns an empty string. The subsequent mkd=
ir
command then fails to create the required output directories, which causes =
the
compiler to fail with a "No such file or directory" error when attempting to
write the libvfio object files.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626213534.3866=
178-1-seanjc@google.com?part=3D1
