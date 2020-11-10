Return-Path: <SRS0=+U1N=EQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DEE8C388F7
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 09:24:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A34892080A
	for <kvmarm@archiver.kernel.org>; Tue, 10 Nov 2020 09:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="onpjg59A"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A34892080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 978194B7BA;
	Tue, 10 Nov 2020 04:24:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yMTNRLElV+zc; Tue, 10 Nov 2020 04:24:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 966474B7B0;
	Tue, 10 Nov 2020 04:24:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FEAB4B7AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 04:24:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 75GRcsQhrCJU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Nov 2020 04:24:08 -0500 (EST)
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com
 [209.85.128.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2BADC4B526
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 04:24:08 -0500 (EST)
Received: by mail-wm1-f67.google.com with SMTP id p22so2268685wmg.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Nov 2020 01:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ieiicjOVe5riWnNrGnNnOrGqxp8ieWPyQM5kKffkvIM=;
 b=onpjg59Abm3k/FX1eLLE+4S8TaHOTOxJQpqlR1b9xO2ff40pv8k9S77fKMkdTIZLWo
 Bh04quAn5x4D2JXa07xkgK5jMzsHoH6lxOJSVSMfaNKgpiNR85WlPOvpeKq3x07s0gOE
 i6coaA1gTlFR2JR3uPkHuiGNlae1Ayeh+rpIWAImirMVVOho58G848Bx7tzkckBQdpen
 b/ByI6ZrBCQ1V05YD4/qQSoG6rwTFV67xgf1ogX4l+ClrYWbNxM9XTnmai5pjFCUA2rA
 VSinRm1J4g/2haCwW2bCDPJCsjEZUJBu5Yhp5pR/2Flo9QLXkUKG+6/CeHZscobnT22D
 oggQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ieiicjOVe5riWnNrGnNnOrGqxp8ieWPyQM5kKffkvIM=;
 b=cPPhyXBjQRRZlfXM62JBdEfbMlVbx5zzTWf+pCqiCmT13DFV1GyKHwp0E+mZOxiOV+
 wV2GyG9u/ElKnGtyb0gJcr0wSZ7tKy68GsW4ei+3/l+/73yCzKOH8VkL5E9UL6Y+alWm
 LKFqClPXwOI+BPm2trdnLgw9Cd65CB+aZmYX3SpGFp0C9vv1+YovuG9/2HHOdcLop577
 cvH7lQlpsNG+4U+PgKhF97GTb+cIbjZk4q8HmMYCjIEyVc89mxYUPHOkVhjUMwCtnVOq
 gfIvrz0E8nYq0gvCfMf76SwmHyr9owv7RKnJCjMebbPI8QfNZhqaGtNOyGEAbjwrNFcI
 TbAw==
X-Gm-Message-State: AOAM531/Z2HX9ybbHm6Py/ZfuO7vbyrCMNMtzYyKf+th11kW281ULkad
 mgPTeaeXRyqwDJWNyyovsv+syg==
X-Google-Smtp-Source: ABdhPJy1icaD3sfcujReiQX6aFmIuki+belXPIbhl5kdHjIfsFAhrckKgShoPSKl9gc1Eu8Xq4XXTA==
X-Received: by 2002:a1c:63c4:: with SMTP id x187mr3704674wmb.172.1605000246872; 
 Tue, 10 Nov 2020 01:24:06 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:870:7715:aaa1:475e])
 by smtp.gmail.com with ESMTPSA id q17sm1248351wro.36.2020.11.10.01.24.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 10 Nov 2020 01:24:05 -0800 (PST)
Date: Tue, 10 Nov 2020 09:24:04 +0000
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v1 17/24] kvm: arm64: Add __hyp_pa_symbol helper macro
Message-ID: <20201110092404.lduvqjpjzeea57vi@google.com>
References: <20201109113233.9012-1-dbrazdil@google.com>
 <20201109113233.9012-18-dbrazdil@google.com>
 <20201109165933.GA447754@google.com>
 <1951645a457232caeca323bec2af5408@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1951645a457232caeca323bec2af5408@kernel.org>
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
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

On Mon, Nov 09, 2020 at 06:10:05PM +0000, Marc Zyngier wrote:
> On 2020-11-09 16:59, Quentin Perret wrote:
> > Hey David,
> > 
> > On Monday 09 Nov 2020 at 11:32:26 (+0000), David Brazdil wrote:
> > > Add helper macro for computing the PA of a kernel symbol in nVHE hyp
> > > code. This will be useful for computing the PA of a PSCI CPU_ON entry
> > > point.
> > > 
> > > Signed-off-by: David Brazdil <dbrazdil@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/psci.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/psci.c
> > > b/arch/arm64/kvm/hyp/nvhe/psci.c
> > > index b0b5df590ba5..7510b9e174e9 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/psci.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/psci.c
> > > @@ -20,6 +20,16 @@ s64 hyp_physvirt_offset;
> > > 
> > >  #define __hyp_pa(x) ((phys_addr_t)((x)) + hyp_physvirt_offset)
> > > 
> > > +#define __hyp_pa_symbol(sym)					\
> > > +	({							\
> > > +		extern char sym[];				\
> > > +		unsigned long kern_va;				\
> > > +								\
> > > +		asm volatile("ldr %0, =%1" : "=r" (kern_va)	\
> > > +					   : "S" (sym));	\
> > > +		kern_va - kimage_voffset;			\
> > > +	})
> > > +
> > 
> > Could this be simplified to __hyp_pa(hyp_symbol_addr(sym))? That would
> > avoid the dependency on kimage_voffset.

Ah, didn't see that one. Ok, removing this patch.

> 
> I'm going to move away from evaluating kimage_voffset at runtime anyway,
> see [1].

Awesome! One more dependency gone.

> 
> Thanks,
> 
>         M.
> 
> [1] https://lore.kernel.org/r/20201109175923.445945-1-maz@kernel.org
> -- 
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
