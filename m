Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9262E17741
	for <kvmarm@lists.linux.dev>; Tue,  6 Feb 2024 19:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707249517; cv=none; b=fyk0JGtZ8aJ4bGyIG14npJXVm589fJJZqZJif+bBkXYAIowBratDqHECUDeJD8x4b8Dt/njZYZB7BUK5CVOkPKLjp/aUpFQvdpVdFNZlOn5nZxJBeIi4fAbRU+5l0eYAWcifPmw+DjzNVrdy+Xomi9/ba1C2b6ddgQGMrSKVPfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707249517; c=relaxed/simple;
	bh=CSs8R3eAqFpZbozTGGxVMdRi1LPhZmwG0SUML7+4tx4=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=CYTAk3hhYzHA16KpDPxilvR2URX8yz/G9eIysehO6lbnmSSn0ZJu7dUgwdy0Dsu/fWIg8F30bGfycZK/c6ZOgFRqyLv3jP3UoK+UVw8KpS6TvHp3mkpX2G+S29MnaZqMLmRNB4UwCAuUMN2zv/BHYDet2a248QYK382iWLv69eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=QVf5neav; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="QVf5neav"
Received: from rrs24-12-35.corp.microsoft.com (unknown [131.107.8.19])
	by linux.microsoft.com (Postfix) with ESMTPSA id E764F20B2000;
	Tue,  6 Feb 2024 11:58:33 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E764F20B2000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1707249514;
	bh=YiGmA9Lr1a/CDIgqHElD8PPnAN1LFYjN75PS7RDnPho=;
	h=From:To:Subject:Date:From;
	b=QVf5neav0galuOadt6P17o8D+jpDq8FW0dD+dOrJecGZiNAcOz3KgLTnX01F6RU9G
	 Kgt5DG9JP3uEkIGH1aTeUYBiD23JfuLOCzEo5q+slprE1w1TSUoWfrvMQVnGpRPk9Q
	 XZXfHj/Uf9P1AOnahuIRFutrj/ftsu+Qlsgbah5Y=
From: Easwar Hariharan <eahariha@linux.microsoft.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Rob Herring <robh@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)),
	linux-kernel@vger.kernel.org (open list),
	kvmarm@lists.linux.dev (open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64))
Subject: [RFC PATCH] KVM: arm64: Override Microsoft Azure Cobalt 100 MIDR value with ARM Neoverse N2
Date: Tue,  6 Feb 2024 19:58:16 +0000
Message-Id: <20240206195819.1146693-1-eahariha@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several workload optimizations and errata depend on validating that the
optimization or errata are applicable to the particular CPU by checking
the MIDR_EL1 system register value. With the Microsoft implementer ID
for Azure Cobalt 100, the value doesn't match and ~20-25% performance
regression is seen in these workloads. Override the Azure Cobalt 100
value and replace it with the default ARM Neoverse N2 value that Azure
Cobalt 100 is based on.

Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
---
 arch/arm64/include/asm/cputype.h   | 3 ++-
 arch/arm64/include/asm/el2_setup.h | 5 +++++
 arch/arm64/kvm/sys_regs.c          | 9 ++++++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 7c7493cb571f..0450c6c32377 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -262,7 +262,8 @@ is_midr_in_range_list(u32 midr, struct midr_range const *ranges)
  */
 static inline u32 __attribute_const__ read_cpuid_id(void)
 {
-	return read_cpuid(MIDR_EL1);
+	return (read_cpuid(MIDR_EL1) == 0x6D0FD490 ? 0x410FD490 :
+			read_cpuid(MIDR_EL1));
 }
 
 static inline u64 __attribute_const__ read_cpuid_mpidr(void)
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index b7afaa026842..502a14e54a31 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -138,6 +138,11 @@
 .macro __init_el2_nvhe_idregs
 	mrs	x0, midr_el1
 	mrs	x1, mpidr_el1
+	ldr	x2, =0x6D0FD490
+	cmp	x0, x2
+	bne	.Loverride_cobalt100_\@
+	ldr	x0, =0x410FD490
+.Loverride_cobalt100_\@:
 	msr	vpidr_el2, x0
 	msr	vmpidr_el2, x1
 .endm
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 30253bd19917..8ea9c7fdabdb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3574,7 +3574,14 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 		return ((struct sys_reg_desc *)r)->val;			\
 	}
 
-FUNCTION_INVARIANT(midr_el1)
+static u64 get_midr_el1(struct kvm_vcpu *v, const struct sys_reg_desc *r)
+{
+	((struct sys_reg_desc *)r)->val = read_sysreg(midr_el1);
+	if (((struct sys_reg_desc *)r)->val == 0x6D0FD490)
+		((struct sys_reg_desc *)r)->val == 0x410FD490;
+	return ((struct sys_reg_desc *)r)->val;
+}
+
 FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
-- 
2.34.1

