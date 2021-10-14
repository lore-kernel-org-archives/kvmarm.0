Return-Path: <SRS0=kePE=PC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6D1C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 09:32:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9EA766109F
	for <kvmarm@archiver.kernel.org>; Thu, 14 Oct 2021 09:32:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9EA766109F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 297534B102;
	Thu, 14 Oct 2021 05:32:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M3ng2cgCI0HT; Thu, 14 Oct 2021 05:32:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 085104B108;
	Thu, 14 Oct 2021 05:32:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 744294B104
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 05:32:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bSHuCKyOtxs2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Oct 2021 05:32:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A03354B102
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 05:32:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634203945;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=wi15Ur3KlO1RcGZUz0YgACO/6MX5vtNsrghcoTR65A4=;
 b=KvTz96lhNN/WS4fql04IMwdESI97/H5/nRiISrgp3plyd0+XgoQ18N4y1DEobcN+jKJ7P6
 lU31q7nn9Dn7kkwIPAFFpSRu3TPVlobcXxvJfqvJDMrrKiTTml2J93KQrkhryKWC7akXhO
 F9nT9VqTN0FlTKhh0hpSMY+3oVhdX2g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-575-tGNi8mC4OIiJr4Z_SNw3Uw-1; Thu, 14 Oct 2021 05:32:24 -0400
X-MC-Unique: tGNi8mC4OIiJr4Z_SNw3Uw-1
Received: by mail-ed1-f70.google.com with SMTP id
 e14-20020a056402088e00b003db6ebb9526so4607751edy.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Oct 2021 02:32:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=wi15Ur3KlO1RcGZUz0YgACO/6MX5vtNsrghcoTR65A4=;
 b=0VfGqGMj1GQlijldInlgOHB3AP5nbmzAkC20eROqtgTjc9ynvtuqYpanhMbuf+KWR4
 h6fTSWl6q0uC/PPCujF5do6k3ds0MZ2PQVmRR8dcYTnFkyzpZXu4fM1+c1i+KAPiFwJ0
 n9LqMWnxXSI/CdNCx61q0pXzWG3k7po2ILAAxcpZ21Lu1SmSmEbTzOYRwJh9M5IfNvqk
 oANeSTGs7s9AAFcdKc/Ldm2WfnBMVbR0xhwKwBjAFO+6P5OOctb/CIJAlVwrDGst5l0Z
 kQW6/C25Cj15diSUQYdFLrubOS8N3bIpBfalHp9OrIl3fSd+9wD1yJ+Kwg88sWSYWvIT
 cMxQ==
X-Gm-Message-State: AOAM533bD62ziDpCIHKkhojdIdjl+QS+E3x36ro6wLBayT7Kk0kSnan3
 r0KIwQx9/izIw1uTd1sNNUCrU9v+3vVsjxrir4sZG37EDyXwrtTeUO5+QU8GBixPQJUVRr9oiyn
 HyrfMD+VhIdQAieh0A4KsXS33
X-Received: by 2002:a17:906:bb0c:: with SMTP id
 jz12mr2415832ejb.455.1634203942966; 
 Thu, 14 Oct 2021 02:32:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtVNEOaUZN/thRjJPIlW9SJat0i5pMBR7vZyAEyhc6jryGDj27ElPWGuFo/lT48kERbeIA6A==
X-Received: by 2002:a17:906:bb0c:: with SMTP id
 jz12mr2415804ejb.455.1634203942750; 
 Thu, 14 Oct 2021 02:32:22 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
 by smtp.gmail.com with ESMTPSA id r16sm1484675ejj.89.2021.10.14.02.32.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Oct 2021 02:32:22 -0700 (PDT)
Date: Thu, 14 Oct 2021 11:32:20 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v9 14/22] KVM: arm64: pkvm: Make the ERR/ERX*_EL1
 registers RAZ/WI
Message-ID: <20211014093220.ylnqb3ohuh5qayps@gator.home>
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

This is a read-only register. Is write-ignore correct? I'd expect we to
inject an exception.

> +	RAZ_WI(SYS_ERRSELR_EL1),
> +	RAZ_WI(SYS_ERXFR_EL1),

Another read-only reg.

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

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
