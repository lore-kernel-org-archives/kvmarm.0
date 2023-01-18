Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E567723A7
	for <kvmarm@lists.linux.dev>; Wed, 18 Jan 2023 05:53:30 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id y3-20020a17090a390300b00229add7bb36so1121453pjb.4
        for <kvmarm@lists.linux.dev>; Tue, 17 Jan 2023 21:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wahhz162cGALETeb/ISZLg8Fhmw0Fj3kLf5lRSh9VZM=;
        b=GvcDFbzXPkGbkEKZrNUtBEp9Rg2IsP8T5gSRRo4uGLyjFexdd9XSDGNM4Uw1GQ/Ae9
         aI/W7ey2axc3Cnmn6+GxStsjMuIvc4n2lZtL3vsQ/AATXG5LzV7ngtFFZl/8jJnwWaRF
         BF4DpyqbWYEWMYoNarqDgWbsuqZzOSEqbsjKjX08DsKbk0eU2Cb6mmrE1UP4Glnp4E5f
         MNOdcWXdVW1uHe2TfRhzulok8BCWK4ww3Wze+g+xkogaNeFYM7CePz031w+T3rLVxSnt
         NFz4pqCSJkLgsk2v8uASyvRoci0/OfPR0OPhBoHJkfBndpujD8Pp2xx0Znbyetyz1tag
         JXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wahhz162cGALETeb/ISZLg8Fhmw0Fj3kLf5lRSh9VZM=;
        b=ulwdDXoiNYlCFD0LpogUbzRYO+t44MY7/o08ITlfBuVwyswsX9xKmcKTOeqB7WM4Nk
         3mex9MTxlOl+gOuB2uqyc/gJiaU4faryRIIV23WLcesc9q48ImlilLoX/p/6Ob3jaj7b
         +VtyuTUdzV2rtzRtXE3Ebtl75RwXocwJxxshYfzn2JNcgZBRWCjy0wMN5UsKtWGllI3E
         UCKfj7Tt0+cYNwEhA8X3Cc1yBtr9iTLysFo3dCjqAI1HMdDP9NFSgaA/B6pB3gSUGzqS
         bWZLyRA3/lFY5dveOYILEvEnvpmU0886UOYniTVGmAeTxh0PUsVYyzI9gxnuS7aOBOV/
         6gcg==
X-Gm-Message-State: AFqh2krVzkNPBoLubWfdwckgR5Ip1TzqhATGbT0zQXgi0vjQ5i6MNYK0
	cVUvsFc+48hU/UXtDEUy2HH3kf+Iex5kwJQff9ZUZw==
X-Google-Smtp-Source: AMrXdXuP1ogMpHwdRh8FHVtzRB3m/jt9X03RZQAcnQdwF6D5j30DJzC633Pz+N1kJMop9GmbAY4Yh87/hvbAoLs6xJk=
X-Received: by 2002:a17:90a:8546:b0:227:1d0b:5379 with SMTP id
 a6-20020a17090a854600b002271d0b5379mr497896pjw.103.1674021210146; Tue, 17 Jan
 2023 21:53:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230117013542.371944-1-reijiw@google.com> <ce52d9fc-cd1f-9863-0f3a-b83eb0c36e5d@redhat.com>
In-Reply-To: <ce52d9fc-cd1f-9863-0f3a-b83eb0c36e5d@redhat.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 17 Jan 2023 21:53:13 -0800
Message-ID: <CAAeT=Fwj3cqLupv-L05JxP6XEUGJMoHYq6PuOYb0gXfvj8B-ww@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] KVM: arm64: PMU: Allow userspace to limit the
 number of PMCs on vCPU
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Jing Zhang <jingzhangos@google.com>, Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Shaoqin,

> I have tested this patch set on an Ampere machine, and every thing works
> fine.
>
>
> Tested-by: Shaoqin Huang <shahuang@redhat.com>

Thank you for testing the series!
Reiji


>
> On 1/17/23 09:35, Reiji Watanabe wrote:
> > The goal of this series is to allow userspace to limit the number
> > of PMU event counters on the vCPU. We need this to support migration
> > across systems that implement different numbers of counters.
> >
> > The number of PMU event counters is indicated in PMCR_EL0.N.
> > For a vCPU with PMUv3 configured, its value will be the same as
> > the host value by default. Userspace can set PMCR_EL0.N for the
> > vCPU to a lower value than the host value, using KVM_SET_ONE_REG.
> > However, it is practically unsupported, as KVM resets PMCR_EL0.N
> > to the host value on vCPU reset and some KVM code uses the host
> > value to identify (un)implemented event counters on the vCPU.
> >
> > This series will ensure that the PMCR_EL0.N value is preserved
> > on vCPU reset and that KVM doesn't use the host value
> > to identify (un)implemented event counters on the vCPU.
> > This allows userspace to limit the number of the PMU event
> > counters on the vCPU.
> >
> > Patch 1 fixes reset_pmu_reg() to ensure that (RAZ) bits of
> > {PMCNTEN,PMOVS}{SET,CLR}_EL1 corresponding to unimplemented event
> > counters on the vCPU are reset to zero even when PMCR_EL0.N for
> > the vCPU is different from the host.
> >
> > Patch 2 is a minor refactoring to use the default PMU register reset
> > function (reset_pmu_reg()) for PMUSERENR_EL0 and PMCCFILTR_EL0.
> > (With the Patch 1 change, reset_pmu_reg() can now be used for
> > those registers)
> >
> > Patch 3 fixes reset_pmcr() to preserve PMCR_EL0.N for the vCPU on
> > vCPU reset.
> >
> > Patch 4 adds the sys_reg's set_user() handler for the PMCR_EL0
> > to disallow userspace to set PMCR_EL0.N for the vCPU to a value
> > that is greater than the host value.
> >
> > Patch 5-8 adds a selftest to verify reading and writing PMU registers
> > for implemented or unimplemented PMU event counters on the vCPU.
> >
> > The series is based on v6.2-rc4.
> >
> > v2:
> >   - Added the sys_reg's set_user() handler for the PMCR_EL0 to
> >     disallow userspace to set PMCR_EL0.N for the vCPU to a value
> >     that is greater than the host value (and added a new test
> >     case for this behavior). [Oliver]
> >   - Added to the commit log of the patch 2 that PMUSERENR_EL0 and
> >     PMCCFILTR_EL0 have UNKNOWN reset values.
> >
> > v1: https://lore.kernel.org/all/20221230035928.3423990-1-reijiw@google.com/
> >
> > Reiji Watanabe (8):
> >    KVM: arm64: PMU: Have reset_pmu_reg() to clear a register
> >    KVM: arm64: PMU: Use reset_pmu_reg() for PMUSERENR_EL0 and
> >      PMCCFILTR_EL0
> >    KVM: arm64: PMU: Preserve vCPU's PMCR_EL0.N value on vCPU reset
> >    KVM: arm64: PMU: Disallow userspace to set PMCR.N greater than the
> >      host value
> >    tools: arm64: Import perf_event.h
> >    KVM: selftests: aarch64: Introduce vpmu_counter_access test
> >    KVM: selftests: aarch64: vPMU register test for implemented counters
> >    KVM: selftests: aarch64: vPMU register test for unimplemented counters
> >
> >   arch/arm64/kvm/pmu-emul.c                     |   6 +
> >   arch/arm64/kvm/sys_regs.c                     |  57 +-
> >   tools/arch/arm64/include/asm/perf_event.h     | 258 +++++++
> >   tools/testing/selftests/kvm/Makefile          |   1 +
> >   .../kvm/aarch64/vpmu_counter_access.c         | 644 ++++++++++++++++++
> >   .../selftests/kvm/include/aarch64/processor.h |   1 +
> >   6 files changed, 954 insertions(+), 13 deletions(-)
> >   create mode 100644 tools/arch/arm64/include/asm/perf_event.h
> >   create mode 100644 tools/testing/selftests/kvm/aarch64/vpmu_counter_access.c
> >
> >
> > base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
>
> --
> Regards,
> Shaoqin
>
