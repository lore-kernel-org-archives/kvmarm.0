Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A624DC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Feb 2022 17:38:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E23FE4B119;
	Thu,  3 Feb 2022 12:38:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6PlStPFpi7eF; Thu,  3 Feb 2022 12:38:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 691A94B103;
	Thu,  3 Feb 2022 12:38:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C9B954B0B9
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:38:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bJlyZPj5x8Qm for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Feb 2022 12:38:00 -0500 (EST)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com
 [209.85.208.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B21E94A11C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Feb 2022 12:38:00 -0500 (EST)
Received: by mail-lj1-f173.google.com with SMTP id q22so4948130ljh.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Feb 2022 09:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=6t1NMzP4e8n3FBQ7Ilq4G/oflmuQi4zeKyZmWebLgWI=;
 b=hda7WI8uFTics5pmFrHWD1sVsLUEkG5a0ilo+bECArSPgaAQHFDVKPblloMUejv90E
 hahtFEpw1bvYpIbBbDGPE1TFLHWQALzW9cCU++8eL+eVIB05b8wFlPprTh/WDDiJ1jRC
 HHeMr/iZYmL95DDyzJ9mWtu9+nw1U1k841MEt3vthKfAROrToVmh4B50qco28SiVYejc
 3zC1W6a3Fq39M6kW9CHohpFG0rjYENzWe1zHw+e93KuE2VX1A0adL1r3uYiAwdn7LXty
 IT9Xdqt7y/pkYdt4q5FiAKefaTnOajvxQjjRLavffOE+2W0/jEHcTwZUOmgS5GGJcmTp
 emjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=6t1NMzP4e8n3FBQ7Ilq4G/oflmuQi4zeKyZmWebLgWI=;
 b=0BN8yiv9jK/n9M3oMZhSoYRnOxURQfn8iIsUoWBAkHmvnRjDg/bj45WYfENk2nz225
 9wyrB1BRVZBOgAmVjvQi/fajLzuGEhgx59zqNaPUM3u4kJgKx1+9iSZlN19mwyP7wQN7
 3P4nlkTfmxL5HhA3jATiMK3zcaVcXOXeZrg953yuuFRzj6bl91ji8Ocnqpa9T5DWK83+
 s2yEcS+FYXVCvE3BWeCd13XvdXded7Q5hkN6yGDTzjyh2dAFTE0F33/wcDw2cZcNxxzh
 oVxnKO8kvdA6sfwYjYfRjWCOQAtA/HryFIpgMeMCogGlNrJAkIyON1cDiXQZ4xBzSGY1
 Hr/g==
X-Gm-Message-State: AOAM532/RwhspV8iiGd0pK4CLRd36movfobERzjYHB9AcuRZC0f9/VNe
 W/J+GjJTtBcstXgEOph3gY1wgDTIcHVBtkaw7TVa/A==
X-Google-Smtp-Source: ABdhPJx0I/4I6/U1UG73AltPWLQkpDwtns8xeurO6OUxlLlusAin2rvTO+b1teWE6T2TXJWIO3Fg/uP2LzH/HiTDSgg=
X-Received: by 2002:a2e:b449:: with SMTP id o9mr22832976ljm.140.1643909879114; 
 Thu, 03 Feb 2022 09:37:59 -0800 (PST)
MIME-Version: 1.0
References: <20211214172812.2894560-1-oupton@google.com>
 <20211214172812.2894560-4-oupton@google.com>
 <YbncTRH4TnVvRVxB@FVFF77S0Q05N>
In-Reply-To: <YbncTRH4TnVvRVxB@FVFF77S0Q05N>
From: Oliver Upton <oupton@google.com>
Date: Thu, 3 Feb 2022 09:37:48 -0800
Message-ID: <CAOQ_QsjppDFzy8-kN_wkGXB6fn0j4svfx=K265v-bit5uPeJTQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Allow guest to set the OSLK bit
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

Hi Mark,

Sorry for the delay on my end..

On Wed, Dec 15, 2021 at 4:15 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > +static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
> > +                        struct sys_reg_params *p,
> > +                        const struct sys_reg_desc *r)
> > +{
> > +     u64 oslsr;
> > +
> > +     if (!p->is_write)
> > +             return read_from_write_only(vcpu, p, r);
> > +
> > +     /* Forward the OSLK bit to OSLSR */
> > +     oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
> > +     if (p->regval & SYS_OSLAR_OSLK)
> > +             oslsr |= SYS_OSLSR_OSLK;
> > +
> > +     __vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
> > +     return true;
> > +}
>
> Does changing this affect existing userspace? Previosuly it could read
> OSLAR_EL1 as 0, whereas now that should be rejected.
>
> That might be fine, and if so, it would be good to call that out in the commit
> message.

I do not believe we expose OSLAR_EL1 to userspace. Attempts to read it
return -ENOENT. The access will go through get_invariant_sys_reg(),
which cannot find a corresponding entry in the invariant_sys_regs
array.

[...]

> > @@ -309,9 +331,14 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> >       if (err)
> >               return err;
> >
> > -     if (val != rd->val)
> > +     /*
> > +      * The only modifiable bit is the OSLK bit. Refuse the write if
> > +      * userspace attempts to change any other bit in the register.
> > +      */
> > +     if ((val & ~SYS_OSLSR_OSLK) != SYS_OSLSR_OSLM)
> >               return -EINVAL;
>
> How about:
>
>         if ((val ^ rd->val) & ~SYS_OSLSR_OSLK)
>                 return -EINVAL;
>
> ... so that we don't need to hard-code the expected value here, and can more
> easily change it in future?

Nice and clean. Thanks!

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
