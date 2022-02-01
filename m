Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96AD6C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 06:01:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CADB840E64;
	Tue,  1 Feb 2022 01:01:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4iMiWFdLCQDD; Tue,  1 Feb 2022 01:01:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FC2940BCF;
	Tue,  1 Feb 2022 01:01:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 53D0040BCF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 01:00:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G8qp0boUV916 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 01:00:58 -0500 (EST)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E50E940BAF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 01:00:57 -0500 (EST)
Received: by mail-pf1-f180.google.com with SMTP id e6so14916882pfc.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jan 2022 22:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Rj5HQhQyptq1prqqLiR0JYrAw/J6DdBaPhsGSRewuxA=;
 b=O2IqdcrI8j0Fqi0KLhNgLfYvcMZ+S5gfnYs5VGOXc+eq31DvL1WRmHgOcbuf3PNREL
 P6AZcPXN5ToMiFIcW6coJ7bhgKkYcUlVqxfDvGRyZo3aTU5AwV9eWsHLbUKVMUP12oyE
 sa+Iue/3E32CRtHwt5vVuAGaGg8JLCtk69eABQICMWUF2f5mVN6QMObTbPmPdd3u7wlH
 3O3W+bgX/B/R71yMf6doM+Ycw4bFIjy0jbZBgZl+oBW79vO2+3r2Eg1RcyI/ZohXHb4p
 LrmULTQvqy2unNtfUCmIQwwrOsi04Uv5uwi/vHFROe6v/+11rAdmK+TIs8Vtyie4n5mf
 LFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Rj5HQhQyptq1prqqLiR0JYrAw/J6DdBaPhsGSRewuxA=;
 b=JC2XJFZrqeZ/3W3qWUEiczwN4RUmOhkVB24nEYAbEip/NUYoF8SDWC4yKTbe9uh3le
 o7bw8WKrgHt6Qw4cePAd9+s4tuPIQK5E4to5lcM5LuSwX99TtyJh/4c6A3F+T54itCW7
 xxW/981xIwxyoe/8Th+c4FY0KvqIuiwCDRE35g1+N2ZFJ584IpYPO3eyMNbg4N7CBYBz
 laGbWfdyFM7IqnQjpNOLPyIr36rGTbz1q4wYRc9eh3mq4760twhtJra316kQds6dSVbm
 W+B2z5jGkYzRi19Rv4Kx8Y3e+hn5Zy4vLx/BCEhj9yVIgUoiNb7sEiMqrDXMvmjXkPBS
 lvLQ==
X-Gm-Message-State: AOAM53343lNvRHIn+q1TYOROpd9XdST0rM1LXU988O7kV0QojZAdhezr
 sudEf8kzlf6tt8tOy3TPlXrCpg/WdSXboKinbZ7Rcg==
X-Google-Smtp-Source: ABdhPJx45aOEpU8XeKqNCF1T0wz5+DGu/Vk0J6PTyadiSbYSNQNorBZhyf+hidGFrdlNDTX4Oly9AlOgikkUK7Nr0OE=
X-Received: by 2002:aa7:95b2:: with SMTP id a18mr23381629pfk.39.1643695256681; 
 Mon, 31 Jan 2022 22:00:56 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com>
 <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
 <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
 <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
 <YfdaKpBqFkULxgX/@google.com>
In-Reply-To: <YfdaKpBqFkULxgX/@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 31 Jan 2022 22:00:40 -0800
Message-ID: <CAAeT=Fw7Fr2=sWyMZ85Ky-rhQJ3WQTa8fE8tNDHinwFYm3ksBQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
To: Ricardo Koller <ricarkol@google.com>
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

Hi Ricardo,

On Sun, Jan 30, 2022 at 7:40 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Fri, Jan 28, 2022 at 09:52:21PM -0800, Reiji Watanabe wrote:
> > Hi Ricardo,
> >
> > > > > > +
> > > > > > +/*
> > > > > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > > > > + * with ID_SANITISED() to the host's sanitized value.
> > > > > > + */
> > > > > > +void set_default_id_regs(struct kvm *kvm)
> > > > > > +{
> > > > > > +     int i;
> > > > > > +     u32 id;
> > > > > > +     const struct sys_reg_desc *rd;
> > > > > > +     u64 val;
> > > > > > +
> > > > > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > > > > +             rd = &sys_reg_descs[i];
> > > > > > +             if (rd->access != access_id_reg)
> > > > > > +                     /* Not ID register, or hidden/reserved ID register */
> > > > > > +                     continue;
> > > > > > +
> > > > > > +             id = reg_to_encoding(rd);
> > > > > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > > > > +                     /* Shouldn't happen */
> > > > > > +                     continue;
> > > > > > +
> > > > > > +             val = read_sanitised_ftr_reg(id);
> > > > >
> > > > > I'm a bit confused. Shouldn't the default+sanitized values already use
> > > > > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
> > > >
> > > > I'm not sure if I understand your question.
> > > > arm64_ftr_bits_kvm is used for feature support checkings when
> > > > userspace tries to modify a value of ID registers.
> > > > With this patch, KVM just saves the sanitized values in the kvm's
> > > > buffer, but userspace is still not allowed to modify values of ID
> > > > registers yet.
> > > > I hope it answers your question.
> > >
> > > Based on the previous commit I was assuming that some registers, like
> > > id_aa64dfr0,
> > > would default to the overwritten values as the sanitized values. More
> > > specifically: if
> > > userspace doesn't modify any ID reg, shouldn't the defaults have the
> > > KVM overwritten
> > > values (arm64_ftr_bits_kvm)?
> >
> > arm64_ftr_bits_kvm doesn't have arm64_ftr_reg but arm64_ftr_bits,
> > and arm64_ftr_bits_kvm doesn't have the sanitized values.
> >
> > Thanks,
>
> Hey Reiji,
>
> Sorry, I wasn't very clear. This is what I meant.
>
> If I set DEBUGVER to 0x5 (w/ FTR_EXACT) using this patch on top of the
> series:
>
>  static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
>         S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
> -       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
> +       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x5),
>
> it means that userspace would not be able to set DEBUGVER to anything
> but 0x5. But I'm not sure what it should mean for the default KVM value
> of DEBUGVER, specifically the value calculated in set_default_id_regs().
> As it is, KVM is still setting the guest-visible value to 0x6, and my
> "desire" to only allow booting VMs with DEBUGVER=0x5 is being ignored: I
> booted a VM and the DEBUGVER value from inside is still 0x6. I was
> expecting it to not boot, or to show a warning.

Thank you for the explanation!

FTR_EXACT (in the existing code) means that the safe_val should be
used if values of the field are not identical between CPUs (see how
update_cpu_ftr_reg() uses arm64_ftr_safe_value()). For KVM usage,
it means that if the field value for a vCPU is different from the one
for the host's sanitized value, only the safe_val can be used safely
for the guest (purely in terms of CPU feature).

If KVM wants to restrict some features due to some reasons (e.g.
a feature for guests is not supported by the KVM yet), it should
be done by KVM (not by cpufeature.c), and  'validate' function in
"struct id_reg_info", which is introduced in patch-3, will be used
for such cases (the following patches actually use).

Thanks,
Reiji

>
> I think this has some implications for migrations. It would not be
> possible to migrate the example VM on the patched kernel from above: you
> can boot a VM with DEBUGVER=0x5 but you can't migrate it.
>
> Thanks,
> Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
