Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B450C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jun 2022 13:58:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07BE04B490;
	Thu, 30 Jun 2022 09:58:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EfbrHud+QYGk; Thu, 30 Jun 2022 09:58:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAD664B0C2;
	Thu, 30 Jun 2022 09:58:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB863403AD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uoLK0s8GBP0P for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 09:58:55 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF2564B493
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:55 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 4469261F5F;
 Thu, 30 Jun 2022 13:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043D3C341CB;
 Thu, 30 Jun 2022 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656597534;
 bh=2z+VzqIdlmDgIeL4Gyw6Deiw7cE868Mkg1FnosIPnHc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=rLqIa2JdFBtYk9APFZdiBZ7/eWILkmVwkgPMtwiNknkg+Ojj/xuHVpLfil7crGHkp
 GbUo1NRNC0lrCOPweNQK/0kRqMPgyA3iwj4ByPepvotoizkNQqWi0nXE/5/6ab4qzH
 7Zq7w2RZEuGj1JXJV4VFeFoCysI+L9ABjS8qL4sotsi40JGiOfDIFXAVxcUgjIFsZn
 TRpWy/kBaUjkPxO0O2XbXSpA81bLDkSNEdXS1v190pfJmVjbP/NPoNc5vRTl6dVJYY
 tROMdMgEk0g50ZMJYrKdomAgSlupmAid9atnl5na9OU5gDYpledQxjskG/Tplet71u
 O6ymQpXjN+NYw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 15/24] KVM: arm64: Initialise hyp symbols regardless of pKVM
Date: Thu, 30 Jun 2022 14:57:38 +0100
Message-Id: <20220630135747.26983-16-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The nVHE object at EL2 maintains its own copies of some host variables
so that, when pKVM is enabled, the host cannot directly modify the
hypervisor state. When running in normal nVHE mode, however, these
variables are still mirrored at EL2 but are not initialised.

Initialise the hypervisor symbols from the host copies regardless of
pKVM, ensuring that any reference to this data at EL2 with normal nVHE
will return an sensibly initialised value.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arm.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 66e1d37858f1..a2343640c73c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1891,11 +1891,8 @@ static int do_pkvm_init(u32 hyp_va_bits)
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
@@ -1904,6 +1901,12 @@ static int kvm_hyp_init_protection(u32 hyp_va_bits)
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
@@ -2078,6 +2081,8 @@ static int init_hyp_mode(void)
 		cpu_prepare_hyp_mode(cpu);
 	}
 
+	kvm_hyp_init_symbols();
+
 	if (is_protected_kvm_enabled()) {
 		init_cpu_logical_map();
 
@@ -2085,9 +2090,7 @@ static int init_hyp_mode(void)
 			err = -ENODEV;
 			goto out_err;
 		}
-	}
 
-	if (is_protected_kvm_enabled()) {
 		err = kvm_hyp_init_protection(hyp_va_bits);
 		if (err) {
 			kvm_err("Failed to init hyp memory protection\n");
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
