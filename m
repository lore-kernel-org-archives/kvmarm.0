Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBF8C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 31 Jan 2022 03:40:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A9B154B218;
	Sun, 30 Jan 2022 22:40:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id robQ95-SH1Fo; Sun, 30 Jan 2022 22:40:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AED74B129;
	Sun, 30 Jan 2022 22:40:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE6F54B11E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jan 2022 22:40:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HyIn8IVIi54I for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Jan 2022 22:40:31 -0500 (EST)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 981B74B11A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jan 2022 22:40:31 -0500 (EST)
Received: by mail-pf1-f176.google.com with SMTP id a19so5836194pfx.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Jan 2022 19:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=kKkdVczReHlJmEq2mHCzOlF2f9zOsI8Qlek1CLGRtXg=;
 b=gv2/52IHXhxJ9V+CpUkuE8dj13TXoUzbfqNmRA89Z8RxAggQ29fLbrg/TdohGYCGSN
 epfA+Wly5u0v1Nx+89fgyFvCuAxqUB1+uAfDYmOdC9BofPSGSqFqKnpQACBXfQlOKKsM
 +2eRoGjDdz7lRlO+Bp8JWFrK6/khewbv7ZCqyl2edW/X3iTiLFoAruAsFfZ3PcQNyH0Z
 wr9saZ31sYhvjT2tG2f/gMzb2jo+TJ2r82NuCxKfFVUv0uxjTV8Pjvml3lgYvje/3qjK
 VWrOQqtFQcpjE+Nei63rhSfgH9jC52UKbOzVjej4FYqNmJEGPiwpu7GUUfoHFjwjD0lQ
 S11A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=kKkdVczReHlJmEq2mHCzOlF2f9zOsI8Qlek1CLGRtXg=;
 b=pzdwMBk6xIzsUQWzfq51pBethDko6I409Qzfc03c8FWITp9kzo5kQNW0vmxHFcCU+F
 f2wG6HDrC5D/bYCZ+jYydBtH6+yuXUEysF7Q4beUS8Iql33SwYw9e10gHsRKywgRBQ18
 DP3KGKPf4daJ2tzQeDW/oV9FUSQomkFygMgMXRXsgWYfV7I3dpZnsS7bdqoYRVdHqSH4
 cvnAqZ+9uKY8S9t3j9o9+jsrOfxIQ61R3FAzOvJGQBJ2IVYtVzJakt6yMhREEWAElht7
 o2+EQrTh+EDDgEghExuPIxOd81GVUSRR2v7KbxsPXOqT5fIdJwXbRWPS9mOgh0CTsF9c
 jHkA==
X-Gm-Message-State: AOAM530zHhKMNH3bHG6IsEGnQ9RwcpuiO+oHUmFfzKW/svwvbN/tdBjV
 30BCMV+UypQTN78o2htxxHDeZQ==
X-Google-Smtp-Source: ABdhPJw80u0ql8gqDhxSKNzAHP5XbIa8eMWvNhJoZHnaH+q7E1P+ygb864/BAuMsFe+9AhCI1lRiGA==
X-Received: by 2002:a05:6a00:1a86:: with SMTP id
 e6mr18886798pfv.2.1643600430510; 
 Sun, 30 Jan 2022 19:40:30 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id y15sm16663120pfi.87.2022.01.30.19.40.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 30 Jan 2022 19:40:29 -0800 (PST)
Date: Sun, 30 Jan 2022 19:40:26 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
Message-ID: <YfdaKpBqFkULxgX/@google.com>
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com>
 <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
 <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
 <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
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

On Fri, Jan 28, 2022 at 09:52:21PM -0800, Reiji Watanabe wrote:
> Hi Ricardo,
> 
> > > > > +
> > > > > +/*
> > > > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > > > + * with ID_SANITISED() to the host's sanitized value.
> > > > > + */
> > > > > +void set_default_id_regs(struct kvm *kvm)
> > > > > +{
> > > > > +     int i;
> > > > > +     u32 id;
> > > > > +     const struct sys_reg_desc *rd;
> > > > > +     u64 val;
> > > > > +
> > > > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > > > +             rd = &sys_reg_descs[i];
> > > > > +             if (rd->access != access_id_reg)
> > > > > +                     /* Not ID register, or hidden/reserved ID register */
> > > > > +                     continue;
> > > > > +
> > > > > +             id = reg_to_encoding(rd);
> > > > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > > > +                     /* Shouldn't happen */
> > > > > +                     continue;
> > > > > +
> > > > > +             val = read_sanitised_ftr_reg(id);
> > > >
> > > > I'm a bit confused. Shouldn't the default+sanitized values already use
> > > > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
> > >
> > > I'm not sure if I understand your question.
> > > arm64_ftr_bits_kvm is used for feature support checkings when
> > > userspace tries to modify a value of ID registers.
> > > With this patch, KVM just saves the sanitized values in the kvm's
> > > buffer, but userspace is still not allowed to modify values of ID
> > > registers yet.
> > > I hope it answers your question.
> >
> > Based on the previous commit I was assuming that some registers, like
> > id_aa64dfr0,
> > would default to the overwritten values as the sanitized values. More
> > specifically: if
> > userspace doesn't modify any ID reg, shouldn't the defaults have the
> > KVM overwritten
> > values (arm64_ftr_bits_kvm)?
> 
> arm64_ftr_bits_kvm doesn't have arm64_ftr_reg but arm64_ftr_bits,
> and arm64_ftr_bits_kvm doesn't have the sanitized values.
> 
> Thanks,

Hey Reiji,

Sorry, I wasn't very clear. This is what I meant.

If I set DEBUGVER to 0x5 (w/ FTR_EXACT) using this patch on top of the
series:

 static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
        S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
-       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
+       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x5),

it means that userspace would not be able to set DEBUGVER to anything
but 0x5. But I'm not sure what it should mean for the default KVM value
of DEBUGVER, specifically the value calculated in set_default_id_regs().
As it is, KVM is still setting the guest-visible value to 0x6, and my
"desire" to only allow booting VMs with DEBUGVER=0x5 is being ignored: I
booted a VM and the DEBUGVER value from inside is still 0x6. I was
expecting it to not boot, or to show a warning.

I think this has some implications for migrations. It would not be
possible to migrate the example VM on the patched kernel from above: you
can boot a VM with DEBUGVER=0x5 but you can't migrate it.

Thanks,
Ricardo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
