Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7810E1EC4C5
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 10:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733912520; cv=none; b=lDLvRi5u6YkEb/k5Ugqc9JK8E8cxp66xMppENHNJglQ/aGv6KKBASfJH76iqihohr++fkiBxBfQGW1h6mzN9CzD/owN2ZAD11Xt7O7OHQZLoV12bvGNRgeBNFFLzK8/huNDvY9kEJsjNeMO9AY/+LDKnZE9AWjQL6CiY4pJH7AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733912520; c=relaxed/simple;
	bh=UDTVUyfFjVIKkfvVfweWHLUWsyuJZrsbYUs890yBJrY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pf0VlcZcOKH9neBmWhIXO4hEKpPK7/79YuZCfbVBFM2BH+RgUu5CQAfbp9Gs8Wxbi+JCwhhXdxOrYMn0urgmd+CE2UfbSM/x6ZU1SoTl/fpMgEsJJ9zezQDBs+DW2rXoS1t0YG3x2WUQj6mx7DV91SqNkG7NETJb9Li0v5ns/w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xl/iyeTx; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xl/iyeTx"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-434f150e9b5so29465e9.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 02:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733912517; x=1734517317; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BeXMj8VvPwXBM+YorP3kB6swE+LJumb2PgH049Y7jrU=;
        b=xl/iyeTxAc1n4RMuNDwinL2djRc2N4T5tFtCsrC/IVcl/tEFTbPKPGyHJJJ7/BrSc2
         Gw44Rt3GmoCTOONq8QFo3HyeKHWGFufb1R9MEVCH3wZMordvKzLqBcHn1bMplzVbeMmh
         3VurpHKYfA7Lk0Lme8k9auBFGcnp/z40Bm4fvLLYtBMrSjTYtPWz6+6jw+UZ/jHAdVm0
         63hdlgWMicDz7i0THhUqHa8xmXlawDYJR5SKI5U0G6x2SnruC+VxUh/OQUBPrui0ehqa
         xbOtBkmgVrqihRqL01x/fUR9QYa3tHsx+ujTbit5NpT8+MqZed7ivdjAzrQUBdh085T1
         T7rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733912517; x=1734517317;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BeXMj8VvPwXBM+YorP3kB6swE+LJumb2PgH049Y7jrU=;
        b=nV1L/r8Pa69Jid7EPVEjlH/HMEGAFlcqgvN3tl5nsFEbGkr2X3pkhj1I+yJIlyMCLc
         gg94CWiLbF96su2nQrpjbBEvgGsVZi/lIYmMZtQQmdib9x3EkNcdu1lS0YDrpKCZVZ9i
         qUZQlJ13YZqbHCqA0ja/PHMRQHEDCsbFembln57U9Kib0yZXUnnTcZ41Y/EOmi5Kj/Qf
         MU6t5ZRwdffmir3o4WutfnncSlJwmxtm+F8JyS9KfxhthCp731GVKzPlFCyegnF5oDTi
         72BKAxojMYAWaW2dXqAkByfNjZHEL3HPeZMkbU0+k2GQgLkqxvld64FCYTAh8AoaVLPu
         cVCg==
X-Forwarded-Encrypted: i=1; AJvYcCWgzuwof9if8Lj3yKwURtR/rgsmTrHUXKXpmmrPvgKuFan46m58XAtNZW8EebYGAAjSE/V2swY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRIc/ueIcpvtgLJgTgeSQBPNM51D9d8S6X1/t8MPOaPr3lvDru
	jk0gyNGaPX7Pmgc6ZjsGxmyRsDkFa3lqITCmVHHgjglGFywUpRS1SBpZ0aDwbKNOR+sEYSMSLJP
	CqI416eL/G5B30er4lFArFsLuCp6olTp5YIP9
X-Gm-Gg: ASbGncu02D/1eUspooc/1/bHRMyGvCQCwdrT7CkGOD8d1BvgPWT9vyEnqycUZx7UNgx
	Eim1g2Q4cIV3kCwaKyBSGIDaCRU4OjRGB2heh8pC2jkck6ug1Vsx7fLohDKSRVlSh
X-Google-Smtp-Source: AGHT+IGdAegS44TMEDlVdgvzE+gKy2ozwm3TkkcQ7rpYSyvhwicVZQRotOml5HMNIrItY+DK9IjWorBpSsLKxTL7rAM=
X-Received: by 2002:a05:600c:490a:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-4361c0e320bmr1000685e9.2.1733912516699; Wed, 11 Dec 2024
 02:21:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-17-qperret@google.com>
 <CA+EHjTw_e_q5TFkgxvVDKxwj-C5S0Hd1OfVO4_FitrB8_J2Rpw@mail.gmail.com> <Z1ljbPFsUdUC8AD3@google.com>
In-Reply-To: <Z1ljbPFsUdUC8AD3@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Dec 2024 10:21:20 +0000
Message-ID: <CA+EHjTwnZ8S4LUgmJ40g8juHh5OneWUWtJDDCnn03Xw0MvQ-=A@mail.gmail.com>
Subject: Re: [PATCH v2 16/18] KVM: arm64: Introduce __pkvm_tlb_flush_vmid()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Wed, 11 Dec 2024 at 10:03, Quentin Perret <qperret@google.com> wrote:
>
> On Tuesday 10 Dec 2024 at 15:23:02 (+0000), Fuad Tabba wrote:
> > Hi Quentin,
> >
> > On Tue, 3 Dec 2024 at 10:38, Quentin Perret <qperret@google.com> wrote:
> > >
> > > Introduce a new hypercall to flush the TLBs of non-protected guests. The
> > > host kernel will be responsible for issuing this hypercall after changing
> > > stage-2 permissions using the __pkvm_host_relax_guest_perms() or
> > > __pkvm_host_wrprotect_guest() paths. This is left under the host's
> > > responsibility for performance reasons.
> > >
> > > Note however that the TLB maintenance for all *unmap* operations still
> > > remains entirely under the hypervisor's responsibility for security
> > > reasons -- an unmapped page may be donated to another entity, so a stale
> > > TLB entry could be used to leak private data.
> > >
> > > Signed-off-by: Quentin Perret <qperret@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_asm.h   |  1 +
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 17 +++++++++++++++++
> > >  2 files changed, 18 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > > index 6178e12a0dbc..df6237d0459c 100644
> > > --- a/arch/arm64/include/asm/kvm_asm.h
> > > +++ b/arch/arm64/include/asm/kvm_asm.h
> > > @@ -87,6 +87,7 @@ enum __kvm_host_smccc_func {
> > >         __KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
> > >         __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
> > >         __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
> > > +       __KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
> > >  };
> > >
> > >  #define DECLARE_KVM_VHE_SYM(sym)       extern char sym[]
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index de0012a75827..219d7fb850ec 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > @@ -398,6 +398,22 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
> > >         __kvm_tlb_flush_vmid(kern_hyp_va(mmu));
> > >  }
> > >
> > > +static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
> > > +{
> > > +       DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> > > +       struct pkvm_hyp_vm *hyp_vm;
> > > +
> > > +       if (!is_protected_kvm_enabled())
> > > +               return;
> > > +
> > > +       hyp_vm = get_pkvm_hyp_vm(handle);
> > > +       if (!hyp_vm)
> > > +               return;
> > > +
> > > +       __kvm_tlb_flush_vmid(&hyp_vm->kvm.arch.mmu);
> > > +       put_pkvm_hyp_vm(hyp_vm);
> > > +}
> >
> > Since this is practically the same as kvm_tlb_flush_vmid(), does it
> > make sense to modify that instead (handle___kvm_tlb_flush_vmid()) to
> > do the right thing depending on whether pkvm is enabled? Thinking as
> > well for the future in case we want to support the rest of the
> > kvm_tlb_flush_vmid_*().
>
> I considered it, but the two implementations want different arguments --
> pkvm wants the handle while standard KVM uses the kvm struct address
> directly. I had an implementation at some point that multiplexed the
> implementations on a single HVC (we'd interpret the arguments
> differently depending on pKVM being enabled or not) but that felt more
> error prone than simply having two HVCs.
>
> Happy to reconsider if we can find a good way to make it work though.

I don't have a strong opinion about this. I think that for now, since
it's only this function, it's probably fine. That said, the
multiplexing is (as of patch 18, which I haven't reviewed yet) is just
lifted higher up to the host kernel, albeit with fewer parameters to
wiggle around.

To summarize, I think we can worry about it if/once we need the other
tlb_flush_* variants.

Cheers,
/fuad
