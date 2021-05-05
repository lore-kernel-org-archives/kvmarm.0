Return-Path: <SRS0=ArdN=KA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28295C433B4
	for <kvmarm@archiver.kernel.org>; Wed,  5 May 2021 16:35:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 772046188B
	for <kvmarm@archiver.kernel.org>; Wed,  5 May 2021 16:35:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 772046188B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E850F4B420;
	Wed,  5 May 2021 12:35:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E-ozkMY6dh44; Wed,  5 May 2021 12:35:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 242A34B322;
	Wed,  5 May 2021 12:35:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E24A24B289
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 May 2021 12:35:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MWeupWYReiTx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 May 2021 12:35:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 921854B23A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 May 2021 12:35:06 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65CAD6190A;
 Wed,  5 May 2021 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620232505;
 bh=XUjM3uzOEodAd8GDaJ/3gful5wE9ZKQwbXWbEv/ZHZ0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=P44MEyT7BdQQKisV/A8INp4AyD4Ii/f18R52Cj6ewBywb4mndqsq2fBYvez951o5a
 VrttSeEq4nsrZFie/1yUYAyjDGqh/+kWAZdtGu0zmJd6mz0urrR6a+wdPcvFxIHR5X
 KTZyWzlERzXcrOVZyPHs1+6RzWvIaOtQcwGUpG0TQcNZW0unAKV58ES3UQyl6Qw6jz
 IxpVlFUyp8j94V5Td95yfS92fndATrkIKOinJdMoAwnQXrRBB0rHS99HYNKntHPGbH
 FSnY6NCHGyO/Kqz8MMcwXRNzfNSFhY34vV7Rm7sHoEvwZ+Ut/2p5kaiTzBN88KjWGi
 /8iFUDNT65Sww==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 036/104] KVM: arm64: Use BUG and BUG_ON in nVHE
 hyp
Date: Wed,  5 May 2021 12:33:05 -0400
Message-Id: <20210505163413.3461611-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Cc: Sasha Levin <sashal@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

From: Andrew Scull <ascull@google.com>

[ Upstream commit f79e616f27ab6cd74deb0995a8eead3d1c9d65af ]

hyp_panic() reports the address of the panic by using ELR_EL2, but this
isn't a useful address when hyp_panic() is called directly. Replace such
direct calls with BUG() and BUG_ON() which use BRK to trigger an
exception that then goes to hyp_panic() with the correct address. Also
remove the hyp_panic() declaration from the header file to avoid
accidental misuse.

Signed-off-by: Andrew Scull <ascull@google.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210318143311.839894-5-ascull@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c  | 6 ++----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 32ae676236b6..fe5fc814f228 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -100,7 +100,6 @@ u64 __guest_enter(struct kvm_vcpu *vcpu);
 
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 
-void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 			       u64 elr, u64 par);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 1b8ef37bf805..2630d3bbae62 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -181,6 +181,6 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_smc(host_ctxt);
 		break;
 	default:
-		hyp_panic();
+		BUG();
 	}
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index 2997aa156d8e..4495aed04240 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -18,8 +18,7 @@ u64 __ro_after_init hyp_cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID
 
 u64 cpu_logical_map(unsigned int cpu)
 {
-	if (cpu >= ARRAY_SIZE(hyp_cpu_logical_map))
-		hyp_panic();
+	BUG_ON(cpu >= ARRAY_SIZE(hyp_cpu_logical_map));
 
 	return hyp_cpu_logical_map[cpu];
 }
@@ -30,8 +29,7 @@ unsigned long __hyp_per_cpu_offset(unsigned int cpu)
 	unsigned long this_cpu_base;
 	unsigned long elf_base;
 
-	if (cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base))
-		hyp_panic();
+	BUG_ON(cpu >= ARRAY_SIZE(kvm_arm_hyp_percpu_base));
 
 	cpu_base_array = (unsigned long *)hyp_symbol_addr(kvm_arm_hyp_percpu_base);
 	this_cpu_base = kern_hyp_va(cpu_base_array[cpu]);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
