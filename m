Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDDDC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:46:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86E334B3FC;
	Thu, 19 May 2022 09:46:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xpFHyjRpn+Gz; Thu, 19 May 2022 09:46:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6844B413;
	Thu, 19 May 2022 09:46:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35F0E4B3C8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hOL6KN3ceYZt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:46:40 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 25C6B4B46A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:46:40 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B2068617D2;
 Thu, 19 May 2022 13:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A424CC385AA;
 Thu, 19 May 2022 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652967999;
 bh=ykWIkC/B0e9kSshvdCfgGdw5lw0ICxc/NqaNlHqBpS8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=T8HYojTSxMlrrGKq7Yb57Pih7CxPJahzenwHlNqXjii2CspaJWdBeQnPSfIWbAL0H
 H0Sxdhyh+1uCPzcskuvc2ktDETJgRSohx1uZMaZsx7D6vixCUpQNsQ34fDquJ5EN0n
 2jjA9AcGAdmu91H75D+WpWsthclh+zUAqLlCFKnogsMiSCAFfPZG6OzgjR8VbMHF9D
 9+UoMXUGEhwH1/bEcGRnAwrgQ6s11InLEaPBsltjyAFlT+u/X8iMZM6DSRPbtPg+z/
 jcgoMl9xbOwz1K+SbLiSSdWz3JL+B7Z9kK+U864SDAjN2D0MKR0ab7S3yOfm5kplCc
 Ssmdi4fsmyCDw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 64/89] KVM: arm64: Advertise GICv3 sysreg interface to
 protected guests
Date: Thu, 19 May 2022 14:41:39 +0100
Message-Id: <20220519134204.5379-65-will@kernel.org>
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

Advertise the system register GICv3 CPU interface to protected guests
as that is the only supported configuration under pKVM.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pkvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 6f13f62558dd..062ae2ffbdfb 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -43,11 +43,13 @@ void kvm_shadow_destroy(struct kvm *kvm);
 /*
  * Allow for protected VMs:
  * - Floating-point and Advanced SIMD
+ * - GICv3(+) system register interface
  * - Data Independent Timing
  */
 #define PVM_ID_AA64PFR0_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64PFR0_FP) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_GIC) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_DIT) \
 	)
 
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
