Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5082C433EF
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 11:38:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 097244B332;
	Sat, 28 May 2022 07:38:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eHvvI+qPBWPj; Sat, 28 May 2022 07:38:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFB154B354;
	Sat, 28 May 2022 07:38:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0BDD4B335
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:38:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fk+-s5EAUjvq for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 May 2022 07:38:37 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 955A24B2B6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:38:37 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0F2ED60E88;
 Sat, 28 May 2022 11:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24ACFC3411B;
 Sat, 28 May 2022 11:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653737916;
 bh=d39ibshBzkgRXzQXdSghaz5ZDck87DjC7xPM+/J1juE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=cH5ET/kJKf8pzCP7k3GEzvI0ZHrigVNRpiybWI5UKAm87EYF2Xfs6L/kPyKRfzms2
 js2PL2KBvuRJI+zNjgakKqv01AHk4iqYSKMJP/MesMcld3jyw/MVsFo7cytjqGjWsj
 6v13+PYV+Mtal2bXE5RMW3ZaxwN+JLPnlz84NGj9v+PBEQtMOOqSLL4sKsYRG4I6oV
 fiSdYZ6y6OKI+X3gxuNmwEDwbrZqZlMUMU64cNP4TYbs67/uBQxLpyUgD85FO2z/vG
 4iSvJsvRAA0jaHPTbU0UUQzmLxmcU1xfSgoDYLugZXnQYOitXHHM2+gIQqJiDN3ywx
 998Kyz3kTJeuQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nuum9-00EEGh-Rr; Sat, 28 May 2022 12:38:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/18] KVM: arm64: Always start with clearing SME flag on load
Date: Sat, 28 May 2022 12:38:12 +0100
Message-Id: <20220528113829.1043361-3-maz@kernel.org>
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

On each vcpu load, we set the KVM_ARM64_HOST_SME_ENABLED
flag if SVE is enabled for EL0 on the host. This is used to
restore the correct state on vpcu put.

However, it appears that nothing ever clears this flag. Once
set, it will stick until the vcpu is destroyed, which has the
potential to spuriously enable SME for userspace. As it turns
out, this is due to the SME code being more or less copied from
SVE, and inheriting the same shortcomings.

We never saw the issue because nothing uses SME, and the amount
of testing is probably still pretty low.

Fixes: 861262ab8627 ("KVM: arm64: Handle SME host state when running guests")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 3c2cfc3adc51..78b3f143a2d0 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -94,6 +94,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	 * operations. Do this for ZA as well for now for simplicity.
 	 */
 	if (system_supports_sme()) {
+		vcpu->arch.flags &= ~KVM_ARM64_HOST_SME_ENABLED;
 		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
 			vcpu->arch.flags |= KVM_ARM64_HOST_SME_ENABLED;
 
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
