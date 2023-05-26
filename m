Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A223AD27
	for <kvmarm@lists.linux.dev>; Fri, 26 May 2023 08:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685088885; x=1716624885;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HPGDHu6IKq4H5POSoCBIPfi5+ElxIaYyDhGjzmz4eVM=;
  b=f5Y3sPLcNXPZAmoJOq3z0qA1qNRqNhOA9i5jW3MkmFhgOqxkBQi4LAVy
   CTKIeSrUEN+j1fTFZSreCY0b8jIeXW8FP5BPOVtMbxx6W77HXMfgzQllB
   VuvyjpTs+YFtQVGx1oKZi132vNOBVMyqNtu3purXUdfHOO5e0J34m4kEO
   WxGDcRUWJdyx0Ilyi5A8SogHukp983ZffZTmsQYESsRF2b+XDB/t0DHRD
   r6Fedl5pZwQGcbYrn35K6zMGwiN/8ABeLcENTnee3hmz0Qs36sGB+YN0w
   wK/ifoLM2PnKjFR0caVUSyGgQf5s1VYoP2Y0v1yxlQmX9NunWGpYzSfci
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="440503371"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="440503371"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 01:14:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="705115769"
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="705115769"
Received: from ubuntu.bj.intel.com ([10.238.156.105])
  by orsmga002.jf.intel.com with ESMTP; 26 May 2023 01:14:42 -0700
From: Jun Miao <jun.miao@intel.com>
To: maz@kernel.org,
	oliver.upton@linux.de,
	james.morse@arm.com,
	linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev,
	jun.miao@intel.com
Subject: [PATCH] KVM: arm64: fix typo
Date: Fri, 26 May 2023 16:15:48 +0800
Message-Id: <20230526081548.12729-1-jun.miao@intel.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change "begining" to "beginning"

Fixes: 8e6bcc3a4502 ("KVM: arm64: Back the hypervisor 'struct hyp_page' array for all memory")
Signed-off-by: Jun Miao <jun.miao@intel.com>
---
 arch/arm64/kvm/hyp/nvhe/mm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 318298eb3d6b..f16d9f38bb48 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -145,7 +145,7 @@ int hyp_back_vmemmap(phys_addr_t back)
 		start = hyp_memory[i].base;
 		start = ALIGN_DOWN((u64)hyp_phys_to_page(start), PAGE_SIZE);
 		/*
-		 * The begining of the hyp_vmemmap region for the current
+		 * The beginning of the hyp_vmemmap region for the current
 		 * memblock may already be backed by the page backing the end
 		 * the previous region, so avoid mapping it twice.
 		 */
-- 
2.32.0

