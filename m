Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793379154;
	b=jVoJ5Z15Y55pk4wOznev5p0IvoVQcLTxx8WfDsKVmxe3v/omu1py5DRybwvZTzfMNf63
	 g5rMIbKz5tZdiQoFijImmENgrfW1sr28VBrhPPXE5FKav2QGARM0LdGIIfD7Aqz+cZjGT
	 +EX2wDeBJul4X8mJbWNHTF+pBYUQDrY8bh8gCLoa99en80a5oPP4LqrcUMziyqyVBaAi0
	 EpJhrdm++tAzYpl+gL7cU+JSdfZeN8vsL1CdNod6LDDO/lxqz8isJAIIQiK0MzEV4M9il
	 DwmS7X+EkSz1imTigALjU1Yp1QU+utAdZB3gduuL0TY27rumR4k2eDVoCiRSk3EJ8yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793379154;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=ktj+5dC08v5X6CbAXYodRMTXsnx7EjXTMl4rsHotSsw=;
	b=YJvtphln2qK5XMYOKj6Qy4Sx7Ld0jqcEeMmQ45vPoHR/Ix4QLM8Tp06HibVWtwTR0BuK
	 gO09lxbaUwfsVnL99+VgEFSiBOMTw7wnCGUzTRbspR8FyJvUJlHD/57gJQus6tqj0YQpp
	 EZippGtxMa92yemv5wIK8x0cmtLI3VFC39vq8ZRFGGly47d3Mn91ZPcnzTALYUq06TiRB
	 IBm73KLwz030/F3mNBp1rrsziOyAnCj1oy7y/1GJVXOYOOLqTluIdhLziMaRVLWZ0DAaU
	 ehONyMqjb2NUhBTeqEFmBd2SRl8zQQ2ZJXuZNM1bs58uZweaVoeJtgiPz2Pkhxgm1TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vsLUxmt6;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B27B606A31C
	for <kvmarm@lists.linux.dev>; Fri, 30 Oct 2026 16:52:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B27B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vsLUxmt6
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0249A1682;
	Fri, 30 Oct 2026 09:52:29 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE1D03F673;
	Fri, 30 Oct 2026 09:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793379152; bh=7VMMf7kMCadyG94rG4Zx25wwUW0u14+sRWOtUecg2H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vsLUxmt6b/5m7BzFV7Hd8fIIx1EsthiLTP6rN+Ce6YaebNT/TyYfDFqazq9LqUwgB
	 9RphgrRu+PvjSC9PSvb4hysq0nLDGl2+UBl5il7GrIuZiENqtwODfbcpLMWOpptqBa
	 6Mh5JBUfaxOKWika3tkdWGger6AD196OTOfbuvSA=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 08/15] KVM: arm64: Flush the HDBSS buffer on VM exit
Date: Fri, 30 Oct 2026 16:52:08 +0000
Message-ID: <auTLOIafIq4cjRho@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <5bbd0d3b-1026-43f3-bc45-245472603144@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-9-zhengtian10@huawei.com> <auDpyRNpeDNzIk3W@LeoBrasDK> <5bbd0d3b-1026-43f3-bc45-245472603144@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Oct 30, 2026 at 12:57:06PM +0800, Tian Zheng wrote:
> 
> 
> On 10/28/2026 2:13 AM, Leonardo Bras wrote:
> > On Tue, Sep 29, 2026 at 06:36:48PM +0800, Tian Zheng wrote:
> > > From: Eillon <yezhenyu2@huawei.com>
> > > 
> > > HDBSS entries accumulate in the per-vCPU buffer while the guest runs,
> > > and must be drained into the dirty bitmap or dirty ring before
> > > userspace can observe them.
> > > 
> > > Drain the buffer at a single point: kvm_arch_vcpu_ioctl_run() flushes
> > > it on every VM exit, before the exit reason is handled. Flushing
> > > inside the run loop keeps the dirty-ring feedback timely: when a flush
> > > pushes the ring past its soft limit, kvm_dirty_ring_push() raises
> > > KVM_REQ_DIRTY_RING_SOFT_FULL, which check_vcpu_requests() observes at
> > > the top of the next loop iteration, so the vCPU exits to userspace for
> > > the harvest before re-entering the guest.
> > > 
> > > kvm_arch_sync_dirty_log() relies on the exit path to flush: it kicks
> > > vCPUs out of guest mode, and the GET/CLEAR protocol tolerates
> > > concurrent bitmap writes, so the snapshot is complete without extra
> > > synchronization.
> > > 
> > > Signed-off-by: Eillon <yezhenyu2@huawei.com>
> > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > ---
> > >   arch/arm64/include/asm/kvm_dirty_bit.h | 15 +++++++++
> > >   arch/arm64/kvm/arm.c                   | 20 ++++++++++++
> > >   arch/arm64/kvm/dirty_bit.c             | 45 ++++++++++++++++++++++++++
> > >   3 files changed, 80 insertions(+)
> > > 
> > > diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > index fe703f02626b..d828e6b43fe9 100644
> > > --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> > > +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > @@ -13,6 +13,9 @@
> > >   #include <asm/sysreg.h>
> > >   #include <linux/sizes.h>
> > > 
> > > +#define HDBSS_ENTRY_VALID	BIT(0)
> > > +#define HDBSS_ENTRY_IPA	GENMASK_ULL(55, 12)
> > > +
> > >   #define KVM_ARM_HDBSS_DEFAULT_SIZE  PAGE_SIZE
> > >   #define KVM_ARM_HDBSS_MAX_SIZE      SZ_2M
> > > 
> > > @@ -22,7 +25,19 @@ static inline u32 kvm_hdbss_buffer_size(struct kvm *kvm)
> > >   	return kvm->arch.hdbss_buffer_size ?: KVM_ARM_HDBSS_DEFAULT_SIZE;
> > >   }
> > > 
> > > +static inline bool kvm_hdbss_enabled(struct kvm *kvm)
> > > +{
> > > +	return kvm->arch.mmu.vtcr & VTCR_EL2_HDBSS;
> > > +}
> > > +
> > > +static inline bool vcpu_hdbss_enabled(struct kvm_vcpu *vcpu)
> > > +{
> > > +	return vcpu->arch.hw_mmu &&
> > > +		(vcpu->arch.hw_mmu->vtcr & VTCR_EL2_HDBSS);
> > > +}
> > > +
> > 
> > IIUC, arch.mmu is always the canonical s2_mmu, while hw_mmu can be the
> > nested s2_mmu, if enabled.
> > 
> > Was that your intend here?
> > If not, we could use only kvm* version, which can be called with vcpu->kvm.
> > 
> > If it was, then I would like to understand the logic here, as IIUC the
> > buffer is accessible only for the non-nested guest, as it's
> > allocated in a per-vcpu structure. (vcpu->arch)
> > 
> 
> Hi leo,
> 
> Yes, that was the intent. The shadow MMU never carries VTCR_EL2.HDBSS,
> so the flush is naturally skipped when running nested.

Ah, right. If we always test the kvm one, we may enable it for the nested 
guest, which is undesired.

[...]
> 
> > 
> > > @@ -2017,7 +2025,19 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
> > > 
> > >   void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
> > >   {
> > > +	unsigned long i;
> > > +	struct kvm_vcpu *vcpu;
> > > 
> > > +	if (!kvm_hdbss_enabled(kvm))
> > > +		return;
> > > +

And then here you check for the L1 VM because during migration the host 
could have dirtied memory, and you want to track that as well.

Makes sense

> > > +	/*
> > > +	 * The buffer is drained on every VM exit, so kicking running
> > > +	 * vCPUs is enough to flush them; the dirty-log GET/CLEAR
> > > +	 * protocol tolerates bits set concurrently with the snapshot.
> > > +	 */
> > > +	kvm_for_each_vcpu(i, vcpu, kvm)
> > > +		kvm_vcpu_kick(vcpu);
> > >   }
> > > 
> > >   static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> > > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > > index f9aeb9f34ad0..be0d12555c84 100644
> > > --- a/arch/arm64/kvm/dirty_bit.c
> > > +++ b/arch/arm64/kvm/dirty_bit.c
> > > @@ -13,6 +13,7 @@
> > >   #include <linux/kconfig.h>
> > >   #include <linux/log2.h>
> > >   #include <linux/mm.h>
> > > +#include <linux/srcu.h>
> > > 
> > 
> > Out of curiosity, could you please explain you reasoning on selecting srcu
> > as locking here?
> > 
> > (Like, what are you protecting against, and why srcu is a good choice)
> > 
> 
> kvm_vcpu_mark_page_dirty() resolves the memslot under SRCU
> (kvm_vcpu_gfn_to_memslot), and the flush loop calls it for each entry,
> so the whole loop needs the read lock held.

Oh, right, it's just about getting the memslot... now I see it :)

Thanks!
Leo
