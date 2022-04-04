Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2EA8C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 17:57:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CB754B2AB;
	Mon,  4 Apr 2022 13:57:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PuLD8Lfpe3yL; Mon,  4 Apr 2022 13:57:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 340D64B156;
	Mon,  4 Apr 2022 13:57:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B1D749F55
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 13:57:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fp0J14Zvtns9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 13:57:20 -0400 (EDT)
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com
 [209.85.166.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4045D49EE4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 13:57:20 -0400 (EDT)
Received: by mail-il1-f181.google.com with SMTP id x9so7458295ilc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 10:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=GmQMDW9Kl2RXHFpra8Cb+yFdRaCEgtk0WeuxWIun/PE=;
 b=T/YID3m7jqfMsZdI5yipTxP6mq1tBCIPkkaeRZEOGXJXCRTNAVRLgO6d3oGPKiaIsM
 hB1IuYXuYvxwGnm/jAntlYOH177EGDJShNXiQsKuSX5zmuTfztgeEwn8fCn3X5foUENF
 tSPmbGrEqNTLnjaKU1LnFelmOozabOJ/CJhjHjgSpIDgJsIVglglRlphqOF6I5tZB4fN
 RjXIJozATO4FyKzOy/3PbchB4/uuHz062rsh7sbqfMMWRA2/+03t3OuXgIyBsGiXxQuP
 s6lHlTJrjRufZd9tiwr5+a8oqSI3d98djdhUvx2xfaAT94UiQ2BSWSf8Or0aJ0TjXzUY
 Cssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=GmQMDW9Kl2RXHFpra8Cb+yFdRaCEgtk0WeuxWIun/PE=;
 b=Hq88tu4Hgew4AhKK0M7mK1Cjpu3cEkHTIJ54LL6LsTwSKWy1U1WJ3EgBjzZzmmfUq/
 mP4fYvDT0Zo6HouTaDqM0l0xft1Uhd9RVi8e/c/6wFt8Vn1JeM8S0EZO67JR7JEcXDdI
 8dhVP1cB0ExG77JEmOoaDilANUe/ijnuVG1fd8Sy8kcrGwAGKiQ1H00zC/MrO/1Rl7oT
 bwzDmiyXKvFNxTt2+n8bQhwCCgSUfkJgIOPtnFqyxmwAvKZyzJpKwBS2D1B1W5RJoBpR
 IJnjXtz1/8y2iWrDYNLPgmgIC2bI0zInZHY4bG2wjuNXV3XORKqAfc/U3oTWwYZbc5IK
 xakQ==
X-Gm-Message-State: AOAM5338EKYiDPa/cyYJm0aCaDRw9nd6tFVBjT470bHZ8bQsnByQGq8j
 UJI6cMCdhJkatVWMpE8Cu5o7fw==
X-Google-Smtp-Source: ABdhPJyxcxrXm46aKYYcD84LuHXVzCCX7Rui8hCXMmO19c75bw55+ZX3BLOKGyUKxAuIXD3PlAjPvg==
X-Received: by 2002:a92:3405:0:b0:2c8:70ad:fa86 with SMTP id
 b5-20020a923405000000b002c870adfa86mr483750ila.268.1649095039360; 
 Mon, 04 Apr 2022 10:57:19 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 d15-20020a92d78f000000b002ca4c409d1asm1036438iln.83.2022.04.04.10.57.17
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 04 Apr 2022 10:57:18 -0700 (PDT)
Date: Mon, 4 Apr 2022 17:57:14 +0000
From: Oliver Upton <oupton@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/4] KVM: Only log about debugfs directory collision once
Message-ID: <Yksxeo7IhzyFS8AM@google.com>
References: <20220402174044.2263418-1-oupton@google.com>
 <20220402174044.2263418-3-oupton@google.com>
 <Yksr6etwnN0iW8ZH@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yksr6etwnN0iW8ZH@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, stable@kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Sean,

On Mon, Apr 04, 2022 at 05:33:29PM +0000, Sean Christopherson wrote:
> On Sat, Apr 02, 2022, Oliver Upton wrote:
> > In all likelihood, a debugfs directory name collision is the result of a
> > userspace bug. If userspace closes the VM fd without releasing all
> > references to said VM then the debugfs directory is never cleaned.
> > 
> > Even a ratelimited print statement can fill up dmesg, making it
> > particularly annoying for the person debugging what exactly went wrong.
> > Furthermore, a userspace that wants to be a nuisance could clog up the
> > logs by deliberately holding a VM reference after closing the VM fd.
> > 
> > Dial back logging to print at most once, given that userspace is most
> > likely to blame. Leave the statement in place for the small chance that
> > KVM actually got it wrong.
> > 
> > Cc: stable@kernel.org
> > Fixes: 85cd39af14f4 ("KVM: Do not leak memory for duplicate debugfs directories")
> 
> I don't think this warrants Cc: stable@, the whole point of ratelimiting printk is
> to guard against this sort of thing.  If a ratelimited printk can bring down the
> kernel and/or logging infrastructure, then the kernel is misconfigured for the
> environment.

Good point.

> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 69c318fdff61..38b30bd60f34 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -959,7 +959,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
> >  	mutex_lock(&kvm_debugfs_lock);
> >  	dent = debugfs_lookup(dir_name, kvm_debugfs_dir);
> >  	if (dent) {
> > -		pr_warn_ratelimited("KVM: debugfs: duplicate directory %s\n", dir_name);
> > +		pr_warn_once("KVM: debugfs: duplicate directory %s\n", dir_name);
> 
> I don't see how printing once is going to be usefull for a human debugger.  If we
> want to get rid of the ratelimited print, why not purge it entirely?

I'd really like to drop it altogether. I've actually looked at several
instances of this printk firing internally, and all of it had to do with
some leak in userspace.

I'll pull this patch out of the series for v2 and maybe just propose we
drop it altogether.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
