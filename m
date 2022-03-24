Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAAEC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 23:01:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3FB49EAA;
	Thu, 24 Mar 2022 19:01:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0L4qv5mWBn4T; Thu, 24 Mar 2022 19:01:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB50149F21;
	Thu, 24 Mar 2022 19:01:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DE8649EAA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 19:01:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yo89jf8ILh9w for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 19:01:34 -0400 (EDT)
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com
 [209.85.166.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0AAB749E44
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 19:01:33 -0400 (EDT)
Received: by mail-il1-f175.google.com with SMTP id j15so4151008ila.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 16:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=gFsgyLr9ZtY3CsTFCFwPED/ZztahOm1f0K0B19xBX3w=;
 b=kH0v456Gt3P/aaiK1WD+pFZmD9Gp500hFIgXBeuKEOsibDtVkcQ5MS5bkseEn3PwHO
 lMRAf8PprVMJiIsuTtIjMPYVLd178OLFNq5YXov60sLQbgTcptsgHQ71qQWKxpXJ+ZkR
 gFh9oC6cAbkt3OR5dp4jsY32eonP7c6a8U88vxJUKD2tXRWR0Xl6tWSPCXYEmL2nC6dj
 HHyWjN+DMwyjhUHiOlPaEoNqs4n5eXaX/dXqyKMw8f5Tig2q7G8un89ZsicqjxlcTNlF
 ZfFplWKPp+SZ0xzaIW6fpNVEFoGAk91tasISQvMSIcCRWvHzzdDKwXmgV4CsJ566xWx4
 FQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gFsgyLr9ZtY3CsTFCFwPED/ZztahOm1f0K0B19xBX3w=;
 b=lk7cFwpKikQS3R6TxsS0zFbLBGMJjHlUDMHIdaiJCV/wbY9iDbrat9X3pZWvnBBcvv
 Jr1TcZkGmPMpWvpveLAohtPouISmo2bG8t/gK07c7ABq3s0ZUl63Nlj2r2HbQ0qZYF78
 kegkdjxv7bPqt353V11qXKPF4mfG6lw7tyuEPasl127j6S6jSihxJtuaP7ThQ3FHMn7a
 Ec+cmFGORbKtsTBGpbkmr6diFoT7oKPr0Kgq3DK9izJQ9At3xzvWv104i26fuNW0GbZ+
 infFJKt7AGsBbhcgTZ9bLM7NQlkd72CWQdqZjrJgu+fQwTSjoo6WCLJdBBrDeGu0zMT+
 NGOw==
X-Gm-Message-State: AOAM532rS40+UWqb2VEH6pAvb6YsVfboUnEjGKio/a5J4lEyTO3e55Dt
 mGgJfxUPtThyzwfC5cEAA0v56w==
X-Google-Smtp-Source: ABdhPJx2bRtFRweMkEdLStxBpCpfXVRg/31TxuTxppv+RqiYB6T4/Iszjoin9ITToDSMnv+L9FMkEw==
X-Received: by 2002:a05:6e02:1ba8:b0:2c8:218a:24bd with SMTP id
 n8-20020a056e021ba800b002c8218a24bdmr3897140ili.198.1648162893098; 
 Thu, 24 Mar 2022 16:01:33 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 q9-20020a5edb09000000b00645c7a00cbbsm1978604iop.20.2022.03.24.16.01.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 16:01:32 -0700 (PDT)
Date: Thu, 24 Mar 2022 23:01:29 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <Yjz4SZbqS+3aD5YO@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com>
 <CAAeT=FwkXSpwtCOrggwg=V72TYCRb24rqHYVUGd+gTEA-jN66w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FwkXSpwtCOrggwg=V72TYCRb24rqHYVUGd+gTEA-jN66w@mail.gmail.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Thu, Mar 24, 2022 at 01:23:42PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Wed, Mar 23, 2022 at 12:53 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > > Add hidden or reserved ID registers, and remaining ID registers,
> > > which don't require special handling, to id_reg_desc_table.
> > > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > > or reserved registers. Since now id_reg_desc_init() is called even
> > > for hidden/reserved registers, change it to not do anything for them.
> > >
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >
> > I think there is a very important detail of the series that probably
> > should be highlighted. We are only allowing AArch64 feature registers to
> > be configurable, right? AArch32 feature registers remain visible with
> > their default values passed through to the guest. If you've already
> > stated this as a precondition elsewhere then my apologies for the noise.
> >
> > I don't know if adding support for this to AArch32 registers is
> > necessarily the right step forward, either. 32 bit support is working
> > just fine and IMO its OK to limit new KVM features to AArch64-only so
> > long as it doesn't break 32 bit support. Marc of course is the authority
> > on that, though :-)
> >
> > If for any reason a guest uses a feature present in the AArch32 feature
> > register but hidden from the AArch64 register, we could be in a
> > particularly difficult position. Especially if we enabled traps based on
> > the AArch64 value and UNDEF the guest.
> >
> > One hack we could do is skip trap configuration if AArch32 is visible at
> > either EL1 or EL0, but that may not be the most elegant solution.
> > Otherwise, if we are AArch64-only at every EL then the definition of the
> > AArch32 feature registers is architecturally UNKNOWN, so we can dodge
> > the problem altogether. What are your thoughts?
> 
> Thank you so much for your review, Oliver!
> 
> For aarch32 guests (when KVM_ARM_VCPU_EL1_32BIT is configured),
> yes, the current series is problematic as you mentioned...
> I am thinking of disallowing configuring ID registers (keep ID
> registers immutable) for the aarch32 guests for now at least.
> (will document that)

That fixes it halfway, but the AArch64 views of the AArch32 feature
registers have meaning even if AArch32 is defined at EL0. The only time
they are architecturally UNKNOWN is if AArch32 is not implemented at any
EL visible to the guest.

So, given that:

> For aarch64 guests that support EL0 aarch32, it would generally
> be a userspace bug if userspace sets inconsistent values in 32bit
> and 64bit ID registers. KVM doesn't provide a complete consistency
> checking for ID registers, but this could be added later as needed.

I completely agree that there is a large set of things that can be swept
under the rug of userspace bugs. If we are going to do that, we need to
strongly assert that configurable feature registers is only for fully
AArch64-only guests. Additionally, strong documentation around these
expectations is required.

Mind you, these opinions are my own and IDK how others or Marc feel
about it. My read of the situation w.r.t. the AArch32 registers is that
it will become a mess to implement on top of the AArch64 registers.
Given the fact that we aren't breaking AArch32 VMs, only augmenting
behavior for AArch64, it seems OK.

But I would genuinely love to be wrong on this topic too. I just don't
have perspective on AArch32 users so it is hard to really say whether
this is something they need as well.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
