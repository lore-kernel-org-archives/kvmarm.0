Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D082C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 14:30:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EDFE660FED
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 14:30:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EDFE660FED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68A3C4B28D;
	Mon, 18 Oct 2021 10:30:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KbYLCdrP-noP; Mon, 18 Oct 2021 10:30:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C2AD4B1B6;
	Mon, 18 Oct 2021 10:30:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D3EA4B1B6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 10:30:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4LLEkKqh3suP for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 10:30:46 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20B564B1B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 10:30:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1634567445;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=16lgWy6r2ijeFvmyYBWNBFj6OUleKDb2cTJh8BDi66E=;
 b=HtHzxpFH7TVwDwzFfjKl2+U62Z5IhPIkhLHMVriKOuULu8SUBFPiU1RWPSJOPB/7uIbPeW
 7dDcMHgxfMtfqAkAArEZcsrYvjNyb7gKXJVnMVCek4uANRJLCkOxyou8S3ffnfSnvWWkHZ
 EbvJyofzaVAZXeDVMyYYrlIUIu33Jb4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-bIHj4FtVNqSp90VrLKdUkA-1; Mon, 18 Oct 2021 10:30:44 -0400
X-MC-Unique: bIHj4FtVNqSp90VrLKdUkA-1
Received: by mail-ed1-f72.google.com with SMTP id
 i7-20020a50d747000000b003db0225d219so9924057edj.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 07:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=16lgWy6r2ijeFvmyYBWNBFj6OUleKDb2cTJh8BDi66E=;
 b=wn4tw3GJDoS52iI4bnCFgHB1euWpVLdJgDaZhdVtg4InWUHNlnfDiHTGz+BQYgq8Pg
 rAvyKujfO1DBEnM0KAoKDR0NyOZsVTX10DrMJOcR/5q3u4BLdcW/vGLy/zomxDXgXnca
 Me94H0QaE7kgH5fOh2+pWkfcZ+ywdJksSMviMnYZjGKi+swQzupsgjA1xNqO6epPNunm
 /+4Pf1W/Hhgz9linfclUWXrAr5+N2h9TL0SG0m2LZAFu1asDudv+c3nPiOGyEUyiv2+j
 Ajs9p0AC2XvCRF8PA3kF9SmnI3nIpF8KPFP3aAiYSHgPdAcvJCcMOTJ+iT/cQ8QDwWIy
 C66Q==
X-Gm-Message-State: AOAM53024G1DXP88YzbZGBqQSvBDuFNZI88L42gwZR4IlCxGuu1BuR1W
 WfK+cbaGKpkgtH9dfFev8m4paFzchiQwb1ZotQKULonKsr61dwKK7EYLnYvclXtuvjHh7yrllNy
 gJnqFqm0U2fQ5mNILxo4r4szB
X-Received: by 2002:aa7:cd8b:: with SMTP id x11mr45193816edv.384.1634567443443; 
 Mon, 18 Oct 2021 07:30:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOPhN4B7GDbBSZ7+1OX/c4MoxhYUWo11/O3rb3LVvmuMXMvo3tDY2r0PmKoGrxiNYc9rNOlg==
X-Received: by 2002:aa7:cd8b:: with SMTP id x11mr45193777edv.384.1634567443091; 
 Mon, 18 Oct 2021 07:30:43 -0700 (PDT)
Received: from gator.home (cst2-174-2.cust.vodafone.cz. [31.30.174.2])
 by smtp.gmail.com with ESMTPSA id jg21sm5789033ejc.14.2021.10.18.07.30.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 18 Oct 2021 07:30:42 -0700 (PDT)
Date: Mon, 18 Oct 2021 16:30:40 +0200
From: Andrew Jones <drjones@redhat.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [RFC PATCH 02/25] KVM: arm64: Save ID registers' sanitized value
 per vCPU
Message-ID: <20211018143040.nhkv67cxni6ind6k@gator.home>
References: <20211012043535.500493-1-reijiw@google.com>
 <20211012043535.500493-3-reijiw@google.com>
 <20211015130918.ezlygga73doepbw6@gator>
 <CAAeT=Fx9zUet2HvFe8dwhXjyozuggn+qcQBoyb_8hUGJNKFNTQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAAeT=Fx9zUet2HvFe8dwhXjyozuggn+qcQBoyb_8hUGJNKFNTQ@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
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

On Sat, Oct 16, 2021 at 05:42:59PM -0700, Reiji Watanabe wrote:
> On Fri, Oct 15, 2021 at 6:09 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Mon, Oct 11, 2021 at 09:35:12PM -0700, Reiji Watanabe wrote:
> > > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > > registers' sanitized value in the array for the vCPU at the first
> > > vCPU reset. Use the saved ones when ID registers are read by
> > > userspace (via KVM_GET_ONE_REG) or the guest.
> > >
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
> > >  arch/arm64/kvm/sys_regs.c         | 26 ++++++++++++++++++--------
> > >  2 files changed, 28 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 9b5e7a3b6011..0cd351099adf 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -145,6 +145,14 @@ struct kvm_vcpu_fault_info {
> > >       u64 disr_el1;           /* Deferred [SError] Status Register */
> > >  };
> > >
> > > +/*
> > > + * (Op0, Op1, CRn, CRm, Op2) of ID registers is (3, 0, 0, crm, op2),
> > > + * where 0<=crm<8, 0<=op2<8.
> >
> > crm is 4 bits, so this should be 0 <= crm < 16 and...
> >
> > > + */
> > > +#define KVM_ARM_ID_REG_MAX_NUM 64
> >
> > ...this should be 128. Or am I missing something?
> 
> Registers with (3, 0, 0, 0<=crm<8, op2) are defined/allocated including
> reserved (RAZ) ones (please see Table D12-2 in ARM DDI 0487G.b),
> and the code supports those only for now.
> 
> I understand that registers with crm >= 8 could be defined in the future
> (I'm not so sure if they will be really ID registers though),
> but then we can include them later as needed.

Oh, I see. Thanks. Looking at the table I see CRm=0,op2={1,2,3,4,7} are
also missing, but it certainly doesn't matter that we allocate a few
unused entries, especially since we also allocate entries for all the
RAZ ones.

> 
> > > +#define IDREG_IDX(id)                ((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > +#define IDREG_SYS_IDX(id)    (ID_REG_BASE + IDREG_IDX(id))
> > > +
> > >  enum vcpu_sysreg {
> > >       __INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
> > >       MPIDR_EL1,      /* MultiProcessor Affinity Register */
> > > @@ -209,6 +217,8 @@ enum vcpu_sysreg {
> > >       CNTP_CVAL_EL0,
> > >       CNTP_CTL_EL0,
> > >
> > > +     ID_REG_BASE,
> > > +     ID_REG_END = ID_REG_BASE + KVM_ARM_ID_REG_MAX_NUM - 1,
> > >       /* Memory Tagging Extension registers */
> > >       RGSR_EL1,       /* Random Allocation Tag Seed Register */
> > >       GCR_EL1,        /* Tag Control Register */
> > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > index 1d46e185f31e..72ca518e7944 100644
> > > --- a/arch/arm64/kvm/sys_regs.c
> > > +++ b/arch/arm64/kvm/sys_regs.c
> > > @@ -273,7 +273,7 @@ static bool trap_loregion(struct kvm_vcpu *vcpu,
> > >                         struct sys_reg_params *p,
> > >                         const struct sys_reg_desc *r)
> > >  {
> > > -     u64 val = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
> > > +     u64 val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(SYS_ID_AA64MMFR1_EL1));
> > >       u32 sr = reg_to_encoding(r);
> > >
> > >       if (!(val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))) {
> > > @@ -1059,12 +1059,11 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
> > >       return true;
> > >  }
> > >
> > > -/* Read a sanitised cpufeature ID register by sys_reg_desc */
> > >  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> > >               struct sys_reg_desc const *r, bool raz)
> > >  {
> > >       u32 id = reg_to_encoding(r);
> > > -     u64 val = raz ? 0 : read_sanitised_ftr_reg(id);
> > > +     u64 val = raz ? 0 : __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
> > >
> > >       switch (id) {
> > >       case SYS_ID_AA64PFR0_EL1:
> > > @@ -1174,6 +1173,16 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
> > >       return REG_HIDDEN;
> > >  }
> > >
> > > +static void reset_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
> >
> > Since not all ID registers will use this, then maybe name it
> > reset_sanitised_id_reg?
> 
> Thank you for the suggestion.
> 
> I named it 'reset_id_reg' according to the naming conventions of
> set_id_reg, get_id_reg, and access_id_reg which are used for the same
> set of ID registers (ID_SANITISED ones) as reset_id_reg.
> I would think it's better to use consistent names for all of them.
> So, I am a bit reluctant to change only the name of reset_id_reg.
> 
> What do you think about the names of those other three functions ?

I think I like the shorter names, so please disregard my suggestion.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
