Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745D93B47D0;
	Fri,  2 Oct 2026 09:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932429; cv=none; b=N/NiWjJgZ9ic0oEeqeR68Nnu3qQTJvHkFq1vJuPO/wsVYk/UH3sRfIh4w6M0+9hifeE5IrVEZO0vq8HH/YTYekJsInjfZHAa4L5xbERLpFhHZfRUbrlg0TSC7YD9b/3McikiXjadHgBF6HlYzyaeRKOP6o/V3U/9Pcpz9m0279g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932429; c=relaxed/simple;
	bh=u+6y/sHA9bEwoLN/XVzbQULKtLo/nmjfs/1bU8x07Yg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CbGateDb7bh7qwdyNEObaeb1zjO/6UfwvfEPc8ggcxiODhqYsT8KqZbA0YQFF2WEVeLYEIj9o0dlzDc4SLSS23uqdyVpiPU67CNOv0v5MNs8vWcvELnxIZM5I1waY94LoIyi0MFrCL9125ANQcJJzj6yp5VOW2EnRKwLkK8CG6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Phjx1Hkj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Phjx1Hkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1769C1F00899;
	Fri,  2 Oct 2026 09:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932428;
	bh=Lh9A+TR4VoPNddgYfrzpdItXq1VCAZ0FpSq357jHMJY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Phjx1HkjgaXSK6khRltoBmAvuY0TTKFa5ig1tiYEfKettPGs5uZQ1n9DRPUK3RTwQ
	 c69gfijKhArlaLG3+tyscG7Btz9kY13BBfGaWJ5jhON9VI+OJS2QShOwHuhCdXIbhd
	 qi3l5eW3/hdkCWFsG33qBByOI9pWqTNBOeC5TvWwc/WGKRMaEZaLW3BtzS6i7Qfd/w
	 yAmILpOt96qFAh3wp2R4KbXKuETb8qv1vMAqzPO90/qLlv54gRgrxRjyGXnKfPJx/u
	 KyOcc9dENGVeNlA6p9IyR+LWHWDDDiNuKDC3xdiojtXwRWOVBdX37HxgF1SkTJlzJC
	 1bINf3lPp8Jew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v21 18/23] KVM: arm64: CCA: Don't expose unsupported
 capabilities for realm guests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261001210703.1597150-19-suzuki.poulose@arm.com>
References: <20261001210703.1597150-1-suzuki.poulose@arm.com>
 <20261001210703.1597150-19-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:47 +0000
Message-Id: <20261002091348.1769C1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] arm64: kvm: KVM_CAP_IRQCHIP incorrectly exposed for Realm VMs
--

commit af0bceb4971b2a4c5816fbca6500c4f10a51388d
Author: Suzuki K Poulose <suzuki.poulose@arm.com>

KVM: arm64: CCA: Don't expose unsupported capabilities for realm guests

This commit limits the capabilities that are allowed for Realm VMs and bloc=
ks
the corresponding vm_ioctls. It repurposes kvm_pkvm_ioctl_allowed() to
support both pKVM and Realm ioctls and adds a generic kvm_vm_ext_allowed()
helper for filtering.

> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kv=
m_rmi.h
> index 44f5c75a27b5b..ea1450e0c8619 100644
> --- a/arch/arm64/include/asm/kvm_rmi.h
> +++ b/arch/arm64/include/asm/kvm_rmi.h
[ ... ]
> @@ -58,4 +60,26 @@ struct realm {
> =20
>  void kvm_init_rmi(void);
> =20
> +static inline bool kvm_realm_ext_allowed(long ext)
> +{
> +	switch (ext) {
> +	case KVM_CAP_IRQCHIP:

[Severity: Medium]
The commit message states "Drop KVM_CAP_CREATE_IRQCHIP, as we don't support
VGIC_V2 for Realms". Did you intend to drop KVM_CAP_IRQCHIP from this
allowlist?

Because KVM_CAP_IRQCHIP is still explicitly allowed here in
kvm_realm_ext_allowed(), userspace is falsely advertised VGIC_V2 capability
via KVM_CHECK_EXTENSION.

This also allows the KVM_CREATE_IRQCHIP ioctl to bypass the
kvm_vm_ioctl_allowed() check in kvm_arch_vm_ioctl() and attempt to
instantiate an unsupported VGIC_V2 before being rejected downstream.

> +	case KVM_CAP_ARM_PSCI:
> +	case KVM_CAP_ARM_PSCI_0_2:
> +	case KVM_CAP_DEVICE_CTRL:
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001210703.1597=
150-1-suzuki.poulose@arm.com?part=3D18
