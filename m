Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA0FC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 20:44:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3325D411D2;
	Wed, 23 Mar 2022 16:44:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id raWwg6AL3OuH; Wed, 23 Mar 2022 16:44:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 013A449F1F;
	Wed, 23 Mar 2022 16:44:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BACB949EB5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 16:44:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZT+fFDId0PWJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 16:44:31 -0400 (EDT)
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com
 [209.85.166.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B19C411D2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 16:44:31 -0400 (EDT)
Received: by mail-io1-f43.google.com with SMTP id h63so3176112iof.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 13:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=fBYzqNvet64/0krUr0ciJEOs0VfPj+5SgRq8wB41m/Y=;
 b=lLOyeDE2K2xnQP2wIsZs+7lFjAZSUj+oUmRol43y2da5eJOostn3fkxHSFqFT1OEoE
 DLJLBtgCvey2Y6GmWH+AVUYWVDk5ms0Pn4hWGrwF5nL+TJ/T5R2fktQIlF/lcushiszq
 W4PP9+tx8xGR6cgtFo3T9retLiCapuKxPzlGCopIMxn623ciKn/lu7rUK4ar8gVKrWWH
 /zln0ndb20fztc0l9AiKPOzEFe4T4YxiHzKoYrpDJHBNnYyuYe38LJcdKWb3HF98Wcip
 ZJU9aEkYve+mZv7RHs5kvtHOYKRGHNuDy9LZWztx70CdbisJJ8L2vp5eYA5qa2UF8S6+
 y8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=fBYzqNvet64/0krUr0ciJEOs0VfPj+5SgRq8wB41m/Y=;
 b=v3qaLB7Ad2+NJ49JKuuImJihwdJaA+CWovwXgilXZJI3tHJnd0G6xApBs7NCLD24qe
 9gXyA/MnYwPlcs/txqJJZi80BzmLDSHHgyusJ8idZLLqCgUYfkNK6kIqBjPbyFLlBzQL
 oEmV+i4O2LNotn1xXGBiys50oBgedSe/vZ7+DCNVZrrYrrm2sEhg/aC6U1sjBKMC39kg
 SD0zsLGomPtbvPLwaH+TopnI8tguKHDupAwf8q12siq0wBSkDt0/sQ+lCpx4QxF8ndOJ
 6uOJpwa+95HW/bAVRUTwv78q/Y0a0SXZkcLlT/Mn+OeiCQ3ZhCD9xgU8BYPfW+TP99wR
 qj5g==
X-Gm-Message-State: AOAM531Kc/ADWmlZrQPRdmAX+tkOHLVj2tPCJF8AV/yteZeQQXpaS9f7
 aU7xxcqXRILQdhQimMOFCE9Q/Q==
X-Google-Smtp-Source: ABdhPJw3ZsqPYgRWN2t8hFdvcwjyxZrgb4iSxxaz6Qmr0jj4ImtSi0dpxqgCuiywJjF12eN2LenMAA==
X-Received: by 2002:a05:6602:1409:b0:5e7:487:133c with SMTP id
 t9-20020a056602140900b005e70487133cmr986456iov.196.1648068270491; 
 Wed, 23 Mar 2022 13:44:30 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 k5-20020a6bf705000000b00649a2634725sm470970iog.17.2022.03.23.13.44.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 13:44:29 -0700 (PDT)
Date: Wed, 23 Mar 2022 20:44:26 +0000
From: Oliver Upton <oupton@google.com>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <YjuGqunshjhCoIs5@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com> <Yjt/bJidLEPsiPfQ@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Yjt/bJidLEPsiPfQ@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
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

On Wed, Mar 23, 2022 at 01:13:32PM -0700, Ricardo Koller wrote:
> On Wed, Mar 23, 2022 at 07:53:14PM +0000, Oliver Upton wrote:
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
> 
> Aren't AArch64 ID regs architecturally mapped to their AArch32
> counterparts?  They should show the same values.  I'm not sure if it's a
> problem (and if KVM is faithful to that rule),

I believe it's a bit more subtle than that. The AArch32 feature registers
are architecturally mapped to certain encodings accessible from AArch64.
For example, ID_PFR0_EL1 is actually a 64 bit register where bits [31:0]
map to the ID_PFR0 AArch32 register. ID_PFR0_EL1 is only accessible from
AArch64 with the MRS instruction, and ID_PFR0 is only accessible from
AArch32 with the MRC instruction. KVM just so happens to handle both of
these reads from the same sys_reg_desc.

AFAIK, there does not exist a direct bit mapping between the
ID_*_EL1 <-> ID_AA64*_EL1 registers. But hey, could be wrong :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
