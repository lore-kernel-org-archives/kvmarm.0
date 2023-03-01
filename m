Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55665883D;
	Wed,  1 Mar 2023 20:21:16 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id j17so15289453ljq.11;
        Wed, 01 Mar 2023 12:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677702074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LPRzczm2wGlm6Acu/l6huV/wn3LazkeUdQZ6PCCLChQ=;
        b=cOhEeH1WbB9GB02Xj94/oBs4LLalpGpRsZt4noDlX08wznB4ETeULIsi5VI7ldE1PA
         GG11jx4yRs8j2QJov16ykTRBTrMcizWt+c6X39zcmxE/ZPBO2WNede+2uqUsx5Nz2ivc
         MZQ1hCq9xXrgB7aDiTxUq6sJ2uq+GTZYIOl5Kv+4CUUn0wMr99rA7aV7YCG9rDbyys5w
         GzyiCTs1Eu6KgJXHdLbmRSqUpCSUkTWcd3P57qUMyjjii1AF9qsT245+4YaBYuiT91Ox
         A4Sb8mcKmQGRSfo349KbqM4W9gQx3shQuqBpLDONuVBFmZxgAMbHgGW/99pBOEIH27in
         bweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677702074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LPRzczm2wGlm6Acu/l6huV/wn3LazkeUdQZ6PCCLChQ=;
        b=Zl46zixthuxaCgQ46b6XoXFykeV1IPg1gxu+RHORJnAWBiNfpXE0XDIcxQPzgk8sXU
         r5ihxsS6AIPdBG+8b+/bs339H3CDEmJpm4hK9RmUdY3wYYjC6nE9gOUR82aT/DRXY0J/
         Ds3bDp3nvDDUAXN3RMYWHGf1AIEKk0PT/32GdHRTzZvVzqY5a8fG1IN+tyNGGrkJluU6
         Hzqnd34SfVZAjbIA6rYBHkG9iKB3OS+dzkdQiFWXcsZjmmio71kXPzjpvyAMvZHKA/EM
         RpTYIRwXYWGKUGHdGst+ntww/2Dz3ge9aJzS1E9qdCTCJ8D0IqiKwD8+Dw89s8KyVy0O
         ntCw==
X-Gm-Message-State: AO0yUKXGvoBGw9zKX7oIvoCuAq7SfElWGXtcKjh9iwte6tFXZxWhRICl
	4ehoIj3AKDtcNBmjUsdMsrA=
X-Google-Smtp-Source: AK7set//lT5xo12hxlQxelQR8VrVKBkgBABiLB+SLWfCUjQ1QO8JK2l/Nl96Wcz0sxWliWJDTdMrfw==
X-Received: by 2002:a2e:95d4:0:b0:293:1696:a042 with SMTP id y20-20020a2e95d4000000b002931696a042mr2137065ljh.4.1677702074195;
        Wed, 01 Mar 2023 12:21:14 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id p17-20020a2eb991000000b00295b1ad177csm1595531ljp.68.2023.03.01.12.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 12:21:14 -0800 (PST)
From: Zhi Wang <zhi.wang.linux@gmail.com>
X-Google-Original-From: Zhi Wang <zhi.wang.linux@intel.com>
Date: Wed, 1 Mar 2023 22:21:12 +0200
To: Steven Price <steven.price@arm.com>
Cc: Zhi Wang <zhi.wang.linux@gmail.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>, Marc
 Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse
 <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Joey
 Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 05/28] arm64: RME: Define the user ABI
Message-ID: <20230301222112.00003bc7@intel.com>
In-Reply-To: <8e803abd-8856-3c44-6262-40c026216c9a@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
	<20230127112932.38045-1-steven.price@arm.com>
	<20230127112932.38045-6-steven.price@arm.com>
	<20230213180413.00000392@gmail.com>
	<8e803abd-8856-3c44-6262-40c026216c9a@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 1 Mar 2023 11:54:34 +0000
Steven Price <steven.price@arm.com> wrote:

> On 13/02/2023 16:04, Zhi Wang wrote:
> > On Fri, 27 Jan 2023 11:29:09 +0000
> > Steven Price <steven.price@arm.com> wrote:
> > 
> >> There is one (multiplexed) CAP which can be used to create, populate and
> >> then activate the realm.
> >>
> >> Signed-off-by: Steven Price <steven.price@arm.com>
> >> ---
> >>  Documentation/virt/kvm/api.rst    |  1 +
> >>  arch/arm64/include/uapi/asm/kvm.h | 63 +++++++++++++++++++++++++++++++
> >>  include/uapi/linux/kvm.h          |  2 +
> >>  3 files changed, 66 insertions(+)
> >>
> >> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> >> index 0dd5d8733dd5..f1a59d6fb7fc 100644
> >> --- a/Documentation/virt/kvm/api.rst
> >> +++ b/Documentation/virt/kvm/api.rst
> >> @@ -4965,6 +4965,7 @@ Recognised values for feature:
> >>  
> >>    =====      ===========================================
> >>    arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
> >> +  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
> >>    =====      ===========================================
> >>  
> >>  Finalizes the configuration of the specified vcpu feature.
> >> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> >> index a7a857f1784d..fcc0b8dce29b 100644
> >> --- a/arch/arm64/include/uapi/asm/kvm.h
> >> +++ b/arch/arm64/include/uapi/asm/kvm.h
> >> @@ -109,6 +109,7 @@ struct kvm_regs {
> >>  #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
> >>  #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
> >>  #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
> >> +#define KVM_ARM_VCPU_REC		7 /* VCPU REC state as part of Realm */
> >>  
> >>  struct kvm_vcpu_init {
> >>  	__u32 target;
> >> @@ -401,6 +402,68 @@ enum {
> >>  #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
> >>  #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
> >>  
> >> +/* KVM_CAP_ARM_RME on VM fd */
> >> +#define KVM_CAP_ARM_RME_CONFIG_REALM		0
> >> +#define KVM_CAP_ARM_RME_CREATE_RD		1
> >> +#define KVM_CAP_ARM_RME_INIT_IPA_REALM		2
> >> +#define KVM_CAP_ARM_RME_POPULATE_REALM		3
> >> +#define KVM_CAP_ARM_RME_ACTIVATE_REALM		4
> >> +
> > 
> > It is a little bit confusing here. These seems more like 'commands' not caps.
> > Will leave more comments after reviewing the later patches.
> 
> Sorry for the slow response. Thank you for your review - I hope to post
> a new version of this series (rebased on 6.3-rc1) in the coming weeks
> with your comments addressed.
> 

Hi:

No worries. I spent most of my time on closing the review of TDX/SNP
series recently while stopped at patch 16 of this series. I will try to
finish the rest of this series this week.

I am glad if my efforts help and more reviewers can smoothly jump in
later.
 
> They are indeed commands - and using caps is a bit of a hack. The
> benefit here is that all the Realm commands are behind the one
> KVM_CAP_ARM_RME.
> 
> The options I can see are:
> 
> a) What I've got here - (ab)using KVM_ENABLE_CAP to perform commands.
> 
> b) Add new ioctls for each of the above stages (so 5 new ioctls on top
> of the CAP for discovery). With any future extensions requiring new ioctls.
> 
> c) Add a single new multiplexing ioctl (along with the CAP for discovery).
> 
> I'm not massively keen on defining a new multiplexing scheme (c), but
> equally (b) seems like it's burning through ioctl numbers. Which led me
> to stick with (a) which at least keeps the rebasing simple (there's only
> the one CAP number which could conflict) and there's already a
> multiplexing scheme.
> 
> But I'm happy to change if there's consensus a different approach would
> be preferable.
> 

Let's see if others have different opinions.

My coin goes to b as it is better to respect "what it is, make it explicit
and clear" when coming to define the UABI. Ioctl number is for UABI. If
it is going to burn out, IMHO, we need to find another way, perhaps another
fd to group those ioctls, like KVM.

1. a) seems abusing the usage of the cap. for sure, the benefit is obvious.
2. c) seems hiding the details, which saves the ioctl numbers, but it didn't
actually help a lot on the complexity and might end up with another bunch
of "command code".

> Thanks,
> 
> Steve
> 
> >> +#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256		0
> >> +#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512		1
> >> +
> >> +#define KVM_CAP_ARM_RME_RPV_SIZE 64
> >> +
> >> +/* List of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
> >> +#define KVM_CAP_ARM_RME_CFG_RPV			0
> >> +#define KVM_CAP_ARM_RME_CFG_HASH_ALGO		1
> >> +#define KVM_CAP_ARM_RME_CFG_SVE			2
> >> +#define KVM_CAP_ARM_RME_CFG_DBG			3
> >> +#define KVM_CAP_ARM_RME_CFG_PMU			4
> >> +
> >> +struct kvm_cap_arm_rme_config_item {
> >> +	__u32 cfg;
> >> +	union {
> >> +		/* cfg == KVM_CAP_ARM_RME_CFG_RPV */
> >> +		struct {
> >> +			__u8	rpv[KVM_CAP_ARM_RME_RPV_SIZE];
> >> +		};
> >> +
> >> +		/* cfg == KVM_CAP_ARM_RME_CFG_HASH_ALGO */
> >> +		struct {
> >> +			__u32	hash_algo;
> >> +		};
> >> +
> >> +		/* cfg == KVM_CAP_ARM_RME_CFG_SVE */
> >> +		struct {
> >> +			__u32	sve_vq;
> >> +		};
> >> +
> >> +		/* cfg == KVM_CAP_ARM_RME_CFG_DBG */
> >> +		struct {
> >> +			__u32	num_brps;
> >> +			__u32	num_wrps;
> >> +		};
> >> +
> >> +		/* cfg == KVM_CAP_ARM_RME_CFG_PMU */
> >> +		struct {
> >> +			__u32	num_pmu_cntrs;
> >> +		};
> >> +		/* Fix the size of the union */
> >> +		__u8	reserved[256];
> >> +	};
> >> +};
> >> +
> >> +struct kvm_cap_arm_rme_populate_realm_args {
> >> +	__u64 populate_ipa_base;
> >> +	__u64 populate_ipa_size;
> >> +};
> >> +
> >> +struct kvm_cap_arm_rme_init_ipa_args {
> >> +	__u64 init_ipa_base;
> >> +	__u64 init_ipa_size;
> >> +};
> >> +
> >>  /* Device Control API on vcpu fd */
> >>  #define KVM_ARM_VCPU_PMU_V3_CTRL	0
> >>  #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
> >> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >> index 20522d4ba1e0..fec1909e8b73 100644
> >> --- a/include/uapi/linux/kvm.h
> >> +++ b/include/uapi/linux/kvm.h
> >> @@ -1176,6 +1176,8 @@ struct kvm_ppc_resize_hpt {
> >>  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
> >>  #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
> >>  
> >> +#define KVM_CAP_ARM_RME 300 // FIXME: Large number to prevent conflicts
> >> +
> >>  #ifdef KVM_CAP_IRQ_ROUTING
> >>  
> >>  struct kvm_irq_routing_irqchip {
> > 
> 

