Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66AF8C00
	for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 08:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690274326; x=1721810326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zqDvxDhtOrH/ZxpWvBX+hbQeY8ju0wv1s0jCmUcL6Vs=;
  b=RkTAIa4EyHqQ+uK1SfMYrUPHEkm2ccXIAAouBOxFbNYBkNSOEBKVhw+2
   t7KmQ2FQ/k1FRijMVF3HjqIKhHkwVlR97ZQ2FdFPom3QARzw0Ag93/vbS
   on8pQRgpWxVg+Kewbnb4TZQxCdPdd/KggeNAsP7gfTDP7Spb7OmMCbHfg
   Y7LTrYDsQNK+60W3F18h6bvDUOxPay6EgIHrxpLulsbbTwtS+ZlcbuspF
   GofGkumXPzR+LqP5T0S60dN6hKixc9+a4g7rybJL+8bwE9mMTGHzsZEtG
   By158dWbgYkW+kSYKOyJgJwrRJhsl8Xl8mcQFNghgiyjCGqywmv3qJuTB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="371265085"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="371265085"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 01:38:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="761131217"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="761131217"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 01:38:39 -0700
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
Subject: [PATCH v6 11/13] KVM: selftests: Add skip_set facility to get_reg_list test
Date: Tue, 25 Jul 2023 16:41:37 +0800
Message-Id: <04cecbc3169d93d7501885a205851f4e8b0a935b.1690273969.git.haibo1.xu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1690273969.git.haibo1.xu@intel.com>
References: <cover.1690273969.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add new skips_set members to vcpu_reg_sublist so as to skip
set operation on some registers.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 tools/testing/selftests/kvm/get-reg-list.c    | 20 +++++++++++++------
 .../selftests/kvm/include/kvm_util_base.h     |  2 ++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
index 2232620fb797..be7bf5224434 100644
--- a/tools/testing/selftests/kvm/get-reg-list.c
+++ b/tools/testing/selftests/kvm/get-reg-list.c
@@ -163,6 +163,7 @@ static void run_test(struct vcpu_reg_list *c)
 {
 	int new_regs = 0, missing_regs = 0, i, n;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
+	int skipped_set = 0;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct vcpu_reg_sublist *s;
@@ -216,7 +217,7 @@ static void run_test(struct vcpu_reg_list *c)
 			.id = reg_list->reg[i],
 			.addr = (__u64)&addr,
 		};
-		bool reject_reg = false;
+		bool reject_reg = false, skip_reg = false;
 		int ret;
 
 		ret = __vcpu_get_reg(vcpu, reg_list->reg[i], &addr);
@@ -227,8 +228,8 @@ static void run_test(struct vcpu_reg_list *c)
 			++failed_get;
 		}
 
-		/* rejects_set registers are rejected after KVM_ARM_VCPU_FINALIZE */
 		for_each_sublist(c, s) {
+			/* rejects_set registers are rejected for set operation */
 			if (s->rejects_set && find_reg(s->rejects_set, s->rejects_set_n, reg.id)) {
 				reject_reg = true;
 				ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
@@ -240,9 +241,16 @@ static void run_test(struct vcpu_reg_list *c)
 				}
 				break;
 			}
+
+			/* skips_set registers are skipped for set operation */
+			if (s->skips_set && find_reg(s->skips_set, s->skips_set_n, reg.id)) {
+				skip_reg = true;
+				++skipped_set;
+				break;
+			}
 		}
 
-		if (!reject_reg) {
+		if (!reject_reg && !skip_reg) {
 			ret = __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
 			if (ret) {
 				printf("%s: Failed to set ", config_name(c));
@@ -287,9 +295,9 @@ static void run_test(struct vcpu_reg_list *c)
 	}
 
 	TEST_ASSERT(!missing_regs && !failed_get && !failed_set && !failed_reject,
-		    "%s: There are %d missing registers; "
-		    "%d registers failed get; %d registers failed set; %d registers failed reject",
-		    config_name(c), missing_regs, failed_get, failed_set, failed_reject);
+		    "%s: There are %d missing registers; %d registers failed get; "
+		    "%d registers failed set; %d registers failed reject; %d registers skipped set",
+		    config_name(c), missing_regs, failed_get, failed_set, failed_reject, skipped_set);
 
 	pr_info("%s: PASS\n", config_name(c));
 	blessed_n = 0;
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index ec65c292b5fd..a2623aaf3a55 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -134,6 +134,8 @@ struct vcpu_reg_sublist {
 	__u64 regs_n;
 	__u64 *rejects_set;
 	__u64 rejects_set_n;
+	__u64 *skips_set;
+	__u64 skips_set_n;
 };
 
 struct vcpu_reg_list {
-- 
2.34.1

