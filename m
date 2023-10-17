Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714CE3D3A8
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 17:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W99mATUJ"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1c9d4f08d7cso10945ad.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 10:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697562667; x=1698167467; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYRiu9lSScYzjuPNTRfPjUaha4Cty0VP8HNHJXHNDls=;
        b=W99mATUJJC2ZI9s7VVyp8CDbC2uGI6bk/x0woYsI3v0xbfluHE47OaH5ZeVhyARQmV
         PpCRDmZ2yOf17qX8woC1SZe1pMFdI8UkeDImwOSS5uDsS9hsZiAgvjarv7up27Ey38xD
         WXzXFAQiz2rkcvZ6boseEesCQa/gl+NT9zbBI50gVwLdTnf7bhTouxKlpTN61lkHMQWX
         2ttTSO1YZj6FzgzG/hyvaWzViYrspCdRmJ7sg1pVuFspLyz11nKZylsqm3Yz3pgKAlZP
         3uWaXEl5hCOIiaccTYnFid7Kxu8mSOueDtilzSyhaHK0oWwus1ZtxCLY0cwypfBfrFIu
         e89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697562667; x=1698167467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYRiu9lSScYzjuPNTRfPjUaha4Cty0VP8HNHJXHNDls=;
        b=R4YOLJjFhgydTMy7q86fMO8+RkaAmfnhl9aRYiNSBgDFvrZTJf7zkzL5S0tE6BUdN4
         k36Y/kf7Ur2oWeoGm8Fs8v0nnTgf3OIRmP1BEakP18j/EYKtsN6qi3cQkuopk42sLa2Z
         xlI6dtYSChP44mRBwTw5YK5SrJD2ZiliSRRgZhDWT1mzCni6TG2BhjcBEWJ73MfwEygV
         c0mHmwVXJBl/LETSfCZziMdwq0+tFBmMucj1mxDZxxrPlmauiOcZgzNADbSWULmdGGwL
         weC0p8/TPQ6aNUTKw+H61G1NfPsWtXcsjvIBoJJqcsCBEozRakPQ/QJA2fCt643ss2eo
         g5hg==
X-Gm-Message-State: AOJu0YwmEm4+WT2nFTu+OKD+Ba+tFyOm8YwHiPYcJAjMDgase1RG7mIQ
	kCmmbb2L+kZaBdgbriGNwiY+zGoWTmL/Zg6eD2aLQA==
X-Google-Smtp-Source: AGHT+IFRYWvFaJ0WInRTJyr+F9zMf0+RQKXl4mnaUaW2eO670fDT8aRdRXn0jZoCF3qiP5KSAr97AZqkZIqNS1w8Bx0=
X-Received: by 2002:a17:902:6b47:b0:1c9:d7d8:862c with SMTP id
 g7-20020a1709026b4700b001c9d7d8862cmr17098plt.10.1697562667428; Tue, 17 Oct
 2023 10:11:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-11-rananta@google.com>
 <e0fdb0ea-2f08-6343-1765-afe32510f3a7@redhat.com>
In-Reply-To: <e0fdb0ea-2f08-6343-1765-afe32510f3a7@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 17 Oct 2023 10:10:55 -0700
Message-ID: <CAJHc60wQuCM_H_ksSWUdCjJj30Stzn1aEr4=jvzqM0ZvhuN5gQ@mail.gmail.com>
Subject: Re: [PATCH v7 10/12] KVM: selftests: aarch64: Introduce
 vpmu_counter_access test
To: Sebastian Ott <sebott@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17, 2023 at 8:48=E2=80=AFAM Sebastian Ott <sebott@redhat.com> w=
rote:
>
> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> > +static void guest_code(uint64_t expected_pmcr_n)
> > +{
> > +     uint64_t pmcr, pmcr_n;
> > +
> > +     __GUEST_ASSERT(expected_pmcr_n <=3D ARMV8_PMU_MAX_GENERAL_COUNTER=
S,
> > +                     "Expected PMCR.N: 0x%lx; ARMv8 general counters: =
0x%lx",
> > +                     expected_pmcr_n, ARMV8_PMU_MAX_GENERAL_COUNTERS);
> > +
> > +     pmcr =3D read_sysreg(pmcr_el0);
> > +     pmcr_n =3D get_pmcr_n(pmcr);
> > +
> > +     /* Make sure that PMCR_EL0.N indicates the value userspace set */
> > +     __GUEST_ASSERT(pmcr_n =3D=3D expected_pmcr_n,
> > +                     "Expected PMCR.N: 0x%lx, PMCR.N: 0x%lx",
> > +                     pmcr_n, expected_pmcr_n);
>
> Expected vs read value is swapped.
>
Good catch! I'll fix this in v8.
>
> Also, since the kernel has special handling for this, should we add a
> test like below?
>
> +static void immutable_test(void)
> +{
> +       struct kvm_vcpu *vcpu;
> +       uint64_t sp, pmcr, pmcr_n;
> +       struct kvm_vcpu_init init;
> +
> +       create_vpmu_vm(guest_code);
> +
> +       vcpu =3D vpmu_vm.vcpu;
> +
> +       /* Save the initial sp to restore them later to run the guest aga=
in */
> +       vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1), &sp);
> +
> +       vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), &pmcr);
> +       pmcr_n =3D get_pmcr_n(pmcr);
> +
> +       run_vcpu(vcpu, pmcr_n);
> +
> +       vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
> +       init.features[0] |=3D (1 << KVM_ARM_VCPU_PMU_V3);
> +       aarch64_vcpu_setup(vcpu, &init);
> +       vcpu_init_descriptor_tables(vcpu);
> +       vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
> +       vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code)=
;
> +
> +       /* Update the PMCR_EL0.N after the VM ran once */
> +       set_pmcr_n(&pmcr, 0);
> +       vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
> +
> +       /* Verify that the guest still gets the unmodified value */
> +       run_vcpu(vcpu, pmcr_n);
> +
> +       destroy_vpmu_vm();
> +}
Thanks for the suggestion! I'll add this test case in v8.

- Raghavendra
>
