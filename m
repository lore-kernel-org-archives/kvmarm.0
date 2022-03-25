Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FE5C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Mar 2022 08:51:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DDF94B0DB;
	Fri, 25 Mar 2022 04:51:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qmkAI3XEKpob; Fri, 25 Mar 2022 04:51:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 546824A119;
	Fri, 25 Mar 2022 04:51:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5154249F4E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 04:51:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VmHUbj1atcYq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2022 04:51:33 -0400 (EDT)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com
 [209.85.166.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07ADB410BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 04:51:32 -0400 (EDT)
Received: by mail-il1-f172.google.com with SMTP id e9so4760032ilu.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 01:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=D+ewmka4Gd8DAMHHQuozzPeOxQhpVTwVoGFD7qhHhPs=;
 b=EmuKVvi9M1eAh5stXUDrlPwv/SJMwHUAT4uY3DOSKr64k1SA6eCCsIlkfzTtnoVz66
 8K4uQ7h9YSh/R1wi4ogUkG8ayYlPpsEw6HiQJa14cdkhqgKs2pVKws38OtMQtaKosELk
 CUayzinuHGmMDVy+fWPRQ1UdSAbHh7P2xrISjl3ENUOdwyzF5aoyYPjwZgvg/cQLY9WZ
 yKCtIaE0VPFxEC0z1RRpOS6aFi7IKqT8XfAY/RSRsE10nM2yJbxwXcK6UVnMJcknO7sC
 sMgfLZNzvmo8qCDK2/Z5HyjtFEKSFyyCjXk+oinCRW8TtbDfaT8gpmrAj5WFgGz8cTg8
 gt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=D+ewmka4Gd8DAMHHQuozzPeOxQhpVTwVoGFD7qhHhPs=;
 b=FIQbne2de2KpjgYY6pT70wYGj6raF7Sq4H9+A7Kh20d9XiS2ICbyXCxV2xb19wY3PJ
 Xo9sbYl/FyiPqnCw0sUIuspZV9jI2DriF6LVH4RZLL2455WeTNVMJ+sf4bu3mR3XBTqX
 vdR0HDIen5l4Ywyxb1/mS2dXTYOVEn2XydOcB/Mv2DamoC8ubtFnPs8XXWrZ1r+e8H6b
 jGerdQhEF2ZD3g2EWzLbOjsOsLkNr684XxZOSpLbtFCnB/LtyempHXf4BVdpSA+uyxSF
 9R1oAMAggYJJEhwrXu6xsrPx+0vpJslFikUiJ3HFqIN7YSxE/h0L2FOg1CTZh458CEdt
 Ptww==
X-Gm-Message-State: AOAM531p8ObOMWcLtXTFcp/ihIiiUSOEaasSsCuZ5E4U0+8gHSIIbsPO
 u460klfz6yrrjM5dijcFFq8EMQ==
X-Google-Smtp-Source: ABdhPJzLBqfP1XcXqob9kFKwAurSxWiBTNrBa1UAoCW3rOZKHRhfNNzkyCiKxxa+LBJw8i7jEfIOzw==
X-Received: by 2002:a92:ae02:0:b0:2c6:798d:2be with SMTP id
 s2-20020a92ae02000000b002c6798d02bemr4402956ilh.18.1648198292138; 
 Fri, 25 Mar 2022 01:51:32 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 z11-20020a92cd0b000000b002c85ac49d2asm2607365iln.79.2022.03.25.01.51.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 25 Mar 2022 01:51:31 -0700 (PDT)
Date: Fri, 25 Mar 2022 08:51:28 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <Yj2CkBSy87crVekv@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com>
 <CAAeT=FwkXSpwtCOrggwg=V72TYCRb24rqHYVUGd+gTEA-jN66w@mail.gmail.com>
 <Yjz4SZbqS+3aD5YO@google.com>
 <CAAeT=FxbXELzn4gTjdqwO9hwNMJN69BTWntNyNXHCjFTW=t25g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FxbXELzn4gTjdqwO9hwNMJN69BTWntNyNXHCjFTW=t25g@mail.gmail.com>
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

On Thu, Mar 24, 2022 at 10:15:41PM -0700, Reiji Watanabe wrote:
> On Thu, Mar 24, 2022 at 4:01 PM Oliver Upton <oupton@google.com> wrote:
> >
> > On Thu, Mar 24, 2022 at 01:23:42PM -0700, Reiji Watanabe wrote:
> > > Hi Oliver,
> > >
> > > On Wed, Mar 23, 2022 at 12:53 PM Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > Hi Reiji,
> > > >
> > > > On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > > > > Add hidden or reserved ID registers, and remaining ID registers,
> > > > > which don't require special handling, to id_reg_desc_table.
> > > > > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > > > > or reserved registers. Since now id_reg_desc_init() is called even
> > > > > for hidden/reserved registers, change it to not do anything for them.
> > > > >
> > > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > >
> > > > I think there is a very important detail of the series that probably
> > > > should be highlighted. We are only allowing AArch64 feature registers to
> > > > be configurable, right? AArch32 feature registers remain visible with
> > > > their default values passed through to the guest. If you've already
> > > > stated this as a precondition elsewhere then my apologies for the noise.
> > > >
> > > > I don't know if adding support for this to AArch32 registers is
> > > > necessarily the right step forward, either. 32 bit support is working
> > > > just fine and IMO its OK to limit new KVM features to AArch64-only so
> > > > long as it doesn't break 32 bit support. Marc of course is the authority
> > > > on that, though :-)
> > > >
> > > > If for any reason a guest uses a feature present in the AArch32 feature
> > > > register but hidden from the AArch64 register, we could be in a
> > > > particularly difficult position. Especially if we enabled traps based on
> > > > the AArch64 value and UNDEF the guest.
> > > >
> > > > One hack we could do is skip trap configuration if AArch32 is visible at
> > > > either EL1 or EL0, but that may not be the most elegant solution.
> > > > Otherwise, if we are AArch64-only at every EL then the definition of the
> > > > AArch32 feature registers is architecturally UNKNOWN, so we can dodge
> > > > the problem altogether. What are your thoughts?
> > >
> > > Thank you so much for your review, Oliver!
> > >
> > > For aarch32 guests (when KVM_ARM_VCPU_EL1_32BIT is configured),
> > > yes, the current series is problematic as you mentioned...
> > > I am thinking of disallowing configuring ID registers (keep ID
> > > registers immutable) for the aarch32 guests for now at least.
> > > (will document that)
> >
> > That fixes it halfway, but the AArch64 views of the AArch32 feature
> > registers have meaning even if AArch32 is defined at EL0. The only time
> > they are architecturally UNKNOWN is if AArch32 is not implemented at any
> > EL visible to the guest.
> >
> > So, given that:
> >
> > > For aarch64 guests that support EL0 aarch32, it would generally
> > > be a userspace bug if userspace sets inconsistent values in 32bit
> > > and 64bit ID registers. KVM doesn't provide a complete consistency
> > > checking for ID registers, but this could be added later as needed.
> >
> > I completely agree that there is a large set of things that can be swept
> > under the rug of userspace bugs. If we are going to do that, we need to
> > strongly assert that configurable feature registers is only for fully
> > AArch64-only guests. Additionally, strong documentation around these
> > expectations is required.
> 
> Just to be clear, what I meant "this could be added later" is that
> the feature consistency checking between 64bit ID registers and 32bit ID
> registers could be added later.  It means configuring ID registers
> itself will be allowed for EL1 aarch64 guests including ones that
> support EL0 aarch32 (but not for EL1 aarch32 guests).
> 

I believe we are in agreement then. I don't believe there is any need
to prohibit register accesses for the case of AArch32 EL1, given the
fact that it is impossible to read the ID_AA64*_EL1 registers from the
guest anyway.

We can go ahead and let userspace play with those registers as much as
it wants, it delightfully has no affect :)

> > Mind you, these opinions are my own and IDK how others or Marc feel
> > about it. My read of the situation w.r.t. the AArch32 registers is that
> > it will become a mess to implement on top of the AArch64 registers.
> > Given the fact that we aren't breaking AArch32 VMs, only augmenting
> > behavior for AArch64, it seems OK.
> 
> Thank you for sharing your thoughts.
> They look almost the same as what I've been thinking.
> 
> Thanks,
> Reiji
> 
> 
> > But I would genuinely love to be wrong on this topic too. I just don't
> > have perspective on AArch32 users so it is hard to really say whether
> > this is something they need as well.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
