Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21308C00
	for <kvmarm@lists.linux.dev>; Tue, 25 Jul 2023 08:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690274266; x=1721810266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OoQ+1qYdGZMPeSSdT/rt4BEdsqDSU5GTDeIFLk0Jaf0=;
  b=UprcC/ADp1RuYAvQnDiLzINLqSDvx6sY5eyC84BufEtuiZvd7frZ5qEz
   jsx+NCuPFi1gG6TceI7eRmHZidVlU2nxiZpGbXvQ75Rua3ajYZo4Kt7hj
   gb9ZVbHYoYuiu8nbuE1CnGgeXkGSb7gKb4xRYvC96kWXsDDKJL4MlSKut
   W9fyIQrVQd/N0DnL1pVe5wIR9Tao8cXEEDiGQ2gMo7MHSHXmRvOJ2tgIn
   IYm3zn98Cd/T85BHy8u7TM/UPJLVewmIwX6nt70lTxMWT2vG12cPb0pc9
   i0dUWaJTv2tGc7B5ELIKbXk7ckdEIyelv2FC5WZb5SVeEL/s8kbH0YE/H
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="371264706"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="371264706"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 01:37:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="761130541"
X-IronPort-AV: E=Sophos;i="6.01,230,1684825200"; 
   d="scan'208";a="761130541"
Received: from haibo-optiplex-7090.sh.intel.com ([10.239.159.132])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 01:37:39 -0700
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
	Vitaly Kuznetsov <vkuznets@redhat.com>,
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
Subject: [PATCH v6 07/13] KVM: arm64: selftests: Finish generalizing get-reg-list
Date: Tue, 25 Jul 2023 16:41:33 +0800
Message-Id: <ded631b3cea55f5fe5a056cd882cd711b825b560.1690273969.git.haibo1.xu@intel.com>
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

From: Andrew Jones <ajones@ventanamicro.com>

Add some unfortunate #ifdeffery to ensure the common get-reg-list.c
can be compiled and run with other architectures. The next
architecture to support get-reg-list should now only need to provide
$(ARCH_DIR)/get-reg-list.c where arch-specific print_reg() and
vcpu_configs[] get defined.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
---
 tools/testing/selftests/kvm/get-reg-list.c | 26 +++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
index a29e548643d1..853cbf470da2 100644
--- a/tools/testing/selftests/kvm/get-reg-list.c
+++ b/tools/testing/selftests/kvm/get-reg-list.c
@@ -104,6 +104,7 @@ void __weak print_reg(const char *prefix, __u64 id)
 	printf("\t0x%llx,\n", id);
 }
 
+#ifdef __aarch64__
 static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu_init *init)
 {
 	struct vcpu_reg_sublist *s;
@@ -126,6 +127,25 @@ static void finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
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
+	finalize_vcpu(vcpu, c);
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
@@ -145,7 +165,6 @@ static bool print_filtered;
 
 static void run_test(struct vcpu_reg_list *c)
 {
-	struct kvm_vcpu_init init = { .target = -1, };
 	int new_regs = 0, missing_regs = 0, i, n;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
 	struct kvm_vcpu *vcpu;
@@ -155,10 +174,7 @@ static void run_test(struct vcpu_reg_list *c)
 	check_supported(c);
 
 	vm = vm_create_barebones();
-	prepare_vcpu_init(c, &init);
-	vcpu = __vm_vcpu_add(vm, 0);
-	aarch64_vcpu_setup(vcpu, &init);
-	finalize_vcpu(vcpu, c);
+	vcpu = vcpu_config_get_vcpu(c, vm);
 
 	reg_list = vcpu_get_reg_list(vcpu);
 
-- 
2.34.1

