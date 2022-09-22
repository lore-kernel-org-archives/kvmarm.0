Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E728C32771
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 03:19:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85E754B1C6;
	Wed, 21 Sep 2022 23:19:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9XOWAhUY1CWP; Wed, 21 Sep 2022 23:19:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A59E04B645;
	Wed, 21 Sep 2022 23:19:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 847C940B90
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 23:19:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X+eZpWhLveFX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2022 23:19:08 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9272A4B1C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 23:19:06 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-349f88710b2so67968647b3.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 20:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date;
 bh=tN5R5SopzaHGArjvbV8A2BOgjZV2vImyuFPHiE9aLpQ=;
 b=F3bSBt1mXoBPajVvYMos+K94ptUrfcP4FWvHQiN0vHTDk8pYY340hBvmInSWC0ntNX
 1EpkU+4Y4eyjAQyOrGF2iBeyaPoIgRr/G282HQH+3dF67nMELaO1MM9TWfduo7ro8XL6
 km8cY3+M9ENDKoaPVxdkOIRTCbQZ+Wm+VcIeXA4leEMRnV6xfLU5m1+CX9O6x7+ogWJR
 cnkIDbK8/WIZ8JsvyGUDn4BV/03M1eCPV7GHNwebdvyv1hJoBlcLVn3LWKxQNZ4jdLqw
 2h5O/ZOP7oKp/1ZMM/os+zpnZdnhdZdtgfua9eAH5nzktAjSjxDgjcuJKQtwaPqZ0vkB
 Vxbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date;
 bh=tN5R5SopzaHGArjvbV8A2BOgjZV2vImyuFPHiE9aLpQ=;
 b=ITQxKyCuV3aoN6z44xm6HrJx46Q9wt1H5Njo8edE+nzeEivDkfVfCna+4Rmpupr/Ro
 3kol9cN3yXvYrPXg6XgxVhN4sXyMIpmQiR9NWcHQoRvpXS33gAW0h42ll0ZtFJEBKnzk
 tBS5Qsb52AHJtoWIOR08aQY2lYc+8hZtU+suxg6gj+uMF77ASafQyoiMAa+3spz9yb5R
 jnaproje+pj99sWa0UTB+00mkyu89pSPwpwOSUT5yWeqxaCJ5QEUjcILPLmsrg2LSSZ1
 eZXSsouvaTk5sZbLX3lHM+/VWc1XypLezU9+crhkPOKMi6npUlSsY2vIsyOgxsDUVSMM
 G0OA==
X-Gm-Message-State: ACrzQf0jsQBh77n/7nZC9atKGJ7fMrsQhixTVyhVQIHsDV9vUkc+VjqA
 Ky+brCLOmpjYwVE20TUxFmwyE05Updq8Jw==
X-Google-Smtp-Source: AMsMyM4Mc1QJGVbsNnZ9OIYOMXXEL+AsNyytFGwL2Buust7Yvgrdi2fjgrKIfN1139XADivytE7pvuCEAICzyQ==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:5cd:0:b0:6ae:a4be:ab42 with SMTP id
 196-20020a2505cd000000b006aea4beab42mr1516140ybf.323.1663816746060; Wed, 21
 Sep 2022 20:19:06 -0700 (PDT)
Date: Thu, 22 Sep 2022 03:18:47 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-5-ricarkol@google.com>
Subject: [PATCH v8 04/14] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
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
