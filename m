Return-Path: <SRS0=kePE=PC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25596C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 16:20:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61CAF610EA
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 16:20:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 61CAF610EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2F0F4B12E;
	Thu, 14 Oct 2021 12:20:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1wIbtin2nJry; Thu, 14 Oct 2021 12:20:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DA9D4B0EC;
	Thu, 14 Oct 2021 12:20:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 049874B092
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 12:20:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2iL+DjdrlSlE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Oct 2021 12:20:46 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A9754B08B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 12:20:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634228445;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=f/x0GMWtXzbHVSq1sXMLR+bmmD/sS6+vnmT+tCy96wk=;
 b=Xe7lzAJj6gxj2OtO71TRwGWs8iTIpCS4RNr3k4RW/VVWHCKirTvdV7OHA8s9feea/AfRt0
 pXP4hW7v1w/CKDXL8sWI2cu3qV3ZN8VKmXgHuG+tYzsJ590OzGVkUtWKTNJ9u6RTdastB4
 /DHEiQQJzbottWOCC1X7iKkH1FJv4rM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-Qa4nZ_9ON3ugiQfKlVUlRQ-1; Thu, 14 Oct 2021 12:20:44 -0400
X-MC-Unique: Qa4nZ_9ON3ugiQfKlVUlRQ-1
Received: by mail-qt1-f199.google.com with SMTP id
 q24-20020ac84118000000b002a6d14f21e9so4845115qtl.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 09:20:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=f/x0GMWtXzbHVSq1sXMLR+bmmD/sS6+vnmT+tCy96wk=;
 b=kNKfj07OxGAfT/qHDNOS+EibZ1trZQXslc5RUS1QsxXHNHFmyAG1NpLAyA6bttIpVJ
 UmS/vS4s6JmIyigim+n87EMFpT9bX9C8b4l7KFmCdRoMeA4lRksjXVav1w3icav1gTBT
 dyBjXGBkHliEJ+xwx1i6TmvdHiwP3mM2Z344XI8CVTKiWSYyo+rh1MNwxQPeJcE+CagS
 o5zst9xhnfVTrgxJ8eEkyuNQaKHCxT+eJ/DRp6kc7szxKY+GKc0/25k1TdiWSjNoEmPn
 Y39sh6huqtjM41WesP2q64Iv4RLNN+4s0GzjATAyFZy8C1DFCAK57kYYbEl62/pqxOqv
 2RxQ==
X-Gm-Message-State: AOAM533ekwAOWefZZtuxIFq97mLyj/HL7FJHBrTq8hCWNJjJs/dRl6iL
 Vqn77qzpVU7ZlPhH8+7h5fe7IYwOnf0itMFFChNyaQvdVsvTwAXqXcqZvweyAc2i+fTr7sXt0oz
 CC5nhFpcZiIwDxvWlaKLLtRZy
X-Received: by 2002:ac8:10a:: with SMTP id e10mr7607143qtg.406.1634228444123; 
 Thu, 14 Oct 2021 09:20:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxP6s5Caxb2ESan17RuUDUYd/oN90Ga/T3lVfd6666txoozRp5nG/hxM/ybPlKlcMqK0iKAQQ==
X-Received: by 2002:ac8:10a:: with SMTP id e10mr7607116qtg.406.1634228443916; 
 Thu, 14 Oct 2021 09:20:43 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id f15sm1578546qtm.37.2021.10.14.09.20.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Oct 2021 09:20:43 -0700 (PDT)
Date: Thu, 14 Oct 2021 18:20:38 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 14/22] KVM: arm64: pkvm: Make the ERR/ERX*_EL1
 registers RAZ/WI
Message-ID: <20211014162038.cxdoedqlbsxtzw5l@gator>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <20211013120346.2926621-4-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211013120346.2926621-4-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, pbonzini@redhat.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Wed, Oct 13, 2021 at 01:03:38PM +0100, Marc Zyngier wrote:
> The ERR*/ERX* registers should be handled as RAZ/WI, and there
> should be no need to involve EL1 for that.
> 
> Add a helper that handles such registers, and repaint the sysreg
> table to declare these registers as RAZ/WI.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 33 ++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index f125d6a52880..042a1c0be7e0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -248,6 +248,16 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  	return pvm_read_id_reg(vcpu, reg_to_encoding(r));
>  }
>  
> +/* Handler to RAZ/WI sysregs */
> +static bool pvm_access_raz_wi(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	if (!p->is_write)
> +		p->regval = 0;
> +
> +	return true;
> +}
> +
>  /*
>   * Accessor for AArch32 feature id registers.
>   *
> @@ -270,9 +280,7 @@ static bool pvm_access_id_aarch32(struct kvm_vcpu *vcpu,
>  	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1),
>  		     PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) > ID_AA64PFR0_ELx_64BIT_ONLY);
>  
> -	/* Use 0 for architecturally "unknown" values. */
> -	p->regval = 0;
> -	return true;
> +	return pvm_access_raz_wi(vcpu, p, r);
>  }
>  
>  /*
> @@ -301,6 +309,9 @@ static bool pvm_access_id_aarch64(struct kvm_vcpu *vcpu,
>  /* Mark the specified system register as an AArch64 feature id register. */
>  #define AARCH64(REG) { SYS_DESC(REG), .access = pvm_access_id_aarch64 }
>  
> +/* Mark the specified system register as Read-As-Zero/Write-Ignored */
> +#define RAZ_WI(REG) { SYS_DESC(REG), .access = pvm_access_raz_wi }
> +
>  /* Mark the specified system register as not being handled in hyp. */
>  #define HOST_HANDLED(REG) { SYS_DESC(REG), .access = NULL }
>  
> @@ -388,14 +399,14 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
>  	HOST_HANDLED(SYS_AFSR1_EL1),
>  	HOST_HANDLED(SYS_ESR_EL1),
>  
> -	HOST_HANDLED(SYS_ERRIDR_EL1),
> -	HOST_HANDLED(SYS_ERRSELR_EL1),
> -	HOST_HANDLED(SYS_ERXFR_EL1),
> -	HOST_HANDLED(SYS_ERXCTLR_EL1),
> -	HOST_HANDLED(SYS_ERXSTATUS_EL1),
> -	HOST_HANDLED(SYS_ERXADDR_EL1),
> -	HOST_HANDLED(SYS_ERXMISC0_EL1),
> -	HOST_HANDLED(SYS_ERXMISC1_EL1),
> +	RAZ_WI(SYS_ERRIDR_EL1),
> +	RAZ_WI(SYS_ERRSELR_EL1),
> +	RAZ_WI(SYS_ERXFR_EL1),
> +	RAZ_WI(SYS_ERXCTLR_EL1),
> +	RAZ_WI(SYS_ERXSTATUS_EL1),
> +	RAZ_WI(SYS_ERXADDR_EL1),
> +	RAZ_WI(SYS_ERXMISC0_EL1),
> +	RAZ_WI(SYS_ERXMISC1_EL1),
>  
>  	HOST_HANDLED(SYS_TFSR_EL1),
>  	HOST_HANDLED(SYS_TFSRE0_EL1),
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
