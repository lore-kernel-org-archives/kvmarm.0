Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC89C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  2 Feb 2022 06:46:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B500B49F21;
	Wed,  2 Feb 2022 01:46:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ut37V9eoofSS; Wed,  2 Feb 2022 01:46:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61FD349F28;
	Wed,  2 Feb 2022 01:46:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 996A349F21
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Feb 2022 01:46:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gFycruo0irvg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Feb 2022 01:46:32 -0500 (EST)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BF1B49F05
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Feb 2022 01:46:32 -0500 (EST)
Received: by mail-pj1-f49.google.com with SMTP id
 z14-20020a17090ab10e00b001b6175d4040so5927406pjq.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Feb 2022 22:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=n4I2R/hpf5Fa4L81XJ6bvxceN9VV7gkH/UQIc45psZ4=;
 b=tIMuSrNzRH+KWp61Vo/OMMvaDkFTGOZvrsS0v4SKqfShDl+PQ3OrxwXGO10cig7KH0
 brcJBL/bKE0lhbtp/HBpjl8yUDAZIr+3+OAp3aHtGlVyz8pl2ZDkN2dD93zpt/5KHz02
 0E/PovCbpnSEtik2Y/iWeVjuCFFXvfJs8Vwshd3VGIeFzjV1j3CLTqG67f4uqtl0i2ka
 ifuPeeci4ApuXeShICr+eGBiR+8gyLw5sre/ZFpDIg5UlGuKCxhjyTzyD36/s2RrvTX3
 LuNCPHae9QrMzdR+0IJY5XUrXrrXz70jc5K8PUm3ajXy5lZj7CEpMJ+5hqPJptRHP17l
 4N7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=n4I2R/hpf5Fa4L81XJ6bvxceN9VV7gkH/UQIc45psZ4=;
 b=NWYXYbouWxeida1sYKfsYRQG8c5IGCQo3fOdYAljLPRrHmdKDHLziUH9TnSYdgobqy
 OVjRgy43Z19MTNjM+GFsBjepEIKzk/Ix69KSKfEzPmzy7vpHudlJE60uE/3qWZYedFo1
 QQaUfJ5ym9gi9lwkKjtC2ma4cNbreW9m1PpLmNvQNfJFq1rSp59agWwhVOU18qOMiUEz
 2FuigGm70Ai9LTsL0qihFxlqtxQ18dzgzLHI0Nn/jGMFLHtJoMggnUM3NqciPBU7ub+d
 YH/+Sy02vrmLQZHXlITpqmCH/TpP5pTNgcvrQVe8VimiHXNmp2M7ZlPapOWWcnu4RNRB
 1how==
X-Gm-Message-State: AOAM530GhJvTbRzbvNPX6LvGWD1bCWFaE8FN9M/EQWNfcZHFZpnLKsBV
 QtS0JTIqxyL1ca9ukzo4dpPhvNWLXqDwR2tKmMbBRA==
X-Google-Smtp-Source: ABdhPJxoAC726UM4u8e1ITpNdSeFTzBmsKFwQ8RsnfrQGMs41DYzrOEDXws/ljWMGL4oA33Cq0yVqGM2HhAprUNIMQw=
X-Received: by 2002:a17:902:b684:: with SMTP id
 c4mr1249326pls.122.1643784391037; 
 Tue, 01 Feb 2022 22:46:31 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-2-reijiw@google.com>
 <CA+EHjTx+b0ZVw30riW4OUVP4BCPeJZe+gr5_ycHkPbwU=y7sqA@mail.gmail.com>
 <CAAeT=Fy8AXaM1SGs1wRssTZ9QW9bH-d1d_sCdSrC7EitZLPKBw@mail.gmail.com>
 <CA+EHjTwRiNpGq=i8LyuH4M3kCdTHFQKALXWNJcTZ+J5SQD87Wg@mail.gmail.com>
In-Reply-To: <CA+EHjTwRiNpGq=i8LyuH4M3kCdTHFQKALXWNJcTZ+J5SQD87Wg@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 1 Feb 2022 22:46:14 -0800
Message-ID: <CAAeT=FzDVbLsCdshTP+jszn_E_CqK3fN0V5bXeozf98abCdTZg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 01/26] KVM: arm64: Introduce a validation function
 for an ID register
To: Fuad Tabba <tabba@google.com>
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

Hi Fuad,

On Tue, Feb 1, 2022 at 6:14 AM Fuad Tabba <tabba@google.com> wrote:
>
> Hi Reiji,
>
> ...
>
> > > Could you please explain using ftr_temp[] and changing the value in
> > > arm64_ftr_bits_kvm_override, rather than just
> > > arm64_ftr_reg_bits_overrite(bits->ftr_bits, o_bits->ftr_bits)?
> >
> > I would like to maintain the order of the entries in the original
> > ftr_bits so that (future) functions that work for the original ones
> > also work for the KVM's.
> > The copy and override is an easy way to do that.  The same thing can
> > be done without ftr_temp[], but it would look a bit tricky.
> >
> > If we assume the order shouldn't matter or entries in ftr_bits
> > are always in descending order, just changing the value in
> > arm64_ftr_bits_kvm_override would be a much simpler way though.
>
> Could you please add a comment in that case? I did find it to be
> confusing until I read your explanation here.

Yes, I will add a comment for it.

>
> >
> > >
> > >
> > > > +static const struct arm64_ftr_bits *get_arm64_ftr_bits_kvm(u32 sys_id)
> > > > +{
> > > > +       const struct __ftr_reg_bits_entry *ret;
> > > > +       int err;
> > > > +
> > > > +       if (!arm64_ftr_bits_kvm) {
> > > > +               /* arm64_ftr_bits_kvm is not initialized yet. */
> > > > +               err = init_arm64_ftr_bits_kvm();
> > >
> > > Rather than doing this check, can we just initialize it earlier, maybe
> > > (indirectly) via kvm_arch_init_vm() or around the same time?
> >
> > Thank you for the comment.
> > I will consider when it should be initialized.
> > ( perhaps even earlier than kvm_arch_init_vm())
> >
> > >
> > >
> > > > +               if (err)
> > > > +                       return NULL;
> > > > +       }
> > > > +
> > > > +       ret = bsearch((const void *)(unsigned long)sys_id,
> > > > +                     arm64_ftr_bits_kvm,
> > > > +                     arm64_ftr_bits_kvm_nentries,
> > > > +                     sizeof(arm64_ftr_bits_kvm[0]),
> > > > +                     search_cmp_ftr_reg_bits);
> > > > +       if (ret)
> > > > +               return ret->ftr_bits;
> > > > +
> > > > +       return NULL;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Check if features (or levels of features) that are indicated in the ID
> > > > + * register value @val are also indicated in @limit.
> > > > + * This function is for KVM to check if features that are indicated in @val,
> > > > + * which will be used as the ID register value for its guest, are supported
> > > > + * on the host.
> > > > + * For AA64MMFR0_EL1.TGranX_2 fields, which don't follow the standard ID
> > > > + * scheme, the function checks if values of the fields in @val are the same
> > > > + * as the ones in @limit.
> > > > + */
> > > > +int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
> > > > +{
> > > > +       const struct arm64_ftr_bits *ftrp = get_arm64_ftr_bits_kvm(sys_reg);
> > > > +       u64 exposed_mask = 0;
> > > > +
> > > > +       if (!ftrp)
> > > > +               return -ENOENT;
> > > > +
> > > > +       for (; ftrp->width; ftrp++) {
> > > > +               s64 ftr_val = arm64_ftr_value(ftrp, val);
> > > > +               s64 ftr_lim = arm64_ftr_value(ftrp, limit);
> > > > +
> > > > +               exposed_mask |= arm64_ftr_mask(ftrp);
> > > > +
> > > > +               if (ftr_val == ftr_lim)
> > > > +                       continue;
> > >
> > > At first I thought that this check isn't necessary, it should be
> > > covered by the check below (arm64_ftr_safe_value. However, I think
> > > that it's needed for the FTR_HIGHER_OR_ZERO_SAFE case. If my
> > > understanding is correct, it might be worth adding a comment, or even
> > > encapsulating this logic in a arm64_is_safe_value() function for
> > > clarity.
> >
> > In my understanding, arm64_ftr_safe_value() provides a safe value
> > when two values are different, and I think there is nothing special
> > about the usage of this function (This is actually how the function
> > is used by update_cpu_ftr_reg()).
> > Without the check, it won't work for FTR_EXACT, but there might be
> > more in the future.
> >
> > Perhaps it might be more straightforward to add the equality check
> > into arm64_ftr_safe_value() ?
>
> I don't think this would work for all callers of
> arm64_ftr_safe_value(). The thing is arm64_ftr_safe_value() doesn't
> check whether the value is safe, but it returns the safe value that
> supports the highest feature. Whereas arm64_check_features() on the
> other hand is trying to determine whether a value is safe.
>
> If you move the equality check there it would work for
> arm64_check_features(), but I am not convinced it wouldn't change the
> behavior for init_cpu_ftr_reg() in the case of FTR_EXACT, unless this
> never applies to override->val. What do you think?

The equality check (simply returns the new value if new == cur) could
change a return value of arm64_ftr_safe_value only if ftr_ovr == ftr_new
for FTR_EXACT case.  For init_cpu_ftr_reg, since ftr_ovr value doesn't
matter if ftr_ovr == ftr_new, I would think the override behavior itself
stays the same although the message that will be printed by
init_cpu_ftr_reg() will change ("ignoring override" => "already set").

Having said that, since the change (having arm64_ftr_safe_value does
the equality check) isn't necessary, either way is fine, and
I can keep the current implementation of arm64_ftr_safe_value().

Thanks,
Reiji


>
> Thanks,
> /fuad
>
>
> > >
> > > > +
> > > > +               if (ftr_val != arm64_ftr_safe_value(ftrp, ftr_val, ftr_lim))
> > > > +                       return -E2BIG;
> > > > +       }
> > > > +
> > > > +       /* Make sure that no unrecognized fields are set in @val. */
> > > > +       if (val & ~exposed_mask)
> > > > +               return -E2BIG;
> > > > +
> > > > +       return 0;
> > > > +}
> >
> > Thanks,
> > Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
