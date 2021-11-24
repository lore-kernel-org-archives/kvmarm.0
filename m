Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5208C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 18:09:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30FE04B1D0;
	Wed, 24 Nov 2021 13:09:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ttpas1WGhfKs; Wed, 24 Nov 2021 13:09:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BC974B174;
	Wed, 24 Nov 2021 13:09:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EAB44B0F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 13:08:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q9Y+71kH0Ujt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 13:08:57 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7424B0B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 13:08:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1637777337;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=1U6pHOdjTzqLr+UPekAI7w6u+A8bWKUlBWhhw9r2+iQ=;
 b=Ciu7vUavN9G1q7CslnHSjC6ydW0Ytnf5qodN2Z61CedXtqKL2NE17ad6B40v+8RKYq2Q1M
 YPsAZ2l1L1kizWecjy23O98NNNZlN7rOvl5RBsfisKSMi24Pj7dNCqA9rNvsK/pRJ5VPHl
 HOg63ThqBlH/OrP725U4iqvXWVRiVeg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-80-6z4r63puP6ecPs8R6fRMmQ-1; Wed, 24 Nov 2021 13:08:56 -0500
X-MC-Unique: 6z4r63puP6ecPs8R6fRMmQ-1
Received: by mail-wm1-f70.google.com with SMTP id
 k25-20020a05600c1c9900b00332f798ba1dso3409075wms.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 10:08:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=1U6pHOdjTzqLr+UPekAI7w6u+A8bWKUlBWhhw9r2+iQ=;
 b=wQXpugnmXxNuGePTFd5R3u859oBcACAAeNJtDEPn6WN9C/+T44cle7pV19AGew7D5t
 vYdg74qxBEZUk1cIDHQMRroz+zTNOGOQLDwu9tWSiKM+efWWsYJGvd6mG5ryUtqOgJ6L
 gbDUQHtP+O9f8IQnqFxLQu78kGHcEDoV0a2R1RC6EmgHu8mZIqFK37iTyxD+FNe0GiG5
 uJOsWeSqMB5WgWwnBhnV1furjYIMlHlv68HgL9EAmjzCOYNfFsiDXRGK54ye3jKt5Zz5
 Gr6mSRNqM+X5p5mBHfNcc8/V9+DgR9Pxh6rMA1ww2G1JpZ6/xN3jf1vsShkP5Bn2Y5Zh
 L6JQ==
X-Gm-Message-State: AOAM531gI2yu42eOu64TC46Rcf2B5G1AohbX8do5aXo6xuCJLfpP2JVD
 zsAm3/p1AaZ/PlnTztrT8MtjCLcCht/xD+zcDsegms79LJCqD8E9CW4TKW44fvJfWHlsSJ1lIRY
 wHeEhiKoVOtahxCPeo82jqw2m
X-Received: by 2002:a05:6000:1141:: with SMTP id
 d1mr21415765wrx.342.1637777335101; 
 Wed, 24 Nov 2021 10:08:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx26wuW9BzebF4e9Wvpg/UOAPXdq55mOMjSx/2pn674sZDA0jSUK6O9ANjx+8U8K2xw1sK2ag==
X-Received: by 2002:a05:6000:1141:: with SMTP id
 d1mr21415709wrx.342.1637777334754; 
 Wed, 24 Nov 2021 10:08:54 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id p2sm6221778wmq.23.2021.11.24.10.08.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 24 Nov 2021 10:08:53 -0800 (PST)
Subject: Re: [RFC PATCH v3 02/29] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To: Reiji Watanabe <reijiw@google.com>
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-3-reijiw@google.com>
 <dad16d0f-a0fa-cd8e-fdd0-0bbdf38af791@redhat.com>
 <CAAeT=FyUjwJDLw=6u_ocgQ_974+vD4w0n2=WCYXLsH4cf+dxOw@mail.gmail.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <4193e1b3-3cc2-7e9a-e249-75ef71495398@redhat.com>
Date: Wed, 24 Nov 2021 19:08:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=FyUjwJDLw=6u_ocgQ_974+vD4w0n2=WCYXLsH4cf+dxOw@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

On 11/18/21 11:00 PM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Nov 18, 2021 at 12:37 PM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>> Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
>>> registers' sanitized value in the array for the vCPU at the first
>>> vCPU reset. Use the saved ones when ID registers are read by
>>> userspace (via KVM_GET_ONE_REG) or the guest.
>>>
>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>> ---
>>>  arch/arm64/include/asm/kvm_host.h | 10 +++++++
>>>  arch/arm64/kvm/sys_regs.c         | 43 +++++++++++++++++++------------
>>>  2 files changed, 37 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index edbe2cb21947..72db73c79403 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -146,6 +146,14 @@ struct kvm_vcpu_fault_info {
>>>       u64 disr_el1;           /* Deferred [SError] Status Register */
>>>  };
>>>
>>> +/*
>>> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
>>> + * where 0<=crm<8, 0<=op2<8.
>>> + */
>>> +#define KVM_ARM_ID_REG_MAX_NUM 64
>>> +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
>>> +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
>>> +
>>>  enum vcpu_sysreg {
>>>       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
>>>       MPIDR_EL1,      /* MultiProcessor Affinity Register */
>>> @@ -210,6 +218,8 @@ enum vcpu_sysreg {
>>>       CNTP_CVAL_EL0,
>>>       CNTP_CTL_EL0,
>>>
>>> +     ID_REG_BASE,
>>> +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
>>>       /* Memory Tagging Extension registers */
>>>       RGSR_EL1,       /* Random Allocation Tag Seed Register */
>>>       GCR_EL1,        /* Tag Control Register */
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index e3ec1a44f94d..5608d3410660 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -33,6 +33,8 @@
>>>
>>>  #include "trace.h"
>>>
>>> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
>>> +
>>>  /*
>>>   * All of this file is extremely similar to the ARM coproc.c, but the
>>>   * types are different. My gut feeling is that it should be pretty
>>> @@ -273,7 +275,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
>>>                         struct sys_reg_params *p,
>>>                         const struct sys_reg_desc *r)
>>>  {
>>> -     u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
>>> +     u64 val = __read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
>>>       u32 sr = reg_to_encoding(r);
>>>
>>>       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
>>> @@ -1059,17 +1061,9 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
>>>       return true;
>>>  }
>>>
>>> -/* Read a sanitised cpufeature ID register by sys_reg_desc */
>>> -static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>>> -             struct sys_reg_desc const *r, bool raz)
>>> +static u64 __read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
>>>  {
>>> -     u32 id = reg_to_encoding(r);
>>> -     u64 val;
>>> -
>>> -     if (raz)
>>> -             return 0;
>>> -
>>> -     val = read_sanitised_ftr_reg(id);
>>> +     u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
>>>
>>>       switch (id) {
>>>       case SYS_ID_AA64PFR0_EL1:
>>> @@ -1119,6 +1113,14 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>>>       return val;
>>>  }
>>>
>>> +static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>>> +                    struct sys_reg_desc const *r, bool raz)
>>> +{
>>> +     u32 id = reg_to_encoding(r);
>>> +
>>> +     return raz ? 0 : __read_id_reg(vcpu, id);
>>> +}
>>> +
>>>  static unsigned int id_visibility(const struct kvm_vcpu *vcpu,
>>>                                 const struct sys_reg_desc *r)
>>>  {
>>> @@ -1178,6 +1180,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>>>       return REG_HIDDEN;
>>>  }
>>>
>>> +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
>>> +{
>>> +     u32 id = reg_to_encoding(rd);
>>> +
>>> +     if (vcpu_has_reset_once(vcpu))
>>> +             return;
>>> +
>>> +     __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
>>> +}
>>> +
>>>  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>>>                              const struct sys_reg_desc *rd,
>>>                              const struct kvm_one_reg *reg, void __user *uaddr)
>>> @@ -1223,9 +1235,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>>>  /*
>>>   * cpufeature ID register user accessors
>>>   *
>>> - * For now, these registers are immutable for userspace, so no values
>>> - * are stored, and for set_id_reg() we don't allow the effective value
>>> - * to be changed.
>>> + * We don't allow the effective value to be changed.
>> This change may be moved to a subsequent patch as this patch does not
>> change the behavior yet.
> 
> Thank you for the review.
> 
> There are three main parts in the original comments.
> 
>  (A) these registers are immutable for userspace
>  (B) no values are stored
>  (C) we don't allow the effective value to be changed
> 
> This patch stores ID register values in sys_regs[].
> So, I don't think (B) should be there, and I removed (B).
> Since (A) is essentially the same as (C), I removed (A)
> (and left (C)).
> 
> Do you think it is better to leave (A) in this patch, too ?
yes I think I would leave 'for now,  these registers are immutable for
userspace'

Eric
> 
> Thanks,
> Reiji
> 
> 
>>>   */
>>>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
>>>                       const struct sys_reg_desc *rd, void __user *uaddr,
>>> @@ -1382,6 +1392,7 @@ static unsigned int mte_visibility(const struct kvm_vcpu *vcpu,
>>>  #define ID_SANITISED(name) {                 \
>>>       SYS_DESC(SYS_##name),                   \
>>>       .access = access_id_reg,                \
>>> +     .reset  = reset_id_reg,                 \
>>>       .get_user = get_id_reg,                 \
>>>       .set_user = set_id_reg,                 \
>>>       .visibility = id_visibility,            \
>>> @@ -1837,8 +1848,8 @@ static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
>>>       if (p->is_write) {
>>>               return ignore_write(vcpu, p);
>>>       } else {
>>> -             u64 dfr = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
>>> -             u64 pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
>>> +             u64 dfr = __read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
>>> +             u64 pfr = __read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
>>>               u32 el3 = !!cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR0_EL3_SHIFT);
>>>
>>>               p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
>>>
>> Thanks
>>
>> Eric
>>
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
