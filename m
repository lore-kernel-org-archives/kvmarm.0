Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA27CA95E
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 01:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784769449; cv=none; b=ISs7mj9UNgMqIRtAYctw/tdsZlRpElaqyHHxPtqo50b18iF3b01jSfNY3brXCajbw52BLZg1de3QSbITu+y81KnaqVqldPQX894xOn3SRC2GIyGVvSqnk1RgeTwbueaVh4Wce3fZZR76lv3vu/HapUWHc5KIY2BeXe0owXumI8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784769449; c=relaxed/simple;
	bh=V6Cs4Qzo6p3FaluJv2sigFfnWTYfuCDv6hhFmQUkZuI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XGXTGor9fqLJNbTT2Zu+Lubx58zSm04tDkL7NcTrXuOWjD99yUxPNhNXIlzUXHTMysys9MekzpCcV6mS3AnKu/QATHMVdXkSKx7IxCJvgiGTxmqr7+cK2N7v3E/sBbLa+2+Xdo+ix9MFhU6/hGwcjD5CynTl+zmPrXRXOBLjJXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxgaOmef; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxgaOmef"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-caf45fc5202so116347a12.1
        for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 18:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784769447; x=1785374247; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8t4aEed9nNcew1/x2yByb1j/7/zYvGDZmCtQ4e+XO40=;
        b=ZxgaOmefN/v97pft+dpLpz81vh53RqyDeYU7Eq28RdmcTsQhmgxjadaX46Yw3+ufZL
         75Vhm01NdQq2PCmg57AjgbFCQTWDj4GXSCxeRL5j6s+jyoODqrCl0p5CCouvQnfiWhxD
         Soe4qZWghS9i7JCe/tb2Ezh24gmFWFc3pwuohw4w28CmKOVBGEKTW55BtnqCorCDafP5
         8Gcs9hfNm2y0+gwYu2D9xFn1JChUretpnWid70m0G5W8VZP30zboa8JcSdH14ch4cZ4W
         k9WpBiMsjWdroi0R7WRrIg2LQd25WjlSYGRC8slzvDPiYFVAlOF4L0xwslitG2jcE0Yq
         RLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784769447; x=1785374247;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8t4aEed9nNcew1/x2yByb1j/7/zYvGDZmCtQ4e+XO40=;
        b=OUZlRRBkwCgy3xcf6x3miZxYwqpXMxnNwyMl/RVcmlnkSThlDPzuSqJ6e8zGRTaKib
         G2MQ1IIjgYZZFgcZQS+SJLbQZg1Y/HPJZ85MDUOdJry4TxhpX3qhhps/ViGcVeYdHlPw
         XWnd0p11zhXCB7EuboMVaJSVTsKtroCGrgDg8c53vcIXy8EimqGd1MIuV1HC/4dzXtrl
         857BstBOemJbyuCvXa51bm6mAI1CnsSE+tUuwtUzG/T8sSgiX2bojY88JR9v93QGxkS1
         p70ts5bBB0u8U604VLzm9qJl1nO6W0gAt1WhqcOgfhnBjYVfQnS5/rhm3mi8AlLp58ky
         L+mg==
X-Forwarded-Encrypted: i=1; AHgh+Ro3+4BSbM6Li1PEnkmfuQSG+5IEbv6gx74ofkO4Rl/zroVyUjkCxPM5CwPtnauefH3uxizSYHk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yya2/TmW5xA/LiD+4H2wuqMJpCiDzjD0Njs0BLHaabYx8Kr+xKj
	TII8G1YHAVJfDJtKf14wpX5onZseOZiTI2KcZjPhdRFRFw0XC+TUkm0APzDjbbQX
X-Gm-Gg: AR+sD13ZUDS99kGEn2UOgVz+Zd9j38grmwoWAVNBj4H8lQwUJSxUQwdlXD5DR5Ap6OQ
	xrAGe4XTCG11Dj8qqZTQex1o1yrZsOBoQ/fpW9BrYbK2rNPvKmju7DJXg9H41SbLLV+AyHmCaEd
	lP7cq4z5Xjq4XLc8EOoTD0/5g/Qe9GXRq11k54/tDD/OqkZPYy0Bcxy6Bt7fG5IUPMkSF0Hc79d
	yL7BmNm0uAfUyg4pVByPtP0yr2EYlYTmTYDt+ZclKIG675Y31UPqWxJHKmAtDfw9lCziGiVB57x
	DV1UUapQaFYBHrp4XqWIRCJbWhTtgm1vuJj29Qgm1bMdQl8vONXQNc0ZDI9oUY11WRfLS7JtasS
	Sji8NJYSEu54+YOqBuUqOp3MZyii6N/Qdp83t/CJe+t4wQkQicVOp7g==
X-Received: by 2002:a05:6a20:a114:b0:3c3:791e:5e12 with SMTP id adf61e73a8af0-3c44b274079mr1007753637.72.1784769446921;
        Wed, 22 Jul 2026 18:17:26 -0700 (PDT)
Received: from localhost ([2001:da8:7001:11::cb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f0ffe02sm1855493a12.14.2026.07.22.18.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 18:17:26 -0700 (PDT)
Date: Thu, 23 Jul 2026 09:17:23 +0800
From: Inochi Amaoto <inochiama@gmail.com>
To: Leonardo Bras <leo.bras@arm.com>, Inochi Amaoto <inochiama@gmail.com>
Cc: Tian Zheng <zhengtian10@huawei.com>, maz@kernel.org, oupton@kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, yuzenghui@huawei.com, wangzhou1@hisilicon.com, 
	yangjinqian1@huawei.com, caijian11@h-partners.com, liuyonglong@huawei.com, 
	yezhenyu2@huawei.com, yubihong@huawei.com, linuxarm@huawei.com, joey.gouly@arm.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, seiden@linux.ibm.com, suzuki.poulose@arm.com
Subject: Re: [PATCH v4 5/6] KVM: arm64: Add HDBSS fault handling and buffer
 flush
Message-ID: <amFrF3265kZozxNM@inochi.infowork>
References: <9340fa94-6f26-4053-a4ca-0803af725936@huawei.com>
 <alYUXkub43YxkeH1@LeoBrasDK>
 <fa0839f9-7d83-4ad1-80e2-7e7dd0280222@huawei.com>
 <alZFVPkS3lgGdruc@LeoBrasDK>
 <3fb4b33e-4618-4523-b140-955e15fd9a8c@huawei.com>
 <alpN16Q3MgVHJzsN@LeoBrasDK>
 <al8xreH4_RoL5P83@inochi.infowork>
 <al9_oOblOF5pjSTi@LeoBrasDK>
 <amAfV1LB7rJelenJ@inochi.infowork>
 <amCjufy4-5N3397i@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <amCjufy4-5N3397i@LeoBrasDK>

On Wed, Jul 22, 2026 at 12:04:26PM +0100, Leonardo Bras wrote:
> On Wed, Jul 22, 2026 at 01:14:15PM +0800, Inochi Amaoto wrote:
> > On Tue, Jul 21, 2026 at 03:18:09PM +0100, Leonardo Bras wrote:
> > > On Tue, Jul 21, 2026 at 04:53:08PM +0800, Inochi Amaoto wrote:
> > > > On Fri, Jul 17, 2026 at 04:44:24PM +0100, Leonardo Bras wrote:
> > > > > On Fri, Jul 17, 2026 at 02:51:12PM +0800, Tian Zheng wrote:
> > > > > > 
> > > > > > On 7/14/2026 10:19 PM, Leonardo Bras wrote:
> > > > > > > On Tue, Jul 14, 2026 at 09:27:15PM +0800, Tian Zheng wrote:
> > > > > > > > On 7/14/2026 6:50 PM, Leonardo Bras wrote:
> > > > > > > > > On Tue, Jul 14, 2026 at 03:38:39PM +0800, Tian Zheng wrote:
> > > > > > > > > > On 7/13/2026 10:06 PM, Leonardo Bras wrote:
> > > > > > > > > > > On Thu, Jul 09, 2026 at 06:40:25PM +0800, Tian Zheng wrote:
> > > > > > > > > > > > From: eillon <yezhenyu2@huawei.com>
> > > > > > > > > > > > 
> > > > > > > > > > > > Add HDBSS fault handling for buffer full, external abort, and general
> > > > > > > > > > > > protection fault (GPF) events. When the HDBSS buffer becomes full,
> > > > > > > > > > > > the hardware traps to EL2 with an HDBSSF event, which is handled by
> > > > > > > > > > > > setting a flush request.
> > > > > > > > > > > > 
> > > > > > > > > > > > Add kvm_flush_hdbss_buffer() to consume HDBSS buffer entries and
> > > > > > > > > > > > propagate dirty information into the userspace-visible dirty bitmap.
> > > > > > > > > > > > Flush is triggered on vcpu_put, check_vcpu_requests, and
> > > > > > > > > > > > sync_dirty_log.
> > > > > > > > > > > > 
> > > > > > > > > > > > Add esr_iss2_is_hdbssf() helper for HDBSS fault detection in guest
> > > > > > > > > > > > abort handling.
> > > > > > > > > > > > 
> > > > > > > > > > > > Signed-off-by: Eillon <yezhenyu2@huawei.com>
> > > > > > > > > > > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > > > > > > > > > > ---
> > > > > > > > > > > >     arch/arm64/include/asm/esr.h           |  5 +++
> > > > > > > > > > > >     arch/arm64/include/asm/kvm_dirty_bit.h | 11 +++++
> > > > > > > > > > > >     arch/arm64/include/asm/kvm_host.h      |  1 +
> > > > > > > > > > > >     arch/arm64/kvm/arm.c                   | 14 ++++++
> > > > > > > > > > > >     arch/arm64/kvm/dirty_bit.c             | 62 ++++++++++++++++++++++++++
> > > > > > > > > > > >     arch/arm64/kvm/mmu.c                   |  4 ++
> > > > > > > > > > > >     6 files changed, 97 insertions(+)
> > > > > > > > > > > > 
> > > > > > > > > > > > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > > > > > > > > > > > index 81c17320a588..2e6b679b5908 100644
> > > > > > > > > > > > --- a/arch/arm64/include/asm/esr.h
> > > > > > > > > > > > +++ b/arch/arm64/include/asm/esr.h
> > > > > > > > > > > > @@ -437,6 +437,11 @@
> > > > > > > > > > > >     #ifndef __ASSEMBLER__
> > > > > > > > > > > >     #include <asm/types.h>
> > > > > > > > > > > > 
> > > > > > > > > > > > +static inline bool esr_iss2_is_hdbssf(unsigned long esr)
> > > > > > > > > > > > +{
> > > > > > > > > > > > +	return ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF;
> > > > > > > > > > > This will return a long, which will be casted as bool.
> > > > > > > > > > > In general, what I see in the kernel is something like:
> > > > > > > > > > > 
> > > > > > > > > > > 	return !!(ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF)
> > > > > > > > > > ok!
> > > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > > > +}
> > > > > > > > > > > > +
> > > > > > > > > > > >     static inline unsigned long esr_brk_comment(unsigned long esr)
> > > > > > > > > > > >     {
> > > > > > > > > > > >     	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> > > > > > > > > > > > diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > > > > > > > > index 84b12f0a10af..4b28000e972f 100644
> > > > > > > > > > > > --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > > > > > > > > +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > > > > > > > > @@ -10,7 +10,18 @@
> > > > > > > > > > > >     #include <asm/kvm_pgtable.h>
> > > > > > > > > > > >     #include <asm/sysreg.h>
> > > > > > > > > > > > 
> > > > > > > > > > > > +/* HDBSS entry field definitions */
> > > > > > > > > > > > +#define HDBSS_ENTRY_VALID	BIT(0)
> > > > > > > > > > > > +#define HDBSS_ENTRY_TTWL_SHIFT (1)
> > > > > > > > > > > > +#define HDBSS_ENTRY_TTWL_MASK (GENMASK(3, 1))
> > > > > > > > > > > > +#define HDBSS_ENTRY_TTWL(x) \
> > > > > > > > > > > > +	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
> > > > > > > > > > > > +#define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
> > > > > > > > > > > > +#define HDBSS_ENTRY_IPA	GENMASK_ULL(55, 12)
> > > > > > > > > > > > +
> > > > > > > > > > > >     int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
> > > > > > > > > > > >     void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> > > > > > > > > > > > +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
> > > > > > > > > > > > +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu);
> > > > > > > > > > > > 
> > > > > > > > > > > >     #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> > > > > > > > > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > > > > > > > > > index c41ec6d9c45a..cecfb884a64f 100644
> > > > > > > > > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > > > > > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > > > > > > > > @@ -55,6 +55,7 @@
> > > > > > > > > > > >     #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
> > > > > > > > > > > >     #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
> > > > > > > > > > > >     #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
> > > > > > > > > > > > +#define KVM_REQ_FLUSH_HDBSS			KVM_ARCH_REQ(12)
> > > > > > > > > > > > 
> > > > > > > > > > > >     #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> > > > > > > > > > > >     				     KVM_DIRTY_LOG_INITIALLY_SET)
> > > > > > > > > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > > > > > > > > index bf6688245d83..566953a4e23a 100644
> > > > > > > > > > > > --- a/arch/arm64/kvm/arm.c
> > > > > > > > > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > > > > > > > > @@ -755,6 +755,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> > > > > > > > > > > >     		kvm_vcpu_put_hw_mmu(vcpu);
> > > > > > > > > > > >     	kvm_arm_vmid_clear_active();
> > > > > > > > > > > > 
> > > > > > > > > > > > +	if (vcpu->kvm->arch.enable_hdbss)
> > > > > > > > > > > > +		kvm_flush_hdbss_buffer(vcpu);
> > > > > > > > > > > > +
> > > > > > > > > > > >     	vcpu_clear_on_unsupported_cpu(vcpu);
> > > > > > > > > > > >     	vcpu->cpu = -1;
> > > > > > > > > > > >     }
> > > > > > > > > > > > @@ -1157,6 +1160,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> > > > > > > > > > > >     		if (kvm_dirty_ring_check_request(vcpu))
> > > > > > > > > > > >     			return 0;
> > > > > > > > > > > > 
> > > > > > > > > > > > +		if (kvm_check_request(KVM_REQ_FLUSH_HDBSS, vcpu))
> > > > > > > > > > > > +			kvm_flush_hdbss_buffer(vcpu);
> > > > > > > > > > > > +
> > > > > > > > > > > >     		check_nested_vcpu_requests(vcpu);
> > > > > > > > > > > >     	}
> > > > > > > > > > > > 
> > > > > > > > > > > > @@ -1971,7 +1977,15 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
> > > > > > > > > > > > 
> > > > > > > > > > > >     void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
> > > > > > > > > > > >     {
> > > > > > > > > > > > +	/*
> > > > > > > > > > > > +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
> > > > > > > > > > > > +	 * before reporting dirty_bitmap to userspace. Send a request with
> > > > > > > > > > > > +	 * KVM_REQUEST_WAIT to flush buffer synchronously.
> > > > > > > > > > > > +	 */
> > > > > > > > > > > > +	if (!kvm->arch.enable_hdbss)
> > > > > > > > > > > > +		return;
> > > > > > > > > > > > 
> > > > > > > > > > > > +	kvm_make_all_cpus_request(kvm, KVM_REQ_FLUSH_HDBSS | KVM_REQUEST_WAIT);
> > > > > > > > > > > >     }
> > > > > > > > > > > > 
> > > > > > > > > > > >     static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> > > > > > > > > > > > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > > > > > > > > > > > index 6c7a6ef66b5a..002366337637 100644
> > > > > > > > > > > > --- a/arch/arm64/kvm/dirty_bit.c
> > > > > > > > > > > > +++ b/arch/arm64/kvm/dirty_bit.c
> > > > > > > > > > > > @@ -50,3 +50,65 @@ void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> > > > > > > > > > > > 
> > > > > > > > > > > >     	vcpu->arch.hdbss.hdbssbr_el2 = 0;
> > > > > > > > > > > >     }
> > > > > > > > > > > > +
> > > > > > > > > > > > +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
> > > > > > > > > > > > +{
> > > > > > > > > > > > +	int idx, curr_idx;
> > > > > > > > > > > > +	u64 *hdbss_buf;
> > > > > > > > > > > > +	struct kvm *kvm = vcpu->kvm;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	if (!kvm->arch.enable_hdbss)
> > > > > > > > > > > > +		return;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
> > > > > > > > > > > > +
> > > > > > > > > > > > +	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
> > > > > > > > > > > > +	if (curr_idx == 0 || vcpu->arch.hdbss.hdbssbr_el2 == 0)
> > > > > > > > > > > > +		return;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
> > > > > > > > > > > > +	if (!hdbss_buf)
> > > > > > > > > > > > +		return;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
> > > > > > > > > > > > +	for (idx = 0; idx < curr_idx; idx++) {
> > > > > > > > > > > > +		u64 gpa;
> > > > > > > > > > > > +
> > > > > > > > > > > > +		gpa = hdbss_buf[idx];
> > > > > > > > > > > > +		if (!(gpa & HDBSS_ENTRY_VALID))
> > > > > > > > > > > > +			continue;
> > > > > > > > > > > > +
> > > > > > > > > > > > +		gpa &= HDBSS_ENTRY_IPA;
> > > > > > > > > > > > +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> > > > > > > > > > > You mention that it does not support dirty-ring, but above function will
> > > > > > > > > > > mark the page as dirty in the dirty-ring :/
> > > > > > > > > > > 
> > > > > > > > > > In kvm_arm_enable_hdbss_global(), we explicitly check and reject HDBSS
> > > > > > > > > > enablement if dirty-ring is active:
> > > > > > > > > > 
> > > > > > > > > > ```
> > > > > > > > > > if (kvm->dirty_ring_size)
> > > > > > > > > >       return 0;
> > > > > > > > > > ```
> > > > > > > > > > 
> > > > > > > > > > So when kvm_flush_hdbss_buffer() runs (which requires enable_hdbss = true),
> > > > > > > > > > we know for certain that
> > > > > > > > > > 
> > > > > > > > > > kvm->dirty_ring_size == 0. Therefore, kvm_vcpu_mark_page_dirty() will always
> > > > > > > > > > take the dirty_bitmap path,
> > > > > > > > > > 
> > > > > > > > > > never the dirty-ring path.
> > > > > > > > > > 
> > > > > > > > > > That said, I'll add a comment in kvm_flush_hdbss_buffer() before dirty ring
> > > > > > > > > > mode is supported, to make this explicit:
> > > > > > > > > > 
> > > > > > > > > > ```
> > > > > > > > > > /*
> > > > > > > > > >    * HDBSS is mutually exclusive with dirty-ring mode (see
> > > > > > > > > >    * kvm_arm_enable_hdbss_global()), so kvm_vcpu_mark_page_dirty()
> > > > > > > > > >    * will update the dirty_bitmap, not the dirty-ring.
> > > > > > > > > >    */
> > > > > > > > > > ```
> > > > > > > > > > 
> > > > > > > > > Got it :)
> > > > > > > > > 
> > > > > > > > > Out of curiosity: which issues have you found on supporting dirty-ring at
> > > > > > > > > this point?
> > > > > > > > > 
> > > > > > > > > Thanks!
> > > > > > > > > Leo
> > > > > > > > 
> > > > > > > > I haven't looked deeply into dirty-ring yet — my main concern is that if
> > > > > > > > both the dirty
> > > > > > > > 
> > > > > > > > ring and HDBSS buffer fill up, the flush path might get blocked or
> > > > > > > > complicated.
> > > > > > > > 
> > > > > > > > For now, I'm planning to match the HDBSS buffer size to the dirty ring size
> > > > > > > > in v5 and test it.
> > > > > > > > 
> > > > > > > > Ideally, the two buffers would be the same size, and the entire dirty
> > > > > > > > tracking path would use
> > > > > > > > 
> > > > > > > Ah, I see the point.
> > > > > > > 
> > > > > > > IIRC, when dirty-ring gets full, the kernel returns to userspace with
> > > > > > > run->exit_reason == KVM_EXIT_DIRTY_RING_FULL, which will warn the VMM to
> > > > > > > drain the dirty-ring, and that makes space for us draining HDBSS to the
> > > > > > > dirty-ring again.
> > > > > > > 
> > > > > > > The best way to achieve that, as I remember, is to always drain
> > > > > > > HDBSS as much as possible at guest_exitting. That will make more space to
> > > > > > > newer HDBSS entries, and we can get userspace to drain the dirty-ring
> > > > > > > earlier.
> > > > > > > 
> > > > > > > I would say to even make HDBSS buffer half (entries) the dirty-ring. Then
> > > > > > > we can generally fully drain to the dirty-ring and even report ring full
> > > > > > > if the ring is above a given threshold percentage full.
> > > > > > > > HDBSS exclusively — no fallback to the legacy dirty bitmap path. If that
> > > > > > > > works, I think this approach should be fine.
> > > > > > > > 
> > > > > > > > Let me know if you have any insights on dirty ring's full-buffer behavior —
> > > > > > > > that would be helpful.
> > > > > > > > 
> > > > > > > > 
> > > > > > > Will do!
> > > > > > > 
> > > > > > > Thanks!
> > > > > > > Leo
> > > > > > 
> > > > > > 
> > > > > > Thanks for the insights — reusing PML's reservation mechanism makes sense.
> > > > > > 
> > > > > > I think we can*keep the HDBSS buffer at 512 entries* (matching
> > > > > 
> > > > > I recommend using a PAGESIZE (512 in 4k, but bigger in other sizes)
> > > > > 
> > > > > > PML_LOG_NR_ENTRIES)
> > > > > > 
> > > > > > for now, and *not expose any ioctl for userspace to configure it*. Since the
> > > > > > kernel
> > > > > > 
> > > > > > auto-enables HDBSS, a userspace size knob would be confusing.
> > > > > > 
> > > > > 
> > > > > Humm, I am in favor of letting the user change it according to it's 
> > > > > workload. Why would that be confusing?
> > > > > 
> > > > > (Having a default size is useful just for enabling it to work without any 
> > > > > change in current VMs)
> > > > > 
> > > > > > 
> > > > > > The reservation logic would be:
> > > > > > 
> > > > > > - Implement kvm_cpu_dirty_log_size() on arm64 to return the HDBSS buffer
> > > > > > entry
> > > > > > 
> > > > > > count (512, or 0 if HDBSS is not enabled)
> > > > > 
> > > > > Why a get to log_size? does userspace need to know it's using HDBSS?
> > > > > 
> > > > > Just a set should do, as VMMs can just try to set a value, and if it fails 
> > > > > (IOCTL does not exist, or invalid value), then it can just go forward. 
> > > > > 
> > > > > > 
> > > > > > - Reuse kvm_dirty_ring_get_rsvd_entries() to reserve space for one full
> > > > > > flush:
> > > > > > 
> > > > > > KVM_DIRTY_RING_RSVD_ENTRIES + hdbss_entries
> > > > > > 
> > > > > > - So soft_limit = dirty_ring_size - (KVM_DIRTY_RING_RSVD_ENTRIES +
> > > > > > hdbss_entries),
> > > > > > 
> > > > > > guaranteeing a full flush always fits
> > > > > > 
> > > > > > kvm_flush_hdbss_buffer() at guest_exit pushes via mark_page_dirty_in_slot()
> > > > > > ->
> > > > > > 
> > > > > 
> > > > > I think I get the point here: since we can have sw dirtying as well as 
> > > > > HDBSS tracking, we may get to the point that we don't have enough space to 
> > > > > flush hdbss -> dirty-ring, right?
> > > > > 
> > > > > > kvm_dirty_ring_push() -> kvm_dirty_ring_soft_full, which triggers
> > > > > > 
> > > > > > KVM_EXIT_DIRTY_RING_FULL when needed.
> > > > > > 
> > > > > > If soft_limit is hit, KVM_REQ_DIRTY_RING_FULL is set and the next vcpu_run
> > > > > > exits
> > > > > > 
> > > > > > to userspace for QEMU to drain the ring.
> > > > > 
> > > > > So the software dirtying routine would be affected by the soft limit, but 
> > > > > HADBSS exit would not. It means the dirty-ring would be effectively smaller 
> > > > > than specified if we are having mostly sw dirtying.
> > > > > 
> > > > > Did I get that right?
> > > > > 
> > > > > > 
> > > > > > *One more thing: *when userspace sets the dirty ring size via
> > > > > > 
> > > > > > KVM_VM_IOCTL_ENABLE_DIRTY_LOG_RING, we already enforce that
> > > > > > 
> > > > > > size >= kvm_dirty_ring_get_rsvd_entries(kvm) * sizeof(struct kvm_dirty_gfn)
> > > > > > 
> > > > > > or size < PAGE_SIZE. With HDBSS, kvm_dirty_ring_get_rsvd_entries() will
> > > > > > include the
> > > > > > 
> > > > > > HDBSS entries via kvm_cpu_dirty_log_size(), so the same check will
> > > > > > automatically guarantee
> > > > > > 
> > > > > > the ring is large enough to accommodate the HDBSS buffer. No additional
> > > > > > validation is needed.
> > > > > > 
> > > > > 
> > > > 
> > > 
> > > Hi Inochi,
> > > 
> > > > I have a small question on this, since HDBSS supports 2MiB buffer,
> > > > it  will has more entries than the dirty ring.
> > > 
> > > The entries reserved for HDBSS are part of the dirty ring, but I get the 
> > > point: having a dirty-ring with 64k entries and HDBSS with 256k entries 
> > > (2MB/8) would be weird.
> > > 
> > > For the dirty-ring I think the plan is to have HDBSS buffer to be a fraction
> > > of the configured dirty-ring size.
> > > 
> > > > If we use 
> > > > kvm_cpu_dirty_log_size() to reserve entries. It will always enter
> > > > soft limit if the HDBSS buffer is huge. 
> > > > 
> > > 
> > > Yeah, but once HDBSS is active if we enable dirty_tracking, there should 
> > > not be a lot of entries being added to the dirty ring that don't come from 
> > > HDBSS, so it should be fine. If it happens, though, it will just exit guest 
> > > and drain as it happens nowadays.
> > > 
> > 
> > You are true, I found the IOMMU reports the dirty log in a different
> > way, so when enabling HDBSS, the dirty log in this scene should mainly
> > come from HDBSS, which means the limit check mainly replies on the 
> > the state of HDBSS. 
> > 
> > > 
> > > > Since I think users set large buffer expect less context switch.
> > > > I think this may require some change on the dirty ring framework.
> > > > At least I think the soft limit check should be adjusted.
> > > > 
> > > 
> > > That may not be the case: the memory usage of the dirty-ring is 
> > > (16 * dirty_ring_size * vcpus) in bytes. 
> > > 
> > > On a VM with 1024 vcpus, only the HDBSS buffer alone would be 2GB, plus 4GB 
> > > of the reserved dirty-ring for that buffer.
> > > 
> > 
> > Yeah, it is the case, the memory usage is huge in this case, and it
> > also hits the case what I said, the user uses huge buffer to reduce
> > the number of KVM exit.
> 
> Yeah, also possible depending on the workload.
> 
> > 
> > Although it is kind of off topic, I think if a machine can have a
> > VM with 1024 vCPU in production. It should has so much memory (in TB)
> > that it may be acceptable for the a big dirty log buffer in a short
> > time.
> > 
> 
> I get your point, but it depends deeply of the workload. Maybe the user 
> prefers to use those extra GB in the VM instead.
> 
> It's less about how big the VM is, and more about how many pages it's 
> dirtying. There are workloads that keep the writing minimal, so a small 
> ringbuffer should do. 
> 

You are true, this is mainly depends on the type of the workload,
and this information should come from the caller, as the kvm can't
get this information.

Regards,
Inochi

> > > Which brings the discussion: maybe we should have a buffer management 
> > > happen instead of using the reserving strategy: If the buffer does not fit 
> > > in the dirty-ring, just move the remaining entries to the start, adjust the 
> > > index register, and continue. 
> > > 
> > > (On a 2MB size it would be bad, as there could be many remaining entries)
> > > 
> > 
> > I guess this could be something bad in most cases, even a 256KB buffer
> > (32K entry) means we have to move half of the buffer to the start...
> > 
> > > Alternatively, we can just keep guest_exitting until all HDBSS entries fit 
> > > the dirty_ring, which introduce overhead, but should work as well.
> > > 
> > > All options have some tradeoff, though.
> > > 
> > 
> > Right, everything method has some tradeoff, I guess for the first
> > version, just using the alternative method could be a simple idea.
> > This is because the HDBSS does provide an improvement on the dirty
> > log tracking even the implement is not very perfect.
> > 
> 
> True, just by reducing the amount of times a vCPU exits when a memory page 
> gets dirty, there is a lot of performance improvement to get.
> 
> Thanks!
> Leo
