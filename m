Return-Path: <SRS0=60kf=LB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C16EAC47094
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 16:57:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3DDE56102A
	for <kvmarm@archiver.kernel.org>; Mon,  7 Jun 2021 16:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DDE56102A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87BA04B087;
	Mon,  7 Jun 2021 12:57:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 99VQk7iMznnX; Mon,  7 Jun 2021 12:57:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 811FF406AD;
	Mon,  7 Jun 2021 12:57:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26628406AD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 12:57:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UFGnjd-kB0+J for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 12:57:04 -0400 (EDT)
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com
 [209.85.216.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28B024057F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 12:57:04 -0400 (EDT)
Received: by mail-pj1-f48.google.com with SMTP id
 l10-20020a17090a150ab0290162974722f2so424087pja.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 07 Jun 2021 09:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=cMsZT5zKE7Lf53ne/OxHCuP0u91jCcIDQH5EV8YFGE0=;
 b=IZHdNs+ur7ut3ZUv87Wd541/vK/b/gq7FGmjeVJYDKNDzBQ2/t/ulGfgvj446oGxIb
 rFaLzjdkmrQhvv8SKPet13fsOxFrz0vvhuoRzuNqLJ6/7uAaHi2K3THsNjYWGl5GyeMf
 cyAULvTG2Z/Kl2L1kLbRv1oZoADLSn87cPyz/p7NtB1lI0gjsOIamnaMqCQ1W2uCh1s4
 p6drCWUmpyYVqxk1iOt1zrJ5axpYQkpT8kJa92cokMz2G7jgaj9cOR4oW4h7M+H6G+EB
 BoIeqK1iBpBPeohfxgReHGbv4eRnUQlo0WxR3T5agnVlo1CVvLxpWpplyXesyrTwtx9C
 1LJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cMsZT5zKE7Lf53ne/OxHCuP0u91jCcIDQH5EV8YFGE0=;
 b=uO8qPiz5pz6k8aWdprkTdt+Y0SqteYeHzmhYRpGfHOc7/SSQRmx0TfaymNAso3Eecr
 hDVWKDXU7W5xn+lgm57eELqJ6kGUJ7CZY1yznt18435Z7XkK/lVEDDmBcg7N8On1jKUf
 kzIJ9c1eWfHLFzhp4AewtfJWdhZu92Nk91qE6CSuvquzWWbZZrssPAT30DxAYYRd8Wiw
 jRfiErVvrbstZ1lkn4Jh8Zd80UvAJrh/tdkBRoSuzNhofiehzBlm54WwtJGuUM0ivkpT
 zmfR9cwn186p7zaIRoyRjUtG3/zu0SScWVnFyYd8qrxgXzVXEmqZDIfFoivH2Pt8M5fI
 b5CA==
X-Gm-Message-State: AOAM533MXrdtkWuwQ5dRainAt6vfKUFbC2J8jQ7FOp/qKY9oPfg0sfsu
 0/ODd9/gcMxmni1/GRwfvPgGxw==
X-Google-Smtp-Source: ABdhPJzNbGt0h4fAXPLjmNjb3atpTOnOk/5fD1cNXMVfYVBjFpEQn/NuP8ZLgcaz3nCrWIvY8iubXQ==
X-Received: by 2002:a17:90a:901:: with SMTP id n1mr116137pjn.44.1623085023134; 
 Mon, 07 Jun 2021 09:57:03 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id a15sm8607897pff.128.2021.06.07.09.57.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 07 Jun 2021 09:57:02 -0700 (PDT)
Date: Mon, 7 Jun 2021 09:56:59 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
Message-ID: <YL5P28rvUcM3ohxx@google.com>
References: <20210604181833.1769900-1-ricarkol@google.com>
 <YLqanpE8tdiNeoaN@google.com> <YLqzI9THXBX2dWDE@google.com>
 <6d1f569a5260612eb0704e31655d168d@kernel.org>
 <YL5ETJatW+BM9vKS@google.com> <87mts1zlzc.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87mts1zlzc.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 kernel test robot <oliver.sang@intel.com>, pbonzini@redhat.com,
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

On Mon, Jun 07, 2021 at 05:19:03PM +0100, Marc Zyngier wrote:
> On Mon, 07 Jun 2021 17:07:40 +0100,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > On Sun, Jun 06, 2021, Marc Zyngier wrote:
> > > This is becoming a bit messy. I'd rather drop the whole series from
> > > -next, and get something that doesn't break in the middle. Please
> > > resend the series tested on top of -rc4.
> > 
> > That'd be my preference too.  I almost asked if it could be (temporarily)
> > dropped, but I assumed the hashes in -next are intended to be stable.
> 
> I usually try and keep these commits stable.
> 
> But in this case, we end-up with a broken build at some point in the
> series. For such cases, I'm more than happy to drop the series and
> merge a clean version again (I keep each series on a separate branch
> for this exact purpose).

Thank you both. I will send a new series with the fix and Seans
suggestions (tested on the latest rc).

Apologies again for the mess.

Ricardo

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
