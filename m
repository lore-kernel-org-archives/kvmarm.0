Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE013FFADD
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 15:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781535838; cv=pass; b=lPuxFa1m54zH9JyE5XccSXfULdZuCgFSJwg67UhyRGcQhA1rtyud/iBWWTPyv/9wkWwmybrk2ljS+TbBtkI8mw2QBEP9RUIlPivp8YkBSVVlxV72igl+HHLLLzlIqqHvV5wc0wGI84wYaPIRfRXz5dYiewbaMhNKd0tubk3rPPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781535838; c=relaxed/simple;
	bh=TVvpghQpbt6e+zhhdXdSsnP+d/HSV4H84QGAaAKA3vI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qe5RzV4WpTBxoGifRngZLZQQTLviGViI2mcS7aZg8EIjQfkdb8qeaw2aDIt54cqEHjUzZZ2RJC83O7Og15LfKoshiFB4Y2AmZGdIr//RS3HlpHSc2mIJaWXd6zTZbBftJM7pxGtbGQOi0QyQKWg6GbrVIK2BZU2g6HFLJdjzzhc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dy8h49ld; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dy8h49ld"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51765531803so117791cf.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 08:03:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781535835; cv=none;
        d=google.com; s=arc-20240605;
        b=OQg9QIFXtdSTSlkJwnaw6ntACW+Mowmrbe5oHQTe2KEqA/qD4EoxaBFum1NnrSgqao
         /RFYjoK7YlXtNqu+P8MYdL8sjUtKZKs2F6eYF1DAytafXYt8lSeXzLOtdvF7AV++Rdki
         d3MKVedQD5v7ZJuD/cTG45CYoh0ebJeYGAMjt+c0uVbwov7TL9IAsCigB00+/kQjj6fY
         vuq19Cwa8QCkj8Xx554IuwazfhpDM+86usafy0JwUec/WitTtqz2wlUsJBcfUNGMhHM9
         tCAYWVNbyZ/4LitWws7pHMeyCgUb8kaIbkMAKVjNkZJ4ypiMkTjkqkXwgkn/aoJmWPF4
         Cobg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dH/2FN9MBlarR5JU+NMeyThmVcZKaugzdsaHBaCxFFk=;
        fh=x5cq8RELtoAJdSfxSr9i/MVLpa/72ckx6IorPbxTpYU=;
        b=Y13duRer2X506JJ9epifbB4G8Rukat6yrsxS0zRPWN1iiNzOcb2diFNcVFa/ycmIct
         VIyrK8kkcJAtGsDgPPPRhknsKWS57EhQx6uIExW/I0GQMnko9JiN8yUCY5N0TWPGv6Bg
         moWL+zweaTKADP68udBEfHjn1Cg3nPTC+OvvrYfo+SVN+3sOnq7/NgrfsruieDfcRByW
         8vLGmp3GKtkTqkp2aDIjv/dlcLVEKJdQfsuByGEjgxwbbrBodN+QgFjowyQ1KarwGSt+
         UWDezEgyR3+lCuxxCXyoo+UfkfCTufxkd852LUB512s2aoGAQmVNWq7EoY9Ifgdrg29e
         wiVQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781535835; x=1782140635; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dH/2FN9MBlarR5JU+NMeyThmVcZKaugzdsaHBaCxFFk=;
        b=dy8h49ldOJkFB66FemEx5l8fVEAlW9LBOqVxZyty38N7cEIVCUt9nvRW4Z/pPn4I+8
         VLa29Uc1PqIZTFCJ3kls/oTlfzNuVFjCPcNvDlRr3rX1CZC5b847CyXZd8NATNDS1+ZO
         cOPyf8VLYwmWLXfgnvzE2HQWAtm7hZwFA/BBbwcCeUQBPi66Pa+mrXSQwjDx/8XBIgsn
         VakZ20s3KN5aHIEMA8gvJyA+c9Ubfkmb6/VYf3aUjqwEg5eZ5GmnAb11Cbm5SUuAhOtW
         yvmfWW01M0bkTeS6WdMFPuCqSoXf/JW5o8N4gpWtxSsbFg+vzYVhf3uBV40Kpex5f8R1
         UsuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781535835; x=1782140635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dH/2FN9MBlarR5JU+NMeyThmVcZKaugzdsaHBaCxFFk=;
        b=OVHSOd6uoOJbmqq4zYjX7+sAmtpJK89iG1fRHVhXOxVzq9NigIIBG8W8df9YI1X7zH
         HVgr+itL8TPZb9fkq5G71ZdUnMjMyuogfEsdEU9CUSNgdoYOKJ/7kvSPVcKvZM7EO/ho
         UkRUMBuofynuApZ9mdRbzsSGHKLXhwOZOHtDSAtAZbP3g0RdZGm3JNQKsW1F3yViz5Fi
         aLOCw44FFKdb+6vH4zp73QIqS1tKtMiYOUAFBgXZvjU5Foufj9oHirAUGlX4A6USxopS
         lAGCt/Jci9sx/BUJcCAM7cNY1s9dkoQ54a4PByR53ax0cxVg+6Vot6TRbVHMIQXldg6F
         GLRw==
X-Forwarded-Encrypted: i=1; AFNElJ9YALK/d2q0x4aKseTQdM7FpRIrmkTS9WvqqRO81uB3GQTD7figfNniDwl6DJA/8MXqMObhGlg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxhulFHMRuqfycTrq+FVr0Lh1VbCEhXVIYL7v4NTiIt/2NVnVv
	a3+eowGX4EqJ7qF+SaIIymDH4r0HyQZaCH5jgC1jCRrjdr762HmVr9vLqrq7IK4BjJFZQZGWexL
	wDIE7Ma/l7t/H5fZY6MmtO4nI5khOy3L3uWgPCDLV
X-Gm-Gg: Acq92OGF6MT+CBvXmOnR7C70eAOdXW33V6MgoWVlmEB8JFpkgsfdGFQ1jedYxiM6//n
	9M8Z0Q/Gd4tcJR7DsakLizBya2dsRrU/pjgwse/DpUXOrDsZzngsUNQNsMHy2nf7bvS3oaItAgF
	vG0CDsxfAK5jm95Yt39IgOS+jEgD0dMV8qFILgAivaI5E7A7p1hO7Sn0tM3lP60e2ylxPfPhwea
	FNLWtTzlbhwYfZTMCqrprJ1BU89seuqB9rcsHpXXu635nuW1craKuh63fvz6HuRQz3sbMYDeZJ8
	xpgiZuEd
X-Received: by 2002:a05:622a:551b:b0:517:99ea:ab7a with SMTP id
 d75a77b69052e-5198765a8cemr2490151cf.26.1781535834368; Mon, 15 Jun 2026
 08:03:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612113414.1022901-1-tabba@google.com> <ai_OevUNS-OACPm7@willie-the-truck>
 <CA+EHjTyMOoCLQ7d6+TgkrnOJF-PV9K-BKtb4CNuAg8p4gtg6wg@mail.gmail.com> <ajAPNFDsQ63k_jAS@willie-the-truck>
In-Reply-To: <ajAPNFDsQ63k_jAS@willie-the-truck>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 16:03:17 +0100
X-Gm-Features: AVVi8Cda5pPeMmputRE2w7EYBD7XN30xx4QwVSzYxlGD-O5h54qT752Fu-6z6Pg
Message-ID: <CA+EHjTzL4GKw8RQrGnMq81Ohquo48_L4-MNJrCdGnBpMPR7XcA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Sync SPSR_EL1 when injecting an exception
 into a pVM
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Sascha Bischoff <Sascha.Bischoff@arm.com>, Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Jun 2026 at 15:42, Will Deacon <will@kernel.org> wrote:
>
> On Mon, Jun 15, 2026 at 11:52:10AM +0100, Fuad Tabba wrote:
> > On Mon, 15 Jun 2026 at 11:05, Will Deacon <will@kernel.org> wrote:
> > >
> > > On Fri, Jun 12, 2026 at 12:34:14PM +0100, Fuad Tabba wrote:
> > > > When pKVM injects a synchronous exception into a protected guest, it
> > > > re-enters without restoring the guest's EL1 sysregs and writes the EL1
> > > > exception registers to hardware by hand: ESR_EL1 and ELR_EL1, but not
> > > > SPSR_EL1. enter_exception64() sets SPSR_EL1 (the interrupted PSTATE)
> > > > only in memory, so the guest's handler reads a stale SPSR_EL1 and
> > > > restores the wrong PSTATE on eret.
> > > >
> > > > Write SPSR_EL1 alongside the other exception registers.
> > > >
> > > > Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
> > > > Reported-by: sashiko <sashiko@sashiko.dev>
> > > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > > > index 8c3fbb413a06..1a7d5cd16d72 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > > > @@ -268,6 +268,7 @@ static void inject_sync64(struct kvm_vcpu *vcpu, u64 esr)
> > > >
> > > >       write_sysreg_el1(esr, SYS_ESR);
> > > >       write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
> > > > +     write_sysreg_el1(read_sysreg_el2(SYS_SPSR), SYS_SPSR);
> > > >       write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
> > > >       write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> > > >  }
> > >
> > > Is SPSR_EL1 not set in enter_exception64() using vcpu_cpsr(vcpu), which
> > > *is* set here? I'm just a bit wary of the report, as I'd have expected
> > > fireworks if we weren't initialising the guest's SPSR on the exception
> > > injection path.
> >
> > Yes, enter_exception64() sets SPSR_EL1, but only in memory:
> > __vcpu_write_spsr() takes the nVHE path and calls
> > __vcpu_assign_sys_reg(vcpu, SPSR_EL1, val), which writes
> > vcpu->arch.ctxt.sys_regs[SPSR_EL1] without touching the hardware
> > register.
> >
> > In the normal nVHE entry path that memory value reaches hardware via
> > __sysreg_restore_state_nvhe() before __guest_enter(). But
> > inject_sync64() runs inside the fixup_guest_exit() loop, which
> > re-enters the guest directly without a sysreg restore pass. ESR_EL1
> > and ELR_EL1 are already written to hardware by hand for this reason
> > but SPSR_EL1 was missed.
>
> Ah, I see. Does that mean that all the in-memory updates performed by
> enter_exception64() (e.g. the construction of the cpsr) are ignored too?

From looking at the code, no. inject_sync64() reads back the cpsr and
PC that enter_exception64() computed in memory and writes them to
hardware:

    write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
    write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);

So the guest re-enters with the right PSTATE. The only value left
stranded in memory is SPSR_EL1.

Cheers,
/fuad

>
> Will
