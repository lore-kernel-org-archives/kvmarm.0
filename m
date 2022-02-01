Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F2A2C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 14:14:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4B9649F31;
	Tue,  1 Feb 2022 09:14:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rKEc4C9-2AVo; Tue,  1 Feb 2022 09:14:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B5A449EFB;
	Tue,  1 Feb 2022 09:14:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B65EC49EFB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:14:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IkqAWAUQcUTb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 09:14:18 -0500 (EST)
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com
 [209.85.167.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AECD49EC2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 09:14:18 -0500 (EST)
Received: by mail-oi1-f176.google.com with SMTP id m10so8471061oie.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Feb 2022 06:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PYRbSeUWHWAkD5Kd+0N25nvXOHZL7u4Qu9YXoNUAyeo=;
 b=jj1iDsiCiZxpNd7FUut/qtkCzC6WJgaSsVAFh8dUdVFHNP1PiHxUKDddWVsFL7Z9YW
 O2Pcg0qmagvLRBtXMXfaT2CqGtdZSS1xTncLUhgL7HlgkJU4ASwia6enK54Eu/6rj6x7
 dV+T6gHsymf03+F3KV38Zy2WTrIf+pY1doeh77ksOXd/KIcbD9+ibfsyJQZxlLAeRmTW
 /0TU5VgHZ7vo4ExkO3bOw48U5agl5jOBQYJL6NewaXvUukJgXrBvGClEyb1YXQDAb9Ui
 VBCeJTlyrOExu9JUIcZXY05S8Zdjl7bgRW3H7jwBfPa0kNxYImzOWkOJiqgOS0BF3p+Z
 ei7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=PYRbSeUWHWAkD5Kd+0N25nvXOHZL7u4Qu9YXoNUAyeo=;
 b=MuX+AAGt8+yU49BzGfQv8rNPwOYTiLJn5D9F/CZYGNh6YGKRId2MPfwCAMiM8yMhZ4
 f6x1MICICw/fORqRqKXEJgKfqfeSBVUh4e4nDOeDbm99GZwFPCEmqrLplkprlFnnJR2F
 ZHdAhfw8rWYXFBX6lTFRSAirRMG5sHk4mapwAtr28a6z0+5NKa5jX9usXRE1B16dWqyz
 R3cTSrU+1YgXB2IjElNWM7iLqcfVCNsgVR8NlfFhU1aD7CDoLx6FrMXBluHkzjv6UaYm
 OImz91HmwC+QICbpi3dus1MmeIC/2bs1HjyxMuDW3OdqKg3x2o2kQqAyi9gHb5ZLFVQj
 I0Uw==
X-Gm-Message-State: AOAM532psIBCRj+MlSLHPVCAa867g1GwoKZO/3Rs9WoJ2bvfvZVARunn
 r0/cV2jjjcqLlJ07sv6gkKTcvrUF8m18/V3/2ST4VA==
X-Google-Smtp-Source: ABdhPJwvM9sVuGBLbRrWN3HLt1MxHUPHW4zc7Gzm0+emygrWaIiDLe8jwqyEvUpeiu5Um4JDrMN1VKQX7TsEITjmbcw=
X-Received: by 2002:a05:6808:230f:: with SMTP id
 bn15mr1262203oib.91.1643724857477; 
 Tue, 01 Feb 2022 06:14:17 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-2-reijiw@google.com>
 <CA+EHjTx+b0ZVw30riW4OUVP4BCPeJZe+gr5_ycHkPbwU=y7sqA@mail.gmail.com>
 <CAAeT=Fy8AXaM1SGs1wRssTZ9QW9bH-d1d_sCdSrC7EitZLPKBw@mail.gmail.com>
In-Reply-To: <CAAeT=Fy8AXaM1SGs1wRssTZ9QW9bH-d1d_sCdSrC7EitZLPKBw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 1 Feb 2022 14:13:41 +0000
Message-ID: <CA+EHjTwRiNpGq=i8LyuH4M3kCdTHFQKALXWNJcTZ+J5SQD87Wg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 01/26] KVM: arm64: Introduce a validation function
 for an ID register
To: Reiji Watanabe <reijiw@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

...

> > Could you please explain using ftr_temp[] and changing the value in
> > arm64_ftr_bits_kvm_override, rather than just
> > arm64_ftr_reg_bits_overrite(bits->ftr_bits, o_bits->ftr_bits)?
>
> I would like to maintain the order of the entries in the original
> ftr_bits so that (future) functions that work for the original ones
> also work for the KVM's.
> The copy and override is an easy way to do that.  The same thing can
> be done without ftr_temp[], but it would look a bit tricky.
>
> If we assume the order shouldn't matter or entries in ftr_bits
> are always in descending order, just changing the value in
> arm64_ftr_bits_kvm_override would be a much simpler way though.

Could you please add a comment in that case? I did find it to be
confusing until I read your explanation here.

>
> >
> >
> > > +static const struct arm64_ftr_bits *get_arm64_ftr_bits_kvm(u32 sys_id)
> > > +{
> > > +       const struct __ftr_reg_bits_entry *ret;
> > > +       int err;
> > > +
> > > +       if (!arm64_ftr_bits_kvm) {
> > > +               /* arm64_ftr_bits_kvm is not initialized yet. */
> > > +               err = init_arm64_ftr_bits_kvm();
> >
> > Rather than doing this check, can we just initialize it earlier, maybe
> > (indirectly) via kvm_arch_init_vm() or around the same time?
>
> Thank you for the comment.
> I will consider when it should be initialized.
> ( perhaps even earlier than kvm_arch_init_vm())
>
> >
> >
> > > +               if (err)
> > > +                       return NULL;
> > > +       }
> > > +
> > > +       ret = bsearch((const void *)(unsigned long)sys_id,
> > > +                     arm64_ftr_bits_kvm,
> > > +                     arm64_ftr_bits_kvm_nentries,
> > > +                     sizeof(arm64_ftr_bits_kvm[0]),
> > > +                     search_cmp_ftr_reg_bits);
> > > +       if (ret)
> > > +               return ret->ftr_bits;
> > > +
> > > +       return NULL;
> > > +}
> > > +
> > > +/*
> > > + * Check if features (or levels of features) that are indicated in the ID
> > > + * register value @val are also indicated in @limit.
> > > + * This function is for KVM to check if features that are indicated in @val,
> > > + * which will be used as the ID register value for its guest, are supported
> > > + * on the host.
> > > + * For AA64MMFR0_EL1.TGranX_2 fields, which don't follow the standard ID
> > > + * scheme, the function checks if values of the fields in @val are the same
> > > + * as the ones in @limit.
> > > + */
> > > +int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
> > > +{
> > > +       const struct arm64_ftr_bits *ftrp = get_arm64_ftr_bits_kvm(sys_reg);
> > > +       u64 exposed_mask = 0;
> > > +
> > > +       if (!ftrp)
> > > +               return -ENOENT;
> > > +
> > > +       for (; ftrp->width; ftrp++) {
> > > +               s64 ftr_val = arm64_ftr_value(ftrp, val);
> > > +               s64 ftr_lim = arm64_ftr_value(ftrp, limit);
> > > +
> > > +               exposed_mask |= arm64_ftr_mask(ftrp);
> > > +
> > > +               if (ftr_val == ftr_lim)
> > > +                       continue;
> >
> > At first I thought that this check isn't necessary, it should be
> > covered by the check below (arm64_ftr_safe_value. However, I think
> > that it's needed for the FTR_HIGHER_OR_ZERO_SAFE case. If my
> > understanding is correct, it might be worth adding a comment, or even
> > encapsulating this logic in a arm64_is_safe_value() function for
> > clarity.
>
> In my understanding, arm64_ftr_safe_value() provides a safe value
> when two values are different, and I think there is nothing special
> about the usage of this function (This is actually how the function
> is used by update_cpu_ftr_reg()).
> Without the check, it won't work for FTR_EXACT, but there might be
> more in the future.
>
> Perhaps it might be more straightforward to add the equality check
> into arm64_ftr_safe_value() ?

I don't think this would work for all callers of
arm64_ftr_safe_value(). The thing is arm64_ftr_safe_value() doesn't
check whether the value is safe, but it returns the safe value that
supports the highest feature. Whereas arm64_check_features() on the
other hand is trying to determine whether a value is safe.

If you move the equality check there it would work for
arm64_check_features(), but I am not convinced it wouldn't change the
behavior for init_cpu_ftr_reg() in the case of FTR_EXACT, unless this
never applies to override->val. What do you think?

Thanks,
/fuad


> >
> > > +
> > > +               if (ftr_val != arm64_ftr_safe_value(ftrp, ftr_val, ftr_lim))
> > > +                       return -E2BIG;
> > > +       }
> > > +
> > > +       /* Make sure that no unrecognized fields are set in @val. */
> > > +       if (val & ~exposed_mask)
> > > +               return -E2BIG;
> > > +
> > > +       return 0;
> > > +}
>
> Thanks,
> Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
