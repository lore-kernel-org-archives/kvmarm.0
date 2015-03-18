From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 4/4] vga: flag vram as uncached
Date: Wed, 18 Mar 2015 15:11:48 -0400
Message-ID: <1426705908-2765-5-git-send-email-drjones@redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
 <1426705908-2765-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDE0C491C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:05:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZodgmrbbrWPF for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 15:05:22 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32B05491CB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:05:21 -0400 (EDT)
In-Reply-To: <1426705908-2765-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com
Cc: catalin.marinas@arm.com, lersek@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Video RAM is typically mapped as uncached by guests. Flag it as
such.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 hw/display/vga.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/display/vga.c b/hw/display/vga.c
index c0f7b343bbab5..5c8c249a8d780 100644
--- a/hw/display/vga.c
+++ b/hw/display/vga.c
@@ -2143,6 +2143,7 @@ void vga_common_init(VGACommonState *s, Object *obj, bool global_vmstate)
     s->is_vbe_vmstate = 1;
     memory_region_init_ram(&s->vram, obj, "vga.vram", s->vram_size,
                            &error_abort);
+    memory_region_set_uncached(&s->vram);
     vmstate_register_ram(&s->vram, global_vmstate ? NULL : DEVICE(obj));
     xen_register_framebuffer(&s->vram);
     s->vram_ptr = memory_region_get_ram_ptr(&s->vram);
-- 
1.8.3.1
