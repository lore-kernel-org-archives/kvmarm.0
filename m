From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 11/20] ARM: Expose the VA/IDMAP offset
Date: Fri, 17 Feb 2017 15:44:20 +0000
Message-ID: <20170217154429.5000-12-marc.zyngier@arm.com>
References: <20170217154429.5000-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170217154429.5000-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The KVM code needs to be able to compute the address of
symbols in its idmap page (the equivalent of a virt_to_idmap()
call). Unfortunately, virt_to_idmap is slightly complicated,
depending on the use of arch_phys_to_idmap_offset or not, and
none of that is readily available at HYP.

Instead, expose a single kimage_voffset variable which contains the
offset between a kernel VA and its idmap address, enabling the
VA->IDMAP conversion. This allows the KVM code to behave similarily
to its arm64 counterpart.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/mm/mmu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 4001dd15818d..d9bb3ae876ad 100644
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
@@ -1654,4 +1656,7 @@ void __init paging_init(const struct machine_desc *mdesc)
 
 	empty_zero_page = virt_to_page(zero_page);
 	__flush_dcache_page(NULL, empty_zero_page);
+
+	/* Compute the virt/idmap offset, mostly for the sake of KVM */
+	kimage_voffset = (unsigned long)&kimage_voffset - virt_to_idmap(&kimage_voffset);
 }
-- 
2.11.0
