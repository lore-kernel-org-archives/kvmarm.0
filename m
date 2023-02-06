Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6374553BA
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 17:23:49 +0000 (UTC)
Received: by mail-il1-f201.google.com with SMTP id s12-20020a056e021a0c00b0030efd0ed890so8432530ild.7
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 09:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I0XHQF3wFWbgtteCR59qm3StUISJj2Yko9/2XqErnNg=;
        b=btBNnRAc7wt8tsxJP6uN/M06/M4SZpYblnw+qwfYZIv4gmJghOeEjTTGvl1OYIjkLo
         L0Vv/dmjv0BXJhLWNtoBkowsRGyLx4mp0h236DEdiO5EXrxLJpYaTZNQuhTBbegOowqw
         sb07mVRDbB4SVcO7OS1hJXB0TGRelTjis2Dg5znefWhQ4ZND6zFSPIrxYyYlH1rTgFCR
         MLOL/lmwOkKjSfqRHATn0fVd4ZoN43BY0xulwCjz5tbZ6FMq+oEQd2YQ8f8PAoOPJXgb
         ATmp1ZNZ+umx3GhBRv1/EW67B4E17tXTOnwa0XbznyawTlp2k+lbjt04lK/yQfLz81le
         SJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I0XHQF3wFWbgtteCR59qm3StUISJj2Yko9/2XqErnNg=;
        b=MvJ1uGM51BMpaQIXAkjxkaLqNY0Jwy326WyZcq8atUKCV/lOckBNdo8H2GTySPPzZ8
         Etddv4vuvT19e3qtn//AAFN6EGmQrV4pAnPF1iRUcoasK+pK/UdcMUFAjq+3YskN6a56
         aQrQKhiEmreyXl1TA5VcuhKOlWDgzLqduel1ptZRuA42iEsk1emSOOWn39nHJtwvxmL0
         D9tAjUfhV2+wQ1b7EFQMefBaKO+034Wk3lpHxbg4d24j3Lxy/ZvitR3KSUFt8I5vjhVZ
         sxCCF1E5rP3cfhupRY2YQes2QHmx+1RXM7pv5cczp6IOppbDNTWn/zFQkpX2GHcLSMI7
         k7iQ==
X-Gm-Message-State: AO0yUKWYXnOJqKaid6uC2SOGWoqJluwxH9brDTSFhJaBwV/BbzRyyBNz
	DwDkdkrIoQKgJsX+gMmvxZTPn+YfiKsm
X-Google-Smtp-Source: AK7set8m5os9pgRD9ZWypJHZlTWrqpUxhtGI32tM5bufh7Y7K68C5uAYXAjJ3KtZhwMvtEjkQXo+9+T6t238
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:6638:61b:b0:3a1:336:ad86 with SMTP id
 g27-20020a056638061b00b003a10336ad86mr9641jar.119.1675704228432; Mon, 06 Feb
 2023 09:23:48 -0800 (PST)
Date: Mon,  6 Feb 2023 17:23:34 +0000
In-Reply-To: <20230206172340.2639971-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206172340.2639971-2-rananta@google.com>
Subject: [PATCH v2 1/7] arm64: tlb: Refactor the core flush algorithm of __flush_tlb_range
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Ricardo Koller <ricarkol@google.com>, Reiji Watanabe <reijiw@google.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Currently, the core TLB flush functionality of __flush_tlb_range()
hardcodes vae1is (and variants) for the flush operation. In the
upcoming patches, the KVM code reuses this core algorithm with
ipas2e1is for range based TLB invalidations based on the IPA.
Hence, extract the core flush functionality of __flush_tlb_range()
into its own macro that accepts an 'op' argument to pass any
TLBI operation, such that other callers (KVM) can benefit.

No functional changes intended.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/asm/tlbflush.h | 107 +++++++++++++++---------------
 1 file changed, 54 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 412a3b9a3c25d..9a57eae14e576 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -278,14 +278,60 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
  */
 #define MAX_TLBI_OPS	PTRS_PER_PTE
 
+/* When the CPU does not support TLB range operations, flush the TLB
+ * entries one by one at the granularity of 'stride'. If the TLB
+ * range ops are supported, then:
+ *
+ * 1. If 'pages' is odd, flush the first page through non-range
+ *    operations;
+ *
+ * 2. For remaining pages: the minimum range granularity is decided
+ *    by 'scale', so multiple range TLBI operations may be required.
+ *    Start from scale = 0, flush the corresponding number of pages
+ *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
+ *    until no pages left.
+ *
+ * Note that certain ranges can be represented by either num = 31 and
+ * scale or num = 0 and scale + 1. The loop below favours the latter
+ * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
+ */
+#define __flush_tlb_range_op(op, start, pages, stride, asid, tlb_level, tlbi_user) do {	\
+	int num = 0;										\
+	int scale = 0;										\
+	unsigned long addr;									\
+												\
+	while (pages > 0) {									\
+		if (!system_supports_tlb_range() ||						\
+		    pages % 2 == 1) {								\
+			addr = __TLBI_VADDR(start, asid);					\
+			__tlbi_level(op, addr, tlb_level);					\
+			if (tlbi_user)								\
+				__tlbi_user_level(op, addr, tlb_level);				\
+			start += stride;							\
+			pages -= stride >> PAGE_SHIFT;						\
+			continue;								\
+		}										\
+												\
+		num = __TLBI_RANGE_NUM(pages, scale);						\
+		if (num >= 0) {									\
+			addr = __TLBI_VADDR_RANGE(start, asid, scale,				\
+						  num, tlb_level);				\
+			__tlbi(r##op, addr);							\
+			if (tlbi_user)								\
+				__tlbi_user(r##op, addr);					\
+			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT;			\
+			pages -= __TLBI_RANGE_PAGES(num, scale);				\
+		}										\
+		scale++;									\
+	}											\
+} while (0)
+
 static inline void __flush_tlb_range(struct vm_area_struct *vma,
 				     unsigned long start, unsigned long end,
 				     unsigned long stride, bool last_level,
 				     int tlb_level)
 {
-	int num = 0;
-	int scale = 0;
-	unsigned long asid, addr, pages;
+	unsigned long asid, pages;
 
 	start = round_down(start, stride);
 	end = round_up(end, stride);
@@ -307,56 +353,11 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 	dsb(ishst);
 	asid = ASID(vma->vm_mm);
 
-	/*
-	 * When the CPU does not support TLB range operations, flush the TLB
-	 * entries one by one at the granularity of 'stride'. If the TLB
-	 * range ops are supported, then:
-	 *
-	 * 1. If 'pages' is odd, flush the first page through non-range
-	 *    operations;
-	 *
-	 * 2. For remaining pages: the minimum range granularity is decided
-	 *    by 'scale', so multiple range TLBI operations may be required.
-	 *    Start from scale = 0, flush the corresponding number of pages
-	 *    ((num+1)*2^(5*scale+1) starting from 'addr'), then increase it
-	 *    until no pages left.
-	 *
-	 * Note that certain ranges can be represented by either num = 31 and
-	 * scale or num = 0 and scale + 1. The loop below favours the latter
-	 * since num is limited to 30 by the __TLBI_RANGE_NUM() macro.
-	 */
-	while (pages > 0) {
-		if (!system_supports_tlb_range() ||
-		    pages % 2 == 1) {
-			addr = __TLBI_VADDR(start, asid);
-			if (last_level) {
-				__tlbi_level(vale1is, addr, tlb_level);
-				__tlbi_user_level(vale1is, addr, tlb_level);
-			} else {
-				__tlbi_level(vae1is, addr, tlb_level);
-				__tlbi_user_level(vae1is, addr, tlb_level);
-			}
-			start += stride;
-			pages -= stride >> PAGE_SHIFT;
-			continue;
-		}
-
-		num = __TLBI_RANGE_NUM(pages, scale);
-		if (num >= 0) {
-			addr = __TLBI_VADDR_RANGE(start, asid, scale,
-						  num, tlb_level);
-			if (last_level) {
-				__tlbi(rvale1is, addr);
-				__tlbi_user(rvale1is, addr);
-			} else {
-				__tlbi(rvae1is, addr);
-				__tlbi_user(rvae1is, addr);
-			}
-			start += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT;
-			pages -= __TLBI_RANGE_PAGES(num, scale);
-		}
-		scale++;
-	}
+	if (last_level)
+		__flush_tlb_range_op(vale1is, start, pages, stride, asid, tlb_level, true);
+	else
+		__flush_tlb_range_op(vae1is, start, pages, stride, asid, tlb_level, true);
+
 	dsb(ish);
 }
 
-- 
2.39.1.519.gcb327c4b5f-goog

