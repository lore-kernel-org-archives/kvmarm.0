Return-Path: <SRS0=mpH5=NJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19EC7C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 21:45:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 806FC610A6
	for <kvmarm@archiver.kernel.org>; Wed, 18 Aug 2021 21:45:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 806FC610A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD38A4B0CC;
	Wed, 18 Aug 2021 17:45:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FuSQEsgmXIoR; Wed, 18 Aug 2021 17:45:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0546A4B0D2;
	Wed, 18 Aug 2021 17:45:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B60654B0CC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 17:45:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bMzLKwHMbcpe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Aug 2021 17:45:11 -0400 (EDT)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 491794B0BC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 17:45:11 -0400 (EDT)
Received: by mail-pl1-f173.google.com with SMTP id a5so2694204plh.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Aug 2021 14:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=muQCcqaPenKykG4PGOy+YxdceqzyYMRDPJOUz8KbyH0=;
 b=TexX8C3gmVxHzDuCEwQRrA5o/2oXdFco2ACSFpQmgmxiHjLGxJI3P5NtFHwrAo7JSQ
 4e1LI98IUf45La8KMqOqirtwGyAayWFz/u2zn6V7H2zMBiJZgLKuoTMHeS3A9KUyZn/G
 OPKZdImH3sH8BQQNACUqUrOjxwfBrNA1T34tHRAbVubPFhasl+HWOPmhsHntGlW6ar6e
 XcG0O64PG81S8SXwSC8Op0rH5qvnG8AfcRchXmfeGXC+UMF2CkfpgvNPNkkhQyqhpETE
 /Qh4oCmGyopz9nlk65pUw42LtQ1hIoPAZSg3m0dlsJy3sk4k4Me0/mrAgJUC71QujBTH
 EV2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=muQCcqaPenKykG4PGOy+YxdceqzyYMRDPJOUz8KbyH0=;
 b=WVe2LZepKM4+hUmpCQOMJzs+mwotQTWx+DAQ1JwazDbNbpA3olkdTmb7epHo8nv0mJ
 RrpAcZkBOs8svel3mTFsMjC00VJmp48Mn3wU9as+ZfJgTO7T2ufzXRwLAAyTTNr2BM1e
 cX8O4+3gwI3blo2aVmEXJxrBxY21QYE4tg+DMrFqkHBTuNn+JoOSQzYfpFFhAJX1wjxN
 MXnE/nl3ca8X2TmeNl+lT+5FIbGeKaZq6Q4gNNwPidL9ARn3k7YDEdigAUl1deQKCKl2
 JPINtdWpbhcV9OAk2JvXKnrGZjfZpUK/rP5tGMMDsNmy0b6q3+cOnrV70q2GNRGCy/pY
 II1Q==
X-Gm-Message-State: AOAM531NkPtswDhVMSoU3kmNkXDBSQttRmvp5mpXTzL+UU+5y9hb3kWi
 HIFfO6dXtI8iYzmuT8T+uOMH1g==
X-Google-Smtp-Source: ABdhPJyBiBhnl7bejibYMgU7hymcLriNmoYbU76Tnmv+ZM5Ar+/vDRcYxghD3weIQN8BHvvxpxxKlg==
X-Received: by 2002:a17:90a:2845:: with SMTP id
 p5mr11221708pjf.96.1629323109999; 
 Wed, 18 Aug 2021 14:45:09 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id y1sm829132pga.50.2021.08.18.14.45.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 18 Aug 2021 14:45:09 -0700 (PDT)
Date: Wed, 18 Aug 2021 14:45:04 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
Message-ID: <YR1/YEY8DX+r05nt@google.com>
References: <20210818213205.598471-1-ricarkol@google.com>
 <CAOQ_QshVenuri8WdZdEis4szCv03U0KRNt4CqDNtvUBsqBqUoA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOQ_QshVenuri8WdZdEis4szCv03U0KRNt4CqDNtvUBsqBqUoA@mail.gmail.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, rananta@google.com, pshier@google.com,
 catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu
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

On Wed, Aug 18, 2021 at 02:34:03PM -0700, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Wed, Aug 18, 2021 at 2:32 PM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > vgic_get_irq(intid) is used all over the vgic code in order to get a
> > reference to a struct irq. It warns whenever intid is not a valid number
> > (like when it's a reserved IRQ number). The issue is that this warning
> > can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).
> >
> > Drop the WARN call from vgic_get_irq.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > index 111bff47e471..81cec508d413 100644
> > --- a/arch/arm64/kvm/vgic/vgic.c
> > +++ b/arch/arm64/kvm/vgic/vgic.c
> > @@ -106,7 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> >         if (intid >= VGIC_MIN_LPI)
> >                 return vgic_get_lpi(kvm, intid);
> >
> > -       WARN(1, "Looking up struct vgic_irq for reserved INTID");
> 
> Could we maybe downgrade the message to WARN_ONCE() (to get a stack)
> or pr_warn_ratelimited()? I agree it is problematic that userspace can
> cause this WARN to fire, but it'd be helpful for debugging too.
> 

Was thinking about that, until I found this in bug.h:

	/*
	 * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
	 * significant kernel issues that need prompt attention if they should ever
	 * appear at runtime.
	 *
	 * Do not use these macros when checking for invalid external inputs
	 * (e.g. invalid system call arguments, or invalid data coming from
	 * network/devices),

Just in case, KVM_IRQ_LINE returns -EINVAL for an invalid intid (like
1020). I think it's more appropriate for the vmm to log it. What do you
think?

Thanks,
Ricardo

> --
> Thanks,
> Oliver
> 
> >         return NULL;
> >  }
> >
> > --
> > 2.33.0.rc2.250.ged5fa647cd-goog
> >
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
