Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE6319CC39
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747152692; cv=none; b=eAoRfEzsXs4VmvCxheBxlgw/nGDRa9q9GP2QYiGSxmoNf1hr0W9RJLjq6XP8sA/wlkdZTZAvI26w5JPhbpN2q6N6yR6TXtlj29UC9EQLDt402mfTA7YMkUUFKm9XWWxCHXGCRkNHhqMbf8LRCjh0Q3FjggYy+ypAdjGpLZobzd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747152692; c=relaxed/simple;
	bh=dQI7X15mbfRC1OcPFqkYdGuhmfe/68j3mR8qIPt8VAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfTeKavWVVfQTjxlFG/MSccSF2vcTPfstZFF6hROOJKlgEvv3PyyteSfwLE/5FGUoJMMs8+RDJr9S+MOECfrSzXzqL48H6tj3g6DLo+nT0CWdC68II/mZk7hlhCbtdy0bmFTgFpAXQ4Kj4P3V+8Ij24+0qHwqvXAdzdHbSV+Kus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VcvHhYtl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VcvHhYtl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747152688;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=E6YVLOivsbJttgznjmSdEd0Qrw27d6HhS8sZ/7Y4I10=;
	b=VcvHhYtlwL4TXpCweN+XkWrgUJ5iNgNwG4GE46g2X0H5wou7LcvxZ3dxn1YdY/3Ajb7FAZ
	trDTqXBO3wwTmvPsIT+LaPiGFIhrpivwaNy0cc84cJn3gd4/atrJPLppkzDDjUmPAYtBC3
	+aJgLFx1a/lnOlJZ+Im8dides/ByPLA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-FZ3bEx1jMV2MmJDsC0NyNg-1; Tue,
 13 May 2025 12:11:25 -0400
X-MC-Unique: FZ3bEx1jMV2MmJDsC0NyNg-1
X-Mimecast-MFC-AGG-ID: FZ3bEx1jMV2MmJDsC0NyNg_1747152683
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCC3219560AF;
	Tue, 13 May 2025 16:11:22 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.110])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FADD1953B82;
	Tue, 13 May 2025 16:11:14 +0000 (UTC)
Date: Tue, 13 May 2025 17:11:10 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
	philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v6 02/14] arm/cpu: Store aa64isar0/aa64zfr0 into the
 idregs arrays
Message-ID: <aCNvHgB0dzJIQ8Yt@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250506085234.855779-1-cohuck@redhat.com>
 <20250506085234.855779-3-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250506085234.855779-3-cohuck@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Tue, May 06, 2025 at 10:52:22AM +0200, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
> 
> Also add kvm accessors for storing host features into idregs.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/cpu-features.h | 57 ++++++++++++++++++++-------------------
>  target/arm/cpu.c          | 10 +++----
>  target/arm/cpu.h          |  2 --
>  target/arm/cpu64.c        |  8 +++---
>  target/arm/helper.c       |  6 +++--
>  target/arm/hvf/hvf.c      |  3 ++-
>  target/arm/kvm.c          | 30 ++++++++++++++++++---
>  target/arm/tcg/cpu64.c    | 44 ++++++++++++++++++------------
>  8 files changed, 97 insertions(+), 63 deletions(-)
> 

> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 5e951675c606..dc4b6edaa1d6 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -2225,12 +2226,9 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
>      }
>  
>      if (!cpu->has_neon && !cpu->has_vfp) {
> -        uint64_t t;

Premature removal because ....

>          uint32_t u;
>  
> -        t = cpu->isar.id_aa64isar0;
> -        t = FIELD_DP64(t, ID_AA64ISAR0, FHM, 0);
> -        cpu->isar.id_aa64isar0 = t;
> +        FIELD_DP64_IDREG(isar, ID_AA64ISAR0, FHM, 0);
>  
>          t = cpu->isar.id_aa64isar1;

...it is still used here and so breaks the build.

Your next patch removes this line, so just need
to shift the variable removal to the next patch

>          t = FIELD_DP64(t, ID_AA64ISAR1, FRINTTS, 0);
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 2b1b46475b13..06745d1fc576 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -1077,7 +1077,6 @@ struct ArchCPU {
>          uint32_t dbgdidr;
>          uint32_t dbgdevid;
>          uint32_t dbgdevid1;
> -        uint64_t id_aa64isar0;
>          uint64_t id_aa64isar1;
>          uint64_t id_aa64isar2;
>          uint64_t id_aa64pfr0;
> @@ -1088,7 +1087,6 @@ struct ArchCPU {
>          uint64_t id_aa64mmfr3;
>          uint64_t id_aa64dfr0;
>          uint64_t id_aa64dfr1;
> -        uint64_t id_aa64zfr0;
>          uint64_t id_aa64smfr0;
>          uint64_t reset_pmcr_el0;
>          uint64_t idregs[NUM_ID_IDX];
> diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
> index e3fdff92c1b4..266f7434556c 100644
> --- a/target/arm/cpu64.c
> +++ b/target/arm/cpu64.c
> @@ -136,7 +136,7 @@ void arm_cpu_sve_finalize(ARMCPU *cpu, Error **errp)
>               * SVE is disabled and so are all vector lengths.  Good.
>               * Disable all SVE extensions as well.
>               */
> -            cpu->isar.id_aa64zfr0 = 0;
> +            SET_IDREG(&cpu->isar, ID_AA64ZFR0, 0);
>              return;
>          }
>  
> @@ -639,6 +639,7 @@ void arm_cpu_lpa2_finalize(ARMCPU *cpu, Error **errp)
>  static void aarch64_a57_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,cortex-a57";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -676,7 +677,7 @@ static void aarch64_a57_initfn(Object *obj)
>      cpu->isar.id_isar6 = 0;
>      cpu->isar.id_aa64pfr0 = 0x00002222;
>      cpu->isar.id_aa64dfr0 = 0x10305106;
> -    cpu->isar.id_aa64isar0 = 0x00011120;
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
>      cpu->isar.id_aa64mmfr0 = 0x00001124;
>      cpu->isar.dbgdidr = 0x3516d000;
>      cpu->isar.dbgdevid = 0x01110f13;
> @@ -700,6 +701,7 @@ static void aarch64_a57_initfn(Object *obj)
>  static void aarch64_a53_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,cortex-a53";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -737,7 +739,7 @@ static void aarch64_a53_initfn(Object *obj)
>      cpu->isar.id_isar6 = 0;
>      cpu->isar.id_aa64pfr0 = 0x00002222;
>      cpu->isar.id_aa64dfr0 = 0x10305106;
> -    cpu->isar.id_aa64isar0 = 0x00011120;
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
>      cpu->isar.id_aa64mmfr0 = 0x00001122; /* 40 bit physical addr */
>      cpu->isar.dbgdidr = 0x3516d000;
>      cpu->isar.dbgdevid = 0x00110f13;
> diff --git a/target/arm/helper.c b/target/arm/helper.c
> index 7fb6e8863064..dae27144cd94 100644
> --- a/target/arm/helper.c
> +++ b/target/arm/helper.c
> @@ -7754,6 +7754,8 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>  {
>      /* Register all the coprocessor registers based on feature bits */
>      CPUARMState *env = &cpu->env;
> +    ARMISARegisters *isar = &cpu->isar;
> +
>      if (arm_feature(env, ARM_FEATURE_M)) {
>          /* M profile has no coprocessor registers */
>          return;
> @@ -7943,7 +7945,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 4,
>                .access = PL1_R, .type = ARM_CP_CONST,
>                .accessfn = access_aa64_tid3,
> -              .resetvalue = cpu->isar.id_aa64zfr0 },
> +              .resetvalue = GET_IDREG(isar, ID_AA64ZFR0)},
>              { .name = "ID_AA64SMFR0_EL1", .state = ARM_CP_STATE_AA64,
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 4, .opc2 = 5,
>                .access = PL1_R, .type = ARM_CP_CONST,
> @@ -8003,7 +8005,7 @@ void register_cp_regs_for_features(ARMCPU *cpu)
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 6, .opc2 = 0,
>                .access = PL1_R, .type = ARM_CP_CONST,
>                .accessfn = access_aa64_tid3,
> -              .resetvalue = cpu->isar.id_aa64isar0 },
> +              .resetvalue = GET_IDREG(isar, ID_AA64ISAR0)},
>              { .name = "ID_AA64ISAR1_EL1", .state = ARM_CP_STATE_AA64,
>                .opc0 = 3, .opc1 = 0, .crn = 0, .crm = 6, .opc2 = 1,
>                .access = PL1_R, .type = ARM_CP_CONST,
> diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
> index 34ca36fab556..7999a6ab536f 100644
> --- a/target/arm/hvf/hvf.c
> +++ b/target/arm/hvf/hvf.c
> @@ -19,6 +19,7 @@
>  #include "system/hw_accel.h"
>  #include "hvf_arm.h"
>  #include "cpregs.h"
> +#include "cpu-sysregs.h"
>  
>  #include <mach/mach_time.h>
>  
> @@ -866,7 +867,7 @@ static bool hvf_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>          { HV_SYS_REG_ID_AA64PFR1_EL1, &host_isar.id_aa64pfr1 },
>          { HV_SYS_REG_ID_AA64DFR0_EL1, &host_isar.id_aa64dfr0 },
>          { HV_SYS_REG_ID_AA64DFR1_EL1, &host_isar.id_aa64dfr1 },
> -        { HV_SYS_REG_ID_AA64ISAR0_EL1, &host_isar.id_aa64isar0 },
> +        { HV_SYS_REG_ID_AA64ISAR0_EL1, &host_isar.idregs[ID_AA64ISAR0_EL1_IDX] },
>          { HV_SYS_REG_ID_AA64ISAR1_EL1, &host_isar.id_aa64isar1 },
>          /* Add ID_AA64ISAR2_EL1 here when HVF supports it */
>          { HV_SYS_REG_ID_AA64MMFR0_EL1, &host_isar.id_aa64mmfr0 },
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 97de8c7e9397..a1fe3a0341f0 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -26,6 +26,7 @@
>  #include "system/kvm_int.h"
>  #include "kvm_arm.h"
>  #include "cpu.h"
> +#include "cpu-sysregs.h"
>  #include "trace.h"
>  #include "internals.h"
>  #include "hw/pci/pci.h"
> @@ -246,6 +247,28 @@ static bool kvm_arm_pauth_supported(void)
>              kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
>  }
>  
> +
> +static uint64_t idregs_sysreg_to_kvm_reg(ARMSysRegs sysreg)
> +{
> +    return ARM64_SYS_REG((sysreg & CP_REG_ARM64_SYSREG_OP0_MASK) >> CP_REG_ARM64_SYSREG_OP0_SHIFT,
> +                         (sysreg & CP_REG_ARM64_SYSREG_OP1_MASK) >> CP_REG_ARM64_SYSREG_OP1_SHIFT,
> +                         (sysreg & CP_REG_ARM64_SYSREG_CRN_MASK) >> CP_REG_ARM64_SYSREG_CRN_SHIFT,
> +                         (sysreg & CP_REG_ARM64_SYSREG_CRM_MASK) >> CP_REG_ARM64_SYSREG_CRM_SHIFT,
> +                         (sysreg & CP_REG_ARM64_SYSREG_OP2_MASK) >> CP_REG_ARM64_SYSREG_OP2_SHIFT);
> +}
> +
> +/* read a sysreg value and store it in the idregs */
> +static int get_host_cpu_reg(int fd, ARMHostCPUFeatures *ahcf, ARMIDRegisterIdx index)
> +{
> +    uint64_t *reg;
> +    int ret;
> +
> +    reg = &ahcf->isar.idregs[index];
> +    ret = read_sys_reg64(fd, reg,
> +                         idregs_sysreg_to_kvm_reg(id_register_sysreg[index]));
> +    return ret;
> +}
> +
>  static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>  {
>      /* Identify the feature bits corresponding to the host CPU, and
> @@ -306,6 +329,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>  
>      ahcf->target = init.target;
>      ahcf->dtb_compatible = "arm,arm-v8";
> +    int fd = fdarray[2];
>  
>      err = read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64pfr0,
>                           ARM64_SYS_REG(3, 0, 0, 4, 0));
> @@ -337,8 +361,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>                                ARM64_SYS_REG(3, 0, 0, 5, 0));
>          err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64dfr1,
>                                ARM64_SYS_REG(3, 0, 0, 5, 1));
> -        err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar0,
> -                              ARM64_SYS_REG(3, 0, 0, 6, 0));
> +        err |= get_host_cpu_reg(fd, ahcf, ID_AA64ISAR0_EL1_IDX);
>          err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar1,
>                                ARM64_SYS_REG(3, 0, 0, 6, 1));
>          err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64isar2,
> @@ -447,8 +470,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>               * enabled SVE support, which resulted in an error rather than RAZ.
>               * So only read the register if we set KVM_ARM_VCPU_SVE above.
>               */
> -            err |= read_sys_reg64(fdarray[2], &ahcf->isar.id_aa64zfr0,
> -                                  ARM64_SYS_REG(3, 0, 0, 4, 4));
> +            err |= get_host_cpu_reg(fd, ahcf, ID_AA64ZFR0_EL1_IDX);
>          }
>      }
>  
> diff --git a/target/arm/tcg/cpu64.c b/target/arm/tcg/cpu64.c
> index 29ab0ac79da9..f31bb9ceaac9 100644
> --- a/target/arm/tcg/cpu64.c
> +++ b/target/arm/tcg/cpu64.c
> @@ -32,6 +32,7 @@
>  static void aarch64_a35_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,cortex-a35";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -66,7 +67,7 @@ static void aarch64_a35_initfn(Object *obj)
>      cpu->isar.id_aa64pfr1 = 0;
>      cpu->isar.id_aa64dfr0 = 0x10305106;
>      cpu->isar.id_aa64dfr1 = 0;
> -    cpu->isar.id_aa64isar0 = 0x00011120;
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
>      cpu->isar.id_aa64isar1 = 0;
>      cpu->isar.id_aa64mmfr0 = 0x00101122;
>      cpu->isar.id_aa64mmfr1 = 0;
> @@ -204,6 +205,7 @@ static const Property arm_cpu_lpa2_property =
>  static void aarch64_a55_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,cortex-a55";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -221,7 +223,7 @@ static void aarch64_a55_initfn(Object *obj)
>      cpu->ctr = 0x84448004; /* L1Ip = VIPT */
>      cpu->dcz_blocksize = 4; /* 64 bytes */
>      cpu->isar.id_aa64dfr0  = 0x0000000010305408ull;
> -    cpu->isar.id_aa64isar0 = 0x0000100010211120ull;
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x0000100010211120ull);
>      cpu->isar.id_aa64isar1 = 0x0000000000100001ull;
>      cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
>      cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
> @@ -276,6 +278,7 @@ static void aarch64_a55_initfn(Object *obj)
>  static void aarch64_a72_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,cortex-a72";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -311,7 +314,7 @@ static void aarch64_a72_initfn(Object *obj)
>      cpu->isar.id_isar5 = 0x00011121;
>      cpu->isar.id_aa64pfr0 = 0x00002222;
>      cpu->isar.id_aa64dfr0 = 0x10305106;
> -    cpu->isar.id_aa64isar0 = 0x00011120;
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x00011120);
>      cpu->isar.id_aa64mmfr0 = 0x00001124;
>      cpu->isar.dbgdidr = 0x3516d000;
>      cpu->isar.dbgdevid = 0x01110f13;
> @@ -335,6 +338,7 @@ static void aarch64_a72_initfn(Object *obj)
>  static void aarch64_a76_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,cortex-a76";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -352,7 +356,7 @@ static void aarch64_a76_initfn(Object *obj)
>      cpu->ctr = 0x8444C004;
>      cpu->dcz_blocksize = 4;
>      cpu->isar.id_aa64dfr0  = 0x0000000010305408ull;
> -    cpu->isar.id_aa64isar0 = 0x0000100010211120ull;
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x0000100010211120ull);
>      cpu->isar.id_aa64isar1 = 0x0000000000100001ull;
>      cpu->isar.id_aa64mmfr0 = 0x0000000000101122ull;
>      cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
> @@ -408,6 +412,7 @@ static void aarch64_a76_initfn(Object *obj)
>  static void aarch64_a64fx_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,a64fx";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -431,9 +436,9 @@ static void aarch64_a64fx_initfn(Object *obj)
>      cpu->isar.id_aa64mmfr0 = 0x0000000000001122;
>      cpu->isar.id_aa64mmfr1 = 0x0000000011212100;
>      cpu->isar.id_aa64mmfr2 = 0x0000000000001011;
> -    cpu->isar.id_aa64isar0 = 0x0000000010211120;
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x0000000010211120);
>      cpu->isar.id_aa64isar1 = 0x0000000000010001;
> -    cpu->isar.id_aa64zfr0 = 0x0000000000000000;
> +    SET_IDREG(isar, ID_AA64ZFR0, 0x0000000000000000);
>      cpu->clidr = 0x0000000080000023;
>      /* 64KB L1 dcache */
>      cpu->ccsidr[0] = make_ccsidr(CCSIDR_FORMAT_LEGACY, 4, 256, 64 * KiB, 7);
> @@ -581,6 +586,7 @@ static void define_neoverse_v1_cp_reginfo(ARMCPU *cpu)
>  static void aarch64_neoverse_n1_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,neoverse-n1";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -598,7 +604,7 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
>      cpu->ctr = 0x8444c004;
>      cpu->dcz_blocksize = 4;
>      cpu->isar.id_aa64dfr0  = 0x0000000110305408ull;
> -    cpu->isar.id_aa64isar0 = 0x0000100010211120ull;
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x0000100010211120ull);
>      cpu->isar.id_aa64isar1 = 0x0000000000100001ull;
>      cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
>      cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
> @@ -656,6 +662,7 @@ static void aarch64_neoverse_n1_initfn(Object *obj)
>  static void aarch64_neoverse_v1_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,neoverse-v1";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -676,7 +683,7 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
>      cpu->id_aa64afr1 = 0x00000000;
>      cpu->isar.id_aa64dfr0  = 0x000001f210305519ull;
>      cpu->isar.id_aa64dfr1 = 0x00000000;
> -    cpu->isar.id_aa64isar0 = 0x1011111110212120ull; /* with FEAT_RNG */
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x1011111110212120ull); /* with FEAT_RNG */
>      cpu->isar.id_aa64isar1 = 0x0011100001211032ull;
>      cpu->isar.id_aa64mmfr0 = 0x0000000000101125ull;
>      cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
> @@ -735,7 +742,7 @@ static void aarch64_neoverse_v1_initfn(Object *obj)
>      cpu->isar.mvfr2 = 0x00000043;
>  
>      /* From 3.7.5 ID_AA64ZFR0_EL1 */
> -    cpu->isar.id_aa64zfr0 = 0x0000100000100000;
> +    SET_IDREG(isar, ID_AA64ZFR0, 0x0000100000100000);
>      cpu->sve_vq.supported = (1 << 0)  /* 128bit */
>                              | (1 << 1);  /* 256bit */
>  
> @@ -882,6 +889,7 @@ static const ARMCPRegInfo cortex_a710_cp_reginfo[] = {
>  static void aarch64_a710_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,cortex-a710";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -919,12 +927,12 @@ static void aarch64_a710_initfn(Object *obj)
>      cpu->isar.id_pfr2  = 0x00000011;
>      cpu->isar.id_aa64pfr0  = 0x1201111120111112ull; /* GIC filled in later */
>      cpu->isar.id_aa64pfr1  = 0x0000000000000221ull;
> -    cpu->isar.id_aa64zfr0  = 0x0000110100110021ull; /* with Crypto */
> +    SET_IDREG(isar, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
>      cpu->isar.id_aa64dfr0  = 0x000011f010305619ull;
>      cpu->isar.id_aa64dfr1  = 0;
>      cpu->id_aa64afr0       = 0;
>      cpu->id_aa64afr1       = 0;
> -    cpu->isar.id_aa64isar0 = 0x0221111110212120ull; /* with Crypto */
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x0221111110212120ull); /* with Crypto */
>      cpu->isar.id_aa64isar1 = 0x0010111101211052ull;
>      cpu->isar.id_aa64mmfr0 = 0x0000022200101122ull;
>      cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
> @@ -983,6 +991,7 @@ static const ARMCPRegInfo neoverse_n2_cp_reginfo[] = {
>  static void aarch64_neoverse_n2_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>  
>      cpu->dtb_compatible = "arm,neoverse-n2";
>      set_feature(&cpu->env, ARM_FEATURE_V8);
> @@ -1020,12 +1029,12 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
>      cpu->isar.id_pfr2  = 0x00000011;
>      cpu->isar.id_aa64pfr0  = 0x1201111120111112ull; /* GIC filled in later */
>      cpu->isar.id_aa64pfr1  = 0x0000000000000221ull;
> -    cpu->isar.id_aa64zfr0  = 0x0000110100110021ull; /* with Crypto */
> +    SET_IDREG(isar, ID_AA64ZFR0, 0x0000110100110021ull); /* with Crypto */
>      cpu->isar.id_aa64dfr0  = 0x000011f210305619ull;
>      cpu->isar.id_aa64dfr1  = 0;
>      cpu->id_aa64afr0       = 0;
>      cpu->id_aa64afr1       = 0;
> -    cpu->isar.id_aa64isar0 = 0x1221111110212120ull; /* with Crypto and FEAT_RNG */
> +    SET_IDREG(isar, ID_AA64ISAR0, 0x1221111110212120ull); /* with Crypto and FEAT_RNG */
>      cpu->isar.id_aa64isar1 = 0x0011111101211052ull;
>      cpu->isar.id_aa64mmfr0 = 0x0000022200101125ull;
>      cpu->isar.id_aa64mmfr1 = 0x0000000010212122ull;
> @@ -1083,6 +1092,7 @@ static void aarch64_neoverse_n2_initfn(Object *obj)
>  void aarch64_max_tcg_initfn(Object *obj)
>  {
>      ARMCPU *cpu = ARM_CPU(obj);
> +    ARMISARegisters *isar = &cpu->isar;
>      uint64_t t;
>      uint32_t u;
>  
> @@ -1133,7 +1143,7 @@ void aarch64_max_tcg_initfn(Object *obj)
>      t = FIELD_DP64(t, CTR_EL0, DIC, 1);
>      cpu->ctr = t;
>  
> -    t = cpu->isar.id_aa64isar0;
> +    t = GET_IDREG(isar, ID_AA64ISAR0);
>      t = FIELD_DP64(t, ID_AA64ISAR0, AES, 2);      /* FEAT_PMULL */
>      t = FIELD_DP64(t, ID_AA64ISAR0, SHA1, 1);     /* FEAT_SHA1 */
>      t = FIELD_DP64(t, ID_AA64ISAR0, SHA2, 2);     /* FEAT_SHA512 */
> @@ -1148,7 +1158,7 @@ void aarch64_max_tcg_initfn(Object *obj)
>      t = FIELD_DP64(t, ID_AA64ISAR0, TS, 2);       /* FEAT_FlagM2 */
>      t = FIELD_DP64(t, ID_AA64ISAR0, TLB, 2);      /* FEAT_TLBIRANGE */
>      t = FIELD_DP64(t, ID_AA64ISAR0, RNDR, 1);     /* FEAT_RNG */
> -    cpu->isar.id_aa64isar0 = t;
> +    SET_IDREG(isar, ID_AA64ISAR0, t);
>  
>      t = cpu->isar.id_aa64isar1;
>      t = FIELD_DP64(t, ID_AA64ISAR1, DPB, 2);      /* FEAT_DPB2 */
> @@ -1244,7 +1254,7 @@ void aarch64_max_tcg_initfn(Object *obj)
>      t = FIELD_DP64(t, ID_AA64MMFR3, SPEC_FPACC, 1); /* FEAT_FPACC_SPEC */
>      cpu->isar.id_aa64mmfr3 = t;
>  
> -    t = cpu->isar.id_aa64zfr0;
> +    t = GET_IDREG(isar, ID_AA64ZFR0);
>      t = FIELD_DP64(t, ID_AA64ZFR0, SVEVER, 1);
>      t = FIELD_DP64(t, ID_AA64ZFR0, AES, 2);       /* FEAT_SVE_PMULL128 */
>      t = FIELD_DP64(t, ID_AA64ZFR0, BITPERM, 1);   /* FEAT_SVE_BitPerm */
> @@ -1254,7 +1264,7 @@ void aarch64_max_tcg_initfn(Object *obj)
>      t = FIELD_DP64(t, ID_AA64ZFR0, I8MM, 1);      /* FEAT_I8MM */
>      t = FIELD_DP64(t, ID_AA64ZFR0, F32MM, 1);     /* FEAT_F32MM */
>      t = FIELD_DP64(t, ID_AA64ZFR0, F64MM, 1);     /* FEAT_F64MM */
> -    cpu->isar.id_aa64zfr0 = t;
> +    SET_IDREG(isar, ID_AA64ZFR0, t);
>  
>      t = cpu->isar.id_aa64dfr0;
>      t = FIELD_DP64(t, ID_AA64DFR0, DEBUGVER, 10); /* FEAT_Debugv8p8 */
> -- 
> 2.49.0
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

