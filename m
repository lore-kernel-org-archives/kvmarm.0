Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADF93AB26B
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 05:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784525951; cv=none; b=WN7hZwDik5LyuFLADfQeQ9KJfJa2GfHv45+SLPjun4jbvfp9aQ3Cuhv5HtxYf1Veqc7V8CzhB0rzdXFOXiUAYbQ7foi9Fs0BorZSQ1m5Ca8eIRysmN+HNxUzohaTs/kJwg+5JwrxKromGTkM4cCKw+NBYoXrBRQ5ytXyqIlrkwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784525951; c=relaxed/simple;
	bh=WMFStzPwxGo9/CLh6+gBDb79KsWaVVshyeopvFLJ5WE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fdilVP4MqJYpkd4M6socJjijG4yekNobUaJtkxgwWnxD1Kc9U4WT5CTuMpwp3I29dBko5/SXt9xEPYZMgS25g4En9D4vkmUKRn/5srag4UWpyVDwMe4TCZUdJMwka98AVjyizBNAdu1D1IUcC3/VybDZodL3ITzA6+pnJ1ZQuIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Au52tJQ7 reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Au52tJQ7"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66K5c7ov075973
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Jul 2026 14:38:29 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=j7sWr3lP3gUNcCOHDT5toIViFIw3oVR+P1TswXAYwYE=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1784525909; v=1;
        b=Au52tJQ7rNRnAi3NSc4uvcvWimSIxCHYyvECNrRbILLgxPedffesNzYPfUkdI164
         shKvAEQJn9w2V1cQXDQZb/2uTVuMoOPbw4aCR2k9opLzdPrQNDRwTjCDTNLwt0tI
         ArPxnHZqsgG3Mk0GZMYcwwUDJD/XntyDvee0Vnu57GXMQxDJiqjcf28Q1OF+FGbl
         dtXvLunmd5j0Hxv6aFsif18H2hqr0TabZUrV2wAOC8n88auY5XsIRGUH6EsIO5h5
         kKfKo1b6DMqw3+Pr3THni50RYTbngpDN1jmj/LkkbQLM/mHc/Z5IhuLu6sJZzLYZ
         mZS87X4MFkZOKoywJJZvvg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Jul 2026 14:38:07 +0900
Subject: [PATCH v9 13/16] KVM: arm64: PMU: Pass the target CPU to
 kvm_pmu_probe_armpmu()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hybrid-v9-13-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4094;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=WMFStzPwxGo9/CLh6+gBDb79KsWaVVshyeopvFLJ5WE=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bsFt8+htCtDpP4lrMvCP64IifidfSmL3YSK6aFJu6pK
 3q48cyrjlIWBjEuBlkxRZaUot3cGtG1nwoT4ltg5rAygQxh4OIUgInwpjAyHH7csk32nalxpxf3
 iXmfSphOaMk+u7Q+gOnOhZD1G5XFHjD8T99jY3ZB9PVzk6WvugMvPHqYquUy+8/9LxGsKyd874l
 byg0A
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

kvm_pmu_probe_armpmu() currently samples the current CPU internally,
which ties the helper to default PMU selection.

Move that policy to kvm_arm_set_default_pmu() by passing
raw_smp_processor_id() from the caller, and make the helper search for
the pPMU covering an explicit CPU. Move the helper above
kvm_pmu_create_perf_event() so later code can reuse it when creating
PMU events for a VCPU's current pCPU.

This preserves the existing default PMU selection behavior while
preparing fixed-counters-only mode to select a pPMU at runtime.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/pmu-emul.c | 72 +++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 27db8877f96e..78611eaecca2 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -682,6 +682,23 @@ static int kvm_map_pmu_event(struct arm_pmu *pmu, unsigned int eventsel)
 	return eventsel;
 }
 
+static struct arm_pmu *kvm_pmu_probe_armpmu(int cpu)
+{
+	struct arm_pmu_entry *entry;
+	struct arm_pmu *pmu;
+
+	guard(rcu)();
+
+	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
+		pmu = entry->arm_pmu;
+
+		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
+			return pmu;
+	}
+
+	return NULL;
+}
+
 /**
  * kvm_pmu_create_perf_event - create a perf event for a counter
  * @pmc: Counter context
@@ -811,42 +828,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	list_add_tail_rcu(&entry->entry, &arm_pmus);
 }
 
-static struct arm_pmu *kvm_pmu_probe_armpmu(void)
-{
-	struct arm_pmu_entry *entry;
-	struct arm_pmu *pmu;
-	int cpu;
-
-	guard(rcu)();
-
-	/*
-	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
-	 * the same value is used for the entirety of the loop. Given this, and
-	 * the fact that no percpu data is used for the lookup there is no need
-	 * to disable preemption.
-	 *
-	 * It is still necessary to get a valid cpu, though, to probe for the
-	 * default PMU instance as userspace is not required to specify a PMU
-	 * type. In order to uphold the preexisting behavior KVM selects the
-	 * PMU instance for the core during vcpu init. A dependent use
-	 * case would be a user with disdain of all things big.LITTLE that
-	 * affines the VMM to a particular cluster of cores.
-	 *
-	 * In any case, userspace should just do the sane thing and use the UAPI
-	 * to select a PMU type directly. But, be wary of the baggage being
-	 * carried here.
-	 */
-	cpu = raw_smp_processor_id();
-	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
-		pmu = entry->arm_pmu;
-
-		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
-			return pmu;
-	}
-
-	return NULL;
-}
-
 static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
 {
 	u32 hi[2], lo[2];
@@ -1072,7 +1053,24 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
  */
 int kvm_arm_set_default_pmu(struct kvm *kvm)
 {
-	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
+	/*
+	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
+	 * the same value is used for the entirety of the loop. Given this, and
+	 * the fact that no percpu data is used for the lookup there is no need
+	 * to disable preemption.
+	 *
+	 * It is still necessary to get a valid cpu, though, to probe for the
+	 * default PMU instance as userspace is not required to specify a PMU
+	 * type. In order to uphold the preexisting behavior KVM selects the
+	 * PMU instance for the core during vcpu init. A dependent use
+	 * case would be a user with disdain of all things big.LITTLE that
+	 * affines the VMM to a particular cluster of cores.
+	 *
+	 * In any case, userspace should just do the sane thing and use the UAPI
+	 * to select a PMU type directly. But, be wary of the baggage being
+	 * carried here.
+	 */
+	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu(raw_smp_processor_id());
 
 	if (!arm_pmu)
 		return -ENODEV;

-- 
2.55.0

