Return-Path: <SRS0=WLU+=EB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDF5C4363A
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:36:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E60F520780
	for <kvmarm@archiver.kernel.org>; Mon, 26 Oct 2020 14:36:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Pqj0b7NA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E60F520780
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 605EE4B45C;
	Mon, 26 Oct 2020 10:36:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5+jfHlBGfP0c; Mon, 26 Oct 2020 10:36:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FF404B4C0;
	Mon, 26 Oct 2020 10:36:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF9D64B454
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:36:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OLn59nNiZRN4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2020 10:36:29 -0400 (EDT)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
 [209.85.128.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D856F4B43D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 10:36:28 -0400 (EDT)
Received: by mail-wm1-f68.google.com with SMTP id c16so12721536wmd.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2020 07:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=MerDsv/XmBWBzmLIOlTgREdfdkOm0MotoeVYk/L2CXA=;
 b=Pqj0b7NAxAQeGChbWijWaY4tsNONaAR9oWWuCz66Rw4h3OvJOXQRMudZ+Rp+j3Bo3X
 JncmRLLVjT6tY5sgPuZ7iWz8Bj0uvPru028mnI+pJs8h+/FqmdDCNbgCRnrlFel++ifw
 iOwzQyimqGCGDTwM/i5wxNwoa8GS+9T2U4WXahJW4qImsDZuVCP+BI69yLwIZb0e5TP6
 DVbNdVRVVwWXmBfiPsfcNkKasuDoPIW1bsL3jUbGkGzijWc7CnBMfhG4C+FRJ4ukWyUK
 5hG0llpleWM1WFGvZNHkZWqZd/2e0t93rAFOREJp1pHqaLHvNnma1EKIcplUoPHwUX9S
 HdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=MerDsv/XmBWBzmLIOlTgREdfdkOm0MotoeVYk/L2CXA=;
 b=YXj/bSL2FkBmAlFBCI6p+BhtTUav/2XVG0yj/J4RM9S3tfc/dJxbUMmTsdSXuwikyE
 zGGTroZ+LdYnW4Cl2LV3QMiZMJvZMg1tjow/FEcSMuBkQ7VP70gNbTTNpZL1maegFjv5
 6NyMqQYIvtxgDFxwikGiI6DTna70ZKzr7r4On1gpwX0+r2X5Bh493D7xmkttjqyQbTEo
 236GOsca3l8v8XDV/VTKgPoiccNtGz4lZUE7ZyNGCdbk3k79B58p6aiX0VoKJ8B2cQH1
 Byfx9AUKU7koez+/z3WAlGZkIqWSy4WQASOJ44lUQBpgL9pvNPCaa0DKj36azDGiaauo
 3MhA==
X-Gm-Message-State: AOAM5314naXZapS0rMQAAAVhZY8AcYaNy2ln49AKO9uCTqQZSUMU/tGC
 GX/yRwVY/0uotEi1DGA7477MJg==
X-Google-Smtp-Source: ABdhPJyeJBArajEh/qV0h65NryMws8JKnoPSvxRiqZYn8gQ8o5uMxcIaCVxiY2Ofp3J6w3GhdnhfXw==
X-Received: by 2002:a7b:c0d3:: with SMTP id s19mr6858264wmh.102.1603722987718; 
 Mon, 26 Oct 2020 07:36:27 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 by smtp.gmail.com with ESMTPSA id c18sm20080039wmk.36.2020.10.26.07.36.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 26 Oct 2020 07:36:27 -0700 (PDT)
Date: Mon, 26 Oct 2020 14:36:23 +0000
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/8] KVM: arm64: Don't corrupt tpidr_el2 on failed HVC call
Message-ID: <20201026143623.GA2229434@google.com>
References: <20201026095116.72051-1-maz@kernel.org>
 <20201026095116.72051-2-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201026095116.72051-2-maz@kernel.org>
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
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

On Monday 26 Oct 2020 at 09:51:09 (+0000), Marc Zyngier wrote:
> The hyp-init code starts by stashing a register in TPIDR_EL2
> in in order to free a register. This happens no matter if the
> HVC call is legal or not.
> 
> Although nothing wrong seems to come out of it, it feels odd
> to alter the EL2 state for something that eventually returns
> an error.
> 
> Instead, use the fact that we know exactly which bits of the
> __kvm_hyp_init call are non-zero to perform the check with
> a series of EOR/ROR instructions, combined with a build-time
> check that the value is the one we expect.

Alternatively, could we make __kvm_hyp_init non-SMCCC compliant? While I
understand how it makes sense to be compliant for 'proper' HVCs, this
one really is an odd one that only makes sense on a very transient state.
That would let us define our convention, and we can just say x0-x18 can
be clobbered like any function call, which eradicates the issue Andrew
tried to avoid with this tpidr_el2 trick.

Thoughts?

Thanks,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
