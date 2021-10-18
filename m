Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F502C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 10:51:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98E346126A
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 10:51:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 98E346126A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2544B4B207;
	Mon, 18 Oct 2021 06:51:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wWw2ndu9CVvr; Mon, 18 Oct 2021 06:51:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 140994B20C;
	Mon, 18 Oct 2021 06:51:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0055C4B201
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 06:51:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MKsg1K45Ip-8 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 06:51:23 -0400 (EDT)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDFED4B1EC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 06:51:22 -0400 (EDT)
Received: by mail-wr1-f43.google.com with SMTP id m22so40720583wrb.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 03:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=EUaW7JwfSGO8IfMzxXtAbFj7chATqlw6VUjN7U2ryQM=;
 b=gsh2UkIAMsm5gYe5c49OiGWmzsspPVgjB2PAZkdcBDhHzqjXni96n8WS2mo1deqjcp
 EAWvXhBI3vbC6FovJLqT+tzcAWgqGm27iLzkbUAHDk51q01CC0bWX2vHMA22sXq8cNrV
 FYGbGg1+1E6kzv8/MgEDzSJxpJ+m0Lq1Rpz7qj/xrP5MJ8Y3b44gQ4tBk9n/TNizOR7x
 jwhOMhPLLLQhu+zdIKywI8J/ckZX+WWuMWn0FCdCRChKJwdSZ/ybmc0sP1AyY0y02Sst
 8j2wT9/pm1hfRlBeHG1YiMYxoXjAKAINmnfHZ8VIOfHMxyWEItndpA0p9wAbQ99sH2QF
 tXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=EUaW7JwfSGO8IfMzxXtAbFj7chATqlw6VUjN7U2ryQM=;
 b=lz3NysIP/MmNrmlXMxfWRkhTqRELMyavz5cws3zlrkizM+5PEkO37RirAvCBaMjqfN
 lA3gQywwPBsOxmikKR8xWvvtNT3Zn9+INFFDcGsxjF7j5z0rWtCcOkXfQ86g7PPkgVht
 6oYkd8OUpxoa519H2O/40FqTpPsPrE6LBIUhuAQ4XVotT4SdmgkA7vGFpRdhhm+ZHeSC
 PaPZKk1G1+EnCh2q1qv93wgWcwMka21pnTAboUJWfducKE66Pfu6Nv/kCmHLWtGDrSwd
 uhE68T7aMVm9fYUiSHcJUffVhurSogs4F55Wg6Vp+1UqlCC/y3XWwWNLPacEGByesQsN
 Ow/A==
X-Gm-Message-State: AOAM533WCuSE8g2cf2YTMmEjo8JWjvaQ0fbOT+6jao++EI9V6q2IkSQG
 wqBUefuAjykWM0Aflek5UN2Y8g==
X-Google-Smtp-Source: ABdhPJwhtb3NOEzuy2ZFJYNVEotlalYXUtDQUgg53zsWLVY3XRXYV7dP0NvO8Pf6NgSALYKR0zEs3g==
X-Received: by 2002:a5d:59a9:: with SMTP id p9mr35745131wrr.386.1634554281829; 
 Mon, 18 Oct 2021 03:51:21 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:ba81:6f1b:ab2e:f120])
 by smtp.gmail.com with ESMTPSA id h8sm13921425wrm.27.2021.10.18.03.51.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Oct 2021 03:51:21 -0700 (PDT)
Date: Mon, 18 Oct 2021 11:51:18 +0100
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 04/16] KVM: arm64: Introduce kvm_share_hyp()
Message-ID: <YW1RphOb9D/4/QGp@google.com>
References: <20211013155831.943476-1-qperret@google.com>
 <20211013155831.943476-5-qperret@google.com>
 <875ytworvy.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <875ytworvy.wl-maz@kernel.org>
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

On Sunday 17 Oct 2021 at 11:41:21 (+0100), Marc Zyngier wrote:
> Not directly related to this code, but it looks to me that
> kvm_host_owns_hyp_mappings() really ought to check for
> is_kernel_in_hyp_mode() on its own. VHE really deals with its own
> mappings, and create_hyp_mappings() already has a check to do nothing
> on VHE.

Sure, I'll stick a patch at the beginning of the series.

> 
> > +
> > +	return pkvm_share_hyp(kvm_kaddr_to_phys(from), kvm_kaddr_to_phys(to));
> > +}
> > +
> >  /**
> >   * create_hyp_mappings - duplicate a kernel virtual address range in Hyp mode
> >   * @from:	The virtual kernel start address of the range
> > @@ -316,12 +327,8 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
> >  	if (is_kernel_in_hyp_mode())
> >  		return 0;
> >  
> > -	if (!kvm_host_owns_hyp_mappings()) {
> > -		if (WARN_ON(prot != PAGE_HYP))
> > -			return -EPERM;
> > -		return pkvm_share_hyp(kvm_kaddr_to_phys(from),
> > -				      kvm_kaddr_to_phys(to));
> > -	}
> > +	if (WARN_ON(!kvm_host_owns_hyp_mappings()))
> > +		return -EPERM;
> 
> Do we really need this? Can't we just verify that all the code paths
> to create_hyp_mappings() check for kvm_host_owns_hyp_mappings()?
> 
> At the very least, make this a VM_BUG_ON() so that this is limited to
> debug. Yes, I'm quickly developing a WARN_ON()-phobia.

Right, that _is_ purely debug. It's just that folks are used to being
able to just call create_hyp_mappings() for anything, so I wanted to
make sure we have an easy way to catch future changes that would
unknowingly break pKVM, but no objection to make this VM_BUG_ON().

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
