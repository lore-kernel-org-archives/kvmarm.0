Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9D7C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 00:41:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 23E084A7FD;
	Thu,  7 Apr 2022 20:41:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GMJmpVpvZx7I; Thu,  7 Apr 2022 20:41:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9689C4A49C;
	Thu,  7 Apr 2022 20:41:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2379649F29
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cc9aBVEblOlK for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 20:41:35 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0176C49F44
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 20:41:34 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 i2-20020a056a00224200b004fa60c248a1so4201950pfu.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 17:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tRGVvoht62Wm0zdeImIalZjSLMP6mzAfCTWi8BhGbl8=;
 b=n4CEYM1D4z3Giyg+eCtkiEPPA3r+PIMHJVXRYwvPp7clxkEoLN6B6kqft8A7MJji+k
 iU8SOTNYfL4+d2PP5p2Vr0VZawQI+r6N14yhgAMXQ3z1V2Tx7DV1g3/ubk+U3oeTt7zh
 WDKha5AI4T8BUlhzIeEEfcfEBk1YhYRvuxgQe76KY2LtnMsAtLdhV8kYGXiLQBg3MwY2
 DDInFL5IOU7mjynjxSSCwyfUY4YRd3xJblLcvRLp2Rm2llgnV8j4Adpq+hBh9U23S35b
 1da6uAkxawWDJQVvptnrSvI5refAD77/Yit/Wzu3iA2UXDrZSnGXfnI025QofF+Z83/B
 e7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tRGVvoht62Wm0zdeImIalZjSLMP6mzAfCTWi8BhGbl8=;
 b=pl3AGPLf2sF1GWw2S7iQ5b0Rb++IQbZLdLRzF84amTJVhSMAhz+wv2csGX7yvP3UpM
 8GvhlHJ4uTYavaKpZeuLvNBJoAYQOX5vm9xTIK32WGh/Q2xjiJmF0iCzLr1Zv1fTDxJH
 AD7OXboinBj0Z449NiY6KaJOM164Ggt8byPRt+JvryoC5yys345ft8VyfeUBM+RaGM/p
 +Axl4mLrHJOJeuvu3FFg8CVxznrOag8UW9Iy6+SYAaJ8snDUsUcYaEqWm0ZghNfr+Jn7
 NGj64s/oOH3RE3uL7Z6czz0J+u9OMhVnx/MATfG9dmb4HvQvonz5x4tSLFr6QftrJ7p8
 p+9A==
X-Gm-Message-State: AOAM532Y9AO89lbSkpfzoGbp9o140ZsRcYoSFpY0VAS8bC7IHGkDBLcK
 1IFrBPXxIGRdsq2P4tJfmPFcd2oWW1qAWg==
X-Google-Smtp-Source: ABdhPJz6ca9o7Zb2UxcHfmiWYOMgxfK+ATlfbD5jLUnRA5ipNhqqxQmJEMTBA9bnY7kk9pmVoibA7Pf0fmkrug==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:6901:b0:156:4aad:fad7 with SMTP
 id j1-20020a170902690100b001564aadfad7mr16809280plk.33.1649378494200; Thu, 07
 Apr 2022 17:41:34 -0700 (PDT)
Date: Thu,  7 Apr 2022 17:41:14 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-8-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 07/13] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 24 ++++++++++++++-----
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 3965a5ac778e..16753a1f28e3 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -38,12 +38,24 @@
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
+#define MAIR_NORMAL_WT		UL(0xbb)
+
+#define MT_DEVICE_nGnRnE	0
+#define MT_DEVICE_nGnRE		1
+#define MT_DEVICE_GRE		2
+#define MT_NORMAL_NC		3
+#define MT_NORMAL		4
+#define MT_NORMAL_WT		5
+
+#define DEFAULT_MAIR_EL1							\
+	(MAIR_ATTRIDX(MAIR_ATTR_DEVICE_nGnRE, MT_DEVICE_nGnRE) |		\
+	 MAIR_ATTRIDX(MAIR_ATTR_DEVICE_GRE, MT_DEVICE_GRE) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL_NC, MT_NORMAL_NC) |			\
+	 MAIR_ATTRIDX(MAIR_ATTR_NORMAL, MT_NORMAL) |				\
+	 MAIR_ATTRIDX(MAIR_NORMAL_WT, MT_NORMAL_WT))
 
 #define MPIDR_HWID_BITMASK (0xff00fffffful)
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 8f4ec1be4364..c7b899ba3e38 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -134,7 +134,7 @@ void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
+	uint64_t attr_idx = MT_NORMAL;
 
 	_virt_pg_map(vm, vaddr, paddr, attr_idx, 0);
 }
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
