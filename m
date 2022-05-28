Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF6CC43217
	for <kvmarm@archiver.kernel.org>; Sat, 28 May 2022 11:50:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA7504B361;
	Sat, 28 May 2022 07:50:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pcUzYpgp3euJ; Sat, 28 May 2022 07:50:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 91C4F4B334;
	Sat, 28 May 2022 07:50:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 895E74B350
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:50:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5u2AoWMZo-Ip for <kvmarm@lists.cs.columbia.edu>;
 Sat, 28 May 2022 07:50:02 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DE844B2AA
 for <kvmarm@lists.cs.columbia.edu>; Sat, 28 May 2022 07:50:02 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B951160E8E;
 Sat, 28 May 2022 11:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB4EC34118;
 Sat, 28 May 2022 11:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653738601;
 bh=yyB4hR+igLzaHP7EAyqgeD9ghacZPHl0R9Sq6ANIVOE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=d3vYl542YFv3IJ9osmVM4WSi2218X2VpMsUOjpQIk6V//UZCY3OyLyTE89mS2HWij
 xjQEi4/vXRFLY0Uzc4kquuaK9PHcgPcQd235V5DlQ1zsPBKJBOjQyCGN2r++BZQ4Hy
 vv/k+M1zNA9cWp7lQBDOYcjkAnH2oUk/zR2EERAKCmL1q7S3vrlSyY8gUns3KDYcKL
 wygZU3xYRzy2Qdej5T/fM/NuiA42DLJJUdVlfxnjLR5HraWuGUB8bCEgf/9kWZJWUb
 aavW18bnw9JXPyqYa3o0sKOGwM2kcy54nWICEH6tPKFUyvIQHxFYpma3Qp3LDnUEbJ
 yVHW8JysbIuLA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nuumD-00EEGh-DD; Sat, 28 May 2022 12:38:37 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 16/18] KVM: arm64: Add build-time sanity checks for flags
Date: Sat, 28 May 2022 12:38:26 +0100
Message-Id: <20220528113829.1043361-17-maz@kernel.org>
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

Flags are great, but flags can also be dangerous: it is easy
to encode a flag that is bigger than its container (unless the
container is a u64), and it is easy to construct a flag value
that doesn't fit in the mask that is associated with it.

Add a couple of build-time sanity checks that ensure we catch
these two cases.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4073a33af17c..70931231f0cb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -420,8 +420,20 @@ struct kvm_vcpu_arch {
 	} steal;
 };
 
+#define __build_check_flag(v, flagset, f, m)			\
+	do {							\
+		typeof(v->arch.flagset) *_fset;			\
+								\
+		/* Check that the flags fit in the mask */	\
+		BUILD_BUG_ON(HWEIGHT(m) != HWEIGHT((f) | (m)));	\
+		/* Check that the flags fit in the type */	\
+		BUILD_BUG_ON((sizeof(*_fset) * 8) <= __fls(m));	\
+	} while (0)
+
 #define __vcpu_get_flag(v, flagset, f, m)			\
 	({							\
+		__build_check_flag(v, flagset, f, m);		\
+								\
 		v->arch.flagset & (m);				\
 	})
 
@@ -429,6 +441,8 @@ struct kvm_vcpu_arch {
 	do {							\
 		typeof(v->arch.flagset) *fset;			\
 								\
+		__build_check_flag(v, flagset, f, m);		\
+								\
 		fset = &v->arch.flagset;			\
 		if (HWEIGHT(m) > 1)				\
 			*fset &= ~(m);				\
@@ -439,6 +453,8 @@ struct kvm_vcpu_arch {
 	do {							\
 		typeof(v->arch.flagset) *fset;			\
 								\
+		__build_check_flag(v, flagset, f, m);		\
+								\
 		fset = &v->arch.flagset;			\
 		*fset &= ~(m);					\
 	} while (0)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
