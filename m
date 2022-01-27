Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E0EC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 07:51:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DC9249F20;
	Thu, 27 Jan 2022 02:51:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X+X1PMwzv6sJ; Thu, 27 Jan 2022 02:51:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E285A4A014;
	Thu, 27 Jan 2022 02:51:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2CEC49F27
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 02:51:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dhT14G4z9TzF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 02:51:25 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B4F49F20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 02:51:25 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643269885;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=GZX/pfOEsztdvqNPhksRj9ximKWEK/m51aO4OO9gIOw=;
 b=b7Jp4AcX3kuHQxt/Fk5erIL/0UiD5952SRoSIA7LKavxlHgr/qmBXNKI30Ag9x0NH7nSN+
 JaIlOmwGGHO0hjrxyUZJyCQW672B5XDVaiUJE3v2MQ9B+oFDwSiJrUObG+x1wDQuhmBPFK
 2ZCTfVMKyTfiagqs/sBR4qZm+6JHrME=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-uM8NzwD6P--IdxSVcC_xuQ-1; Thu, 27 Jan 2022 02:51:24 -0500
X-MC-Unique: uM8NzwD6P--IdxSVcC_xuQ-1
Received: by mail-ej1-f71.google.com with SMTP id
 kw5-20020a170907770500b006ba314a753eso919791ejc.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 23:51:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GZX/pfOEsztdvqNPhksRj9ximKWEK/m51aO4OO9gIOw=;
 b=XOrg9lcPX2aY0tlnbXaB8LYnsCgJx/M0/tZLgkYPr4yNHlNRnZj+rykCHL3CTj36ns
 ltXE15VRtPe1ltjM8zW0ZyDpppFi/UgX5Y+7WPyNct3FeiMtqFvwHbgGkYDtPlkiqBNJ
 SArCvqQBFC/9Znk7aGmixs0BZP97MsCiD/sJ6ovDitzJ6JNNXmuShTDLI1mTjn0Tr8VY
 QLHjaIU05rHB+Kd7tmltSR1vF3MbOD7xrmmzx+uDMxetqer3+JDHS/hHu1NGtBl8jVXw
 IBm6giHgu8hX1Ob2P8fpa5UPA/5CXzDfM2NxCsGOOso7/rP9oF9coFXg+O/AA/fUbwiv
 wuAA==
X-Gm-Message-State: AOAM532cHKb0LjD9V3a2qSYPdf8wAjsxqNTH19qSMwWby8mjuI3Pydzb
 AlHaRJTlfMtebj6jlDB7vl/iOecENyC1aud5graFBPCK1CO68q7e0jTQU4Pm5Isc4+SbsgNXyve
 J3prhtcq0x/pjDgFT9+vvawJ0
X-Received: by 2002:a17:907:7ba9:: with SMTP id
 ne41mr2137815ejc.554.1643269883098; 
 Wed, 26 Jan 2022 23:51:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwG/4UQhcMKE386PoihoaUB7txnfoFbjmOGSKcgi5XKPa25Kh8n1GHpKiCaWiNcG0+jyHaPGA==
X-Received: by 2002:a17:907:7ba9:: with SMTP id
 ne41mr2137807ejc.554.1643269882938; 
 Wed, 26 Jan 2022 23:51:22 -0800 (PST)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id g15sm10892632edy.77.2022.01.26.23.51.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 26 Jan 2022 23:51:22 -0800 (PST)
Date: Thu, 27 Jan 2022 08:51:20 +0100
From: Andrew Jones <drjones@redhat.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 5/5] kvm: selftests: aarch64: use a tighter assert in
 vgic_poke_irq()
Message-ID: <20220127075120.5ntwadlgf2ncd2ua@gator>
References: <20220127030858.3269036-1-ricarkol@google.com>
 <20220127030858.3269036-6-ricarkol@google.com>
MIME-Version: 1.0
In-Reply-To: <20220127030858.3269036-6-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu
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

On Wed, Jan 26, 2022 at 07:08:58PM -0800, Ricardo Koller wrote:
> vgic_poke_irq() checks that the attr argument passed to the vgic device
> ioctl is sane. Make this check tighter by moving it to after the last
> attr update.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Cc: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/lib/aarch64/vgic.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> index 79864b941617..f365c32a7296 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
> @@ -138,9 +138,6 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
>  	uint64_t val;
>  	bool intid_is_private = INTID_IS_SGI(intid) || INTID_IS_PPI(intid);
>  
> -	/* Check that the addr part of the attr is within 32 bits. */
> -	assert(attr <= KVM_DEV_ARM_VGIC_OFFSET_MASK);
> -
>  	uint32_t group = intid_is_private ? KVM_DEV_ARM_VGIC_GRP_REDIST_REGS
>  					  : KVM_DEV_ARM_VGIC_GRP_DIST_REGS;
>  
> @@ -150,6 +147,9 @@ static void vgic_poke_irq(int gic_fd, uint32_t intid,
>  		attr += SZ_64K;
>  	}
>  
> +	/* Check that the addr part of the attr is within 32 bits. */
> +	assert((attr & ~KVM_DEV_ARM_VGIC_OFFSET_MASK) == 0);
> +
>  	/*
>  	 * All calls will succeed, even with invalid intid's, as long as the
>  	 * addr part of the attr is within 32 bits (checked above). An invalid
> -- 
> 2.35.0.rc0.227.g00780c9af4-goog
>

 
Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
