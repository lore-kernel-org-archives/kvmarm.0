Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B274344AB68
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386470; cv=none; b=n6z0hiQldZdJ1pTYO6NmOReyvT7aBdNdURNKXnNqpCOed18LKkw9rv5/MT7faMpwhnQ05unRPCfeNMBkzEk85K/IWSF35/NQ8NgtOiYFzOifhHBTx5xX0f2l49bwIroTaNvL7mcYiCbfGI24ZenXsJkD0yY2I6s2U17aTH2DEt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386470; c=relaxed/simple;
	bh=ySVw3BtQ8VdlSvwcAcvu2VldK45kYaHXHC6yP9WKKsg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=W9dH8ckI1w1+NebpzI/UjAZGAIq+eRVhPZO+XBaZxeR9kJB2EFhQ+KzvsIbItcFgPYo5njNCUM7QB0qluW2PHkwo94zW7rssUn656v9jFcoo81xzhnoqPktG4A0+TqiUoKttBHRCIcotMKbAdQflKME6YOT+ijUul+lrGq5/bSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=SXuEO2sa; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="SXuEO2sa"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjsJ084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:57 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=iW6paRDU1WuHVvPa2Tan4+ENXAFGhAHh39Stpx/lGEU=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386117; v=1;
        b=SXuEO2saKk20YD2hI4Bd3B6I1m3y39IXjKSDYVMyTHJVPMTQG/DWMsTfg5ROC63a
         jQn/hizniPKxQGoa4QtbRLVEU85+E7s2+daO7YVK9mG9QtCn58S1tOauNKKtiSV2
         rgA9ixQDTlU1/m0K8LG0USQ6+PyjRjdGcSGYV1qGyESosnCt3e+dw6Ii5Bv8hD/0
         e19rtNxCti9KLIb+3XRWxOaN7rt0DXQJs+t1yWxfjNxqRebhgPZGzMpvOugpvHoi
         RSX+sNZyTMEjUyAPfeRllhhiUhdOq0z8rIfdEgfUVkAEW7O39oHByZAhKO/t0Tnu
         QykA1SOKzEoWPoyc1NtBKQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:56 +0900
Subject: [PATCH v10 17/20] KVM: arm64: PMU: Pass the target CPU to
 kvm_pmu_probe_armpmu()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-17-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
References: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
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
        Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
        Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4142;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=ySVw3BtQ8VdlSvwcAcvu2VldK45kYaHXHC6yP9WKKsg=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byu2U355cuY5z6LYFNdSLDjY2nWNJbHYwqTMv2haonR
 tcq65h3lLIwiHExyIopsqQU7ebWiK79VJgQ3wIzh5UJZAgDF6cATGRWH8M/bSkpMyOu3ZuiUyKv
 s+34fcnmwj2ftH1hDPOTZrcb/JjQwciwrdDrxrf1b/cXzY3MPyxivDqlxUfFsIJ1b3pkRcrOA5O
 5AQ==
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
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 72 +++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 05b48be05abd..ccd268d76235 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -694,6 +694,23 @@ static int kvm_map_pmu_event(struct arm_pmu *pmu, unsigned int eventsel)
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
@@ -823,42 +840,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
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
@@ -1098,7 +1079,24 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
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

