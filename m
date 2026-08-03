Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E014437C93F
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785752661; cv=none; b=RNKfKdHj6VEMVuX4xIBKJRImzvJbWW31NkZSk5TBKVxjVT7MBJXTZdWJQVOWV8uhK051t6HMXWRV9hXdAXZsdCa9YtOJ1l/l4id4njDgsjIpi4RkP1JZQa9nphHb4WAFztIOH1FvMfFpQ2EJ61GZZaOQEnImh54aCX7aAopxNqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785752661; c=relaxed/simple;
	bh=/C15BAjeHf8zl1dcubOk0yLwqz1IpPIfTVQ5pgG6ff0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=A4PkEey/MS7olqP+Cod2/kTfD2VqAjnqn3D9HORbNmFpKaUZuLCfqPpVX6+S+ntsxFBAwQPZ6ZRYffx7VgQjq0HA2zt4z357RtTzLDGYgX8s501txk7AAbJkpNmhG3Fa1tl2H0X+uFRXwOuksZhZuQAT4NqrdsiyakvaWYCvEwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FmNYySzB; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FmNYySzB"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D41A143D;
	Mon,  3 Aug 2026 03:24:14 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 449A83F632;
	Mon,  3 Aug 2026 03:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785752658; bh=/C15BAjeHf8zl1dcubOk0yLwqz1IpPIfTVQ5pgG6ff0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmNYySzBpWAIUTSruOLCSGdfsdkodvZndNXqdfjKzHUMYyqt9lOFap+/FmVXjQSME
	 PznNz/mycww34H25i04tueVoe+qEa1ktLYEqbzK2LzFA1qGDrPcfCks6w+UIVGFLK5
	 2lDWWdWQP8FZ/rleYtudYIkMOqJwZGYxBsu89y60=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
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
Subject: Re: [PATCH v4 5/6] KVM: arm64: Add HDBSS fault handling and buffer flush
Date: Mon,  3 Aug 2026 11:24:13 +0100
Message-ID: <anBsTG4_ibvl82SM@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <e561c281-4926-4b72-86c6-8da66297cd4b@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-6-zhengtian10@huawei.com> <alTw0nwiBDWoFrjB@LeoBrasDK> <9340fa94-6f26-4053-a4ca-0803af725936@huawei.com> <alYUXkub43YxkeH1@LeoBrasDK> <fa0839f9-7d83-4ad1-80e2-7e7dd0280222@huawei.com> <alZFVPkS3lgGdruc@LeoBrasDK> <3fb4b33e-4618-4523-b140-955e15fd9a8c@huawei.com> <alpN16Q3MgVHJzsN@LeoBrasDK> <e561c281-4926-4b72-86c6-8da66297cd4b@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Aug 03, 2026 at 11:22:45AM +0800, Tian Zheng wrote:
> 
> 
> On 7/17/2026 11:44 PM, Leonardo Bras wrote:
> > On Fri, Jul 17, 2026 at 02:51:12PM +0800, Tian Zheng wrote:
> > > 
> > > On 7/14/2026 10:19 PM, Leonardo Bras wrote:
> > > > On Tue, Jul 14, 2026 at 09:27:15PM +0800, Tian Zheng wrote:
> > > > > On 7/14/2026 6:50 PM, Leonardo Bras wrote:
> > > > > > On Tue, Jul 14, 2026 at 03:38:39PM +0800, Tian Zheng wrote:
> > > > > > > On 7/13/2026 10:06 PM, Leonardo Bras wrote:
> > > > > > > > On Thu, Jul 09, 2026 at 06:40:25PM +0800, Tian Zheng wrote:
> > > > > > > > > From: eillon <yezhenyu2@huawei.com>
> > > > > > > > > 
> > > > > > > > > Add HDBSS fault handling for buffer full, external abort, and general
> > > > > > > > > protection fault (GPF) events. When the HDBSS buffer becomes full,
> > > > > > > > > the hardware traps to EL2 with an HDBSSF event, which is handled by
> > > > > > > > > setting a flush request.
> > > > > > > > > 
> > > > > > > > > Add kvm_flush_hdbss_buffer() to consume HDBSS buffer entries and
> > > > > > > > > propagate dirty information into the userspace-visible dirty bitmap.
> > > > > > > > > Flush is triggered on vcpu_put, check_vcpu_requests, and
> > > > > > > > > sync_dirty_log.
> > > > > > > > > 
> > > > > > > > > Add esr_iss2_is_hdbssf() helper for HDBSS fault detection in guest
> > > > > > > > > abort handling.
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Eillon <yezhenyu2@huawei.com>
> > > > > > > > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > > > > > > > ---
> > > > > > > > >      arch/arm64/include/asm/esr.h           |  5 +++
> > > > > > > > >      arch/arm64/include/asm/kvm_dirty_bit.h | 11 +++++
> > > > > > > > >      arch/arm64/include/asm/kvm_host.h      |  1 +
> > > > > > > > >      arch/arm64/kvm/arm.c                   | 14 ++++++
> > > > > > > > >      arch/arm64/kvm/dirty_bit.c             | 62 ++++++++++++++++++++++++++
> > > > > > > > >      arch/arm64/kvm/mmu.c                   |  4 ++
> > > > > > > > >      6 files changed, 97 insertions(+)
> > > > > > > > > 
> > > > > > > > > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > > > > > > > > index 81c17320a588..2e6b679b5908 100644
> > > > > > > > > --- a/arch/arm64/include/asm/esr.h
> > > > > > > > > +++ b/arch/arm64/include/asm/esr.h
> > > > > > > > > @@ -437,6 +437,11 @@
> > > > > > > > >      #ifndef __ASSEMBLER__
> > > > > > > > >      #include <asm/types.h>
> > > > > > > > > 
> > > > > > > > > +static inline bool esr_iss2_is_hdbssf(unsigned long esr)
> > > > > > > > > +{
> > > > > > > > > +	return ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF;
> > > > > > > > This will return a long, which will be casted as bool.
> > > > > > > > In general, what I see in the kernel is something like:
> > > > > > > > 
> > > > > > > > 	return !!(ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF)
> > > > > > > ok!
> > > > > > > 
> > > > > > > 
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > > > >      static inline unsigned long esr_brk_comment(unsigned long esr)
> > > > > > > > >      {
> > > > > > > > >      	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> > > > > > > > > diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > > > > > index 84b12f0a10af..4b28000e972f 100644
> > > > > > > > > --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > > > > > +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > > > > > @@ -10,7 +10,18 @@
> > > > > > > > >      #include <asm/kvm_pgtable.h>
> > > > > > > > >      #include <asm/sysreg.h>
> > > > > > > > > 
> > > > > > > > > +/* HDBSS entry field definitions */
> > > > > > > > > +#define HDBSS_ENTRY_VALID	BIT(0)
> > > > > > > > > +#define HDBSS_ENTRY_TTWL_SHIFT (1)
> > > > > > > > > +#define HDBSS_ENTRY_TTWL_MASK (GENMASK(3, 1))
> > > > > > > > > +#define HDBSS_ENTRY_TTWL(x) \
> > > > > > > > > +	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
> > > > > > > > > +#define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
> > > > > > > > > +#define HDBSS_ENTRY_IPA	GENMASK_ULL(55, 12)
> > > > > > > > > +
> > > > > > > > >      int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
> > > > > > > > >      void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> > > > > > > > > +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
> > > > > > > > > +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu);
> > > > > > > > > 
> > > > > > > > >      #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> > > > > > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > > > > > > index c41ec6d9c45a..cecfb884a64f 100644
> > > > > > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > > > > > @@ -55,6 +55,7 @@
> > > > > > > > >      #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
> > > > > > > > >      #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
> > > > > > > > >      #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
> > > > > > > > > +#define KVM_REQ_FLUSH_HDBSS			KVM_ARCH_REQ(12)
> > > > > > > > > 
> > > > > > > > >      #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> > > > > > > > >      				     KVM_DIRTY_LOG_INITIALLY_SET)
> > > > > > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > > > > > index bf6688245d83..566953a4e23a 100644
> > > > > > > > > --- a/arch/arm64/kvm/arm.c
> > > > > > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > > > > > @@ -755,6 +755,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> > > > > > > > >      		kvm_vcpu_put_hw_mmu(vcpu);
> > > > > > > > >      	kvm_arm_vmid_clear_active();
> > > > > > > > > 
> > > > > > > > > +	if (vcpu->kvm->arch.enable_hdbss)
> > > > > > > > > +		kvm_flush_hdbss_buffer(vcpu);
> > > > > > > > > +
> > > > > > > > >      	vcpu_clear_on_unsupported_cpu(vcpu);
> > > > > > > > >      	vcpu->cpu = -1;
> > > > > > > > >      }
> > > > > > > > > @@ -1157,6 +1160,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> > > > > > > > >      		if (kvm_dirty_ring_check_request(vcpu))
> > > > > > > > >      			return 0;
> > > > > > > > > 
> > > > > > > > > +		if (kvm_check_request(KVM_REQ_FLUSH_HDBSS, vcpu))
> > > > > > > > > +			kvm_flush_hdbss_buffer(vcpu);
> > > > > > > > > +
> > > > > > > > >      		check_nested_vcpu_requests(vcpu);
> > > > > > > > >      	}
> > > > > > > > > 
> > > > > > > > > @@ -1971,7 +1977,15 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
> > > > > > > > > 
> > > > > > > > >      void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
> > > > > > > > >      {
> > > > > > > > > +	/*
> > > > > > > > > +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
> > > > > > > > > +	 * before reporting dirty_bitmap to userspace. Send a request with
> > > > > > > > > +	 * KVM_REQUEST_WAIT to flush buffer synchronously.
> > > > > > > > > +	 */
> > > > > > > > > +	if (!kvm->arch.enable_hdbss)
> > > > > > > > > +		return;
> > > > > > > > > 
> > > > > > > > > +	kvm_make_all_cpus_request(kvm, KVM_REQ_FLUSH_HDBSS | KVM_REQUEST_WAIT);
> > > > > > > > >      }
> > > > > > > > > 
> > > > > > > > >      static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> > > > > > > > > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > > > > > > > > index 6c7a6ef66b5a..002366337637 100644
> > > > > > > > > --- a/arch/arm64/kvm/dirty_bit.c
> > > > > > > > > +++ b/arch/arm64/kvm/dirty_bit.c
> > > > > > > > > @@ -50,3 +50,65 @@ void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> > > > > > > > > 
> > > > > > > > >      	vcpu->arch.hdbss.hdbssbr_el2 = 0;
> > > > > > > > >      }
> > > > > > > > > +
> > > > > > > > > +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
> > > > > > > > > +{
> > > > > > > > > +	int idx, curr_idx;
> > > > > > > > > +	u64 *hdbss_buf;
> > > > > > > > > +	struct kvm *kvm = vcpu->kvm;
> > > > > > > > > +
> > > > > > > > > +	if (!kvm->arch.enable_hdbss)
> > > > > > > > > +		return;
> > > > > > > > > +
> > > > > > > > > +	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
> > > > > > > > > +
> > > > > > > > > +	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
> > > > > > > > > +	if (curr_idx == 0 || vcpu->arch.hdbss.hdbssbr_el2 == 0)
> > > > > > > > > +		return;
> > > > > > > > > +
> > > > > > > > > +	hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
> > > > > > > > > +	if (!hdbss_buf)
> > > > > > > > > +		return;
> > > > > > > > > +
> > > > > > > > > +	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
> > > > > > > > > +	for (idx = 0; idx < curr_idx; idx++) {
> > > > > > > > > +		u64 gpa;
> > > > > > > > > +
> > > > > > > > > +		gpa = hdbss_buf[idx];
> > > > > > > > > +		if (!(gpa & HDBSS_ENTRY_VALID))
> > > > > > > > > +			continue;
> > > > > > > > > +
> > > > > > > > > +		gpa &= HDBSS_ENTRY_IPA;
> > > > > > > > > +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> > > > > > > > You mention that it does not support dirty-ring, but above function will
> > > > > > > > mark the page as dirty in the dirty-ring :/
> > > > > > > > 
> > > > > > > In kvm_arm_enable_hdbss_global(), we explicitly check and reject HDBSS
> > > > > > > enablement if dirty-ring is active:
> > > > > > > 
> > > > > > > ```
> > > > > > > if (kvm->dirty_ring_size)
> > > > > > >        return 0;
> > > > > > > ```
> > > > > > > 
> > > > > > > So when kvm_flush_hdbss_buffer() runs (which requires enable_hdbss = true),
> > > > > > > we know for certain that
> > > > > > > 
> > > > > > > kvm->dirty_ring_size == 0. Therefore, kvm_vcpu_mark_page_dirty() will always
> > > > > > > take the dirty_bitmap path,
> > > > > > > 
> > > > > > > never the dirty-ring path.
> > > > > > > 
> > > > > > > That said, I'll add a comment in kvm_flush_hdbss_buffer() before dirty ring
> > > > > > > mode is supported, to make this explicit:
> > > > > > > 
> > > > > > > ```
> > > > > > > /*
> > > > > > >     * HDBSS is mutually exclusive with dirty-ring mode (see
> > > > > > >     * kvm_arm_enable_hdbss_global()), so kvm_vcpu_mark_page_dirty()
> > > > > > >     * will update the dirty_bitmap, not the dirty-ring.
> > > > > > >     */
> > > > > > > ```
> > > > > > > 
> > > > > > Got it :)
> > > > > > 
> > > > > > Out of curiosity: which issues have you found on supporting dirty-ring at
> > > > > > this point?
> > > > > > 
> > > > > > Thanks!
> > > > > > Leo
> > > > > 
> > > > > I haven't looked deeply into dirty-ring yet — my main concern is that if
> > > > > both the dirty
> > > > > 
> > > > > ring and HDBSS buffer fill up, the flush path might get blocked or
> > > > > complicated.
> > > > > 
> > > > > For now, I'm planning to match the HDBSS buffer size to the dirty ring size
> > > > > in v5 and test it.
> > > > > 
> > > > > Ideally, the two buffers would be the same size, and the entire dirty
> > > > > tracking path would use
> > > > > 
> > > > Ah, I see the point.
> > > > 
> > > > IIRC, when dirty-ring gets full, the kernel returns to userspace with
> > > > run->exit_reason == KVM_EXIT_DIRTY_RING_FULL, which will warn the VMM to
> > > > drain the dirty-ring, and that makes space for us draining HDBSS to the
> > > > dirty-ring again.
> > > > 
> > > > The best way to achieve that, as I remember, is to always drain
> > > > HDBSS as much as possible at guest_exitting. That will make more space to
> > > > newer HDBSS entries, and we can get userspace to drain the dirty-ring
> > > > earlier.
> > > > 
> > > > I would say to even make HDBSS buffer half (entries) the dirty-ring. Then
> > > > we can generally fully drain to the dirty-ring and even report ring full
> > > > if the ring is above a given threshold percentage full.
> > > > > HDBSS exclusively — no fallback to the legacy dirty bitmap path. If that
> > > > > works, I think this approach should be fine.
> > > > > 
> > > > > Let me know if you have any insights on dirty ring's full-buffer behavior —
> > > > > that would be helpful.
> > > > > 
> > > > > 
> > > > Will do!
> > > > 
> > > > Thanks!
> > > > Leo
> > > 
> > > 
> > > Thanks for the insights — reusing PML's reservation mechanism makes sense.
> > > 
> > > I think we can*keep the HDBSS buffer at 512 entries* (matching
> > 
> > I recommend using a PAGESIZE (512 in 4k, but bigger in other sizes)
> > 
> > > PML_LOG_NR_ENTRIES)
> > > 
> > > for now, and *not expose any ioctl for userspace to configure it*. Since the
> > > kernel
> > > 
> > > auto-enables HDBSS, a userspace size knob would be confusing.
> > > 
> > 
> > Humm, I am in favor of letting the user change it according to it's
> > workload. Why would that be confusing?
> > 
> > (Having a default size is useful just for enabling it to work without any
> > change in current VMs)
> > 
> > > 
> > > The reservation logic would be:
> > > 
> > > - Implement kvm_cpu_dirty_log_size() on arm64 to return the HDBSS buffer
> > > entry
> > > 
> > > count (512, or 0 if HDBSS is not enabled)
> > 
> > Why a get to log_size? does userspace need to know it's using HDBSS?
> > 
> > Just a set should do, as VMMs can just try to set a value, and if it fails
> > (IOCTL does not exist, or invalid value), then it can just go forward.
> > 
> > > 
> > > - Reuse kvm_dirty_ring_get_rsvd_entries() to reserve space for one full
> > > flush:
> > > 
> > > KVM_DIRTY_RING_RSVD_ENTRIES + hdbss_entries
> > > 
> > > - So soft_limit = dirty_ring_size - (KVM_DIRTY_RING_RSVD_ENTRIES +
> > > hdbss_entries),
> > > 
> > > guaranteeing a full flush always fits
> > > 
> > > kvm_flush_hdbss_buffer() at guest_exit pushes via mark_page_dirty_in_slot()
> > > ->
> > > 
> > 
> > I think I get the point here: since we can have sw dirtying as well as
> > HDBSS tracking, we may get to the point that we don't have enough space to
> > flush hdbss -> dirty-ring, right?
> > 
> > > kvm_dirty_ring_push() -> kvm_dirty_ring_soft_full, which triggers
> > > 
> > > KVM_EXIT_DIRTY_RING_FULL when needed.
> > > 
> > > If soft_limit is hit, KVM_REQ_DIRTY_RING_FULL is set and the next vcpu_run
> > > exits
> > > 
> > > to userspace for QEMU to drain the ring.
> > 
> > So the software dirtying routine would be affected by the soft limit, but
> > HADBSS exit would not. It means the dirty-ring would be effectively smaller
> > than specified if we are having mostly sw dirtying.
> > 
> > Did I get that right?
> > 
> 
> Yep. And about why not expose an ioctl to userspace, and how the kernel
> should size the HDBSS buffer for both dirty-bitmap and dirty-ring modes —
> please see the discussion below:
> 
> https://lore.kernel.org/linux-arm-kernel/2d8f90dd-ed43-4663-8256-6c3eeb51d480@huawei.com/
> 

Okay then, following there as well.

Thanks!
Leo


> > > 
> > > *One more thing: *when userspace sets the dirty ring size via
> > > 
> > > KVM_VM_IOCTL_ENABLE_DIRTY_LOG_RING, we already enforce that
> > > 
> > > size >= kvm_dirty_ring_get_rsvd_entries(kvm) * sizeof(struct kvm_dirty_gfn)
> > > 
> > > or size < PAGE_SIZE. With HDBSS, kvm_dirty_ring_get_rsvd_entries() will
> > > include the
> > > 
> > > HDBSS entries via kvm_cpu_dirty_log_size(), so the same check will
> > > automatically guarantee
> > > 
> > > the ring is large enough to accommodate the HDBSS buffer. No additional
> > > validation is needed.
> > > 
> > 
> > An alternative is moving the remaining array entries to the beginning of
> > the array, and setting the registers accordingly. The tradeoff is an
> > overhead here vs having the full size of the array available later.
> > 
> > Thanks!
> > Leo
> > 
> > 
> 
