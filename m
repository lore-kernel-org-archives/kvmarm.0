From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 05/55] KVM: arm64: Add vcpu_mode_el2 primitive to support nesting
Date: Mon,  9 Jan 2017 01:24:01 -0500
Message-ID: <1483943091-1364-6-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29DD4401F2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:23:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GvrWS5K2-SSk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:23:56 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33E93403F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:23:56 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PX6N017321
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:37 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id CB42285
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:37 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 9BA448B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:37 -0500 (EST)
Received: from mail-qk0-f199.google.com (mail-qk0-f199.google.com
 [209.85.220.199])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PbWo041699
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:37 -0500
Received: by mail-qk0-f199.google.com with SMTP id d201so85770626qkg.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:37 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When running a nested hypervisor we occasionally have to figure out if
the mode we are switching into is the virtual EL2 mode or a regular
EL0/1 mode.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm/include/asm/kvm_emulate.h   |  6 ++++++
 arch/arm64/include/asm/kvm_emulate.h | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 9a8a45a..399cd75e 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -77,6 +77,12 @@ static inline bool vcpu_mode_is_32bit(const struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+/* We don't support nesting on arm */
+static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 static inline unsigned long *vcpu_pc(struct kvm_vcpu *vcpu)
 {
 	return &vcpu->arch.ctxt.gp_regs.usr_regs.ARM_pc;
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f5ea0ba..830be2e 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -143,6 +143,18 @@ static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 	return mode != PSR_MODE_EL0t;
 }
 
+static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
+{
+	u32 mode;
+
+	if (vcpu_mode_is_32bit(vcpu))
+		return false;
+
+	mode = *vcpu_cpsr(vcpu) & PSR_MODE_MASK;
+
+	return mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t;
+}
+
 static inline u32 kvm_vcpu_get_hsr(const struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.fault.esr_el2;
-- 
1.9.1
