Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7EDC6FA82
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 04:15:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BD904B6B9;
	Tue, 20 Sep 2022 00:15:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uRp0PafJBS3N; Tue, 20 Sep 2022 00:15:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 135BF4B70F;
	Tue, 20 Sep 2022 00:15:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E7404B629
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 793MZrQym9AL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 00:15:20 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1800A4B62A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 00:15:19 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 k14-20020a25e80e000000b006aa1160dfe3so1097042ybd.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 21:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=tN5R5SopzaHGArjvbV8A2BOgjZV2vImyuFPHiE9aLpQ=;
 b=OD3j4c/XoEVXRO9oLsaY42jyUA2VwddvzESrRdjWxgKGPxEpd2qlVSViY5f6ixALw9
 5ouok9TQns81DIsyKfG1YzqhyLnsHu7V56IQC8CqHw28aDN7IL+n5oeKBoQ7RhAB2Knl
 uFMjKvpl+Fahi3gAJOyKipMxZkWbvAH/znpWa+AnVUjy602GLU/pQ1/aoiwuda6PgnCj
 zP3jMqcXsWFB9aejNKEFkR+V/seL7qIr0Ow9wNIVHUwxd0HhsOInF5iLJlhVXS+goNms
 7TQkqlCECTYjZqKNoTKqm8CbR1Z2VU8PoJDL679W17HQJO10AJmkse3KNqq+xOpowTml
 f8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=tN5R5SopzaHGArjvbV8A2BOgjZV2vImyuFPHiE9aLpQ=;
 b=fKa8srd5r5mYtYEW0asXSw0Axjs2XK3KUgO7pb2bDLuQ1RIemNRyddXqRrXs//Btpc
 gxOGnQvruja/yLR5CbqY0QZ+hZnbijLki59XHwXA0DvbsKtE1/etVNAZ2RFqXHnjEfpU
 3fnQzxfwgQVmyblrmKZC/WEZKokZzbLn7dgnQCGw3mAtHEnkSdjdggdn+yn9DFwG4iKa
 bB2qa8J8x9ZeXqRphf0q+WnYAVyxpkyHQvyIkzaqXwxsTxzMsISalGSIATdPiM3X60ie
 m7HTj3qWO7bAok2mvHwvYuQUEqH0VJDV8b0ajB4CJzZN9XeAKvs/pSbaiupxambiw/aw
 o5Gw==
X-Gm-Message-State: ACrzQf0CsyLeQpeR0zfGEz/rBT2NBC/zeyllOCskcLReCjt41fhzx/iW
 wbTpwyWdugL2Sxv1C4jsx+cUU+Yxa5a5gw==
X-Google-Smtp-Source: AMsMyM4EHHeL483VfBA/mBkUN2XhgWB7wXX9kQQujXR7L0SZ3JPXSogQMzX2W6u3RS05ur7mfikXosglo0XPLg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:b09:0:b0:345:30d:77b7 with SMTP id
 9-20020a810b09000000b00345030d77b7mr17479125ywl.177.1663647318653; Mon, 19
 Sep 2022 21:15:18 -0700 (PDT)
Date: Tue, 20 Sep 2022 04:15:00 +0000
In-Reply-To: <20220920041509.3131141-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220920041509.3131141-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920041509.3131141-5-ricarkol@google.com>
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
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
