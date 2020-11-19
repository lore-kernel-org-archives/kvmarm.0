Return-Path: <SRS0=Ckwh=EZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0EEC56201
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:26:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C6D4D246AA
	for <kvmarm@archiver.kernel.org>; Thu, 19 Nov 2020 16:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="KQDbQtOp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6D4D246AA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 531A84B528;
	Thu, 19 Nov 2020 11:26:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IHRJS1+dNIAl; Thu, 19 Nov 2020 11:26:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 233C34B520;
	Thu, 19 Nov 2020 11:26:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26EC54B488
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:26:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nPOM8FGwqOIf for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2020 11:26:03 -0500 (EST)
Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com
 [209.85.208.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D9B964B3DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 11:26:02 -0500 (EST)
Received: by mail-ed1-f68.google.com with SMTP id cf17so2896906edb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2020 08:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=Du1A1iohvYOXikNEv0tYZPkKvUMheyRm10QbPuVgnlA=;
 b=KQDbQtOpKGlA/mJE+IKXYs3nd9nRJy91CRVZ6hpu8lHeREkppXMaTHfErgzVmjd00n
 dxVTRWsn03RgwIp78LSBRmbwGjQ0Ysta0qEqtCYxX/Aw42cycA7Z3Si83t/T84oP7OjE
 XP2QIW0IKzQuuONquwHYq1b0lhWu0F8Ay88R5bcwanmVfL8zloykzAmLPzj3sF9L3pEz
 ye/en7DDEy9JnRLeJJSxVudY00hpdsmd9QPnBwGIvMPDqvaIhTalqmtNxOviEicwP+0m
 zd38ISBAid8iqz+ug7DqkjTEAbtMSaK/O/5zumXsM/LELNGvleSwfa5n36uwsTaZJlTv
 GajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=Du1A1iohvYOXikNEv0tYZPkKvUMheyRm10QbPuVgnlA=;
 b=SuXNpRKi5f547gdecNckr05ksmhiyI7XHMqX24oduRRhQwowNUlP2GJYVdCGahAU7C
 Z2IMMh2E9NEKsgJNkIJIkadkHqTsIa0QqVRNVlmOTaN/2+CwEU76Svzdc7lZEMLS82ZD
 FxMDnq+HO0cS0ZPbOXVkV95gxNJ6LpnaDpxR++K4HNIK8xUSbqgBo6tCVpVd6OavuZGP
 sznsPeRck3g9PFAVWdZHT4L3oXq8EOjUeeLQVlIMgwKRR8C1r4jJvgWefbMOQEJRtzd0
 RO85JtNsYsYRsGiR0FUBNxXkGxYZGRd/UADP0q3mjO67wi0UO55d05VDHDtkd5OHK6KD
 WlGA==
X-Gm-Message-State: AOAM531uOwYqO6lTEN6i8hOy9CpQFbbXiEN38yA1X9cDqyWLz6kpPVah
 Qhq8H9LL6xmCfspeUUwC9uPu1BWzlpNmvg==
X-Google-Smtp-Source: ABdhPJz+hVLzImDN1eqY0j2SdIgTYsByI/xefUNdZgBEv9BhBBzOHOWikqW/5dwv0rlHb5NhMij5fA==
X-Received: by 2002:a50:cd09:: with SMTP id z9mr32082700edi.152.1605803161427; 
 Thu, 19 Nov 2020 08:26:01 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:9843:cd3f:f36b:d55c])
 by smtp.gmail.com with ESMTPSA id rn2sm58104ejb.94.2020.11.19.08.26.00
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 19 Nov 2020 08:26:00 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH 6/6] kvm: arm64: Remove hyp_symbol_addr
Date: Thu, 19 Nov 2020 16:25:43 +0000
Message-Id: <20201119162543.78001-7-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201119162543.78001-1-dbrazdil@google.com>
References: <20201119162543.78001-1-dbrazdil@google.com>
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>
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

The helper was used to force PC-relative addressing in hyp code because
absolute addressing via constant-pools used to generate kernel VAs. This
was cumbersome and required programmers to remember to use the helper
whenever they wanted to take a pointer.

Now that hyp relocations are fixed up, there is no need for the helper
any logner. Remove it.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_asm.h         | 20 --------------------
 arch/arm64/kvm/hyp/include/hyp/switch.h  |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c        |  4 ++--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c     |  4 ++--
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  2 +-
 5 files changed, 7 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 1a86581e581e..1961d23c0c40 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -203,26 +203,6 @@ extern void __vgic_v3_init_lrs(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
-/*
- * Obtain the PC-relative address of a kernel symbol
- * s: symbol
- *
- * The goal of this macro is to return a symbol's address based on a
- * PC-relative computation, as opposed to a loading the VA from a
- * constant pool or something similar. This works well for HYP, as an
- * absolute VA is guaranteed to be wrong. Only use this if trying to
- * obtain the address of a symbol (i.e. not something you obtained by
- * following a pointer).
- */
-#define hyp_symbol_addr(s)						\
-	({								\
-		typeof(s) *addr;					\
-		asm("adrp	%0, %1\n"				\
-		    "add	%0, %0, :lo12:%1\n"			\
-		    : "=r" (addr) : "S" (&s));				\
-		addr;							\
-	})
-
 #define __KVM_EXTABLE(from, to)						\
 	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
 	"	.align		3\n"					\
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 84473574c2e7..54f4860cd87c 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -505,8 +505,8 @@ static inline void __kvm_unexpected_el2_exception(void)
 	struct exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
 
-	entry = hyp_symbol_addr(__start___kvm_ex_table);
-	end = hyp_symbol_addr(__stop___kvm_ex_table);
+	entry = &__start___kvm_ex_table;
+	end = &__stop___kvm_ex_table;
 
 	while (entry < end) {
 		addr = (unsigned long)&entry->insn + entry->insn;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index ceb427aabb91..6870d9f3d4b7 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -33,8 +33,8 @@ unsigned long __hyp_per_cpu_offset(unsigned int cpu)
 	if (cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base))
 		hyp_panic();
 
-	cpu_base_array = (unsigned long*)hyp_symbol_addr(kvm_arm_hyp_percpu_base);
+	cpu_base_array = (unsigned long*)(&kvm_arm_hyp_percpu_base[0]);
 	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
-	elf_base = (unsigned long)hyp_symbol_addr(__per_cpu_start);
+	elf_base = (unsigned long)&__per_cpu_start;
 	return this_cpu_base - elf_base;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/psci-relay.c b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
index 313ef42f0eab..f64380a49a72 100644
--- a/arch/arm64/kvm/hyp/nvhe/psci-relay.c
+++ b/arch/arm64/kvm/hyp/nvhe/psci-relay.c
@@ -147,7 +147,7 @@ static int psci_cpu_suspend(u64 func_id, struct kvm_cpu_context *host_ctxt)
 	 * point if it is a deep sleep state.
 	 */
 	ret = psci_call(func_id, power_state,
-			__hyp_pa(hyp_symbol_addr(__kvm_hyp_cpu_entry)),
+			__hyp_pa(__kvm_hyp_cpu_entry),
 			__hyp_pa(cpu_params));
 
 	release_reset_state(cpu_state);
@@ -182,7 +182,7 @@ static int psci_cpu_on(u64 func_id, struct kvm_cpu_context *host_ctxt)
 		return PSCI_RET_ALREADY_ON;
 
 	ret = psci_call(func_id, mpidr,
-			__hyp_pa(hyp_symbol_addr(__kvm_hyp_cpu_entry)),
+			__hyp_pa(__kvm_hyp_cpu_entry),
 			__hyp_pa(cpu_params));
 
 	/*
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 8f0585640241..87a54375bd6e 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -64,7 +64,7 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	}
 
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
-	addr  = hyp_symbol_addr(kvm_vgic_global_state)->vcpu_hyp_va;
+	addr  = kvm_vgic_global_state.vcpu_hyp_va;
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
