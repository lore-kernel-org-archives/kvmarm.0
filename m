Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D01EAC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 19:58:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C7514B862;
	Mon, 17 Oct 2022 15:58:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JUynAPRUU6XA; Mon, 17 Oct 2022 15:58:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5438E4B7A9;
	Mon, 17 Oct 2022 15:58:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1316D4B847
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:58:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r0p38dAYjeMo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 15:58:47 -0400 (EDT)
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com
 [209.85.160.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B4524B733
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 15:58:44 -0400 (EDT)
Received: by mail-oa1-f73.google.com with SMTP id
 586e51a60fabf-1329a5d3272so4900156fac.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 12:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=jgCIrvyj0IDci5P6m/g4M7I9DXQORNjMkIRBxaHCRXY=;
 b=ovz62uUAclqokr4+sK1sld0IXpy5sVrMhhq9Ztw46WvF06VocRRF4bINqwtQ6BZPpl
 TNxpT6pwkIsjNqwfbE24kJqeTaMuQij07JvtMzpJpnWb+k5lMBn94JUxBekLZOfAKXHA
 YwoG4h5WTYFEfxyyOEKLHR3jPojJCjxl+RHcO2yT69Pk0UQyNkkjW1XYvBmgAXKIMNK4
 HUTYWrNphngocXw+g5WSAN3blUVG4SRK/GOZ1gstMo4GM8RHzi+F6BWGm67ZuNY6lubq
 tP6zlKbL8jorR6bNLrO3wq0LZPuDLWOgObxgm6qD4CMOuwGYUbIE88qhCbRwtqRv3V2C
 OPTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=jgCIrvyj0IDci5P6m/g4M7I9DXQORNjMkIRBxaHCRXY=;
 b=yCbbulNlk+DDuAehVbjErI0M2E+WWezrnQcy2uEM8tEj3g6hJwy2GpjO55+m/Ds3a9
 7tQbFUVin6YyrIgVxrTEy0OaOJg6PBaAwgUYlgitIC5NLNTPqzKkGK5GJV8EVEej37++
 s1eqFrEALl/83hrM6Lu7sY+xB1qiGgD37FhM/CZx3RXFuULjTBoYKotp+5T/FSVzQI5L
 nBy6F542uK4V8WX/22CvT+zLuw/8onG2AuaT7PudIMCFsLdjIolV+xgaLxHHe8rz8myy
 7z40UikIounyulr+rAlCji3gNg9QBKAANR2ArN7ra8GaiFgs8xgWvSQi3khOvK6n1BCj
 V9tg==
X-Gm-Message-State: ACrzQf1NkR+0PYjfvkbciFGyhYu8mPLHYrh5DigzQSA0O8j6KLsOZlKr
 q1/h91USbBZGwzCCktJ8Nb8137Z4bB47WA==
X-Google-Smtp-Source: AMsMyM5gN6HolrDQXK8DQ3qq5P69fItYC8UeUiEblU9Fno7u5E4vwNaG4hNg/nv1vmJNSfk9bS6oI/cvGWAmIQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6870:525:b0:130:9e35:137a with SMTP
 id j37-20020a056870052500b001309e35137amr6295123oao.88.1666036723631; Mon, 17
 Oct 2022 12:58:43 -0700 (PDT)
Date: Mon, 17 Oct 2022 19:58:24 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-5-ricarkol@google.com>
Subject: [PATCH v10 04/14] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 andrew.jones@linux.dev
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
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
