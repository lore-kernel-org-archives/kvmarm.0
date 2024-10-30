Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89A3F36126
	for <kvmarm@lists.linux.dev>; Wed, 30 Oct 2024 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730304212; cv=none; b=OyRNnCAv2Nery26VcsPvEYJ8oZsYALzXKmGODmv+LHMwGQDYl3R4XekWFqrS1ulToIj6+UORL8ZUMhv6RTlHiaA0XX1hQrSARlOAiqROPqWc+VyoNWa+atq9rrhPSyqA/spxFIRv1UOfnVB5BXe3cNeGd+0o+dQG4Rus6nM3mDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730304212; c=relaxed/simple;
	bh=OtdXOUA4QKEiF9uXIzjUm2NE7VsRt0sP3jhZI/yRZJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GD1eZKJlSOGMKp75ht8jurZW+FSJuuFRmxmIAGRoNXcM8THQM5ZX/8PXpi6dPtwvJwBu8IwEhIEe2bDOeEbK39c/BsoQiIRDSYbh5efebYwkl60idBXmxzu8SSxjsxiwBxeZDuk1KcfEfBvRYBvt6vur1ElLxWPB/LkQREqyNNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1557176C;
	Wed, 30 Oct 2024 09:03:59 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D909F3F528;
	Wed, 30 Oct 2024 09:03:27 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: anshuman.khandual@arm.com,
	gshan@redhat.com,
	james.morse@arm.com,
	joey.gouly@arm.com,
	shameerali.kolothum.thodi@huawei.com,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v6 2/7] arm64: head.S: Initialise MPAM EL2 registers and disable traps
Date: Wed, 30 Oct 2024 16:03:12 +0000
Message-Id: <20241030160317.2528209-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241030160317.2528209-1-joey.gouly@arm.com>
References: <20241030160317.2528209-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: James Morse <james.morse@arm.com>

Add code to head.S's el2_setup to detect MPAM and disable any EL2 traps.
This register resets to an unknown value, setting it to the default
parititons/pmg before we enable the MMU is the best thing to do.

Kexec/kdump will depend on this if the previous kernel left the CPU
configured with a restrictive configuration.

If linux is booted at the highest implemented exception level el2_setup
will clear the enable bit, disabling MPAM.

This code can't be enabled until a subsequent patch adds the Kconfig
and cpufeature boiler plate.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/el2_setup.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index e0ffdf13a18b..4cd41464be3f 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -220,6 +220,19 @@
 	msr	spsr_el2, x0
 .endm
 
+.macro __init_el2_mpam
+	/* Memory Partitioning And Monitoring: disable EL2 traps */
+	mrs	x1, id_aa64pfr0_el1
+	ubfx	x0, x1, #ID_AA64PFR0_EL1_MPAM_SHIFT, #4
+	cbz	x0, .Lskip_mpam_\@		// skip if no MPAM
+	msr_s	SYS_MPAM2_EL2, xzr		// use the default partition
+						// and disable lower traps
+	mrs_s	x0, SYS_MPAMIDR_EL1
+	tbz	x0, #MPAMIDR_EL1_HAS_HCR_SHIFT, .Lskip_mpam_\@	// skip if no MPAMHCR reg
+	msr_s	SYS_MPAMHCR_EL2, xzr		// clear TRAP_MPAMIDR_EL1 -> EL2
+.Lskip_mpam_\@:
+.endm
+
 /**
  * Initialize EL2 registers to sane values. This should be called early on all
  * cores that were booted in EL2. Note that everything gets initialised as
@@ -237,6 +250,7 @@
 	__init_el2_stage2
 	__init_el2_gicv3
 	__init_el2_hstr
+	__init_el2_mpam
 	__init_el2_nvhe_idregs
 	__init_el2_cptr
 	__init_el2_fgt
-- 
2.25.1

