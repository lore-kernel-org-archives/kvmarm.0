From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 5/6] vga: flag vram as incoherent
Date: Fri,  6 Mar 2015 13:53:37 -0500
Message-ID: <1425668018-3649-6-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425668018-3649-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A8C924802B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kb8xDcXaxEzJ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:47:46 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A88CA48016
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:44 -0500 (EST)
In-Reply-To: <1425668018-3649-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 hw/display/vga.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/display/vga.c b/hw/display/vga.c
index c8c49abc6e8ba..2b74eb8e96462 100644
--- a/hw/display/vga.c
+++ b/hw/display/vga.c
@@ -2135,6 +2135,7 @@ void vga_common_init(VGACommonState *s, Object *obj, bool global_vmstate)
     s->is_vbe_vmstate = 1;
     memory_region_init_ram(&s->vram, obj, "vga.vram", s->vram_size,
                            &error_abort);
+    memory_region_set_incoherent_cache(&s->vram);
     vmstate_register_ram(&s->vram, global_vmstate ? NULL : DEVICE(obj));
     xen_register_framebuffer(&s->vram);
     s->vram_ptr = memory_region_get_ram_ptr(&s->vram);
-- 
1.8.3.1
