Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE682E62B9
	for <kvmarm@lists.linux.dev>; Thu,  3 Apr 2025 23:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743722204; cv=none; b=KJH3QD9r9RtZNhazQjr3S9XnpLnzPUurlPWgSbGTLGCyX5jPeSW5Gq1uW86jdeSV3VVAcyPvU6xHlUa9i0/eKpvRXYEde9jwUBhXEvaIT9cM/64LdOF6x2ClxXLMQ4/qZ9yzWaacerTZf5291XIKww4fqHA2Iudo28oyo7dnE48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743722204; c=relaxed/simple;
	bh=wh0ytXTxl9aARb2BhoKoJMizTos4zQMkR1yl7m9eloM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=awczIUh65uFqHYxUf3wxmmgne99SiS4Rk6Ug6phq45CzPaOLg7931rQgdhety896dT+MEj3PUTGdOvNRSOu6u785wwma79ZfciKYpY6eWLFWwGx4i3xQt/znSM/gsHlFsJTaxtciBco529L7N6SyE+4oBTznHWStwiUW9I8I75Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pmtunawC; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pmtunawC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743722199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IqS3NdTst9jPygMvsQyB6MPquwdcmmsi0yUtNVz3Gu0=;
	b=pmtunawCbG6a8u2RCEMMHTx10edaX9Cli0uRrxuCMq1apP7mJxVW9KkEXXiWtzGhsSZVnx
	/yH3pVg/RlCwS3G+bKiYVDVhRdWOfsOgvTd0zui48epnGxpwK1el7zBboLyB29U/SnHQIu
	CkjFizMSZoSMz9zbjnJ9C90IXaTFhyY=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] arm64: Expose AIDR_EL1 via sysfs
Date: Thu,  3 Apr 2025 16:16:26 -0700
Message-Id: <20250403231626.3181116-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The KVM PV ABI recently added a feature that allows the VM to discover
the set of physical CPU implementations, identified by a tuple of
{MIDR_EL1, REVIDR_EL1, AIDR_EL1}. Unlike other KVM PV features, the
expectation is that the VMM implements the hypercall instead of KVM as
it has the authoritative view of where the VM gets scheduled.

To do this the VMM needs to know the values of these registers on any
CPU in the system. While MIDR_EL1 and REVIDR_EL1 are already exposed,
AIDR_EL1 is not. Provide it in sysfs along with the other identification
registers.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu |  1 +
 Documentation/arch/arm64/cpu-feature-registers.rst | 13 +++++++------
 arch/arm64/include/asm/cpu.h                       |  1 +
 arch/arm64/kernel/cpuinfo.c                        |  3 +++
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 206079d3bd5b..9bbf4c27c237 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -485,6 +485,7 @@ What:		/sys/devices/system/cpu/cpuX/regs/
 		/sys/devices/system/cpu/cpuX/regs/identification/
 		/sys/devices/system/cpu/cpuX/regs/identification/midr_el1
 		/sys/devices/system/cpu/cpuX/regs/identification/revidr_el1
+		/sys/devices/system/cpu/cpuX/regs/identification/aidr_el1
 		/sys/devices/system/cpu/cpuX/regs/identification/smidr_el1
 Date:		June 2016
 Contact:	Linux ARM Kernel Mailing list <linux-arm-kernel@lists.infradead.org>
diff --git a/Documentation/arch/arm64/cpu-feature-registers.rst b/Documentation/arch/arm64/cpu-feature-registers.rst
index 253e9743de2f..add66afc7b03 100644
--- a/Documentation/arch/arm64/cpu-feature-registers.rst
+++ b/Documentation/arch/arm64/cpu-feature-registers.rst
@@ -72,14 +72,15 @@ there are some issues with their usage.
     process could be migrated to another CPU by the time it uses the
     register value, unless the CPU affinity is set. Hence, there is no
     guarantee that the value reflects the processor that it is
-    currently executing on. The REVIDR is not exposed due to this
-    constraint, as REVIDR makes sense only in conjunction with the
-    MIDR. Alternately, MIDR_EL1 and REVIDR_EL1 are exposed via sysfs
-    at::
+    currently executing on. REVIDR and AIDR are not exposed due to this
+    constraint, as these registers only make sense in conjunction with
+    the MIDR. Alternately, MIDR_EL1, REVIDR_EL1, and AIDR_EL1 are exposed
+    via sysfs at::
 
 	/sys/devices/system/cpu/cpu$ID/regs/identification/
-	                                              \- midr
-	                                              \- revidr
+	                                              \- midr_el1
+	                                              \- revidr_el1
+	                                              \- aidr_el1
 
 3. Implementation
 --------------------
diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index 81e4157f92b7..71493b760b83 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -44,6 +44,7 @@ struct cpuinfo_arm64 {
 	u64		reg_dczid;
 	u64		reg_midr;
 	u64		reg_revidr;
+	u64		reg_aidr;
 	u64		reg_gmid;
 	u64		reg_smidr;
 	u64		reg_mpamidr;
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 285d7d538342..621218d2a991 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -328,11 +328,13 @@ static const struct kobj_type cpuregs_kobj_type = {
 
 CPUREGS_ATTR_RO(midr_el1, midr);
 CPUREGS_ATTR_RO(revidr_el1, revidr);
+CPUREGS_ATTR_RO(aidr_el1, aidr);
 CPUREGS_ATTR_RO(smidr_el1, smidr);
 
 static struct attribute *cpuregs_id_attrs[] = {
 	&cpuregs_attr_midr_el1.attr,
 	&cpuregs_attr_revidr_el1.attr,
+	&cpuregs_attr_aidr_el1.attr,
 	NULL
 };
 
@@ -469,6 +471,7 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 	info->reg_dczid = read_cpuid(DCZID_EL0);
 	info->reg_midr = read_cpuid_id();
 	info->reg_revidr = read_cpuid(REVIDR_EL1);
+	info->reg_aidr = read_cpuid(AIDR_EL1);
 
 	info->reg_id_aa64dfr0 = read_cpuid(ID_AA64DFR0_EL1);
 	info->reg_id_aa64dfr1 = read_cpuid(ID_AA64DFR1_EL1);

base-commit: e8b471285262d1561feb2eb266aab6ebe7094124
-- 
2.39.5

