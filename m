Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF843F4126
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 13:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530206; cv=pass; b=Y3wV3L+ytir5W7g3DBfyOht6BGMNGahGdkS4DdZkoNV8hmogkcw832iv5RFCqF7yDDYMvm2htEee0l+5NSXGk7V4vlIPBidRPnoEYLa+CcBThwNDOUHCNmYJirPVjm5A5np24ikQB7VD0xq5CMFOF81l25Fs3JgTGuruesynF74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530206; c=relaxed/simple;
	bh=9ceuLGvv1zMH2eH5W1uoX2v0/qeb7/FjKCkH1pWLJbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OMAkWui2ax8Ia0X62PDx0/GTvHJRnclDBtE+5ypZCVEXNC+CiHckc3YTJAQH45wkXgkUnBXOVKbl6Gq61m/sEDFZuRZboxhepIKFVRNI/7a1nqT0mRH32DV7UPGjOVPTAoyVh0ZDqMY2CYrX0aBOBTT7Z0dhFsmjZVem0zF77bQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E5ea7Rzm; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E5ea7Rzm"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51765531803so75951cf.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 06:30:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781530203; cv=none;
        d=google.com; s=arc-20240605;
        b=IM51rdpQ9U+23+2q984SEmSsL4lpZ/4LvgcYvfCXxlsrw6CVTtsdEcaLIwVZtkQChC
         1F8vmsptaANxXE56bOJv8v/4XWlWbtIRDRoOtGd5yl3HSz5mv8dwHjPeH7TpZsqlCaPb
         UQmxE3vAapuGCeLsg05sHBNte9NwYve+nc1g/DnMnwNxgn6Zz7jx6AVvRuB8gqGF1Qg/
         C4x/oTWfG2ydTgrkZt3xETZ51kRCzU78BYrzxPwyg1U5dvUVof8OHWokY3Qc+mwB/i37
         znodyxJJ2zpVRsP+yHt5QxxKwJ31mTZjMHhS/ZZu9VcX6LQv2ughd5g3tSLO2kzujrYF
         xN0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3phygt89mT1L7d+3MFHcmDG0z7MbIjyRqhevKospxxM=;
        fh=w7UjD8Ozxkn5Cb2cNGlqeDOH7Sg2pS87Kg28zqM7g6I=;
        b=BJIOzz60LevTAEPiwMWcD7Y4JeCA/BaBMknzbQZId4XR4XDMVmNoJrdyjBFwLBQOHl
         F73/IBN0YMIigFhPEEiJvglRWm2sjhlvivz34o7JfctAu1UnrQq8Hy/RzUjblWsUWnhw
         iqA/nn2SXAJEsXcPQjdW274tUZ9ypU02RDTDldQE9ATRFVsWWWV8F0WoKDdTAB1cOZPU
         VFgqOipiL5/yXZDb/cBbK9jUlheqrQAOWrBFJGjHKEdgUZ04aYW4P0blVmuGBw3uAGcb
         +BhN9uhNDbqYvWC9J6BEaKGFLNIAIm9cp1/kLHfkzrAk1LeN0CA48BPnB+DErXKevfbc
         k4iQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781530203; x=1782135003; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3phygt89mT1L7d+3MFHcmDG0z7MbIjyRqhevKospxxM=;
        b=E5ea7Rzm//0Nxyj+9c0abIorCXzROIf85n61NS5vXq/g8iBEufmvNCCLh6BNc/bkG4
         iFH6yF62OjvRXBACHD+DCRaI9xVyVSG6s8TYGaFOrnevEbDIGogwd4U8wbT/oo8Q2+vm
         FVLUef8yDNSRiYQ2iHcflSkqSuXt2i+Yd2IZZ5Kl71damJ3y/RHqgicGVRY+svSJLZ33
         wxbHBAesAznQmqwx8Qs/fzmeSSAdlNskhOXoQPTi2s8S/G5SBiXTMqbvb++BQql6Nxz+
         OjRFCflW0+8++bRXHzWX0qZqYPgfvfgolz4HwB/wITsSWblU02akeNAm600qGOzfrONN
         fhmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781530203; x=1782135003;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3phygt89mT1L7d+3MFHcmDG0z7MbIjyRqhevKospxxM=;
        b=AuuANN629fhLfnX+2pMbsXk+H7vHl1tVX3aPCAAoSRG4tJYg3ZA2w0rMNz7v8YyvMM
         2WAQCsIL0h1KbjJWXKEXwuMPRpVXyz5ZvL6geGzpLMCsUgRNQPQvGZIZqNUlDXELQFrx
         8pXP7o77aAz/yUGINfkY2JsbAyDp3mnWFwP+/mJecf5T++iUgiiuhZW3c+GImlDAO7jB
         m/oqprD/+dexo7RgEvwSDbZ8jQ1tzEQfFTL8laEN3GJfoBKFVP6dmxoLUQO1aezF2p88
         F8vUBZMKMpfCu8/UTMI4dxGzQUpbEyzeER2ITZE1ryi/CcL6Kn1fWlG4Hf+Mle6lEXMj
         j9Cg==
X-Forwarded-Encrypted: i=1; AFNElJ/TjpnIEyST4ZJJ0yo+RUtHTUs1yaDiDMgiAvV96qtWo+/UtoWMJdzushZNL5oJyR23H5YW1Dw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyaC5euE+tWtJ0mXECb3eoz5Rf6N6W1PrMkShUUEt3N9JUvel2
	o7TIXneJECXqU40MdvOY4H7j/P4h/sjRFczqVKuI6JU8L97h4zeEOJqa5K32D3MKg/sEpnAE0Zh
	5mUAz/wrgJTHR0B2tQtUp2cklFbMbNfg7h6SVZbH7
X-Gm-Gg: Acq92OHwrm5TDBe0dXyc6oBu9SI5fAd6SO4PoSm1JfEi0YOYiAH3o91eg+thJDavTM+
	+uRq1YSVif6gKnL7xzFYXM4fDRfAInY71IiBqNz3nOpZQ6yPQGE21sMu1ee/XewPyV+Hm8X7IER
	OxLXLLVXjgeOOR9mK7rUXdonFZ+qKnNW6rYjnZVIo6CP7YPiXjAWru3u5QyF3d/mvMRaJEmcFnF
	uVAPorWVC+r8k5phZAXTvHyM4F1obFyiT6p58KIwca+qJfQ0zOfZpXJYRhLgJ+ufjXYCz2Z1ia3
	ZnjM930A
X-Received: by 2002:a05:622a:1188:b0:4ff:bfd9:dd31 with SMTP id
 d75a77b69052e-519872df71amr1731631cf.5.1781530202283; Mon, 15 Jun 2026
 06:30:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com> <20260612065925.755562-6-tabba@google.com>
 <ai_5_CoRm-LdoVMm@google.com>
In-Reply-To: <ai_5_CoRm-LdoVMm@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 14:29:24 +0100
X-Gm-Features: AVVi8CcrTMGo9YYeBFMqIsQ3CD-jzDAcCVBgdTfRMO0b7ViZFUlAAkK2kzEwfHA
Message-ID: <CA+EHjTyRR3Rg3BT4guUy_VKw9jgZawKUhg7tv_H8iqSGW5Lsvw@mail.gmail.com>
Subject: Re: [PATCH v1 05/11] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Per Larsen <perlarsen@google.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jonathan Cameron <jonathan.cameron@huawei.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 15 Jun 2026 at 14:11, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Fri, Jun 12, 2026 at 07:59:19AM +0100, tabba@google.com wrote:
> > The vcpu_{read,write}_sys_reg() accessors are host-only, so helpers
> > built on them such as kvm_vcpu_set_be()/kvm_vcpu_is_be() cannot be
> > shared with hyp code. Add _vcpu_read_sys_reg()/_vcpu_write_sys_reg()
> > inlines in kvm_emulate.h that dispatch on is_nvhe_hyp_code() to the
> > host- or hyp-side accessor. A follow-up series uses this to share that
> > emulation code at EL2.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_emulate.h | 22 +++++++++++++++++++---
> >  1 file changed, 19 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index 5bf3d7e1d92c..aed9fc0b717b 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -506,6 +506,22 @@ static inline unsigned long kvm_vcpu_get_mpidr_aff(struct kvm_vcpu *vcpu)
> >       return __vcpu_sys_reg(vcpu, MPIDR_EL1) & MPIDR_HWID_BITMASK;
> >  }
> >
> > +static inline u64 _vcpu_read_sys_reg(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
>
> I am not sure a single underscore is widely used in the kernel.
>
> Why not move __vcpu_read_sys_reg() and __vcpu_write_sys_reg() from exception.c
> to kvm_emulate.h? especially this already checks has_vhe().

Good point. has_vhe() already returns a compile-time constant
in hyp code and a runtime cap check at EL1, so it works in all
contexts. I'll move them to kvm_emulate.h and rename to
kvm_vcpu_read_sys_reg() / kvm_vcpu_write_sys_reg().

Cheers,
/fuad

>
> > +{
> > +     if (!is_nvhe_hyp_code())
> > +             return vcpu_read_sys_reg(vcpu, reg);
> > +
> > +     return __vcpu_sys_reg(vcpu, reg);
> > +}
> > +
> > +static inline void _vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, enum vcpu_sysreg reg)
> > +{
> > +     if (!is_nvhe_hyp_code())
> > +             vcpu_write_sys_reg(vcpu, val, reg);
> > +     else
> > +             __vcpu_assign_sys_reg(vcpu, reg, val);
> > +}
> > +
> >  static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> >  {
> >       if (vcpu_mode_is_32bit(vcpu)) {
> > @@ -516,9 +532,9 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
> >
> >               r = vcpu_has_nv(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
> >
> > -             sctlr = vcpu_read_sys_reg(vcpu, r);
> > +             sctlr = _vcpu_read_sys_reg(vcpu, r);
> >               sctlr |= SCTLR_ELx_EE;
> > -             vcpu_write_sys_reg(vcpu, sctlr, r);
> > +             _vcpu_write_sys_reg(vcpu, sctlr, r);
> >       }
> >  }
> >
> > @@ -533,7 +549,7 @@ static inline bool kvm_vcpu_is_be(struct kvm_vcpu *vcpu)
> >       r = is_hyp_ctxt(vcpu) ? SCTLR_EL2 : SCTLR_EL1;
> >       bit = vcpu_mode_priv(vcpu) ? SCTLR_ELx_EE : SCTLR_EL1_E0E;
> >
> > -     return vcpu_read_sys_reg(vcpu, r) & bit;
> > +     return _vcpu_read_sys_reg(vcpu, r) & bit;
> >  }
> >
> >  static inline unsigned long vcpu_data_guest_to_host(struct kvm_vcpu *vcpu,
> > --
> > 2.54.0.1136.gdb2ca164c4-goog
> >
