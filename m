Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A8A15B7
	for <kvmarm@lists.linux.dev>; Tue, 11 Oct 2022 01:06:42 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-355bdeba45bso119017537b3.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Oct 2022 18:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G5HDQ76XxR6LhG5G7Q04ltrToK8CzPidrVSTTOm2giM=;
        b=nEWlcyrt0nCFF41on5PLOyPT5ANVJAvY+BjoFq/+7B2SzlritkipQ+XdyBTDhnRHnN
         x0tFVJ5Udv+ogPw0pEKe1KuwBqESCRATne5McvPB47ZcJhNcYP8QnHySc2EeCBgvgFZf
         ekGVGVtY/xHmML54ErAJ6FwC9orIeCyxMNEpdEWgdFIC7FHCu5JYWBUMMW4+DEJURrQe
         pZAFDx9fa92bldqRvCeZHk2pkstoSR5GJ8aLyx3xePRAfm0UxaC8fkj9h1hU7um/oLBf
         sICdhq5q5xERyorGhSiO1kQwtpbnX5UTKt7HvgQKrIEzCSsXSTIwO3in5vU+VRymHYGY
         fxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5HDQ76XxR6LhG5G7Q04ltrToK8CzPidrVSTTOm2giM=;
        b=Q/BGkoSa2u+hc0k8LF/u221DtIh9o3n2OBb//gCHwCGl0KzZM3U4jJ2nxm1o+UitXV
         lMDH+uMupqlVmajcSnVOOwUOES4eFEx6Qr/7PLue6I0fdJlGvJg6WK6wLmxx7wMmS+v0
         MIgK/RnQYKecUI91hcdsqVwbPpwUkWU65p+lcg2ksEySLoHyK6O9USoPx+oknyjlH51X
         cG6EDHloUJtsqpdk6EX+AEtTD/+pgc23S2XI42z8cLx/C4XkoMPd1GxL5I4ivXe3tvUR
         0rgsjiUU03g8MUZWBnc/vGIgeUQSf4VhvFcELVNEO8SbT1g9rnF3ZPJyqnMzp2EcXax8
         pWEA==
X-Gm-Message-State: ACrzQf1XbNYY8YS0uSPGlVgCVXraSQnIrGn5SiAxH61JLOUSJTgS/IWI
	zN6ztSmJA1QNmdMO77HlfaBTOEl2HXIj0w==
X-Google-Smtp-Source: AMsMyM4vh+AzTn/oWIaOk0oo483LBa9Y4ObtOhRbF9XhamGnuxyJwOjF5KJtpTGc8cl+K/YMmG/YwrzL9cF2OQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:c285:0:b0:354:deb2:1aaa with SMTP id
 e127-20020a0dc285000000b00354deb21aaamr19074489ywd.4.1665450401600; Mon, 10
 Oct 2022 18:06:41 -0700 (PDT)
Date: Tue, 11 Oct 2022 01:06:18 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-5-ricarkol@google.com>
Subject: [PATCH v9 04/14] KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1
 using sysreg.h macros
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, seanjc@google.com, 
	alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221011010618.mCvlVad1oTFdlm1vYePvIQ-IbRPlPft4rMNY7YMYCVU@z>

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
2.38.0.rc1.362.ged0d419d3c-goog

