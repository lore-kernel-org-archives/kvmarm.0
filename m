Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E25F20F05
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 07:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1692775011; x=1724311011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DjzRqyjeWdMT4yTOwjQ1OB/ZRsANx6ueGhGD1k+8Wik=;
  b=PlGTuSEhFACyngiSNpL3ToxbkFMwEHzPNTMo3Q87sUuMGpnka1ZoRMAr
   0xGcs7o440sBqAQwNDMDw7mn63aZqMZFXz4wMciT2fucbQ9lW1GnBcpuB
   AuCwxygmX9oK65UHPUHKEvkRgSQ1c6L7e+DhXg7ZcnGkjBsfkag/GRJSZ
   IXMVNabsUjm8qzx7VvcD+IHcV4HY14x4AAxcP3rpU8N7A3zTI2aOSvBhI
   t5SencUE+YXw7Mzc4Xv6aC7RpQderNtzoUxTuIallu8K3BqI1Xi0gIQCJ
   lvpqd6ARfgobk1Lu2pPQAlcV1sKcgISMHFRRCChvuhIANKrPeJcL73Fr6
   g==;
X-IronPort-AV: E=Sophos;i="6.01,195,1684792800"; 
   d="scan'208";a="32577938"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 23 Aug 2023 09:15:38 +0200
Received: from steina-w.localnet (steina-w.tq-net.de [10.123.53.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 708F3280075;
	Wed, 23 Aug 2023 09:15:38 +0200 (CEST)
From: Alexander Stein <alexander.stein@ew.tq-group.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>, Huang Shijie <shijie@os.amperecomputing.com>, Leo Yan <leo.yan@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2] KVM: arm64: pmu: Resync EL0 state on counter rotation
Date: Wed, 23 Aug 2023 09:15:38 +0200
Message-ID: <14141350.uLZWGnKmhe@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <20230820090108.177817-1-maz@kernel.org>
References: <20230820090108.177817-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi,

Am Sonntag, 20. August 2023, 11:01:08 CEST schrieb Marc Zyngier:
> Huang Shijie reports that, when profiling a guest from the host
> with a number of events that exceeds the number of available
> counters, the reported counts are wildly inaccurate. Without
> the counter oversubscription, the reported counts are correct.
>=20
> Their investigation indicates that upon counter rotation (which
> takes place on the back of a timer interrupt), we fail to
> re-apply the guest EL0 enabling, leading to the counting of host
> events instead of guest events.
>=20
> In order to solve this, add yet another hook between the host PMU
> driver and KVM, re-applying the guest EL0 configuration if the
> right conditions apply (the host is VHE, we are in interrupt
> context, and we interrupted a running vcpu). This triggers a new
> vcpu request which will apply the correct configuration on guest
> reentry.
>=20
> With this, we have the correct counts, even when the counters are
> oversubscribed.
>=20
> Reported-by: Huang Shijie <shijie@os.amperecomputing.com>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Tested_by: Huang Shijie <shijie@os.amperecomputing.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: Leo Yan <leo.yan@linaro.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Link:
> https://lore.kernel.org/r/20230809013953.7692-1-shijie@os.amperecomputing=
=2Ec
> om ---
>=20
> Notes:
>     V2: Fixed 32bit compilation
>=20
>  arch/arm/include/asm/arm_pmuv3.h  |  2 ++
>  arch/arm64/include/asm/kvm_host.h |  1 +
>  arch/arm64/kvm/arm.c              |  3 +++
>  arch/arm64/kvm/pmu.c              | 18 ++++++++++++++++++
>  drivers/perf/arm_pmuv3.c          |  2 ++
>  include/kvm/arm_pmu.h             |  2 ++
>  6 files changed, 28 insertions(+)
>=20
> diff --git a/arch/arm/include/asm/arm_pmuv3.h
> b/arch/arm/include/asm/arm_pmuv3.h index f3cd04ff022d..72529f5e2bed 100644
> --- a/arch/arm/include/asm/arm_pmuv3.h
> +++ b/arch/arm/include/asm/arm_pmuv3.h
> @@ -227,6 +227,8 @@ static inline bool kvm_set_pmuserenr(u64 val)
>  	return false;
>  }
>=20
> +static inline void kvm_vcpu_pmu_resync_el0(void) {}
> +
>  /* PMU Version in DFR Register */
>  #define ARMV8_PMU_DFR_VER_NI        0
>  #define ARMV8_PMU_DFR_VER_V3P4      0x5
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h index d3dd05bbfe23..553040e0e375 1006=
44
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -49,6 +49,7 @@
>  #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
>  #define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
>  #define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
> +#define KVM_REQ_RESYNC_PMU_EL0	KVM_ARCH_REQ(7)
>=20
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE=
 |
> \ KVM_DIRTY_LOG_INITIALLY_SET)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 72dc53a75d1c..978b0411082f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -803,6 +803,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  			kvm_pmu_handle_pmcr(vcpu,
>  					    __vcpu_sys_reg(vcpu,=20
PMCR_EL0));
>=20
> +		if (kvm_check_request(KVM_REQ_RESYNC_PMU_EL0, vcpu))
> +			kvm_vcpu_pmu_restore_guest(vcpu);
> +
>  		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
>  			return kvm_vcpu_suspend(vcpu);
>=20
> diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
> index 121f1a14c829..0eea225fd09a 100644
> --- a/arch/arm64/kvm/pmu.c
> +++ b/arch/arm64/kvm/pmu.c
> @@ -236,3 +236,21 @@ bool kvm_set_pmuserenr(u64 val)
>  	ctxt_sys_reg(hctxt, PMUSERENR_EL0) =3D val;
>  	return true;
>  }
> +
> +/*
> + * If we interrupted the guest to update the host PMU context, make
> + * sure we re-apply the guest EL0 state.
> + */
> +void kvm_vcpu_pmu_resync_el0(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +
> +	if (!has_vhe() || !in_interrupt())
> +		return;
> +
> +	vcpu =3D kvm_get_running_vcpu();
> +	if (!vcpu)
> +		return;
> +
> +	kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
> +}
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 08b3a1bf0ef6..6a3d8176f54a 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -772,6 +772,8 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
>=20
>  	/* Enable all counters */
>  	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
> +
> +	kvm_vcpu_pmu_resync_el0();

This breaks if CONFIG_HW_PERF_EVENTS is enabled but CONFIG_KVM is not. As i=
n=20
this case arch/arm64/kvm/pmu.c is never compiled, but the dummy inline in=20
include/kvm/arm_pmu.h for kvm_vcpu_pmu_resync_el0() only depends on=20
CONFIG_HW_PERF_EVENTS.
This results in this error:

aarch64-v8a-linux-gnu-ld: Unexpected GOT/PLT entries detected!
aarch64-v8a-linux-gnu-ld: Unexpected run-time procedure linkages detected!
aarch64-v8a-linux-gnu-ld: drivers/perf/arm_pmuv3.o: in function=20
`armv8pmu_start':
drivers/perf/arm_pmuv3.c:753: undefined reference to `kvm_vcpu_pmu_resync_e=
l0'

Best regards,
Alexander

>  }
>=20
>  static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 847da6fc2713..3a8a70a60794 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -74,6 +74,7 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
>  struct kvm_pmu_events *kvm_get_pmu_events(void);
>  void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> +void kvm_vcpu_pmu_resync_el0(void);
>=20
>  #define kvm_vcpu_has_pmu(vcpu)				=09
\
>  	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
> @@ -171,6 +172,7 @@ static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
>  {
>  	return 0;
>  }
> +static inline void kvm_vcpu_pmu_resync_el0(void) {}
>=20
>  #endif


=2D-=20
TQ-Systems GmbH | M=FChlstra=DFe 2, Gut Delling | 82229 Seefeld, Germany
Amtsgericht M=FCnchen, HRB 105018
Gesch=E4ftsf=FChrer: Detlef Schneider, R=FCdiger Stahl, Stefan Schneider
http://www.tq-group.com/


