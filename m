Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D72BC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 14 Jan 2022 14:08:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 097234A369;
	Fri, 14 Jan 2022 09:08:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NBG0icfWLrRD; Fri, 14 Jan 2022 09:08:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47E4B49ED8;
	Fri, 14 Jan 2022 09:08:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57B3849E3F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 09:08:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aqptzbychx-z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Jan 2022 09:08:08 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EAE0549E34
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Jan 2022 09:08:07 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D5CACB825F7;
 Fri, 14 Jan 2022 14:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB2FC36AEA;
 Fri, 14 Jan 2022 14:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1642169285;
 bh=+j7fPeRRv68KrVPtxSs60N+ZuvAsLE9Bw+2TU2jHgoQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=XvgKwbyKqtgukelVtUiizqfkGIiaERnOflKAXbG26u3EeRD42bMXvxuXVo/jJFlEb
 HHBmoF6ivfmMh+T2SuqWg9ysV1z+UiRhx3jxLpZhj/gSA1ULl8kpkht0h1Alde6+yx
 SbJI4dB2CKvDlrRuGlIo/MKWaqTUXaSOl6qwlF4tUa2hILhbhXIK23BkQYYkVZfQbX
 4bXNtveTLzFztTgJPugFXP6R1n2mZP9ZY5TtvaKlL5TwyA61TiFt2mOxXY5qtszedZ
 4hqd9QUJZebW1Q0SiuIs1rvTiuJG3uXcFTbp56Y0SDJqs9U6+CWo0mDuoAbz1r96gx
 tQdksv2LHEKZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1n8NFL-000V8K-KZ; Fri, 14 Jan 2022 14:08:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: qemu-devel@nongnu.org
Subject: [PATCH v5 5/6] hw/arm/virt: Disable highmem devices that don't fit in
 the PA range
Date: Fri, 14 Jan 2022 14:07:40 +0000
Message-Id: <20220114140741.1358263-6-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220114140741.1358263-1-maz@kernel.org>
References: <20220114140741.1358263-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, drjones@redhat.com,
 eric.auger@redhat.com, peter.maydell@linaro.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, kernel-team@android.com
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

In order to only keep the highmem devices that actually fit in
the PA range, check their location against the range and update
highest_gpa if they fit. If they don't, mark them as disabled.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 hw/arm/virt.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index a427676b50..053791cc44 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1712,21 +1712,43 @@ static void virt_set_memmap(VirtMachineState *vms, int pa_bits)
         base = vms->memmap[VIRT_MEM].base + LEGACY_RAMLIMIT_BYTES;
     }
 
+    /* We know for sure that at least the memory fits in the PA space */
+    vms->highest_gpa = memtop - 1;
+
     for (i = VIRT_LOWMEMMAP_LAST; i < ARRAY_SIZE(extended_memmap); i++) {
         hwaddr size = extended_memmap[i].size;
+        bool fits;
 
         base = ROUND_UP(base, size);
         vms->memmap[i].base = base;
         vms->memmap[i].size = size;
+
+        /*
+         * Check each device to see if they fit in the PA space,
+         * moving highest_gpa as we go.
+         *
+         * For each device that doesn't fit, disable it.
+         */
+        fits = (base + size) <= BIT_ULL(pa_bits);
+        if (fits) {
+            vms->highest_gpa = base + size - 1;
+        }
+
+        switch (i) {
+        case VIRT_HIGH_GIC_REDIST2:
+            vms->highmem_redists &= fits;
+            break;
+        case VIRT_HIGH_PCIE_ECAM:
+            vms->highmem_ecam &= fits;
+            break;
+        case VIRT_HIGH_PCIE_MMIO:
+            vms->highmem_mmio &= fits;
+            break;
+        }
+
         base += size;
     }
 
-    /*
-     * If base fits within pa_bits, all good. If it doesn't, limit it
-     * to the end of RAM, which is guaranteed to fit within pa_bits.
-     */
-    vms->highest_gpa = (base <= BIT_ULL(pa_bits) ? base : memtop) - 1;
-
     if (device_memory_size > 0) {
         ms->device_memory = g_malloc0(sizeof(*ms->device_memory));
         ms->device_memory->base = device_memory_base;
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
