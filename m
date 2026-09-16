Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E039E47F3DA
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567254; cv=none; b=hOyZM/ydziLlLvpoysUsfgb5ReZRIAZfLO5DHDBDc1hfm0T8JpBgwvTgG3nlP7eg5+z+lc1MSUrCEOouQTA9sjMhhADr/U8Z+J26A2A7atqXDzvWrZPbHzP65oYUihZXYJoJZzXaCIKi6xVWviAOzi4ihVALHkoTwqksa0iw3HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567254; c=relaxed/simple;
	bh=X32TptwEZT8cNEFqLMIyufpmRkecQmhziZDP7tUEcFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=na/pJcoyO3JHP7bD9tHXTCAb+0HNg7biZvlvGT04olvwg0K90XAQNXQXhBQqU0EsOhxQRiZI8GjbI5oP66EjIhFHF4LUJNFLyY086WA/AQ+CpXIf5o9JTASVNOjlcOGCsTQe092aTu82IuV2oQvcAyKdQDXGJUlAyejUrPcB/Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KvTp87F3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KvTp87F3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71178152B;
	Wed, 16 Sep 2026 07:00:47 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (unknown [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B58283F86F;
	Wed, 16 Sep 2026 07:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789567251; bh=X32TptwEZT8cNEFqLMIyufpmRkecQmhziZDP7tUEcFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvTp87F375+25OWbtr4lzE6MhuYnnz7yrLqjKKabM/qIP0yCdpHFAvjv127/mHkyw
	 zNK/AxgFUI+K0zz4un8xqXs2VJW/1sOtg4tVYTyk/wM+QBJ/JRcUWauDC6RwWYk5iI
	 xzgbpyo1Dv8iqh6vr2jO7nw9f6phwndr1/BSrUOI=
From: Leonardo Bras <leo.bras@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Enable HAFDBS for guests not on migration
Date: Wed, 16 Sep 2026 15:00:46 +0100
Message-ID: <aqqhDs3NyjtkZzXK@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aqneWnlsdpocLIl6@kernel.org>
References: <20260901171558.2674031-1-leo.bras@arm.com> <20260901171558.2674031-6-leo.bras@arm.com> <aqneWnlsdpocLIl6@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 15, 2026 at 05:10:02PM -0700, Oliver Upton wrote:
> Hi,
> 
> On Tue, Sep 01, 2026 at 06:15:56PM +0100, Leonardo Bras wrote:
> > When dirty-logging is disabled, even non-write faults make a page dirty,
> > which avoids a second fault when the page is actually written to.
> > 
> > On dirty-logging enable, this approach causes all (writable) pages on the
> > memslot to be marked clean, even if they were not written to, which can
> > take a lot of time, while holding the MMU lock, doing atomic writes to
> > PTEs.
> 
> Do you have any performance numbers for this? Enabling HAFDBS seems a
> bit involved to avoid some stores on the first pass.

Not yet, but if the idea does not look too crazy I can find hardware and 
collect some data :)

> 
> > So, if the system supports VHE + HAFDBS, keep the non-write-faulted page as
> > writable-clean, and let HAFDBS update that on demand when a write happens.
> > 
> > When dirty-tracking actually starts, disable HAFDBS as having it on
> > avoids the same fault that is used for dirty-logging.
> > 
> > Signed-off-by: Leonardo Bras <leo.bras@arm.com>
> > ---
> >  arch/arm64/include/asm/kvm_mmu.h    |  6 ++++++
> >  arch/arm64/include/asm/kvm_nested.h |  9 +++++++--
> >  arch/arm64/kvm/arm.c                |  7 +++++++
> >  arch/arm64/kvm/mmu.c                | 26 +++++++++++++++++++++++++-
> >  4 files changed, 45 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> > index 6eae7e7e2a68..3defa1a988d3 100644
> > --- a/arch/arm64/include/asm/kvm_mmu.h
> > +++ b/arch/arm64/include/asm/kvm_mmu.h
> > @@ -383,20 +383,26 @@ static inline void kvm_fault_unlock(struct kvm *kvm)
> >   * and CMOs are NOP'd. This has the effect of no longer requiring a
> >   * KVA for addresses mapped into the S2. The presence of these features
> >   * are thus necessary to support cacheable S2 mapping of VM_PFNMAP.
> >   */
> >  static inline bool kvm_supports_cacheable_pfnmap(void)
> >  {
> >  	return cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) &&
> >  	       cpus_have_final_cap(ARM64_HAS_CACHE_DIC);
> >  }
> >  
> > +static inline bool kvm_supports_hafdbs(struct kvm *kvm)
> > +{
> > +	return IS_ENABLED(CONFIG_ARM64_HW_AFDBM) &&
> 
> cpucap_is_possible() is the right place to park this.
> 

Noted!

> > 						      has_vhe() &&
> 
> I don't see a reason why this needs to be constrained to VHE-only.
> 

Humm, in nVHE would not the host kernel run in EL1?
I thought that this being a feature that depends on EL2 registers host 
would need to be in EL2 to make use of it.

That being said, I understand very little of how this works, so I 
constrained to VHE only at the start.

Would this work in nVHE?

> > +		!kvm_vcpu_has_nv(kvm) && cpus_have_final_cap(ARM64_HW_DBM);
> 
> Same thing goes for nested... KVM can make use of HAFDBS in the
> canonical stage-2 MMU (or even a shadow stage-2) independent of the
> guest hypervisor.
> 

Humm, I remember reaching the conclusion that it could not be used if the 
guest supported NV. Let's say:

L0 - Host	- Has HAFDBS enabled
L1 - Hypervisor - Has HAFDBS disabled
L2 - Guest	-

Let's say guest writes to a page, and the shadow S2 has DBM=1, so it's 
marked as WD by HAFDBS. Since no fault was taken, how would the L1 be able 
to update it's S2 pagetables to mark the page dirty?

(We would have to transverse the Shadow S2 Pagetable updating the original 
S2 pagetable)

I was wondering, thought, that we could emulate it in the last level 
hypervisor, if it's guest does not support nested guests. That would mean 
we can have the last-1 level hypervisor to update the S2 pagetable on the 
last level hypervisor without it having to fault. Ex:

L0 Host - HAFDBS disabled
[...]
Ln-1 Hypervisor - HAFDBS disabled
Ln   Hypervisor - HAFDBS enabled
Ln+1 Guest - No E2H feature

When the guest writes to a page, the host should receive a fault, that IIUC 
have to propagate down up to Ln Hyp. If Ln Hyp has HAFDBS, we could skip 
injecting a fault in Ln Hyp, as  Ln-1 Hyp could emulate HAFDBS and write 
the dirty bit to S2 pagetagle of Ln+1 guest, that resides in Ln memory.

Not sure if the troulbe would be worth, though.
Does it make sense?



> >  #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> >  void kvm_s2_ptdump_create_debugfs(struct kvm *kvm);
> >  void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu);
> >  void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu);
> >  #else
> >  static inline void kvm_s2_ptdump_create_debugfs(struct kvm *kvm) {}
> >  static inline void kvm_nested_s2_ptdump_create_debugfs(struct kvm_s2_mmu *mmu) {}
> >  static inline void kvm_nested_s2_ptdump_remove_debugfs(struct kvm_s2_mmu *mmu) {}
> >  #endif /* CONFIG_PTDUMP_STAGE2_DEBUGFS */
> >  
> > diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> > index 1ed708335809..9242b5d665af 100644
> > --- a/arch/arm64/include/asm/kvm_nested.h
> > +++ b/arch/arm64/include/asm/kvm_nested.h
> > @@ -1,24 +1,29 @@
> >  /* SPDX-License-Identifier: GPL-2.0 */
> >  #ifndef __ARM64_KVM_NESTED_H
> >  #define __ARM64_KVM_NESTED_H
> >  
> >  #include <linux/bitfield.h>
> >  #include <linux/kvm_host.h>
> >  #include <asm/kvm_emulate.h>
> >  #include <asm/kvm_pgtable.h>
> >  
> > -static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
> > +static inline bool kvm_vcpu_has_nv(const struct kvm *kvm)
> 
> The name would suggest this thing takes a vcpu pointer...
> 

Ah, that name was based on
#define kvm_vcpu_has_feature(k, f)  __vcpu_has_feature(&(k)->arch, #(f))

That takes a kvm struct to check the kvm_arch one, instead of looking into 
the vcpu. I did it like this because there were some scenarios it was not 
quite straightforward to get the vcpu to use vcpu_has_nv(), which takes a 
vcpu.


Thanks!
Leo
