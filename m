Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6824DD291
	for <kvmarm@lists.linux.dev>; Thu, 12 Oct 2023 06:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6444413D5;
	Wed, 11 Oct 2023 23:47:11 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.62.137])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C813C3F5A1;
	Wed, 11 Oct 2023 23:46:27 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: arm64: pmu: Drop redundant check for non-NULL kvm_pmu_events
Date: Thu, 12 Oct 2023 12:16:17 +0530
Message-Id: <20231012064617.897346-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is an allocated and valid struct kvm_pmu_events for each cpu on the
system via DEFINE_PER_CPU(). Hence there cannot be a NULL pointer accessed
via this_cpu_ptr() in the helper kvm_get_pmu_events(). Hence non-NULL check
for pmu in such places are redundant and can be dropped.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/kvm/pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 0eea225fd09a..a243934c5568 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -39,7 +39,7 @@ void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr)
 {
 	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
 
-	if (!kvm_arm_support_pmu_v3() || !pmu || !kvm_pmu_switch_needed(attr))
+	if (!kvm_arm_support_pmu_v3() || !kvm_pmu_switch_needed(attr))
 		return;
 
 	if (!attr->exclude_host)
@@ -55,7 +55,7 @@ void kvm_clr_pmu_events(u32 clr)
 {
 	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
 
-	if (!kvm_arm_support_pmu_v3() || !pmu)
+	if (!kvm_arm_support_pmu_v3())
 		return;
 
 	pmu->events_host &= ~clr;
-- 
2.25.1

