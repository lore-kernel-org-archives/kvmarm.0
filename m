Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BEAC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:47:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E530B4B44F;
	Thu, 19 May 2022 09:47:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I69sPuSqZM1E; Thu, 19 May 2022 09:47:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA8894B455;
	Thu, 19 May 2022 09:47:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBDF94B4A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b+FzkLd8TXWn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:47:40 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B90E24B49B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:40 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B6717B824B1;
 Thu, 19 May 2022 13:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19249C34116;
 Thu, 19 May 2022 13:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968058;
 bh=Fi4thb9Ps0T6UgODhOnaPjCJWB96ZlDSu7QTR8NPXQo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=GZBOSK7VfxPFzib5mV3HMqsJQ9/evGbAliHuAVatM2kZEoNTGkN0CKuYss/GQpPCu
 wCgUw+uVwN1pqUqj1qSqKSMfGISRf8SfmpdY+mlaCSYruHm7oXUJPdGWrFmbeTh8WP
 Zw6e+/WSVVPnQxuonjCpc79/P2/cMN0N4Tjhn/j+zb1kaj+Lat55ejjuUb/totLzuL
 IcYgQuKPC9LjSOJdsAwwp6UQ5bG03WonLTNoT26HOaaY6QgmMyqnifqvsLB80yC+Jg
 CaIFEdO2RVaFsM73oebNGyphbNtUAV020Nd+iw/B3afIZavVOonu+kcI200/wbJa/j
 ZjfRbga5U+cvQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 79/89] KVM: arm64: Add is_pkvm_initialized() helper
Date: Thu, 19 May 2022 14:41:54 +0100
Message-Id: <20220519134204.5379-80-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Quentin Perret <qperret@google.com>

Add a helper allowing to check when the pkvm static key is enabled to
ease the introduction of pkvm hooks in other parts of the code.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/virt.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 0e80db4327b6..3d5bfcdb49aa 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -74,6 +74,12 @@ void __hyp_reset_vectors(void);
 
 DECLARE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
 
+static inline bool is_pkvm_initialized(void)
+{
+	return IS_ENABLED(CONFIG_KVM) &&
+	       static_branch_likely(&kvm_protected_mode_initialized);
+}
+
 /* Reports the availability of HYP mode */
 static inline bool is_hyp_mode_available(void)
 {
@@ -81,8 +87,7 @@ static inline bool is_hyp_mode_available(void)
 	 * If KVM protected mode is initialized, all CPUs must have been booted
 	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
 	 */
-	if (IS_ENABLED(CONFIG_KVM) &&
-	    static_branch_likely(&kvm_protected_mode_initialized))
+	if (is_pkvm_initialized())
 		return true;
 
 	return (__boot_cpu_mode[0] == BOOT_CPU_MODE_EL2 &&
@@ -96,8 +101,7 @@ static inline bool is_hyp_mode_mismatched(void)
 	 * If KVM protected mode is initialized, all CPUs must have been booted
 	 * in EL2. Avoid checking __boot_cpu_mode as CPUs now come up in EL1.
 	 */
-	if (IS_ENABLED(CONFIG_KVM) &&
-	    static_branch_likely(&kvm_protected_mode_initialized))
+	if (is_pkvm_initialized())
 		return false;
 
 	return __boot_cpu_mode[0] != __boot_cpu_mode[1];
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
