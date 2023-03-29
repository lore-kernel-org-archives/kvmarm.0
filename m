Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD012F30
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 16:29:13 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id l7so14548897pjg.5
        for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 09:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680107353;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9wWrsLlXKWvQA38obw+xbkZDiZxNr9CZXUvW32hk7Zs=;
        b=Zz6aCUUmIOsuN6jjhxWlSNkUocUVLBH86e4Cgs8AuqoEgzVZgAoXrLrwHoI1qV+7SG
         eYGVOZwQlZ1yerLWiCTfWbSZ9ba7dYB4fbXiPKH96l6XVRCkJLtilAHjAsgDMiiS7iq/
         hHg5b2DyjekHyoQua10b/Fdi5z0Pdt0QhHMwyGm7oE6c7lnMLOv2pYwycyOlKQ2YCBYu
         twGVqko3CVySmDqYsadOtEGgy5Ye5WTkNDFpsMFGsvLa7viQ09FBSLoybrs12Jls+H3G
         9z9MyicL3PlJP1NQZQZHEOqzopBFoMpSJHqB8d1r/DA85oJJFhSal70+02jrzlwNbo1z
         82Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680107353;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9wWrsLlXKWvQA38obw+xbkZDiZxNr9CZXUvW32hk7Zs=;
        b=iG7lvZ6eaMteNACTQdTifLt/0jtLwEAl3VVYCKhE4VDUHJU8Z/oJSFewnLi4EpUGbC
         aTiGA1ZKS05pH/QdbOyI5CkzUgzNyRkgJVfozKuI8KEjc6Fw+PD1nbnN8kCTG3A7MXDz
         3iBBa2GRmNXw88NcOoVEX8Gg7j8gK9B2Eu6i3QC8v9LRRbqs5VCMkFoburDd7SBtmSqm
         6t/mEGwrVrmCoIs9IZVEF/W+jKmWYJJnvq7dakX+U7hKGGozcvwJ0coSjPkD0RAQZZlo
         CZOnIV0lHBazCFinpUA1JDxJUc5MuN/gH8x8rT2bqIbfYVJBBc1ZqOubH2TlvfKQ6KkH
         EA4Q==
X-Gm-Message-State: AAQBX9esZGZDbZmj6pt02DtnEYtfJB6NDWB8WvUPNT7ZR9GX4gP0udY7
	QMiFgHFp3iVyrYyp5VOtaggL9zuZLfgq7h5x+B36YQ==
X-Google-Smtp-Source: AKy350ZORUTybtTmxknrU6U6sDbDJmKms88a0NXHL8s0bQ+Pm9uOWRyP22uljRbj0cRwTCy7wM0LnHGSFCGNhYzF50w=
X-Received: by 2002:a17:902:848d:b0:1a2:1fd0:226b with SMTP id
 c13-20020a170902848d00b001a21fd0226bmr6464831plo.5.1680107352908; Wed, 29 Mar
 2023 09:29:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230329002136.2463442-1-reijiw@google.com> <20230329002136.2463442-2-reijiw@google.com>
 <87v8ikqaib.wl-maz@kernel.org>
In-Reply-To: <87v8ikqaib.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 29 Mar 2023 09:28:56 -0700
Message-ID: <CAAeT=Fx3ZHXwOBoCTAV-Hp4ZG4V_MJfzbmC6zDUk-0M5mP=PnA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, Mar 29, 2023 at 08:31:24AM +0100, Marc Zyngier wrote:
> On Wed, 29 Mar 2023 01:21:35 +0100,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Restore the host's PMUSERENR_EL0 value instead of clearing it,
> > before returning back to userspace, as the host's EL0 might have
> > a direct access to PMU registers (some bits of PMUSERENR_EL0
> > might not be zero).
> >
> > Fixes: 83a7a4d643d3 ("arm64: perf: Enable PMU counter userspace access for perf event")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h       | 3 +++
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 3 ++-
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index bcd774d74f34..82220ecec10e 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -544,6 +544,9 @@ struct kvm_vcpu_arch {
> >
> >     /* Per-vcpu CCSIDR override or NULL */
> >     u32 *ccsidr;
> > +
> > +   /* the value of host's pmuserenr_el0 before guest entry */
> > +   u64     host_pmuserenr_el0;
>
> I don't think we need this in each and every vcpu. Why can't this be
> placed in struct kvm_host_data and accessed via the per-cpu pointer?
> Maybe even use the PMUSERNR_EL0 field in the sysreg array?

Thank you for the nice suggestion.
Indeed, that would be better.  I will fix it in v2.

>
> There is probably a number of things that we could move there, but
> let's start by not adding more unnecessary stuff to the vcpu
> structure.

Yeah, I agree.

Thank you,
Reiji



>
> >  };
> >
> >  /*
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > index 07d37ff88a3f..44b84fbdde0d 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -82,6 +82,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
> >      */
> >     if (kvm_arm_support_pmu_v3()) {
> >             write_sysreg(0, pmselr_el0);
> > +           vcpu->arch.host_pmuserenr_el0 = read_sysreg(pmuserenr_el0);
> >             write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
> >     }
> >
> > @@ -106,7 +107,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
> >
> >     write_sysreg(0, hstr_el2);
> >     if (kvm_arm_support_pmu_v3())
> > -           write_sysreg(0, pmuserenr_el0);
> > +           write_sysreg(vcpu->arch.host_pmuserenr_el0, pmuserenr_el0);
> >
> >     if (cpus_have_final_cap(ARM64_SME)) {
> >             sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
>
> Thanks,
>
>       M.
>
> --
> Without deviation from the norm, progress is not possible.
