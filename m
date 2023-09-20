Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6D23CCF9
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 19:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1695238093; x=1726774093;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dHQ/IkMgpqc/cc830nOBcba0JO3V/dW0PDzOz1fOh1Y=;
  b=TLWO7Khh8y29RLmDMs+6O7iUGw7I4ejOUjNSP9vL57Lpg7jnKBCvW12h
   fQVuUW1eG5TorjsHujJYg6cJnCR2WkceN7Ztfkx422OGDJoeWj4d+gDwG
   jim90IGiY0M+gRgMosHla5NZTwyE94w5mL+pRuJftFcMIHtLco2YooFEA
   8=;
X-IronPort-AV: E=Sophos;i="6.03,162,1694736000"; 
   d="scan'208";a="239951116"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 19:28:11 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com (Postfix) with ESMTPS id 0FA6681A05;
	Wed, 20 Sep 2023 19:28:05 +0000 (UTC)
Received: from EX19D030UWB002.ant.amazon.com (10.13.139.182) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Wed, 20 Sep 2023 19:27:47 +0000
Received: from u1e958862c3245e.ant.amazon.com (10.111.86.147) by
 EX19D030UWB002.ant.amazon.com (10.13.139.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Wed, 20 Sep 2023 19:27:46 +0000
From: Suraj Jitindar Singh <surajjs@amazon.com>
To: <stable@vger.kernel.org>
CC: <james.morse@arm.com>, <alexandru.elisei@arm.com>,
	<suzuki.poulose@arm.com>, <oliver.upton@linux.dev>,
	<catalin.marinas@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <kvmarm@lists.cs.columbia.edu>,
	<linux-kernel@vger.kernel.org>, <sjitindarsingh@gmail.com>, Quentin Perret
	<qperret@google.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Vincent Donnefort <vdonnefort@google.com>, Will Deacon
	<will@kernel.org>, Marc Zyngier <maz@kernel.org>, Suraj Jitindar Singh
	<surajjs@amazon.com>
Subject: [PATCH stable 6.1.y 1/2] KVM: arm64: Prevent the donation of no-map pages
Date: Wed, 20 Sep 2023 12:27:28 -0700
Message-ID: <20230920192729.694309-1-surajjs@amazon.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.86.147]
X-ClientProxiedBy: EX19D041UWB003.ant.amazon.com (10.13.139.176) To
 EX19D030UWB002.ant.amazon.com (10.13.139.182)

From: Quentin Perret <qperret@google.com>

commit 43c1ff8b75011bc3e3e923adf31ba815864a2494 upstream.

Memory regions marked as "no-map" in the host device-tree routinely
include TrustZone carev-outs and DMA pools. Although donating such pages
to the hypervisor may not breach confidentiality, it could be used to
corrupt its state in uncontrollable ways. To prevent this, let's block
host-initiated memory transitions targeting "no-map" pages altogether in
nVHE protected mode as there should be no valid reason to do this in
current operation.

Thankfully, the pKVM EL2 hypervisor has a full copy of the host's list
of memblock regions, so we can easily check for the presence of the
MEMBLOCK_NOMAP flag on a region containing pages being donated from the
host.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221110190259.26861-8-will@kernel.org
[ bp: clean ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 07f9dc9848ef..0f6c053686c7 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -195,7 +195,7 @@ struct kvm_mem_range {
 	u64 end;
 };
 
-static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
+static struct memblock_region *find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 {
 	int cur, left = 0, right = hyp_memblock_nr;
 	struct memblock_region *reg;
@@ -218,18 +218,28 @@ static bool find_mem_range(phys_addr_t addr, struct kvm_mem_range *range)
 		} else {
 			range->start = reg->base;
 			range->end = end;
-			return true;
+			return reg;
 		}
 	}
 
-	return false;
+	return NULL;
 }
 
 bool addr_is_memory(phys_addr_t phys)
 {
 	struct kvm_mem_range range;
 
-	return find_mem_range(phys, &range);
+	return !!find_mem_range(phys, &range);
+}
+
+static bool addr_is_allowed_memory(phys_addr_t phys)
+{
+	struct memblock_region *reg;
+	struct kvm_mem_range range;
+
+	reg = find_mem_range(phys, &range);
+
+	return reg && !(reg->flags & MEMBLOCK_NOMAP);
 }
 
 static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
@@ -348,7 +358,7 @@ static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot pr
 static int host_stage2_idmap(u64 addr)
 {
 	struct kvm_mem_range range;
-	bool is_memory = find_mem_range(addr, &range);
+	bool is_memory = !!find_mem_range(addr, &range);
 	enum kvm_pgtable_prot prot;
 	int ret;
 
@@ -425,7 +435,7 @@ static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
 	struct check_walk_data *d = arg;
 	kvm_pte_t pte = *ptep;
 
-	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
+	if (kvm_pte_valid(pte) && !addr_is_allowed_memory(kvm_pte_to_phys(pte)))
 		return -EINVAL;
 
 	return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
-- 
2.34.1

