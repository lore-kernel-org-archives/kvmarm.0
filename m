Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.241
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580840;
	b=ZpZLerBJ4p5UWZa4+jN4kCLVhURAYGh0mblbcH1M1mk9DAurhjg5Dm7s97+4el7TXfyp
	 vQhuaDaEcIgbI8HtcFYyd+Gi/ofUFFfTQ3Yi0fucibHhTrn4nG9QBpSL2u0j4KrwZc8+i
	 WvCM8UChiaUSdZprscF6PvY+3qYGWSgWeBeuFcY7IMp+FOdPu9FnDqhN4m/i8Tw8DtjxC
	 VeKBHbdXLAHhInYeCXNK+JCSARVBpeweSMZUftyZp8/m0VWXPZ9rTUkXxvd3lTEzrs5T+
	 3ZXMmQjIhsRhaV8a2YTCItZhciSQBEIM5/du8+1B1PUvfAfuCBGkKkwh3dPnfYNu7lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580840;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aMikreozefWP0A1pDF6mPPOuxdBSRCIA1RsbQnpSxVk=;
	b=xssZVVBqq9KWGrTqYjCgPuy83MtFIzkDi62kSt+9iuw3nY/9TjOD1rypolOGSJbpRL7v
	 iyyEg7NgUQ1oWiMuBJ+NoEILCWNfRhDInZ8cUVq/ZIRwVEZP4wBY0mfLTnj3+cH/ozlTS
	 lEX2IAOsH39UDmI3fLD0zKFoYX3EK72W7t5CoCRtMRDdXorcginrq6UQt4iFq7xKmU6TB
	 Cl3mT0UG5afzT/bfFpOcxCHTPf0YIx/xGa0RmjBihwxPxZmPsl3bvzds6mCtpOahxUQ1n
	 DdmmzhaKsUHehv7XRZy6qP+s2iVkuX1vfcVLiQmIaXsOvXDFVoraZ+v4gqkV9eTGQ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WWGu0TAH;
	arc=none smtp.remote-ip=95.215.58.241
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADE3606A33F
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 11:07:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7ADE3606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WWGu0TAH
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CFC+EpkLs8GV2o/35gbFX0OJWtbLR8uwfWhMsdHJKjw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792580837; v=1; x=1793185637;
 b=WWGu0TAHYBStBTe0fKymiemcvwQ8nkXduNeNineIWMwacZcDuT2uZxjBeMbUhV+EP1Vh0ynP
 kCfjv4lbYhRu5+9H88jDl84U9LHiHB5uOaTxas+SMhxc83OtxmAIvjfczdz/2pHZk1yLtikbHiK
 +ZcZlxSxSk0okXj7yjpK5Ecc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 203429e2f75eaf6d;
	Wed, 21 Oct 2026 11:07:17 +0000
X-Mizu-Trace-ID: 203429e2f75eaf6d
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Steven Price <steven.price@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] arm64: mte: Add mte_clear_folio_tags()
Date: Wed, 21 Oct 2026 12:07:00 +0100
Message-ID: <20261021110700.493315-5-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261021110700.493315-1-fuad.tabba@linux.dev>
References: <20261021110700.493315-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mte_sync_tags(), sanitise_mte_tags() and kvm_vm_ioctl_mte_copy_tags()
each open-code the loop that clears the tags of every page in a hugetlb
folio. Add mte_clear_folio_tags() and use it in all three.
kvm_vm_ioctl_mte_copy_tags() then tests for hugetlb first, as it does
where it sets the tagged flag below.

No functional change intended.

Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/mte.h |  4 ++++
 arch/arm64/kernel/mte.c      | 15 ++++++++++-----
 arch/arm64/kvm/guest.c       | 10 +++++-----
 arch/arm64/kvm/mmu.c         |  3 +--
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 7f7b97e099968..5a2d2814c0416 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -96,6 +96,7 @@ static inline bool try_page_mte_tagging(struct page *page)
 }
 
 void mte_zero_clear_page_tags(void *addr);
+void mte_clear_folio_tags(struct folio *folio);
 void mte_sync_tags(pte_t pte, unsigned int nr_pages);
 void mte_copy_page_tags(void *kto, const void *kfrom);
 void mte_thread_init_user(void);
@@ -128,6 +129,9 @@ static inline bool try_page_mte_tagging(struct page *page)
 static inline void mte_zero_clear_page_tags(void *addr)
 {
 }
+static inline void mte_clear_folio_tags(struct folio *folio)
+{
+}
 static inline void mte_sync_tags(pte_t pte, unsigned int nr_pages)
 {
 }
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 1a9aad6ef22a0..fb2598f8c0ccd 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -36,6 +36,14 @@ DEFINE_STATIC_KEY_FALSE(mte_async_or_asymm_mode);
 EXPORT_SYMBOL_GPL(mte_async_or_asymm_mode);
 #endif
 
+void mte_clear_folio_tags(struct folio *folio)
+{
+	unsigned long i;
+
+	for (i = 0; i < folio_nr_pages(folio); i++)
+		mte_clear_page_tags(page_address(folio_page(folio, i)));
+}
+
 void mte_sync_tags(pte_t pte, unsigned int nr_pages)
 {
 	struct page *page = pte_page(pte);
@@ -43,12 +51,9 @@ void mte_sync_tags(pte_t pte, unsigned int nr_pages)
 	unsigned long i;
 
 	if (folio_test_hugetlb(folio)) {
-		unsigned long nr = folio_nr_pages(folio);
-
-		/* Hugetlb MTE flags are set for head page only */
+		/* A hugetlb folio is marked tagged as a whole, so clear every page */
 		if (folio_try_hugetlb_mte_tagging(folio)) {
-			for (i = 0; i < nr; i++, page++)
-				mte_clear_page_tags(page_address(page));
+			mte_clear_folio_tags(folio);
 			folio_set_hugetlb_mte_tagged(folio);
 		}
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index cda655fbff657..c75466384f8ac 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1012,7 +1012,6 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 		void *maddr;
 		unsigned long num_tags;
 		struct folio *folio;
-		unsigned long i;
 
 		if (!page) {
 			ret = -EFAULT;
@@ -1046,11 +1045,12 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			 * tags. A hugetlb folio is marked tagged as a whole,
 			 * so its first tagging clears every page.
 			 */
-			if (!folio_test_hugetlb(folio))
+			if (folio_test_hugetlb(folio)) {
+				if (folio_try_hugetlb_mte_tagging(folio))
+					mte_clear_folio_tags(folio);
+			} else {
 				try_page_mte_tagging(page);
-			else if (folio_try_hugetlb_mte_tagging(folio))
-				for (i = 0; i < folio_nr_pages(folio); i++)
-					mte_clear_page_tags(page_address(folio_page(folio, i)));
+			}
 			num_tags = mte_copy_tags_from_user(maddr, tags,
 							MTE_GRANULES_PER_PAGE);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6e10aa9913d71..f8139c0a54deb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1514,8 +1514,7 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	if (folio_test_hugetlb(folio)) {
 		/* A hugetlb folio is marked tagged as a whole, so clear every page */
 		if (folio_try_hugetlb_mte_tagging(folio)) {
-			for (i = 0; i < folio_nr_pages(folio); i++)
-				mte_clear_page_tags(page_address(folio_page(folio, i)));
+			mte_clear_folio_tags(folio);
 			folio_set_hugetlb_mte_tagged(folio);
 		}
 		return;
-- 
2.47.3

