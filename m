Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCDBC32793
	for <kvmarm@archiver.kernel.org>; Tue, 23 Aug 2022 23:47:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC3F84C60D;
	Tue, 23 Aug 2022 19:47:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ReW4yr8CsijZ; Tue, 23 Aug 2022 19:47:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBC934C5D1;
	Tue, 23 Aug 2022 19:47:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51F4D4C54A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iT5GYlMg9+d4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 Aug 2022 19:47:40 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D11954C5CB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 19:47:39 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3328a211611so261915777b3.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 Aug 2022 16:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=YtZTa0HE8S58eOAg9Dki1hh4yfD5zzqoGg9fbalm1X0=;
 b=V7nf30q7SHKk4vJWTYplWPzKY30iQ/kQ8R3HQhGXCGNDsYOHslr3NLM6j44R5+F/p7
 MgFjfIPHt9UazXQKNphIWTVuY4v6bvZdmpi4GqV2WC9uI6EAgwOW+MfhkjNd+vtCcxCq
 Lik8kC+x+HnYhu7/55BiVrsXAIBuTlGXVa6nB9nGRztK/WWQLp13+eNXrXQBaxt8S3zk
 avUxVcSntEaooUosGdvpordA2/d6965cUhn/UqnfSrNDQ6Atlh7gF4t9cup4XMH1XbZf
 ulVMnGgG54Sba7Z7MLHA9EA3NcEHgImRNE0AjIAdCJ/e9jqDULJj03t863mNSvxWZvyL
 QyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=YtZTa0HE8S58eOAg9Dki1hh4yfD5zzqoGg9fbalm1X0=;
 b=xpPkxL6R7psZCG2brGtx9zesRCR21JKt3yYpavMuUH81F6w9ed7t5Et+NpK7arhfpc
 5KvpjvszKisQvZAZ73Gcc98P06B1tO27tAfGVo4uXlOkNx/o9hApYcWfNj5Pq/VygcBX
 PwDD/0I0sDrga3OjVWDraLcXXunG0pzjbLdOHvsn222sdWtwhzFSlimrO0iCpq88hzZx
 EOsXUlEWdPNa0X2iSIWblL/g3PjHwVwcWFJEsSCPmT0Sv7z6i5dHmwC4Fyjln8kz+wsg
 x1zkdBoL02LUDpqdtCcn4Z/gm3PxjOGdUwIpKNolXmX3hK0cuueMJCtqqiE6Fp8uVM63
 VXMA==
X-Gm-Message-State: ACgBeo2/sfnUkWXYiv4Hf4JoN176KFMRPopCOwCkA0X3cGv429LIfaHQ
 B+wEeOfiQD3698+7EQwvQ+9pkDMfkJnLgw==
X-Google-Smtp-Source: AA6agR6w6gd89wtCBmNf5J0KCa9rpntnN/mVGcLeN65rTEHCvKB+jgvdXirEG7qVr/sXmW5OmDMXkTODutzY8Q==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:128c:0:b0:334:5b68:48a3 with SMTP id
 134-20020a81128c000000b003345b6848a3mr29288586yws.428.1661298459467; Tue, 23
 Aug 2022 16:47:39 -0700 (PDT)
Date: Tue, 23 Aug 2022 23:47:18 +0000
In-Reply-To: <20220823234727.621535-1-ricarkol@google.com>
Message-Id: <20220823234727.621535-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220823234727.621535-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v5 04/13] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: dmatclack@google.com, maz@kernel.org, bgardon@google.com,
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
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
