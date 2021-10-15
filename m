Return-Path: <SRS0=poro=PD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DBEDC4332F
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 10:13:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AADD961053
	for <kvmarm@archiver.kernel.org>; Fri, 15 Oct 2021 10:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AADD961053
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36B5B4B17D;
	Fri, 15 Oct 2021 06:13:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SYW4-nH9HOJD; Fri, 15 Oct 2021 06:13:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 398014B183;
	Fri, 15 Oct 2021 06:13:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55A354B17C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 06:13:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R4PfM+07d380 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Oct 2021 06:13:05 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5A24B17B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 06:13:05 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634292785;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=j2wKSd8eRy2pD7AkaeNeFHMLzezM6aIro+x06mkpfA4=;
 b=Hxh8wc46zFKLhNQWpdsey2SGh2mQRCdixHvIfmJCoaDfjlGx05TVZhuHfqfyrQWIE2OmKn
 TJHx+8vBLlO3wAb0frgVVOgl2czpk3EJl742+3u1vqdCz0uo0XA3PTIwIOR+NT6NujKQvH
 2/DFSjIxhLyuf2IXkJmJIdp9xsH+VLU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-kNYJM4SyOWKpRGLrbPfzYA-1; Fri, 15 Oct 2021 06:13:03 -0400
X-MC-Unique: kNYJM4SyOWKpRGLrbPfzYA-1
Received: by mail-wm1-f71.google.com with SMTP id
 6-20020a1c1906000000b0030dd4dd6659so695267wmz.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Oct 2021 03:13:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=j2wKSd8eRy2pD7AkaeNeFHMLzezM6aIro+x06mkpfA4=;
 b=0Fx56cpjo79QwSbS5zxANmm4MWb0L4SX2c4l2+BD1NoRCyrPbDD8jritNBoZ+VUbWw
 nsPt0Henc8K/9EIt6hF2NHovd6l9vvpiEC2WVloGSOHZEfq+NwBrC1VpzVautgKHdlaN
 ZJASRdCBAyufClEUzX6SvWr5UF0xkbWgbl1CAy1n96TqABSG/B45HAR4aLgb2w9ZlcpD
 wojObdgiaCqFWoByFVRNjTi50CHri0oIwzIrZDnHRkfpbFWd2Q7AmgTVvYpUo946IKGb
 OoDrV7tYAHBbF1W3urWHz/E3zMFo0LdHne65yCQRuw24PVaFW1sQJYCmwazAq19QGczD
 oe+Q==
X-Gm-Message-State: AOAM533L546cpzK6ns1wZse1fjm8IopzTfmQutzNzp1ht+c2Re6GC6GD
 fHpwuwDaIZBzdbywZekBY8VUMIB/GoNM07eoizf48m3Xtee14k29GHFiYuKoaB4Zyvzb/SxCF0W
 om5/cE4LLOhI7S4jjdAWLqmNr
X-Received: by 2002:a1c:208:: with SMTP id 8mr25341141wmc.114.1634292782050;
 Fri, 15 Oct 2021 03:13:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySQyml7m4lUYWHcFoNKT7dSS0DKGc0cSC3P/sTwgEM1cRhAW6jGm/Uuh+3uSwKU+ZfUSK9FQ==
X-Received: by 2002:a1c:208:: with SMTP id 8mr25341109wmc.114.1634292781779;
 Fri, 15 Oct 2021 03:13:01 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id g1sm11222799wmk.2.2021.10.15.03.13.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 15 Oct 2021 03:13:01 -0700 (PDT)
Date: Fri, 15 Oct 2021 12:12:59 +0200
From: Andrew Jones <drjones@redhat.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH 01/25] KVM: arm64: Add has_reset_once flag for vcpu
Message-ID: <20211015101259.4lmlgk5ll2mrnohd@gator>
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-2-reijiw@google.com>
MIME-Version: 1.0
In-Reply-To: <20211012043535.500493-2-reijiw@google.com>
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

On Mon, Oct 11, 2021 at 09:35:11PM -0700, Reiji Watanabe wrote:
> Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
> if the vCPU reset has been done once, for later use.
> 
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 2 ++
>  arch/arm64/kvm/reset.c            | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f8be56d5342b..9b5e7a3b6011 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -384,6 +384,7 @@ struct kvm_vcpu_arch {
>  		u64 last_steal;
>  		gpa_t base;
>  	} steal;
> +	bool has_reset_once;
>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> @@ -449,6 +450,7 @@ struct kvm_vcpu_arch {
>  
>  #define vcpu_has_sve(vcpu) (system_supports_sve() &&			\
>  			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> +#define	vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
>  
>  #ifdef CONFIG_ARM64_PTR_AUTH
>  #define vcpu_has_ptrauth(vcpu)						\
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 5ce36b0a3343..4d34e5c1586c 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	if (loaded)
>  		kvm_arch_vcpu_load(vcpu, smp_processor_id());
>  	preempt_enable();
> +
> +	if (!ret && !vcpu->arch.has_reset_once)
> +		vcpu->arch.has_reset_once = true;
> +
>  	return ret;
>  }
>  
> -- 
> 2.33.0.882.g93a45727a2-goog
>

Hi Reiji,

Can't we use kvm_vcpu_initialized(vcpu)? vcpu->arch.target should
only be >= when we've successfully reset the vcpu at least once.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
