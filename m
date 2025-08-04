Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D41723A58B
	for <kvmarm@lists.linux.dev>; Mon,  4 Aug 2025 12:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309883; cv=none; b=LohGgnaP0BCR48MJb7S4NFznO8W1i80gJCOFLdDPxUVE5awdrLlToP92etS6PD6mgGZ0OTnQFMMiX6BHfZDCDyrmvfXkRdriDAvKEVWZaF+yHp/57lornpAGzjrb3VlIKLmZGuOw70L/QWDuY2Va5uBsHE7XFl2yAPhwqbCkDK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309883; c=relaxed/simple;
	bh=yyHiKn3TTe/WLOZndQLfBtKivmH21ktYqHo2TtBhYCA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j+klTX+fJCPighgdmhASTiFb+iyC+6t1c5EkStneTZyuszgl7UGlG+NbGZ6xftaa/WsgMidFnF3Camnt4VPVaH304H7gX1yHINvQojCVd6zYX+t2Gcr+1fu2LTrOdJ806nWzUbRXts72L+lwttusSb8I54ESMchsNaH11rZ0ORo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91355150C;
	Mon,  4 Aug 2025 05:17:53 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E987D3F738;
	Mon,  4 Aug 2025 05:17:57 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	anshuman.khandual@arm.com,
	robh@kernel.org,
	james.morse@arm.com,
	mark.rutland@arm.com,
	joey.gouly@arm.com,
	ry111@xry111.site,
	Dave.Martin@arm.com,
	ahmed.genidi@arm.com,
	kevin.brodsky@arm.com,
	scott@os.amperecomputing.com,
	mbenes@suse.cz,
	james.clark@linaro.org,
	frederic@kernel.org,
	rafael@kernel.org,
	pavel@kernel.org,
	ryan.roberts@arm.com,
	suzuki.poulose@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH 08/11] KVM: arm64: initialise SCTLR2_EL1 at __kvm_host_psci_cpu_entry()
Date: Mon,  4 Aug 2025 13:17:21 +0100
Message-Id: <20250804121724.3681531-9-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250804121724.3681531-1-yeoreum.yun@arm.com>
References: <20250804121724.3681531-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

initialise SCTLR2_EL1 at __kvm_host_psci_cpu_entry().

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kvm/hyp/nvhe/psci-relay.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index c3e196fb8b18..4ed4b7fa57c2 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -4,6 +4,7 @@
  * Author: David Brazdil <dbrazdil@google.com>
  */

+#include <asm/alternative.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
@@ -219,6 +220,8 @@ asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on)
 		release_boot_args(boot_args);

 	write_sysreg_el1(INIT_SCTLR_EL1_MMU_OFF, SYS_SCTLR);
+	if (alternative_has_cap_unlikely(ARM64_HAS_SCTLR2))
+		write_sysreg_el1(INIT_SCTLR2_EL1, SYS_SCTLR2);
 	write_sysreg(INIT_PSTATE_EL1, SPSR_EL2);

 	__host_enter(host_ctxt);
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

