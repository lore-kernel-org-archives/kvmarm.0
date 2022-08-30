Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAAAECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 30 Aug 2022 17:45:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 392364B64E;
	Tue, 30 Aug 2022 13:45:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ovcqLIGvR2XT; Tue, 30 Aug 2022 13:45:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBDCA4B8DD;
	Tue, 30 Aug 2022 13:45:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77FD24B8D8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 13:45:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1eDM+8-4G8SR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2022 13:45:19 -0400 (EDT)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 11ECD4B64E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2022 13:45:18 -0400 (EDT)
Date: Tue, 30 Aug 2022 12:45:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1661881517;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=bZ/O3vOFDUvoL+xwB7YJSEtUpOZ6W45CAPj5b/aG6hs=;
 b=FW0OqKpqy3RbUkz4twa7NjQFBZuUkJapstDnlrevW9OKV8lDkgX3u1cof3AprNcoA3nNWt
 /Fp68JTIJ+Z6ku+RFpjQhQm7dUZZP0XGeDT3CYETvIlZ88EI0VqEYaYCOUwmHGPtDLhr5+
 kv20p2660vzAYC5mu21QVsRSEqe8DtI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/6] KVM: arm64: Remove internal accessor helpers for id
 regs
Message-ID: <Yw5MqMvqwPXBPE0a@google.com>
References: <20220817214818.3243383-1-oliver.upton@linux.dev>
 <20220817214818.3243383-3-oliver.upton@linux.dev>
 <CAAeT=FwxN=UtVGO+85iZNRkGEoZ7GQ_WB4FAhHBRnCKoPNXHVg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FwxN=UtVGO+85iZNRkGEoZ7GQ_WB4FAhHBRnCKoPNXHVg@mail.gmail.com>
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

Hi Reiji,

On Mon, Aug 29, 2022 at 10:45:09PM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> On Wed, Aug 17, 2022 at 2:48 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > The internal accessors are only ever called once. Dump out their
> > contents in the caller.
> >
> > No functional change intended.
> >
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 46 ++++++++++-----------------------------
> >  1 file changed, 12 insertions(+), 34 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index e18efb9211f0..26210f3a0b27 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1153,25 +1153,17 @@ static unsigned int raz_visibility(const struct kvm_vcpu *vcpu,
> >
> >  /* cpufeature ID register access trap handlers */
> >
> > -static bool __access_id_reg(struct kvm_vcpu *vcpu,
> > -                           struct sys_reg_params *p,
> > -                           const struct sys_reg_desc *r,
> > -                           bool raz)
> > -{
> > -       if (p->is_write)
> > -               return write_to_read_only(vcpu, p, r);
> > -
> > -       p->regval = read_id_reg(vcpu, r, raz);
> > -       return true;
> > -}
> > -
> >  static bool access_id_reg(struct kvm_vcpu *vcpu,
> >                           struct sys_reg_params *p,
> >                           const struct sys_reg_desc *r)
> >  {
> >         bool raz = sysreg_visible_as_raz(vcpu, r);
> >
> > -       return __access_id_reg(vcpu, p, r, raz);
> > +       if (p->is_write)
> > +               return write_to_read_only(vcpu, p, r);
> > +
> > +       p->regval = read_id_reg(vcpu, r, raz);
> > +       return true;
> >  }
> >
> >  /* Visibility overrides for SVE-specific control registers */
> > @@ -1226,31 +1218,13 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >   * are stored, and for set_id_reg() we don't allow the effective value
> >   * to be changed.
> >   */
> > -static int __get_id_reg(const struct kvm_vcpu *vcpu,
> > -                       const struct sys_reg_desc *rd, u64 *val,
> > -                       bool raz)
> > -{
> > -       *val = read_id_reg(vcpu, rd, raz);
> > -       return 0;
> > -}
> > -
> > -static int __set_id_reg(const struct kvm_vcpu *vcpu,
> > -                       const struct sys_reg_desc *rd, u64 val,
> > -                       bool raz)
> > -{
> > -       /* This is what we mean by invariant: you can't change it. */
> > -       if (val != read_id_reg(vcpu, rd, raz))
> > -               return -EINVAL;
> > -
> > -       return 0;
> > -}
> > -
> >  static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >                       u64 *val)
> >  {
> >         bool raz = sysreg_visible_as_raz(vcpu, rd);
> >
> > -       return __get_id_reg(vcpu, rd, val, raz);
> > +       *val = read_id_reg(vcpu, rd, raz);
> > +       return 0;
> >  }
> >
> >  static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> > @@ -1258,7 +1232,11 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >  {
> >         bool raz = sysreg_visible_as_raz(vcpu, rd);
> >
> > -       return __set_id_reg(vcpu, rd, val, raz);
> > +       /* This is what we mean by invariant: you can't change it. */
> > +       if (val != read_id_reg(vcpu, rd, raz))
> > +               return -EINVAL;
> > +
> > +       return 0;
> >  }
> 
> I see no reason for read_id_reg() to take raz as an argument.
> Perhaps having read_id_reg() call sysreg_visible_as_raz() instead
> might make those functions even simpler?

Good point, as this patch has done away with caller-specified RAZ. I'll
incorporate that into v2.

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
