Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.234
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792580832;
	b=pN4R9vsi1sr62aiut3WUOfjrOM8JlOTUXuVq9OL2btp2ZorRG5MIR/vACbj7yrod5cVo
	 OEX8pjPIyfr6H5uPobNtD2SEEyNb92d2gdRwnwODKpCoxN1BDQCCNXDgTKSaLcwdBtE/X
	 YJrBDBAu0kEOU8NSU5jlMs6iPwWv/xmblSEz+pR9A/wYTO/3af8Bvami7XvcMvQg4bZKT
	 1fKgyqBH5t/Nko9BF9imIddqL4WfgpQ1s3KRDx+JGQCjXnea9vi+zpxrn20KGyQ1BHnqZ
	 Jm7fJl3FXavAyJJfqhoXJUjr/P6AJlja+GJhL592GGxfF8QJ9+ZRNe0/MC0zn9gMbcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792580832;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9m8ViHr1UqAzoBRlxS+Gxk2y8F/+VCn9YhxkhleDGiU=;
	b=dHncEht/DdnhV7YsxC5TIu2+s6xCSntm4lDFbUDapbYey8iOCLKwu947Ipv3dHYUHCqP
	 DdayaKhEPLbuHwrYapF+OQULeMJpDcySHMSUwOJas7J5A5Jy0FE7E5mZS9zjhwhvSvwuV
	 5ghKYVLM0vLJhG3mYl6mRAcjOPWIYhAtuVAkV1Tvq1ZkLnOq1KjrW9mQeYBvgwEmAx2l1
	 h/hNSRSNwuJgY6A3iNlSwnLaVAS9iZd7EkHlxfJ6gTCKAnUZWQIli8eI5c64fCdDirqVu
	 llZY1vXjKcl3PxYz7Z6M8MD1FPZ54zCmErcUlpPmt1iYRph+P/HQCvZgfSs3BwrcxKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gH4vvTMn;
	arc=none smtp.remote-ip=91.218.175.234
Received: from mta0.migadu.com (out-234.mta0.migadu.com [91.218.175.234])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82633606A31A
	for <kvmarm@lists.linux.dev>; Wed, 21 Oct 2026 11:07:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82633606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gH4vvTMn
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=R/fPNXDyLmbkYE0kKFi9F8PpL/slnTHOsf1/K3rjOBE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792580829; v=1; x=1793185629;
 b=gH4vvTMnpIHal2aaTVQvCySxdgaV/dpT1ozBPnQkGrRgeDfn9lFZMq+uEi8xvp4n3WDBSx6S
 Jb4vqZeZOZ6jCmhcyeaKaBKnseZ/K/bmlk4p46nsn+fGy1kJ2OuMmXQqyXG05DqD9FHhRiJ/22d
 KxMCnFyrfzcpgLADa+LvLwd8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 04f5e76770af7b13;
	Wed, 21 Oct 2026 11:07:09 +0000
X-Mizu-Trace-ID: 04f5e76770af7b13
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
Subject: [PATCH v2 1/4] KVM: arm64: Clear the whole hugetlb folio when sanitising MTE tags
Date: Wed, 21 Oct 2026 12:06:57 +0100
Message-ID: <20261021110700.493315-2-fuad.tabba@linux.dev>
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

sanitise_mte_tags() clears the tags of the pages about to be mapped at
stage-2 before marking them tagged. For a hugetlb folio the flag covers
every page in the folio, but the loop only covers the mapping being
installed. Stage-2 maps a folio in pieces for the contiguous hugetlb
sizes, and for any size under dirty logging. The first fault then marks
the whole folio after clearing only its own piece, and the rest keeps
its previous owner's tags for the guest to read.

Clear the whole folio, as mte_sync_tags() does.

Fixes: 25c17c4b55def ("hugetlb: arm64: add mte support")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4af..a551b6bb13c21 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1512,10 +1512,10 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 	}
 
 	if (folio_test_hugetlb(folio)) {
-		/* Hugetlb has MTE flags set on head page only */
+		/* A hugetlb folio is marked tagged as a whole, so clear every page */
 		if (folio_try_hugetlb_mte_tagging(folio)) {
-			for (i = 0; i < nr_pages; i++, page++)
-				mte_clear_page_tags(page_address(page));
+			for (i = 0; i < folio_nr_pages(folio); i++)
+				mte_clear_page_tags(page_address(folio_page(folio, i)));
 			folio_set_hugetlb_mte_tagged(folio);
 		}
 		return;
-- 
2.47.3

