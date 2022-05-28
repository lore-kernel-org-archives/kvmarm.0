Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB744C4332F
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 11:49:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E9B54B337;
	Sat, 28 May 2022 07:49:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VE9NE5YFM9fn; Sat, 28 May 2022 07:49:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 111B14B334;
	Sat, 28 May 2022 07:49:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76D934B108
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:49:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7PsulwKL4aEk for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 May 2022 07:49:55 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D5CA4B28F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:49:55 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 59A55B81705;
 Sat, 28 May 2022 11:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24207C34100;
 Sat, 28 May 2022 11:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653738592;
 bh=N0NNp71i7DfCF28Gn1//ZvCMFd8ZM8wQyOhM8D3TpFo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=POkvcqcM/zISGrTrfs/06p5WIB6cFBniHoIl8hdw+/hFD8yZfL/zMblqwioESv8ZK
 EBrJllFUcTdqPoUu6KsVNGQKIgUVgPccW81QT1EnVWSqnRvU1qIFg41ZBc9MztI/B1
 F8bhfFIIbXlkMidzI5txFiESLJn44CrA6jKD2W3+UcNHF66DH0+aFJFZ61ncOrF6Rt
 wd+Qks8nXzUigfLRIvZbMDBULPAHUXampzzlteT6PEEOrQI7RxGcfnJCW0nc7UDgKV
 EO5jXBpA8uOWnt1vbAfW7qwi4Gai1hcwk3SrJOsazqvAsEF24j6cGHgOJODVtvWD5K
 m8kaJsjL6FxzA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nuumC-00EEGh-1n; Sat, 28 May 2022 12:38:36 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/18] KVM: arm64: Move vcpu ON_UNSUPPORTED_CPU flag to the
 state flag set
Date: Sat, 28 May 2022 12:38:21 +0100
Message-Id: <20220528113829.1043361-12-maz@kernel.org>
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

The ON_UNSUPPORTED_CPU flag is only there to track the sad fact
that we have ended-up on a CPU where we cannot really run.

Since this is only for the host kernel's use, move it to the state
set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a28a2dca8767..e0a2edca5861 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -511,6 +511,8 @@ struct kvm_vcpu_arch {
 #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
 /* SME enabled for EL0 */
 #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
+/* Physical CPU not in supported_cpus */
+#define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
@@ -533,7 +535,6 @@ struct kvm_vcpu_arch {
 })
 
 /* vcpu_arch flags field values: */
-#define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
 #define KVM_ARM64_WFIT			(1 << 17) /* WFIT instruction trapped */
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
@@ -553,13 +554,13 @@ struct kvm_vcpu_arch {
 #endif
 
 #define vcpu_on_unsupported_cpu(vcpu)					\
-	((vcpu)->arch.flags & KVM_ARM64_ON_UNSUPPORTED_CPU)
+	vcpu_get_flag(vcpu, ON_UNSUPPORTED_CPU)
 
 #define vcpu_set_on_unsupported_cpu(vcpu)				\
-	((vcpu)->arch.flags |= KVM_ARM64_ON_UNSUPPORTED_CPU)
+	vcpu_set_flag(vcpu, ON_UNSUPPORTED_CPU)
 
 #define vcpu_clear_on_unsupported_cpu(vcpu)				\
-	((vcpu)->arch.flags &= ~KVM_ARM64_ON_UNSUPPORTED_CPU)
+	vcpu_clear_flag(vcpu, ON_UNSUPPORTED_CPU)
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
