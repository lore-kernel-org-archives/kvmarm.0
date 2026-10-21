Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580834;
	b=AJMrgn5ycZpkyPC09HbzR911Dh8JatKh6MYDQUmk2dMCrN335zIKq2bVvVFjDQtCNuLQ
	 0vlsVBz3Hxu+iIQMZhuQ6/EdhNBjqo+vizgkiK1UIRbK9zRP6iG6NRNVUYJNZX2ld+rKi
	 5wl4ylyqROIfpULLr/7AZG+MvSkU+RBIDYhTl0v3bliJ0dBaTesUYGhBsiQ9G//lJOgBN
	 sXVRTmM49nPUkeZeWnycgqBPS649y3cLO0AGI7rfKbFhS0AEUPjo503F+7G//X6KnwiTm
	 F5SycLxL8uLUzQeLVMeoRhy2kuYA38e63SLJleKsDEzbdEpiIGF9UiWTXU+9KxPuDAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580834;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=U/Sb0nePo52l0p+fSi/XZuFjwRAlWL1aHJZwdIky6to=;
	b=Spa0W8svK+fwUp9Mjj0nkZ/OfrBzWl2ejHyPPSyn9SDA9ifSuTKkUb2GJrNo930zu0+2
	 8OENuERmYruVwA9YboOzZpiAhSM1wEyrX2oeFAoPE0zQEubclI80BOJTfXBVCDg5btgUa
	 iDcVbkn/bi2kMMcZXzNj0kAuy1iq3gZL1ErKnXpM2xSLJ5zmZKsKm1ZrAyTFDCslcqKkj
	 YeNcI0aC7YglzcNitgSn4lwnDhoW3I609j78QfW/yM1stun37vtCeEZKfThpzQGvs3mNH
	 2yG0eCnd7nVPUWsRyzfxBLqHU4P5RcHkc1ydIn2OZSQ+07e7BkBrz2imIjiWV99SwXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sciekYSj;
	arc=none smtp.remote-ip=95.215.58.233
Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45638606A327
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 11:07:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45638606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sciekYSj
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=crnCwJrJSeAJKv/UwSU/fESmAVujZiBl8NwghS4U/as=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792580831; v=1; x=1793185631;
 b=sciekYSjR18yZi0uEjdtijIOzXM8G31v9lxfN9fih2idqe51jbojFfQXwwBjq3wscXC62dHA
 Zn5HrBdrRLc/hEd/tcwmyH0KfgRqbOKVmZ6+2HsyZYCivalQ0GhMt+YbMoobFH4RSvQhR/k1uu7
 FqO8l0xaYQnURiWczo+OOM7g=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5b317a989263a742;
	Wed, 21 Oct 2026 11:07:11 +0000
X-Mizu-Trace-ID: 5b317a989263a742
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
Subject: [PATCH v2 2/4] KVM: arm64: Clear the whole hugetlb folio when storing MTE tags
Date: Wed, 21 Oct 2026 12:06:58 +0100
Message-ID: <20261021110700.493315-3-fuad.tabba@linux.dev>
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

When KVM_ARM_MTE_COPY_TAGS copies tags into a page, it marks the page as
tagged. For a hugetlb folio the flag covers every page in the folio. If
the folio wasn't tagged yet, its other pages are marked as tagged with
their previous owner's tags still in place. The stage-2 fault path then
maps them into the guest without clearing them. The ioctl's read side
also copies them out to the VMM.

Clear the whole folio on its first tagging, before copying in this
page's tags.

Fixes: 25c17c4b55def ("hugetlb: arm64: add mte support")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/guest.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index b01d6622b8720..cda655fbff657 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1012,6 +1012,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 		void *maddr;
 		unsigned long num_tags;
 		struct folio *folio;
+		unsigned long i;
 
 		if (!page) {
 			ret = -EFAULT;
@@ -1042,12 +1043,14 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			/*
 			 * Only locking to serialise with a concurrent
 			 * __set_ptes() in the VMM but still overriding the
-			 * tags, hence ignoring the return value.
+			 * tags. A hugetlb folio is marked tagged as a whole,
+			 * so its first tagging clears every page.
 			 */
-			if (folio_test_hugetlb(folio))
-				folio_try_hugetlb_mte_tagging(folio);
-			else
+			if (!folio_test_hugetlb(folio))
 				try_page_mte_tagging(page);
+			else if (folio_try_hugetlb_mte_tagging(folio))
+				for (i = 0; i < folio_nr_pages(folio); i++)
+					mte_clear_page_tags(page_address(folio_page(folio, i)));
 			num_tags = mte_copy_tags_from_user(maddr, tags,
 							MTE_GRANULES_PER_PAGE);
 
-- 
2.47.3

