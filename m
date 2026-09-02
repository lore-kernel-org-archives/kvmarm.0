Received: from mta1.migadu.com (out-157.mta1.migadu.com [95.215.58.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90E74772AC
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 11:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788348978; cv=none; b=EO0I14oXeZiBxcVOj69hiVoT1m5OpWH7NeFzCYqpNfwfKAtzltgRFNTCvk6MzNLKo2foi8vZ1bgfufhs1W9O0pNcoJ0BnvFkvxBsUAG5EPFWPNYV5UrndnTPkpocTjQLyvLNfxKvwVXblXFXQ9IZ88cB2pvfQn3boCSRPCxAIes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788348978; c=relaxed/simple;
	bh=BiRsbHGkJc2vaZ1y6LTSpqtajhdT9mOwKxmAqCYwFoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=blk2ilc/OnuPSbC244pVVf2NKtBeymYtKzvgxx7KS4Vs+8nP+FVpPXX0+tZ+Nx/9XTJ/yZJQ00h0YaaY6P+P2Seo3EbzXqF7FqTBt9RlssiCCYlWQToD4hew3C5TrUv+mWPBIxrwVtAjsx7KkgpQQU20IQ4FxAtCaidvEfKSgQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jumnKcd7; arc=none smtp.client-ip=95.215.58.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jumnKcd7"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=BiRsbHGkJc2vaZ1y6LTSpqtajhdT9mOwKxmAqCYwFoc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788348965; v=1; x=1788953765;
 b=jumnKcd7yjbFc/KymgpnBVE/D1y3u8TEwLdmSRdLi6goEPhLrK7reSfz2mNd6hKDgdW0GvBG
 ZDz7rHHPbUSotX9Zcj0Tv17PYRRhM7HeJc1n5M3s0GIaYjAUCx9jRJ9aLm/cvkk7Rvk7DCFz4RX
 81GNwqanRKyW5v87hSMnwBQQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 325548552829cace;
	Wed, 02 Sep 2026 11:36:04 +0000
X-Mizu-Trace-ID: 325548552829cace
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384c4so745e87.1
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 04:36:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz94VZ9AZ2oa6Kgzzqz8DUPTj0uFm62r5DB12yqN3SB77nWfkW9zIXSeHdM/R/gs6KV/dHPnbA=@lists.linux.dev
X-Gm-Message-State: AFuF++kAwaA9zfmkAvNONIWdQbif4gjEXYR2xCoxFpq55j5ynkocdsNu
	r0cJv8ELEIhtWFYhA6AwU2QykpyAO1fGh9/0SnjYxzwBrrt3fYV1U4gM9YCZv9WVSU3wqSr8we4
	DYXGkYL/vSsF8kj9T606vxmEgSvD6/nihMMlYLGwJ
X-Received: by 2002:a05:6512:3093:b0:5ae:a4e8:47be with SMTP id
 2adb3069b0e04-5b60d6755a2mr15375e87.7.1788348963517; Wed, 02 Sep 2026
 04:36:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831163421.272420-1-fuad.tabba@linux.dev> <20260831163421.272420-5-fuad.tabba@linux.dev>
 <apf2jvCicXlw7JYP@e143914.arm.com>
In-Reply-To: <apf2jvCicXlw7JYP@e143914.arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 2 Sep 2026 12:35:27 +0100
X-Gmail-Original-Message-ID: <CA+EHjTww35U372+YMHZTU-qP_C6+9wTxU9YWC3tZk8rm33zgVQ@mail.gmail.com>
X-Gm-Features: AcwNN1VE-_5vfzg4Lhs7Q3UcFlXLB7ylH5M4tdjkXzGG-P3YyREDqCRKlfdtavY
Message-ID: <CA+EHjTww35U372+YMHZTU-qP_C6+9wTxU9YWC3tZk8rm33zgVQ@mail.gmail.com>
Subject: Re: [PATCH 04/17] KVM: arm64: Introduce per-EC entry handlers for pKVM
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 2 Sept 2026 at 11:12, Joey Gouly <joey.gouly@arm.com> wrote:
>
> On Mon, Aug 31, 2026 at 05:34:08PM +0100, Fuad Tabba wrote:
> > From: Marc Zyngier <maz@kernel.org>
> >
> > Add an ESR_EL2.EC-indexed handler table, entry_hyp_vm_handlers[],
> > consulted from flush_hyp_vcpu() on re-entry when the previous exit was
> > a trap: sync_hyp_vcpu() records the exit reason in the hyp vCPU as
> > exit_code, and the trap's exception class comes from its ESR_EL2.
> >
> > Entry carries the host's requested PC updates to the hyp vCPU: add
> > vcpu_copy_flag() to copy a masked set of flags between the two vCPU
> > structures, with PC_UPDATE_REQ covering INCREMENT_PC and the
> > pending-exception flags. The wholesale iflags copy moves into the
> > non-protected branch; a protected vCPU takes only PC_UPDATE_REQ.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
>
> Not really looked at nVHE much (or pkvm ever), but:

That's a plus. Good to get a fresh perspective on the code.

> Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks for the review!
/fuad

>
> > ---
> >  arch/arm64/include/asm/kvm_host.h      | 19 +++++++++++++
> >  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 ++
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 39 +++++++++++++++++++++++---
> >  3 files changed, 57 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 27fe0cd5b2d7a..78a4d387f9fd4 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1033,11 +1033,28 @@ struct kvm_vcpu_arch {
> >               set;                                            \
> >       })
> >
> > +#define __vcpu_copy_flag(vt, vs, flagset, f, m)                      \
> > +     do {                                                    \
> > +             typeof(vs->arch.flagset) tmp, val;              \
> > +                                                             \
> > +             __build_check_flag(vs, flagset, f, m);          \
> > +                                                             \
> > +             val = READ_ONCE(vs->arch.flagset);              \
> > +             val &= (m);                                     \
> > +             __vcpu_flags_preempt_disable();                 \
> > +             tmp = READ_ONCE(vt->arch.flagset);              \
> > +             tmp &= ~(m);                                    \
> > +             tmp |= val;                                     \
> > +             WRITE_ONCE(vt->arch.flagset, tmp);              \
> > +             __vcpu_flags_preempt_enable();                  \
> > +     } while (0)
> > +
> >  #define vcpu_get_flag(v, ...)        __vcpu_get_flag((v), __VA_ARGS__)
> >  #define vcpu_set_flag(v, ...)        __vcpu_set_flag((v), __VA_ARGS__)
> >  #define vcpu_clear_flag(v, ...)      __vcpu_clear_flag((v), __VA_ARGS__)
> >  #define vcpu_test_and_clear_flag(v, ...)                     \
> >       __vcpu_test_and_clear_flag((v), __VA_ARGS__)
> > +#define vcpu_copy_flag(vt, vs, ...) __vcpu_copy_flag((vt), (vs), __VA_ARGS__)
> >
> >  /* KVM_ARM_VCPU_INIT completed */
> >  #define VCPU_INITIALIZED     __vcpu_single_flag(cflags, BIT(0))
> > @@ -1055,6 +1072,8 @@ struct kvm_vcpu_arch {
> >  #define INCREMENT_PC         __vcpu_single_flag(iflags, BIT(1))
> >  /* Target EL/MODE (not a single flag, but let's abuse the macro) */
> >  #define EXCEPT_MASK          __vcpu_single_flag(iflags, GENMASK(3, 1))
> > +/* Cover both PENDING_EXCEPTION and EXCEPT_MASK for global operations */
> > +#define PC_UPDATE_REQ                __vcpu_single_flag(iflags, GENMASK(3, 0))
> >  /* Host-set: the hyp flushes the non-protected vCPU state in on entry */
> >  #define PKVM_HOST_STATE_DIRTY        __vcpu_single_flag(iflags, BIT(4))
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > index c904647d2f760..49a0a992047ba 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> > @@ -26,6 +26,9 @@ struct pkvm_hyp_vcpu {
> >        * per-cpu pointer tracking us. Otherwise, NULL if not loaded.
> >        */
> >       struct pkvm_hyp_vcpu **loaded_hyp_vcpu;
> > +
> > +     /* The previous exit's ARM_EXCEPTION_* code. */
> > +     u32 exit_code;
> >  };
> >
> >  /*
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index b6bfe502bcd04..ca7122b0bccdd 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -31,6 +31,17 @@ unsigned int hyp_gicv3_nr_lr;
> >
> >  void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
> >
> > +typedef void (*hyp_entry_exit_handler_fn)(struct pkvm_hyp_vcpu *);
> > +
> > +static void handle_vm_entry_generic(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     vcpu_copy_flag(&hyp_vcpu->vcpu, hyp_vcpu->host_vcpu, PC_UPDATE_REQ);
> > +}
>
> This is added here because the full copy of iflags was moved into the
> !pkvm_hyp_vcpu_is_protected() section, so is needed temporarily until
> each EC has its own handler.
>
> Thanks,
> Joey
