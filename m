From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v11 4/4] hw/arm/virt: change indentation in a15memmap
Date: Wed,  4 Mar 2015 16:18:29 +0000
Message-ID: <1425485909-5091-5-git-send-email-eric.auger@linaro.org>
References: <1425485909-5091-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57AAB47B79
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:12:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A8vzoSUioBVp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Mar 2015 11:12:44 -0500 (EST)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E33DB47B5E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Mar 2015 11:12:43 -0500 (EST)
Received: by wivr20 with SMTP id r20so235032wiv.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Mar 2015 08:18:46 -0800 (PST)
In-Reply-To: <1425485909-5091-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, qemu-devel@nongnu.org, peter.maydell@linaro.org
Cc: patches@linaro.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Re-indent in a15memmap after VIRT_PLATFORM_BUS introduction

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/arm/virt.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index c3f4c54..e22a0fa 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -128,26 +128,26 @@ typedef struct {
  */
 static const MemMapEntry a15memmap[] = {
     /* Space up to 0x8000000 is reserved for a boot ROM */
-    [VIRT_FLASH] =      {          0, 0x08000000 },
-    [VIRT_CPUPERIPHS] = { 0x08000000, 0x00020000 },
+    [VIRT_FLASH] =          {          0, 0x08000000 },
+    [VIRT_CPUPERIPHS] =     { 0x08000000, 0x00020000 },
     /* GIC distributor and CPU interfaces sit inside the CPU peripheral space */
-    [VIRT_GIC_DIST] =   { 0x08000000, 0x00010000 },
-    [VIRT_GIC_CPU] =    { 0x08010000, 0x00010000 },
-    [VIRT_UART] =       { 0x09000000, 0x00001000 },
-    [VIRT_RTC] =        { 0x09010000, 0x00001000 },
-    [VIRT_FW_CFG] =     { 0x09020000, 0x0000000a },
+    [VIRT_GIC_DIST] =       { 0x08000000, 0x00010000 },
+    [VIRT_GIC_CPU] =        { 0x08010000, 0x00010000 },
+    [VIRT_UART] =           { 0x09000000, 0x00001000 },
+    [VIRT_RTC] =            { 0x09010000, 0x00001000 },
+    [VIRT_FW_CFG] =         { 0x09020000, 0x0000000a },
     [VIRT_PLATFORM_BUS] =   { 0x09400000, 0x00400000 },
-    [VIRT_MMIO] =       { 0x0a000000, 0x00000200 },
+    [VIRT_MMIO] =           { 0x0a000000, 0x00000200 },
     /* ...repeating for a total of NUM_VIRTIO_TRANSPORTS, each of that size */
     /*
      * PCIE verbose map:
      *
-     * MMIO window      { 0x10000000, 0x2eff0000 },
-     * PIO window       { 0x3eff0000, 0x00010000 },
-     * ECAM             { 0x3f000000, 0x01000000 },
+     * MMIO window          { 0x10000000, 0x2eff0000 },
+     * PIO window           { 0x3eff0000, 0x00010000 },
+     * ECAM                 { 0x3f000000, 0x01000000 },
      */
-    [VIRT_PCIE] =       { 0x10000000, 0x30000000 },
-    [VIRT_MEM] =        { 0x40000000, 30ULL * 1024 * 1024 * 1024 },
+    [VIRT_PCIE] =           { 0x10000000, 0x30000000 },
+    [VIRT_MEM] =            { 0x40000000, 30ULL * 1024 * 1024 * 1024 },
 };
 
 static const int a15irqmap[] = {
-- 
1.8.3.2
