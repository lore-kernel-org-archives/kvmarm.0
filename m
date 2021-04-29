Return-Path: <SRS0=jtxo=J2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 952A7C43460
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 17:52:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBDC06141E
	for <kvmarm@archiver.kernel.org>; Thu, 29 Apr 2021 17:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBDC06141E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15EA94B393;
	Thu, 29 Apr 2021 13:52:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v1uRiKUYnc0F; Thu, 29 Apr 2021 13:52:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 045E94B394;
	Thu, 29 Apr 2021 13:52:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBA914B38C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 13:52:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mRvt8KCgWrCJ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Apr 2021 13:52:04 -0400 (EDT)
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com
 [209.85.214.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C53264B389
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 13:52:04 -0400 (EDT)
Received: by mail-pl1-f174.google.com with SMTP id v13so21578318ple.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Apr 2021 10:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=Iqvx6xUJ3HpBD776B4jOHX3DLMKME1UEEEadpoQT2gQ=;
 b=jGzEnHyVLypFuPSu8rwkpX2gw75JhanOw6rujoZojvWajm23gVjBoBRyEMs0GNr7Tf
 EcOQCFEQRHs5l1om6BhrQUyLwY6d/qnjVcbqFQzCVec6NMixGQPl8Q+im8HFnw5KqADL
 JpWeBCVxB5lAcDQqFhjm349oNMLodbTI3QJ4mQZUVyJR/oCpKPzdrJZOalg8HVJ5q2dO
 Q7sUVbWw8XJXF+BygD9tCvtlWqOFa+c8QhNMwhXQq1VYCsdktnz9IZwujP0y2UHT9gqv
 /SlKRcfLpR5Z1xWPo4ys9565wgBOfp16ixNMnx517kk3b1R6bU8QT7cdkCCJv9OfyEOv
 puHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Iqvx6xUJ3HpBD776B4jOHX3DLMKME1UEEEadpoQT2gQ=;
 b=eODS9WKShfZaifj+uCSgMhv4+bFGoUs3e5EEzoxuOtbe82RfA0iBQEdrWFpYQ0LVwB
 ISchE8f0OySGbV5bxErWjfonyMAgy5KPgRDT0MzJP0JPO1eOfyuhsMGaBdAOPXwGAqC/
 DGvL0ALTa8o6xBfyxPI9h402R6pUA3IDhNYKDyYslmh6fgBiq8iA9Fyw9KjUG6v/sVDF
 Ceojq7SxQ0mxZIu2BPnyY99fbIBqLicB6gA5+UiwMroMBWiUtalvYqFrhiuOk5hYtHUt
 lyphBWClKdUyN1Z0SyO7hVlmA6mgXrQJbK6VZsceLGuAP1pYZudOIAu4VsilWH9Fs6TZ
 qYIg==
X-Gm-Message-State: AOAM532M1C2/S1XUP/B6Lz9tdDGGi0d4p+nGOei0XLqffS9qdA/Uohgy
 WJhL6pABwin2FPfDX5rWo86OfA==
X-Google-Smtp-Source: ABdhPJzso9M0RRFDzJYpF5zFVqb7Ha24skEaZX2/YLwsOZbDSGiaKX23vzenBQY+6pH5STksUnpOgw==
X-Received: by 2002:a17:90a:602:: with SMTP id
 j2mr1024998pjj.211.1619718723372; 
 Thu, 29 Apr 2021 10:52:03 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id x13sm526220pgf.13.2021.04.29.10.52.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Apr 2021 10:52:02 -0700 (PDT)
Date: Thu, 29 Apr 2021 10:51:59 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] KVM: selftests: Add exception handling support for
 aarch64
Message-ID: <YIryP84dAc0XHJk2@google.com>
References: <20210423040351.1132218-1-ricarkol@google.com>
 <20210423040351.1132218-2-ricarkol@google.com>
 <87sg3hnzrj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87sg3hnzrj.wl-maz@kernel.org>
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

On Fri, Apr 23, 2021 at 09:58:24AM +0100, Marc Zyngier wrote:
> Hi Ricardo,
> 
> Thanks for starting this.
> 
> On Fri, 23 Apr 2021 05:03:49 +0100,
> Ricardo Koller <ricarkol@google.com> wrote:
> > +.pushsection ".entry.text", "ax"
> > +.balign 0x800
> > +.global vectors
> > +vectors:
> > +.popsection
> > +
> > +/*
> > + * Build an exception handler for vector and append a jump to it into
> > + * vectors (while making sure that it's 0x80 aligned).
> > + */
> > +.macro HANDLER, el, label, vector
> > +handler\()\vector:
> > +	save_registers \el
> > +	mov	x0, sp
> > +	mov	x1, \vector
> > +	bl	route_exception
> > +	restore_registers \el
> > +
> > +.pushsection ".entry.text", "ax"
> > +.balign 0x80
> > +	b	handler\()\vector
> > +.popsection
> > +.endm
> 
> That's an interesting construct, wildly different from what we are
> using elsewhere in the kernel, but hey, I like change ;-). It'd be
> good to add a comment to spell out that anything that emits into
> .entry.text between the declaration of 'vectors' and the end of this
> file will break everything.
> 
> > +
> > +.global ex_handler_code
> > +ex_handler_code:
> > +	HANDLER	1, sync, 0			// Synchronous EL1t
> > +	HANDLER	1, irq, 1			// IRQ EL1t
> > +	HANDLER	1, fiq, 2			// FIQ EL1t
> > +	HANDLER	1, error, 3			// Error EL1t
> 
> Can any of these actually happen? As far as I can see, the whole
> selftest environment seems to be designed around EL1h.
>

They can happen. KVM defaults to use EL1h:

	#define VCPU_RESET_PSTATE_EL1   (PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \

but then a guest can set the SPSel to 0:

	asm volatile("msr spsel, #0");

and this happens:

	  Unexpected exception guest (vector:0x0, ec:0x25)

I think it should still be a valid situation: some test might want to
try it.

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
