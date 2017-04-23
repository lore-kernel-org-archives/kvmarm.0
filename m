From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 52/79] ARM: Expose the VA/IDMAP offset
Date: Sun, 23 Apr 2017 19:09:02 +0200
Message-ID: <20170423170929.27334-53-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A58A49CED
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ahOc9uEnxfMu for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:41 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC56F49D11
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:40 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id r190so50454249wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:10:27 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The KVM code needs to be able to compute the address of
symbols in its idmap page (the equivalent of a virt_to_idmap()
call). Unfortunately, virt_to_idmap is slightly complicated,
depending on the use of arch_phys_to_idmap_offset or not, and
none of that is readily available at HYP.

Instead, expose a single kimage_voffset variable which contains the
offset between a kernel VA and its idmap address, enabling the
VA->IDMAP conversion. This allows the KVM code to behave similarily
to its arm64 counterpart.

Tested-by: Keerthy <j-keerthy@ti.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/mm/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 4e016d7..e98a2b5 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -87,6 +87,8 @@ struct cachepolicy {
 #define s2_policy(policy)	0
 #endif
 
+unsigned long kimage_voffset __ro_after_init;
+
 static struct cachepolicy cache_policies[] __initdata = {
 	{
 		.policy		= "uncached",
@@ -1635,4 +1637,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 
 	empty_zero_page = virt_to_page(zero_page);
 	__flush_dcache_page(NULL, empty_zero_page);
+
+	/* Compute the virt/idmap offset, mostly for the sake of KVM */
+	kimage_voffset = (unsigned long)&kimage_voffset - virt_to_idmap(&kimage_voffset);
 }
-- 
2.9.0
