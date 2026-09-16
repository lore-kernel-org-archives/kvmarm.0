Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D9E30D410
	for <kvmarm@lists.linux.dev>; Wed, 16 Sep 2026 14:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570139; cv=none; b=ceb8Qq/C0KioYKklYEZ87JDzy44b4UJZykrMx1M1G2S5hsa+CxdgtXxGYRfQ9y1q4+Xv3I4BmGt37rCjiNhEL+5Dr9mepHtnSNSA7DI9KW2knUkGtu1RYR8z2DeCDllC+ubbEOlxX/lusco2tT8vImE0YuTQi/ZjCOd4CXRwwKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570139; c=relaxed/simple;
	bh=MLR2dTK67oPC41gGA5+VOhNJBzjyOuwkD99gFOEr2pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Ys2bXbpk0rjlxaVc9IDXfVZ6+nVzrR0TI8bErzLvRUbboqDhyomUVyrFHU1XyE1Ls81NdGc0DTRCS5sCcwXwU1mTqjvPOzt9pD+BMPFPol7kxZwtp7mqGggSh/heOfY+r+ylhilfHipZ0Bi+mpn1QUuWviTTrTZrA8/s4bpsM3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ux+yGci0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ux+yGci0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789570136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mp9Gt8hNuRwnR0Nv0BcxvQY9JAq4AGfT4zgsNY49Aq4=;
	b=Ux+yGci0GSSBra8uUYjfkmPrj6IoVUE9Kdvgsf4Ysq1lHLCQ0SgxTX1Zyi6BeGMhK8xTsM
	f01fIe0t6YmiAokdu8K9jGwL/omXg4ERS8oT8aNXOREKqsVILKhHYDcFWh6e6plOo3XlFt
	Q1eISORnTxlwqBdgrX4khab7vEjFtPY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-Zhm2K5kAOdGo1WweSdMt_g-1; Wed,
 16 Sep 2026 10:48:52 -0400
X-MC-Unique: Zhm2K5kAOdGo1WweSdMt_g-1
X-Mimecast-MFC-AGG-ID: Zhm2K5kAOdGo1WweSdMt_g_1789570130
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEDEE1801355;
	Wed, 16 Sep 2026 14:48:50 +0000 (UTC)
Received: from laptop.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2646719560AB;
	Wed, 16 Sep 2026 14:48:45 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	qemu-devel@nongnu.org,
	qemu-arm@nongnu.org,
	kvmarm@lists.linux.dev,
	peter.maydell@linaro.org,
	shaju.abraham@nutanix.com,
	khushit.shah@nutanix.com,
	yangjinqian1@huawei.com,
	cohuck@redhat.com,
	richard.henderson@linaro.org,
	sebott@redhat.com,
	skolothumtho@nvidia.com,
	philmd@oss.qualcomm.com
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	pbonzini@redhat.com,
	armbru@redhat.com,
	berrange@redhat.com,
	abologna@redhat.com,
	jdenemar@redhat.com
Subject: [PATCH v9 15/26] target/arm/kvm: Pass an Error handle to kvm_arch_init_vcpu
Date: Wed, 16 Sep 2026 16:45:38 +0200
Message-ID: <20260916144721.751810-16-eric.auger@redhat.com>
In-Reply-To: <20260916144721.751810-1-eric.auger@redhat.com>
References: <20260916144721.751810-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: c67EdWOd9RaO5yBEmCltQNhvzqwHiW52iVUl25IcX68_1789570130
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The 2 callers of kvm_arch_init_vcpu(), namely kvm_rebind_vcpus()
and kvm_init_vcpu() are passed an Error handle. So it is a pity
not using it in kvm_arch_init_vcpu(). Also some functions called
within kvm_arch_init_vcpu() could get benefit from it, especially
on ARM. This will happen in subsequent patches.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 include/system/kvm.h       |  2 +-
 accel/kvm/kvm-all.c        | 15 +++++++--------
 target/arm/kvm.c           | 14 +++++++++-----
 target/i386/kvm/kvm.c      | 22 ++++++++++++----------
 target/loongarch/kvm/kvm.c | 24 ++++++++----------------
 target/ppc/kvm.c           |  6 +++---
 target/riscv/kvm/kvm-cpu.c |  3 ++-
 target/s390x/kvm/kvm.c     |  2 +-
 8 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/include/system/kvm.h b/include/system/kvm.h
index 714b8c7b01..cd94eb0323 100644
--- a/include/system/kvm.h
+++ b/include/system/kvm.h
@@ -358,7 +358,7 @@ int kvm_arch_get_default_type(MachineState *ms);
 int kvm_arch_init(MachineState *ms, KVMState *s);
 
 int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp);
-int kvm_arch_init_vcpu(CPUState *cpu);
+int kvm_arch_init_vcpu(CPUState *cpu, Error **errp);
 int kvm_arch_destroy_vcpu(CPUState *cpu);
 
 #ifdef TARGET_KVM_HAVE_RESET_PARKED_VCPU
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 83cbd120a8..a66d1d8c66 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -492,11 +492,11 @@ static int kvm_rebind_vcpus(Error **errp)
             }
         }
 
-        ret = kvm_arch_init_vcpu(cpu);
+        ret = kvm_arch_init_vcpu(cpu, errp);
         if (ret < 0) {
-            error_setg_errno(errp, -ret,
-                             "kvm_init_vcpu: kvm_arch_init_vcpu failed (%lu)",
-                             vcpu_id);
+            error_prepend(errp,
+                          "kvm_init_vcpu: kvm_arch_init_vcpu failed (%lu)",
+                          vcpu_id);
         }
 
         close(cpu->kvm_vcpu_stats_fd);
@@ -739,11 +739,10 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
         }
     }
 
-    ret = kvm_arch_init_vcpu(cpu);
+    ret = kvm_arch_init_vcpu(cpu, errp);
     if (ret < 0) {
-        error_setg_errno(errp, -ret,
-                         "kvm_init_vcpu: kvm_arch_init_vcpu failed (%lu)",
-                         kvm_arch_vcpu_id(cpu));
+        error_prepend(errp, "kvm_init_vcpu: kvm_arch_init_vcpu failed (%lu)",
+                      kvm_arch_vcpu_id(cpu));
     }
     cpu->kvm_vcpu_stats_fd = kvm_vcpu_ioctl(cpu, KVM_GET_STATS_FD, NULL);
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index cdc3779321..3ec2618cc1 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2215,7 +2215,7 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
-int kvm_arch_init_vcpu(CPUState *cs)
+int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
 {
     int ret;
     uint64_t mpidr;
@@ -2224,7 +2224,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     uint64_t psciver;
 
     if (cpu->kvm_target == QEMU_KVM_ARM_TARGET_NONE) {
-        error_report("KVM is not supported for this guest CPU type");
+        error_setg(errp, "KVM is not supported for this guest CPU type");
         return -EINVAL;
     }
 
@@ -2263,16 +2263,19 @@ int kvm_arch_init_vcpu(CPUState *cs)
     /* Do KVM_ARM_VCPU_INIT ioctl */
     ret = kvm_arm_vcpu_init(cpu);
     if (ret) {
+        error_setg(errp, "failed kvm_arm_vcpu_init (%d)", ret);
         return ret;
     }
 
     if (cpu_isar_feature(aa64_sve, cpu)) {
         ret = kvm_arm_sve_set_vls(cpu);
         if (ret) {
+            error_setg(errp, "failed kvm_arm_sve_set_vls (%d)", ret);
             return ret;
         }
         ret = kvm_arm_vcpu_finalize(cpu, KVM_ARM_VCPU_SVE);
         if (ret) {
+            error_setg(errp, "failed kvm_arm_vcpu_finalize (%d)", ret);
             return ret;
         }
     }
@@ -2281,11 +2284,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
         psciver = cpu->psci_version;
         ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
         if (ret) {
-            error_report("KVM in this kernel does not support PSCI version %d.%d",
+            error_setg(errp, "KVM in this kernel does not support PSCI version %d.%d",
                          (int) PSCI_VERSION_MAJOR(psciver),
                          (int) PSCI_VERSION_MINOR(psciver));
-            error_printf("Consider setting the kvm-psci-version property on the "
-                         "migration source.\n");
+            error_append_hint(errp, "Consider setting the kvm-psci-version property "
+                              "on the migration source.\n");
             return ret;
         }
     }
@@ -2307,6 +2310,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
      */
     ret = kvm_get_one_reg(cs, ARM64_SYS_REG(ARM_CPU_ID_MPIDR), &mpidr);
     if (ret) {
+        error_setg(errp, "failed retrieving PMIDR value");
         return ret;
     }
     cpu->mp_affinity = mpidr & ARM64_AFFINITY_MASK;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 1eeadb99ad..41e99f6dcd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2218,7 +2218,7 @@ static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid, X86CPU *cpu)
     }
 }
 
-int kvm_arch_init_vcpu(CPUState *cs)
+int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
 {
     struct {
         struct kvm_cpuid2 cpuid;
@@ -2240,12 +2240,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
     int kvm_base = KVM_CPUID_SIGNATURE;
     int max_nested_state_len;
     int r;
-    Error *local_err = NULL;
 
     if (current_machine->cgs) {
         r = x86_confidential_guest_check_features(
                 X86_CONFIDENTIAL_GUEST(current_machine->cgs), cs);
         if (r < 0) {
+            error_setg(errp, "failed x86_confidential_guest_check_features (%d)", r);
             return r;
         }
     }
@@ -2258,6 +2258,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
     r = kvm_arch_set_tsc_khz(cs);
     if (r < 0) {
+        error_setg(errp, "failed setting tsc_khz (%d)", r);
         return r;
     }
 
@@ -2285,14 +2286,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
      * can still proceed and check/expand Hyper-V enlightenments here so legacy
      * behavior is preserved.
      */
-    if (!kvm_hyperv_expand_features(cpu, &local_err)) {
-        error_report_err(local_err);
+    if (!kvm_hyperv_expand_features(cpu, errp)) {
         return -ENOSYS;
     }
 
     if (hyperv_enabled(cpu)) {
         r = hyperv_init_vcpu(cpu);
         if (r) {
+            error_setg(errp, "failed hyperv_init_vcpu (%d)", r);
             return r;
         }
 
@@ -2371,6 +2372,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
         r = kvm_xen_init_vcpu(cs);
         if (r) {
+            error_setg(errp, "failed kvm_xen_init_vcpu (%d)", r);
             return r;
         }
 
@@ -2419,12 +2421,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
         ret = kvm_get_mce_cap_supported(cs->kvm_state, &mcg_cap, &banks);
         if (ret < 0) {
-            fprintf(stderr, "kvm_get_mce_cap_supported: %s", strerror(-ret));
+            error_setg(errp, "kvm_get_mce_cap_supported: %s", strerror(-ret));
             return ret;
         }
 
         if (banks < (env->mcg_cap & MCG_CAP_BANKS_MASK)) {
-            error_report("kvm: Unsupported MCE bank count (QEMU = %d, KVM = %d)",
+            error_setg(errp, "kvm: Unsupported MCE bank count (QEMU = %d, KVM = %d)",
                          (int)(env->mcg_cap & MCG_CAP_BANKS_MASK), banks);
             return -ENOTSUP;
         }
@@ -2432,7 +2434,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         unsupported_caps = env->mcg_cap & ~(mcg_cap | MCG_CAP_BANKS_MASK);
         if (unsupported_caps) {
             if (unsupported_caps & MCG_LMCE_P) {
-                error_report("kvm: LMCE not supported");
+                error_setg(errp, "kvm: LMCE not supported");
                 return -ENOTSUP;
             }
             warn_report("Unsupported MCG_CAP bits: 0x%" PRIx64,
@@ -2442,7 +2444,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         env->mcg_cap &= mcg_cap | MCG_CAP_BANKS_MASK;
         ret = kvm_vcpu_ioctl(cs, KVM_X86_SETUP_MCE, &env->mcg_cap);
         if (ret < 0) {
-            fprintf(stderr, "KVM_X86_SETUP_MCE: %s", strerror(-ret));
+            error_setg(errp, "KVM_X86_SETUP_MCE: %s", strerror(-ret));
             return ret;
         }
     }
@@ -2470,9 +2472,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
             error_setg(&invtsc_mig_blocker,
                        "State blocked by non-migratable CPU device"
                        " (invtsc flag)");
-            r = migrate_add_blocker(&invtsc_mig_blocker, &local_err);
+            r = migrate_add_blocker(&invtsc_mig_blocker, errp);
             if (r < 0) {
-                error_report_err(local_err);
                 return r;
             }
         }
@@ -2501,6 +2502,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     cpuid_data.cpuid.padding = 0;
     r = kvm_vcpu_ioctl(cs, KVM_SET_CPUID2, &cpuid_data);
     if (r) {
+        error_setg(errp, "KVM_SET_CPUID2 failed (%m)");
         goto fail;
     }
     kvm_init_xsave(env);
diff --git a/target/loongarch/kvm/kvm.c b/target/loongarch/kvm/kvm.c
index 15082a01f8..9fca5f81f8 100644
--- a/target/loongarch/kvm/kvm.c
+++ b/target/loongarch/kvm/kvm.c
@@ -1239,11 +1239,10 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
-int kvm_arch_init_vcpu(CPUState *cs)
+int kvm_arch_init_vcpu(CPUState *cs, Error *errp)
 {
     uint64_t val;
     int ret;
-    Error *local_err = NULL;
     LoongArchCPU *cpu = LOONGARCH_CPU(cs);
 
     cpu->vmsentry = qemu_add_vm_change_state_handler(
@@ -1253,45 +1252,38 @@ int kvm_arch_init_vcpu(CPUState *cs)
         brk_insn = val;
     }
 
-    ret = kvm_cpu_check_lsx(cs, &local_err);
+    ret = kvm_cpu_check_lsx(cs, errp);
     if (ret < 0) {
-        error_report_err(local_err);
         return ret;
     }
 
-    ret = kvm_cpu_check_lasx(cs, &local_err);
+    ret = kvm_cpu_check_lasx(cs, errp);
     if (ret < 0) {
-        error_report_err(local_err);
         return ret;
     }
 
-    ret = kvm_cpu_check_lbt(cs, &local_err);
+    ret = kvm_cpu_check_lbt(cs, errp);
     if (ret < 0) {
-        error_report_err(local_err);
         return ret;
     }
 
-    ret = kvm_cpu_check_pmu(cs, &local_err);
+    ret = kvm_cpu_check_pmu(cs, errp);
     if (ret < 0) {
-        error_report_err(local_err);
         return ret;
     }
 
-    ret = kvm_cpu_check_pv_features(cs, &local_err);
+    ret = kvm_cpu_check_pv_features(cs, errp);
     if (ret < 0) {
-        error_report_err(local_err);
         return ret;
     }
 
-    ret = kvm_cpu_check_ptw(cs, &local_err);
+    ret = kvm_cpu_check_ptw(cs, errp);
     if (ret < 0) {
-        error_report_err(local_err);
         return ret;
     }
 
-    ret = kvm_cpu_check_msgint(cs, &local_err);
+    ret = kvm_cpu_check_msgint(cs, errp);
     if (ret < 0) {
-        error_report_err(local_err);
         return ret;
     }
 
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 8e89a6c665..d90e904f90 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -484,7 +484,7 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
-int kvm_arch_init_vcpu(CPUState *cs)
+int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
 {
     PowerPCCPU *cpu = POWERPC_CPU(cs);
     CPUPPCState *cenv = &cpu->env;
@@ -494,8 +494,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
     ret = kvm_arch_sync_sregs(cpu);
     if (ret) {
         if (ret == -EINVAL) {
-            error_report("Register sync failed... If you're using kvm-hv.ko,"
-                         " only \"-cpu host\" is possible");
+            error_setg(errp, "Register sync failed... If you're using kvm-hv.ko,"
+                       " only \"-cpu host\" is possible");
         }
         return ret;
     }
diff --git a/target/riscv/kvm/kvm-cpu.c b/target/riscv/kvm/kvm-cpu.c
index 68e1501b21..d09048c522 100644
--- a/target/riscv/kvm/kvm-cpu.c
+++ b/target/riscv/kvm/kvm-cpu.c
@@ -1544,7 +1544,7 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
-int kvm_arch_init_vcpu(CPUState *cs)
+int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
 {
     int ret = 0;
     RISCVCPU *cpu = RISCV_CPU(cs);
@@ -1554,6 +1554,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (!object_dynamic_cast(OBJECT(cpu), TYPE_RISCV_CPU_HOST)) {
         ret = kvm_vcpu_set_machine_ids(cpu, cs);
         if (ret != 0) {
+            error_setg(errp, "failed setting machine id (%d)", ret);
             return ret;
         }
     }
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index b34a912714..19b9540bdd 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -403,7 +403,7 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
     return 0;
 }
 
-int kvm_arch_init_vcpu(CPUState *cs)
+int kvm_arch_init_vcpu(CPUState *cs, Error **errp)
 {
     unsigned int max_cpus = MACHINE(qdev_get_machine())->smp.max_cpus;
     S390CPU *cpu = S390_CPU(cs);
-- 
2.53.0

