Return-Path: <SRS0=1hyK=BH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEC8C433E8
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 08:23:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 954B82075D
	for <kvmarm@archiver.kernel.org>; Tue, 28 Jul 2020 08:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2uewzYw+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 954B82075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 508B64B92A;
	Tue, 28 Jul 2020 04:23:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PCqokq60zhI3; Tue, 28 Jul 2020 04:23:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9EDE4B913;
	Tue, 28 Jul 2020 04:23:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 085F04B858
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 04:23:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TrxRlNjEZvoM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jul 2020 04:23:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C61134B860
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jul 2020 04:23:25 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F0B4820809;
 Tue, 28 Jul 2020 08:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1595924605;
 bh=iJ+8/MWn5KdaoZ81Y0HfDlr48qzak2k8kb91X6SO0S4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=2uewzYw+Xs67HzTT2pJajyh1R5CYcRLNJBkQAy0ca72w4NYphAI5cXI/qsrZk+gbl
 oCAXjVjUAa24o1lA0ewSimmiTtPJPx2LWThxiP8+NgPur0ha3BJ5ydDIiw+ceqxwog
 +ToKOaROkXVQnHLz0hrkP8AmJqLeQgQWGrXs4Ar0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k0KtP-00FaXh-GW; Tue, 28 Jul 2020 09:23:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/2] KVM: arm64: Prevent vcpu_has_ptrauth from generating OOL
 functions
Date: Tue, 28 Jul 2020 09:22:54 +0100
Message-Id: <20200728082255.3864378-2-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200728082255.3864378-1-maz@kernel.org>
References: <20200728082255.3864378-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, natechancellor@gmail.com,
 ndesaulniers@google.com, qperret@google.com, will@kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Nick Desaulniers <ndesaulniers@google.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, Will Deacon <will@kernel.org>,
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

So far, vcpu_has_ptrauth() is implemented in terms of system_supports_*_auth()
calls, which are declared "inline". In some specific conditions (clang
and SCS), the "inline" very much turns into an "out of line", which
leads to a fireworks when this predicate is evaluated on a non-VHE
system (right at the beginning of __hyp_handle_ptrauth).

Instead, make sure vcpu_has_ptrauth gets expanded inline by directly
using the cpus_have_final_cap() helpers, which are __always_inline,
generate much better code, and are the only thing that make sense when
running at EL2 on a nVHE system.

Fixes: 29eb5a3c57f7 ("KVM: arm64: Handle PtrAuth traps early")
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Link: https://lore.kernel.org/r/20200722162231.3689767-1-maz@kernel.org
---
 arch/arm64/include/asm/kvm_host.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c3e6fcc664b1..e21d4a01372f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -380,9 +380,14 @@ struct kvm_vcpu_arch {
 #define vcpu_has_sve(vcpu) (system_supports_sve() && \
 			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
 
-#define vcpu_has_ptrauth(vcpu)	((system_supports_address_auth() || \
-				  system_supports_generic_auth()) && \
-				 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))
+#ifdef CONFIG_ARM64_PTR_AUTH
+#define vcpu_has_ptrauth(vcpu)						\
+	((cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||		\
+	  cpus_have_final_cap(ARM64_HAS_GENERIC_AUTH)) &&		\
+	 (vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
+#else
+#define vcpu_has_ptrauth(vcpu)		false
+#endif
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
 
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
