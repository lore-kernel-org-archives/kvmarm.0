Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CE5C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 20:49:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDEEE613B1
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 20:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDEEE613B1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B8E04B3AD;
	Thu, 29 Apr 2021 16:49:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rw43urJd8Zz0; Thu, 29 Apr 2021 16:49:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C7964B3A6;
	Thu, 29 Apr 2021 16:49:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 855E54B39E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 16:49:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2coQCYP2EMdW for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 16:48:59 -0400 (EDT)
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com
 [209.85.210.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE85B4B39D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 16:48:56 -0400 (EDT)
Received: by mail-pf1-f182.google.com with SMTP id n6so1179336pfv.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 13:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=vfHYRnlb0vVZXq2Q43nIevJ7E7GHoNnTAH4NF+Y+ato=;
 b=bX9FlXZlTMXKWDjEW6C0Fo7hElOWeG/bNgdT2zGzTrxSmlR/fT0SIWaNA8fO3F6FzT
 PiTywxQs7BJz2sypT9T/UgHUZUXd+NZ2y/x5nklOe7OC/Qk/1HmRyZWeb5X+JPnGfgQY
 4C4My8Jy2Q0pIjifBEK0TgbnQMrZNplVVNyjngx1HTTxG3l91DZRum1giu20xqM6uU7R
 vDOR6XRg1hAevH0sjKxU6vCWwXNMVmFgwOZ8BCNHag7qao99j+qWTx6YzlTai6EG/KDj
 IKiu3zrUsLQkq96XZXp8xI4129oeZSDkU+mvwd7mmY5WW5wEBRH74xX4rPxjk06WykSk
 zg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=vfHYRnlb0vVZXq2Q43nIevJ7E7GHoNnTAH4NF+Y+ato=;
 b=WslUYaDz6kpQaENRim9TIiUfDbW6ONGkFn3PCW2K1Q/wlQbjXQvEdK6TDtzMV4BiId
 BL2xmGLO6V5EFHxGLGmdYGIl2qDetYWZtPIhnqDieDBnFtZjUeGz8XOG7cXxb6cFQTub
 WEpDsh0TWezkO3VloYoDq53/fUQExXTo77on68AkYuCfMNTtJlJKZ3U+3dAnrS1DRtEp
 aP5xQkqnsjabioMejle8QdVDIZiwXFvotGmAWEPlwWKFR9ebOlBM0kmO9EPBaeUzSXB9
 BDowK+O/OUoE4wdqnV9PbIwmnwUFMjdFOqKy+NAJxeI+l4gYxEP2qMI84bfMdMsZOlt2
 49Iw==
X-Gm-Message-State: AOAM533OVknNvUT0jjVilHrEQ50ymB2+BVNhwVwa0bxqhnPx0PPULHd6
 U3YkKDPcktYoq4paT+1cEgw0sw==
X-Google-Smtp-Source: ABdhPJzuQA1inRk4ReHCvh+AGTrZE0BErUvVuR+abPHgf+1IpAurGZHHxvanQ1tmL/Y8HSon3LHLiw==
X-Received: by 2002:a63:df09:: with SMTP id u9mr1459024pgg.112.1619729326829; 
 Thu, 29 Apr 2021 13:48:46 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id p12sm8544742pjo.4.2021.04.29.13.48.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Apr 2021 13:48:46 -0700 (PDT)
Date: Thu, 29 Apr 2021 13:48:42 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] KVM: selftests: Add exception handling support for
 aarch64
Message-ID: <YIsbqhQ/OOzluxtq@google.com>
References: <20210423040351.1132218-1-ricarkol@google.com>
 <20210423040351.1132218-2-ricarkol@google.com>
 <87sg3hnzrj.wl-maz@kernel.org> <YIryP84dAc0XHJk2@google.com>
 <87fsz8vp4d.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87fsz8vp4d.wl-maz@kernel.org>
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

On Thu, Apr 29, 2021 at 08:59:14PM +0100, Marc Zyngier wrote:
> AOn Thu, 29 Apr 2021 18:51:59 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > 
> > On Fri, Apr 23, 2021 at 09:58:24AM +0100, Marc Zyngier wrote:
> > > Hi Ricardo,
> > > 
> > > Thanks for starting this.
> > > 
> > > On Fri, 23 Apr 2021 05:03:49 +0100,
> > > Ricardo Koller <ricarkol@google.com> wrote:
> > > > +.pushsection ".entry.text", "ax"
> > > > +.balign 0x800
> > > > +.global vectors
> > > > +vectors:
> > > > +.popsection
> > > > +
> > > > +/*
> > > > + * Build an exception handler for vector and append a jump to it into
> > > > + * vectors (while making sure that it's 0x80 aligned).
> > > > + */
> > > > +.macro HANDLER, el, label, vector
> > > > +handler\()\vector:
> > > > +	save_registers \el
> > > > +	mov	x0, sp
> > > > +	mov	x1, \vector
> > > > +	bl	route_exception
> > > > +	restore_registers \el
> > > > +
> > > > +.pushsection ".entry.text", "ax"
> > > > +.balign 0x80
> > > > +	b	handler\()\vector
> > > > +.popsection
> > > > +.endm
> > > 
> > > That's an interesting construct, wildly different from what we are
> > > using elsewhere in the kernel, but hey, I like change ;-). It'd be
> > > good to add a comment to spell out that anything that emits into
> > > .entry.text between the declaration of 'vectors' and the end of this
> > > file will break everything.
> > > 
> > > > +
> > > > +.global ex_handler_code
> > > > +ex_handler_code:
> > > > +	HANDLER	1, sync, 0			// Synchronous EL1t
> > > > +	HANDLER	1, irq, 1			// IRQ EL1t
> > > > +	HANDLER	1, fiq, 2			// FIQ EL1t
> > > > +	HANDLER	1, error, 3			// Error EL1t
> > > 
> > > Can any of these actually happen? As far as I can see, the whole
> > > selftest environment seems to be designed around EL1h.
> > >
> > 
> > They can happen. KVM defaults to use EL1h:
> 
> That's not a KVM decision. That's an architectural requirement. Reset
> is an exception, exception use the handler mode.
> 

That makes sense, thanks for the clarification.

> > 
> > 	#define VCPU_RESET_PSTATE_EL1   (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
> > 
> > but then a guest can set the SPSel to 0:
> > 
> > 	asm volatile("msr spsel, #0");
> > 
> > and this happens:
> > 
> > 	  Unexpected exception guest (vector:0x0, ec:0x25)
> > 
> > I think it should still be a valid situation: some test might want to
> > try it.
> 
> Sure, but that's not what this test (in patch #2) is doing, is it?
> If, as I believe, this is an unexpected situation, why not handle it
> separately? I'm not advocating one way or another, but it'd be good to
> understand the actual scope of the exception handling in this
> infrastructure.
> 
> If you plan to allow tests to run in the EL1t environment, where do
> you decide to switch back to EL1t after taking the exception in EL1h?
> Are the tests supposed to implement both stack layouts?
> 
> Overall, I'm worried that nobody is going to use this layout *unless*
> it becomes mandated.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.

Got it, I see your point. Yes, I'm definitely not planning to use it.
Will just treat those vectors as "invalid".

Thanks again,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
