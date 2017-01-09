From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 55/55] KVM: arm64: Enable nested virtualization
Date: Mon,  9 Jan 2017 01:24:51 -0500
Message-ID: <1483943091-1364-56-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 16BC340625
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 84v7rL0vtiGe for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:25:03 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 255B9405A7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:59 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q5Cx006198
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:40 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id BD93181
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:40 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id 8803382
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:40 -0500 (EST)
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com
 [209.85.220.198])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096QeXW041928
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:40 -0500
Received: by mail-qk0-f198.google.com with SMTP id d201so85781077qkg.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:40 -0800 (PST)
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

Now that everything is ready, we enable nested virtualization by setting
the HCR NV and NV1 bit.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/asm/kvm_arm.h | 1 +
 arch/arm64/kvm/hyp/switch.c      | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index f9addf3..ab8b93b 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -24,6 +24,7 @@
 
 /* Hyp Configuration Register (HCR) bits */
 #define HCR_NV1		(UL(1) << 43)
+#define HCR_NV		(UL(1) << 42)
 #define HCR_E2H		(UL(1) << 34)
 #define HCR_ID		(UL(1) << 33)
 #define HCR_CD		(UL(1) << 32)
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index c80b2ae..df7b88d 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -87,7 +87,7 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		isb();
 	}
 	if (vcpu_mode_el2(vcpu))
-		val |= HCR_TVM | HCR_TRVM;
+		val |= HCR_TVM | HCR_TRVM | HCR_NV | HCR_NV1;
 	write_sysreg(val, hcr_el2);
 	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
-- 
1.9.1
