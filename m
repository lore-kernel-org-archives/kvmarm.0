Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4138B287514
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 08:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747988860; cv=none; b=V7MX5wU3Lg8ItlY0nuggDy0OYVidhariAVlV4Yrrk7MbgW+kFOwbR/Yqi+6/r1GbPTpqKLHwFEI+L56Iq3UfPuy4EQPlog4S59cpNK6ajlNcVhHwIb0U52Gl5Y08gv7TvlgbEzMyGZwVOh5nlPGR5USBayZfZYupNNAwAaW7UC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747988860; c=relaxed/simple;
	bh=yoz1CMwg1Hl+8wxEhjbOD1aVanuzL5EIlc5ujdcmh88=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mnv9AF6qqG4S1zkbRz67Nj7Tsf+SPuPwW7PHmHgdNj4YU8LL4hEi7K9ONy1sJvECk84TMdZG7C29F2LI20n/yxRoX+BVp04hQEzjtFizjBXjckBqxdSTX54xWwkABxQMWhJyegAqgJIdE4f9mSKr6DQDxZhUZgmZcY7/kSmrcmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4b3dVT2ZLRz6L5BG;
	Fri, 23 May 2025 16:24:17 +0800 (CST)
Received: from frapeml100005.china.huawei.com (unknown [7.182.85.132])
	by mail.maildlp.com (Postfix) with ESMTPS id 5B9451402FF;
	Fri, 23 May 2025 16:27:34 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 frapeml100005.china.huawei.com (7.182.85.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 23 May 2025 10:27:34 +0200
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Fri, 23 May 2025 10:27:34 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Cornelia Huck <cohuck@redhat.com>, "eric.auger.pro@gmail.com"
	<eric.auger.pro@gmail.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "qemu-arm@nongnu.org"
	<qemu-arm@nongnu.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"richard.henderson@linaro.org" <richard.henderson@linaro.org>,
	"alex.bennee@linaro.org" <alex.bennee@linaro.org>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"sebott@redhat.com" <sebott@redhat.com>, "armbru@redhat.com"
	<armbru@redhat.com>, "berrange@redhat.com" <berrange@redhat.com>,
	"abologna@redhat.com" <abologna@redhat.com>, "jdenemar@redhat.com"
	<jdenemar@redhat.com>
CC: "agraf@csgraf.de" <agraf@csgraf.de>, "shahuang@redhat.com"
	<shahuang@redhat.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>,
	"philmd@linaro.org" <philmd@linaro.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: RE: [PATCH v3 06/10] arm/kvm: Allow reading all the writable ID
 registers
Thread-Topic: [PATCH v3 06/10] arm/kvm: Allow reading all the writable ID
 registers
Thread-Index: AQHbrVwDcXqCrMgzAUqDqJzZ5+FsArPgHVQw
Date: Fri, 23 May 2025 08:27:34 +0000
Message-ID: <ee2e2631faf640f3807c08c6acd95732@huawei.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-7-cohuck@redhat.com>
In-Reply-To: <20250414163849.321857-7-cohuck@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Monday, April 14, 2025 5:39 PM
> To: eric.auger.pro@gmail.com; eric.auger@redhat.com; qemu-
> devel@nongnu.org; qemu-arm@nongnu.org; kvmarm@lists.linux.dev;
> peter.maydell@linaro.org; richard.henderson@linaro.org;
> alex.bennee@linaro.org; maz@kernel.org; oliver.upton@linux.dev;
> sebott@redhat.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; armbru@redhat.com;
> berrange@redhat.com; abologna@redhat.com; jdenemar@redhat.com
> Cc: agraf@csgraf.de; shahuang@redhat.com; mark.rutland@arm.com;
> philmd@linaro.org; pbonzini@redhat.com; Cornelia Huck
> <cohuck@redhat.com>
> Subject: [PATCH v3 06/10] arm/kvm: Allow reading all the writable ID
> registers
>=20
> From: Eric Auger <eric.auger@redhat.com>
>=20
> At the moment kvm_arm_get_host_cpu_features() reads a subset of the
> ID regs. As we want to introduce properties for all writable ID reg
> fields, we want more genericity and read more default host register
> values.
>=20
> Introduce a new get_host_cpu_idregs() helper and add a new exhaustive
> boolean parameter to kvm_arm_get_host_cpu_features() and
> kvm_arm_set_cpu_features_from_host() to select the right behavior.
> The host cpu model will keep the legacy behavior unless the writable
> id register interface is available.
>=20
> A writable_map IdRegMap is introduced in the CPU object. A subsequent
> patch will populate it.
>=20
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu-sysregs.h |  2 ++
>  target/arm/cpu.h         |  3 ++
>  target/arm/cpu64.c       |  2 +-
>  target/arm/kvm.c         | 78 ++++++++++++++++++++++++++++++++++++++--
>  target/arm/kvm_arm.h     |  9 +++--
>  target/arm/trace-events  |  1 +
>  6 files changed, 89 insertions(+), 6 deletions(-)
>=20
> diff --git a/target/arm/cpu-sysregs.h b/target/arm/cpu-sysregs.h
> index e89a1105904c..367fab51f19e 100644
> --- a/target/arm/cpu-sysregs.h
> +++ b/target/arm/cpu-sysregs.h
> @@ -41,6 +41,8 @@ int get_sysreg_idx(ARMSysRegs sysreg);
>=20
>  #ifdef CONFIG_KVM
>  uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg);
> +int kvm_idx_to_idregs_idx(int kidx);
> +int idregs_idx_to_kvm_idx(ARMIDRegisterIdx idx);
>  #endif
>=20
>  #endif /* ARM_CPU_SYSREGS_H */
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 775a8aebc5d3..8717c5e7695b 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -1088,6 +1088,9 @@ struct ArchCPU {
>       */
>      ARMIdRegsState writable_id_regs;
>=20
> +    /* ID reg writable bitmask (KVM only) */
> +    IdRegMap *writable_map;
> +
>      /* QOM property to indicate we should use the back-compat CNTFRQ
> default */
>      bool backcompat_cntfrq;
>=20
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index 839442745ea4..60a709502697 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -757,7 +757,7 @@ static void aarch64_host_initfn(Object *obj)
>  {
>  #if defined(CONFIG_KVM)
>      ARMCPU *cpu =3D ARM_CPU(obj);
> -    kvm_arm_set_cpu_features_from_host(cpu);
> +    kvm_arm_set_cpu_features_from_host(cpu, false);
>      if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
>          aarch64_add_sve_properties(obj);
>          aarch64_add_pauth_properties(obj);
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 6e3cd06e9bc5..b07d5f16db50 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -41,6 +41,7 @@
>  #include "hw/acpi/ghes.h"
>  #include "target/arm/gtimer.h"
>  #include "migration/blocker.h"
> +#include "cpu-custom.h"
>=20
>  const KVMCapabilityInfo kvm_arch_required_capabilities[] =3D {
>      KVM_CAP_INFO(DEVICE_CTRL),
> @@ -270,7 +271,73 @@ static int get_host_cpu_reg(int fd,
> ARMHostCPUFeatures *ahcf, ARMIDRegisterIdx i
>      return ret;
>  }
>=20
> -static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
> +int kvm_idx_to_idregs_idx(int kidx)
> +{
> +    int op1, crm, op2;
> +    ARMSysRegs sysreg;
> +
> +    op1 =3D kidx / 64;
> +    if (op1 =3D=3D 2) {
> +        op1 =3D 3;
> +    }
> +    crm =3D (kidx % 64) / 8;
> +    op2 =3D kidx % 8;
> +    sysreg =3D ENCODE_ID_REG(3, op1, 0, crm, op2);
> +    return get_sysreg_idx(sysreg);
> +}
> +
> +int idregs_idx_to_kvm_idx(ARMIDRegisterIdx idx)
> +{
> +    ARMSysRegs sysreg =3D id_register_sysreg[idx];
> +
> +    return KVM_ARM_FEATURE_ID_RANGE_IDX((sysreg &
> CP_REG_ARM64_SYSREG_OP0_MASK) >>
> CP_REG_ARM64_SYSREG_OP0_SHIFT,
> +                                        (sysreg & CP_REG_ARM64_SYSREG_OP=
1_MASK) >>
> CP_REG_ARM64_SYSREG_OP1_SHIFT,
> +                                        (sysreg & CP_REG_ARM64_SYSREG_CR=
N_MASK) >>
> CP_REG_ARM64_SYSREG_CRN_SHIFT,
> +                                        (sysreg & CP_REG_ARM64_SYSREG_CR=
M_MASK) >>
> CP_REG_ARM64_SYSREG_CRM_SHIFT,
> +                                        (sysreg & CP_REG_ARM64_SYSREG_OP=
2_MASK) >>
> CP_REG_ARM64_SYSREG_OP2_SHIFT);
> +}
> +
> +
> +/*
> + * get_host_cpu_idregs: Read all the writable ID reg host values
> + *
> + * Need to be called once the writable mask has been populated
> + * Note we may want to read all the known id regs but some of them are
> not
> + * writable and return an error, hence the choice of reading only those
> which
> + * are writable. Those are also readable!
> + */
> +static int get_host_cpu_idregs(ARMCPU *cpu, int fd, ARMHostCPUFeatures
> *ahcf)
> +{
> +    int err =3D 0;
> +    int i;
> +
> +    for (i =3D 0; i < NUM_ID_IDX; i++) {
> +        ARM64SysReg *sysregdesc =3D &arm64_id_regs[i];
> +        ARMSysRegs sysreg =3D sysregdesc->sysreg;
> +        uint64_t writable_mask =3D cpu->writable_map-
> >regs[idregs_idx_to_kvm_idx(i)];
> +        uint64_t *reg;
> +        int ret;
> +
> +        if (!writable_mask) {
> +            continue;
> +        }
> +
> +        reg =3D &ahcf->isar.idregs[i];
> +        ret =3D read_sys_reg64(fd, reg, idregs_sysreg_to_kvm_reg(sysreg)=
);

I think we can use get_host_cpu_reg() here.

> +        trace_get_host_cpu_idregs(sysregdesc->name, *reg);
> +        if (ret) {
> +            error_report("%s error reading value of host %s register (%m=
)",
> +                         __func__, sysregdesc->name);
> +
> +            err =3D ret;
> +        }
> +    }
> +    return err;
> +}
> +
> +static bool
> +kvm_arm_get_host_cpu_features(ARMCPU *cpu, ARMHostCPUFeatures
> *ahcf,
> +                              bool exhaustive)
>  {
>      /* Identify the feature bits corresponding to the host CPU, and
>       * fill out the ARMHostCPUClass fields accordingly. To do this
> @@ -398,6 +465,11 @@ static bool
> kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>          err |=3D get_host_cpu_reg(fd, ahcf, ID_DFR1_EL1_IDX);
>          err |=3D get_host_cpu_reg(fd, ahcf, ID_MMFR5_EL1_IDX);
>=20
> +        /* Make sure writable ID reg values are read */
> +        if (exhaustive) {
> +            err |=3D get_host_cpu_idregs(cpu, fd, ahcf);
> +        }


Also if we do this a bit above can we avoid reading the ID registers twice
if "exhaustive=3Dtrue" ?

Thanks,
Shameer

> +
>          /*
>           * DBGDIDR is a bit complicated because the kernel doesn't
>           * provide an accessor for it in 64-bit mode, which is what this
> @@ -467,13 +539,13 @@ static bool
> kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>      return true;
>  }
>=20
> -void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
> +void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool
> exhaustive)
>  {
>      CPUARMState *env =3D &cpu->env;
>=20
>      if (!arm_host_cpu_features.dtb_compatible) {
>          if (!kvm_enabled() ||
> -            !kvm_arm_get_host_cpu_features(&arm_host_cpu_features)) {
> +            !kvm_arm_get_host_cpu_features(cpu, &arm_host_cpu_features,
> exhaustive)) {
>              /* We can't report this error yet, so flag that we need to
>               * in arm_cpu_realizefn().
>               */
> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
> index 8d1f20ca8d89..90ba4f7d8987 100644
> --- a/target/arm/kvm_arm.h
> +++ b/target/arm/kvm_arm.h
> @@ -141,8 +141,12 @@ uint32_t kvm_arm_sve_get_vls(ARMCPU *cpu);
>   *
>   * Set up the ARMCPU struct fields up to match the information probed
>   * from the host CPU.
> + *
> + * @cpu: cpu object
> + * @exhaustive: if true, all the feature ID regs are queried instead of
> + *              a subset
>   */
> -void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu);
> +void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu, bool
> exhaustive);
>=20
>  /**
>   * kvm_arm_add_vcpu_properties:
> @@ -257,7 +261,8 @@ static inline int
> kvm_arm_get_writable_id_regs(ARMCPU *cpu, IdRegMap *idregmap)
>  /*
>   * These functions should never actually be called without KVM support.
>   */
> -static inline void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu)
> +static inline void kvm_arm_set_cpu_features_from_host(ARMCPU *cpu,
> +                                                      bool exhaustive)
>  {
>      g_assert_not_reached();
>  }
> diff --git a/target/arm/trace-events b/target/arm/trace-events
> index 4438dce7becc..17e52c0705f2 100644
> --- a/target/arm/trace-events
> +++ b/target/arm/trace-events
> @@ -13,3 +13,4 @@ arm_gt_update_irq(int timer, int irqstate)
> "gt_update_irq: timer %d irqstate %d"
>=20
>  # kvm.c
>  kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova =3D
> 0x%"PRIx64" is translated into 0x%"PRIx64
> +get_host_cpu_idregs(const char *name, uint64_t value) "scratch vcpu host
> value for %s is 0x%"PRIx64
> --
> 2.49.0
>=20

