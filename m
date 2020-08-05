Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDBFC433E0
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 17:57:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 85CB522D07
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 17:57:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dq0mTS5l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85CB522D07
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E26D4B57C;
	Wed,  5 Aug 2020 13:57:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vzG3kFsM8cU3; Wed,  5 Aug 2020 13:57:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B6A04B579;
	Wed,  5 Aug 2020 13:57:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E69804B4EB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 13:57:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X5GGo1EogYCq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 13:57:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D7B474B561
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 13:57:15 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 01FEB2250E;
 Wed,  5 Aug 2020 17:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596650235;
 bh=auCGx6XCpPj3YqEfR6NXLz5q29tOXX3dB0MRke0HUQQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Dq0mTS5ldx9HxUmrCnD0/17fGX0zXjqZ6in/6TXrm92Pc61ToxKYi1AR+F+gYHNTQ
 n6YBKphf2pcDLWZK+nIM00efMICQMG1YOV26GFBe54ICAMPhw9vRlmi7OFhmAUE4H8
 hV7YhEKHnG4vhcQ2XZsG/wLq4PhPK4OPOPCq2q+4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1k3Nf7-0004w9-IK; Wed, 05 Aug 2020 18:57:13 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 02/56] KVM: arm64: Allow ARM64_PTR_AUTH when ARM64_VHE=n
Date: Wed,  5 Aug 2020 18:56:06 +0100
Message-Id: <20200805175700.62775-3-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com,
 alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com,
 christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com,
 richard.peng@oppo.com, qperret@google.com, will@kernel.org,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Peng Hao <richard.peng@oppo.com>, kernel-team@android.com,
 kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

We currently prevent PtrAuth from even being built if KVM is selected,
but VHE isn't. It is a bit of a pointless restriction, since we also
check this at run time (rejecting the enabling of PtrAuth for the
vcpu if we're not running with VHE).

Just drop this apparently useless restriction.

Acked-by: Andrew Scull <ascull@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 31380da53689..d719ea9c596d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1516,7 +1516,6 @@ menu "ARMv8.3 architectural features"
 config ARM64_PTR_AUTH
 	bool "Enable support for pointer authentication"
 	default y
-	depends on !KVM || ARM64_VHE
 	depends on (CC_HAS_SIGN_RETURN_ADDRESS || CC_HAS_BRANCH_PROT_PAC_RET) && AS_HAS_PAC
 	# GCC 9.1 and later inserts a .note.gnu.property section note for PAC
 	# which is only understood by binutils starting with version 2.33.1.
@@ -1543,8 +1542,7 @@ config ARM64_PTR_AUTH
 
 	  The feature is detected at runtime. If the feature is not present in
 	  hardware it will not be advertised to userspace/KVM guest nor will it
-	  be enabled. However, KVM guest also require VHE mode and hence
-	  CONFIG_ARM64_VHE=y option to use this feature.
+	  be enabled.
 
 	  If the feature is present on the boot CPU but not on a late CPU, then
 	  the late CPU will be parked. Also, if the boot CPU does not have
-- 
2.27.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
