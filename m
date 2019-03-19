From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 2/2] KVM: arm/arm64: vgic-its: Take the srcu lock when parsing
 the memslots
Date: Tue, 19 Mar 2019 13:30:22 +0000
Message-ID: <20190319133022.10693-3-marc.zyngier@arm.com>
References: <20190319133022.10693-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 057904A484
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 09:30:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ikrfrRYdMQYM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Mar 2019 09:30:51 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3F694A486
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Mar 2019 09:30:51 -0400 (EDT)
In-Reply-To: <20190319133022.10693-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Calling kvm_is_visible_gfn() implies that we're parsing the memslots,
and doing this without the srcu lock is frown upon:

[12704.164532] =============================
[12704.164544] WARNING: suspicious RCU usage
[12704.164560] 5.1.0-rc1-00008-g600025238f51-dirty #16 Tainted: G        W
[12704.164573] -----------------------------
[12704.164589] ./include/linux/kvm_host.h:605 suspicious rcu_dereference_check() usage!
[12704.164602] other info that might help us debug this:
[12704.164616] rcu_scheduler_active = 2, debug_locks = 1
[12704.164631] 6 locks held by qemu-system-aar/13968:
[12704.164644]  #0: 000000007ebdae4f (&kvm->lock){+.+.}, at: vgic_its_set_attr+0x244/0x3a0
[12704.164691]  #1: 000000007d751022 (&its->its_lock){+.+.}, at: vgic_its_set_attr+0x250/0x3a0
[12704.164726]  #2: 00000000219d2706 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164761]  #3: 00000000a760aecd (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164794]  #4: 000000000ef8e31d (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164827]  #5: 000000007a872093 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xd0
[12704.164861] stack backtrace:
[12704.164878] CPU: 2 PID: 13968 Comm: qemu-system-aar Tainted: G        W         5.1.0-rc1-00008-g600025238f51-dirty #16
[12704.164887] Hardware name: rockchip evb_rk3399/evb_rk3399, BIOS 2019.04-rc3-00124-g2feec69fb1 03/15/2019
[12704.164896] Call trace:
[12704.164910]  dump_backtrace+0x0/0x138
[12704.164920]  show_stack+0x24/0x30
[12704.164934]  dump_stack+0xbc/0x104
[12704.164946]  lockdep_rcu_suspicious+0xcc/0x110
[12704.164958]  gfn_to_memslot+0x174/0x190
[12704.164969]  kvm_is_visible_gfn+0x28/0x70
[12704.164980]  vgic_its_check_id.isra.0+0xec/0x1e8
[12704.164991]  vgic_its_save_tables_v0+0x1ac/0x330
[12704.165001]  vgic_its_set_attr+0x298/0x3a0
[12704.165012]  kvm_device_ioctl_attr+0x9c/0xd8
[12704.165022]  kvm_device_ioctl+0x8c/0xf8
[12704.165035]  do_vfs_ioctl+0xc8/0x960
[12704.165045]  ksys_ioctl+0x8c/0xa0
[12704.165055]  __arm64_sys_ioctl+0x28/0x38
[12704.165067]  el0_svc_common+0xd8/0x138
[12704.165078]  el0_svc_handler+0x38/0x78
[12704.165089]  el0_svc+0x8/0xc

Make sure the lock is taken when doing this.

Fixes: bf308242ab98 ("KVM: arm/arm64: VGIC/ITS: protect kvm_read_guest() calls with SRCU lock")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index bb76220f2f30..7543f166943d 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -880,8 +880,9 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 	u64 indirect_ptr, type = GITS_BASER_TYPE(baser);
 	phys_addr_t base = GITS_BASER_ADDR_48_to_52(baser);
 	int esz = GITS_BASER_ENTRY_SIZE(baser);
-	int index;
+	int index, idx;
 	gfn_t gfn;
+	bool ret;
 
 	switch (type) {
 	case GITS_BASER_TYPE_DEVICE:
@@ -908,7 +909,8 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 
 		if (eaddr)
 			*eaddr = addr;
-		return kvm_is_visible_gfn(its->dev->kvm, gfn);
+
+		goto out;
 	}
 
 	/* calculate and check the index into the 1st level */
@@ -938,7 +940,12 @@ static bool vgic_its_check_id(struct vgic_its *its, u64 baser, u32 id,
 
 	if (eaddr)
 		*eaddr = indirect_ptr;
-	return kvm_is_visible_gfn(its->dev->kvm, gfn);
+
+out:
+	idx = srcu_read_lock(&its->dev->kvm->srcu);
+	ret = kvm_is_visible_gfn(its->dev->kvm, gfn);
+	srcu_read_unlock(&its->dev->kvm->srcu, idx);
+	return ret;
 }
 
 static int vgic_its_alloc_collection(struct vgic_its *its,
-- 
2.20.1
