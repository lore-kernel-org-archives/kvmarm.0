Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7791BD013
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 13:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764116; cv=none; b=MqWo9OlLP8dNgaRkK/Q+XLFDI6UiYTZiZGffixl8YLZzslZyTjK4MDGlO/pcuQDGK2z9jp9Zb3d5UxgqbMqwI9Mad8UCA41PjfKnwq5yJ/hIjVNzGKxlrPgUCpHiFfspCag/d2hVilExrJ0ffXWt8iLeybGvAaA9Aehd2dPyjA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764116; c=relaxed/simple;
	bh=K+TlnW9Omwb4YI1ixYapWz1zvuIl+jvuJ8oEax/y7lQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9crqRvWCZlSM5gHMmmMEpSQxe8uHcD3//msI9Gyu/RONToRtR0fsWA5Z3GcByJBh3DD6oCFbFjhOYdO37xSEUBm5wKD/db252PJ+T2viyghxCGg2XVMwAz6jfR9T/cs/ftAWpyC/hx/B+DmBzwqx5NhU+xiXcqY6oS8MhHQB1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FET8VBMU; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FET8VBMU"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-429d2d7be1eso29826025e9.1
        for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 06:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724764112; x=1725368912; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVI5R+WdttBIprX1m04d9bNMFDDS+NINGmtqeG2h9Pk=;
        b=FET8VBMUdl8VWkp7AM26A+HfWCS0dZwcQ/r2SLc3Sj9C0pHuw7rhrSqV4JhaslOFol
         WMrT2TEmGekPm5yEUOqTVR2y1lTb6gDVH9Tbwt2A8OUuOvyXW6k7CVucSeXADhh23GZv
         pdciOIHiehMiMEHvMeCKf6tNJyImf2CLgQRig9Oz8Z2ElcD1hu+ILe+1/75Z29Wuyn8f
         mD+O1vjHg54SKwsT3FCvo+Ulux8jcW0wCCB4CU/VGLbveexRbiRiIx5iHN5Nozhw+Ynl
         fnnidY8CMKBYzwnduStPrzoUPKhqGD/OytSasFLlSyS93qK94hB3mhXaDjVJOZxSzCEG
         acKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724764112; x=1725368912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zVI5R+WdttBIprX1m04d9bNMFDDS+NINGmtqeG2h9Pk=;
        b=lKIeZOMGyxF7sK44uyAGCVQJfaeBmOAr/pfytICxnGVMfcrdrJGibhZAapxG3omhv/
         mpNutOYuAg4P4T00FzSWD5PatmCfDMP29l8rK8LbVUXdJewjHHlEg6NdZNAHu5Z1kPzO
         +StWXeZSMNPZwmMsYuKzNRFS9Mqv3U1Sa2yb55OAdUwdJkbqh2an9Za8Nu36ymxtvEg4
         2UGv2sqRdFIPuGGYvWxIt4mljBFUhGEzc+M7AsyKWGtVfKVVD3F48kxGWxjqDosi3sUW
         jDkESVjBHdWKk4gCYZKS5j0ZC/hieD4y6lftSic+AEo7vZNtWJloGdmgMzkTc/DXkZIj
         ZkWw==
X-Forwarded-Encrypted: i=1; AJvYcCUWUt629hNcVRC6+dHgPilIpDRjxKcHokDEduHhES6jPKKx8nHwftQBSXcQUBhFV/YIiiew2yk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwizeYrupxbY53sP5GqCUify6ghgODeWIv4qtYsZUmn38l8Cmje
	Ak2rZXLJk23X/blbwlBdUAzlgn+YVYoKrAtJXPCraFp88S3DOz53CsD1QY7ToTs=
X-Google-Smtp-Source: AGHT+IE8YdSXKOIj7u+2bEQxKE7kkLyia2JoNSH9WemPGkONFgqu20dBwFvHn7im4jBKQqBOOuvFvA==
X-Received: by 2002:a05:600c:19c7:b0:426:5b19:d2b3 with SMTP id 5b1f17b1804b1-42b9a682241mr16687955e9.14.1724764111836;
        Tue, 27 Aug 2024 06:08:31 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42abefcb674sm221517205e9.32.2024.08.27.06.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 06:08:30 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 29A415F9F9;
	Tue, 27 Aug 2024 14:08:30 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	arnd@linaro.org,
	D Scott Phillips <scott@os.amperecomputing.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 2/3] ampere/arm64: Work around Ampere Altra erratum #82288 PCIE_65
Date: Tue, 27 Aug 2024 14:08:28 +0100
Message-Id: <20240827130829.43632-3-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240827130829.43632-1-alex.bennee@linaro.org>
References: <20240827130829.43632-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: D Scott Phillips <scott@os.amperecomputing.com>

Altra's PCIe controller may generate incorrect addresses when receiving
writes from the CPU with a discontiguous set of byte enables. Attempt to
work around this by handing out Device-nGnRE maps instead of Normal
Non-cacheable maps for PCIe memory areas.

Upstream-Status: Pending
Signed-off-by: D Scott Phillips <scott@os.amperecomputing.com>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 arch/arm64/Kconfig               | 22 +++++++++++++++++++++-
 arch/arm64/include/asm/io.h      |  3 +++
 arch/arm64/include/asm/pgtable.h | 27 ++++++++++++++++++++++-----
 arch/arm64/mm/ioremap.c          | 27 +++++++++++++++++++++++++++
 drivers/pci/quirks.c             |  9 +++++++++
 include/asm-generic/io.h         |  4 ++++
 mm/ioremap.c                     |  2 +-
 7 files changed, 87 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3fc891f15442..01adb50df214e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -440,6 +440,27 @@ config AMPERE_ERRATUM_AC03_CPU_38
 config ARM64_WORKAROUND_CLEAN_CACHE
 	bool
 
+config ALTRA_ERRATUM_82288
+	bool "Ampere Altra: 82288: PCIE_65: PCIe Root Port outbound write combining issue"
+	default y
+	help
+	  This option adds an alternative code sequence to work around
+	  Ampere Altra erratum 82288.
+
+	  PCIe device drivers may map MMIO space as Normal, non-cacheable
+	  memory attribute (e.g. Linux kernel drivers mapping MMIO
+	  using ioremap_wc). This may be for the purpose of enabling write
+	  combining or unaligned accesses. This can result in data corruption
+	  on the PCIe interface’s outbound MMIO writes due to issues with the
+	  write-combining operation.
+
+	  The workaround modifies software that maps PCIe MMIO space as Normal,
+	  non-cacheable memory (e.g. ioremap_wc) to instead Device,
+	  non-gatheringmemory (e.g. ioremap). And all memory operations on PCIe
+	  MMIO space must be strictly aligned.
+
+	  If unsure, say Y.
+
 config ARM64_ERRATUM_826319
 	bool "Cortex-A53: 826319: System might deadlock if a write cannot complete until read data is accepted"
 	default y
@@ -2388,4 +2409,3 @@ endmenu # "CPU Power Management"
 source "drivers/acpi/Kconfig"
 
 source "arch/arm64/kvm/Kconfig"
-
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 41fd90895dfc3..403b65f2f44de 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -273,6 +273,9 @@ __iowrite64_copy(void __iomem *to, const void *from, size_t count)
 
 #define ioremap_prot ioremap_prot
 
+pgprot_t ioremap_map_prot(phys_addr_t phys_addr, size_t size, unsigned long prot);
+#define ioremap_map_prot ioremap_map_prot
+
 #define _PAGE_IOREMAP PROT_DEVICE_nGnRE
 
 #define ioremap_wc(addr, size)	\
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 7a4f5604be3f7..f4603924390eb 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -236,11 +236,6 @@ static inline pte_t pte_mkyoung(pte_t pte)
 	return set_pte_bit(pte, __pgprot(PTE_AF));
 }
 
-static inline pte_t pte_mkspecial(pte_t pte)
-{
-	return set_pte_bit(pte, __pgprot(PTE_SPECIAL));
-}
-
 static inline pte_t pte_mkcont(pte_t pte)
 {
 	pte = set_pte_bit(pte, __pgprot(PTE_CONT));
@@ -682,6 +677,28 @@ static inline bool pud_table(pud_t pud) { return true; }
 				 PUD_TYPE_TABLE)
 #endif
 
+#ifdef CONFIG_ALTRA_ERRATUM_82288
+extern bool __read_mostly have_altra_erratum_82288;
+#endif
+
+static inline pte_t pte_mkspecial(pte_t pte)
+{
+#ifdef CONFIG_ALTRA_ERRATUM_82288
+	phys_addr_t phys = __pte_to_phys(pte);
+	pgprot_t prot = __pgprot(pte_val(pte) & ~PTE_ADDR_LOW);
+
+	if (unlikely(have_altra_erratum_82288) &&
+	    (phys < 0x80000000 ||
+	     (phys >= 0x200000000000 && phys < 0x400000000000) ||
+	     (phys >= 0x600000000000 && phys < 0x800000000000))) {
+		pte = __pte(__phys_to_pte_val(phys) | pgprot_val(pgprot_device(prot)));
+	}
+#endif
+
+	return set_pte_bit(pte, __pgprot(PTE_SPECIAL));
+}
+
+
 extern pgd_t init_pg_dir[];
 extern pgd_t init_pg_end[];
 extern pgd_t swapper_pg_dir[];
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index 269f2f63ab7dc..8965766181359 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -3,6 +3,33 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 
+#ifdef CONFIG_ALTRA_ERRATUM_82288
+
+bool have_altra_erratum_82288 __read_mostly;
+EXPORT_SYMBOL(have_altra_erratum_82288);
+
+static bool is_altra_pci(phys_addr_t phys_addr, size_t size)
+{
+	phys_addr_t end = phys_addr + size;
+
+	return (phys_addr < 0x80000000 ||
+		(end > 0x200000000000 && phys_addr < 0x400000000000) ||
+		(end > 0x600000000000 && phys_addr < 0x800000000000));
+}
+#endif
+
+pgprot_t ioremap_map_prot(phys_addr_t phys_addr, size_t size,
+                          unsigned long prot_val)
+{
+	pgprot_t prot = __pgprot(prot_val);
+#ifdef CONFIG_ALTRA_ERRATUM_82288
+	if (unlikely(have_altra_erratum_82288 && is_altra_pci(phys_addr, size))) {
+		prot = pgprot_device(prot);
+	}
+#endif
+	return prot;
+}
+
 void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 			   unsigned long prot)
 {
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index a2ce4e08edf5a..8baf90ee3357c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6234,6 +6234,15 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa73f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa76e, dpc_log_size);
 #endif
 
+#ifdef CONFIG_ALTRA_ERRATUM_82288
+static void quirk_altra_erratum_82288(struct pci_dev *dev)
+{
+	pr_info_once("Write combining PCI maps disabled due to hardware erratum\n");
+	have_altra_erratum_82288 = true;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMPERE, 0xe100, quirk_altra_erratum_82288);
+#endif
+
 /*
  * For a PCI device with multiple downstream devices, its driver may use
  * a flattened device tree to describe the downstream devices.
diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 80de699bf6af4..75670d7094537 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -1047,6 +1047,10 @@ static inline void iounmap(volatile void __iomem *addr)
 #elif defined(CONFIG_GENERIC_IOREMAP)
 #include <linux/pgtable.h>
 
+#ifndef ioremap_map_prot
+#define ioremap_map_prot(phys_addr, size, prot) __pgprot(prot)
+#endif
+
 void __iomem *generic_ioremap_prot(phys_addr_t phys_addr, size_t size,
 				   pgprot_t prot);
 
diff --git a/mm/ioremap.c b/mm/ioremap.c
index 3e049dfb28bd0..a4e6950682f33 100644
--- a/mm/ioremap.c
+++ b/mm/ioremap.c
@@ -52,7 +52,7 @@ void __iomem *generic_ioremap_prot(phys_addr_t phys_addr, size_t size,
 void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 			   unsigned long prot)
 {
-	return generic_ioremap_prot(phys_addr, size, __pgprot(prot));
+	return generic_ioremap_prot(phys_addr, size, ioremap_map_prot(phys_addr, size, prot));
 }
 EXPORT_SYMBOL(ioremap_prot);
 #endif
-- 
2.39.2

