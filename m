Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962ADC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 05:40:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04FAC4B150;
	Tue, 30 Nov 2021 00:40:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bYxlvyN3H4iR; Tue, 30 Nov 2021 00:40:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6AA094B1A3;
	Tue, 30 Nov 2021 00:40:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 980A84B1F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 00:40:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YI78OoZs6B10 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Nov 2021 00:40:00 -0500 (EST)
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com
 [209.85.210.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 70F6F4B1F5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 00:40:00 -0500 (EST)
Received: by mail-pf1-f175.google.com with SMTP id x131so19386148pfc.12
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 21:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=2O/hiQ03MFaYbbx3qyaBx+GPTTjxo7NbQIxhjjvNI2w=;
 b=FJaoREo5lr4D3hO1iEHEr3xWdnD0wwrtf7Ef1X1rSs8S4PWjhTbbX6jnw6DBltbsJX
 6i9Ywnw7JCOsnCL/UwEWjqp17HJkt4EzbZTxyBxuoWJG8/Of+n/SqA6za6RkHdE6SASr
 t6wu10M8KcnN+UXjYsY9yGCelVtKnbGPoQhZ/rPLX3b85pSxj+RB3R/kmxfVxxpG54+m
 FjTcQGEc9YCx64+fwylV3ylCk+0ERgSyEiXZ87vXZfSFh7ajfHECA38JLabu1lYOUZ4J
 1ktEAlEFRS5l1KibAPtXqfVpQMMEVdyQZjAA9POS4cKpRUN4R8mV+hoW2fGgdNxpid+B
 KG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=2O/hiQ03MFaYbbx3qyaBx+GPTTjxo7NbQIxhjjvNI2w=;
 b=m7XoICpU9jp2NFofCxQ+xX5akuY67vAYqORS0P04/EtnO2X0Id7/oUmsZ9KIcoHh9E
 p0Rkerul8V8ahof/NCDiMmGlwbIJCpwpP5/1yKiTE9nCTHmBSAnUhWD7yjkz8RRcFt7P
 tHDHHR/6wNUR2HMFmdcPuo1Bqt60MR+fLHsi4PYT3G79txmR8AKxSF4nnzvFal2r2Y+U
 /QE51ilELjOj3SoMUvBwQPkpptBIvETaZj2KMXtwNtDR0NS9HuhPDUZyV1PLTXUWQpBO
 LBhBPRT/24jSxyUOaQuEDNzCNpBcUToEkPEnx59QXgYFChP45yA8NY1/ALZBvn3GPAPy
 8n/Q==
X-Gm-Message-State: AOAM533DWNwCqQMX3GPLCQV/6HCPxdqDl8ZYjtowRJ81djGRG/3kbow/
 kFWaB0UgD8J9rhqsbzdng9qR4GmpdKW4RduJxKUz8A==
X-Google-Smtp-Source: ABdhPJzYoUPHGrIYMegTjTSSCO7W+6mHt9oLHSQoSM1blfLYXTNnPxnKfkEzBg1Vu3CUu/4qR3k0I2UA4fV59wak9oI=
X-Received: by 2002:a63:82c6:: with SMTP id
 w189mr26026217pgd.491.1638250799398; 
 Mon, 29 Nov 2021 21:39:59 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-13-reijiw@google.com>
 <44073484-639e-3d23-2068-ae5c2cac3276@redhat.com>
In-Reply-To: <44073484-639e-3d23-2068-ae5c2cac3276@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Mon, 29 Nov 2021 21:39:43 -0800
Message-ID: <CAAeT=FyBaKvof6BpPB021MN6k797BcMP+sPMDeiZ9SR6nvXdCA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 12/29] KVM: arm64: Make ID_DFR1_EL1 writable
To: Eric Auger <eauger@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Eric,

On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > This patch adds id_reg_info for ID_DFR1_EL1 to make it writable
> > by userspace.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index fbd335ac5e6b..dda7001959f6 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -859,6 +859,11 @@ static struct id_reg_info id_dfr0_el1_info = {
> >       .get_reset_val = get_reset_id_dfr0_el1,
> >  };
> >
> > +static struct id_reg_info id_dfr1_el1_info = {
> > +     .sys_reg = SYS_ID_DFR1_EL1,
> > +     .ftr_check_types = S_FCT(ID_DFR1_MTPMU_SHIFT, FCT_LOWER_SAFE),
> what about the 0xF value which indicates the MTPMU is not implemented?

The field is treated as a signed field.
So, 0xf(== -1) is handled correctly.
(Does it answer your question?)

Thanks,
Reiji

>
> Eric
> > +};
> > +
> >  /*
> >   * An ID register that needs special handling to control the value for the
> >   * guest must have its own id_reg_info in id_reg_info_table.
> > @@ -869,6 +874,7 @@ static struct id_reg_info id_dfr0_el1_info = {
> >  #define      GET_ID_REG_INFO(id)     (id_reg_info_table[IDREG_IDX(id)])
> >  static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
> >       [IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
> > +     [IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
> >       [IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
> >       [IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
> >       [IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
