Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD9D1A629
	for <kvmarm@lists.linux.dev>; Thu, 10 Nov 2022 19:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9E6C433D7;
	Thu, 10 Nov 2022 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668107044;
	bh=i95H10uekay+RA6wzlU9ZChG/pQGqzHO4SoBQ86elTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c85xoJIRgbO0/NFiP3LATskVa0QLFzir933dS2B8UrvDJsBtOJU30oVaq3YYCiCjY
	 b32+rRGaIyaTHmMsx+P1eAWYTjncUpLBk3Ut4m6ZCeBOwO67Sq/bJCCKXwaIFTkqcY
	 MgwX2gfuDtH9FmpkOUHWKhp96SgQbWrjC0VqvOvfYAIzV213ynuQZ9cd3cUFeDEVEN
	 54u80dPqovNnBRXcP1MsyZQ8XCawOPPx5sLU3tEdsKnzJ7Pa040fktK1Mxw5SG2JBV
	 BcVkwJLfVk8o/YZ2fWSClzbunQt31hgVImeiV8/0UXwxd+FK6tSuuRoU7B7NwG2+m8
	 va5VFvpkCjcuw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Quentin Perret <qperret@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kernel-team@android.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 15/26] KVM: arm64: Initialise hypervisor copies of host symbols unconditionally
Date: Thu, 10 Nov 2022 19:02:48 +0000
Message-Id: <20221110190259.26861-16-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221110190259.26861-1-will@kernel.org>
References: <20221110190259.26861-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The nVHE object at EL2 maintains its own copies of some host variables
so that, when pKVM is enabled, the host cannot directly modify the
hypervisor state. When running in normal nVHE mode, however, these
variables are still mirrored at EL2 but are not initialised.

Initialise the hypervisor symbols from the host copies regardless of
pKVM, ensuring that any reference to this data at EL2 with normal nVHE
will return a sensibly initialised value.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 30d6fc5d3a93..584626e11797 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1884,11 +1884,8 @@ static int do_pkvm_init(u32 hyp_va_bits)
 	return ret;
 }
 
-static int kvm_hyp_init_protection(u32 hyp_va_bits)
+static void kvm_hyp_init_symbols(void)
 {
-	void *addr = phys_to_virt(hyp_mem_base);
-	int ret;
-
 	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR0_EL1);
@@ -1897,6 +1894,12 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
 	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
+}
+
+static int kvm_hyp_init_protection(u32 hyp_va_bits)
+{
+	void *addr = phys_to_virt(hyp_mem_base);
+	int ret;
 
 	ret = create_hyp_mappings(addr, addr + hyp_mem_size, PAGE_HYP);
 	if (ret)
@@ -2071,6 +2074,8 @@ static int init_hyp_mode(void)
 		cpu_prepare_hyp_mode(cpu);
 	}
 
+	kvm_hyp_init_symbols();
+
 	if (is_protected_kvm_enabled()) {
 		init_cpu_logical_map();
 
@@ -2078,9 +2083,7 @@ static int init_hyp_mode(void)
 			err = -ENODEV;
 			goto out_err;
 		}
-	}
 
-	if (is_protected_kvm_enabled()) {
 		err = kvm_hyp_init_protection(hyp_va_bits);
 		if (err) {
 			kvm_err("Failed to init hyp memory protection\n");
-- 
2.38.1.431.g37b22c650d-goog

