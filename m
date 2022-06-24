Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4508CCA47E
	for <kvmarm@archiver.kernel.org>; Fri, 24 Jun 2022 21:33:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8559349E2B;
	Fri, 24 Jun 2022 17:33:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hccbyEcIZNW0; Fri, 24 Jun 2022 17:33:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C6A8E49EF2;
	Fri, 24 Jun 2022 17:33:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F5A041019
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hm5T7MRVJIKV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Jun 2022 17:33:14 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96B174A19A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 17:33:13 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 v2-20020a622f02000000b0052573fc72f8so1389581pfv.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Jun 2022 14:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=2pvMWA5+LGv3RdMZNBoLvpYZzgKfwmddMMIH/iaxNxg=;
 b=DWRLrw0Pt69QOEsBGJR5o/AN8ZFPsVl53Xo8K8BIJhG/IDN/uxsSrynpUdplQs376z
 lqxwwBt1kmwr+toD0URkkYAZ3p7c5C/TMMc0W6SGwg5q9acLZEawJ5XW5EXAT/hHjF+7
 dJ8PYxHzObjsF5WwmcCMZQdoecdsWgnkpFR5MqkLUlicWqozJaLjCY+kYPY8m8boWU73
 90T/Iq11fKY2ZMiVbBwrBqEkDPhJzPWD2OPeXPHsjK7tRr1yHWnCUQd870WkN9B9LODN
 FwGfF6Rh0mSy5RG+yZxvNpJYKx7RCfin80oYvjsMMgugwBlD2sdn8A22hN5v09qAIyQr
 KDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=2pvMWA5+LGv3RdMZNBoLvpYZzgKfwmddMMIH/iaxNxg=;
 b=jSpR5vyNSKRXwjosQX0+WHbRgi1lKbPmAWaEtzyQlQ0UUrF8IwQ86sNwwltlP+qaYA
 PEZJL23GfxGdE+qFJXKk+OuRb/apXaXG2SOKEWsMru6iI5SV7hvPCCdZlU2APMkNCaQu
 wz0SEIR71GoPlMODzK6QC64HOIN0MIaa7Hx4x8cgWtmqivm23abGogfhHKJ0PeSUOrZY
 dPJ3+Uz6Y0eKzmD862+hWgIu+oh6LBzy7wTtXwwa8JhwBBDFS/NHHO7ATyVIkX8a7eYD
 UvTfnbxplsXf2VVGGldmr76yMKR8XK5eXJySkVq/nx6z/F4xF3reC1Pl8EdawDhT99zo
 p+Og==
X-Gm-Message-State: AJIora9T2PUloNDXMMi/OxSQfeQKCrgWdkNOLlsmGEeE+DcGn66azuVy
 F30TcDSA0+flJXLYrqfKWktvVghuVUzttQ==
X-Google-Smtp-Source: AGRyM1tXnFVHX/mA1hKXRSHVJBfUgoA+2551qzmvFCvbDgZmsP7oq3cp/lqnX0pyYD+bQFHOsi/Tr1cAB3hKtA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e8c6:b0:169:10c4:5231 with SMTP
 id v6-20020a170902e8c600b0016910c45231mr1144856plg.173.1656106392828; Fri, 24
 Jun 2022 14:33:12 -0700 (PDT)
Date: Fri, 24 Jun 2022 14:32:51 -0700
In-Reply-To: <20220624213257.1504783-1-ricarkol@google.com>
Message-Id: <20220624213257.1504783-8-ricarkol@google.com>
Mime-Version: 1.0
References: <20220624213257.1504783-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v4 07/13] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, axelrasmussen@google.com
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

Define macros for memory type indexes and construct DEFAULT_MAIR_EL1
with macros from asm/sysreg.h.  The index macros can then be used when
constructing PTEs (instead of using raw numbers).

Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 25 ++++++++++++++-----
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 6649671fa7c1..74f10d006e15 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -38,12 +38,25 @@
  * NORMAL             4     1111:1111
  * NORMAL_WT          5     1011:1011
  */
-#define DEFAULT_MAIR_EL1 ((0x00ul << (0 * 8)) | \
-			  (0x04ul << (1 * 8)) | \
-			  (0x0cul << (2 * 8)) | \
-			  (0x44ul << (3 * 8)) | \
-			  (0xfful << (4 * 8)) | \
-			  (0xbbul << (5 * 8)))
+
+/* Linux doesn't use these memory types, so let's define them. */
+#define MAIR_ATTR_DEVICE_GRE	UL(0x0c)
+#define MAIR_ATTR_NORMAL_WT	UL(0xbb)
+
+#define MT_DEVICE_nGnRnE	0
+#define MT_DEVICE_nGnRE		1
+#define MT_DEVICE_GRE		2
+#define MT_NORMAL_NC		3
+#define MT_NORMAL		4
+#define MT_NORMAL_WT		5
+
+#define DEFAULT_MAIR_EL1							\
+	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRnE, MT_DEVICE_nGnRnE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |				\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_WT, MT_NORMAL_WT))
 
 #define MPIDR_HWID_BITMASK (0xff00fffffful)
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 8dd511aa79c2..733a2b713580 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -133,7 +133,7 @@ void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
+	uint64_t attr_idx = MT_NORMAL;
 
 	_virt_pg_map(vm, vaddr, paddr, attr_idx, 0);
 }
-- 
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
