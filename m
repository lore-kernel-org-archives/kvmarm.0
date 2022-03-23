Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A149FC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 19:22:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01F7A49EEE;
	Wed, 23 Mar 2022 15:22:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1Odeo7uCZyb6; Wed, 23 Mar 2022 15:22:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAF6B49E37;
	Wed, 23 Mar 2022 15:22:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E1B440D0B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:22:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FcD+MrTO-eim for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 15:22:17 -0400 (EDT)
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com
 [209.85.166.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6504240C95
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 15:22:17 -0400 (EDT)
Received: by mail-io1-f43.google.com with SMTP id c23so2926943ioi.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 12:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=JlMssrBS5MsWzr4IlAQ1DcKlCFmfRWojcGydLqsuTtY=;
 b=SMG6cDmX+eXpRQ94AqhVqDKxEoEuWDo5YwwCRBPkxeUSTJIBdfNA7sSU3zJkicwEgb
 aHqD6tW07HceqvJp6mNptONcqESdKtAJ4t4iK3VaQCsSF0JIO8nocEaUyLVKxno1lDKp
 6jbLYrMGLdeGqdhZ7MJissy9yA8ijNrm81J9D8pA8iklFPVM1EdLrAGKIt4r+cOZDoq/
 ZStvN0KQGX3lb7eNnqtliwowc3pZHjYv1PYJECBaXM0/o50dQdb25DOueNGYXNr9fPZp
 BMdZg0S7oX94Ty2B1QvUD17nhtXKWcKacDcl0Vr8Nix9ZDHa/GzSMHOmW+53X80mxxh1
 lVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JlMssrBS5MsWzr4IlAQ1DcKlCFmfRWojcGydLqsuTtY=;
 b=x3EWRmRpDcYpX2cWhaDN8oRFj983O0EdlwbVh8e2bhXPtgBQq9vUQSnPojIjN8L9DF
 TL4S1pj3uaw3oRhxLzz3CJtIuxXOZbkkEDWxEFAhOU5knGYicIiXHBAOzmQ4tOLy0WcI
 Jt8MQ2Cy5H6VGiy1UH63LoMDPlkJrVhGrEAHK/3O+p9ZTk63qFcEultjuwOuSM7ja00c
 q8BAc7WS8uEahwDI+YfoDRW6KSgU5Ndm1McmTOSFlei18bcILQei5ndkp17yuVDQoDX6
 vAu3WxnlUOqNREjDpQvbCtPg9c1qUYjYfK9PGUgx2imcOmmMYzGeXqva0J8ZoSTMP/h0
 zLBQ==
X-Gm-Message-State: AOAM532cgc5IfOnIB3AgnlXFEBgdE8CTfctQqRCyifp4TUfnL5H0pdyu
 JMsg90XFwBOFrJVT8k6kRyyyaQ==
X-Google-Smtp-Source: ABdhPJwngJg/5LHhODSUq+zIVlvVV5bBB3J5MW1sVvzghvqD9c55m4X7Zxu6PadTGaeTnZhTx2kmgQ==
X-Received: by 2002:a05:6602:1493:b0:649:1890:cffd with SMTP id
 a19-20020a056602149300b006491890cffdmr844378iow.167.1648063336566; 
 Wed, 23 Mar 2022 12:22:16 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 d3-20020a056e020c0300b002c7b42b4b0esm422584ile.65.2022.03.23.12.22.15
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 12:22:15 -0700 (PDT)
Date: Wed, 23 Mar 2022 19:22:12 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v6 02/25] KVM: arm64: Save ID registers' sanitized value
 per guest
Message-ID: <YjtzZI8Lw2uzjm90@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-3-reijiw@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220311044811.1980336-3-reijiw@google.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Reiji,

On Thu, Mar 10, 2022 at 08:47:48PM -0800, Reiji Watanabe wrote:
> Introduce id_regs[] in kvm_arch as a storage of guest's ID registers,
> and save ID registers' sanitized value in the array at KVM_CREATE_VM.
> Use the saved ones when ID registers are read by the guest or
> userspace (via KVM_GET_ONE_REG).
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 12 ++++++
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/sys_regs.c         | 65 ++++++++++++++++++++++++-------
>  3 files changed, 63 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2869259e10c0..c041e5afe3d2 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -101,6 +101,13 @@ struct kvm_s2_mmu {
>  struct kvm_arch_memory_slot {
>  };
>  
> +/*
> + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> + * where 0<=crm<8, 0<=op2<8.

Doesn't the Feature ID register scheme only apply to CRm={1-7},
op2={0-7}? I believe CRm=0, op2={1-4,7} are in fact UNDEFINED, not RAZ
like the other ranges. Furthermore, the registers that are defined in
that range do not go through the read_id_reg() plumbing.

> + */
> +#define KVM_ARM_ID_REG_MAX_NUM	64
> +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> +
>  struct kvm_arch {
>  	struct kvm_s2_mmu mmu;
>  
> @@ -137,6 +144,9 @@ struct kvm_arch {
>  	/* Memory Tagging Extension enabled for the guest */
>  	bool mte_enabled;
>  	bool ran_once;
> +
> +	/* ID registers for the guest. */
> +	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];

This is a decently large array. Should we embed it in kvm_arch or
allocate at init?

[...]

> +
> +/*
> + * Set the guest's ID registers that are defined in sys_reg_descs[]
> + * with ID_SANITISED() to the host's sanitized value.
> + */
> +void set_default_id_regs(struct kvm *kvm)

nit, more relevant if you take the above suggestion: maybe call it
kvm_init_id_regs()?

> +{
> +	int i;
> +	u32 id;
> +	const struct sys_reg_desc *rd;
> +	u64 val;
> +
> +	for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {

You could avoid walking the entire system register table, since we
already know the start and end values for the Feature ID register range.

maybe:

  #define FEATURE_ID_RANGE_START	SYS_ID_PFR0_EL1
  #define FEATURE_ID_RANGE_END		sys_reg(3, 0, 0, 7, 7)

  u32 sys_reg;

  for (sys_reg = FEATURE_ID_RANGE_START; sys_reg <= FEATURE_ID_RANGE_END; sys_reg++)

But, it depends on if this check is necessary:

> +		rd = &sys_reg_descs[i];
> +		if (rd->access != access_id_reg)
> +			/* Not ID register, or hidden/reserved ID register */
> +			continue;

Which itself is dependent on whether KVM is going to sparsely or
verbosely define its feature filtering tables per the other thread. So
really only bother with this if that is the direction you're going.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
