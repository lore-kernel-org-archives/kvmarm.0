Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438A33F1ABF
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 15:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784301705; cv=none; b=MkvoLSkxZjUCUxMm9bli0rcF2U8ER4N0SoMSDOF3oPa51amb1b+XzgiQ+11LyOF/Sm5oSYBdu4BbznoBhGVQ5e5QOZnLmbuVYM20p5NWNMwyNiaQ2ohf+W+nAw8K8gVTUYXOwnQXchDJT9CxRSSYV2udnJzAqhuGnJOVHxIWrJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784301705; c=relaxed/simple;
	bh=hshQp5SW3TLdYcHxLEIRY0pDy1WP0fQxtmt0LEheZmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=OUgYvywVQ+0OHyS7uo9xDAp0jVZDtiWKHTC/1HVHL9SlkiGS9+0nqtgD6czFypc4x5nWezVpqhedTXfhYtTnNcujID04GGfOvP79Q3K9ZIAbQwlD+YNXfqop4nhnmIKEYLCkt7aAcjH4VoR1mmmSuI5aY5LKocwuADaytJaACxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eZ/BnOvi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eZ/BnOvi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B1981476;
	Fri, 17 Jul 2026 08:21:38 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C6333F905;
	Fri, 17 Jul 2026 08:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784301702; bh=hshQp5SW3TLdYcHxLEIRY0pDy1WP0fQxtmt0LEheZmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZ/BnOvi0wntk6aeCRcAnDUHvCjvHUZbPE/atxemoHCi7gQ3QqveUMZ6IQzHbnq8h
	 AWNLRiFpA8cwMYv+9hA7cxO1KDDJJfNQeQOtYOaCDWgpMGrpmByeNagX2E4QVxIyVl
	 JdXylIaq8Khx9l5zqMQuDywCEZuTxRMAV+JL/zOY=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v4 3/6] KVM: arm64: Add auto DBM support for hardware dirty tracking
Date: Fri, 17 Jul 2026 16:21:32 +0100
Message-ID: <alpIfIOFfrudBzD5@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <0943eb14-9ffb-4dbb-9219-060e97bca2a7@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-4-zhengtian10@huawei.com> <aliKo7dTZzKcWHzI@kernel.org> <0943eb14-9ffb-4dbb-9219-060e97bca2a7@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jul 17, 2026 at 11:58:06AM +0800, Tian Zheng wrote:
> 
> On 7/16/2026 3:39 PM, Oliver Upton wrote:
> > Hi Tian,
> > 
> > On Thu, Jul 09, 2026 at 06:40:23PM +0800, Tian Zheng wrote:
> > > -	if (prot & KVM_PGTABLE_PROT_W)
> > > +	if (prot & KVM_PGTABLE_PROT_W) {
> > >   		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > > 
> > > +		/*
> > > +		 * No DEVICE filter needed here: relax_perms is only called
> > > +		 * on FSC_PERM faults. Device pages always get full RW from
> > > +		 * initial mapping and are never write-protected during
> > > +		 * migration, so they never trigger a permission fault.
> > > +		 */
> > > +		if (pgt->flags & KVM_PGTABLE_S2_DBM)
> > > +			set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > > +	} else {
> > > +		/*
> > > +		 * Clear DBM on W→RO downgrade to prevent hardware from
> > > +		 * silently upgrading RO+DBM back to W+dirty, which would
> > > +		 * bypass KVM's write tracking and cause data corruption.
> > > +		 */
> > > +		clr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> > > +	}
> > > +
> > This block makes it pretty evident that the DBM bit really *is* the
> > write permission bit. I'd much rather we introduce the concept of dirty
> > state to the page table library and migrate the abstract write
> > permission to the DBM field, even if we don't have FEAT_HAFDBS.
> >

Ohh, that's an amazing idea!

 
> > That way everything 'just works' from outside the page-table library:
> > write-protecting hugepages would have the effect of clearing DBM and we
> > can separately reap dirty state from page descriptors.
> > 
> > If/when the architecture forces FEAT_S2PIE upon us we will need to make
> > this change anyway since dirty state management is unconditional and
> > handled separately from the actual permissions.
> >
> > Thanks,
> > Oliver
> 
> Hi Oliver,
> 
> Thanks again for your insightful review. Following your suggestion, I've
> 
> reworked the design around a unified three-state model that works regardless
> 
> of whether FEAT_HAFDBS is implemented:
> 
> **State table**
> State               | DBM    | S2AP[1] | Without HTTU            | With  HTTU  (HAFDBS)
> Non-writable   (N)  |  0     |    0    | write -> fault, inject  | write -> fault, inject
> Writable-clean (C)  |  1     |    0    | write -> fault, sw C->D | write -> hw C->D, no fault, HDBSS logs
> Writable-dirty (D)  |  1     |    1    | writable, no fault      | writable, no fault
> 

Yeah, that's how the table works with HAFDBS/HDBSS/HACDBS.

> **Proposed changes**
> 1. Remove KVM_PGTABLE_S2_DBM from enum kvm_pgtable_stage2_flags
> 
> — VTCR_EL2.{HD,HDBSS,HA} enablement in kvm_arm_enable_hdbss_global()
> 
> already keys off kvm->arch.enable_hdbss / system_supports_hdbss().
> 

We may need a system_support_hdbss() for the actual hdbss routines, though.


> 2. stage2_set_prot_attr() — set DBM unconditionally on writable pages:
> ```
> if (prot & KVM_PGTABLE_PROT_W) {
>     attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>     /* Writable-dirty: DBM=1 conveys write intent, S2AP[1]=1 marks dirty */
>     attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
> }
> ```
> 
> 3. kvm_pgtable_stage2_relax_perms() — drop the else branch entirely:
> ```
> if (prot & KVM_PGTABLE_PROT_W) {
>     set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
>     /* Non-writable -> Writable-dirty: restore both write intent and dirty state */
>     set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;

In the future, depending on the setup of HDBSS/splitting, we may want to 
change this behavior. But for software only, it looks nice. 

> }
> /* no else: callers passing !W (e.g. exec faults) must not touch DBM */
> ```
> 
> 4. kvm_pgtable_stage2_wrprotect() — unchanged: it only clears S2AP1 (D->C).
> 
> DBM is preserved so HDBSS re-arms next round.
>  ```
> int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64
> size)
> {
>    /* Writable-dirty -> Writable-clean: clear dirty state (S2AP_W),
>    * preserve write intent (DBM) so HDBSS re-arms for next write.
>     */
>     return stage2_update_leaf_attrs(pgt, addr, size, 0,
>                          KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
>                          NULL, NULL,
>                          KVM_PGTABLE_WALK_IGNORE_EAGAIN);
> }
> ```
> 
> **One clarification**
> In the three-state model above, wrprotect() clears S2AP[1] but preserves DBM
> (D->C).
> 
> This allows HDBSS to re-arm on the next write. If we instead cleared DBM as
> well (->N),
> 
> HDBSS would be permanently disabled on that page and we'd lose the benefit
> of hardware
> 
> dirty tracking.
> 
> 
> So my understanding is:
> 
> wrprotect() (dirty tracking): D->C — clears S2AP[1], preserves DBM
> 
> mkreadonly() (true RO, future): ->N — clears both S2AP[1] and DBM
> 
> Does this match what you had in mind?
> 
> Looking forward to your thoughts.
> 
> Thanks,
> Tian
> 
> 
 
Thanks!
Leo
