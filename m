Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7625BC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  5 Apr 2022 01:46:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCF904B1C7;
	Mon,  4 Apr 2022 21:46:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q-L57SbVDCKy; Mon,  4 Apr 2022 21:46:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D68D74B0D0;
	Mon,  4 Apr 2022 21:46:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2C134B0BD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 21:46:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D1nZVu81jeJT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 21:46:52 -0400 (EDT)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A66F84B0B6
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 21:46:52 -0400 (EDT)
Received: by mail-pj1-f54.google.com with SMTP id
 ku13-20020a17090b218d00b001ca8fcd3adeso1076212pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Apr 2022 18:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=5/ENKPwEE0XsowuVbAwYwEQbZbBA4Wrsv1B56cUOhLw=;
 b=nsiMnTnbPhcHABw79aFqyBZ52gouWySQb6b1zd/6RuyHX6qu73aXxT51uGKKKoUFCq
 j0Ntp5j3lq7wl3WQLkxUzU4TP7IL1XWp62PZglt+kE30WJI06gMGKc3zXkHK4pUvQhX5
 FeNlAj47ZRvz7WWAzc21LhNTm/3Of2xMjtdLDhYJ0a7+Kg4y3UAZuxhLbCioOhPCCIDk
 ve6CW64McuhYSy5w9e1MKsGtIntlS2YUZmSSgvEjW5lrERmRgcXps9QhsQqCUzNp2TBB
 X2O+F7cDoZ4QCAf9UpkfOXMlxzobrkpcdzd2kwwZdkCGR57Ob40eopdLwj65gtU4QehD
 SNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=5/ENKPwEE0XsowuVbAwYwEQbZbBA4Wrsv1B56cUOhLw=;
 b=x9RU2+p08rSx8EROUqbF0miLQUWfW4V12UStvOWYn0E98iZ7dnQQpjuimFySR+MPQJ
 gX2+ghLYKCk2MonaB5M31vNDRCyZb6gJkYlwheVB8e3r6D22+KiVlPqcHkxRWgdbZa7K
 EpE0j45hZy8+qHrDUpJBEYpM0uLogZ9I90F9i+5RmI41PieydfRji6kZtG87v0xAsMF0
 oJLt5PUWk5snEnpiiIrYzSSZdOGokY70AbxiYQZ+p+8x1U6ZpUUBkXPXvhpkiN41GFqP
 HzD/Kh2i/LssZFtd0gDj6ee7AjI5sNtb2PMa8A39pR2X/kOpN6opUuticaImhkBcd3hP
 10Ew==
X-Gm-Message-State: AOAM5308Wvsi3O8Nm2KJeabbbQJCgFzR7mro5LmCmfP6zCYMaPkRs2rc
 RuM66G4C47mzM4zbFPf8zQFUSbuHzMs9ESdGyZ0c8Q==
X-Google-Smtp-Source: ABdhPJwZdAVxNvvwelmoX0UfJB9QP/f71rA9aZ2+c9FFogDIIiR3+0GsySURpnJyc8i+/2rzWVAUXFRGTR5VQN4zqG8=
X-Received: by 2002:a17:90a:b903:b0:1ca:be37:1d41 with SMTP id
 p3-20020a17090ab90300b001cabe371d41mr1258623pjr.9.1649123211375; Mon, 04 Apr
 2022 18:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-3-oupton@google.com>
 <CAAeT=FxSTL2MEBP-_vcUxJ57+F1X0EshU4R2+kNNEf5k1jJXig@mail.gmail.com>
 <YkqCAcPCnqYofspa@google.com> <Ykt8/Q5LLpZdgLu5@google.com>
In-Reply-To: <Ykt8/Q5LLpZdgLu5@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 4 Apr 2022 18:46:35 -0700
Message-ID: <CAAeT=Fx=aFF6h-iYeW3NLiba_uStO72jL6eQYNjyx8B6a2OLOQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Plumb cp10 ID traps through the
 AArch64 sysreg handler
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Oliver,

On Mon, Apr 4, 2022 at 4:19 PM Oliver Upton <oupton@google.com> wrote:
>
> On Mon, Apr 04, 2022 at 05:28:33AM +0000, Oliver Upton wrote:
> > Hi Reiji,
> >
> > On Sun, Apr 03, 2022 at 08:57:47PM -0700, Reiji Watanabe wrote:
> > > > +int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> > > > +       u32 esr = kvm_vcpu_get_esr(vcpu);
> > > > +       struct sys_reg_params params;
> > > > +       int ret;
> > > > +
> > > > +       /* UNDEF on any unhandled register or an attempted write */
> > > > +       if (!kvm_esr_cp10_id_to_sys64(esr, &params) || params.is_write) {
> > > > +               kvm_inject_undefined(vcpu);
> > >
> > > Nit: For debugging, it might be more useful to use unhandled_cp_access()
> > > (, which needs to be changed to support ESR_ELx_EC_CP10_ID though)
> > > rather than directly calling kvm_inject_undefined().
> >
> > A very worthy nit, you spotted my laziness in shunting straight to
> > kvm_inject_undefined() :)
> >
> > Thinking about this a bit more deeply, this code should be dead. The
> > only time either of these conditions would happen is on a broken
> > implementation. Probably should still handle it gracefully in case the
> > CP10 handling in KVM becomes (or is in my own patch!) busted.
>
> Actually, on second thought: any objections to leaving this as-is?
> kvm_esr_cp10_id_to_sys64() spits out sys_reg_params that point at the
> MRS alias for the VMRS register. Even if that call succeeds, the params
> that get printed out by unhandled_cp_access() do not match the actual
> register the guest was accessing. And if the call fails, ->Op2 is
> uninitialized.

I understand a few additional changes are needed for this.
Or simply use WARN_ON_ONCE ? (since this cannot be created by
the guest but by a KVM or CPU problem)

I'm fine with the current code as-is though:)

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
