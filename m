Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9032FC43217
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 09:07:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 309194B85F;
	Thu, 20 Oct 2022 05:07:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WMxwzH6SNCyE; Thu, 20 Oct 2022 05:07:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D8274B967;
	Thu, 20 Oct 2022 05:07:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4EC64B940
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:07:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TohXqkdeb3nq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 05:07:39 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADF154B947
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 05:07:39 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 34DB461A8A;
 Thu, 20 Oct 2022 09:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53ABFC43470;
 Thu, 20 Oct 2022 09:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1666256858;
 bh=ibRbpbqyyZwpE8uleN4Hk5+6ZsHndJbfZ6Q1wyW9WnI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Y17VeND+16qCwxDJ46fkgBcrXLFRNMO9G4sV7gkCf9etfSn0LCP+gmzInphOk1Ni3
 5e2pWVSIVBEkNG0IcF6R/cQFjOPB/Lm7gaxPXQ9VmicfbqAQdF9lxI+qDohW1361T+
 FZMCDSulK/T0KNVb2EtbzPs6ZzLuOOOjPYIdu4tIBbhDIPG4z0hKwMlSCr/UVrHgvk
 h5Qsty+A0pA6gkeWncGuJsQyeE22EfoMujB1b/Ogkcg1P118frgLNSXakAlcqE8Frb
 gjXkD+2QiHDn28y2GvBZY0oZK7HZ2lP8ZC23MiwD/ZIEfZp64qkT2FsqRc6TnC71eJ
 YCuEwBYCYYAjQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1olRWa-000Buf-Jc;
 Thu, 20 Oct 2022 10:07:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 08/17] KVM: arm64: Remove alternatives from sysreg accessors
 in VHE hypervisor context
Date: Thu, 20 Oct 2022 10:07:18 +0100
Message-Id: <20221020090727.3669908-9-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev,
 qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>
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

In the VHE hypervisor code, we should be using the remapped VHE
accessors, no ifs, no buts. No need to generate any alternative.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index aa7fa2a08f06..461fc0dc4a70 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -16,6 +16,23 @@ DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DECLARE_PER_CPU(unsigned long, kvm_hyp_vector);
 DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
+/*
+ * Unified accessors for registers that have a different encoding
+ * between VHE and non-VHE. They must be specified without their "ELx"
+ * encoding, but with the SYS_ prefix, as defined in asm/sysreg.h.
+ */
+
+#if defined(__KVM_VHE_HYPERVISOR__)
+
+#define read_sysreg_el0(r)	read_sysreg_s(r##_EL02)
+#define write_sysreg_el0(v,r)	write_sysreg_s(v, r##_EL02)
+#define read_sysreg_el1(r)	read_sysreg_s(r##_EL12)
+#define write_sysreg_el1(v,r)	write_sysreg_s(v, r##_EL12)
+#define read_sysreg_el2(r)	read_sysreg_s(r##_EL1)
+#define write_sysreg_el2(v,r)	write_sysreg_s(v, r##_EL1)
+
+#else // !__KVM_VHE_HYPERVISOR__
+
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
 		u64 reg;						\
@@ -35,12 +52,6 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 					 : : "rZ" (__val));		\
 	} while (0)
 
-/*
- * Unified accessors for registers that have a different encoding
- * between VHE and non-VHE. They must be specified without their "ELx"
- * encoding, but with the SYS_ prefix, as defined in asm/sysreg.h.
- */
-
 #define read_sysreg_el0(r)	read_sysreg_elx(r, _EL0, _EL02)
 #define write_sysreg_el0(v,r)	write_sysreg_elx(v, r, _EL0, _EL02)
 #define read_sysreg_el1(r)	read_sysreg_elx(r, _EL1, _EL12)
@@ -48,6 +59,8 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 #define read_sysreg_el2(r)	read_sysreg_elx(r, _EL2, _EL1)
 #define write_sysreg_el2(v,r)	write_sysreg_elx(v, r, _EL2, _EL1)
 
+#endif	// __KVM_VHE_HYPERVISOR__
+
 /*
  * Without an __arch_swab32(), we fall back to ___constant_swab32(), but the
  * static inline can allow the compiler to out-of-line this. KVM always wants
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
