Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F85AC6FA83
	for <kvmarm@archiver.kernel.org>; Sat, 10 Sep 2022 04:15:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 253974C0BC;
	Sat, 10 Sep 2022 00:15:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id euIvG7lBQJmy; Sat, 10 Sep 2022 00:15:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 177AF4BFBB;
	Sat, 10 Sep 2022 00:15:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A668D4BF5F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2022 00:15:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8uJh941ourzY for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Sep 2022 00:15:53 -0400 (EDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com
 [209.85.217.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F0A74BF19
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Sep 2022 00:15:53 -0400 (EDT)
Received: by mail-vs1-f54.google.com with SMTP id k2so3644120vsk.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Sep 2022 21:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date;
 bh=otYREk8t2WdG/NJ+ZPtuIVmKtO1jI4mWCWtGovgZifs=;
 b=P1/zZ7bOsUX2MawfFHJAH9LBegb1zhmBN9uR6JsmYDcDZCVq8AuQpbgnXpW8iPb4GB
 TP6FJIUZzb+d8XBBIush3ABrXqtl7/wyjLv6aKCkBCFR96Ej72dJpIhO3ezgUn/9MLYM
 Ot0IJEUCvIDFNlMv3Wifnjb5gdhNMEn+PqszUyRDnRilMi6VdoTYkUYAP1HLkux/qd9Y
 UO5gRN03fRRoRjEsJjH3k0g6kxnyy5bX9GYetj2MPWsi7zzaCdyN8RQiN08gM2Z+YRKJ
 tDUvQVqiH5TC9GSDcVbekxwRALeE1CoXehCkEdesZkbbLnE7g0v+5edVCZzDIjWZtRsT
 sK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=otYREk8t2WdG/NJ+ZPtuIVmKtO1jI4mWCWtGovgZifs=;
 b=hAHJXR8y0iiFTe9DcvQm8WovtWKtZf9/Y7Iuwfw+2N+RkQ98c49xT7HvExFCKRmeHI
 SLfssW7gcbibGMDCDXCy7rRpdwi6T2L3ecHBuRSD+Taz8ihM2OAP6vejz8BLR7Fycc8V
 rdfxjkk7DlM0eRyH+W0g+2mXI573TTxGgs7uET2JBVjcLhmsr1+77dji3b6QFn92Xk58
 iAG3rRI7Yj06D088ecSIoKzC+0F4beg1Wu0It+0Q5WYhcKFHKrezAA0BpNeVqBE1sMaN
 cpL50FR0oGet2r7cQX06jnrfVjDOeLiueqhxqznH8RqTItdF9MRNfi7/STmzEPFORmwD
 f6ow==
X-Gm-Message-State: ACgBeo2CbnxdtLB0QTn67i2x+aUr96zaM5yKsYGyV5nquLX07khYeGBG
 YvD0BrXK/R6hZ9qozKD8OYVAESu62g0b0BuU+UcabA==
X-Google-Smtp-Source: AA6agR4VUM5bZTnLtDGODi754vdxpwLgswug4ZoSrk/lFyazp+e82v69j928eFB59oIJrBArMmqhtHgMHx/zOs6vvnc=
X-Received: by 2002:a67:ea58:0:b0:38f:d89a:e4b3 with SMTP id
 r24-20020a67ea58000000b0038fd89ae4b3mr5967895vso.51.1662783353013; Fri, 09
 Sep 2022 21:15:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com>
 <20220825050846.3418868-4-reijiw@google.com>
 <YxuX+ztKm/rPetql@google.com>
In-Reply-To: <YxuX+ztKm/rPetql@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Fri, 9 Sep 2022 21:15:37 -0700
Message-ID: <CAAeT=Fx38tW+XkfWBvs+dgB4JU4SpVHOVzu4w-BMkAbe21+W5g@mail.gmail.com>
Subject: Re: [PATCH 3/9] KVM: arm64: selftests: Remove the hard-coded
 {b,w}pn#0 from debug-exceptions
To: Ricardo Koller <ricarkol@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Andrew Jones <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Ricardo,

On Fri, Sep 9, 2022 at 12:46 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Aug 24, 2022 at 10:08:40PM -0700, Reiji Watanabe wrote:
> > Remove the hard-coded {break,watch}point #0 from the guest_code()
> > in debug-exceptions to allow {break,watch}point number to be
> > specified.  Subsequent patches will add test cases for non-zero
> > {break,watch}points.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  .../selftests/kvm/aarch64/debug-exceptions.c  | 50 ++++++++++++-------
> >  1 file changed, 32 insertions(+), 18 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > index 51047e6b8db3..183ee16acb7d 100644
> > --- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > +++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
> > @@ -93,6 +93,9 @@ GEN_DEBUG_WRITE_REG(dbgwvr)
> >
> >  static void reset_debug_state(void)
> >  {
> > +     uint8_t brps, wrps, i;
> > +     uint64_t dfr0;
> > +
> >       asm volatile("msr daifset, #8");
> >
> >       write_sysreg(0, osdlr_el1);
> > @@ -100,11 +103,20 @@ static void reset_debug_state(void)
> >       isb();
> >
> >       write_sysreg(0, mdscr_el1);
> > -     /* This test only uses the first bp and wp slot. */
> > -     write_sysreg(0, dbgbvr0_el1);
> > -     write_sysreg(0, dbgbcr0_el1);
> > -     write_sysreg(0, dbgwcr0_el1);
> > -     write_sysreg(0, dbgwvr0_el1);
> > +
> > +     /* Reset all bcr/bvr/wcr/wvr registers */
> > +     dfr0 = read_sysreg(id_aa64dfr0_el1);
> > +     brps = cpuid_get_ufield(dfr0, ID_AA64DFR0_BRPS_SHIFT);
>
> I guess this might have to change to ARM64_FEATURE_GET(). In any case:
>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
>
> (also assuming it includes the commit message clarification about reset
> clearing all registers).

Yes, I will fix those in V2.

Thank you for the review!
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
