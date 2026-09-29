Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709BB4FECEA;
	Tue, 29 Sep 2026 11:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790680001; cv=none; b=ZGFxzJSdvwlFVPT2JmVrfqpbCK0x6kFZGBaDQiFXntJ3ZoHSHrci/x2C8QFJHA1DAxj6sdqPt0VUQBgbB7zDyEc2JZDc7PdZJfNm0upIHQJfpfT1iwLvBAB54sX5yyex6X29l2q1mN+G8JCJ2Vr0r1JnQa6ISryccHJR/YsoHMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790680001; c=relaxed/simple;
	bh=xo99Uqbz4winsFycjLoBbZOBDB4IgEKD6IeoGvlzROY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JqkxsfMjbOe59hxRmN75KtA3Sm5UB4FJwb+3LcJNZNoWcWABN7M+W0Uzm2fZ3oX7RrPnTJ/HaVaQ4YNRVdVopV8etCNmpJeB7BWgZLP+U2Fj3bE2btN0c21unhtLZXlv6e//nD0amK+XkhuCAJxlrlQLA8I2xmGROIt7hFH01xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jd/PVxO5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jd/PVxO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19171F000FF;
	Tue, 29 Sep 2026 11:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790679999;
	bh=x7xpjkH/+Y+E+QqPl1IPWhcctgJIBF+u5LKGMwCv304=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jd/PVxO5dqtpJiY3lOtt8/Ab+ilruJ1HYAdbGUAXJEy1uKN/InG4JO74wuuQPe+SY
	 mecC//sqaow0SOSto48WK9Y9r1Sq0lOUHv8AL9CwsLUbSxnyJmM6Kft1J83PUiKdsH
	 EfUwIkA6s46sf558388Ylo6G1COgFwvOktPsnpta0kG/q6VkC9rANjlHgH+FTnnBf1
	 Io5HibFONgzqm5Tv6Bk40aYG1ariGxIzL6SugmOhMuZSx6AfjeLAzRKgBO6WE8qKGR
	 1jZzfHeIN6ZyoBkdbXfQihj4yJ4dpEFjVUMDfpjKeGHjO/IYUHP6HS5fRPE6Q4d9Ry
	 ZgPcaFiIbO+MA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 14/15] KVM: arm64: Document HDBSS buffer size ioctl
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tian Zheng" <zhengtian10@huawei.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260929103655.85107-15-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-15-zhengtian10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 11:06:38 +0000
Message-Id: <20260929110638.D19171F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] kvm: arm64: missing vCPU kick in kvm_arch_update_hw_dirty_mode=
 causes data corruption
- [High] kvm: arm64: stage2_wrprotect_walker clobbers concurrent hardware P=
TE updates
- [Medium] kvm: uapi: enabling dirty ring silently resets HDBSS buffer size
- [Low] kvm: uapi: KVM_CHECK_EXTENSION misused to return mutable VM state
--

commit ad3d8df658768bdca959742e1b61e3dd3914fdd8
Author: Tian Zheng <zhengtian10@huawei.com>

KVM: arm64: Document HDBSS buffer size ioctl
   =20
Document KVM_CAP_ARM_HDBSS_BUFFER_SIZE, which lets userspace configure the
per-vCPU HDBSS buffer size for hardware-assisted dirty tracking during live
migration.

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -9056,6 +9056,34 @@ enabled, cmma can't be enabled anymore and pfmfi a=
nd the storage key
>  interpretation are disabled. If cmma has already been enabled or the
>  hpage_2g module parameter is not set to 1, -EINVAL is returned.
> =20
> +7.48 KVM_CAP_ARM_HDBSS_BUFFER_SIZE
> +-----------------------------------
> +
> +:Architectures: arm64
> +:Target: VM
> +:Parameters: args[0] is the per-vCPU HDBSS buffer size in bytes
> +:Returns: 0 on success; -EINVAL if the size is invalid or vCPUs have alr=
eady
> +          been created; -EBUSY if the buffer size was already configured.
> +
> +This capability configures the per-vCPU HDBSS buffer size used for
> +hardware-assisted dirty tracking during live migration.
> +
> +Userspace sets the size in bytes via KVM_ENABLE_CAP. KVM allocates
> +per-vCPU HDBSS buffers of the requested size.
> +
> +KVM_CHECK_EXTENSION returns the maximum supported size (``SZ_2M``)
> +when queried without a VM, or the configured per-VM size (default
> +``PAGE_SIZE``) when queried with a VM.

[Severity: Low]
KVM_CHECK_EXTENSION is designed to advertise static feature support and
limits, not to serve as a GET interface for mutable, dynamically configured
VM attributes.

Would it be better to use a dedicated interface to read back this dynamic
state instead of KVM_CHECK_EXTENSION?

> +
> +Constraints:
> +
> +- The size must be a power of two in [``PAGE_SIZE``, ``SZ_2M``].
> +- Dirty-bitmap mode only: rejected with -EINVAL once the dirty ring
> +  (``KVM_CAP_DIRTY_LOG_RING``) is enabled, and enabling the ring after
> +  a size was set resets it to the default.

[Severity: Medium]
The KVM guidelines mandate that new memslot and vCPU flags default to
immutable.=20

Instead of silently mutating previously configured state (which can lead to
unpredictable state-machine transitions that userspace is not prepared
for), should this incompatible capability configuration fail explicitly by
returning an error like -EINVAL?

> +- Must be set before any vCPU is created; a second setting is rejected
> +  with -EBUSY.
> =20
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c

[ ... ]

> @@ -1285,12 +1298,47 @@ static int stage2_update_leaf_attrs(struct kvm_pg=
table *pgt, u64 addr,
>  	return 0;
>  }
> =20
> +static int stage2_wrprotect_walker(const struct kvm_pgtable_visit_ctx *c=
tx,
> +				   enum kvm_pgtable_walk_flags visit)
> +{
> +	kvm_pte_t new =3D ctx->old & ~KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +
> +	/* We remove DBM on blocks so they can fault and get split */
> +	if (ctx->level < KVM_PGTABLE_LAST_LEVEL)
> +		new &=3D ~KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> +
> +	if (kvm_pte_valid(ctx->old) && ctx->old !=3D new &&
> +	    (ctx->old & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W) &&
> +	    ctx->mm_ops->mark_page_dirty)
> +		ctx->mm_ops->mark_page_dirty(kvm_pte_to_phys(ctx->old));
> +
> +	/*
> +	 * The plain WRITE_ONCE races with hardware updates; both are
> +	 * benign.
> +	 *
> +	 * AF: the update may be lost, and is set on the next access.
> +	 *
> +	 * Dirty state: we only rewrite entries whose old value had S2AP[1]
> +	 * set, while hardware only promotes entries with S2AP[1] clear, so
> +	 * the two never touch the same entry. The one overlap is DBM removal
> +	 * on writable-clean blocks: a racing promotion is demoted back to
> +	 * read-only, but the write is still recorded in the HDBSS buffer and
> +	 * the folio was marked dirty at fault-in, so nothing is lost.
> +	 */
> +	if (kvm_pte_valid(ctx->old) && ctx->old !=3D new)
> +		WRITE_ONCE(*ctx->ptep, new);

[Severity: High]
The global review guidelines strictly mandate: When KVM updates SPTE bits t=
hat
the hardware page-table walker also writes (Dirty/Access on leaf entries), =
the
update must not clobber a concurrent hardware update.

Since WRITE_ONCE unconditionally overwrites the PTE with the old masked
value, could this non-atomic write in stage2_wrprotect_walker() clobber
concurrent hardware updates to the Access Flag (AF) or Dirty Bit on leaf
PTEs?

> +
> +	return 0;
> +}
> +
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c

[ ... ]

> @@ -2581,6 +2629,45 @@ int __init kvm_mmu_init(u32 hyp_va_bits)
>  	return err;
>  }
> =20
> +/*
> + * The VM's hardware dirty-management mode is a derived value, a pure
> + * function of the static capabilities and the number of logging
> + * memslots, so recomputing it on every event cannot lose an update
> + * and needs no locking against racing writers:
> + *
> + *   logging && HDBSS-capable  ->  HD|HA|HDBSS (hardware tracking)
> + *   logging, no HDBSS         ->  off (write-protect faults)
> + *   !logging && HAFDBS-cap.   ->  HD|HA (only written pages go dirty)
> + */
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
> +
> +	cur =3D kvm->arch.mmu.vtcr & (VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBS=
S);
> +	if (cur =3D=3D target)
> +		return;
> +
> +	kvm->arch.mmu.vtcr =3D (kvm->arch.mmu.vtcr &
> +			      ~(VTCR_EL2_HD | VTCR_EL2_HA | VTCR_EL2_HDBSS)) |
> +			     target;
> +
> +	kvm_make_all_cpus_request(kvm, KVM_REQ_RELOAD_STAGE2);
> +
> +	/*
> +	 * The request only reloads VTCR_EL2; cached translations keep
> +	 * the old permissions until invalidated.
> +	 */
> +	kvm_flush_remote_tlbs(kvm);

[Severity: Critical]
Inside kvm_arch_update_hw_dirty_mode(), kvm_make_all_cpus_request() is issu=
ed
with KVM_REQ_RELOAD_STAGE2, which is defined as:

#define KVM_REQ_RELOAD_STAGE2 \
	KVM_ARCH_REQ_FLAGS(12, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)

The KVM_REQUEST_NO_WAKEUP flag prevents the request from interrupting runni=
ng
vCPUs. The subsequent kvm_flush_remote_tlbs() executes a hardware broadcast=
 TLBI
and also does not send IPIs.=20

Because running vCPUs are never kicked out of guest mode, won't they
continue executing with their physical VTCR_EL2 register holding the
stale state (HD=3D1)?

If software dirty logging is active but HDBSS is not correctly synchronized
on the CPU, the hardware page table walker could silently promote
writable-clean PTEs to writable-dirty without trapping. Since KVM never
sees the write, could this cause silent data loss during live migration?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260929103655.8510=
7-1-zhengtian10@huawei.com?part=3D14
