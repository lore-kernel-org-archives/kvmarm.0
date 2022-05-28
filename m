Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1163FC433EF
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 11:50:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8A2B4B2B5;
	Sat, 28 May 2022 07:50:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RbX-g8w7oUVt; Sat, 28 May 2022 07:49:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 382E34B357;
	Sat, 28 May 2022 07:49:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E354B108
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:49:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UtOkpHlJVeso for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 May 2022 07:49:56 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 834544B28F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:49:56 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 89001B816FE;
 Sat, 28 May 2022 11:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2515BC34100;
 Sat, 28 May 2022 11:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653738594;
 bh=C9c28cedZULwe3x4XI5ibuDlgiUGa4VC7XtN6wvnzwA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=VIC+dN8rg1nItQp2y4Mj7faOO7iw4JkaFZNWTRJb9S4B1Twp2lSF0xCgfwYPTEdrA
 pmtUwu/W3Nw/aXg0ZGz9vcrNa0ZGvb9G4J64BNa4ZJSPrM2rQii3TaLLBYHiMsDM41
 jjTT+aqkKNFPQdME4CGBVENhqb7RkEF4IuYUaP3tcHqJJhtgJy5vldy5QdRdHoxtJX
 zd0hWzF6CS2yMFDh2svFN+3+F/eiMSCgRT3Lod8jcAp0uowQiMrMbCAevFR8Tk8wRG
 WmQjjFN6zx8tIpuFWlmcOw5Ju7yusQtGtjzyy2Qwy0yq11VKOhZmAwyQuVyx8T7umJ
 Yyxksk+FZv5WA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nuumD-00EEGh-3t; Sat, 28 May 2022 12:38:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/18] KVM: arm64: Warn when PENDING_EXCEPTION and
 INCREMENT_PC are set together
Date: Sat, 28 May 2022 12:38:25 +0100
Message-Id: <20220528113829.1043361-16-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220528113829.1043361-1-maz@kernel.org>
References: <20220528113829.1043361-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>
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

We really don't want PENDING_EXCEPTION and INCREMENT_PC to ever be
set at the same time, as they are mutually exclusive. Add checks
that will generate a warning should this ever happen.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c   | 2 ++
 arch/arm64/kvm/inject_fault.c        | 8 ++++++++
 3 files changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 46e631cd8d9e..861fa0b24a7f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -473,6 +473,7 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 
 static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 {
+	WARN_ON(vcpu_get_flag(vcpu, PENDING_EXCEPTION));
 	vcpu_set_flag(vcpu, INCREMENT_PC);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 2841a2d447a1..04973984b6db 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -38,6 +38,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
 
+	WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
+
 	vcpu_set_flag(vcpu, PENDING_EXCEPTION);
 	vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a9a7b513f3b0..2f4b9afc16ec 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -20,6 +20,8 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
+	WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
+
 	vcpu_set_flag(vcpu, PENDING_EXCEPTION);
 	vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
 
@@ -51,6 +53,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 {
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
+	WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
+
 	vcpu_set_flag(vcpu, PENDING_EXCEPTION);
 	vcpu_set_flag(vcpu, EXCEPT_AA64_EL1_SYNC);
 
@@ -71,6 +75,8 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 
 static void inject_undef32(struct kvm_vcpu *vcpu)
 {
+	WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
+
 	vcpu_set_flag(vcpu, PENDING_EXCEPTION);
 	vcpu_set_flag(vcpu, EXCEPT_AA32_UND);
 }
@@ -94,6 +100,8 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
 
 	far = vcpu_read_sys_reg(vcpu, FAR_EL1);
 
+	WARN_ON(vcpu_get_flag(vcpu, INCREMENT_PC));
+
 	if (is_pabt) {
 		vcpu_set_flag(vcpu, PENDING_EXCEPTION);
 		vcpu_set_flag(vcpu, EXCEPT_AA32_IABT);
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
