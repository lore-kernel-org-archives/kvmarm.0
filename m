Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23028C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 13:37:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9649A4B168;
	Fri, 10 Dec 2021 08:37:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ToMw1mKgt5ny; Fri, 10 Dec 2021 08:37:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 310B64B0E2;
	Fri, 10 Dec 2021 08:37:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 08B7C4079A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 08:37:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vz4ZuJ54xucU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 08:37:18 -0500 (EST)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D90DD4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 08:37:17 -0500 (EST)
Received: by mail-wr1-f49.google.com with SMTP id t9so14961450wrx.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 05:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=UMyDDswc1FZItAV+NSBPgTMyKyf2+D9Oge1wredtc7c=;
 b=Hd1kuvSf5n0DrJQqp7698lcVKXaMe/TLA/TGhOMfEQB+SDBrEZSfhys+1IT/Y9TNyo
 FL8OV6pI6tCoxkvRHdGU1Yb0vpUYv9NpLbrYPsFAhL0emDoOlMJ8koYvMmkU1N1c+g/o
 a+6RuJ+GeMiN9MGhCLm4Xe5H2oksD2RfUEfIT0cDRa47DtJrc6B/2rirhTiqEnjLknZg
 Edm9SBItDyelahvSPfyZd7mfbz0+0T4ipL34oS5YwSFmZOS+jm+2AstTmdnupYqn7yS4
 bXnwlWddpKU7TKBOqNuxT+m/f+GADIey098ZH+N1FWcJiCWqUTlDRfdOZ5imoUiEH2mt
 F4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=UMyDDswc1FZItAV+NSBPgTMyKyf2+D9Oge1wredtc7c=;
 b=PDzibVYqRAk+EH48HWpMY3X+iTUrwvWu7+tz6DlWvXNmMxF0aB8H6RtGhqYSidlylY
 0jxhSGG8LMR9iu4hNlfCMyKCNLybsVa0fm+6FJ3tHDGm0y1Kt80UwQfiCBBo6tLGWiQY
 XySJn5qCdHsm0Dodd9kjQUwFGXe2FLvCQFdDZSF1oX9AvyiMTWUOPK9kDu33pqWUfZaM
 d/foO7qoPFyMdBfeU7ZYeKtVpCCWe4SyQ9IyGGXFA9JbgQ69hBg/fzd/O9r22eX3iP6t
 G9nMt+WvGxrtugbOMGcM1bmLVE1N6RR+EOHk0XIGMb4EPgg9/qNycGiuncNfStjRS/w9
 cL3A==
X-Gm-Message-State: AOAM53079bj1Udb+lhZ6OU5tnEl3AylDM9+bOg3IZ/QU7guAQuaWBUYD
 7aHki2RY32wOxXiSvBhaaAtORQ==
X-Google-Smtp-Source: ABdhPJyK1FJ33ENKdaCNwdVJ8F5MUTfJNljKx5SySODi49ZDvjnWhgaYlWH5OSJlvG5ocohi1ih2Ow==
X-Received: by 2002:adf:d1e3:: with SMTP id g3mr14499141wrd.3.1639143436764;
 Fri, 10 Dec 2021 05:37:16 -0800 (PST)
Received: from google.com ([2a00:79e0:d:210:76c1:fb36:1e22:8677])
 by smtp.gmail.com with ESMTPSA id a1sm3408752wri.89.2021.12.10.05.37.16
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 10 Dec 2021 05:37:16 -0800 (PST)
Date: Fri, 10 Dec 2021 13:37:12 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 01/15] KVM: arm64: Check if running in VHE from
 kvm_host_owns_hyp_mappings()
Message-ID: <YbNYCJOOARfUPKq1@google.com>
References: <20211201170411.1561936-1-qperret@google.com>
 <20211201170411.1561936-2-qperret@google.com>
 <20211209101053.GA1833@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211209101053.GA1833@willie-the-truck>
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Thursday 09 Dec 2021 at 10:10:54 (+0000), Will Deacon wrote:
> On Wed, Dec 01, 2021 at 05:03:55PM +0000, Quentin Perret wrote:
> > The kvm_host_owns_hyp_mappings() function should return true if and only
> > if the host kernel is responsible for creating the hypervisor stage-1
> > mappings. That is only possible in standard non-VHE mode, or during boot
> > in protected nVHE mode. But either way, non of this makes sense in VHE,
> > so make sure to catch this case as well, hence making the function
> > return sensible values in any context (VHE or not).
> > 
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Quentin Perret <qperret@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 326cdfec74a1..f8f1096a297f 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -239,6 +239,9 @@ void free_hyp_pgds(void)
> >  
> >  static bool kvm_host_owns_hyp_mappings(void)
> >  {
> > +	if (is_kernel_in_hyp_mode())
> > +		return false;
> 
> This looks identical to:
> 
> https://lore.kernel.org/r/20211208152300.2478542-7-qperret@google.com

Yep, I figured it made more sense in the other series as it's not
strictly related to this one, so ... :)

Cheers,
Quentin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
