Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8B241DEF1
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 18:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783361650; cv=none; b=ElInY2cnmP8wR7KAMft9YmGZKte5NKPHfC2TXV5YRC77cxL+QWqOIohBdrkdR5yfJL4akCRCCBDLSxVu8KeR5VmtbcfQ8Pao3l0YgFzEfjC/WqsFcHN2olOQrNGexIZLvPBmENOKNBeW9m+pNxu8xKrmz6yyKbY8nsxdaKN3KGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783361650; c=relaxed/simple;
	bh=N53I5quFZGz2+xCxOYhkfae3NqjfsaUOhOCJcY6i6rc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uJXlpceKGziNBMH+pzl05qKxiIxJjRI0BNBNkrD09Z3xyfaaJvlzeXCqkRZtE2x52qxDpWCUPidHIAPf3I3Uo2cD4ixFBtrbLuYc5ghdNk9UknmONqpkumBAIdTF3ZBCGawKv582ukkGah3GvebAtZ7XtVlw0kUm+sycEWCuRT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6e7D6Dc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6e7D6Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E14F1F000E9;
	Mon,  6 Jul 2026 18:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783361649;
	bh=k+oqKwE/Rf4wbieDV0YvXZ1GAbJ9IyIevo80flCEwVE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n6e7D6Dc93GM20nsUFZmrJVTq+0ZkIVcy0mtkgM8ohwQZ4qiEtXL/kYS9vWaONV5a
	 Acq70RpIlUgEN68he67sen3V2hArAx4j58EE0Pg7ml1TWVDraCwL1RblFsH3IDMLJl
	 LAXROP53G1X2HWMhBBTZYubLb8jTJmrHCg0BNKnBi4Js8N8zbJHgD9yHUHqqe+dH5z
	 p2+FXOV52s65CioZP0r093T/9xzOfjuaVRrRTei7fdARelPvLF3DN4oK6i0QKWAUjh
	 Nvz3AQg4/g5zkTT2CFH/AOGpEpDjbZyeqxd0GnV41aCPcoy2vhgmdT5YZqEH/eSuUL
	 Gix85SOoKLg7w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/18] KVM: arm64: Add topup interface for the pKVM
 heap allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260706175415.2604046-7-vdonnefort@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-7-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 18:14:08 +0000
Message-Id: <20260706181409.0E14F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] Unused static function `pkvm_hyp_topup` causes build failure.

Pre-existing issues:
- [High] `__pkvm_host_donate_hyp()` handles allocator failures with `WARN_O=
N()`, allowing userspace to trivially panic the hypervisor on memory exhaus=
tion.
--

commit ed5697a7fc612043a616e5de99f36c231db3d5dd
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Add topup interface for the pKVM heap allocator

Introduce a host HVC interface and a host side helper to allow refilling
the pKVM heap allocator.

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8324a6a1bc48b..e2c8714e8ccc0 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
[ ... ]
> @@ -85,6 +85,33 @@ void __init kvm_hyp_reserve(void)
>  		 hyp_mem_base);
>  }
> =20
> +static int pkvm_hyp_topup(enum pkvm_topup_id id, unsigned long nr_pages)
> +{
> +	struct kvm_hyp_memcache mc;
> +	struct arm_smccc_res res;

[Severity: Low]
Does this cause a build failure with CONFIG_WERROR=3Dy?

This static function is added here but doesn't appear to be called anywhere
in this patch, which usually triggers a -Wunused-function warning. While it
may be used in a subsequent patch in the series, each patch should compile
independently to preserve git bisectability.

[Severity: High]
This is a pre-existing issue, but can host userspace crash the hypervisor
by exhausting EL2 memory?

In arch/arm64/kvm/hyp/nvhe/mem_protect.c:__pkvm_host_donate_hyp():

    WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP));
    WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HYP));

At EL2 in nVHE/pKVM, WARN_ON() expands to BRK and panics the hypervisor. If
pkvm_create_mappings_locked() requires a new page table level and the EL2
buddy allocator is exhausted, it returns -ENOMEM.=20

By wrapping this in WARN_ON(), a fallible allocator outcome is transformed
into a fatal EL2 panic. This allows host userspace to trivially panic the
host kernel by exhausting EL2 memory, such as by creating numerous VMs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706175415.2604=
046-1-vdonnefort@google.com?part=3D6
