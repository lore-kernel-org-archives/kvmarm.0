Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D789C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  4 Feb 2022 14:41:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E01940D0B;
	Fri,  4 Feb 2022 09:41:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5ugyHGNt5TUd; Fri,  4 Feb 2022 09:41:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9605641019;
	Fri,  4 Feb 2022 09:41:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CE3F40B6C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 09:41:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P2eA4Vswqs2P for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Feb 2022 09:41:41 -0500 (EST)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D9CC40AFA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 09:41:41 -0500 (EST)
Received: by mail-pl1-f178.google.com with SMTP id d1so5291400plh.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Feb 2022 06:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=dg20lHH+5hD5YQZ8GrVegKK1/VjQk9NXTtH1Zx4dOJI=;
 b=Q0O6T9mUzP6wJy9zhpgHJbkyvT10vvCO1wiEmaykAZR23D+4jFHhT8dkvhBY2lp6Yd
 kMAlLCr04o35/20X5iGzoiO9n672vtaUb9rr5gs7ZElqOxPpEopgPtaAV4GdDU0wlFkM
 ihj2/UrAuFCGA/jNATtlzzl4awHx2drn0ReV1ZGuXnq0zmG/iom8TvKZoVxVi9Yaczwz
 PqGPi/eTeQwWjqeu4gfbVMsnctKbwZebEDngDIYqtJIqDemnHoPipyI7iEyB1sZb7fEW
 C4FS6Pb653PwLX4O6Y6lQlO52zbpC8TddXFgxgGLdBQALrSUAWRawK6su8G/93ztDNzW
 BNxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=dg20lHH+5hD5YQZ8GrVegKK1/VjQk9NXTtH1Zx4dOJI=;
 b=3ko/WBsSkjt+Sz8cm2Qccx8TiriHkS+COSLjsd+/fYkNXQGxYQb+nfa5YOgI43+b0J
 bV7+YHLNGchtXf/y1uHzsbo6oJPU3JaRZgbYuHlyCPxdKVJb0jpz23TIFboy4gSCf0iB
 0QkwOy4S5hEde0IufmO8zC+k0g9ujJoV7tRfCU/8zEtjx7uEKHUwoCvkjoCo1E4VeN5v
 vkRzY+hsXoNoTXEzXk0WBp5Vyo2oq/ZhMV9H2RH45pmDAnTHSL6JUXIjFcfyWUieqbWx
 rAHChLoTst7ScW8gAD0o8fSzIFsoC+xJFOjLjmbYpYc09CLXN5XOukfCZFd6B2Fvnm2b
 e5Uw==
X-Gm-Message-State: AOAM533mgldrR6Kw3mFx4CYSzti8ZT86GH76FpRBYNT9bCFQe4t2TRH+
 7Srtp86QBgzWsN2bpjbEJRONvQ==
X-Google-Smtp-Source: ABdhPJxuZ3MRzFW5Hq5CFl1LOZ2xYN55KrXKqNYxi4zn6Kz1Gif+qEnOXKdqDWkXy6BdB1YNpaeU3Q==
X-Received: by 2002:a17:902:d702:: with SMTP id
 w2mr3264277ply.17.1643985697349; 
 Fri, 04 Feb 2022 06:41:37 -0800 (PST)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id h25sm2634724pfn.208.2022.02.04.06.41.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 04 Feb 2022 06:41:36 -0800 (PST)
Date: Fri, 4 Feb 2022 06:41:32 -0800
From: Ricardo Koller <ricarkol@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH v4 02/26] KVM: arm64: Save ID registers' sanitized
 value per guest
Message-ID: <Yf07HATXyDDeE68t@google.com>
References: <20220106042708.2869332-1-reijiw@google.com>
 <20220106042708.2869332-3-reijiw@google.com>
 <YfDaiUbSkpi9/5YY@google.com>
 <CAAeT=FzNSvzz-Ok0Ka95=kkdDGsAMmzf9xiRfD5gYCdvmEfifg@mail.gmail.com>
 <CAOHnOrwBoQncTPngxqWgD_mEDWT6AwcmB_QC=j-eUPY2fwHa2Q@mail.gmail.com>
 <CAAeT=FyqPX_XQ+LDuRBZhApeiWD4s81bTMe=qiKDOZkBWm5ARg@mail.gmail.com>
 <YfdaKpBqFkULxgX/@google.com>
 <CAAeT=Fw7Fr2=sWyMZ85Ky-rhQJ3WQTa8fE8tNDHinwFYm3ksBQ@mail.gmail.com>
 <Yfl+Pz4MWOyEHfhf@google.com>
 <CAAeT=Fx3oBoyUmJjyMWmeyzMJJxcAZAYWDQuv4DUqZztm8ooKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAeT=Fx3oBoyUmJjyMWmeyzMJJxcAZAYWDQuv4DUqZztm8ooKQ@mail.gmail.com>
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

On Wed, Feb 02, 2022 at 10:31:26PM -0800, Reiji Watanabe wrote:
> Hi Ricardo,
> 
> On Tue, Feb 1, 2022 at 10:39 AM Ricardo Koller <ricarkol@google.com> wrote:
> >
> > Hey Reiji,
> >
> > On Mon, Jan 31, 2022 at 10:00:40PM -0800, Reiji Watanabe wrote:
> > > Hi Ricardo,
> > >
> > > On Sun, Jan 30, 2022 at 7:40 PM Ricardo Koller <ricarkol@google.com> wrote:
> > > >
> > > > On Fri, Jan 28, 2022 at 09:52:21PM -0800, Reiji Watanabe wrote:
> > > > > Hi Ricardo,
> > > > >
> > > > > > > > > +
> > > > > > > > > +/*
> > > > > > > > > + * Set the guest's ID registers that are defined in sys_reg_descs[]
> > > > > > > > > + * with ID_SANITISED() to the host's sanitized value.
> > > > > > > > > + */
> > > > > > > > > +void set_default_id_regs(struct kvm *kvm)
> > > > > > > > > +{
> > > > > > > > > +     int i;
> > > > > > > > > +     u32 id;
> > > > > > > > > +     const struct sys_reg_desc *rd;
> > > > > > > > > +     u64 val;
> > > > > > > > > +
> > > > > > > > > +     for (i = 0; i < ARRAY_SIZE(sys_reg_descs); i++) {
> > > > > > > > > +             rd = &sys_reg_descs[i];
> > > > > > > > > +             if (rd->access != access_id_reg)
> > > > > > > > > +                     /* Not ID register, or hidden/reserved ID register */
> > > > > > > > > +                     continue;
> > > > > > > > > +
> > > > > > > > > +             id = reg_to_encoding(rd);
> > > > > > > > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > > > > > > > +                     /* Shouldn't happen */
> > > > > > > > > +                     continue;
> > > > > > > > > +
> > > > > > > > > +             val = read_sanitised_ftr_reg(id);
> > > > > > > >
> > > > > > > > I'm a bit confused. Shouldn't the default+sanitized values already use
> > > > > > > > arm64_ftr_bits_kvm (instead of arm64_ftr_regs)?
> > > > > > >
> > > > > > > I'm not sure if I understand your question.
> > > > > > > arm64_ftr_bits_kvm is used for feature support checkings when
> > > > > > > userspace tries to modify a value of ID registers.
> > > > > > > With this patch, KVM just saves the sanitized values in the kvm's
> > > > > > > buffer, but userspace is still not allowed to modify values of ID
> > > > > > > registers yet.
> > > > > > > I hope it answers your question.
> > > > > >
> > > > > > Based on the previous commit I was assuming that some registers, like
> > > > > > id_aa64dfr0,
> > > > > > would default to the overwritten values as the sanitized values. More
> > > > > > specifically: if
> > > > > > userspace doesn't modify any ID reg, shouldn't the defaults have the
> > > > > > KVM overwritten
> > > > > > values (arm64_ftr_bits_kvm)?
> > > > >
> > > > > arm64_ftr_bits_kvm doesn't have arm64_ftr_reg but arm64_ftr_bits,
> > > > > and arm64_ftr_bits_kvm doesn't have the sanitized values.
> > > > >
> > > > > Thanks,
> > > >
> > > > Hey Reiji,
> > > >
> > > > Sorry, I wasn't very clear. This is what I meant.
> > > >
> > > > If I set DEBUGVER to 0x5 (w/ FTR_EXACT) using this patch on top of the
> > > > series:
> > > >
> > > >  static struct arm64_ftr_bits ftr_id_aa64dfr0_kvm[MAX_FTR_BITS_LEN] = {
> > > >         S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR0_PMUVER_SHIFT, 4, 0),
> > > > -       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x6),
> > > > +       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64DFR0_DEBUGVER_SHIFT, 4, 0x5),
> > > >
> > > > it means that userspace would not be able to set DEBUGVER to anything
> > > > but 0x5. But I'm not sure what it should mean for the default KVM value
> > > > of DEBUGVER, specifically the value calculated in set_default_id_regs().
> > > > As it is, KVM is still setting the guest-visible value to 0x6, and my
> > > > "desire" to only allow booting VMs with DEBUGVER=0x5 is being ignored: I
> > > > booted a VM and the DEBUGVER value from inside is still 0x6. I was
> > > > expecting it to not boot, or to show a warning.
> > >
> > > Thank you for the explanation!
> > >
> > > FTR_EXACT (in the existing code) means that the safe_val should be
> > > used if values of the field are not identical between CPUs (see how
> > > update_cpu_ftr_reg() uses arm64_ftr_safe_value()). For KVM usage,
> > > it means that if the field value for a vCPU is different from the one
> > > for the host's sanitized value, only the safe_val can be used safely
> > > for the guest (purely in terms of CPU feature).
> >
> > Let me double check my understanding using the DEBUGVER example, please.
> > The safe_value would be DEBUGVER=5, and it contradicts the initial VM
> > value calculated on the KVM side. Q1: Can a contradiction like this
> > occur in practice? Q2: If the user saves and restores this id-reg on the
> > same kernel, the AA64DFR0 userspace write would fail (ftr_val !=
> > arm64_ftr_safe_value), right?
> 
> Thank you for the comment!
> 
> For Q1, yes, we might possibly create a bug that makes a contradiction
> between KVM and cpufeature.c.
> For Q2, even with such a contradiction, userspace will still be able to
> save and restore the id reg on the same kernel on the same system in most
> cases because @limit that KVM will specify for arm64_check_features()
> will mostly be the same as the initial value for the guest (except for
> fields corresponding to opt-in CPU features, which are configured with
> KVM_ARM_VCPU_INIT or etc) and arm64_check_features does an equality check
> per field.  Having said that, as you suggested, it might be better to run
> arm64_check_features for the initial value against the host value so we
> can catch such a bug. I'll look into doing that in v5.
> 

Thanks Reiji. Looking forward to v5.

> Thanks,
> Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
