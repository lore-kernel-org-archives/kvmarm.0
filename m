Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67273C43334
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 21:26:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CDC394D918;
	Wed, 20 Jul 2022 17:26:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GulCpBGWfXUc; Wed, 20 Jul 2022 17:26:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C4E44D906;
	Wed, 20 Jul 2022 17:26:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E51314D900
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 17:26:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TsPNoaEHI9Fp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 17:26:14 -0400 (EDT)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF5824CB2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 17:26:14 -0400 (EDT)
Received: by mail-pf1-f169.google.com with SMTP id y141so17595967pfb.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 14:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=HCY796BMJ2oxk4qGgRmjBRC8Xu8JftRftOsx1tYR+B0=;
 b=XDvCGfbA1C8gkVaIGW/X8rxKS3oy3mMldq/gc3wMQyZyXK+URjRMofgHodqHsrdr9C
 tCe/niRyj2oX4geF4nHQjazu2BPPuOU1PcFfbRLJ2410NGhDchKOX1CYPKh/QeuIl7CO
 vZcke62x4v9g1UDW8BOmQz6Zu/uq2MorjqLfU85HP4NBiVnNbA4LWM3k2xht1HTaXzcr
 AEkOkwqz6i7qqLSPcDF5Z6V4mPIR2k8my4SuxHFRjof88vOan0rS25HMVbwM+exgs5E9
 J0Dl5fN7n38nfxUHgSLwA/ZWenlHg+6+PFgs30H48MLSskG66egw7dR+CQ6hF9D2adyh
 RDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HCY796BMJ2oxk4qGgRmjBRC8Xu8JftRftOsx1tYR+B0=;
 b=KtK98n5tqvBr1FW1oWQV52KWLqO+KMdPBi8CREhbnuVD1a7RlipOxWoMRgfmBtx44o
 iD+jPXrQHkWZBVqgOJOIVfYe89PJN5xH1gPogGq1P+X6uQ5cwAkrd3O/+UF8VbueTEPy
 bNDdL08d8Yv08Z8GehxLcSsIyJ9oHXI+PhSmRwKVsLzcXELq5j9SDe9phGAe8tSTo9y8
 cjDKIoCek8SZiewHV4i5Eqli3IyyBUTtqVmxe/raM0Exc1EMVuWDuyTZ5x7GJTjVnFF0
 dK4TEuqGtfWcmydmXVJfod+V4yVkLeE022jiYHSOXVh3jNh2lD7orCIGlSj3Yu4sxAUM
 hWYA==
X-Gm-Message-State: AJIora91Pzo8OU8JBQaMqoCx5ZpX47yH4gOD7P1awmK87tyfCnPS3uvJ
 +P4+KxF8zjbrNoHkByiGmBxJiA==
X-Google-Smtp-Source: AGRyM1u2Toix/4MkWUmJIpxn45NOXxn1ehVFBWt9jErGZXNwxhmyu+pJbUt1b9EMJDEd/3TGpw9dwQ==
X-Received: by 2002:a05:6a02:30d:b0:412:9de2:eb48 with SMTP id
 bn13-20020a056a02030d00b004129de2eb48mr34567838pgb.47.1658352373632; 
 Wed, 20 Jul 2022 14:26:13 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150]) by smtp.gmail.com with ESMTPSA id
 x15-20020a170902ec8f00b0016b8746132esm30750plg.105.2022.07.20.14.26.12
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 20 Jul 2022 14:26:12 -0700 (PDT)
Date: Wed, 20 Jul 2022 14:26:09 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <Ythy8XXN2rFytXdr@google.com>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org> <Yte/YXWYSikyQcqh@google.com>
 <875yjsyv67.wl-maz@kernel.org> <Ythw1UT1wFHbY/jN@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Ythw1UT1wFHbY/jN@google.com>
Cc: drjones@redhat.com, kvm@vger.kernel.org, oliver.upton@linux.dev,
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

On Wed, Jul 20, 2022 at 02:17:09PM -0700, Ricardo Koller wrote:
> On Wed, Jul 20, 2022 at 10:45:20AM +0100, Marc Zyngier wrote:
> > On Wed, 20 Jul 2022 09:40:01 +0100,
> > Ricardo Koller <ricarkol@google.com> wrote:
> > > 
> > > On Tue, Jul 19, 2022 at 12:34:05PM +0100, Marc Zyngier wrote:
> > > > On Mon, 18 Jul 2022 16:49:10 +0100,
> > > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > > 
> > > > > A chained event overflowing on the low counter can set the overflow flag
> > > > > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > > > > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > > > > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > > > > overflow.
> > > > 
> > > > Isn't this indicative of a bug in the KVM emulation? To be honest, the
> > > > pseudocode looks odd. It says:
> > > > 
> > > > <quote>
> > > > 	if old_value<64:ovflw> != new_value<64:ovflw> then
> > > > 	    PMOVSSET_EL0<idx> = '1';
> > > > 	    PMOVSCLR_EL0<idx> = '1';
> > > > </quote>
> > > > 
> > > > which I find remarkably ambiguous. Is this setting and clearing the
> > > > overflow bit? Or setting it in the single register that backs the two
> > > > accessors in whatever way it can?
> > > > 
> > > > If it is the second interpretation that is correct, then KVM
> > > > definitely needs fixing
> > > 
> > > I think it's the second, as those two "= '1'" apply to the non-chained
> > > counters case as well, which should definitely set the bit in PMOVSSET.
> > > 
> > > > (though this looks pretty involved for
> > > > anything that isn't a SWINC event).
> > > 
> > > Ah, I see, there's a pretty convenient kvm_pmu_software_increment() for
> > > SWINC, but a non-SWINC event is implemented as a single 64-bit perf
> > > event.
> > 
> > Indeed. Which means we need to de-optimise chained counters to being
> > 32bit events, which is pretty annoying (for rapidly firing events, the
> > interrupt rate is going to be significantly higher).
> > 
> > I guess we should also investigate the support for FEAT_PMUv3p5 and
> > native 64bit counters. Someone is bound to build it at some point.
> 
> The kernel perf event is implementing 64-bit counters using chained
> counters. I assume this is already firing an interrupt for the low
> counter overflow; we might need to just hook into that, investigating...
> 

Additionally, given that the kernel is already emulating 64-bit
counters, can KVM just expose FEAT_PMUv3p5? Assuming all the other new
features can be emulated.

Thanks,
Ricardo

> > 
> > Thanks,
> > 
> > 	M.
> > 
> > -- 
> > Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
