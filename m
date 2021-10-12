Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD562C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 12:00:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3FF5C610C7
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 12:00:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3FF5C610C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBBB24A534;
	Tue, 12 Oct 2021 08:00:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Iq1mU01ISdUc; Tue, 12 Oct 2021 08:00:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 858B94083E;
	Tue, 12 Oct 2021 08:00:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4635F405EE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 08:00:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kFHZ0hrLlfdQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 08:00:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 678AF4048B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 08:00:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634040045;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=ArgBgcgWfB7RQoup0CVP5TK2CbpCWPXqRtbofxvJguQ=;
 b=fN/zRbb0+3xTK/kDAJ1PcmDfuFC7qYK3S14/eHADQVq5RQU1m0Z0PZl9iwBEaBXPo+CjgN
 2TsRBW9TGO1nqrRz0R3TsZV/GuKfqeWqMdVXyHwmLssbcgTy88RE+GhpV7S59EOwlH5hUc
 oDBxpVbixAsT3GyKQ4FxVoTlxLH8Qs8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-0zLlTnowMySs4GlofACvmA-1; Tue, 12 Oct 2021 08:00:43 -0400
X-MC-Unique: 0zLlTnowMySs4GlofACvmA-1
Received: by mail-wr1-f69.google.com with SMTP id
 f1-20020a5d64c1000000b001611832aefeso2878054wri.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 05:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ArgBgcgWfB7RQoup0CVP5TK2CbpCWPXqRtbofxvJguQ=;
 b=sxbk/emUpYIYMJeo55+bUZwOr2yrRGfk3z+ndLol8meKRj4Irt72sa5xUNm/bfLQNR
 7qWxyHLHhzwCBe295BHaIp3vdv1NbVpZsov0mrn/FQvgLRtwA/9+3ezkMxEVzTBhdMJN
 Di9QKqE4fpLdoQtMW4Nz0QFNDDyveH1MAXEKlMmyZ1YoHNglAXXxlA6yB4J6dslHIp4D
 x1V7asHErs+1lty59rPEbGOcsRdRVd6DmClUEh3h9jXYig24zdWNC1OM8M27X/U6fKXI
 A3ymNLPhs0Pn9AqjqQG8tY4dEfxe4yIPDd4LdyvFYu1W58diudywvMny6dHGSZecO+CC
 zYUg==
X-Gm-Message-State: AOAM530jEUbteCCWV0VTusdNC3GNRYPgipdBZqttGI5udsY7xmWB8ON1
 7Na8TygkMbIFEvH+/7yAvCYPnnGU/7NYBuzXNB9H3TWrgNSdHRaYpgyc5BNx+ZoTWpvGvaaDrSy
 sdRqRxs5Cg1cAwAC3Zdl3MLfp
X-Received: by 2002:adf:dc43:: with SMTP id m3mr30931543wrj.66.1634040042654; 
 Tue, 12 Oct 2021 05:00:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy098exPSYXNknZRGqFiNvB6xq+K6t+GZwbU2j/QF+La5PGmZVBnf+CM7JtvpArPd++nJPDzg==
X-Received: by 2002:adf:dc43:: with SMTP id m3mr30931488wrj.66.1634040042184; 
 Tue, 12 Oct 2021 05:00:42 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
 by smtp.gmail.com with ESMTPSA id a63sm398292wmd.34.2021.10.12.05.00.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 12 Oct 2021 05:00:41 -0700 (PDT)
Date: Tue, 12 Oct 2021 14:00:40 +0200
From: Andrew Jones <drjones@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Fix reporting of endianess when the access
 originates at EL0
Message-ID: <20211012120040.4tfkzlm7uju2n3sa@gator>
References: <20211012112312.1247467-1-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20211012112312.1247467-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Oct 12, 2021 at 12:23:12PM +0100, Marc Zyngier wrote:
> We currently check SCTLR_EL1.EE when computing the address of
> a faulting guest access. However, the fault could have occured at
> EL0, in which case the right bit to check would be SCTLR_EL1.E0E.
> 
> This is pretty unlikely to cause any issue in practice: You'd have
> to have a guest with a LE EL1 and a BE EL0 (or the other way around),
> and have mapped a device into the EL0 page tables.

I wonder if that's something a usermode network driver might want?

> 
> Good luck with that!
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 1fadb5d98a36..14ee8319b1ce 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -396,7 +396,10 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
>  	if (vcpu_mode_is_32bit(vcpu))
>  		return !!(*vcpu_cpsr(vcpu) & PSR_AA32_E_BIT);
>  
> -	return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & (1 << 25));
> +	if (vcpu_mode_priv(vcpu))
> +		return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & SCTLR_ELx_EE);
> +	else
> +		return !!(vcpu_read_sys_reg(vcpu, SCTLR_EL1) & SCTLR_EL1_E0E);
>  }
>  
>  static inline unsigned long vcpu_data_guest_to_host(struct kvm_vcpu *vcpu,
> -- 
> 2.30.2
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
