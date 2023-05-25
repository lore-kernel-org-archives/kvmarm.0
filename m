Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03F4BE51
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 07:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685000123; x=1716536123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0UgYCLc+Ugm0nOt5ygaKN4vdmlTln6KfERyjV7b7/jk=;
  b=EENMOChoa+qP4/7bAroDr83U9JJiURYCabWW0aKtFzJ6Dbnhxf6aJGL4
   4pVSzgoBpU2U7nFE2Z/5NGbDhOYex6I7PVDk2MLFpvBYKNXT/he8eMZig
   TMJd+DgxxmjNqdDc5Ga/+6GEhW76LhoHJnmc0cHfqgH7dvHfUYtDM93As
   4qNsjX1ZPsLeEApm6X/g/I1spE8NvohedEEi0OylxAGDNdWI0w2VmHO2u
   ugh06JpOsW4IhOIUKkMup8hKbWP/rhrb+52uS4Fbb0r52Vrv0ApLB+A5V
   mICkpGUzrUQJ/QNeKH4iw1GGAv3T5jmx9xoVvAlBfo+H+DavnP/WOx2Rr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="417281036"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="417281036"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 00:33:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="769775204"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="769775204"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 00:33:13 -0700
From: Haibo Xu <haibo1.xu@intel.com>
To: 
Cc: xiaobo55x@gmail.com,
	haibo1.xu@intel.com,
	ajones@ventanamicro.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	seanjc@google.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Shuah Khan <shuah@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Gardon <bgardon@google.com>,
	David Matlack <dmatlack@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 03/11] KVM: arm64: selftests: Remove print_reg's dependency on vcpu_config
Date: Thu, 25 May 2023 15:38:27 +0800
Message-Id: <3e3be8710d9bb21bd4bc53719ac6100791483e28.1684999824.git.haibo1.xu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1684999824.git.haibo1.xu@intel.com>
References: <cover.1684999824.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

print_reg() and its helpers only use the vcpu_config pointer for
config_name(). So just pass the config name in instead, which is used
as a prefix in asserts. print_reg() can now be compiled independently
of config_name().

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 52 +++++++++----------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 915272c342f9..424285d39965 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -128,7 +128,7 @@ static bool find_reg(__u64 regs[], __u64 nr_regs, __u64 reg)
 #define CORE_SPSR_XX_NR_WORDS	2
 #define CORE_FPREGS_XX_NR_WORDS	4
 
-static const char *core_id_to_str(struct vcpu_config *c, __u64 id)
+static const char *core_id_to_str(const char *prefix, __u64 id)
 {
 	__u64 core_off = id & ~REG_MASK, idx;
 
@@ -139,7 +139,7 @@ static const char *core_id_to_str(struct vcpu_config *c, __u64 id)
 	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
 	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
 		idx = (core_off - KVM_REG_ARM_CORE_REG(regs.regs[0])) / CORE_REGS_XX_NR_WORDS;
-		TEST_ASSERT(idx < 31, "%s: Unexpected regs.regs index: %lld", config_name(c), idx);
+		TEST_ASSERT(idx < 31, "%s: Unexpected regs.regs index: %lld", prefix, idx);
 		return strdup_printf("KVM_REG_ARM_CORE_REG(regs.regs[%lld])", idx);
 	case KVM_REG_ARM_CORE_REG(regs.sp):
 		return "KVM_REG_ARM_CORE_REG(regs.sp)";
@@ -154,12 +154,12 @@ static const char *core_id_to_str(struct vcpu_config *c, __u64 id)
 	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
 	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
 		idx = (core_off - KVM_REG_ARM_CORE_REG(spsr[0])) / CORE_SPSR_XX_NR_WORDS;
-		TEST_ASSERT(idx < KVM_NR_SPSR, "%s: Unexpected spsr index: %lld", config_name(c), idx);
+		TEST_ASSERT(idx < KVM_NR_SPSR, "%s: Unexpected spsr index: %lld", prefix, idx);
 		return strdup_printf("KVM_REG_ARM_CORE_REG(spsr[%lld])", idx);
 	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
 	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
 		idx = (core_off - KVM_REG_ARM_CORE_REG(fp_regs.vregs[0])) / CORE_FPREGS_XX_NR_WORDS;
-		TEST_ASSERT(idx < 32, "%s: Unexpected fp_regs.vregs index: %lld", config_name(c), idx);
+		TEST_ASSERT(idx < 32, "%s: Unexpected fp_regs.vregs index: %lld", prefix, idx);
 		return strdup_printf("KVM_REG_ARM_CORE_REG(fp_regs.vregs[%lld])", idx);
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
 		return "KVM_REG_ARM_CORE_REG(fp_regs.fpsr)";
@@ -167,11 +167,11 @@ static const char *core_id_to_str(struct vcpu_config *c, __u64 id)
 		return "KVM_REG_ARM_CORE_REG(fp_regs.fpcr)";
 	}
 
-	TEST_FAIL("%s: Unknown core reg id: 0x%llx", config_name(c), id);
+	TEST_FAIL("%s: Unknown core reg id: 0x%llx", prefix, id);
 	return NULL;
 }
 
-static const char *sve_id_to_str(struct vcpu_config *c, __u64 id)
+static const char *sve_id_to_str(const char *prefix, __u64 id)
 {
 	__u64 sve_off, n, i;
 
@@ -181,37 +181,37 @@ static const char *sve_id_to_str(struct vcpu_config *c, __u64 id)
 	sve_off = id & ~(REG_MASK | ((1ULL << 5) - 1));
 	i = id & (KVM_ARM64_SVE_MAX_SLICES - 1);
 
-	TEST_ASSERT(i == 0, "%s: Currently we don't expect slice > 0, reg id 0x%llx", config_name(c), id);
+	TEST_ASSERT(i == 0, "%s: Currently we don't expect slice > 0, reg id 0x%llx", prefix, id);
 
 	switch (sve_off) {
 	case KVM_REG_ARM64_SVE_ZREG_BASE ...
 	     KVM_REG_ARM64_SVE_ZREG_BASE + (1ULL << 5) * KVM_ARM64_SVE_NUM_ZREGS - 1:
 		n = (id >> 5) & (KVM_ARM64_SVE_NUM_ZREGS - 1);
 		TEST_ASSERT(id == KVM_REG_ARM64_SVE_ZREG(n, 0),
-			    "%s: Unexpected bits set in SVE ZREG id: 0x%llx", config_name(c), id);
+			    "%s: Unexpected bits set in SVE ZREG id: 0x%llx", prefix, id);
 		return strdup_printf("KVM_REG_ARM64_SVE_ZREG(%lld, 0)", n);
 	case KVM_REG_ARM64_SVE_PREG_BASE ...
 	     KVM_REG_ARM64_SVE_PREG_BASE + (1ULL << 5) * KVM_ARM64_SVE_NUM_PREGS - 1:
 		n = (id >> 5) & (KVM_ARM64_SVE_NUM_PREGS - 1);
 		TEST_ASSERT(id == KVM_REG_ARM64_SVE_PREG(n, 0),
-			    "%s: Unexpected bits set in SVE PREG id: 0x%llx", config_name(c), id);
+			    "%s: Unexpected bits set in SVE PREG id: 0x%llx", prefix, id);
 		return strdup_printf("KVM_REG_ARM64_SVE_PREG(%lld, 0)", n);
 	case KVM_REG_ARM64_SVE_FFR_BASE:
 		TEST_ASSERT(id == KVM_REG_ARM64_SVE_FFR(0),
-			    "%s: Unexpected bits set in SVE FFR id: 0x%llx", config_name(c), id);
+			    "%s: Unexpected bits set in SVE FFR id: 0x%llx", prefix, id);
 		return "KVM_REG_ARM64_SVE_FFR(0)";
 	}
 
 	return NULL;
 }
 
-static void print_reg(struct vcpu_config *c, __u64 id)
+static void print_reg(const char *prefix, __u64 id)
 {
 	unsigned op0, op1, crn, crm, op2;
 	const char *reg_size = NULL;
 
 	TEST_ASSERT((id & KVM_REG_ARCH_MASK) == KVM_REG_ARM64,
-		    "%s: KVM_REG_ARM64 missing in reg id: 0x%llx", config_name(c), id);
+		    "%s: KVM_REG_ARM64 missing in reg id: 0x%llx", prefix, id);
 
 	switch (id & KVM_REG_SIZE_MASK) {
 	case KVM_REG_SIZE_U8:
@@ -243,16 +243,16 @@ static void print_reg(struct vcpu_config *c, __u64 id)
 		break;
 	default:
 		TEST_FAIL("%s: Unexpected reg size: 0x%llx in reg id: 0x%llx",
-			  config_name(c), (id & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT, id);
+			  prefix, (id & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT, id);
 	}
 
 	switch (id & KVM_REG_ARM_COPROC_MASK) {
 	case KVM_REG_ARM_CORE:
-		printf("\tKVM_REG_ARM64 | %s | KVM_REG_ARM_CORE | %s,\n", reg_size, core_id_to_str(c, id));
+		printf("\tKVM_REG_ARM64 | %s | KVM_REG_ARM_CORE | %s,\n", reg_size, core_id_to_str(prefix, id));
 		break;
 	case KVM_REG_ARM_DEMUX:
 		TEST_ASSERT(!(id & ~(REG_MASK | KVM_REG_ARM_DEMUX_ID_MASK | KVM_REG_ARM_DEMUX_VAL_MASK)),
-			    "%s: Unexpected bits set in DEMUX reg id: 0x%llx", config_name(c), id);
+			    "%s: Unexpected bits set in DEMUX reg id: 0x%llx", prefix, id);
 		printf("\tKVM_REG_ARM64 | %s | KVM_REG_ARM_DEMUX | KVM_REG_ARM_DEMUX_ID_CCSIDR | %lld,\n",
 		       reg_size, id & KVM_REG_ARM_DEMUX_VAL_MASK);
 		break;
@@ -263,25 +263,25 @@ static void print_reg(struct vcpu_config *c, __u64 id)
 		crm = (id & KVM_REG_ARM64_SYSREG_CRM_MASK) >> KVM_REG_ARM64_SYSREG_CRM_SHIFT;
 		op2 = (id & KVM_REG_ARM64_SYSREG_OP2_MASK) >> KVM_REG_ARM64_SYSREG_OP2_SHIFT;
 		TEST_ASSERT(id == ARM64_SYS_REG(op0, op1, crn, crm, op2),
-			    "%s: Unexpected bits set in SYSREG reg id: 0x%llx", config_name(c), id);
+			    "%s: Unexpected bits set in SYSREG reg id: 0x%llx", prefix, id);
 		printf("\tARM64_SYS_REG(%d, %d, %d, %d, %d),\n", op0, op1, crn, crm, op2);
 		break;
 	case KVM_REG_ARM_FW:
 		TEST_ASSERT(id == KVM_REG_ARM_FW_REG(id & 0xffff),
-			    "%s: Unexpected bits set in FW reg id: 0x%llx", config_name(c), id);
+			    "%s: Unexpected bits set in FW reg id: 0x%llx", prefix, id);
 		printf("\tKVM_REG_ARM_FW_REG(%lld),\n", id & 0xffff);
 		break;
 	case KVM_REG_ARM_FW_FEAT_BMAP:
 		TEST_ASSERT(id == KVM_REG_ARM_FW_FEAT_BMAP_REG(id & 0xffff),
-			    "%s: Unexpected bits set in the bitmap feature FW reg id: 0x%llx", config_name(c), id);
+			    "%s: Unexpected bits set in the bitmap feature FW reg id: 0x%llx", prefix, id);
 		printf("\tKVM_REG_ARM_FW_FEAT_BMAP_REG(%lld),\n", id & 0xffff);
 		break;
 	case KVM_REG_ARM64_SVE:
-		printf("\t%s,\n", sve_id_to_str(c, id));
+		printf("\t%s,\n", sve_id_to_str(prefix, id));
 		break;
 	default:
 		TEST_FAIL("%s: Unexpected coproc type: 0x%llx in reg id: 0x%llx",
-			  config_name(c), (id & KVM_REG_ARM_COPROC_MASK) >> KVM_REG_ARM_COPROC_SHIFT, id);
+			  prefix, (id & KVM_REG_ARM_COPROC_MASK) >> KVM_REG_ARM_COPROC_SHIFT, id);
 	}
 }
 
@@ -410,7 +410,7 @@ static void run_test(struct vcpu_config *c)
 			__u64 id = reg_list->reg[i];
 			if ((print_list && !filter_reg(id)) ||
 			    (print_filtered && filter_reg(id)))
-				print_reg(c, id);
+				print_reg(config_name(c), id);
 		}
 		putchar('\n');
 		return;
@@ -438,7 +438,7 @@ static void run_test(struct vcpu_config *c)
 		ret = __vcpu_get_reg(vcpu, reg_list->reg[i], &addr);
 		if (ret) {
 			printf("%s: Failed to get ", config_name(c));
-			print_reg(c, reg.id);
+			print_reg(config_name(c), reg.id);
 			putchar('\n');
 			++failed_get;
 		}
@@ -450,7 +450,7 @@ static void run_test(struct vcpu_config *c)
 				ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
 				if (ret != -1 || errno != EPERM) {
 					printf("%s: Failed to reject (ret=%d, errno=%d) ", config_name(c), ret, errno);
-					print_reg(c, reg.id);
+					print_reg(config_name(c), reg.id);
 					putchar('\n');
 					++failed_reject;
 				}
@@ -462,7 +462,7 @@ static void run_test(struct vcpu_config *c)
 			ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
 			if (ret) {
 				printf("%s: Failed to set ", config_name(c));
-				print_reg(c, reg.id);
+				print_reg(config_name(c), reg.id);
 				putchar('\n');
 				++failed_set;
 			}
@@ -500,7 +500,7 @@ static void run_test(struct vcpu_config *c)
 		       "Consider adding them to the blessed reg "
 		       "list with the following lines:\n\n", config_name(c), new_regs);
 		for_each_new_reg(i)
-			print_reg(c, reg_list->reg[i]);
+			print_reg(config_name(c), reg_list->reg[i]);
 		putchar('\n');
 	}
 
@@ -508,7 +508,7 @@ static void run_test(struct vcpu_config *c)
 		printf("\n%s: There are %d missing registers.\n"
 		       "The following lines are missing registers:\n\n", config_name(c), missing_regs);
 		for_each_missing_reg(i)
-			print_reg(c, blessed_reg[i]);
+			print_reg(config_name(c), blessed_reg[i]);
 		putchar('\n');
 	}
 
-- 
2.34.1

