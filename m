Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4288A2E542C
	for <kvmarm@lists.linux.dev>; Sat, 11 Apr 2026 10:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775902905; cv=none; b=Om0Kg1U8NPcC9fU0tU1gHcHLcvEZrajfhrDPy9TRCh9FlZNDdW2Xf98eV7dXKcD9ske7AFEZoIqvDB/PmO9yj12Kxu1SzhMHUyFq5p9uehdhdyGCMbyqpW9+/s4ngs3MxSe/L0ugRear6R5I9amVtlH2XYRlDVi5AJmf8hq8F4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775902905; c=relaxed/simple;
	bh=iJr5toA1/CsmmyI6M1AbODpx/FMJj4ZMpGVZAMCOEe4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cuHCyko4Nn8i4dPOtSSLZ+ajt4Zrw3dmBNkLTf3E8OaqniJFEEW/DKpmjJNnWGWe74AWmQDYHaCGkUjgeZhM3idkhwdrXLocvEDv4a2bM38UL38dpIX2ltD/YjD1RgGdKd0eTGt/rW1KCOkzZlemcMPupRVWI49CgU0Gj3suon4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=eBwZ9bmS reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="eBwZ9bmS"
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 63BAKqRn021769
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 11 Apr 2026 19:20:54 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=y+sZrQAT5sl0rgEx/XygAhgEwYefEMRbED57gjaRUBQ=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1775902854; v=1;
        b=eBwZ9bmSEJ3hssZAy5qEznlB8PZOsrIghCYflCCIVJeFSkgGZhCI41obXXYM5/jN
         9BkfkJPjYdoB2c5U2tO8HXiTcirs6bdmLTs07SMw/gWa2CKNAJALQDzOkOvGf5s+
         hLdKwsfSjiLJ1okOaNnfEK/DsGe6ZokKoGhbq19CP4QFZ8jQHT7gxr7b1ngFCYCe
         HyForcf6D1f8EtbvTPDX8csAeClgtjPn7OgNQFzG3Ok5So8QAdQ8gP5wO25JmTXz
         eD56K1fp5cBBcbo9/h95qiMN/Pl6a8h7JNGTYdEvRo77pmYwF/blNjx+15y1Vu4e
         Tsl+6ytd04/ye4TRlmPpAQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Sat, 11 Apr 2026 19:20:32 +0900
Subject: [PATCH v5 2/4] KVM: arm64: PMU: Protect the list of PMUs with RCU
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260411-hybrid-v5-2-b043b4d9f49e@rsg.ci.i.u-tokyo.ac.jp>
References: <20260411-hybrid-v5-0-b043b4d9f49e@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260411-hybrid-v5-0-b043b4d9f49e@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-5ab4c

Convert the list of PMUs to a RCU-protected list that has primitives to
avoid read-side contention.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/pmu-emul.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 59ec96e09321..ef5140bbfe28 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -7,9 +7,9 @@
 #include <linux/cpu.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
-#include <linux/list.h>
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmu.h>
+#include <linux/rculist.h>
 #include <linux/uaccess.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
@@ -26,7 +26,6 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc);
 
 bool kvm_supports_guest_pmuv3(void)
 {
-	guard(mutex)(&arm_pmus_lock);
 	return !list_empty(&arm_pmus);
 }
 
@@ -808,7 +807,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 		return;
 
 	entry->arm_pmu = pmu;
-	list_add_tail(&entry->entry, &arm_pmus);
+	list_add_tail_rcu(&entry->entry, &arm_pmus);
 }
 
 static struct arm_pmu *kvm_pmu_probe_armpmu(void)
@@ -817,7 +816,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 	struct arm_pmu *pmu;
 	int cpu;
 
-	guard(mutex)(&arm_pmus_lock);
+	guard(rcu)();
 
 	/*
 	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
@@ -837,7 +836,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 	 * carried here.
 	 */
 	cpu = raw_smp_processor_id();
-	list_for_each_entry(entry, &arm_pmus, entry) {
+	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
 		pmu = entry->arm_pmu;
 
 		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
@@ -1088,9 +1087,9 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	int ret = -ENXIO;
 
 	lockdep_assert_held(&kvm->arch.config_lock);
-	mutex_lock(&arm_pmus_lock);
+	guard(rcu)();
 
-	list_for_each_entry(entry, &arm_pmus, entry) {
+	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
 		arm_pmu = entry->arm_pmu;
 		if (arm_pmu->pmu.type == pmu_id) {
 			if (kvm_vm_has_ran_once(kvm) ||
@@ -1106,7 +1105,6 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 		}
 	}
 
-	mutex_unlock(&arm_pmus_lock);
 	return ret;
 }
 

-- 
2.53.0

