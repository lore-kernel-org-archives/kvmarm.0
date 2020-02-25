Return-Path: <SRS0=K0wf=4N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FB5FC4BA04
	for <kvmarm@archiver.kernel.org>; Tue, 25 Feb 2020 23:52:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C6552176D
	for <kvmarm@archiver.kernel.org>; Tue, 25 Feb 2020 23:52:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXfNZUcm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C6552176D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D96D14AFD0;
	Tue, 25 Feb 2020 18:52:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i2OAbYQ8Gvc4; Tue, 25 Feb 2020 18:52:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B03664AFF2;
	Tue, 25 Feb 2020 18:52:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 138D34AFD4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Feb 2020 18:52:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oYH-bOkokqxI for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Feb 2020 18:52:46 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD2354AFB9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Feb 2020 18:52:45 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0A1BC24672;
 Tue, 25 Feb 2020 23:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582674765;
 bh=0ajrU7Pmgg3XlsIqcpsaNMnHk7izfboYZSxw9q0+DKE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=VXfNZUcmtIUKiKxnEtSc2vuKn8SJvuUhqEgxFyaIa2H+4D+kfbN4ZQlEM5hxyVzI8
 1S3VgFGi5rS5Osf96ICdKF0iy4dOAbPRz/LTjTJqbEL8y6n2DZWUrylQ31i8bkr/6e
 FMeY9SAhkHF6EYlE1P6slDwQkyzS3tZlblKEC0hw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j6k0J-007xuY-8U; Tue, 25 Feb 2020 23:52:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4/5] KVM: arm64: Define our own swab32() to avoid a uapi
 static inline
Date: Tue, 25 Feb 2020 23:52:22 +0000
Message-Id: <20200225235223.12839-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225235223.12839-1-maz@kernel.org>
References: <20200225235223.12839-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, james.morse@arm.com, jcline@redhat.com,
 mark.rutland@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

From: James Morse <james.morse@arm.com>

KVM uses swab32() when mediating GIC MMIO accesses if the GICV is badly
aligned, and the host and guest differ in endianness.

arm64 doesn't provide a __arch_swab32(), so __fswab32() is always backed
by the macro implementation that the compiler reduces to a single
instruction. But the static-inline causes problems for KVM if the compiler
chooses not to inline this function, it may not be located in the
__hyp_text where __vgic_v2_perform_cpuif_access() needs it.

Create our own __kvm_swab32() macro that calls ___constant_swab32()
directly. This way we know it will always be inlined.

Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200220165839.256881-3-james.morse@arm.com
---
 arch/arm64/include/asm/kvm_hyp.h         | 7 +++++++
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 97f21cc66657..5fde137b5150 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -47,6 +47,13 @@
 #define read_sysreg_el2(r)	read_sysreg_elx(r, _EL2, _EL1)
 #define write_sysreg_el2(v,r)	write_sysreg_elx(v, r, _EL2, _EL1)
 
+/*
+ * Without an __arch_swab32(), we fall back to ___constant_swab32(), but the
+ * static inline can allow the compiler to out-of-line this. KVM always wants
+ * the macro version as its always inlined.
+ */
+#define __kvm_swab32(x)	___constant_swab32(x)
+
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 29ee1feba4eb..4f3a087e36d5 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -69,14 +69,14 @@ int __hyp_text __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		u32 data = vcpu_get_reg(vcpu, rd);
 		if (__is_be(vcpu)) {
 			/* guest pre-swabbed data, undo this for writel() */
-			data = swab32(data);
+			data = __kvm_swab32(data);
 		}
 		writel_relaxed(data, addr);
 	} else {
 		u32 data = readl_relaxed(addr);
 		if (__is_be(vcpu)) {
 			/* guest expects swabbed data */
-			data = swab32(data);
+			data = __kvm_swab32(data);
 		}
 		vcpu_set_reg(vcpu, rd, data);
 	}
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
