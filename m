Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51716C433ED
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 18:03:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8FC18610D2
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 18:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FC18610D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F34EB4B75C;
	Fri,  7 May 2021 14:03:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5lfoC0D8lG64; Fri,  7 May 2021 14:03:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 029484B74E;
	Fri,  7 May 2021 14:03:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15FF74B5C6
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 14:03:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d5c9KqiGbwxA for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 14:03:02 -0400 (EDT)
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com
 [209.85.215.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F21844B4FC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 14:03:01 -0400 (EDT)
Received: by mail-pg1-f180.google.com with SMTP id i5so2951749pgm.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 May 2021 11:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Dq/nINI3Bkq3Ln7MVhdaZDOVulBPxVkutw7EPDzvvRA=;
 b=ZPY2n2/Ast/W4mvecQPl0YwBiFsiuZARNymcVwARZlvAMPOzc5FQkn2lPrL8XjarlK
 BiiHSu2Hgn6Qt/cxYc+slTD7EE/JIffcf9L1zPQ4l//9+7sZ6mvLnG6N4Zjknj6UWyZL
 Bk+P8M4YaMZYRa3f7+VZTOXzu1dbppTHdBY2fIMngbOjruUILoQyTdVEcddGI9VEiPuO
 4joqX7FP832VEhpKnL+aWHO5FNUIaw3UeGkvB6i+Ad44v6qdFFEoYmRM6zCM1PfoIHoV
 qxbdpnTLvai3purYBTL7Mx2Ha2bZ8tIBbTzzH6s4RLdkpABOgDjDTY3BaNwfHshZMvRY
 bp2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Dq/nINI3Bkq3Ln7MVhdaZDOVulBPxVkutw7EPDzvvRA=;
 b=B1zoiCWzi2njQM6OFNADIrpSenjNtOFVPC41MhDPkjiQVNP6vz5xV/g3go60HwtJnO
 FGTt2RaWq15jbZ/297xG4OJqxj3PVq4A5uLlLRKYmBu3WDkfsOqx8e1c/iwS0MBV7XX2
 1lZZuYJosiZ9pQNM7Rzp5ddm7atzEZmiz/mzEqELJbu6GbVpuebMKI8q8U8wNrUAPcYk
 VjPU6/ZPInTo3qcaMfWPnFWnXK9c46/dLNaoA7yMWWCADBo0vPZ/LTvIlS8jcwM64kfv
 eREodF2DAUehBHqFbkT8cNKeMvZjc5Qh7ldAZX5TcPK1Nq9Wa7vpVwFEM4uRYNjENJIM
 u2tg==
X-Gm-Message-State: AOAM530UepvMhqebRDvP+sNT5lVcrzl3Aw7jDwisdiV7GeYlyu781THz
 ngk+bSE6W3knrhQhARaoOjTLWw==
X-Google-Smtp-Source: ABdhPJyImt4qEMYR4Ckxhjx1Vymo5/pd2g19btogktByhjv/2TAqJV5kodRh9+WMe+f5Dp3S08CYdw==
X-Received: by 2002:a65:5088:: with SMTP id r8mr10849349pgp.12.1620410580840; 
 Fri, 07 May 2021 11:03:00 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id d132sm5262385pfd.136.2021.05.07.11.02.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 May 2021 11:02:59 -0700 (PDT)
Date: Fri, 7 May 2021 11:02:56 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YJWA0Moczi2kYSjd@google.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org> <YJBLFVoRmsehRJ1N@google.com>
 <877dkapqcj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <877dkapqcj.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

On Fri, May 07, 2021 at 03:31:56PM +0100, Marc Zyngier wrote:
> On Mon, 03 May 2021 20:12:21 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Mon, May 03, 2021 at 11:32:39AM +0100, Marc Zyngier wrote:
> > > On Sat, 01 May 2021 00:24:06 +0100,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> 
> [...]
> 
> > > > +	.if \vector >= 8
> > > > +	mrs	x1, sp_el0
> > > 
> > > I'm still a bit perplexed by this. SP_EL0 is never changed, since you
> > > always run in handler mode. Therefore, saving/restoring it is only
> > > overhead. If an exception handler wants to introspect it, it is
> > > already available in the relevant system register.
> > > 
> > > Or did you have something else in mind for it?
> > > 
> > 
> > Not really. The reason for saving sp_el0 in there was just for
> > consistency, so that handlers for both el0 and el1 exceptions could
> > get the sp at regs->sp.
> 
> We already have sp_el0 consistency by virtue of having it stored in in
> a sysreg.
> 
> > Restoring sp_el0 might be too much. So, what do you think of this
> > v3: we keep the saving of sp_el0 into regs->sp (to keep things the
> > same between el0 and el1) and delete the restoring of sp_el0?
> 
> To me, the whole purpose of saving some some context is to allow the
> exception handling code to run C code and introspect the interrupted
> state. But saving things that are not affected by the context change
> seems a bit pointless.
> 
> One thing I'd like to see though is to save sp_el1 as it was at the
> point of the exception (because that is meaningful to get the
> exception context -- think of an unaligned EL1 stack for example),
> which means correcting the value that gets saved.

Got it. Replacing:
	mov     x1, sp
with:
	add     x1, sp, #16 * 17

> 
> So I would suggest to *only* save sp_el1, to always save it
> (irrespective of the exception coming from EL0 or EL1), and to save a
> retro-corrected value so that the handler can directly know where the
> previous stack pointer was.

Sounds good, will send a V3 accordingly.

Thanks!
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
