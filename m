Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109ECBE51
	for <kvmarm@lists.linux.dev>; Thu, 25 May 2023 07:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685000126; x=1716536126;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6crEFzd6d9em+CESWBV/oDElK6EEeteEO4prc8+WAsQ=;
  b=m7T0Cf+3cpXDv/rkYMHosZvQJts4M38hWXdXpgSX8qip4nGwzS+bDl5r
   IJE3yGvACYIM79oVU3WAqUKaU/v9fD08VIfmb5OQchPCQ9MUSmO9ajzVo
   fZU6a6izxxPByxNBhFgGYW/MNykebw8iOv3ACtLS883ahS74cb7sZllk1
   5FAui99/NuUa08dQet525/kE7veE/4nsu/m1vXu6ytmXpsEcao5/yWZKJ
   eal2eR6xPevS1uiIHQRuBcpk5iuwh3I94yPmEOJfbX7dzeVH00Dngn4Jz
   Igilt+qFygNtSuJ0PAjQaUAoqXwUC1P6U7IdEEZONqkDxU64l68jy3ndU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="417281100"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="417281100"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 00:33:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="769775507"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="769775507"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 00:33:27 -0700
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
Subject: [PATCH v2 04/11] KVM: arm64: selftests: Rename vcpu_config and add to kvm_util.h
Date: Thu, 25 May 2023 15:38:28 +0800
Message-Id: <742c9db19c716cb1a26a5d5018803c7daac9b2ed.1684999824.git.haibo1.xu@intel.com>
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

Rename vcpu_config to vcpu_reg_list to be more specific and add
it to kvm_util.h. While it may not get used outside get-reg-list
tests, exporting it doesn't hurt, as long as it has a unique enough
name. This is a step in the direction of sharing most of the get-
reg-list test code between architectures.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 60 +++++++------------
 .../selftests/kvm/include/kvm_util_base.h     | 16 +++++
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 424285d39965..aae2056379f7 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -37,23 +37,7 @@
 static struct kvm_reg_list *reg_list;
 static __u64 *blessed_reg, blessed_n;
 
-struct reg_sublist {
-	const char *name;
-	long capability;
-	int feature;
-	bool finalize;
-	__u64 *regs;
-	__u64 regs_n;
-	__u64 *rejects_set;
-	__u64 rejects_set_n;
-};
-
-struct vcpu_config {
-	char *name;
-	struct reg_sublist sublists[];
-};
-
-static struct vcpu_config *vcpu_configs[];
+static struct vcpu_reg_list *vcpu_configs[];
 static int vcpu_configs_n;
 
 #define for_each_sublist(c, s)							\
@@ -74,9 +58,9 @@ static int vcpu_configs_n;
 	for_each_reg_filtered(i)						\
 		if (!find_reg(blessed_reg, blessed_n, reg_list->reg[i]))
 
-static const char *config_name(struct vcpu_config *c)
+static const char *config_name(struct vcpu_reg_list *c)
 {
-	struct reg_sublist *s;
+	struct vcpu_reg_sublist *s;
 	int len = 0;
 
 	if (c->name)
@@ -342,18 +326,18 @@ static void core_reg_fixup(void)
 	reg_list = tmp;
 }
 
-static void prepare_vcpu_init(struct vcpu_config *c, struct kvm_vcpu_init *init)
+static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu_init *init)
 {
-	struct reg_sublist *s;
+	struct vcpu_reg_sublist *s;
 
 	for_each_sublist(c, s)
 		if (s->capability)
 			init->features[s->feature / 32] |= 1 << (s->feature % 32);
 }
 
-static void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_config *c)
+static void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
 {
-	struct reg_sublist *s;
+	struct vcpu_reg_sublist *s;
 	int feature;
 
 	for_each_sublist(c, s) {
@@ -364,9 +348,9 @@ static void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_config *c)
 	}
 }
 
-static void check_supported(struct vcpu_config *c)
+static void check_supported(struct vcpu_reg_list *c)
 {
-	struct reg_sublist *s;
+	struct vcpu_reg_sublist *s;
 
 	for_each_sublist(c, s) {
 		if (!s->capability)
@@ -382,14 +366,14 @@ static bool print_list;
 static bool print_filtered;
 static bool fixup_core_regs;
 
-static void run_test(struct vcpu_config *c)
+static void run_test(struct vcpu_reg_list *c)
 {
 	struct kvm_vcpu_init init = { .target = -1, };
 	int new_regs = 0, missing_regs = 0, i, n;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	struct reg_sublist *s;
+	struct vcpu_reg_sublist *s;
 
 	check_supported(c);
 
@@ -526,7 +510,7 @@ static void run_test(struct vcpu_config *c)
 
 static void help(void)
 {
-	struct vcpu_config *c;
+	struct vcpu_reg_list *c;
 	int i;
 
 	printf(
@@ -550,9 +534,9 @@ static void help(void)
 	);
 }
 
-static struct vcpu_config *parse_config(const char *config)
+static struct vcpu_reg_list *parse_config(const char *config)
 {
-	struct vcpu_config *c;
+	struct vcpu_reg_list *c;
 	int i;
 
 	if (config[8] != '=')
@@ -572,7 +556,7 @@ static struct vcpu_config *parse_config(const char *config)
 
 int main(int ac, char **av)
 {
-	struct vcpu_config *c, *sel = NULL;
+	struct vcpu_reg_list *c, *sel = NULL;
 	int i, ret = 0;
 	pid_t pid;
 
@@ -1053,14 +1037,14 @@ static __u64 pauth_generic_regs[] = {
 		.regs_n		= ARRAY_SIZE(pauth_generic_regs),	\
 	}
 
-static struct vcpu_config vregs_config = {
+static struct vcpu_reg_list vregs_config = {
 	.sublists = {
 	BASE_SUBLIST,
 	VREGS_SUBLIST,
 	{0},
 	},
 };
-static struct vcpu_config vregs_pmu_config = {
+static struct vcpu_reg_list vregs_pmu_config = {
 	.sublists = {
 	BASE_SUBLIST,
 	VREGS_SUBLIST,
@@ -1068,14 +1052,14 @@ static struct vcpu_config vregs_pmu_config = {
 	{0},
 	},
 };
-static struct vcpu_config sve_config = {
+static struct vcpu_reg_list sve_config = {
 	.sublists = {
 	BASE_SUBLIST,
 	SVE_SUBLIST,
 	{0},
 	},
 };
-static struct vcpu_config sve_pmu_config = {
+static struct vcpu_reg_list sve_pmu_config = {
 	.sublists = {
 	BASE_SUBLIST,
 	SVE_SUBLIST,
@@ -1083,7 +1067,7 @@ static struct vcpu_config sve_pmu_config = {
 	{0},
 	},
 };
-static struct vcpu_config pauth_config = {
+static struct vcpu_reg_list pauth_config = {
 	.sublists = {
 	BASE_SUBLIST,
 	VREGS_SUBLIST,
@@ -1091,7 +1075,7 @@ static struct vcpu_config pauth_config = {
 	{0},
 	},
 };
-static struct vcpu_config pauth_pmu_config = {
+static struct vcpu_reg_list pauth_pmu_config = {
 	.sublists = {
 	BASE_SUBLIST,
 	VREGS_SUBLIST,
@@ -1101,7 +1085,7 @@ static struct vcpu_config pauth_pmu_config = {
 	},
 };
 
-static struct vcpu_config *vcpu_configs[] = {
+static struct vcpu_reg_list *vcpu_configs[] = {
 	&vregs_config,
 	&vregs_pmu_config,
 	&sve_config,
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index a089c356f354..ac4aaa21deee 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/kvm.h>
 #include "linux/rbtree.h"
+#include <linux/types.h>
 
 #include <asm/atomic.h>
 
@@ -124,6 +125,21 @@ struct kvm_vm {
 	uint32_t memslots[NR_MEM_REGIONS];
 };
 
+struct vcpu_reg_sublist {
+	const char *name;
+	long capability;
+	int feature;
+	bool finalize;
+	__u64 *regs;
+	__u64 regs_n;
+	__u64 *rejects_set;
+	__u64 rejects_set_n;
+};
+
+struct vcpu_reg_list {
+	char *name;
+	struct vcpu_reg_sublist sublists[];
+};
 
 #define kvm_for_each_vcpu(vm, i, vcpu)			\
 	for ((i) = 0; (i) <= (vm)->last_vcpu_id; (i)++)	\
-- 
2.34.1

