Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D779C6FA8B
	for <kvmarm@archiver.kernel.org>; Tue,  6 Sep 2022 18:09:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 384C34BC55;
	Tue,  6 Sep 2022 14:09:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SBOAMKtmFSSe; Tue,  6 Sep 2022 14:09:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3ECF4BCCE;
	Tue,  6 Sep 2022 14:09:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D603C4BBB5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 14:09:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JYtkiUcEJJCR for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2022 14:09:42 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE8CE4BBF1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2022 14:09:42 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3452b545544so51180397b3.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2022 11:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=WT2R6z6Lj/wGUMYzxUUXh6/WyMLsyb+mHF2mn3pQS0A=;
 b=Hpd5SISjcMrCHf9JGChu9s9F77ftmvQgJ0eeVwHgoh+jmH8F1saN/GiAHzrJkOyH4a
 iN6WTYT7UVvEuvarYM60NPIkdylI6USs8tojmkKw77K+FzJsBDpeS6tRdMmQaJ90Yqj0
 ZJptnNxxyoNksHntqPxpLUfqAYcJyBFpG+lpFu5PKIHClFsH9axeaw3Irj+zAzHR1Wfo
 7Rp+ZrH8BINtd+Ovld090w5P713yDfv9HryiEhwngEjv8zWXNGhM2yH+RuBBofiX+EhY
 flQGGu0JTrWNMppeNXJADO1ooRWl7S4HeZJmmlUGmaEgOGwDpImEYqEqW8UOFK/Rk65u
 aT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=WT2R6z6Lj/wGUMYzxUUXh6/WyMLsyb+mHF2mn3pQS0A=;
 b=SpnMMqkYpnFqTs7wvy9MrOZQfMpnUz8gZ81nhH2bn+t8/fdNuH9I4HEkKDBSvWg82/
 IrnMdMoCRm5U6cjOgsqR/vWTfk1osFeB8atXOcKyKtzuh1Wd6FOjGHNu9IiAwyqO3kqq
 H+lu0DG+fAbY6Rw74oIqj7/CAxtCUbubx+crV+3rmlIf0Iieu6PfwrJp1iCzLhPYo5o5
 zw60VuTMqiz8azGIaZolK6tEph25dEwZ8XcBq/vfMMPVr7VwP+22GfGoKXOXiqCFN7Lx
 aHLNXCxpYbToItY9IfrmDIFCO5tn5MrRu1y+FzL3d2/AnnM1SbgmnVUPNBqAqUYtlMtO
 OoJQ==
X-Gm-Message-State: ACgBeo1kOgDZZfztkZADtbc9rdT3C4X7VIiGMZO28X0sBelE/fAhVOxx
 XgTojgRRWZVtn+7fsHGuQavHq2pAs3wT6g==
X-Google-Smtp-Source: AA6agR5HZOlR46dlOCLVnDPm04bTiVUX60QtegJVypIVw2VNqy4drQBeKd/JOH3/A4EZV6bHfN4lbEVmHNvhtg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:10c5:b0:671:7158:cf2c with SMTP
 id w5-20020a05690210c500b006717158cf2cmr39837170ybu.314.1662487782395; Tue,
 06 Sep 2022 11:09:42 -0700 (PDT)
Date: Tue,  6 Sep 2022 18:09:21 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-5-ricarkol@google.com>
Subject: [PATCH v6 04/13] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: maz@kernel.org, bgardon@google.com, pbonzini@redhat.com,
 axelrasmussen@google.com, dmatlack@google.com
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/aarch64/processor.h | 25 ++++++++++++++-----
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index df4bfac69551..c1ddca8db225 100644
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
index 63ef3c78e55e..26f0eccff6fe 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -133,7 +133,7 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	uint64_t attr_idx = 4; /* NORMAL (See DEFAULT_MAIR_EL1) */
+	uint64_t attr_idx = MT_NORMAL;
 
 	_virt_pg_map(vm, vaddr, paddr, attr_idx);
 }
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
