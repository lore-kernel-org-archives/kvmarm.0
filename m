Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F142A17EA
	for <kvmarm@lists.linux.dev>; Fri, 23 Jun 2023 10:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687516656; x=1719052656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c7KoCv9Vo1qMt0K6xHBzZVraLcs3QK09dtvX+ljFZWQ=;
  b=DJFSTFZ3opWzekUXqocx1OcGfGj2BtRmRTKhjeFRd5QIkQT24qByy+Ky
   v/va+y6fchGACgKNkpYo93P7fUTzVOWZ5OlSayG1T4urQ/ZsjXm0tPzDE
   K2bBx0cuqar7QhixLRw2fWQDm3qRyoP0o+FSMVvKk0cJQKn5UUFbVuMzR
   /szs3CLAnjkFjqW6KUEOtyw+4U+zvRjxq1wcwldwUIp0WSS2JgdcnGdxb
   gsOXOd7BaisF+7YHzaOCEgDS/1GFbPr6xBgtExB8zDERH2E0n3L7fUsFf
   HFdEOYUmZtLhU4VzbxwQIg12HnC2Tp6RcJpC9U8r1+r3zsvhta8Yp+6mo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="447112991"
X-IronPort-AV: E=Sophos;i="6.01,151,1684825200"; 
   d="scan'208";a="447112991"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2023 03:37:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="715276262"
X-IronPort-AV: E=Sophos;i="6.01,151,1684825200"; 
   d="scan'208";a="715276262"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2023 03:37:06 -0700
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
	David Matlack <dmatlack@google.com>,
	Ben Gardon <bgardon@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
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
Subject: [PATCH v4 11/12] KVM: riscv: selftests: Add finalize_vcpu check in run_test
Date: Fri, 23 Jun 2023 18:40:13 +0800
Message-Id: <fa6b80b578553e561ccacaeb24091e0716975593.1687515463.git.haibo1.xu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1687515463.git.haibo1.xu@intel.com>
References: <cover.1687515463.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Disable all vcpu extensions which were enabled by default
if they were available in the risc-v host, and only enable
the desired one for a vcpu_config.

Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
---
 tools/testing/selftests/kvm/get-reg-list.c | 42 +++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
index 3beb6b62de0a..612dabc61137 100644
--- a/tools/testing/selftests/kvm/get-reg-list.c
+++ b/tools/testing/selftests/kvm/get-reg-list.c
@@ -138,11 +138,50 @@ static struct kvm_vcpu *vcpu_config_get_vcpu(struct vcpu_reg_list *c, struct kvm
 	prepare_vcpu_init(c, &init);
 	vcpu = __vm_vcpu_add(vm, 0);
 	aarch64_vcpu_setup(vcpu, &init);
-	finalize_vcpu(vcpu, c);
 
 	return vcpu;
 }
 #else
+static inline bool vcpu_has_ext(struct kvm_vcpu *vcpu, int ext)
+{
+	int ret;
+	unsigned long value;
+
+	ret = __vcpu_get_reg(vcpu, RISCV_ISA_EXT_REG(ext), &value);
+	if (ret) {
+		printf("Failed to get ext %d", ext);
+		return false;
+	}
+
+	return !!value;
+}
+
+static void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
+{
+	struct vcpu_reg_sublist *s;
+
+	/*
+	 * Disable all extensions which were enabled by default
+	 * if they were available in the risc-v host.
+	 */
+	for (int i = 0; i < KVM_RISCV_ISA_EXT_MAX; i++) {
+		__vcpu_set_reg(vcpu, RISCV_ISA_EXT_REG(i), 0);
+	}
+
+	for_each_sublist(c, s) {
+		if (!s->feature)
+			continue;
+
+		/* Try to enable the desired extension */
+		__vcpu_set_reg(vcpu, RISCV_ISA_EXT_REG(s->feature), 1);
+
+		/* Double check whether the desired extension was enabled */
+		__TEST_REQUIRE(vcpu_has_ext(vcpu, s->feature),
+			       "%s: %s not available, skipping tests\n",
+			       config_name(c), s->name);
+	}
+}
+
 static struct kvm_vcpu *vcpu_config_get_vcpu(struct vcpu_reg_list *c, struct kvm_vm *vm)
 {
 	return __vm_vcpu_add(vm, 0);
@@ -178,6 +217,7 @@ static void run_test(struct vcpu_reg_list *c)
 
 	vm = vm_create_barebones();
 	vcpu = vcpu_config_get_vcpu(c, vm);
+	finalize_vcpu(vcpu, c);
 
 	reg_list = vcpu_get_reg_list(vcpu);
 
-- 
2.34.1

