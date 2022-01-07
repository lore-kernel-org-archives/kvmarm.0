Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09F57C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 16:34:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6D124B227;
	Fri,  7 Jan 2022 11:34:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zhTmSiMl7Nz3; Fri,  7 Jan 2022 11:34:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D24394B2CD;
	Fri,  7 Jan 2022 11:34:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E66FE4B2A0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 11:34:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yeUf6jpCw61W for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 11:34:02 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C30494B227
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 11:34:02 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 85CD7B8266E;
 Fri,  7 Jan 2022 16:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5906AC36AEF;
 Fri,  7 Jan 2022 16:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1641573240;
 bh=kMM7H7e4NWLd0x88NZ2XUsacDPPAG7dNUs5nG4cFy6c=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=uHw6j0Fmtwgf0fsoAKqeeev5KP1Kx5Ez6QYDIastpIs0OPQ/U5MDIa7SxXm2Qi64e
 F01tAVyiJAD6VQApcrpDI3NCMHnHNXkQhSmsqaOTvdSKaOVF23gZLXtiWycKSJD1lZ
 O7ieBBmsDhvRUrumSKQ9OAJGvDdLb7kxDY0pIo8gY1EORSbjRunN23lBoU147IvwsZ
 qCotKK+8KcYYHevCfs0N5r/3J+fC04C66Mp1aOm2wayylKcqDRxtlDVIy1WQnsCebS
 q1BQtmTaZpvjDOcLDyk1GlmMeU1IwYv9+NM8hPUpFT4Pfro6UIKxI7haTSDj2h1VXL
 Rcompvy7sa3fA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n5sBi-00GbiJ-F6; Fri, 07 Jan 2022 16:33:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v4 2/6] hw/arm/virt: Add a control for the the highmem
 redistributors
Date: Fri,  7 Jan 2022 16:33:20 +0000
Message-Id: <20220107163324.2491209-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220107163324.2491209-1-maz@kernel.org>
References: <20220107163324.2491209-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com, drjones@redhat.com,
 eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Just like we can control the enablement of the highmem PCIe region
using highmem_ecam, let's add a control for the highmem GICv3
redistributor region.

Similarily to highmem_ecam, these redistributors are disabled when
highmem is off.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt-acpi-build.c | 2 ++
 hw/arm/virt.c            | 2 ++
 include/hw/arm/virt.h    | 4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
index cdac009419..505c61e88e 100644
--- a/hw/arm/virt-acpi-build.c
+++ b/hw/arm/virt-acpi-build.c
@@ -946,6 +946,8 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
     acpi_add_table(table_offsets, tables_blob);
     build_fadt_rev5(tables_blob, tables->linker, vms, dsdt);
 
+    vms->highmem_redists &= vms->highmem;
+
     acpi_add_table(table_offsets, tables_blob);
     build_madt(tables_blob, tables->linker, vms);
 
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index b9ce81f4a1..4d1d629432 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2106,6 +2106,7 @@ static void machvirt_init(MachineState *machine)
     virt_flash_fdt(vms, sysmem, secure_sysmem ?: sysmem);
 
     vms->highmem_mmio &= vms->highmem;
+    vms->highmem_redists &= vms->highmem;
 
     create_gic(vms, sysmem);
 
@@ -2805,6 +2806,7 @@ static void virt_instance_init(Object *obj)
 
     vms->highmem_ecam = !vmc->no_highmem_ecam;
     vms->highmem_mmio = true;
+    vms->highmem_redists = true;
 
     if (vmc->no_its) {
         vms->its = false;
diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index 9c54acd10d..dc9fa26faa 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -144,6 +144,7 @@ struct VirtMachineState {
     bool highmem;
     bool highmem_ecam;
     bool highmem_mmio;
+    bool highmem_redists;
     bool its;
     bool tcg_its;
     bool virt;
@@ -190,7 +191,8 @@ static inline int virt_gicv3_redist_region_count(VirtMachineState *vms)
 
     assert(vms->gic_version == VIRT_GIC_VERSION_3);
 
-    return MACHINE(vms)->smp.cpus > redist0_capacity ? 2 : 1;
+    return (MACHINE(vms)->smp.cpus > redist0_capacity &&
+            vms->highmem_redists) ? 2 : 1;
 }
 
 #endif /* QEMU_ARM_VIRT_H */
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
