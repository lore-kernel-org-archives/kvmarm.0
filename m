Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.60
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794933439;
	b=UNQpwlgACjTIc1vn/AmEYY00aJz/nD4MREg/brTFwF/34ZXECB07DmOBfhkjxFtaJ8H+
	 9PzRqEGAp0CywJaQYhP4grD4ySs5zIvDoTXp2FutkCPDD9yYAe96GvBMxrxKTtlG715ry
	 UOqf8nBcZAFKHvw/rd11wHb2H0gaejhsuxDYgWNwVCFwyOk1SmSppCeYyrWeFYXlLkhfV
	 dSFAoDfLgb5veyiqPBzr4pSIonPALe/ZrGY2MyubWTXci3nCdijpG4S0EHrDl3SIs5TQY
	 Fdr5ylG3zcaLqehCmVi6qSUHyCgV/yM22eVicFAmsGcGmgtyOuCam7yBF/IX4WIE3fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794933439;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=z4eKzkcWk1IKH8doz5gGRdUtFm1MYHG1rOm73vYxulA=;
	b=NvnKY3q42pYUg3H4E2zzhOgSrHIH8UpYe83Jf2bCpol697VjIffsBsf1XTCT+o57gasM
	 Jk9OKAcbEfndQV31brvRUThQXt6wGpCeAJx+d7No0xCIrmn0lGbVDuiYUsIoeYTuic/O6
	 aHdsgzD61mWUUrfxg/0TvkOlJb2UIgCBrTOgtT+lyu4f6nuiXzEOfPwfA/DCxpJL5aaN1
	 BgQyWc9te5RBU2KCgzImYwV+zo6PlK7FXYYD+EBH+MRrQceAB9FZs++PNpGgRp5YwRDll
	 BEzbFIUw7Ete0zZ5f4pA/PDhZjmVrr5MkbNCOlWsP2Tpb/G0O7j9nJ0NxpN0JR9B++A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oCy0qdYw;
	arc=none smtp.remote-ip=95.215.58.60
Received: from mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD187606A332
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 16:37:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD187606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oCy0qdYw
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=LbJlXuBe4UMUHY+VoPzgCOZA0cis0LLWHwrzjRk/Y8U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794933436; v=1; x=1795538236;
 b=oCy0qdYwjeDHXe38vwxDSNQWEPbJs0QvpI7Cn4S+JOWRJ2KeFXZxg2o/OvJhxUyURdF93C2D
 CYF048gJn2QYofCCG7NQR/vfrspyRogaMuHWdGfa5gV3tT3BgPHTjFCS8VrY9NmF+f78oIrjt/f
 Ee6HhJL6cSI/liDdjB0CkzXA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 9105d92f22dcb935;
	Tue, 17 Nov 2026 16:37:12 +0000
X-Mizu-Trace-ID: 9105d92f22dcb935
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: arm64: Don't forward the host's SDEI calls to firmware
Date: Tue, 17 Nov 2026 16:37:00 +0000
Message-ID: <20261117163702.1678277-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117163702.1678277-1-fuad.tabba@linux.dev>
References: <20261117163702.1678277-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In protected mode, EL2 forwards host SMCs that it doesn't handle to
EL3, where they arrive as calls from EL2. TF-A treats EL2 as the SDEI
client whenever EL2 is implemented, so the host can register an event
handler that runs at EL2.

A pKVM host kernel can't use SDEI, since sdei_arch_get_entry_point()
fails when the kernel is booted at EL2 but runs at EL1. Return
NOT_SUPPORTED for SDEI calls instead of forwarding them.

Fixes: b93c17c4185bf ("KVM: arm64: Trap host SMCs in protected mode")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 179d7c8277b88..37fb9896ba3ad 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -10,6 +10,7 @@
 #include <hyp/switch.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
+#include <uapi/linux/arm_sdei.h>
 #include <uapi/linux/psci.h>
 
 #include <asm/pgtable-types.h>
@@ -1647,8 +1648,14 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
 }
 
-static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
+static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt, u64 func_id)
 {
+	/* Firmware would enter the host's SDEI event handlers at EL2. */
+	if ((func_id & SDEI_1_0_MASK) == SDEI_1_0_FN_BASE) {
+		cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
+		return;
+	}
+
 	trace_hyp_exit(host_ctxt, HYP_REASON_SMC);
 	__kvm_hyp_host_forward_smc(host_ctxt);
 	trace_hyp_enter(host_ctxt, HYP_REASON_SMC);
@@ -1675,7 +1682,7 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	if (!handled)
 		handled = kvm_host_ffa_handler(host_ctxt, func_id);
 	if (!handled)
-		default_host_smc_handler(host_ctxt);
+		default_host_smc_handler(host_ctxt, func_id);
 
 exit_skip_instr:
 	/* SMC was trapped, move ELR past the current PC. */

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.47.3

