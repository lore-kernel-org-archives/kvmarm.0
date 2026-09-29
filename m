Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10453511E74;
	Tue, 29 Sep 2026 11:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790680567; cv=none; b=kIo3gsHket1sCtutm/chJH3eMBc0rJpyrNBxe2eadvTAvIU8UAQMwqHYGqNoa+yPlSlxoJtrIrpg4Jcn5IY7AszPJ1HMOS9jTAIMS6XZR3DNrgriKWxmqH9xQtsSZa9RCgNWJnGAahinGm8GHj7RjNQvG6nBKTj3jnwlpxlkw2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790680567; c=relaxed/simple;
	bh=RV0bhJW2us+98cweSRFVKECxHzm6KMNb9KdqLyhyFBc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C5P49Y0qrdAORvqEA8nKD7l2fbmHnF2NHB/xwCgdLgzHKfq86XUHfpc7D60BSFDGvRa0liPeOgpL1vN4l8m/qWOKHwH8c+SoucwPTDM1HdvusJ8wKYdRh/fa6vX1mXiZWQZvjgB6rjC0/NYrBLWYWwC9r7//f/qEBU9vNpoC078=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYC7ELLL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYC7ELLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB631F000FF;
	Tue, 29 Sep 2026 11:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790680565;
	bh=hLQQHpj5OPL70Y0eDLsN5RWwrKnhhiwuBNH0fwhz5G8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QYC7ELLLU9dNvIpOnuL5CKuQdup3l6PjCPO6epRqlIvQaTUA8YVVFCv1EK1RTJxrL
	 qzX6TKR4tDR7ia2vBGEg4F5QaBeiek+bYRux3lKAvHm46wEpypcSIEwANAi9voiGaG
	 lvjy8NsNjqG/Aqe1Gk+s7o3Ew9Q9Mgs1eOlr2BUM/uYJAVpmBbw3EEfpnlbttZjcyq
	 8pXJYgmOWMXcUq4cJgDvt8/XYtAxA+/go/XPRYR1CyQKj3U/WYjRS++H9liNaUni9B
	 eJJjz2k7jKMNcuRkxEHCklMLynH+ni8Ak8C7mtqFSkvay/vfEcNDY191PRMQBZixmR
	 YmQlPQxLJmHuQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 12/15] KVM: arm64: Derive the VM hardware dirty mode
 from dirty logging
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260929103655.85107-13-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-13-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 11:16:04 +0000
Message-Id: <20260929111605.4EB631F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] KVM: arm64: Host kernel panic on nVHE via KVM_REQ_RELOAD_STAGE2
- [High] KVM: arm64: HDBSS erroneously enabled for nested VMs
- [High] KVM: arm64: Ampere AC03 CPU 38 hardware erratum mitigation bypass
- [Medium] KVM: arm64: Data race on kvm->arch.mmu.vtcr
--

commit 44b8e43689e1fc16603d982a85e0902b833fcf7d
Author: Tian Zheng <zhengtian10@huawei.com>
Subject: KVM: arm64: Derive the VM hardware dirty mode from dirty logging

Both HAFDBS and HDBSS flip VTCR_EL2.HD at memslot-update time. Two
independent toggles allow an intermediate HDBSS-set/HD-clear state,
an illegal combination, and need locking against concurrent updates.

Replace both with kvm_arch_update_hw_dirty_mode(), a pure function
of the static capabilities and the number of logging memslots.

Link: https://lore.kernel.org/all/20260901171558.2674031-6-leo.bras@arm.com/

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kv=
m_mmu.h
> index 6eae7e7e2a684..24407194444af 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
[ ... ]
> @@ -390,6 +390,24 @@ static inline bool kvm_supports_cacheable_pfnmap(voi=
d)
>  	       cpus_have_final_cap(ARM64_HAS_CACHE_DIC);
>  }
> =20
> +static inline bool kvm_supports_hafdbs(void)
> +{
> +	return IS_ENABLED(CONFIG_ARM64_HW_AFDBM) && has_vhe() &&
> +		cpus_have_final_cap(ARM64_HW_DBM);
> +}
> +
> +static inline bool kvm_supports_hdbss(struct kvm *kvm)
> +{
> +	return system_supports_hdbss() && !kvm_has_nv(kvm);
> +}

[Severity: High]
Does this check reliably gate nested virtualization features if a memslot is
created before vCPUs are initialized?

If userspace creates a memslot with dirty logging prior to initializing
vCPUs, kvm_has_nv() evaluates to false because KVM_ARM_VCPU_HAS_EL2 is not
yet set. This causes HDBSS to be erroneously enabled.

When vCPUs are subsequently initialized, the dirty mode is never
re-evaluated, leaving HDBSS active for the nested VM. This bypasses the
safety gates and can lead to host panics or data corruption.

> +
> +void kvm_arch_update_hw_dirty_mode(struct kvm *kvm);
> +
> +static inline bool kvm_hw_dirty_enabled(struct kvm_s2_mmu *mmu)
> +{
> +	return mmu->vtcr & VTCR_EL2_HD;
> +}
> +
>  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>  void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
>  void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c1e09ba98d48a..17786453c0044 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> +void kvm_arch_update_hw_dirty_mode(struct kvm *kvm)
> +{
> +	unsigned long cur, target;
> +	bool logging =3D atomic_read(&kvm->nr_memslots_dirty_logging) !=3D 0;
> +
> +	if (logging && kvm_supports_hdbss(kvm))
> +		target =3D VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS;
> +	else if (logging || !kvm_supports_hafdbs())
> +		target =3D 0;
> +	else
> +		target =3D VTCR_EL2_HD | VTCR_EL2_HA;

[Severity: High]
Does this bypass the Ampere AC03 CPU 38 hardware erratum mitigation?

kvm_get_vtcr() correctly masks out VTCR_EL2_HA if the erratum is present.
However, this code unconditionally sets VTCR_EL2_HA when
kvm_supports_hafdbs() is true.

Since the erratum does not remove ARM64_HW_DBM support,
kvm_supports_hafdbs() returns true, and this update unconditionally
overwrites the mitigation on any memslot update.

> +
> +	cur =3D kvm->arch.mmu.vtcr & (VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBS=
S);
> +	if (cur =3D=3D target)
> +		return;
> +
> +	kvm->arch.mmu.vtcr =3D (kvm->arch.mmu.vtcr &
> +			      ~(VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS)) |
> +			     target;

[Severity: Medium]
Can this plain read-modify-write of kvm->arch.mmu.vtcr cause a data race?

This update is performed under slots_lock, but concurrent page faults
locklessly read this value via kvm_hw_dirty_enabled(). This plain C
assignment violates the Linux Kernel Memory Model and could lead to
load/store tearing and corrupted hardware state.

> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_STAGE2);

[Severity: Critical]
Will this KVM_REQ_RELOAD_STAGE2 request cause a host kernel panic on an
nVHE system?

When this request is handled by check_vcpu_requests() at EL1 on an nVHE
host, it invokes __load_stage2(), which attempts to write directly to
vtcr_el2. Because vtcr_el2 is an EL2-only register, this will trigger an
Undefined Instruction exception and crash the host kernel.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929103655.8510=
7-1-zhengtian10@huawei.com?part=3D12
