Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7451A3030
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065421; cv=none; b=kXsmAS3gv4D1x6A+tBsilGQpmfZ6QcPJu9T6hECvnvZkb394YuSCwduDH1Md+mumGPnFeDq1zhYUPJ1BWGDmOE7Hft8ElpZpCL2ltNYzdz+edRidCEAvDSQS+i5h891N3VfCtRDdtJNS32+Mf/+uNPfwsYMS5IuPQH+tdAAqIsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065421; c=relaxed/simple;
	bh=IIAVkvLaIFvLB0z2Wa6dsujKRjAOpbGd0p7bW6r9E64=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uYJn54vubkBQ/rEqs3aWe6XNBsO9aWSudTun03RaJLYQQ4VNC3+hiMrvCvuEE92xN+joP48Duf4bd71+w/w3iFtpAQMmP7/SC0K8sHUOwJGwRN7f4a2WF/l1pLlZR24uDG2P2K8Klvoxobd8WAQj6oJxAl1RdYwt792ayns6ezI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=nI2L2RIe; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="nI2L2RIe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726065419; x=1757601419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M6VWy3IvZCNc4zvvTM+7ldu6BbKiq6bFPxrlGyI8xuQ=;
  b=nI2L2RIemjQ39cae4IPqUUN+CGTZvgKt8PtQB9fLkLsv7cnssx7n3sjm
   iElBk5IVs4lli1HAPAvpOQnOSJM+WhM0Deflx2zcwcF6zwdXSJKSnz7ON
   /JudbHObmhFQtoL4GBu3WPBsBcMSBhPmMBM878vnNsV8ORnn4wOGE8/US
   k=;
X-IronPort-AV: E=Sophos;i="6.10,220,1719878400"; 
   d="scan'208";a="679649476"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 14:35:48 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:50131]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.39.168:2525] with esmtp (Farcaster)
 id ce0e4cf6-8c87-42ac-ae89-33a20b34e603; Wed, 11 Sep 2024 14:35:46 +0000 (UTC)
X-Farcaster-Flow-ID: ce0e4cf6-8c87-42ac-ae89-33a20b34e603
Received: from EX19D007EUA004.ant.amazon.com (10.252.50.76) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 14:35:42 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D007EUA004.ant.amazon.com (10.252.50.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 11 Sep 2024 14:35:41 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (10.253.79.181)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Wed, 11 Sep 2024 14:35:39 +0000
From: Fares Mehanna <faresx@amazon.de>
To: 
CC: <nh-open-source@amazon.com>, Fares Mehanna <faresx@amazon.de>, Roman Kagan
	<rkagan@amazon.de>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>, Ard Biesheuvel
	<ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "Javier Martinez
 Canillas" <javierm@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Fuad Tabba
	<tabba@google.com>, Mark Brown <broonie@kernel.org>, Joey Gouly
	<joey.gouly@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, "Randy
 Dunlap" <rdunlap@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "Mike Rapoport (IBM)"
	<rppt@kernel.org>, David Hildenbrand <david@redhat.com>, "moderated
 list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
	<linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE FOR
 ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>, open list
	<linux-kernel@vger.kernel.org>, "open list:MEMORY MANAGEMENT"
	<linux-mm@kvack.org>
Subject: [RFC PATCH 1/7] mseal: expose interface to seal / unseal user memory ranges
Date: Wed, 11 Sep 2024 14:34:00 +0000
Message-ID: <20240911143421.85612-2-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240911143421.85612-1-faresx@amazon.de>
References: <20240911143421.85612-1-faresx@amazon.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

To make sure the kernel mm-local mapping is untouched by the user, we will seal
the VMA before changing the protection to be used by the kernel.

This will guarantee that userspace can't unmap or alter this VMA while it is
being used by the kernel.

After the kernel is done with the secret memory, it will unseal the VMA to be
able to unmap and free it.

Unseal operation is not exposed to userspace.

Signed-off-by: Fares Mehanna <faresx@amazon.de>
Signed-off-by: Roman Kagan <rkagan@amazon.de>
---
 mm/internal.h |  7 +++++
 mm/mseal.c    | 81 ++++++++++++++++++++++++++++++++-------------------
 2 files changed, 58 insertions(+), 30 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index b4d86436565b..cf7280d101e9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1501,6 +1501,8 @@ bool can_modify_mm(struct mm_struct *mm, unsigned long start,
 		unsigned long end);
 bool can_modify_mm_madv(struct mm_struct *mm, unsigned long start,
 		unsigned long end, int behavior);
+/* mm's mmap write lock must be taken before seal/unseal operation */
+int do_mseal(unsigned long start, unsigned long end, bool seal);
 #else
 static inline int can_do_mseal(unsigned long flags)
 {
@@ -1518,6 +1520,11 @@ static inline bool can_modify_mm_madv(struct mm_struct *mm, unsigned long start,
 {
 	return true;
 }
+
+static inline int do_mseal(unsigned long start, unsigned long end, bool seal)
+{
+	return -EINVAL;
+}
 #endif
 
 #ifdef CONFIG_SHRINKER_DEBUG
diff --git a/mm/mseal.c b/mm/mseal.c
index 15bba28acc00..aac9399ffd5d 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -26,6 +26,11 @@ static inline void set_vma_sealed(struct vm_area_struct *vma)
 	vm_flags_set(vma, VM_SEALED);
 }
 
+static inline void clear_vma_sealed(struct vm_area_struct *vma)
+{
+	vm_flags_clear(vma, VM_SEALED);
+}
+
 /*
  * check if a vma is sealed for modification.
  * return true, if modification is allowed.
@@ -117,7 +122,7 @@ bool can_modify_mm_madv(struct mm_struct *mm, unsigned long start, unsigned long
 
 static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		struct vm_area_struct **prev, unsigned long start,
-		unsigned long end, vm_flags_t newflags)
+		unsigned long end, vm_flags_t newflags, bool seal)
 {
 	int ret = 0;
 	vm_flags_t oldflags = vma->vm_flags;
@@ -131,7 +136,10 @@ static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		goto out;
 	}
 
-	set_vma_sealed(vma);
+	if (seal)
+		set_vma_sealed(vma);
+	else
+		clear_vma_sealed(vma);
 out:
 	*prev = vma;
 	return ret;
@@ -167,9 +175,9 @@ static int check_mm_seal(unsigned long start, unsigned long end)
 }
 
 /*
- * Apply sealing.
+ * Apply sealing / unsealing.
  */
-static int apply_mm_seal(unsigned long start, unsigned long end)
+static int apply_mm_seal(unsigned long start, unsigned long end, bool seal)
 {
 	unsigned long nstart;
 	struct vm_area_struct *vma, *prev;
@@ -191,11 +199,14 @@ static int apply_mm_seal(unsigned long start, unsigned long end)
 		unsigned long tmp;
 		vm_flags_t newflags;
 
-		newflags = vma->vm_flags | VM_SEALED;
+		if (seal)
+			newflags = vma->vm_flags | VM_SEALED;
+		else
+			newflags = vma->vm_flags & ~(VM_SEALED);
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
-		error = mseal_fixup(&vmi, vma, &prev, nstart, tmp, newflags);
+		error = mseal_fixup(&vmi, vma, &prev, nstart, tmp, newflags, seal);
 		if (error)
 			return error;
 		nstart = vma_iter_end(&vmi);
@@ -204,6 +215,37 @@ static int apply_mm_seal(unsigned long start, unsigned long end)
 	return 0;
 }
 
+int do_mseal(unsigned long start, unsigned long end, bool seal)
+{
+	int ret;
+
+	if (end < start)
+		return -EINVAL;
+
+	if (end == start)
+		return 0;
+
+	/*
+	 * First pass, this helps to avoid
+	 * partial sealing in case of error in input address range,
+	 * e.g. ENOMEM error.
+	 */
+	ret = check_mm_seal(start, end);
+	if (ret)
+		goto out;
+
+	/*
+	 * Second pass, this should success, unless there are errors
+	 * from vma_modify_flags, e.g. merge/split error, or process
+	 * reaching the max supported VMAs, however, those cases shall
+	 * be rare.
+	 */
+	ret = apply_mm_seal(start, end, seal);
+
+out:
+	return ret;
+}
+
 /*
  * mseal(2) seals the VM's meta data from
  * selected syscalls.
@@ -256,7 +298,7 @@ static int apply_mm_seal(unsigned long start, unsigned long end)
  *
  *  unseal() is not supported.
  */
-static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
+static int __do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 {
 	size_t len;
 	int ret = 0;
@@ -277,33 +319,12 @@ static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 		return -EINVAL;
 
 	end = start + len;
-	if (end < start)
-		return -EINVAL;
-
-	if (end == start)
-		return 0;
 
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
-	/*
-	 * First pass, this helps to avoid
-	 * partial sealing in case of error in input address range,
-	 * e.g. ENOMEM error.
-	 */
-	ret = check_mm_seal(start, end);
-	if (ret)
-		goto out;
-
-	/*
-	 * Second pass, this should success, unless there are errors
-	 * from vma_modify_flags, e.g. merge/split error, or process
-	 * reaching the max supported VMAs, however, those cases shall
-	 * be rare.
-	 */
-	ret = apply_mm_seal(start, end);
+	ret = do_mseal(start, end, true);
 
-out:
 	mmap_write_unlock(current->mm);
 	return ret;
 }
@@ -311,5 +332,5 @@ static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long,
 		flags)
 {
-	return do_mseal(start, len, flags);
+	return __do_mseal(start, len, flags);
 }
-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

