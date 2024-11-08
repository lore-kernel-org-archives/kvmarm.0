Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FB91CF7CE;
	Fri,  8 Nov 2024 07:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731052782; cv=none; b=Lswsq8eBe65qD0cyRo5C5eM0x16mmrzYmZ8fRVVbbzI++RzCtVnr5CyRrgoio+TZGJmdAjQJhj2ESnUnKQme7SI1JXZL3MCi6y9MCUJyJuXG5a9t9NZXn58g1XDojBJuQIB9AnulaZgw9Bl7IFeLyQsWzKdJmVoqquqWW/n7VCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731052782; c=relaxed/simple;
	bh=EO7Z4zvCk/UsSG14xv8TEfSSfqqJKLfDfoNZA0RtGkI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=I4NqUTtpcddAwHcKP902/HtfGTzN72+rpWFj4tfH/G59lzWd2A3MeIpScjYRaSEtNRTZF/ZsKnGdF0WxmPdghQlGpdOXoy9DORgEJuGNwyQLjfA8vQJZ4QB57uBJ4kEHFhm4AzpJiwcEs6VqPxGX4vdVGodJPgHhKe9lMLq5gL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bxQqzu6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bxQqzu6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C6AC4CECE;
	Fri,  8 Nov 2024 07:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731052782;
	bh=EO7Z4zvCk/UsSG14xv8TEfSSfqqJKLfDfoNZA0RtGkI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bxQqzu6cUkfia6eaRqGS1gWAo0hY3k7lqFuouonM8f7aPCLIboaPkh/Ie4n/a405c
	 cYynFFL3ou8C/GDnXLw3EY3JzQuLACMOF0GEqFNDuw80yaCgCInH8vdz0bJmKZO8rU
	 kTLo2ZoKbYDfQYIQrxG8eI7DRUD+IRJxvAdY95ovYVMBAIUVZRi2SqzC5Qp7QEQ54E
	 eooY/Bgj29zNV/Yl0QU8XUuC0klgl2A56QpSmj+q3rveyy8NGbdyUooVstW72F/wvL
	 fXF481geV1tjFEPWDVnSqfo1iwes3+6IbwZG3sDn/Fl+vPreDWrhvGJoxUzChq2aJ7
	 Tf/O4m+zrGJYw==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 4/4] arm64: mte: Use stage-2 NoTagAccess memory
 attribute if supported
In-Reply-To: <87jzdst6os.wl-maz@kernel.org>
References: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
 <20241028094014.2596619-5-aneesh.kumar@kernel.org>
 <87o734ts4m.wl-maz@kernel.org> <yq5ar080cq5x.fsf@kernel.org>
 <87jzdst6os.wl-maz@kernel.org>
Date: Fri, 08 Nov 2024 13:29:31 +0530
Message-ID: <yq5a34k2rw9o.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Hi Marc,

Sorry for the delay in response, I was looking at nested virt and
migration changes so that I can get your feedback on those.

Marc Zyngier <maz@kernel.org> writes:

> On Mon, 28 Oct 2024 13:28:42 +0000,
> Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
>>
>> Marc Zyngier <maz@kernel.org> writes:
>>
>> > On Mon, 28 Oct 2024 09:40:14 +0000,
>> > "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>> >>
>> >> Currently, the kernel won't start a guest if the MTE feature is enabled
>> >> and the guest RAM is backed by memory which doesn't support access tags.
>> >> Update this such that the kernel uses the NoTagAccess memory attribute
>> >> while mapping pages from VMAs for which MTE is not allowed. The fault
>> >> from accessing the access tags with such pages is forwarded to VMM so
>> >> that VMM can decide to kill the guest or remap the pages so that
>> >> access tag storage is allowed.
>> >
>> > I only have questions here:
>> >
>> > - what is the benefit of such approach? why shouldn't that be the
>> >   kernel's job to fix it?
>>
>>
>> IMHO leaving that policy decision to VMM makes the kernel changes
>> simpler. In most cases, VMM will kill the guest, because these
>> restrictions of MTE_ALLOWED are applied at the memslot/vma.
>
> Where is that captured? The whole idea behind FEAT_MTE_PERM was that
> it would be the hypervisor's task to lazily allocate MTE-capable
> memory as tagged-access would occur.
>

Lazily allocating MTE-capable memory requires changes to different
kernel subsystems and previous attempts got dropped [1] because it
was not clear whether the benefit of saving 3% memory overhead was worth
the complexity we add to the kernel.

This patchset is not looking at that feature. Instead, it can be used to
enable MTE in configurations that currently won't allow MTE. One such
example is libkrun which includes linux kernel as firmware in a
dynamically linked library (libkrunfw). libkrun can insert the kernel
region which got mmaped as part of the library load, directly into the
guest memory map instead of copying the kernel. Such a guest config
can't enable MTE currently even though we will never use the newly
inserted memory regions as tag access memory.

Similarly, virtiofs dax support can use a page cache region as
virtio-shm region. We can use MTE_PERM to enable MTE in this config.

[1] https://lore.kernel.org/all/20240125164256.4147-1-alexandru.elisei@arm.com/

>>
>> >
>> > - where is the documentation for this new userspace ABI?
>> >
>>
>> I will add the details if we agree that this should be a separate EXIT
>> as outlined in this patch.
>
> Woooot??? This isn't a *DETAIL*. This is the very first thing you
> should write. Everything *else* is an implementation detail.
>
>>
>> >
>> > - are you expecting the VMM to create a new memslot for this?
>> >
>>
>> I guess there are examples of configs where some memory regions are
>> backed by page cache where we don't directly use those memory regions as
>> allocatable memory in the guest. This change allows us to enable MTE in such
>> configs.
>
> This doesn't answer my question. What is expected sequence a VMM
> should apply to provide tagged memory to the guest?
>
>>
>> > - where is the example of a VMM using this?
>> >
>>
>> I do have changes to kvmtool which won't do any fixup on receiving that
>> VM exit. I expect other VMM to do the same by default when they get a
>> VM exit with an unknown exit_reason. So unless VMM wants to do any
>> special handling, we don't need any change in the VMM.
>
> OK, so this has never been tested. I'm sorry, but for something of
> this magnitude, with expected userspace interactions, and requiring
> VMM handling, I want to see the full end-to-end thing.
>
>>
>>
>> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
>> index 3b95750ecec7..4760bad07476 100644
>> --- a/arm/kvm-cpu.c
>> +++ b/arm/kvm-cpu.c
>> @@ -239,6 +239,17 @@ static bool handle_memoryfault(struct kvm_cpu *vcpu)
>>  	return true;
>>  }
>>
>> +static bool handle_notag_access(struct kvm_cpu *vcpu)
>> +{
>> +	u64 gpa = vcpu->kvm_run->memory_fault.gpa;
>> +	u64 size = vcpu->kvm_run->memory_fault.size;
>> +
>> +	/* For now VMM just panic */
>> +	pr_err("Tag Access to a wrong memory region 0x%lx size 0x%lx\n",
>> +	       (unsigned long)gpa, (unsigned long)size);
>> +	return false;
>> +}
>> +
>>  bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
>>  {
>>  	switch (vcpu->kvm_run->exit_reason) {
>> @@ -246,6 +257,8 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
>>  		return handle_hypercall(vcpu);
>>  	case KVM_EXIT_MEMORY_FAULT:
>>  		return handle_memoryfault(vcpu);
>> +	case KVM_EXIT_ARM_NOTAG_ACCESS:
>> +		return handle_notag_access(vcpu);
>>  	}
>>
>>  	return false;
>> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
>> index 32cff22f0e4d..deef6614f577 100644
>> --- a/include/linux/kvm.h
>> +++ b/include/linux/kvm.h
>> @@ -178,6 +178,7 @@ struct kvm_xen_exit {
>>  #define KVM_EXIT_NOTIFY           37
>>  #define KVM_EXIT_LOONGARCH_IOCSR  38
>>  #define KVM_EXIT_MEMORY_FAULT     39
>> +#define KVM_EXIT_ARM_NOTAG_ACCESS 40
>>
>>  /* For KVM_EXIT_INTERNAL_ERROR */
>>  /* Emulate instruction failed. */
>> @@ -429,10 +430,17 @@ struct kvm_run {
>>  		/* KVM_EXIT_MEMORY_FAULT */
>>  		struct {
>>  #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
>> +#define KVM_MEMORY_EXIT_FLAG_NOTAGACCESS (1ULL << 4)
>>  			__u64 flags;
>>  			__u64 gpa;
>>  			__u64 size;
>>  		} memory_fault;
>> +  		/* KVM_EXIT_ARM_NOTAG_ACCESS */
>> +		struct {
>> +			__u64 flags;
>> +			__u64 gpa;
>> +			__u64 size;
>> +		} notag_access;
>>  		/* Fix the size of the union. */
>>  		char padding[256];
>>  	};
>>
>> >>
>> >> NOTE: We could also use KVM_EXIT_MEMORY_FAULT for this. I chose to
>> >> add a new EXIT type because this is arm64 specific exit type.
>> >>
>> >> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> >> ---
>> >>  arch/arm64/include/asm/kvm_emulate.h |  5 +++++
>> >>  arch/arm64/include/asm/kvm_pgtable.h |  1 +
>> >>  arch/arm64/kvm/hyp/pgtable.c         | 16 +++++++++++++---
>> >>  arch/arm64/kvm/mmu.c                 | 28 ++++++++++++++++++++++------
>> >>  include/uapi/linux/kvm.h             |  7 +++++++
>> >>  5 files changed, 48 insertions(+), 9 deletions(-)
>> >>
>> >> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> >> index a601a9305b10..fa0149a0606a 100644
>> >> --- a/arch/arm64/include/asm/kvm_emulate.h
>> >> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> >> @@ -373,6 +373,11 @@ static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
>> >>  	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
>> >>  }
>> >>
>> >> +static inline bool kvm_vcpu_trap_is_tagaccess(const struct kvm_vcpu *vcpu)
>> >> +{
>> >> +	return !!(ESR_ELx_ISS2(kvm_vcpu_get_esr(vcpu)) & ESR_ELx_TagAccess);
>> >> +}
>> >> +
>> >>  static __always_inline u8 kvm_vcpu_trap_get_fault(const struct kvm_vcpu *vcpu)
>> >>  {
>> >>  	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC;
>> >> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>> >> index 03f4c3d7839c..5657ac1998ad 100644
>> >> --- a/arch/arm64/include/asm/kvm_pgtable.h
>> >> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>> >> @@ -252,6 +252,7 @@ enum kvm_pgtable_prot {
>> >>
>> >>  	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
>> >>  	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
>> >> +	KVM_PGTABLE_PROT_NORMAL_NOTAGACCESS	= BIT(5),
>> >
>> > This seems wrong. NOTAGACCESS is a *permission*, not a memory type.
>> >
>>
>> Are you suggesting the name is wrong? The memory attribute value I
>> wanted to use is
>>
>> MemAttr[3:0] = 0b0100 which is Normal, NoTagAccess, writeback cacheable.
>>
>> I am following the changes similar to KVM_PGTABLE_PROT_NORMAL_NC.
>
> But that's entirely different. This really isn't a memory type. Quite
> the opposite, actually. This is a stage-2 permission setting, which
> you are conflating with the actual memory type.
>
> Also, I don't see why that should be incompatible with something other
> than Normal memory.
>

I am sorry that i am not able to follow you here. I am confused whether
your feedback is related to the use of MemAttr[3:0] values or w.r.t
the usage of KVM_PGTABLE_PROT_NORMAL_NOTAG_ACCESS. If you can explain
more on how you would like to see the changes I can incorporate them in
the next update.

>>
>> >
>> >>
>> >>  	KVM_PGTABLE_PROT_SW0			= BIT(55),
>> >>  	KVM_PGTABLE_PROT_SW1			= BIT(56),
>> >> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>> >> index b11bcebac908..bc0d9f08c49a 100644
>> >> --- a/arch/arm64/kvm/hyp/pgtable.c
>> >> +++ b/arch/arm64/kvm/hyp/pgtable.c
>> >> @@ -677,9 +677,11 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>> >>  {
>> >>  	kvm_pte_t attr;
>> >>  	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
>> >> +	unsigned long prot_mask = KVM_PGTABLE_PROT_DEVICE |
>> >> +				  KVM_PGTABLE_PROT_NORMAL_NC |
>> >> +				  KVM_PGTABLE_PROT_NORMAL_NOTAGACCESS;
>> >>
>> >> -	switch (prot & (KVM_PGTABLE_PROT_DEVICE |
>> >> -			KVM_PGTABLE_PROT_NORMAL_NC)) {
>> >> +	switch (prot & prot_mask) {
>> >>  	case KVM_PGTABLE_PROT_DEVICE | KVM_PGTABLE_PROT_NORMAL_NC:
>> >>  		return -EINVAL;
>> >>  	case KVM_PGTABLE_PROT_DEVICE:
>> >> @@ -692,6 +694,12 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>> >>  			return -EINVAL;
>> >>  		attr = KVM_S2_MEMATTR(pgt, NORMAL_NC);
>> >>  		break;
>> >> +	case KVM_PGTABLE_PROT_NORMAL_NOTAGACCESS:
>> >> +		if (system_supports_notagaccess())
>> >> +			attr = KVM_S2_MEMATTR(pgt, NORMAL_NOTAGACCESS);
>> >> +		else
>> >> +			return -EINVAL;
>> >> +		break;
>> >
>> > How do you see this working when migrating a VM from one host to
>> > another, one that supports FEAT_MTE_PERM and one that doesn't? The
>> > current assumptions are that the VMM will replay the *exact same*
>> > setup on the target host, and this obviously doesn't work.
>> >
>>
>> I missed looking at kvm migration. I guess I will have to expose this as
>> a capability and only allow migration if the target also supports the
>> same capability?
>
> I don't think so. This doesn't affect the guest at all, as the guest
> doesn't know anything about S2, unless you decide to expose
> FEAT_MTE_PERM to NV.
>
> It affects the VMM though, and that's because you are making a
> difference in handling between having FEAT_MTE_PERM or not. Given that
> this is invisible to userspace, that's not a great design.
>

With migration, I guess i can prevent migration to a target that doesn't
support FEAT_MTE_PERM by updating set_one_reg to check for the feature
support. Something like this 

modified   arch/arm64/kvm/sys_regs.c
@@ -1514,7 +1514,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 				       const struct sys_reg_desc *r)
 {
 	u32 id = reg_to_encoding(r);
-	u64 val;
+	u64 val, mask;

 	if (sysreg_visible_as_raz(vcpu, r))
 		return 0;
@@ -1529,8 +1529,10 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME);
 		break;
 	case SYS_ID_AA64PFR2_EL1:
-		/* We only expose FPMR */
-		val &= ID_AA64PFR2_EL1_FPMR;
+		mask = ID_AA64PFR2_EL1_FPMR;
+		if (system_supports_notagaccess())
+			mask |= ID_AA64PFR2_EL1_MTEPERM;
+		val &= mask;
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -2382,7 +2384,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
-	ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR),
+	ID_WRITABLE(ID_AA64PFR2_EL1, ID_AA64PFR2_EL1_FPMR |
+					ID_AA64PFR2_EL1_MTEPERM),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),


For nested virtualization, I guess it is useful to support this for
nested guest. This implies L2 stage2 in L1 will have to support
Normal,NoTagAccess attribute. ie,

in L0 kvm, if the guest abort is on a nested smmu, then we walk the L2
stage2 in L1 and see if the memory attribute is NoTagAccess. If yes
we inject a s2 fault to L1. Do you agree this is a good design?

-aneesh
