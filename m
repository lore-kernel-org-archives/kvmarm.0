Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7507017CB
	for <kvmarm@lists.linux.dev>; Sat,  1 Jul 2023 13:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688218768; x=1719754768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I+7CmZbE8smFi2s/kidYxguksFY8+4Lb0ZPsMAWD3Cc=;
  b=G4KSBKS9PfmTlFQjUQQkp7aVMpEbwrB84eIst5Yxdc4z468p6gPregE+
   u8ChAcQnVWWQBhSdCPA5e1QVweumUk431wcl2kF8SiymAwTFRrCBDdeEm
   ++SRwzC0ahdSQVObatk2Vjq//iiIlF0U2SPKIJxUbwpS/Qp/Xt0x1Wf51
   gjdlT2hArAZbmr/IUbW3qUZub6to3/hdSfRF2XgxUiunJfk6+cal3zR/O
   dEwWhByCjWmAZNa0AOGhdyxaKUK+Slz9Ej+frEmw9KWD62Y2SvZRerLpl
   zluVtOlprJYP5Gxi0LDIRSrV9afdd7ZD4sNUL38p7jY4+ziek7OiuC4Ep
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10758"; a="342926282"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="342926282"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2023 06:39:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10758"; a="747694214"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="747694214"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2023 06:39:20 -0700
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
	Ricardo Koller <ricarkol@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	David Matlack <dmatlack@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v5 10/13] KVM: selftests: Only do get/set tests on present blessed list
Date: Sat,  1 Jul 2023 21:42:58 +0800
Message-Id: <f44c3aa46971d524319c6340f9ce1b00c0182fd2.1688010022.git.haibo1.xu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1688010022.git.haibo1.xu@intel.com>
References: <cover.1688010022.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only do the get/set tests on present and blessed registers
since we don't know the capabilities of any new ones.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/get-reg-list.c | 29 ++++++++++++++--------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
index c61090806007..74fb6f6fdd09 100644
--- a/tools/testing/selftests/kvm/get-reg-list.c
+++ b/tools/testing/selftests/kvm/get-reg-list.c
@@ -49,6 +49,10 @@ extern int vcpu_configs_n;
 	for_each_reg_filtered(i)						\
 		if (!find_reg(blessed_reg, blessed_n, reg_list->reg[i]))
 
+#define for_each_present_blessed_reg(i)			\
+	for ((i) = 0; (i) < blessed_n; ++(i))		\
+		if (find_reg(reg_list->reg, reg_list->n, blessed_reg[i]))
+
 static const char *config_name(struct vcpu_reg_list *c)
 {
 	struct vcpu_reg_sublist *s;
@@ -177,6 +181,16 @@ static void run_test(struct vcpu_reg_list *c)
 		return;
 	}
 
+	for_each_sublist(c, s)
+		blessed_n += s->regs_n;
+	blessed_reg = calloc(blessed_n, sizeof(__u64));
+
+	n = 0;
+	for_each_sublist(c, s) {
+		for (i = 0; i < s->regs_n; ++i)
+			blessed_reg[n++] = s->regs[i];
+	}
+
 	/*
 	 * We only test that we can get the register and then write back the
 	 * same value. Some registers may allow other values to be written
@@ -186,8 +200,11 @@ static void run_test(struct vcpu_reg_list *c)
 	 * be written need to have the other values tested, then we should
 	 * create a new set of tests for those in a new independent test
 	 * executable.
+	 *
+	 * Only do the get/set tests on present, blessed list registers,
+	 * since we don't know the capabilities of any new registers.
 	 */
-	for_each_reg(i) {
+	for_each_present_blessed_reg(i) {
 		uint8_t addr[2048 / 8];
 		struct kvm_one_reg reg = {
 			.id = reg_list->reg[i],
@@ -230,16 +247,6 @@ static void run_test(struct vcpu_reg_list *c)
 		}
 	}
 
-	for_each_sublist(c, s)
-		blessed_n += s->regs_n;
-	blessed_reg = calloc(blessed_n, sizeof(__u64));
-
-	n = 0;
-	for_each_sublist(c, s) {
-		for (i = 0; i < s->regs_n; ++i)
-			blessed_reg[n++] = s->regs[i];
-	}
-
 	for_each_new_reg(i)
 		++new_regs;
 
-- 
2.34.1

