Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD82E1487DB
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 19:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061727; cv=none; b=k14VmI84Pb/8ZYVJ77+I0uD2PW2DHRnt3r0RSkpnF6KbDavxKIyWnVP2EVXhyWRpU+7IY4vT3618yXWZM49Ja3Camtv2pXGecuS4v2DLxPAb4M5bt+CztXW1DzpXk1fgrYMiHIdVJVGHWSCPs+Gcsm9uaThlkP9ZLoUvoTighK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061727; c=relaxed/simple;
	bh=wpDhFfTN6nJKNBehoP3s6/g3ERYTTnU4O47Znkkop/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=j2aK4JdVsa5/GQZuY1lBcfYOc6gWQgtnLPuRzI9PfH1H19IRxyM2Hvco21vSK5R+oxaZQWXUGFpD8tjSXC8apHzycqVdFBTAcGLl6wKWhXjdT3lOxMSLQOZ4gvZ3wEu8JoOH/IByWpiikRaspdON2RGvn/AKL4sUNQweWb7oO0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gc1eCzIM; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gc1eCzIM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYIHvI1GLAd4wT4WngttIKyGQENqRKMJxOIUlux1SQg=;
	b=gc1eCzIMSGOAfy+AyOwQBbxxSGv04dDopROfqAP/gn92j1FtRnYTNJzOqtEkeaNNt3+zbf
	KKEdy3P3g15s9AmQUqHxN2/bZ/Q87m2Y8nq2xf3n+MCZ/QAVHnTNwgiwBo4DkdvhRhnEh1
	X1gkvsBi/ttRhTt0DnkxVhi5hl6wpSs=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 12/18] arm/arm64: Factor out allocator init from mem_init
Date: Tue, 27 Feb 2024 20:21:22 +0100
Message-ID: <20240227192109.487402-32-andrew.jones@linux.dev>
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

The allocator init is identical for mem_init() and efi_mem_init().
Share it.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/setup.c | 46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index f96ee04ddd68..d0be4c437708 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -136,9 +136,28 @@ static void arm_memregions_add_assumed(void)
 #endif
 }
 
-static void mem_init(phys_addr_t freemem_start)
+static void mem_allocator_init(phys_addr_t freemem_start, phys_addr_t freemem_end)
 {
 	phys_addr_t base, top;
+
+	freemem_start = PAGE_ALIGN(freemem_start);
+	freemem_end &= PAGE_MASK;
+
+	phys_alloc_init(freemem_start, freemem_end - freemem_start);
+	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
+
+	phys_alloc_get_unused(&base, &top);
+	base = PAGE_ALIGN(base);
+	top &= PAGE_MASK;
+	assert(sizeof(long) == 8 || !(base >> 32));
+	if (sizeof(long) != 8 && (top >> 32) != 0)
+		top = ((uint64_t)1 << 32);
+	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
+	page_alloc_ops_enable();
+}
+
+static void mem_init(phys_addr_t freemem_start)
+{
 	struct mem_region *freemem, *r, mem = {
 		.start = (phys_addr_t)-1,
 	};
@@ -169,17 +188,7 @@ static void mem_init(phys_addr_t freemem_start)
 	__phys_offset = mem.start;	/* PHYS_OFFSET */
 	__phys_end = mem.end;		/* PHYS_END */
 
-	phys_alloc_init(freemem_start, freemem->end - freemem_start);
-	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
-
-	phys_alloc_get_unused(&base, &top);
-	base = PAGE_ALIGN(base);
-	top = top & PAGE_MASK;
-	assert(sizeof(long) == 8 || !(base >> 32));
-	if (sizeof(long) != 8 && (top >> 32) != 0)
-		top = ((uint64_t)1 << 32);
-	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
-	page_alloc_ops_enable();
+	mem_allocator_init(freemem_start, freemem->end);
 }
 
 static void freemem_push_fdt(void **freemem, const void *fdt)
@@ -292,7 +301,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
 	efi_memory_desc_t *buffer = *map->map;
 	efi_memory_desc_t *d = NULL;
-	phys_addr_t base, top;
 	struct mem_region r;
 	uintptr_t text = (uintptr_t)&_text, etext = ALIGN((uintptr_t)&_etext, 4096);
 	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
@@ -380,17 +388,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 
 	assert(sizeof(long) == 8 || free_mem_start < (3ul << 30));
 
-	phys_alloc_init(free_mem_start, free_mem_pages << EFI_PAGE_SHIFT);
-	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
-
-	phys_alloc_get_unused(&base, &top);
-	base = PAGE_ALIGN(base);
-	top = top & PAGE_MASK;
-	assert(sizeof(long) == 8 || !(base >> 32));
-	if (sizeof(long) != 8 && (top >> 32) != 0)
-		top = ((uint64_t)1 << 32);
-	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
-	page_alloc_ops_enable();
+	mem_allocator_init(free_mem_start, free_mem_start + (free_mem_pages << EFI_PAGE_SHIFT));
 
 	return EFI_SUCCESS;
 }
-- 
2.43.0

