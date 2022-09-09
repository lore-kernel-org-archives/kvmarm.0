Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209EAECAAA1
	for <kvmarm@archiver.kernel.org>; Fri,  9 Sep 2022 10:15:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 990594C91B;
	Fri,  9 Sep 2022 06:15:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZZEV1spiI32w; Fri,  9 Sep 2022 06:15:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 510C94C9F7;
	Fri,  9 Sep 2022 06:15:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 937504C917
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 06:15:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n2eADROV-RCY for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2022 06:15:55 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 44A054C912
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2022 06:15:55 -0400 (EDT)
Date: Fri, 9 Sep 2022 11:15:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1662718554;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=UWf75u93hFnHokSkmXHPMg8FKyuqd4msKp/yEz7C7Ao=;
 b=MTo2cIazKhJL+OTHp3ysffg8vodSCAed8X2h3DOACc71oK2aqbBLC8NVrUh6Y96fLISHKg
 RHr3qPWaAmutt9oyx7mVi3or4pcgVp1Ros6ZN4U6x/7bf6jP/xluVrOBnUw1XFK9aJt0ce
 1VVctsUI4WfaWLRjrfom8jZgC+S/zdk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 6/7] KVM: arm64: Treat 32bit ID registers as RAZ/WI on
 64bit-only system
Message-ID: <YxsSU2Rwdc2sO3IJ@google.com>
References: <20220902154804.1939819-1-oliver.upton@linux.dev>
 <20220902154804.1939819-7-oliver.upton@linux.dev>
 <CAAeT=FxARdyXJyDgh_E4L-w0azuCY+47WgoM9MheBwyS8SdX1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FxARdyXJyDgh_E4L-w0azuCY+47WgoM9MheBwyS8SdX1Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Reiji,

On Tue, Sep 06, 2022 at 09:52:53PM -0700, Reiji Watanabe wrote:

[...]

> >         /* CRm=3 */
> > -       ID_SANITISED(MVFR0_EL1),
> > -       ID_SANITISED(MVFR1_EL1),
> > -       ID_SANITISED(MVFR2_EL1),
> > +       AA32_ID_SANITISED(MVFR0_EL1),
> > +       AA32_ID_SANITISED(MVFR1_EL1),
> > +       AA32_ID_SANITISED(MVFR2_EL1),
> >         ID_UNALLOCATED(3,3),
> > -       ID_SANITISED(ID_PFR2_EL1),
> > +       AA32_ID_SANITISED(ID_PFR2_EL1),
> >         ID_HIDDEN(ID_DFR1_EL1),
> 
> Perhaps it might be better to handle ID_AFR0_EL1 and ID_DFR1_EL1
> in the same way as the other AArch32 ID registers for consistency ?
> (i.e. treat them RAZ/USER_WI instead of RAZ if kvm_supports_32bit_el0()
>  is false instead of RAZ)

Thanks for having a look. I stopped short of treating these registers as
RAZ/USER_WI since an attempted nonzero write to either of these
registers is a userspace bug (KVM always advertised 0).

As the ABI isn't busted for these registers I'd prefer to leave it in
place. Having said that, I'm not too strongly motivated in either
direction.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
