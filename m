Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41C0C43334
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 09:35:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CCE141174;
	Fri, 10 Jun 2022 05:35:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zYNqC38Govrp; Fri, 10 Jun 2022 05:35:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79A0F4B2C0;
	Fri, 10 Jun 2022 05:35:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BA664A0FE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TRM8po0DocXG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 05:35:49 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 166B54B3F8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:49 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 455EBB82CFB;
 Fri, 10 Jun 2022 09:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0240CC3411F;
 Fri, 10 Jun 2022 09:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654853747;
 bh=jbtE45MUd9nV3Z8bCfIwAlBr4MHgnoXHgJYkftSo/C4=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=jKAcBUiCi9RuFk/2o3s3Ps+lQakp9/48ct98m/wo+f7BtpDRh68/deXDut0DsYAHO
 9CJe/93aiVcWbxISacI0S8Zuod1Pf+XVx2bCIxvh7MrJqg+rVJSV8AZ0MzO4BMqFOv
 1qW2lmA5txHwbwnbDKNYLS00Ujzy2CirT/cJrtRF1u9anrKzkTRbNpi/MCG7eQzaWP
 Z5v/AB1Dr82z2mWg+X8ZZDK8Bhaf7If80m8sczFkBzKt4QK9yX9nYRGahIvH3BoYWg
 nBn+LEme0jnc/CrSq2tY1xqguPpAUqFZ95O/giK56DDWgSH3IkxGBqOVwi9dNhOTHO
 7wKb9DebkwUfg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nzawr-00H6Dt-V4; Fri, 10 Jun 2022 10:28:58 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 17/19] KVM: arm64: Reduce the size of the vcpu flag members
Date: Fri, 10 Jun 2022 10:28:36 +0100
Message-Id: <20220610092838.1205755-18-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, oupton@google.com,
 will@kernel.org, tabba@google.com, qperret@google.com, broonie@kernel.org,
 reijiw@google.com, kernel-team@android.com
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

Now that we can detect flags overflowing their container, reduce
the size of all flag set members in the vcpu struct, turning them
into 8bit quantities.

Even with the FP state enum occupying 32bit, the whole of the state
that was represented by flags is smaller by one byte. Profit!

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 6a37018f40b7..c6975ecf5a5f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -333,13 +333,13 @@ struct kvm_vcpu_arch {
 	} fp_state;
 
 	/* Configuration flags, set once and for all before the vcpu can run */
-	u64 cflags;
+	u8 cflags;
 
 	/* Input flags to the hypervisor code, potentially cleared after use */
-	u64 iflags;
+	u8 iflags;
 
 	/* State flags for kernel bookkeeping, unused by the hypervisor code */
-	u64 sflags;
+	u8 sflags;
 
 	/*
 	 * We maintain more than a single set of debug registers to support
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
