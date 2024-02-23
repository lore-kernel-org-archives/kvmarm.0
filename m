Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6757B84FAA
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 15:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708703555; cv=none; b=jxkKbrwJCTkjOEJa050W56F1Rdw/yql1zBtmr8Ins2XW5rMqD4w7tjF0slkHvrWN/chijsW8MMjFKsEYJC5JtRy2ByIs6Tlhup+2clm5MO5qAR7VcsNVW1fO6g8hdaFUJjA4FdoyIKohNyMhmFrexc2hr9MRz/0MWOeyVCxEmTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708703555; c=relaxed/simple;
	bh=MTPlTatfIghDuZ553cISvbEgjkp8435gVtWr1e6Hliw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=V916nDHjtYndHFX/driCL/bXQ1DzpllFLKUXpdZGnT+D5Qq6Nkme9CKnSQcYwb9gb+hsJD8Y3/nHVd3mTO47so7VG7gvzJjWv/VHN9y5UlSKDe+76PV/JQ0o106hNbYHVUC9YqZQDbJPNFJPqeJVzFsM7DEZdHvWz9b2r4NQyyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eG5Q7r5Y; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eG5Q7r5Y"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708703550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PBD1ohiKpXGdC4CTOzC92NNH+OTPx9G6EKUZO37Av4c=;
	b=eG5Q7r5YCAIHScpVm7u5cj47/Z0QP+BmfBAv5FsA/5B/Uf6JgHupdwCrnIC5pm9xU6V5aa
	VW45ixCt/RZkZipEL3SvEW9ajODpCDzAIaKxNbldHm5vfvEgINy5YTcEOtOI/6wee57cbS
	T9V2gP2i4tWIERz0Elf52GVLSsIScu0=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 13/14] arm64: Simplify efi_mem_init
Date: Fri, 23 Feb 2024 16:51:39 +0100
Message-ID: <20240223155125.368512-29-andrew.jones@linux.dev>
In-Reply-To: <20240223155125.368512-16-andrew.jones@linux.dev>
References: <20240223155125.368512-16-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reduce the EFI mem_map loop to only setting flags and finding the
largest free memory region. Then, apply memregions_split() for
the code/data region split and do the rest of the things that
used to be done in the EFI mem_map loop in a separate mem_region
loop.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/setup.c | 45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index d0be4c437708..631597b343f1 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -301,9 +301,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
 	efi_memory_desc_t *buffer = *map->map;
 	efi_memory_desc_t *d = NULL;
-	struct mem_region r;
-	uintptr_t text = (uintptr_t)&_text, etext = ALIGN((uintptr_t)&_etext, 4096);
-	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
+	struct mem_region r, *code, *data;
 	const void *fdt = efi_bootinfo->fdt;
 
 	/*
@@ -337,21 +335,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 			r.flags = MR_F_IO;
 			break;
 		case EFI_LOADER_CODE:
-			if (r.start <= text && r.end > text) {
-				/* This is the unit test region. Flag the code separately. */
-				phys_addr_t tmp = r.end;
-
-				assert(etext <= data);
-				assert(edata <= r.end);
-				r.flags = MR_F_CODE;
-				r.end = data;
-				memregions_add(&r);
-				r.start = data;
-				r.end = tmp;
-				r.flags = 0;
-			} else {
-				r.flags = MR_F_RESERVED;
-			}
+			r.flags = MR_F_CODE;
 			break;
 		case EFI_CONVENTIONAL_MEMORY:
 			if (free_mem_pages < d->num_pages) {
@@ -361,15 +345,27 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 			break;
 		}
 
-		if (!(r.flags & MR_F_IO)) {
-			if (r.start < __phys_offset)
-				__phys_offset = r.start;
-			if (r.end > __phys_end)
-				__phys_end = r.end;
-		}
 		memregions_add(&r);
 	}
 
+	memregions_split((unsigned long)&_etext, &code, &data);
+	assert(code && (code->flags & MR_F_CODE));
+	if (data)
+		data->flags &= ~MR_F_CODE;
+
+	for (struct mem_region *m = mem_regions; m->end; ++m) {
+		if (m != code && (m->flags & MR_F_CODE))
+			m->flags = MR_F_RESERVED;
+
+		if (!(m->flags & MR_F_IO)) {
+			if (m->start < __phys_offset)
+				__phys_offset = m->start;
+			if (m->end > __phys_end)
+				__phys_end = m->end;
+		}
+	}
+	__phys_end &= PHYS_MASK;
+
 	if (efi_bootinfo->fdt_valid) {
 		unsigned long old_start = free_mem_start;
 		void *freemem = (void *)free_mem_start;
@@ -380,7 +376,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 		free_mem_pages = (free_mem_start - old_start) >> EFI_PAGE_SHIFT;
 	}
 
-	__phys_end &= PHYS_MASK;
 	asm_mmu_disable();
 
 	if (free_mem_pages == 0)
-- 
2.43.0

