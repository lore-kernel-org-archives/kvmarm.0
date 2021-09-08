Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9112EC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 21:50:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 02E1E610F8
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 21:50:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 02E1E610F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8250B4B090;
	Wed,  8 Sep 2021 17:50:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id u8y1+4FhdS9s; Wed,  8 Sep 2021 17:50:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AB3D4B0C2;
	Wed,  8 Sep 2021 17:50:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1A014B0A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 17:50:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k6c-5VjV9tST for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 17:50:21 -0400 (EDT)
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com
 [209.85.215.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 927054B090
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 17:50:21 -0400 (EDT)
Received: by mail-pg1-f171.google.com with SMTP id r2so4017807pgl.10
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 14:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Mpyy4auQpAVXPHkb/Qt9jfSIDOOiq0JFvfG5mQuouHk=;
 b=A2IVXrHWAam/jbYtd09fnokjevxMx7ZpbOvIT68k4TqNRvIh/8wukp0MGqbRJy+a5n
 BFC6hV4Ld87OIsLiIJ447d4fFHTDeMekke1ahzsmqcjhlubjLr4vdb6rFQ2jZ1DqUpxR
 0zYlu3UzQD9S7PiO3sY2pwgW6ZJPS7cidIhj45+ELubarexN1oSf8QCMLuEAJ8zpDBs5
 QFLoXDdj/JIE2J56GwPPsBxU/GQtetWPnmL9Y9i70xe3kzV+5CQFS686bp52iH4zpivK
 61MDJsx3oOLTOWtt71s5L+Sswup0lwv30hTeazg9+u4E72AsSgQsBScRdXLqAoK6L8aP
 SuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Mpyy4auQpAVXPHkb/Qt9jfSIDOOiq0JFvfG5mQuouHk=;
 b=OYJivQ13wFoUe9huav5/7R6EJ8pZsIj1SQoDrk+sHFzwzR8feCOLumE28W4MmlyD05
 4heMnmRW465yJOxeX9g+Kyq4SYG86Z4BTHrcpXcEObSRoFbMClpN55wK6E2F7mpQteRk
 8+IWUkECa/e2NXUV/pJTuylN/a1OdicxnQIfuLHhs68pEJgIjjtXqnq/t0n71MUnQROU
 YjIU4rgcq6uRBtGH1dCho7WRAv6jjsVJulw2awdapwAD5Mai2uZHyi8AcaxD6nOU4g9s
 ZrdgX0uFvJEcKdqJRDl0eERZBXrvvQdWApq7YgbsoHxMZmOX6FBrzPhhoE2FseOmzzmk
 H+cg==
X-Gm-Message-State: AOAM5331ZgFhu9q2K3rZRXA6i0aiJEw2x1hkkwEsw008hQXqb2dDg+07
 iUKiwF0646dTKifbUdp7V+zhmQ==
X-Google-Smtp-Source: ABdhPJzRyUcE2S9uzNLkmd1EozoX+VZL0gSRHBDl1S+xIMkCCLxFIXjwGIL8REirGCUlmuZlSiZe7Q==
X-Received: by 2002:a63:374f:: with SMTP id g15mr284346pgn.2.1631137820471;
 Wed, 08 Sep 2021 14:50:20 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id h13sm134675pgf.14.2021.09.08.14.50.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 08 Sep 2021 14:50:19 -0700 (PDT)
Date: Wed, 8 Sep 2021 14:50:16 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
Message-ID: <YTkwGHdBcy7v/mSA@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <YTkr1c7S0wPRv6hH@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YTkr1c7S0wPRv6hH@google.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

On Wed, Sep 08, 2021 at 09:32:05PM +0000, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Wed, Sep 08, 2021 at 02:03:19PM -0700, Ricardo Koller wrote:
> > Extend vgic_v3_check_base() to verify that the redistributor regions
> > don't go above the VM-specified IPA size (phys_size). This can happen
> > when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> > 
> >   base + size > phys_size AND base < phys_size
> > 
> > vgic_v3_check_base() is used to check the redist regions bases when
> > setting them (with the vcpus added so far) and when attempting the first
> > vcpu-run.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > index 66004f61cd83..5afd9f6f68f6 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> >  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> >  			rdreg->base)
> >  			return false;
> 
> Can we drop this check in favor of explicitly comparing rdreg->base with
> kvm_phys_size()? I believe that would be more readable.
>

You mean the integer overflow check above? in that case, I would prefer
to leave it, if you don't mind. It seems that this type of check is used
in some other places in KVM (like kvm_assign_ioeventfd and
vgic_v3_alloc_redist_region).

> > +
> > +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > +			kvm_phys_size(kvm))
> > +			return false;
> >  	}
> >  
> >  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
> 
> --
> Thanks,
> Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
