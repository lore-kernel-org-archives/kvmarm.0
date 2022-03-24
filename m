Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25AAC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 16:23:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 11BAA4B0EF;
	Thu, 24 Mar 2022 12:23:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YOH7OrpryGtP; Thu, 24 Mar 2022 12:23:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9CDB4B0DF;
	Thu, 24 Mar 2022 12:23:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C87AC49F22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 12:23:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fad1Vnk0a64v for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 12:23:15 -0400 (EDT)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8A85940C02
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 12:23:15 -0400 (EDT)
Received: by mail-pg1-f169.google.com with SMTP id q19so4228446pgm.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 09:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=uXjHZDJVvGjT9+tCQuhnhtKNhXNwmcy0iq/6HwiZK08=;
 b=ZSK5ZkdzYQDO0cEAHxpJYlN22xojbHSf/blD76rCVVBf26r5iLwhmhQ2dUo6YqE43e
 vk3cwoLvlxJNd9AIZN6lnHRtasNyl4F8MVf0uaK46a1XJlptageUEWmXuY2htaHZ/ZyZ
 jHIbSbcQiv1r9Fx4Ua1OnnGyawuUTUV48LY0R2g2DTmwJzl0s94TOsOhdEk0rT5hJD+N
 8/6W0EUwyl+hJp+XqZUZYw41Ei9ysNeHTsEc4xZvYyLjakrHk69yoE0Eg9KJB/WLPhPu
 kvId6q+HK203qegslvPkiYKzAYvh3C4WOoZQAHdZQwkXZoZU7hd5AMIqmKnRfmv/bfgt
 GTvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=uXjHZDJVvGjT9+tCQuhnhtKNhXNwmcy0iq/6HwiZK08=;
 b=Ph5O2ay9Trm3rUHFbBVxbToUAh3gmgDD1UzmqWwaCxjXAwVp+LaAllVwxEOtm7I+Kb
 4ixeR5HnVrQLgDcQk7W9FQkdzEqRaQYNgphUeiGylV9owgETjXWNw3vm30fBhFQqbxmY
 05e2Krbf+mmuJBGjDQ/2oUq2iy5uGwzCfc664jdGYdYqBXsiaNtqU5SiKCanJlkKTfEg
 bsRtZbnw4y4Lwvmz9/8dCz1f66PL16uf4makBfExts+tDFJFToLbIwkLPOJ+kaWxboV+
 l93F+rKu3YU/1gvgjxXuyaprFK+HXJH44M2vAxuzcnMO4Wrf565ysOoAOMWPYp2bEzOa
 vg8Q==
X-Gm-Message-State: AOAM533iUwt2ir9hz8h9AkEWoWLBA8wNkepch7EHPCFatkNxgxPw5DQa
 2dMmWFyT6pCuutP89pUyRj63ig==
X-Google-Smtp-Source: ABdhPJwD+IBhf3QMsnVdq71Xhv26Nh25rsYZwWkB1ESJwYqDhPQZN905r3P2Z4pzcGIGI9cn0VNaYw==
X-Received: by 2002:a05:6a00:2484:b0:4fa:997e:3290 with SMTP id
 c4-20020a056a00248400b004fa997e3290mr5859221pfv.37.1648138994270; 
 Thu, 24 Mar 2022 09:23:14 -0700 (PDT)
Received: from [192.168.86.237]
 (107-203-254-183.lightspeed.sntcca.sbcglobal.net. [107.203.254.183])
 by smtp.gmail.com with ESMTPSA id
 w12-20020a056a0014cc00b004f790cdbf9dsm4276831pfu.183.2022.03.24.09.23.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 24 Mar 2022 09:23:13 -0700 (PDT)
Message-ID: <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
Date: Thu, 24 Mar 2022 09:23:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v6 02/25] KVM: arm64: Save ID registers' sanitized value
 per guest
Content-Language: en-US
To: Oliver Upton <oupton@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-3-reijiw@google.com> <YjtzZI8Lw2uzjm90@google.com>
From: Reiji Watanabe <reijiw@google.com>
In-Reply-To: <YjtzZI8Lw2uzjm90@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Oliver,

On 3/23/22 12:22 PM, Oliver Upton wrote:
> Hi Reiji,
> 
> On Thu, Mar 10, 2022 at 08:47:48PM -0800, Reiji Watanabe wrote:
>> Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
>> and save ID registers' sanitized value in the array at KVM_CREATE_VM.
>> Use the saved ones when ID registers are read by the guest or
>> userspace (via KVM_GET_ONE_REG).
>>
>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>> ---
>>   arch/arm64/include/asm/kvm_host.h | 12 ++++++
>>   arch/arm64/kvm/arm.c              |  1 +
>>   arch/arm64/kvm/sys_regs.c         | 65 ++++++++++++++++++++++++-------
>>   3 files changed, 63 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 2869259e10c0..c041e5afe3d2 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -101,6 +101,13 @@ struct kvm_s2_mmu {
>>   struct kvm_arch_memory_slot {
>>   };
>>   
>> +/*
>> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
>> + * where 0<=crm<8, 0<=op2<8.
> 
> Doesn't the Feature ID register scheme only apply to CRm={1-7},
> op2={0-7}? I believe CRm=0, op2={1-4,7} are in fact UNDEFINED, not RAZ
> like the other ranges. Furthermore, the registers that are defined in
> that range do not go through the read_id_reg() plumbing.


Will fix this.


> 
>> + */
>> +#define KVM_ARM_ID_REG_MAX_NUM	64
>> +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
>> +
>>   struct kvm_arch {
>>   	struct kvm_s2_mmu mmu;
>>   
>> @@ -137,6 +144,9 @@ struct kvm_arch {
>>   	/* Memory Tagging Extension enabled for the guest */
>>   	bool mte_enabled;
>>   	bool ran_once;
>> +
>> +	/* ID registers for the guest. */
>> +	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> 
> This is a decently large array. Should we embed it in kvm_arch or
> allocate at init?


What is the reason why you think you might want to allocate it at init ?

  
> [...]
> 
>> +
>> +/*
>> + * Set the guest's ID registers that are defined in sys_reg_descs[]
>> + * with ID_SANITISED() to the host's sanitized value.
>> + */
>> +void set_default_id_regs(struct kvm *kvm)
> 
> nit, more relevant if you take the above suggestion: maybe call it
> kvm_init_id_regs()?
> 
>> +{
>> +	int i;
>> +	u32 id;
>> +	const struct sys_reg_desc *rd;
>> +	u64 val;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> 
> You could avoid walking the entire system register table, since we
> already know the start and end values for the Feature ID register range.> 
> maybe:
> 
>    #define FEATURE_ID_RANGE_START	SYS_ID_PFR0_EL1
>    #define FEATURE_ID_RANGE_END		sys_reg(3, 0, 0, 7, 7)
> 
>    u32 sys_reg;
> 
>    for (sys_reg = FEATURE_ID_RANGE_START; sys_reg <= FEATURE_ID_RANGE_END; sys_reg++)
> 
> But, it depends on if this check is necessary:
>
>> +		rd = &sys_reg_descs[i];
>> +		if (rd->access != access_id_reg)
>> +			/* Not ID register, or hidden/reserved ID register */
>> +			continue;
> 
> Which itself is dependent on whether KVM is going to sparsely or
> verbosely define its feature filtering tables per the other thread. So
> really only bother with this if that is the direction you're going.

Even just going through for ID register ranges, we should do the check
to skip hidden/reserved ID registers (not to call read_sanitised_ftr_reg).

Yes, it's certainly possible to avoid walking the entire system register,
and I will fix it.  The reason why I didn't care it so much was just
because the code (walking the entire system register) will be removed by
the following patches:)

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
