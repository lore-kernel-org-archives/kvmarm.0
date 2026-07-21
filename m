Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B503B3C1094
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 08:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784624052; cv=none; b=BUKw4I/KODc8hy1sA+Ju7XrGu5bOeYjjQn80tb6v7gUaemmVcLe8HI/4VD3tENcm5nK83Auj6+W7nwLCizmoKtHCAEK5f2bjjiwp0IJV2QSIAG9CmxkrjV6mTigco749XHz7GrDyDyuUPqluxbLf0GdHNSF22AxYbvJb+hsIdQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784624052; c=relaxed/simple;
	bh=nIH4MQBe9M8OOY9iX/bLHALNOYWH4Ir+n49HIaM77Dk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpXo5C1ZzG82chqC42nKL5lJn3m/v1WpmANASzqj/qMvPRJTnB4DXOPMnxFVy4rsB+T6y3v9UCFHbZG8iJLwMxGVJR6CvMxQuLqGlTthLGKDR5PRtufUzefVJ+/u6mE5dZnhYWwCJywt44D2WFTSWWwC9gGEwTgpuLG1H10ssNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZDZjimj; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZDZjimj"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2caced6038eso64228555ad.0
        for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 01:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784624046; x=1785228846; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4OeYd0Gbibz5fAUsd+Mr4BvJ/WpM3GNs0QGDm7c5YpE=;
        b=mZDZjimj2nZnwzPBLi+LsyCUyZwIbhUPVwPcylUpq6usML4QCvIOqiIyrMstAdS4EF
         pvYODUpwseolBcuTcRGVn1OZVzPVl5yEn0wkJUl+AumiNfTyNmKUbFyJk1jiHD/Kyauk
         o39+NWOuS6DaaUfAtZTGe53MNhdIalSdgR+/tC298R0RQ6nbE1p3dn9//6sdFJbVVpPy
         RnFw4fdpFebELhMbQYZglTaZl5vzCZaNeYU9/ZHYMhKsRIUOFTeQMWgK+zvnuhJE1Isg
         yFQu5SRo+zHIlDfjV5TLhIUTrZyYXnQ4ZmqvWNnk6/1wsIBjA80UBE29UbkwqvSFwPxG
         zDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784624046; x=1785228846;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4OeYd0Gbibz5fAUsd+Mr4BvJ/WpM3GNs0QGDm7c5YpE=;
        b=kgdVkAesVpOSif8fkbhbpizmRFHatR0mimnX4xmiybB4GjWiOX3bo0qN+sdurljkv2
         x2+iLboyH6TTKNLrM1h3hZkAuvr4roWzsQDKAqznXQZLpdSr4a8MW8EqyDuTmdCmoMVG
         qAPqhWjR2vDzDLXgD8x/EtrWJG8Mf7fsuSJCxf+rA/+AF+MkV8P0D/QyFuDtrwmM78Fm
         YA2UcY90/KeouxICN76LoxOQQNwOhFAyXMWbB30v7yX83JdBoPa18EVOPGcJ/DkJNEOE
         lhLudG+Bltve6MHihcxEjDGYGwu9YRJz4e2uMRC1J7ZxwqjyGovYJEAOimwV2j8J9lwo
         /hyw==
X-Forwarded-Encrypted: i=1; AHgh+RoUc1PauWKGwxMVKuJpdeyDN6GR+V/rQMtwX2Fy9Y/DXSmIbBn0nJVWR+YEGbW55Z2q6/IIp48=@lists.linux.dev
X-Gm-Message-State: AOJu0YwczN6y0Alx//qXonep6KnnwmaH9C1d1cG4sD7Az5SRznEhqJvG
	tfIJi0XJ8gQeyEsBtJ0LnSQ70CKpTceMfKt3DMkP6zLzhs4Xigyv6MOv
X-Gm-Gg: AR+sD10VMdxsMuUYHmzv2F9toHECJAWSx9LmBdQlOTIXHrB/3LaPjxLRtlFH2Kt0mf1
	GQZTJ4wcHuuLo+eIKQnlQxHgYEF5JRjieCPQvscd+cUXeweqxunVwh/UEE6ZApJhO1zMIFwq32l
	AoanzIVL5DKqqWTqSiiJgKX3xQq7uXhn8i4SFgEyCaL5lJ5ECJDjC0nrgbPQ0duCUtGJMmUI5IV
	beqvn7kILUoOFcKvjH5CiVgJudcGSx40VlI4yAEjvDt8Z1sIC7Ncdj9SquTRwNCq5ORQZk89BOR
	tvq14UUql6LduiiOOFoscD218qNjw1j76Sq6MLjTUP2iRZSQ1PTq5k+3n/YiJTsiXsVEPUybwyx
	7CCTQIZVPhQu1yPa+4PR8PdkA7ajXM1Y2eTu+HBRKTeCVF3D9RqFGGcQm9T5nX5za
X-Received: by 2002:a17:903:1249:b0:2c9:d277:2cdb with SMTP id d9443c01a7336-2cf3489529cmr174162115ad.9.1784624045533;
        Tue, 21 Jul 2026 01:54:05 -0700 (PDT)
Received: from localhost ([2001:da8:7001:11::cb])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf3476f70esm70963755ad.77.2026.07.21.01.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 01:54:05 -0700 (PDT)
Date: Tue, 21 Jul 2026 16:53:08 +0800
From: Inochi Amaoto <inochiama@gmail.com>
To: Leonardo Bras <leo.bras@arm.com>, Tian Zheng <zhengtian10@huawei.com>
Cc: maz@kernel.org, oupton@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, yuzenghui@huawei.com, wangzhou1@hisilicon.com, 
	yangjinqian1@huawei.com, caijian11@h-partners.com, liuyonglong@huawei.com, 
	yezhenyu2@huawei.com, yubihong@huawei.com, linuxarm@huawei.com, joey.gouly@arm.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	Inochi Amaoto <inochiama@gmail.com>
Subject: Re: [PATCH v4 5/6] KVM: arm64: Add HDBSS fault handling and buffer
 flush
Message-ID: <al8xreH4_RoL5P83@inochi.infowork>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-6-zhengtian10@huawei.com>
 <alTw0nwiBDWoFrjB@LeoBrasDK>
 <9340fa94-6f26-4053-a4ca-0803af725936@huawei.com>
 <alYUXkub43YxkeH1@LeoBrasDK>
 <fa0839f9-7d83-4ad1-80e2-7e7dd0280222@huawei.com>
 <alZFVPkS3lgGdruc@LeoBrasDK>
 <3fb4b33e-4618-4523-b140-955e15fd9a8c@huawei.com>
 <alpN16Q3MgVHJzsN@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpN16Q3MgVHJzsN@LeoBrasDK>

On Fri, Jul 17, 2026 at 04:44:24PM +0100, Leonardo Bras wrote:
> On Fri, Jul 17, 2026 at 02:51:12PM +0800, Tian Zheng wrote:
> > 
> > On 7/14/2026 10:19 PM, Leonardo Bras wrote:
> > > On Tue, Jul 14, 2026 at 09:27:15PM +0800, Tian Zheng wrote:
> > > > On 7/14/2026 6:50 PM, Leonardo Bras wrote:
> > > > > On Tue, Jul 14, 2026 at 03:38:39PM +0800, Tian Zheng wrote:
> > > > > > On 7/13/2026 10:06 PM, Leonardo Bras wrote:
> > > > > > > On Thu, Jul 09, 2026 at 06:40:25PM +0800, Tian Zheng wrote:
> > > > > > > > From: eillon <yezhenyu2@huawei.com>
> > > > > > > > 
> > > > > > > > Add HDBSS fault handling for buffer full, external abort, and general
> > > > > > > > protection fault (GPF) events. When the HDBSS buffer becomes full,
> > > > > > > > the hardware traps to EL2 with an HDBSSF event, which is handled by
> > > > > > > > setting a flush request.
> > > > > > > > 
> > > > > > > > Add kvm_flush_hdbss_buffer() to consume HDBSS buffer entries and
> > > > > > > > propagate dirty information into the userspace-visible dirty bitmap.
> > > > > > > > Flush is triggered on vcpu_put, check_vcpu_requests, and
> > > > > > > > sync_dirty_log.
> > > > > > > > 
> > > > > > > > Add esr_iss2_is_hdbssf() helper for HDBSS fault detection in guest
> > > > > > > > abort handling.
> > > > > > > > 
> > > > > > > > Signed-off-by: Eillon <yezhenyu2@huawei.com>
> > > > > > > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > > > > > > ---
> > > > > > > >     arch/arm64/include/asm/esr.h           |  5 +++
> > > > > > > >     arch/arm64/include/asm/kvm_dirty_bit.h | 11 +++++
> > > > > > > >     arch/arm64/include/asm/kvm_host.h      |  1 +
> > > > > > > >     arch/arm64/kvm/arm.c                   | 14 ++++++
> > > > > > > >     arch/arm64/kvm/dirty_bit.c             | 62 ++++++++++++++++++++++++++
> > > > > > > >     arch/arm64/kvm/mmu.c                   |  4 ++
> > > > > > > >     6 files changed, 97 insertions(+)
> > > > > > > > 
> > > > > > > > diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> > > > > > > > index 81c17320a588..2e6b679b5908 100644
> > > > > > > > --- a/arch/arm64/include/asm/esr.h
> > > > > > > > +++ b/arch/arm64/include/asm/esr.h
> > > > > > > > @@ -437,6 +437,11 @@
> > > > > > > >     #ifndef __ASSEMBLER__
> > > > > > > >     #include <asm/types.h>
> > > > > > > > 
> > > > > > > > +static inline bool esr_iss2_is_hdbssf(unsigned long esr)
> > > > > > > > +{
> > > > > > > > +	return ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF;
> > > > > > > This will return a long, which will be casted as bool.
> > > > > > > In general, what I see in the kernel is something like:
> > > > > > > 
> > > > > > > 	return !!(ESR_ELx_ISS2(esr) & ESR_ELx_HDBSSF)
> > > > > > ok!
> > > > > > 
> > > > > > 
> > > > > > > > +}
> > > > > > > > +
> > > > > > > >     static inline unsigned long esr_brk_comment(unsigned long esr)
> > > > > > > >     {
> > > > > > > >     	return esr & ESR_ELx_BRK64_ISS_COMMENT_MASK;
> > > > > > > > diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > > > > index 84b12f0a10af..4b28000e972f 100644
> > > > > > > > --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > > > > +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > > > > @@ -10,7 +10,18 @@
> > > > > > > >     #include <asm/kvm_pgtable.h>
> > > > > > > >     #include <asm/sysreg.h>
> > > > > > > > 
> > > > > > > > +/* HDBSS entry field definitions */
> > > > > > > > +#define HDBSS_ENTRY_VALID	BIT(0)
> > > > > > > > +#define HDBSS_ENTRY_TTWL_SHIFT (1)
> > > > > > > > +#define HDBSS_ENTRY_TTWL_MASK (GENMASK(3, 1))
> > > > > > > > +#define HDBSS_ENTRY_TTWL(x) \
> > > > > > > > +	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
> > > > > > > > +#define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
> > > > > > > > +#define HDBSS_ENTRY_IPA	GENMASK_ULL(55, 12)
> > > > > > > > +
> > > > > > > >     int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
> > > > > > > >     void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> > > > > > > > +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu);
> > > > > > > > +int kvm_handle_hdbss_fault(struct kvm_vcpu *vcpu);
> > > > > > > > 
> > > > > > > >     #endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> > > > > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > > > > > index c41ec6d9c45a..cecfb884a64f 100644
> > > > > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > > > > @@ -55,6 +55,7 @@
> > > > > > > >     #define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
> > > > > > > >     #define KVM_REQ_MAP_L1_VNCR_EL2		KVM_ARCH_REQ(10)
> > > > > > > >     #define KVM_REQ_VGIC_PROCESS_UPDATE	KVM_ARCH_REQ(11)
> > > > > > > > +#define KVM_REQ_FLUSH_HDBSS			KVM_ARCH_REQ(12)
> > > > > > > > 
> > > > > > > >     #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
> > > > > > > >     				     KVM_DIRTY_LOG_INITIALLY_SET)
> > > > > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > > > > index bf6688245d83..566953a4e23a 100644
> > > > > > > > --- a/arch/arm64/kvm/arm.c
> > > > > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > > > > @@ -755,6 +755,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> > > > > > > >     		kvm_vcpu_put_hw_mmu(vcpu);
> > > > > > > >     	kvm_arm_vmid_clear_active();
> > > > > > > > 
> > > > > > > > +	if (vcpu->kvm->arch.enable_hdbss)
> > > > > > > > +		kvm_flush_hdbss_buffer(vcpu);
> > > > > > > > +
> > > > > > > >     	vcpu_clear_on_unsupported_cpu(vcpu);
> > > > > > > >     	vcpu->cpu = -1;
> > > > > > > >     }
> > > > > > > > @@ -1157,6 +1160,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
> > > > > > > >     		if (kvm_dirty_ring_check_request(vcpu))
> > > > > > > >     			return 0;
> > > > > > > > 
> > > > > > > > +		if (kvm_check_request(KVM_REQ_FLUSH_HDBSS, vcpu))
> > > > > > > > +			kvm_flush_hdbss_buffer(vcpu);
> > > > > > > > +
> > > > > > > >     		check_nested_vcpu_requests(vcpu);
> > > > > > > >     	}
> > > > > > > > 
> > > > > > > > @@ -1971,7 +1977,15 @@ long kvm_arch_vcpu_unlocked_ioctl(struct file *filp, unsigned int ioctl,
> > > > > > > > 
> > > > > > > >     void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
> > > > > > > >     {
> > > > > > > > +	/*
> > > > > > > > +	 * Flush all CPUs' dirty log buffers to the dirty_bitmap.  Called
> > > > > > > > +	 * before reporting dirty_bitmap to userspace. Send a request with
> > > > > > > > +	 * KVM_REQUEST_WAIT to flush buffer synchronously.
> > > > > > > > +	 */
> > > > > > > > +	if (!kvm->arch.enable_hdbss)
> > > > > > > > +		return;
> > > > > > > > 
> > > > > > > > +	kvm_make_all_cpus_request(kvm, KVM_REQ_FLUSH_HDBSS | KVM_REQUEST_WAIT);
> > > > > > > >     }
> > > > > > > > 
> > > > > > > >     static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
> > > > > > > > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > > > > > > > index 6c7a6ef66b5a..002366337637 100644
> > > > > > > > --- a/arch/arm64/kvm/dirty_bit.c
> > > > > > > > +++ b/arch/arm64/kvm/dirty_bit.c
> > > > > > > > @@ -50,3 +50,65 @@ void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> > > > > > > > 
> > > > > > > >     	vcpu->arch.hdbss.hdbssbr_el2 = 0;
> > > > > > > >     }
> > > > > > > > +
> > > > > > > > +void kvm_flush_hdbss_buffer(struct kvm_vcpu *vcpu)
> > > > > > > > +{
> > > > > > > > +	int idx, curr_idx;
> > > > > > > > +	u64 *hdbss_buf;
> > > > > > > > +	struct kvm *kvm = vcpu->kvm;
> > > > > > > > +
> > > > > > > > +	if (!kvm->arch.enable_hdbss)
> > > > > > > > +		return;
> > > > > > > > +
> > > > > > > > +	curr_idx = HDBSSPROD_IDX(read_sysreg_s(SYS_HDBSSPROD_EL2));
> > > > > > > > +
> > > > > > > > +	/* Do nothing if HDBSS buffer is empty or br_el2 is NULL */
> > > > > > > > +	if (curr_idx == 0 || vcpu->arch.hdbss.hdbssbr_el2 == 0)
> > > > > > > > +		return;
> > > > > > > > +
> > > > > > > > +	hdbss_buf = page_address(phys_to_page(vcpu->arch.hdbss.base_phys));
> > > > > > > > +	if (!hdbss_buf)
> > > > > > > > +		return;
> > > > > > > > +
> > > > > > > > +	guard(write_lock_irqsave)(&vcpu->kvm->mmu_lock);
> > > > > > > > +	for (idx = 0; idx < curr_idx; idx++) {
> > > > > > > > +		u64 gpa;
> > > > > > > > +
> > > > > > > > +		gpa = hdbss_buf[idx];
> > > > > > > > +		if (!(gpa & HDBSS_ENTRY_VALID))
> > > > > > > > +			continue;
> > > > > > > > +
> > > > > > > > +		gpa &= HDBSS_ENTRY_IPA;
> > > > > > > > +		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
> > > > > > > You mention that it does not support dirty-ring, but above function will
> > > > > > > mark the page as dirty in the dirty-ring :/
> > > > > > > 
> > > > > > In kvm_arm_enable_hdbss_global(), we explicitly check and reject HDBSS
> > > > > > enablement if dirty-ring is active:
> > > > > > 
> > > > > > ```
> > > > > > if (kvm->dirty_ring_size)
> > > > > >       return 0;
> > > > > > ```
> > > > > > 
> > > > > > So when kvm_flush_hdbss_buffer() runs (which requires enable_hdbss = true),
> > > > > > we know for certain that
> > > > > > 
> > > > > > kvm->dirty_ring_size == 0. Therefore, kvm_vcpu_mark_page_dirty() will always
> > > > > > take the dirty_bitmap path,
> > > > > > 
> > > > > > never the dirty-ring path.
> > > > > > 
> > > > > > That said, I'll add a comment in kvm_flush_hdbss_buffer() before dirty ring
> > > > > > mode is supported, to make this explicit:
> > > > > > 
> > > > > > ```
> > > > > > /*
> > > > > >    * HDBSS is mutually exclusive with dirty-ring mode (see
> > > > > >    * kvm_arm_enable_hdbss_global()), so kvm_vcpu_mark_page_dirty()
> > > > > >    * will update the dirty_bitmap, not the dirty-ring.
> > > > > >    */
> > > > > > ```
> > > > > > 
> > > > > Got it :)
> > > > > 
> > > > > Out of curiosity: which issues have you found on supporting dirty-ring at
> > > > > this point?
> > > > > 
> > > > > Thanks!
> > > > > Leo
> > > > 
> > > > I haven't looked deeply into dirty-ring yet — my main concern is that if
> > > > both the dirty
> > > > 
> > > > ring and HDBSS buffer fill up, the flush path might get blocked or
> > > > complicated.
> > > > 
> > > > For now, I'm planning to match the HDBSS buffer size to the dirty ring size
> > > > in v5 and test it.
> > > > 
> > > > Ideally, the two buffers would be the same size, and the entire dirty
> > > > tracking path would use
> > > > 
> > > Ah, I see the point.
> > > 
> > > IIRC, when dirty-ring gets full, the kernel returns to userspace with
> > > run->exit_reason == KVM_EXIT_DIRTY_RING_FULL, which will warn the VMM to
> > > drain the dirty-ring, and that makes space for us draining HDBSS to the
> > > dirty-ring again.
> > > 
> > > The best way to achieve that, as I remember, is to always drain
> > > HDBSS as much as possible at guest_exitting. That will make more space to
> > > newer HDBSS entries, and we can get userspace to drain the dirty-ring
> > > earlier.
> > > 
> > > I would say to even make HDBSS buffer half (entries) the dirty-ring. Then
> > > we can generally fully drain to the dirty-ring and even report ring full
> > > if the ring is above a given threshold percentage full.
> > > > HDBSS exclusively — no fallback to the legacy dirty bitmap path. If that
> > > > works, I think this approach should be fine.
> > > > 
> > > > Let me know if you have any insights on dirty ring's full-buffer behavior —
> > > > that would be helpful.
> > > > 
> > > > 
> > > Will do!
> > > 
> > > Thanks!
> > > Leo
> > 
> > 
> > Thanks for the insights — reusing PML's reservation mechanism makes sense.
> > 
> > I think we can*keep the HDBSS buffer at 512 entries* (matching
> 
> I recommend using a PAGESIZE (512 in 4k, but bigger in other sizes)
> 
> > PML_LOG_NR_ENTRIES)
> > 
> > for now, and *not expose any ioctl for userspace to configure it*. Since the
> > kernel
> > 
> > auto-enables HDBSS, a userspace size knob would be confusing.
> > 
> 
> Humm, I am in favor of letting the user change it according to it's 
> workload. Why would that be confusing?
> 
> (Having a default size is useful just for enabling it to work without any 
> change in current VMs)
> 
> > 
> > The reservation logic would be:
> > 
> > - Implement kvm_cpu_dirty_log_size() on arm64 to return the HDBSS buffer
> > entry
> > 
> > count (512, or 0 if HDBSS is not enabled)
> 
> Why a get to log_size? does userspace need to know it's using HDBSS?
> 
> Just a set should do, as VMMs can just try to set a value, and if it fails 
> (IOCTL does not exist, or invalid value), then it can just go forward. 
> 
> > 
> > - Reuse kvm_dirty_ring_get_rsvd_entries() to reserve space for one full
> > flush:
> > 
> > KVM_DIRTY_RING_RSVD_ENTRIES + hdbss_entries
> > 
> > - So soft_limit = dirty_ring_size - (KVM_DIRTY_RING_RSVD_ENTRIES +
> > hdbss_entries),
> > 
> > guaranteeing a full flush always fits
> > 
> > kvm_flush_hdbss_buffer() at guest_exit pushes via mark_page_dirty_in_slot()
> > ->
> > 
> 
> I think I get the point here: since we can have sw dirtying as well as 
> HDBSS tracking, we may get to the point that we don't have enough space to 
> flush hdbss -> dirty-ring, right?
> 
> > kvm_dirty_ring_push() -> kvm_dirty_ring_soft_full, which triggers
> > 
> > KVM_EXIT_DIRTY_RING_FULL when needed.
> > 
> > If soft_limit is hit, KVM_REQ_DIRTY_RING_FULL is set and the next vcpu_run
> > exits
> > 
> > to userspace for QEMU to drain the ring.
> 
> So the software dirtying routine would be affected by the soft limit, but 
> HADBSS exit would not. It means the dirty-ring would be effectively smaller 
> than specified if we are having mostly sw dirtying.
> 
> Did I get that right?
> 
> > 
> > *One more thing: *when userspace sets the dirty ring size via
> > 
> > KVM_VM_IOCTL_ENABLE_DIRTY_LOG_RING, we already enforce that
> > 
> > size >= kvm_dirty_ring_get_rsvd_entries(kvm) * sizeof(struct kvm_dirty_gfn)
> > 
> > or size < PAGE_SIZE. With HDBSS, kvm_dirty_ring_get_rsvd_entries() will
> > include the
> > 
> > HDBSS entries via kvm_cpu_dirty_log_size(), so the same check will
> > automatically guarantee
> > 
> > the ring is large enough to accommodate the HDBSS buffer. No additional
> > validation is needed.
> > 
> 

I have a small question on this, since HDBSS supports 2MiB buffer,
it  will has more entries than the dirty ring. If we use 
kvm_cpu_dirty_log_size() to reserve entries. It will always enter
soft limit if the HDBSS buffer is huge. 

Since I think users set large buffer expect less context switch.
I think this may require some change on the dirty ring framework.
At least I think the soft limit check should be adjusted.

> An alternative is moving the remaining array entries to the beginning of 
> the array, and setting the registers accordingly. The tradeoff is an 
> overhead here vs having the full size of the array available later.
> 
> Thanks!
> Leo
> 

Regards,
Inochi
