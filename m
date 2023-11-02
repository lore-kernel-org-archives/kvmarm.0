Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C80621357
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Be/sqxPi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698942842; x=1730478842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Nbhi+Lxa9AGjvct6KXRPu7ZYORV4sX+cH5+O4Ji6OnI=;
  b=Be/sqxPis0Tv8CuS6bS+hDUREvhyMJ1i/ErP0e4pnNIkYbTPVRl0Ifzi
   9DEUt1RccL1WlZCn6VjW2a6xx0qU7J1hCo6PhUR3gg5LpwQilX3fC5qPJ
   qBFDZwSFJya5iHQOxgS4y70lt1YU1u0jMEmfDph78Vh0O1SXf1xBENVFz
   qSpdLaZJmpMP6wCvaid1CASQluan/3hUBAYFqovy2bz9oWPNxsnEmgEc0
   lAqx2SWDp96i+je/O64YlIIuwfQ9xA9I8p5K9lPJssZrdZmoHRhYfPPhl
   yjKPYGaLqY8kJfeH0M1M+5qDsF4rqmV2LYAiS1r98+Ykl8ca2clGwIUBi
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10882"; a="388571123"
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="388571123"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,272,1694761200"; 
   d="scan'208";a="9448555"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.159.65])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 09:33:42 -0700
From: Zeng Guang <guang.zeng@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	Zeng Guang <guang.zeng@intel.com>
Subject: [RFC PATCH v1 8/8] KVM: selftests: x86: Add KVM forced emulation prefix capability
Date: Thu,  2 Nov 2023 23:51:11 +0800
Message-Id: <20231102155111.28821-9-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231102155111.28821-1-guang.zeng@intel.com>
References: <20231102155111.28821-1-guang.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Introduce KVM selftest exception fixup using forced emulation prefix to
emulate instruction unconditionally when kvm.force_emulation_prefix is
enabled.

Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 2534bdf8aa71..a1645508affc 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1110,6 +1110,10 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
+/* Forced emulation prefix for KVM emulating instruction unconditionally */
+#define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
+#define KVM_FEP_LENGTH 5
+
 /* If a toddler were to say "abracadabra". */
 #define KVM_EXCEPTION_MAGIC 0xabacadabaULL
 
@@ -1149,6 +1153,22 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	"mov  %%r9b, %[vector]\n\t"				\
 	"mov  %%r10, %[error_code]\n\t"
 
+/*
+ * KVM selftest exception fixup using forced emulation prefix enforces KVM
+ * on emulating instruction unconditionally when kvm.force_emulation_prefix
+ * is enabled.
+ */
+#define KVM_FEP_ASM_SAFE(insn)					\
+	"mov $" __stringify(KVM_EXCEPTION_MAGIC) ", %%r9\n\t"	\
+	"lea 1f(%%rip), %%r10\n\t"				\
+	"lea 2f(%%rip), %%r11\n\t"				\
+	KVM_FEP							\
+	"1: " insn "\n\t"					\
+	"xor %%r9, %%r9\n\t"					\
+	"2:\n\t"						\
+	"mov  %%r9b, %[vector]\n\t"				\
+	"mov  %%r10, %[error_code]\n\t"
+
 #define KVM_ASM_SAFE_OUTPUTS(v, ec)	[vector] "=qm"(v), [error_code] "=rm"(ec)
 #define KVM_ASM_SAFE_CLOBBERS	"r9", "r10", "r11"
 
-- 
2.21.3

