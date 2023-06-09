Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB10C10F9
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 02:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686276470; x=1717812470;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UlIRkUVulcSCFIf9TRzhX1R3LH6Ql1M5u49CXYdVOfk=;
  b=EJPPD4dsk5SNk1pdX0sg/VPUESdTNtY1EsR861e2Ay9RAxCk0+nUlo5E
   CBcAgtG9yQ0o3QZrdCqTsZM8Tc3bMAuyO1n1M5o9sHa7/y5gdUxzZxci4
   CmuFU4/Q2eIZ1O4iH0UGeXitDaadSUc54Qz81obsR9mArZW567AoJuhzQ
   vAdppINPdSHhyTxeFjWfQMhY/aJ1s/b7ghBL+2KYs4dhZycQsMs6lSh+F
   okzzCCTv7ESpO5V4w/CIykO8jYnRM3P+sN+lAeKu/Ho1M/rP2eRkYoLCa
   3rs/fgidTEJosC46kIZ5EGO8OPHIbbQfy+4llCMN6nzaFIFrUwO+MbfUq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="359975623"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="359975623"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 19:07:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="713334823"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="713334823"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 19:07:43 -0700
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
Subject: [PATCH v3 07/10] KVM: arm64: selftests: Finish generalizing get-reg-list
Date: Fri,  9 Jun 2023 10:12:15 +0800
Message-Id: <450cb59db52ebeaa68f3d77f1bd995618f3612b8.1686275310.git.haibo1.xu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1686275310.git.haibo1.xu@intel.com>
References: <cover.1686275310.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

Add some unfortunate #ifdeffery to ensure the common get-reg-list.c
can be compiled and run with other architectures. The next
architecture to support get-reg-list should now only need to provide
$(ARCH_DIR)/get-reg-list.c where arch-specific print_reg() and
vcpu_configs[] get defined.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
---
 tools/testing/selftests/kvm/get-reg-list.c | 24 ++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
index 69bb91087081..c4bd5a5259da 100644
--- a/tools/testing/selftests/kvm/get-reg-list.c
+++ b/tools/testing/selftests/kvm/get-reg-list.c
@@ -98,6 +98,7 @@ void __weak print_reg(const char *prefix, __u64 id)
 	printf("\t0x%llx,\n", id);
 }
 
+#ifdef __aarch64__
 static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu_init *init)
 {
 	struct vcpu_reg_sublist *s;
@@ -120,6 +121,24 @@ static void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
 	}
 }
 
+static struct kvm_vcpu *vcpu_config_get_vcpu(struct vcpu_reg_list *c, struct kvm_vm *vm)
+{
+	struct kvm_vcpu_init init = { .target = -1, };
+	struct kvm_vcpu *vcpu;
+
+	prepare_vcpu_init(c, &init);
+	vcpu = __vm_vcpu_add(vm, 0);
+	aarch64_vcpu_setup(vcpu, &init);
+
+	return vcpu;
+}
+#else
+static struct kvm_vcpu *vcpu_config_get_vcpu(struct vcpu_reg_list *c, struct kvm_vm *vm)
+{
+	return __vm_vcpu_add(vm, 0);
+}
+#endif
+
 static void check_supported(struct vcpu_reg_list *c)
 {
 	struct vcpu_reg_sublist *s;
@@ -139,7 +158,6 @@ static bool print_filtered;
 
 static void run_test(struct vcpu_reg_list *c)
 {
-	struct kvm_vcpu_init init = { .target = -1, };
 	int new_regs = 0, missing_regs = 0, i, n;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
 	struct kvm_vcpu *vcpu;
@@ -149,9 +167,7 @@ static void run_test(struct vcpu_reg_list *c)
 	check_supported(c);
 
 	vm = vm_create_barebones();
-	prepare_vcpu_init(c, &init);
-	vcpu = __vm_vcpu_add(vm, 0);
-	aarch64_vcpu_setup(vcpu, &init);
+	vcpu = vcpu_config_get_vcpu(c, vm);
 	finalize_vcpu(vcpu, c);
 
 	reg_list = vcpu_get_reg_list(vcpu);
-- 
2.34.1

