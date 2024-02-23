Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B94D839FB
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 15:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708703549; cv=none; b=QRl5B4XrJBhiK6cOXfgovfHIjjXoV3thpyG0IbC9j9Mdx8ZRCKMw1UlgyXf7VPGjxM/2O0qeGSrbZlNPRBiTKL08hK1+crfmgooA+wmH+b86oDL8B/8Q25NXF73+jOjdDMJIXL99x3VD6nCEsrT+1x4zekxQ64GzB4SjCes525s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708703549; c=relaxed/simple;
	bh=4sTNAa6MnoYrfkKq/iDV5maKOG8CDnDHXU6m+7P7+jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=oqoI4N9xO71r4TUwo/bK+Scumt9FsHwEpNgATc2Hq3G3CUwvZqUiLErIfWUvHDEDsBtsHG/1gKzjTwyO81No2J8cVYBQH3T8Tlr0hja65qcoKATCWXHOjDIEJSMIz18CSJHJ+oBaBJhSUF5ENt2/PPZswdzYcWoYOFlAICmsFQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JKHgzige; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JKHgzige"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708703545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pOyBAmSuH+i2SPph24jGVrUxKJ627tNATtbobG5uL1c=;
	b=JKHgzigeXyCLk+SyC3Jap0+8CQOZX+dvmELbpDVASmQACOdoxjmWQjmkMqGGWWzTjNAn+J
	VgbJ4KEoNegTdtSnM06Gg6S3ZfjBvptsKQRY43/6zClxQbe8Q7DGnd/mCurOyq6GIzdcNT
	4I69h/tah2GHr6gkwFP2DBMyGwLs1DI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 11/14] arm/arm64: Factor out some initial setup
Date: Fri, 23 Feb 2024 16:51:37 +0100
Message-ID: <20240223155125.368512-27-andrew.jones@linux.dev>
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

Factor out some initial setup code into separate functions in order
to share more code between setup() and setup_efi().

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/setup.c | 81 ++++++++++++++++++++++++++++---------------------
 1 file changed, 47 insertions(+), 34 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 76aae4627a7b..f96ee04ddd68 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -182,32 +182,57 @@ static void mem_init(phys_addr_t freemem_start)
 	page_alloc_ops_enable();
 }
 
-void setup(const void *fdt, phys_addr_t freemem_start)
+static void freemem_push_fdt(void **freemem, const void *fdt)
 {
-	void *freemem;
-	const char *bootargs, *tmp;
 	u32 fdt_size;
 	int ret;
 
-	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
-	freemem = (void *)(unsigned long)freemem_start;
-
-	/* Move the FDT to the base of free memory */
 	fdt_size = fdt_totalsize(fdt);
-	ret = fdt_move(fdt, freemem, fdt_size);
+	ret = fdt_move(fdt, *freemem, fdt_size);
 	assert(ret == 0);
-	ret = dt_init(freemem);
+	ret = dt_init(*freemem);
 	assert(ret == 0);
-	freemem += fdt_size;
+	*freemem += fdt_size;
+}
+
+static void freemem_push_dt_initrd(void **freemem)
+{
+	const char *tmp;
+	int ret;
 
-	/* Move the initrd to the top of the FDT */
 	ret = dt_get_initrd(&tmp, &initrd_size);
 	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
 	if (ret == 0) {
-		initrd = freemem;
+		initrd = *freemem;
 		memmove(initrd, tmp, initrd_size);
-		freemem += initrd_size;
+		*freemem += initrd_size;
 	}
+}
+
+static void initrd_setup(void)
+{
+	char *env;
+
+	if (!initrd)
+		return;
+
+	/* environ is currently the only file in the initrd */
+	env = malloc(initrd_size);
+	memcpy(env, initrd, initrd_size);
+	setup_env(env, initrd_size);
+}
+
+void setup(const void *fdt, phys_addr_t freemem_start)
+{
+	void *freemem;
+	const char *bootargs;
+	int ret;
+
+	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
+	freemem = (void *)(unsigned long)freemem_start;
+
+	freemem_push_fdt(&freemem, fdt);
+	freemem_push_dt_initrd(&freemem);
 
 	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
 	memregions_add_dt_regions(MAX_DT_MEM_REGIONS);
@@ -229,12 +254,7 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	assert(ret == 0 || ret == -FDT_ERR_NOTFOUND);
 	setup_args_progname(bootargs);
 
-	if (initrd) {
-		/* environ is currently the only file in the initrd */
-		char *env = malloc(initrd_size);
-		memcpy(env, initrd, initrd_size);
-		setup_env(env, initrd_size);
-	}
+	initrd_setup();
 
 	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
 		setup_vm();
@@ -277,7 +297,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	uintptr_t text = (uintptr_t)&_text, etext = ALIGN((uintptr_t)&_etext, 4096);
 	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
 	const void *fdt = efi_bootinfo->fdt;
-	int fdt_size, ret;
 
 	/*
 	 * Record the largest free EFI_CONVENTIONAL_MEMORY region
@@ -344,14 +363,13 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	}
 
 	if (efi_bootinfo->fdt_valid) {
-		/* Move the FDT to the base of free memory */
-		fdt_size = fdt_totalsize(fdt);
-		ret = fdt_move(fdt, (void *)free_mem_start, fdt_size);
-		assert(ret == 0);
-		ret = dt_init((void *)free_mem_start);
-		assert(ret == 0);
-		free_mem_start += ALIGN(fdt_size, EFI_PAGE_SIZE);
-		free_mem_pages -= ALIGN(fdt_size, EFI_PAGE_SIZE) >> EFI_PAGE_SHIFT;
+		unsigned long old_start = free_mem_start;
+		void *freemem = (void *)free_mem_start;
+
+		freemem_push_fdt(&freemem, fdt);
+
+		free_mem_start = ALIGN((unsigned long)freemem, EFI_PAGE_SIZE);
+		free_mem_pages = (free_mem_start - old_start) >> EFI_PAGE_SHIFT;
 	}
 
 	__phys_end &= PHYS_MASK;
@@ -419,13 +437,8 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	io_init();
 
 	timer_save_state();
-	if (initrd) {
-		/* environ is currently the only file in the initrd */
-		char *env = malloc(initrd_size);
 
-		memcpy(env, initrd, initrd_size);
-		setup_env(env, initrd_size);
-	}
+	initrd_setup();
 
 	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
 		setup_vm();
-- 
2.43.0

