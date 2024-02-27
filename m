Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E688A14AD07
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 19:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061742; cv=none; b=QFHnANYZJCSOVSQ8rpzQKOE6fR0cJkBr2GTqbMgStdeuvXi+9CI3t/bdLFTtZmDAHqKcJQV/QvPEOgxKwHUTVGFG+bmsz23752l17icoxZ1CsuoahALZnAvUK1d1Tniy5/ksWdvR0Dpcaa3PjCQs0JRhK+BV37KaLJjf/KGhAIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061742; c=relaxed/simple;
	bh=DTqy6scdK0VMeDqGk7g/86rHlzjsUbVjS0nIDmPfMeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=ZjJc6lmHoxEgINZ5WmlcZi5lft7dHpnvVnEksKgFrfJtPiDoKxsM9g4/HUUnQ3KUnp5CzPT6yUYsX7DlQ1SvFrBRslcQZ1OEPKLUFmMXlxy6ssUWk2Qhn2h7ipi4XVFDNnArXSXkRCnYDOVZfQmXiYWrOKG34DTI368kawQwi0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kv3umA/5; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kv3umA/5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X98r+E2HjjzpqAg3o8D8X25F7j+MlQGPDJRNThe9QrY=;
	b=Kv3umA/5gtTS40mDTBkpHdoScti8RHZOAwgEBMMhbJggbkE2qaYaP9Nq12s5gRCBWQk5J8
	AVyZaOcbQx+SnKfCujnZztiS7MdPF5/g7qR3q9u59I9+MaNVMl9FDbgTD9PhKakxBHY+rE
	uMR/sEqQDv/y45AcL33YzQEQzBhhJgs=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 15/18] arm64: efi: Don't map reserved regions
Date: Tue, 27 Feb 2024 20:21:25 +0100
Message-ID: <20240227192109.487402-35-andrew.jones@linux.dev>
In-Reply-To: <20240227192109.487402-20-andrew.jones@linux.dev>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We shouldn't need to map all the regions that the EFI memory map
contains. Just map EFI_LOADER_CODE and EFI_LOADER_DATA, since
those are for the loaded unit test, and any region types which
could be used by the unit test for its own memory allocations. We
still map EFI_BOOT_SERVICES_DATA since the primary stack is on a
region of that type. In a later patch we'll switch to a stack we
allocate ourselves to drop that one too.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/mmu.c    | 6 +-----
 lib/arm/setup.c  | 4 ++--
 lib/memregions.c | 8 ++++++++
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index eb5e82a95f06..9dce7da85709 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -221,12 +221,8 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
 		mmu_idmap = alloc_page();
 
 	for (r = mem_regions; r->end; ++r) {
-		if (r->flags & MR_F_IO) {
+		if (r->flags & (MR_F_IO | MR_F_RESERVED)) {
 			continue;
-		} else if (r->flags & MR_F_RESERVED) {
-			/* Reserved pages need to be writable for whatever reserved them */
-			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
-					   __pgprot(PTE_WBWA));
 		} else if (r->flags & MR_F_CODE) {
 			/* armv8 requires code shared between EL1 and EL0 to be read-only */
 			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 521928186fb0..08658b9a222b 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -309,8 +309,8 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 		data->flags &= ~MR_F_CODE;
 
 	for (struct mem_region *m = mem_regions; m->end; ++m) {
-		if (m != code && (m->flags & MR_F_CODE))
-			m->flags = MR_F_RESERVED;
+		if (m != code)
+			assert(!(m->flags & MR_F_CODE));
 
 		if (!(m->flags & MR_F_IO)) {
 			if (m->start < __phys_offset)
diff --git a/lib/memregions.c b/lib/memregions.c
index 9cdbb639ab62..3c6f751eb4f2 100644
--- a/lib/memregions.c
+++ b/lib/memregions.c
@@ -112,6 +112,14 @@ void memregions_efi_init(struct efi_boot_memmap *mem_map,
 		case EFI_LOADER_CODE:
 			r.flags = MR_F_CODE;
 			break;
+		case EFI_LOADER_DATA:
+			break;
+		case EFI_BOOT_SERVICES_DATA:
+			/*
+			 * FIXME: This would ideally be MR_F_RESERVED, but the
+			 * primary stack is in a region of this EFI type.
+			 */
+			break;
 		case EFI_PERSISTENT_MEMORY:
 			r.flags = MR_F_PERSISTENT;
 			break;
-- 
2.43.0

