Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13219ECAAD1
	for <kvmarm@archiver.kernel.org>; Wed, 31 Aug 2022 14:42:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1254BA13;
	Wed, 31 Aug 2022 10:42:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5Imy4r1ItivZ; Wed, 31 Aug 2022 10:42:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13A024B9CD;
	Wed, 31 Aug 2022 10:42:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C7E744B89C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Aug 2022 10:42:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xEV5tUBtjeVv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Aug 2022 10:42:14 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 964C34B85E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Aug 2022 10:42:14 -0400 (EDT)
Date: Wed, 31 Aug 2022 14:42:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661956933;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=g3Lk2N97Zy8lF4iHLvNol66vmP95kccpVgysVRZVMDY=;
 b=DxmKFJZH3WcdiTOix4wPJ2jevhfZDpQLQRr0E8RzgtFAbrFUiWjnuCRIo4VdA7V9wVB0aY
 nWDczGJ5u3d9PShBrqVRrwBKRN7UnFn1ALppULQ+QijhEhPJQJBI8d/ZQnjpzcA8VAbo0Z
 aVVG2TWEZflbOHWlnKVif5jTQZzY8E4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 4/6] KVM: arm64: Add a visibility bit to ignore user writes
Message-ID: <Yw9zQaxuSFlVsf5O@google.com>
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
 <20220817214818.3243383-5-oliver.upton@linux.dev>
 <CAAeT=FzQkgf7g3yXP++u_2zio1XL9mRSzPZ6hxmanwVk4QUNbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FzQkgf7g3yXP++u_2zio1XL9mRSzPZ6hxmanwVk4QUNbQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Tue, Aug 30, 2022 at 08:29:37PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > We're about to ignore writes to AArch32 ID registers on AArch64-only
> > systems. Add a bit to indicate a register is handled as write ignore
> > when accessed from userspace.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 3 +++
> >  arch/arm64/kvm/sys_regs.h | 7 +++++++
> >  2 files changed, 10 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 26210f3a0b27..9f06c85f26b8 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1232,6 +1232,9 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >  {
> >         bool raz = sysreg_visible_as_raz(vcpu, rd);
> >
> > +       if (sysreg_user_write_ignore(vcpu, rd))
> > +               return 0;
> 
> Since the visibility flags are not ID register specific,
> have you considered checking REG_USER_WI from kvm_sys_reg_set_user()
> rather than the ID register specific function ?

Yeah, that's definitely a better place to wire it in.

> This patch made me reconsider my comment for the patch-2.
> Perhaps it might be more appropriate to check RAZ visibility from
> kvm_sys_reg_get_user() rather than the ID register specific function ?

REG_RAZ hides the register value from the guest as well as userspace, so it
might be better to leave it in place. REG_RAZ also has implications for
writing a register from userspace, as we still apply the expectation of
invariance to ID registers that set this flag.

It all 'just works' right now with the check buried in the ID register
accessors. Going the other way around would require sprinkling the check
in several locations.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
