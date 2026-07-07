Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F5A03DA7E3
	for <kvmarm@lists.linux.dev>; Tue,  7 Jul 2026 10:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418846; cv=none; b=umDV9tlHx5QSWliEkYI7fGxkW4QqQlX+wXQDFTmvMymnbPWDVYslko5Ah4j8m+ZW3EzEPiD2MINexcJF+kp+un8RLBu5HriODBT2WvItrbM1SsrUy5lrc75NIjQqidJuw1CN6WIgcst6C5qXIcVBhVfxtkxEfv4Z10zVR+j/d7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418846; c=relaxed/simple;
	bh=efPPuJBmHOVIcmAa1CJwiO+3EKUgUA53PYhTK93MGSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=AIMMtWcMO5uCp4btCYznrjWY4ONeOaMiOvZpv8/hevsH0J4r/0htvElbAwAL8s2V5eJfZuTZUrZ/cajB4FNnMFAw7IxI9BjsYX0H+kyhIE4QnQkinE8ikB0r0JBzAYGserMRaMtxFwcx167SBmLZCkY5FcrAJ4AeC3GQiTawOCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rbe3MZI+; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rbe3MZI+"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31D5C1691;
	Tue,  7 Jul 2026 03:07:19 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5F65D3F85F;
	Tue,  7 Jul 2026 03:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783418843; bh=efPPuJBmHOVIcmAa1CJwiO+3EKUgUA53PYhTK93MGSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbe3MZI++urCP1OCSOL/NfQrdslSkTwiCgeA9Q9anpf+Ns2m6p4JqP36x4i8l1pF5
	 fb29/Ly4R6dJr8KGLT6MsmCN2M8+HWcEEVpszo+08LPmaT06d5iDmLPqkaq/zbRL69
	 uVvTAbUBciXqLYBrviuDehD4/e50rUuQUuj3aL1o=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Inochi Amaoto <inochiama@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	liuyonglong@huawei.com,
	Jonathan.Cameron@huawei.com,
	yezhenyu2@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v3 3/5] KVM: arm64: Add support for FEAT_HDBSS
Date: Tue,  7 Jul 2026 11:07:14 +0100
Message-ID: <akzP0T_Qd9yuZsPI@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <34447d66-8d53-4dc7-82fe-58057f2a5b57@huawei.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com> <20260225040421.2683931-4-zhengtian10@huawei.com> <ahzUUDAMoHtDFJD3@inochi.infowork> <864ijmvdpy.wl-maz@kernel.org> <ah1KLrpYBXSMM91H@inochi.infowork> <22abfaf8-8636-4ed3-9a5c-fb4fdef1bc19@huawei.com> <aku1N23Szkta9uA6@LeoBrasDK> <34447d66-8d53-4dc7-82fe-58057f2a5b57@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jul 07, 2026 at 02:11:23PM +0800, Tian Zheng wrote:
> 
> On 7/6/2026 10:01 PM, Leonardo Bras wrote:
> > On Fri, Jun 05, 2026 at 04:29:49PM +0800, Tian Zheng wrote:
> > > On 6/1/2026 5:05 PM, Inochi Amaoto wrote:
> > > > On Mon, Jun 01, 2026 at 09:58:49AM +0100, Marc Zyngier wrote:
> > > > > On Mon, 01 Jun 2026 01:50:22 +0100,
> > > > > Inochi Amaoto <inochiama@gmail.com> wrote:
> > > > > > On Wed, Feb 25, 2026 at 12:04:19PM +0800, Tian Zheng wrote:
> > > > > > > From: eillon <yezhenyu2@huawei.com>
> > > > > > > 
> > > > > > > Armv9.5 introduces the Hardware Dirty Bit State Structure (HDBSS) feature,
> > > > > > > indicated by ID_AA64MMFR1_EL1.HAFDBS == 0b0100. A CPU capability is added
> > > > > > > to notify the user of the feature.
> > > > > > > 
> > > > > > > Add KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl and basic framework for
> > > > > > > ARM64 HDBSS support. Since the HDBSS buffer size is configurable and
> > > > > > > cannot be determined at KVM initialization, an IOCTL interface is
> > > > > > > required.
> > > > > > > 
> > > > > > > Actually exposing the new capability to user space happens in a later
> > > > > > > patch.
> > > > > > > 
> > > > > > > Signed-off-by: eillon <yezhenyu2@huawei.com>
> > > > > > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > > > > > ---
> > > > > > >    arch/arm64/include/asm/cpufeature.h |  5 +++++
> > > > > > >    arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
> > > > > > >    arch/arm64/tools/cpucaps            |  1 +
> > > > > > >    include/uapi/linux/kvm.h            |  1 +
> > > > > > >    tools/include/uapi/linux/kvm.h      |  1 +
> > > > > > >    5 files changed, 20 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > > > > > > index 4de51f8d92cb..dcc2e2cad5ad 100644
> > > > > > > --- a/arch/arm64/include/asm/cpufeature.h
> > > > > > > +++ b/arch/arm64/include/asm/cpufeature.h
> > > > > > > @@ -856,6 +856,11 @@ static inline bool system_supports_haft(void)
> > > > > > >    	return cpus_have_final_cap(ARM64_HAFT);
> > > > > > >    }
> > > > > > > 
> > > > > > > +static inline bool system_supports_hdbss(void)
> > > > > > > +{
> > > > > > > +	return cpus_have_final_cap(ARM64_HAS_HDBSS);
> > > > > > > +}
> > > > > > > +
> > > > > > >    static __always_inline bool system_supports_mpam(void)
> > > > > > >    {
> > > > > > >    	return alternative_has_cap_unlikely(ARM64_MPAM);
> > > > > > > diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> > > > > > > index c31f8e17732a..348b0afffc3e 100644
> > > > > > > --- a/arch/arm64/kernel/cpufeature.c
> > > > > > > +++ b/arch/arm64/kernel/cpufeature.c
> > > > > > > @@ -2124,6 +2124,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
> > > > > > >    	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
> > > > > > >    }
> > > > > > > 
> > > > > > > +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int cope)
> > > > > > > +{
> > > > > > > +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, cope);
> > > > > > > +}
> > > > > > > +
> > > > > > >    bool cpu_supports_bbml2_noabort(void)
> > > > > > >    {
> > > > > > >    	/*
> > > > > > > @@ -2759,6 +2764,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
> > > > > > >    		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HAFT)
> > > > > > >    	},
> > > > > > >    #endif
> > > > > > > +	{
> > > > > > > +		.desc = "Hardware Dirty state tracking structure (HDBSS)",
> > > > > > > +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> > > > > > > +		.capability = ARM64_HAS_HDBSS,
> > > > > > > +		.matches = has_vhe_hdbss,
> > > > > > > +		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HDBSS)
> > > > > > > +	},
> > > > > > >    	{
> > > > > > >    		.desc = "CRC32 instructions",
> > > > > > >    		.capability = ARM64_HAS_CRC32,
> > > > > > > diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> > > > > > > index 7261553b644b..f6ece5b85532 100644
> > > > > > > --- a/arch/arm64/tools/cpucaps
> > > > > > > +++ b/arch/arm64/tools/cpucaps
> > > > > > > @@ -68,6 +68,7 @@ HAS_VA52
> > > > > > >    HAS_VIRT_HOST_EXTN
> > > > > > >    HAS_WFXT
> > > > > > >    HAS_XNX
> > > > > > > +HAS_HDBSS
> > > > > > >    HAFT
> > > > > > >    HW_DBM
> > > > > > >    KVM_HVHE
> > > > > > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > > > > > index 65500f5db379..15ee42cdbd51 100644
> > > > > > > --- a/include/uapi/linux/kvm.h
> > > > > > > +++ b/include/uapi/linux/kvm.h
> > > > > > > @@ -985,6 +985,7 @@ struct kvm_enable_cap {
> > > > > > >    #define KVM_CAP_ARM_SEA_TO_USER 245
> > > > > > >    #define KVM_CAP_S390_USER_OPEREXEC 246
> > > > > > >    #define KVM_CAP_S390_KEYOP 247
> > > > > > > +#define KVM_CAP_ARM_HW_DIRTY_STATE_TRACK 248
> > > > > > > 
> > > > > > >    struct kvm_irq_routing_irqchip {
> > > > > > >    	__u32 irqchip;
> > > > > > > diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> > > > > > > index dddb781b0507..93e0a1e14dc7 100644
> > > > > > > --- a/tools/include/uapi/linux/kvm.h
> > > > > > > +++ b/tools/include/uapi/linux/kvm.h
> > > > > > > @@ -974,6 +974,7 @@ struct kvm_enable_cap {
> > > > > > >    #define KVM_CAP_GUEST_MEMFD_FLAGS 244
> > > > > > >    #define KVM_CAP_ARM_SEA_TO_USER 245
> > > > > > >    #define KVM_CAP_S390_USER_OPEREXEC 246
> > > > > > > +#define KVM_CAP_ARM_HW_DIRTY_STATE_TRACK 248
> > > > > > > 
> > > > > > >    struct kvm_irq_routing_irqchip {
> > > > > > >    	__u32 irqchip;
> > > > > > > --
> > > > > > > 2.33.0
> > > > > > > 
> > > > > > Instead of having these architecture specific capability, I wonder if
> > > > > > we can add a generic capability like "KVM_CAP_HW_DIRTY_STATE", so
> > > > > > other architecture supports similar things can reuse this capability,
> > > > > What of the existing stuff doing the same thing? x86's PML, to start
> > > > > with?
> > > > > 
> > > > In fact I think the HDBSS is the first one with non-fixed size.
> > > > Although there is a in process RISC-V extension for it, there will
> > > > be a long story to make it ratified.
> > > > 
> > > > > > For this generic thing I suggest, the getter returns the max support
> > > > > > entry count (or the buffer size) it supports like the dirty ring
> > > > > > capability. And the setter just let the architecture set the parameters
> > > > > > based on the user request.
> > > > > This looks wrong on a number of levels.
> > > > > 
> > > > > - If you want something generic, there is the existing dirty
> > > > >     log/bitmap. How this stuff is populated is none of the user's
> > > > >     business (trapping write accesses, dirty bit collection from the
> > > > >     PTs, or HW-generated log), and we don't need an extra feature for
> > > > >     it. Performance will obviously suck, but that's what you pay for
> > > > >     something abstracted and cross-architecture.
> > > > > 
> > > > > - If you want something architecture specific, then it can't be
> > > > >     generic, by definition. You get the raw speed and compatibility with
> > > > >     other arch-specific extensions.
> > > > > 
> > > > OK, I agree, it is better to keep this thing arch-specific. Doing a
> > > > generic thing does not benefit too much, I have made a mistake on
> > > > it. Thanks for your kindly explanation.
> > > 
> > > Awesome. Thanks for the review.
> > > 
> > > I agree with Marc—keeping this ARM-specific is the right approach.
> > > Also, in v4 we're removing the ioctl interface entirely. HDBSS will be
> > > auto-enabled during migration setup and auto-disabled when migration
> > > completes, so the capability naming issue becomes moot.
> > > 
> > > I plan to post v4 with the updated approach soon.
> > Hi Tian,
> > 
> > Any updates in the v4?
> > Please let me know if you want help in any kind, in regards to this
> > patchset.
> > 
> > Thanks!
> > Leo
> Hi Leo,
> 
> Thanks for the follow-up. I've finished polishing v4 and am doing one last
> internal review.
> 
> In this version, I've also aligned with the latest HACDBS v2 implementation
> you shared—e.g.,
> auto-inserting KVM_PGTABLE_S2_DBM into pgt->flags during
> kvm_init_stage2_mmu.
> 
> One note: dirty ring mode is not yet supported in v4—the series currently
> focuses on the
> dirty bitmap mode. I'll explicitly call this out in the commit messages
> (including that
> KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE and related dirty ring components are
> omitted) to avoid
> any confusion during review.
> 
> I plan to send v4 out later this week.
> 
> Thanks,
> Tian

Hi Tian,

Awesome! Thanks for letting me know!
Leo
