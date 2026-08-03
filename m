Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBD5411660
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 12:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785760958; cv=none; b=joC04NgWPR3YoRx3ixxhT9lOPRXZc8pRJfFBJ+2n5YJLEz+aHfcN56oz4eTIXidLax41HvARxCQVHk+/wegeLpK32gfJBHM5b8aAwzfHoY4TsZQdoAKjqokD7SBU2ZdhVxkzqF94Br+97oFS6dROIHeZlI/xJl2gvDq3ZJpDMsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785760958; c=relaxed/simple;
	bh=GaZD8YNbLBwQa9XjzIdEKqb+R+kYZ0rTi364A3qmdig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l0XDFX5lpB99koOgi/gFiot2PC9c8STXEEkXGNF1/gtoiz+JG/X86DDSORuzuottrnKfcw9nlZonoLm9NASVlnq+fup+Zq5p6vWSp2a1erTOBnTWfu74XW17p6IG05Cjpkpyxsp8+yyzua8wgLL9ug3pp2XioQik/sKPJ2Asz3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fLluRGTU; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fLluRGTU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785760954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mbmwUYRMkOEfVhoKhlo/B+eCrpuKcZd9NIaZ5Zet0iU=;
	b=fLluRGTUvfCee++jU1Sc9EXXlzbd+DqgR6e7R71FS/ubVVD+C8AvO6b9xRkSWHFsykTebX
	kTf9qaC7colywkIX+UtMZ5xMrFa1LSI2XxJOPdHRuFXXfiTYBNkxnUHcN68UFZgMr+ht2y
	NzW+WKmLfD/Ofk+XYumKkQVQSJF1pHY=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: maz@kernel.org,
	oupton@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	alexandru.elisei@arm.com,
	vdonnefort@google.com,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	qperret@google.com,
	ardb@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	tabba@google.com,
	fuad.tabba@linux.dev
Subject: [PATCH v2 02/11] KVM: arm64: nVHE: Share the stacktrace per-CPU declarations with EL2
Date: Mon,  3 Aug 2026 13:42:11 +0100
Message-Id: <20260803124220.332248-3-fuad.tabba@linux.dev>
In-Reply-To: <20260803124220.332248-1-fuad.tabba@linux.dev>
References: <20260803124220.332248-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The declarations for overflow_stack, kvm_stacktrace_info and
pkvm_stacktrace are only visible to the host (the first two sit in the
host-only section of stacktrace/nvhe.h, the last is private to
kvm/stacktrace.c), so the definitions in nvhe/stacktrace.c compile
with no declaration in sight and sparse suggests making them static.
DECLARE_KVM_NVHE_PER_CPU() resolves to the right symbol name on both
sides of the build: move the declarations where both can see them and
include the header from the EL2 side unconditionally.

No functional change intended.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/stacktrace/nvhe.h | 10 ++++++++--
 arch/arm64/kvm/hyp/nvhe/stacktrace.c     |  3 +--
 arch/arm64/kvm/stacktrace.c              |  3 ---
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/stacktrace/nvhe.h b/arch/arm64/include/asm/stacktrace/nvhe.h
index 171f9edef49fc..a631a577cbe5d 100644
--- a/arch/arm64/include/asm/stacktrace/nvhe.h
+++ b/arch/arm64/include/asm/stacktrace/nvhe.h
@@ -37,6 +37,14 @@ static inline void kvm_nvhe_unwind_init(struct unwind_state *state,
 	state->pc = pc;
 }
 
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
+DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
+
+#ifdef CONFIG_PKVM_STACKTRACE
+DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
+			 pkvm_stacktrace);
+#endif
+
 #ifndef __KVM_NVHE_HYPERVISOR__
 /*
  * Conventional (non-protected) nVHE HYP stack unwinder
@@ -45,8 +53,6 @@ static inline void kvm_nvhe_unwind_init(struct unwind_state *state,
  * (by the host in EL1).
  */
 
-DECLARE_KVM_NVHE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack);
-DECLARE_KVM_NVHE_PER_CPU(struct kvm_nvhe_stacktrace_info, kvm_stacktrace_info);
 DECLARE_PER_CPU(unsigned long, kvm_arm_hyp_stack_base);
 
 void kvm_nvhe_dump_backtrace(unsigned long hyp_offset);
diff --git a/arch/arm64/kvm/hyp/nvhe/stacktrace.c b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
index 7c832d60d22bb..11fadbebbf1d6 100644
--- a/arch/arm64/kvm/hyp/nvhe/stacktrace.c
+++ b/arch/arm64/kvm/hyp/nvhe/stacktrace.c
@@ -8,6 +8,7 @@
 #include <asm/kvm_hyp.h>
 #include <asm/memory.h>
 #include <asm/percpu.h>
+#include <asm/stacktrace/nvhe.h>
 
 DEFINE_PER_CPU(unsigned long [OVERFLOW_STACK_SIZE/sizeof(long)], overflow_stack)
 	__aligned(16);
@@ -35,8 +36,6 @@ static void hyp_prepare_backtrace(unsigned long fp, unsigned long pc)
 }
 
 #ifdef CONFIG_PKVM_STACKTRACE
-#include <asm/stacktrace/nvhe.h>
-
 DEFINE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)], pkvm_stacktrace);
 
 static struct stack_info stackinfo_get_overflow(void)
diff --git a/arch/arm64/kvm/stacktrace.c b/arch/arm64/kvm/stacktrace.c
index 9724c320126b7..69377195e18b7 100644
--- a/arch/arm64/kvm/stacktrace.c
+++ b/arch/arm64/kvm/stacktrace.c
@@ -198,9 +198,6 @@ static void hyp_dump_backtrace(unsigned long hyp_offset)
 }
 
 #ifdef CONFIG_PKVM_STACKTRACE
-DECLARE_KVM_NVHE_PER_CPU(unsigned long [NVHE_STACKTRACE_SIZE/sizeof(long)],
-			 pkvm_stacktrace);
-
 /*
  * pkvm_dump_backtrace - Dump the protected nVHE HYP backtrace.
  *
-- 
2.39.5

