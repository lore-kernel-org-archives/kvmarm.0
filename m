From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: Handle possible NULL stage2 pud when ageing
 pages
Date: Mon,  5 Jun 2017 19:17:18 +0100
Message-ID: <20170605181718.6994-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73B2040A74
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 14:13:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UYqPcckGxsmA for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jun 2017 14:13:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04D9640969
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 14:13:34 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Under memory pressure, we start ageing pages, which amounts to parsing
the page tables. Since we don't want to allocate any extra level,
we pass NULL for our private allocation cache. Which means that
stage2_get_pud() is allowed to fail. This results in the following
splat:

[ 1520.409577] Unable to handle kernel NULL pointer dereference at virtual address 00000008
[ 1520.417741] pgd = ffff810f52fef000
[ 1520.421201] [00000008] *pgd=0000010f636c5003, *pud=0000010f56f48003, *pmd=0000000000000000
[ 1520.429546] Internal error: Oops: 96000006 [#1] PREEMPT SMP
[ 1520.435156] Modules linked in:
[ 1520.438246] CPU: 15 PID: 53550 Comm: qemu-system-aar Tainted: G        W       4.12.0-rc4-00027-g1885c397eaec #7205
[ 1520.448705] Hardware name: FOXCONN R2-1221R-A4/C2U4N_MB, BIOS G31FB12A 10/26/2016
[ 1520.463726] task: ffff800ac5fb4e00 task.stack: ffff800ce04e0000
[ 1520.469666] PC is at stage2_get_pmd+0x34/0x110
[ 1520.474119] LR is at kvm_age_hva_handler+0x44/0xf0
[ 1520.478917] pc : [<ffff0000080b137c>] lr : [<ffff0000080b149c>] pstate: 40000145
[ 1520.486325] sp : ffff800ce04e33d0
[ 1520.489644] x29: ffff800ce04e33d0 x28: 0000000ffff40064
[ 1520.494967] x27: 0000ffff27e00000 x26: 0000000000000000
[ 1520.500289] x25: ffff81051ba65008 x24: 0000ffff40065000
[ 1520.505618] x23: 0000ffff40064000 x22: 0000000000000000
[ 1520.510947] x21: ffff810f52b20000 x20: 0000000000000000
[ 1520.516274] x19: 0000000058264000 x18: 0000000000000000
[ 1520.521603] x17: 0000ffffa6fe7438 x16: ffff000008278b70
[ 1520.526940] x15: 000028ccd8000000 x14: 0000000000000008
[ 1520.532264] x13: ffff7e0018298000 x12: 0000000000000002
[ 1520.537582] x11: ffff000009241b93 x10: 0000000000000940
[ 1520.542908] x9 : ffff0000092ef800 x8 : 0000000000000200
[ 1520.548229] x7 : ffff800ce04e36a8 x6 : 0000000000000000
[ 1520.553552] x5 : 0000000000000001 x4 : 0000000000000000
[ 1520.558873] x3 : 0000000000000000 x2 : 0000000000000008
[ 1520.571696] x1 : ffff000008fd5000 x0 : ffff0000080b149c
[ 1520.577039] Process qemu-system-aar (pid: 53550, stack limit = 0xffff800ce04e0000)
[...]
[ 1521.510735] [<ffff0000080b137c>] stage2_get_pmd+0x34/0x110
[ 1521.516221] [<ffff0000080b149c>] kvm_age_hva_handler+0x44/0xf0
[ 1521.522054] [<ffff0000080b0610>] handle_hva_to_gpa+0xb8/0xe8
[ 1521.527716] [<ffff0000080b3434>] kvm_age_hva+0x44/0xf0
[ 1521.532854] [<ffff0000080a58b0>] kvm_mmu_notifier_clear_flush_young+0x70/0xc0
[ 1521.539992] [<ffff000008238378>] __mmu_notifier_clear_flush_young+0x88/0xd0
[ 1521.546958] [<ffff00000821eca0>] page_referenced_one+0xf0/0x188
[ 1521.552881] [<ffff00000821f36c>] rmap_walk_anon+0xec/0x250
[ 1521.558370] [<ffff000008220f78>] rmap_walk+0x78/0xa0
[ 1521.563337] [<ffff000008221104>] page_referenced+0x164/0x180
[ 1521.569002] [<ffff0000081f1af0>] shrink_active_list+0x178/0x3b8
[ 1521.574922] [<ffff0000081f2058>] shrink_node_memcg+0x328/0x600
[ 1521.580758] [<ffff0000081f23f4>] shrink_node+0xc4/0x328
[ 1521.585986] [<ffff0000081f2718>] do_try_to_free_pages+0xc0/0x340
[ 1521.592000] [<ffff0000081f2a64>] try_to_free_pages+0xcc/0x240
[...]

The trivial fix is to handle this NULL pud value early, rather than
dereferencing it blindly.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index a2d63247d1bb..e2e5effba2a9 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -879,6 +879,9 @@ static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache
 	pmd_t *pmd;
 
 	pud = stage2_get_pud(kvm, cache, addr);
+	if (!pud)
+		return NULL;
+
 	if (stage2_pud_none(*pud)) {
 		if (!cache)
 			return NULL;
-- 
2.11.0
