Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2BDC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:08:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 694ED4B1D5;
	Mon, 29 Nov 2021 15:08:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ox960KzFdzEZ; Mon, 29 Nov 2021 15:08:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FF2F4B25E;
	Mon, 29 Nov 2021 15:08:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48EDD4B264
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D-EZOxZBPr+D for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:07:57 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 402604B243
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:07:57 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 477A3B8159E;
 Mon, 29 Nov 2021 20:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13300C53FCF;
 Mon, 29 Nov 2021 20:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216475;
 bh=Ph49KKBZ+O22t+hKyvWjXj2PVYxm0X5Rb2BvJLz8sHs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=cJuSURiTc+KIGijIrvc2xeAEkXgjVpGvvvbLINxP40eqOBVXlF4Ch6hMy5WwDVVYn
 yzlspQBDDmIzIl15pgLxwo/DBLYn0MBl8yY4OTHnSLqg3yfaTXBFiF2iVtBN7YnTyU
 L6a5/6JDAzAXfPL24UDyZOPVnFaozbIUiF3DsT+GKlMJfZQ6aC4uzF/2o+wrPtL/G9
 jWUP7dL9r2KyfrcNBIQZj0tD+LePoo0K752ktNfrSMyH7Z8/dIaj/LHl8FJQ6I/Nf2
 dyxe6T+GhqX2yp6azjXKqbKfzbg4r4IQd2qskCHjQzHVy426kHTMazUwPD889pIFeK
 GoRxbBZrnSKIw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmqx-008gvR-U7; Mon, 29 Nov 2021 20:02:19 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 33/69] KVM: arm64: nv: Forward debug traps to the nested
 guest
Date: Mon, 29 Nov 2021 20:01:14 +0000
Message-Id: <20211129200150.351436-34-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

On handling a debug trap, check whether we need to forward it to the
guest before handling it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 2 ++
 arch/arm64/kvm/emulate-nested.c     | 9 +++++++--
 arch/arm64/kvm/sys_regs.c           | 3 +++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 26cba7b4d743..07c15f51cf86 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -62,6 +62,8 @@ static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
 }
 
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
+extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
+			    u64 control_bit);
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 8c7f2fe24bc6..5fbf8978acf2 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -25,14 +25,14 @@
 
 #include "trace.h"
 
-bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg, u64 control_bit)
 {
 	bool control_bit_set;
 
 	if (!nested_virt_in_use(vcpu))
 		return false;
 
-	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	control_bit_set = __vcpu_sys_reg(vcpu, reg) & control_bit;
 	if (!vcpu_mode_el2(vcpu) && control_bit_set) {
 		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
 		return true;
@@ -40,6 +40,11 @@ bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
 	return false;
 }
 
+bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	return __forward_traps(vcpu, HCR_EL2, control_bit);
+}
+
 bool forward_nv_traps(struct kvm_vcpu *vcpu)
 {
 	return forward_traps(vcpu, HCR_NV);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 692cade54caf..9deedd5a058f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -603,6 +603,9 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
+	if (__forward_traps(vcpu, MDCR_EL2, MDCR_EL2_TDA | MDCR_EL2_TDE))
+		return false;
+
 	access_rw(vcpu, p, r);
 	if (p->is_write)
 		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
