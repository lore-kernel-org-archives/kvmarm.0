Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EA0C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jun 2022 09:35:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A8A841174;
	Fri, 10 Jun 2022 05:35:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qcl7qttkZ55Q; Fri, 10 Jun 2022 05:35:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46D994B408;
	Fri, 10 Jun 2022 05:35:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 193B54B11F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fgKAv9G9vR6z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jun 2022 05:35:44 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9F8B4B324
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jun 2022 05:35:43 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E2DAEB83353;
 Fri, 10 Jun 2022 09:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C7DC34114;
 Fri, 10 Jun 2022 09:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654853741;
 bh=Hy44ebNJtdRyimKZ0wHSwqsYAjTWcKc/GaO9BGQt+IA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=MNRMoinxrv8cCVH6ckQlh6bO6wu08NptrV2+KQU5zwQgQbIaZHTwZ+T2rvno+lQBk
 7ZrbiVH8zRilig5kXhd8FxZT+LsXLi96I5bRpd0XJ8A6mfxKEPcv7UsNim9eurJmxG
 nOPgtRag4pOeERMnLVwcr8205DMQXpoDGvEBlOpfNFTlunHZjB5fXnxXp1lYreQT2L
 7hPiFPyYQmZNBKqdvawNGqBOoVlqcJf4+7pr13u6oK1/Zna7Ipg22PP2qRhy7Z3+6L
 AxM9G30f0Vj/tUOWNSZgakU/yNXLAWSvjDDviHUEwCr/qD7Y8IEfDzY1j0vaIFqwaV
 ppdlhgHac4gJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nzawr-00H6Dt-Nl; Fri, 10 Jun 2022 10:28:57 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 16/19] KVM: arm64: Add build-time sanity checks for flags
Date: Fri, 10 Jun 2022 10:28:35 +0100
Message-Id: <20220610092838.1205755-17-maz@kernel.org>
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

Flags are great, but flags can also be dangerous: it is easy
to encode a flag that is bigger than its container (unless the
container is a u64), and it is easy to construct a flag value
that doesn't fit in the mask that is associated with it.

Add a couple of build-time sanity checks that ensure we catch
these two cases.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ffbeb5f5692e..6a37018f40b7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -433,8 +433,20 @@ struct kvm_vcpu_arch {
 #define __unpack_flag(_set, _f, _m)	_f
 #define unpack_vcpu_flag(...)		__unpack_flag(__VA_ARGS__)
 
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
 
@@ -442,6 +454,8 @@ struct kvm_vcpu_arch {
 	do {							\
 		typeof(v->arch.flagset) *fset;			\
 								\
+		__build_check_flag(v, flagset, f, m);		\
+								\
 		fset = &v->arch.flagset;			\
 		if (HWEIGHT(m) > 1)				\
 			*fset &= ~(m);				\
@@ -452,6 +466,8 @@ struct kvm_vcpu_arch {
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
