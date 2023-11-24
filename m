Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B743381D4
	for <kvmarm@lists.linux.dev>; Fri, 24 Nov 2023 16:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 213D01BCA;
	Fri, 24 Nov 2023 08:36:53 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 718883F73F;
	Fri, 24 Nov 2023 08:36:04 -0800 (PST)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org,
	aneesh.kumar@linux.ibm.com,
	broonie@kernel.org,
	catalin.marinas@arm.com,
	dave.hansen@linux.intel.com,
	joey.gouly@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	shuah@kernel.org,
	will@kernel.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 18/25] arm64/ptrace: add support for FEAT_POE
Date: Fri, 24 Nov 2023 16:35:03 +0000
Message-Id: <20231124163510.1835740-19-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231124163510.1835740-1-joey.gouly@arm.com>
References: <20231124163510.1835740-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a regset for POE containing POR_EL0.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/ptrace.c | 46 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h   |  1 +
 2 files changed, 47 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 20d7ef82de90..c3257a5c97f1 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1409,6 +1409,39 @@ static int tagged_addr_ctrl_set(struct task_struct *target, const struct
 }
 #endif
 
+#ifdef CONFIG_ARM64_POE
+static int poe_get(struct task_struct *target,
+		   const struct user_regset *regset,
+		   struct membuf to)
+{
+	if (!system_supports_poe())
+		return -EINVAL;
+
+	return membuf_write(&to, &target->thread.por_el0,
+			    sizeof(target->thread.por_el0));
+}
+
+static int poe_set(struct task_struct *target, const struct
+		   user_regset *regset, unsigned int pos,
+		   unsigned int count, const void *kbuf, const
+		   void __user *ubuf)
+{
+	int ret;
+	long ctrl;
+
+	if (!system_supports_poe())
+		return -EINVAL;
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &ctrl, 0, -1);
+	if (ret)
+		return ret;
+
+	target->thread.por_el0 = ctrl;
+
+	return 0;
+}
+#endif
+
 enum aarch64_regset {
 	REGSET_GPR,
 	REGSET_FPR,
@@ -1437,6 +1470,9 @@ enum aarch64_regset {
 #ifdef CONFIG_ARM64_TAGGED_ADDR_ABI
 	REGSET_TAGGED_ADDR_CTRL,
 #endif
+#ifdef CONFIG_ARM64_POE
+	REGSET_POE
+#endif
 };
 
 static const struct user_regset aarch64_regsets[] = {
@@ -1587,6 +1623,16 @@ static const struct user_regset aarch64_regsets[] = {
 		.set = tagged_addr_ctrl_set,
 	},
 #endif
+#ifdef CONFIG_ARM64_POE
+	[REGSET_POE] = {
+		.core_note_type = NT_ARM_POE,
+		.n = 1,
+		.size = sizeof(long),
+		.align = sizeof(long),
+		.regset_get = poe_get,
+		.set = poe_set,
+	},
+#endif
 };
 
 static const struct user_regset_view user_aarch64_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 9417309b7230..f2713efcd81b 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -440,6 +440,7 @@ typedef struct elf64_shdr {
 #define NT_ARM_SSVE	0x40b		/* ARM Streaming SVE registers */
 #define NT_ARM_ZA	0x40c		/* ARM SME ZA registers */
 #define NT_ARM_ZT	0x40d		/* ARM SME ZT registers */
+#define NT_ARM_POE	0x40f		/* ARM POE registers */
 #define NT_ARC_V2	0x600		/* ARCv2 accumulator/extra registers */
 #define NT_VMCOREDD	0x700		/* Vmcore Device Dump Note */
 #define NT_MIPS_DSP	0x800		/* MIPS DSP ASE registers */
-- 
2.25.1

