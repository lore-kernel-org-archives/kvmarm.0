Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB72C56202
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 14:54:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 351BC20658
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 14:54:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="UboGT20O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 351BC20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 717C74BB90;
	Mon, 23 Nov 2020 09:54:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0FEBHZ2vzZfK; Mon, 23 Nov 2020 09:54:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61CEB4BB92;
	Mon, 23 Nov 2020 09:54:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BDDF4BB78
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 09:54:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VjUCl4c6P2Ya for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 09:54:25 -0500 (EST)
Received: from mail-oo1-f66.google.com (mail-oo1-f66.google.com
 [209.85.161.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1CF984BB5A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 09:54:25 -0500 (EST)
Received: by mail-oo1-f66.google.com with SMTP id s11so3163985oov.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 06:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ypQOivTTwdFzb+/3Z+R/AYhQITc/BOXMPX6lQujmA4Y=;
 b=UboGT20Ox8squh3d2ZnQggVw2BtXqKOdT/s+tMz0g3csU8VHrONyW5B1YMIwVnvOpJ
 BVhxs2al+NwQ7/SMb4AlCm1HMMGJIkJ4dUHbEsfPSfhv/PIufUJTEUVTBAPFNlUKZ9Zi
 VKFmopTXQh23vKUrupe0vcmMB14nl3Hn7cotKcM8aBbzk456BuyKe5yx9hTMYsX63paI
 4j7Ui6K4z4tm29cT38tR4eWypwKe4Xidf2ELMd1Qpxa2/nRlkTKR0TWiestlDZlqI08W
 sKPIQQJFrEgp6sIsBBB9itZyqPLE01pGzbEgFzuhnLBxKeAzPwL09o/fP2akKmeTbh+d
 TzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ypQOivTTwdFzb+/3Z+R/AYhQITc/BOXMPX6lQujmA4Y=;
 b=hHNLBRV7gYWxxNdG4IHs2nZNLq97XpH3qecvzaMUS6yIPTQeL2TgchCQrNWX8nKSI0
 jaVH/3ePla6imjfhRcSC7LsUT8aq9YY+84/jDw9rakB59fxOkysARozcnTMIjrjOMjcC
 +eiv8Do+Lv5p+ACXUWV7cMKAcTLUf2DaD6lZpE1YI8ClkEBOGB2CTT071F2sjMjDd742
 CNg/LiE6nB5mh3WMn7SwMg5OUrxljiQj/7jbX3zxn5I8vQGwVCWEJPv52ztSqUu0L6mA
 ZjfVkybWYTkTGRNSJ3tY6INdZQ+B0iFMgfmhFY+dUeHhuqAHM2nteCUjANR9033pb8KA
 stwA==
X-Gm-Message-State: AOAM5317FZTVaJDWA0/dD6CHg5Pu7Y8p9576OYeRrWq/IHZQXwumyJcX
 Wla/TDUVEk3epiV9ex4DjHstJA==
X-Google-Smtp-Source: ABdhPJzgVQxYNSqFrGNwH41jxDIJClFraR7USL+/G1e6AcGi818QPZSMAXsn1Sq3067Whhx8WgkjEw==
X-Received: by 2002:a4a:eac1:: with SMTP id s1mr23273490ooh.15.1606143264324; 
 Mon, 23 Nov 2020 06:54:24 -0800 (PST)
Received: from google.com ([2a01:4b00:8523:2d03:acac:b2ef:c7d:fd8a])
 by smtp.gmail.com with ESMTPSA id 43sm6858710otf.28.2020.11.23.06.54.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 23 Nov 2020 06:54:23 -0800 (PST)
Date: Mon, 23 Nov 2020 14:54:20 +0000
From: David Brazdil <dbrazdil@google.com>
To: Quentin Perret <qperret@google.com>
Subject: Re: [RFC PATCH 09/27] KVM: arm64: Allow using kvm_nvhe_sym() in hyp
 code
Message-ID: <20201123145420.hjl24xp6p2nn26u2@google.com>
References: <20201117181607.1761516-1-qperret@google.com>
 <20201117181607.1761516-10-qperret@google.com>
 <20201123125723.4mnodg3tnal4q4v2@google.com>
 <20201123140250.GB490744@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20201123140250.GB490744@google.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, kernel-team@android.com,
 Frank Rowand <frowand.list@gmail.com>, android-kvm@google.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 open list <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>
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

On Mon, Nov 23, 2020 at 02:02:50PM +0000, 'Quentin Perret' via kernel-team wrote:
> On Monday 23 Nov 2020 at 12:57:23 (+0000), David Brazdil wrote:
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index 882eb383bd75..391cf6753a13 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -1369,7 +1369,7 @@ static void cpu_prepare_hyp_mode(int cpu)
> > >  
> > >  	params->vector_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref(__kvm_hyp_host_vector));
> > >  	params->stack_hyp_va = kern_hyp_va(per_cpu(kvm_arm_hyp_stack_page, cpu) + PAGE_SIZE);
> > > -	params->entry_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref(__kvm_hyp_psci_cpu_entry));
> > > +	params->entry_hyp_va = kern_hyp_va((unsigned long)kvm_ksym_ref_nvhe(__kvm_hyp_psci_cpu_entry));
> > 
> > Why is this change needed?
> 
> You mean this line specifically or the whole __kvm_hyp_psci_cpu_entry
> thing?
> 
> For the latter, it is to avoid having the compiler complain about
> __kvm_hyp_psci_cpu_entry being re-defined as a different symbol. If
> there is a better way to solve this problem I'm happy to change it -- I
> must admit I got a little confused with the namespacing along the way.

Yeah, we do need a more robust approach. It's getting out of control.

> 
> Thanks,
> Quentin
> 
> -- 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
