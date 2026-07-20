Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C273A960F
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 05:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784525949; cv=none; b=sXGWisiMpL6LqIOJbeebxmWIrhp7GX5lp6Voz4gjjZzwiG7/Dn3NNXUaGtOInKlIWDRhyFFIfVRiLvuoQoZcniPMDilpfqaow8ZZ/TpUULE0naFsXOSwvVPZsUbYFag+aGtCp26YsebsoTatbEMSSWcp5gjSkbnX99J+PHFnOfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784525949; c=relaxed/simple;
	bh=sA6PHZrE+eChltBNP/YRFOEZoFp0fBLLFqrnJLkkuLQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RQRpBOJ0Y8z+RHcFP4zqO2wo0cHRpZSto62a/bArTP81VislNPuYGk5QBvBxebE7WqslFTUOVoRTjtv/u03dKgsN2kPYvl1OryhtYHldYCRkQGTDUdmJUqEuIj79HeVCBBqod9ZMgOgPFNdvKj3j11MImLtDpyt0fdgbKQDWWQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=fiQY9CsU reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="fiQY9CsU"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66K5c7ot075973
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Jul 2026 14:38:28 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=O8vvC+qcqQ6sKtJfRDWaxkOkLTGUo5713aT+sloywJY=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1784525908; v=1;
        b=fiQY9CsUT0ihHExzZEwRWZZdmAoL946rPzpyecbrDAQWhBZ3qiExm8AcHzhUGZi4
         L56D0g/EcaOwZQBzUmobrELA4Pvhkv0DUzPJnpp6tzTBjlTIf/2ktZKS4G97AlYq
         1CCeFl9vj1T3lRxgnZvVN2UbkrCPDbadu4Clvch/VWVpwbVsKQ7+1oz33ajawIb2
         g0j+2RNKJZzKteqeYHMcfJr7ZSTyoDH81UF8dI5ZiZZ5Q4mPM7NKFOMtLt1PLDFW
         852XA0mEEGzTNEsCBXp1dPYO+0vMRHVCaJCGmDp/t95yYP+Ueo39XVW1TMzOyQvb
         ln0j+f36X9juDnSSLTuAYQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Jul 2026 14:38:05 +0900
Subject: [PATCH v9 11/16] KVM: arm64: PMU: Protect the list of PMUs with
 RCU
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hybrid-v9-11-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5
X-Developer-Signature: v=1; a=openpgp-sha256; l=2740;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=sA6PHZrE+eChltBNP/YRFOEZoFp0fBLLFqrnJLkkuLQ=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bsFu/yoJM/xSy9atJ3Zy2embnIxuXT/tjS3Sfmfyvkv
 pPA8fVMRykLgxgXg6yYIktK0W5ujejaT4UJ8S0wc1iZQIYwcHEKwEROSTH8d33MzFvGu+rNwXpB
 7/+XRZ9YON8x6bVbvNDqKZcQ38lnvQy/2ZcE9C87vCWuwOqxGcfbS8/FOT/82rjjkOmnv9n5tmX
 tXAA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

Convert the list of PMUs to a RCU-protected list that has primitives to
avoid read-side contention.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/pmu-emul.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 9ac5f307ea31..c5c505b6fc61 100644
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
@@ -20,6 +20,10 @@
 #define MDCR_EL2_PMU_RECREATE_MASK	(MDCR_EL2_HPMN | MDCR_EL2_HPMD | \
 					 MDCR_EL2_HLP)
 
+/*
+ * arm_pmus is append-only. kvm_supports_guest_pmuv3() feeds persistent
+ * VM state, so a true result must remain valid after the check.
+ */
 static LIST_HEAD(arm_pmus);
 static DEFINE_MUTEX(arm_pmus_lock);
 
@@ -29,7 +33,6 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc);
 
 bool kvm_supports_guest_pmuv3(void)
 {
-	guard(mutex)(&arm_pmus_lock);
 	return !list_empty(&arm_pmus);
 }
 
@@ -807,7 +810,7 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 		return;
 
 	entry->arm_pmu = pmu;
-	list_add_tail(&entry->entry, &arm_pmus);
+	list_add_tail_rcu(&entry->entry, &arm_pmus);
 }
 
 static struct arm_pmu *kvm_pmu_probe_armpmu(void)
@@ -816,7 +819,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 	struct arm_pmu *pmu;
 	int cpu;
 
-	guard(mutex)(&arm_pmus_lock);
+	guard(rcu)();
 
 	/*
 	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
@@ -836,7 +839,7 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 	 * carried here.
 	 */
 	cpu = raw_smp_processor_id();
-	list_for_each_entry(entry, &arm_pmus, entry) {
+	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
 		pmu = entry->arm_pmu;
 
 		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
@@ -1088,9 +1091,9 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	int ret = -ENXIO;
 
 	lockdep_assert_held(&kvm->arch.config_lock);
-	mutex_lock(&arm_pmus_lock);
+	guard(rcu)();
 
-	list_for_each_entry(entry, &arm_pmus, entry) {
+	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
 		arm_pmu = entry->arm_pmu;
 		if (arm_pmu->pmu.type == pmu_id) {
 			if (kvm_vm_has_ran_once(kvm) ||
@@ -1106,7 +1109,6 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 		}
 	}
 
-	mutex_unlock(&arm_pmus_lock);
 	return ret;
 }
 

-- 
2.55.0

