Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6360018627
	for <kvmarm@lists.linux.dev>; Tue,  5 Mar 2024 16:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657246; cv=none; b=F6pbCDprt9HGEgXG9y2b1inqqIvDO789VObap/44n8df8Gzh/eDGGqNt0xJGEC+qqt1+Ca2Yr6dq7IuMxm9ykf0jBKbP0xgkQzOOHKO/ztt9SX7UFuaiVYkZj0uRI8Vr2qUottRaDLm5/IAdG8/ZLxMbXjAXWW7lYpJOQmxJ5lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657246; c=relaxed/simple;
	bh=UiYLWy5gXfXcrCJwBk9W9L/rn/d/gXXaeO43wVMX9EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=dlUifyryCShbTwCCG5ER+Gf92WAetMSFfkqGaC0NYaf3GawkCqQFgpDowl7nHi6kzCef9nJjc0n0ahkLOKRyDPIgSv5cGbF0IzB1j0+PCpdATL0QTnaP2RokrsYAeH43E/12sSc+e6coV9glBZo6GZQ688FTCOGRu1vLqxhv05g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gwZz+/GL; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gwZz+/GL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H6sZCXOViSyeJFa4S/XErJyBLA/lVA6LoZVSPOhZj6k=;
	b=gwZz+/GLC1HW6Fvr2Fj4tKaypoutqWHKUouBDgSdODE8+4GrA5u71fYW9wq8C8EkVr2F2e
	8SGoFdrrdRzyxz2bkmA/1pXM4lpNHwodsROXtqpAtNgbxcoitamHAv0nqSIs2ZUWRgOtgD
	9YFiUAn7XS375KFScHSNgBo22UsMNQo=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 17/18] arm64: efi: Switch to our own stack
Date: Tue,  5 Mar 2024 17:46:41 +0100
Message-ID: <20240305164623.379149-37-andrew.jones@linux.dev>
In-Reply-To: <20240305164623.379149-20-andrew.jones@linux.dev>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We don't want to map EFI_BOOT_SERVICES_DATA regions, so move the
stack from its EFI_BOOT_SERVICES_DATA region to EFI_LOADER_CODE,
which we always map. We'll still map the stack as R/W instead of
R/X because we split EFI_LOADER_CODE regions on the _etext boundary
and map addresses before _etext as R/X and the rest as R/W.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/crt0-efi-aarch64.S | 22 +++++++++++++++++-----
 lib/arm/setup.c            |  4 ----
 lib/memregions.c           |  6 ------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
index 5fd3dc94dae8..71ce2794f059 100644
--- a/arm/efi/crt0-efi-aarch64.S
+++ b/arm/efi/crt0-efi-aarch64.S
@@ -125,12 +125,18 @@ _start:
 
 	ldp		x0, x1, [sp, #16]
 
-	/* Align sp; this is necessary due to way we store cpu0's thread_info */
+	/*
+	 * Switch to our own stack and align sp; this is necessary due
+	 * to way we store cpu0's thread_info
+	 */
+	adrp		x2, stacktop
+	add		x2, x2, :lo12:stacktop
+	and		x2, x2, #THREAD_MASK
+	mov		x3, sp
+	mov		sp, x2
+	stp		xzr, xzr, [sp, #-16]!
 	mov		x29, sp
-	mov		x30, sp
-	and		x30, x30, #THREAD_MASK
-	mov		sp, x30
-	str		x29, [sp, #-16]!
+	str		x3, [sp, #-16]!
 
 	bl		efi_main
 
@@ -140,3 +146,9 @@ _start:
 
 0:	ldp		x29, x30, [sp], #32
 	ret
+
+	.section	.data
+
+.balign 65536
+.space 65536
+stacktop:
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 50a3bb65d865..2f649aff5551 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -340,10 +340,6 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 {
 	efi_status_t status;
 
-	struct thread_info *ti = current_thread_info();
-
-	memset(ti, 0, sizeof(*ti));
-
 	exceptions_init();
 
 	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
diff --git a/lib/memregions.c b/lib/memregions.c
index 3c6f751eb4f2..53fc0c7cfc58 100644
--- a/lib/memregions.c
+++ b/lib/memregions.c
@@ -114,12 +114,6 @@ void memregions_efi_init(struct efi_boot_memmap *mem_map,
 			break;
 		case EFI_LOADER_DATA:
 			break;
-		case EFI_BOOT_SERVICES_DATA:
-			/*
-			 * FIXME: This would ideally be MR_F_RESERVED, but the
-			 * primary stack is in a region of this EFI type.
-			 */
-			break;
 		case EFI_PERSISTENT_MEMORY:
 			r.flags = MR_F_PERSISTENT;
 			break;
-- 
2.44.0

