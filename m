Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F4C3E3DB8;
	Thu,  9 Jul 2026 11:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783595739; cv=none; b=e/BOodMTfwqQmlA1PdRPmi3Rdij48EGM8eimNEKRAbgDXYaTHapScPKZSKQzuhCChtn4v5fPvUcRxDy2OmKuGcSmnAY2gK4oiBMFJzhIg1XM6nDth6N6leqUHLB9Wtea6c/gtKP474x4GbH5VCKiKSxxMDmMcIa8jpRZIEmX0gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783595739; c=relaxed/simple;
	bh=Xg63DGN8QQ/hdIZjSvRRhHnLj97wYdiYLd+ZhQU6p70=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pO/qBMSvgpMddw81JU42JKX1qqVEhYl1tgJtR++cjPMm0shu257d0ulUcwD4TFI2/rQzLQ4hNmWWi8EJtup6jdZZjMXWDPPFqSRqORcHhb5E/ANxzJBXnRnTswgHZTkw3BXXJZXfWlH9enUi6T1foExdkWWFS2m2i4WLu3yYyL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmygzzZq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmygzzZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEDD1F000E9;
	Thu,  9 Jul 2026 11:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783595738;
	bh=DeiyCDiwWO4N/BiU3nW4UwBd9LDm9aDpF7rPj85Ka+c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dmygzzZqZ/uGSh9jwJXl3ETwXWe8Zc4Ni70I61bwSksjCFSRGj3QSIoa9pXJ1TBav
	 f2bIGogY3ChY2CWHvYixvVpqV7kcydJ5dfJifKzPunKgMJdMStqW+cnSovjFB2MH/z
	 lCqUJfcVd3eovayyhxKFX/D/Hsd7Z/rh6b4XXIhcSzk2bD/SaaMDStHG18cgYGb5HS
	 fvtmVwLb7ghnExyyIpY/4LxFpMyLhVB4nZ+4i+JYq/gOQGWwLIQ1z/Tqm/WYs1Sd8b
	 H8ouyuRYjzWqGTfGfaApBneMLr9PhKc4Pk01IdHOg3/m5G1C/f5N/uwFvZhl4w8Uix
	 rAt1xOnhETJeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/6] KVM: arm64: Add HDBSS per-vCPU buffer management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org
In-Reply-To: <20260709104026.2612599-5-zhengtian10@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-5-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 09 Jul 2026 11:15:37 +0000
Message-Id: <20260709111538.0AEDD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] Broken error handling in `kvm_arch_vcpu_create` leads to success m=
asking and hypervisor memory leaks.
- [High] The hardware producer index `SYS_HDBSSPROD_EL2` is lost during vCP=
U context switch.
- [High] `__load_hdbss()` risks a fatal UNDEFINED exception on hardware lac=
king HDBSS.
- [High] Misinterpretation of the `order` parameter causes memory waste or =
buffer undersizing on non-4KB page granules.
- [Medium] Missing context synchronization event (ISB) after control-plane =
system register write.
- [Low] Memory leak when an allocation resolves to physical address 0.
--

--- Patch [4]: [PATCH v4 4/6] KVM: arm64: Add HDBSS per-vCPU buffer managem=
ent ---
commit 1967caa637e339cacc49eecff93c9e0e02ecad9e
Author: eillon <yezhenyu2@huawei.com>

KVM: arm64: Add HDBSS per-vCPU buffer management

This commit introduces the infrastructure for HDBSS (Hardware Dirty Bit Sta=
te
Structure) per-vCPU buffer management, including allocation, freeing, and
loading of HDBSS registers during vCPU load.

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -565,6 +566,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	err =3D kvm_share_hyp(vcpu, vcpu + 1);
>  	if (err)
>  		kvm_vgic_vcpu_destroy(vcpu);
> =20
> +	if (vcpu->kvm->arch.enable_hdbss) {
> +		err =3D kvm_arm_vcpu_alloc_hdbss(vcpu, vcpu->kvm->arch.hdbss_order);

[Severity: High]
Does this code mask kvm_share_hyp() failures? If kvm_share_hyp() fails, the
code falls through. If HDBSS is enabled and allocation succeeds, err is
overwritten to 0.

Additionally, if kvm_share_hyp() succeeds but kvm_arm_vcpu_alloc_hdbss() fa=
ils,
is the hypervisor mapping leaked since kvm_unshare_hyp() isn't called before
returning?

> +		if (err)
> +			kvm_vgic_vcpu_destroy(vcpu);
> +	}
> +
>  	return err;
>  }

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> --- /dev/null
> +++ b/arch/arm64/kvm/dirty_bit.c
[ ... ]
> +int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order)
> +{
> +	struct page *hdbss_pg =3D NULL;
> +
> +	if (vcpu->arch.hdbss.hdbssbr_el2 || !system_supports_hdbss())
> +		return 0;
> +
> +	if (order > HDBSS_MAX_ORDER)
> +		return -EINVAL;
> +
> +	hdbss_pg =3D alloc_pages(GFP_KERNEL_ACCOUNT, order);
> +	if (!hdbss_pg)
> +		return -ENOMEM;
> +
> +	vcpu->arch.hdbss =3D (struct vcpu_hdbss_state) {
> +		.base_phys =3D page_to_phys(hdbss_pg),
> +		.hdbssbr_el2 =3D HDBSSBR_EL2(page_to_phys(hdbss_pg), order),

[Severity: High]
Is the order parameter interpreted differently depending on the page granule
size? The order parameter is used both for alloc_pages() (which scales by
PAGE_SIZE) and HDBSSBR_EL2() (which expects an absolute hardware size).=20

On 64KB pages, supplying order=3D9 for a 2MB buffer would allocate 32MB fro=
m the
buddy allocator, while order=3D5 would configure the hardware for 128KB.

> +		.hdbssprod_el2 =3D 0,
> +	};
> +
> +	return 0;
> +}
> +
> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	struct page *hdbss_pg;
> +
> +	if (!vcpu->arch.hdbss.hdbssbr_el2) {
> +		return;
> +	}

[Severity: Low]
Could this leak the buffer if the buddy allocator returns physical address 0
and order is 0? The resulting HDBSSBR_EL2 value would be 0, causing this
early return to intercept a valid allocation.

> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/swi=
tch.c
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
[ ... ]
> @@ -213,6 +214,19 @@ static void __vcpu_put_deactivate_traps(struct kvm_v=
cpu *vcpu)
>  	local_irq_restore(flags);
>  }
> =20
> +static void __load_hdbss(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm =3D vcpu->kvm;
> +
> +	if (!kvm->arch.enable_hdbss)
> +		return;
> +
> +	write_sysreg_s(vcpu->arch.hdbss.hdbssbr_el2, SYS_HDBSSBR_EL2);

[Severity: High]
Will __load_hdbss() trigger a fatal UNDEFINED exception on hardware without
HDBSS? The function relies solely on kvm->arch.enable_hdbss. If it is enabl=
ed
but the hardware lacks support, accessing SYS_HDBSSBR_EL2 could panic the
hypervisor.

> +	write_sysreg_s(vcpu->arch.hdbss.hdbssprod_el2, SYS_HDBSSPROD_EL2);

[Severity: Medium]
Is an isb() required immediately after writing to SYS_HDBSSBR_EL2? ARM64
subsystem rules state that every write to a control-plane system register m=
ust
be followed by an isb() as the very next instruction.

> +
> +	isb();
> +}
> +
>  void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>  {
>  	host_data_ptr(host_ctxt)->__hyp_running_vcpu =3D vcpu;
> @@ -220,6 +234,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>  	__vcpu_load_switch_sysregs(vcpu);
>  	__vcpu_load_activate_traps(vcpu);
>  	__load_stage2(vcpu->arch.hw_mmu);
> +	__load_hdbss(vcpu);
>  }
> =20
>  void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
>  {
>  	__vcpu_put_deactivate_traps(vcpu);
>  	__vcpu_put_switch_sysregs(vcpu);
> =20
>  	host_data_ptr(host_ctxt)->__hyp_running_vcpu =3D NULL;
>  }

[Severity: High]
Are the hardware producer index updates lost during context switch?=20

The producer index is loaded in kvm_vcpu_load_vhe(), but it doesn't appear =
KVM
reads and saves it back to vcpu->arch.hdbss.hdbssprod_el2 during
kvm_vcpu_put_vhe(). Would this rewind the hardware index on the next load?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260709104026.2612=
599-1-zhengtian10@huawei.com?part=3D4
