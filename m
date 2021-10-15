Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0C7C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 13:47:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17443611C3
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 13:47:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 17443611C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A3154B14D;
	Fri, 15 Oct 2021 09:47:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R+vKCd3WKXrL; Fri, 15 Oct 2021 09:47:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3245C4B150;
	Fri, 15 Oct 2021 09:47:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D4E24B137
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 09:47:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0UkxroMpYCPD for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 09:47:46 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22D784B136
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 09:47:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634305666;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=905TQ6sVFkrlPQGtSa1vZo3FPe4+bey8MMYC90BfT1I=;
 b=VoS2k8j8nuLQOv5zOeRxricifDZ4BFJWIGJmIrKdxbngV2ZoYuGpJjE2eLKCTYDw4GKjKI
 sCSNk0W/tK9ygYhcQh+b7HmWDtFvdXpGt6aEbMz5C48tYHie2Op0yEdteMQwoh7T49YtqV
 Yr/nt3f6XecuLjRHA7mQXgJNLy9xdtI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-zALYS0aoP3ehE2AAOs7JuA-1; Fri, 15 Oct 2021 09:47:44 -0400
X-MC-Unique: zALYS0aoP3ehE2AAOs7JuA-1
Received: by mail-wr1-f70.google.com with SMTP id
 k2-20020adfc702000000b0016006b2da9bso5961405wrg.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 06:47:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=905TQ6sVFkrlPQGtSa1vZo3FPe4+bey8MMYC90BfT1I=;
 b=SIv4dBQL+dgrYoQ2w0pJm2pT6sjyz27rb0oO/+sSQpqPolZVzXQupAaQKzr4EgxMx5
 hKY3md/MLHqTHx95jR5dGp3jFsUzN9WAUlL5QRhetseyJm56Nb3DR6iyuWDyU8HxPiYw
 1akT/jeXcvcoC4kE3X2hCfjLZpblGnVKdNV+GieOipMToy1W8RXl7zWRYEzmbkFZAEN1
 2O1ctyFrrwvGZIaxde0jc6AGQX3M2FSdDKnA0jdbIHUtpZAOw7URI9r8AhSBWg/dxX6f
 aEqkMF8MScYrW3LWmDyDWuTK1WPfZaqQV0htf5sHSC+lrVIDMoruDJzUQmstbcZDKIzk
 0yMQ==
X-Gm-Message-State: AOAM53380EIHEsXLyWH1/PfD1TdprHyecqkW3aNGoNnenBM7j7vf9J/o
 YTTVdtZWeBQ7L1hf0wzDolOnQ47P+a9glH1yFW0hwfsvjgECb67snOHmf6oA3tvgvVI4Bua1aY8
 LUo8EgUmeJf11btuD02JVE+P1
X-Received: by 2002:a7b:c0d6:: with SMTP id s22mr12895938wmh.135.1634305663580; 
 Fri, 15 Oct 2021 06:47:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKiyeRICSQwCx6u67t9jIDbrnnYMy+xlq9xT3pFo6tsffk1uTG39cLFsFhhclyy8uWAl8uXA==
X-Received: by 2002:a7b:c0d6:: with SMTP id s22mr12895900wmh.135.1634305663264; 
 Fri, 15 Oct 2021 06:47:43 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id a81sm5278467wmd.30.2021.10.15.06.47.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Oct 2021 06:47:42 -0700 (PDT)
Date: Fri, 15 Oct 2021 15:47:41 +0200
From: Andrew Jones <drjones@redhat.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH 04/25] KVM: arm64: Introduce struct id_reg_info
Message-ID: <20211015134741.b7jahdmypu6tqkt2@gator>
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-5-reijiw@google.com>
MIME-Version: 1.0
In-Reply-To: <20211012043535.500493-5-reijiw@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Mon, Oct 11, 2021 at 09:35:14PM -0700, Reiji Watanabe wrote:
> This patch lays the groundwork to make ID registers writable.
> 
> Introduce struct id_reg_info for an ID register to manage the
> register specific control of its value for the guest.
> It is used to do register specific initialization, validation
> of the ID register and etc.  Not all ID registers must have
> the id_reg_info. ID registers that don't have the id_reg_info
> are handled in a common way that is applied to all other
> ID registers.
> 
> At present, changing an ID register from userspace is allowed only
> if the ID register has the id_reg_info, but that will be changed
> by the following patches.
> 
> No ID register has the structure yet and the following patches
> will add the id_reg_info for some ID registers.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 120 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 111 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 72ca518e7944..8a0b88f9a975 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -263,6 +263,76 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
>  		return read_zero(vcpu, p);
>  }
>  
> +struct id_reg_info {
> +	u32	sys_reg;	/* Register ID */
> +	u64	sys_val;	/* Sanitized system value */
> +
> +	/*
> +	 * Limit value of the register for a vcpu. The value is sys_val
> +	 * with bits cleared for unsupported features for the guest.
> +	 */
> +	u64	vcpu_limit_val;

Maybe I'll see a need for both later, but at the moment I'd think we only
need sys_val with the bits cleared for disabled features.

> +
> +	/* Bits that are not validated when userspace sets the register. */
> +	u64	ignore_mask;
> +
> +	/* Initialization function of the id_reg_info */
> +	void (*init)(struct id_reg_info *id_reg);
> +
> +	/* Register specific validation function */
> +	int (*validate)(struct kvm_vcpu *vcpu, u64 val);
> +
> +	/* Return the reset value of the register for the vCPU */
> +	u64 (*get_reset_val)(struct kvm_vcpu *vcpu, struct id_reg_info *id_reg);
> +};
> +
> +static void id_reg_info_init(struct id_reg_info *id_reg)
> +{
> +	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
> +	id_reg->vcpu_limit_val = id_reg->sys_val;
> +}
> +
> +/*
> + * An ID register that needs special handling to control the value for the
> + * guest must have its own id_reg_info in id_reg_info_table.
> + * (i.e. the reset value is different from the host's sanitized value,
> + * the value is affected by opt-in features, some fields needs specific
> + * validation, etc.)
> + */
> +#define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
> +static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {};
> +
> +static int validate_id_reg(struct kvm_vcpu *vcpu,
> +			   const struct sys_reg_desc *rd, u64 val)
> +{
> +	u32 id = reg_to_encoding(rd);
> +	const struct id_reg_info *id_reg = GET_ID_REG_INFO(id);
> +	u64 limit;
> +	u64 check_val = val;
> +	int err;
> +
> +	if (id_reg) {
> +		/*
> +		 * Clear bits with ignore_mask, which we don't want
> +		 * arm64_check_features to check.
> +		 */
> +		check_val &= ~id_reg->ignore_mask;
> +		limit = id_reg->vcpu_limit_val;
> +	} else
> +		limit = read_sanitised_ftr_reg(id);
> +
> +	/* Check if the value indicates any feature that is not in the limit. */
> +	err = arm64_check_features(id, check_val, limit);
> +	if (err)
> +		return err;
> +
> +	if (id_reg && id_reg->validate)
> +		/* Run the ID register specific validity check. */
> +		err = id_reg->validate(vcpu, val);
> +
> +	return err;
> +}
> +
>  /*
>   * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
>   * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
> @@ -1176,11 +1246,19 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
>  static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
>  {
>  	u32 id = reg_to_encoding(rd);
> +	struct id_reg_info *id_reg;
> +	u64 val;
>  
>  	if (vcpu_has_reset_once(vcpu))
>  		return;
>  
> -	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = read_sanitised_ftr_reg(id);
> +	id_reg = GET_ID_REG_INFO(id);
> +	if (id_reg && id_reg->get_reset_val)
> +		val = id_reg->get_reset_val(vcpu, id_reg);
> +	else
> +		val = read_sanitised_ftr_reg(id);
> +
> +	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) = val;
>  }
>  
>  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> @@ -1225,11 +1303,7 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -/*
> - * cpufeature ID register user accessors
> - *
> - * We don't allow the effective value to be changed.
> - */
> +/* cpufeature ID register user accessors */
>  static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
> @@ -1240,11 +1314,12 @@ static int __get_id_reg(const struct kvm_vcpu *vcpu,
>  	return reg_to_user(uaddr, &val, id);
>  }
>  
> -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> +static int __set_id_reg(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_desc *rd, void __user *uaddr,
>  			bool raz)
>  {
>  	const u64 id = sys_reg_to_index(rd);
> +	u32 encoding = reg_to_encoding(rd);
>  	int err;
>  	u64 val;
>  
> @@ -1252,10 +1327,18 @@ static int __set_id_reg(const struct kvm_vcpu *vcpu,
>  	if (err)
>  		return err;
>  
> -	/* This is what we mean by invariant: you can't change it. */
> -	if (val != read_id_reg(vcpu, rd, raz))
> +	/* Don't allow to change the reg unless the reg has id_reg_info */
> +	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
>  		return -EINVAL;
>  
> +	if (raz)
> +		return (val == 0) ? 0 : -EINVAL;

This is already covered by the val != read_id_reg(vcpu, rd, raz) check.

> +
> +	err = validate_id_reg(vcpu, rd, val);
> +	if (err)
> +		return err;
> +
> +	__vcpu_sys_reg(vcpu, IDREG_SYS_IDX(encoding)) = val;
>  	return 0;
>  }
>  
> @@ -2818,6 +2901,23 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	return write_demux_regids(uindices);
>  }
>  
> +static void id_reg_info_init_all(void)
> +{
> +	int i;
> +	struct id_reg_info *id_reg;
> +
> +	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
> +		id_reg = (struct id_reg_info *)id_reg_info_table[i];
> +		if (!id_reg)
> +			continue;
> +
> +		if (id_reg->init)
> +			id_reg->init(id_reg);
> +		else
> +			id_reg_info_init(id_reg);

Maybe call id_reg->init(id_reg) from within id_reg_info_init() in case we
wanted to apply some common id register initialization at some point?

> +	}
> +}
> +
>  void kvm_sys_reg_table_init(void)
>  {
>  	unsigned int i;
> @@ -2852,4 +2952,6 @@ void kvm_sys_reg_table_init(void)
>  			break;
>  	/* Clear all higher bits. */
>  	cache_levels &= (1 << (i*3))-1;
> +
> +	id_reg_info_init_all();
>  }
> -- 
> 2.33.0.882.g93a45727a2-goog
>

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
