Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com [209.85.160.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C3715AD
	for <kvmarm@lists.linux.dev>; Wed, 15 Feb 2023 01:16:35 +0000 (UTC)
Received: by mail-qt1-f201.google.com with SMTP id s4-20020ac85284000000b003b849aa2cd6so10321725qtn.15
        for <kvmarm@lists.linux.dev>; Tue, 14 Feb 2023 17:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPrYycs38Jm3Sq3undZq9ttXoskj6Xab1yQZ0uAvcW8=;
        b=nT5UvRV+bdXTY47eDM312ZUnHfNlWrwBJx6pdwuGEIubphNFZSWnMXxcpXFhQpNXYh
         F8TnEG1zuWzDqzduwqwOrXyGlqCFCkM98iRpeBU1tcpHvFAk4+JIxRxdH+TKZmx8h/lO
         Bqm9+nSVsOmUHwl0qdzxKY2MrmCICC2ZmEOhcHWcESFpdcAQrCCKl3VAR52ACOxfx1Cl
         4HRdc0oHWA+SMUEa7WpQaDAh7TbB/N+cvqRF5mGV8aRafe2Xo6dzwFGqvQm1cPXymb1X
         hq3qSrSQJEV5pufNUG/jT2SMrTDNz0J9Fi6QrMD2x1izAiSkB53PtmoiGLWVTEPCWm/j
         mg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPrYycs38Jm3Sq3undZq9ttXoskj6Xab1yQZ0uAvcW8=;
        b=FmSoRvk6MRQLzytONen5UWk+36HWb/Ai2wFjwp56nV6vG2RdEB67DhnDepIpmld7d8
         Oy2SMy5gx57a4Lc7Pps/DhT1gPj9S39S6OwSW3AodF43vGVM3vB2hI/3UsF0Kcgfmm2x
         cqGHrtm6hVSiYAw7Qo458sUlNyFzZF7HcuRmGPGLJ8zTdhbJ6SngO7Gp+FJ3dTSH/Vew
         pQvmdQ4P3G9dCg80TEI+BVHzEmCTlUBvqsRjXQLJxY7AHLkWHaFnUCsJ7iySO5EcMA2E
         09c//OrpJFYKNCI7r4tSgBWSqcs+MPsoXdsXt8JhgTCuvaHenDFgDJXltbZ/s3TiTlFZ
         8zMw==
X-Gm-Message-State: AO0yUKUczIAQR4RnWLlVpDNnp3mgnTUKtNud75YljuYGxxRyo4r+pDse
	uizZiE/Pp8PwT37mYYZEWdJRyylJZDuOxA==
X-Google-Smtp-Source: AK7set8OIyhmpWoTab6NgRcquwz3ebP9gVLRLX3gqnZH2lhB8uDvbbDq1XcJNQVsOeixNwKTxn++WoFJjfzvCQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:ac8:498d:0:b0:3b7:fda5:14ba with SMTP id
 f13-20020ac8498d000000b003b7fda514bamr9963qtq.12.1676423794603; Tue, 14 Feb
 2023 17:16:34 -0800 (PST)
Date: Wed, 15 Feb 2023 01:16:10 +0000
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-5-amoorthy@google.com>
Subject: [PATCH 4/8] kvm: Allow hva_pfn_fast to resolve read-only faults.
From: Anish Moorthy <amoorthy@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>, Anish Moorthy <amoorthy@google.com>, 
	Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The upcoming mem_fault_nowait commits will make it so that, when the
relevant cap is enabled, hva_to_pfn will return after calling
hva_to_pfn_fast without ever attempting to pin memory via
hva_to_pfn_slow.

hva_to_pfn_fast currently just fails for read-only faults. However,
there doesn't seem to be a reason that we can't just try pinning the
page without FOLL_WRITE instead of immediately falling back to slow-GUP.
This commit implements that behavior.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331e..dae5f48151032 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2479,7 +2479,7 @@ static inline int check_user_page_hwpoison(unsigned long addr)
 }
 
 /*
- * The fast path to get the writable pfn which will be stored in @pfn,
+ * The fast path to get the pfn which will be stored in @pfn,
  * true indicates success, otherwise false is returned.  It's also the
  * only part that runs if we can in atomic context.
  */
@@ -2487,16 +2487,18 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
 			    bool *writable, kvm_pfn_t *pfn)
 {
 	struct page *page[1];
+	bool found_by_fast_gup =
+		get_user_page_fast_only(
+			addr,
+			/*
+			 * Fast pin a writable pfn only if it is a write fault request
+			 * or the caller allows to map a writable pfn for a read fault
+			 * request.
+			 */
+			(write_fault || writable) ? FOLL_WRITE : 0,
+			page);
 
-	/*
-	 * Fast pin a writable pfn only if it is a write fault request
-	 * or the caller allows to map a writable pfn for a read fault
-	 * request.
-	 */
-	if (!(write_fault || writable))
-		return false;
-
-	if (get_user_page_fast_only(addr, FOLL_WRITE, page)) {
+	if (found_by_fast_gup) {
 		*pfn = page_to_pfn(page[0]);
 
 		if (writable)
-- 
2.39.1.581.gbfd45094c4-goog

