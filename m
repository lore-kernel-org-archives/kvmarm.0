From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: Close VMID generation race
Date: Mon,  9 Apr 2018 18:07:06 +0100
Message-ID: <20180409170706.23541-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <cdall@kernel.org>, Shannon Zhao <zhaoshenglong@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Before entering the guest, we check whether our VMID is still
part of the current generation. In order to avoid taking a lock,
we start with checking that the generation is still current, and
only if not current do we take the lock, recheck, and update the
generation and VMID.

This leaves open a small race: A vcpu can bump up the global
generation number as well as the VM's, but has not updated
the VMID itself yet.

At that point another vcpu from the same VM comes in, checks
the generation (and finds it not needing anything), and jumps
into the guest. At this point, we end-up with two vcpus belonging
to the same VM running with two different VMIDs. Eventually, the
VMID used by the second vcpu will get reassigned, and things will
really go wrong...

A simple solution would be to drop this initial check, and always take
the lock. This is likely to cause performance issues. A middle ground
is to convert the spinlock to a rwlock, and only take the read lock
on the fast path. If the check fails at that point, drop it and
acquire the write lock, rechecking the condition.

This ensures that the above scenario doesn't occur.

Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
I haven't seen any reply from Shannon, so reposting this to
a slightly wider audience for feedback.

 virt/kvm/arm/arm.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index dba629c5f8ac..a4c1b76240df 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -63,7 +63,7 @@ static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
 static atomic64_t kvm_vmid_gen = ATOMIC64_INIT(1);
 static u32 kvm_next_vmid;
 static unsigned int kvm_vmid_bits __read_mostly;
-static DEFINE_SPINLOCK(kvm_vmid_lock);
+static DEFINE_RWLOCK(kvm_vmid_lock);
 
 static bool vgic_present;
 
@@ -473,11 +473,16 @@ static void update_vttbr(struct kvm *kvm)
 {
 	phys_addr_t pgd_phys;
 	u64 vmid;
+	bool new_gen;
 
-	if (!need_new_vmid_gen(kvm))
+	read_lock(&kvm_vmid_lock);
+	new_gen = need_new_vmid_gen(kvm);
+	read_unlock(&kvm_vmid_lock);
+
+	if (!new_gen)
 		return;
 
-	spin_lock(&kvm_vmid_lock);
+	write_lock(&kvm_vmid_lock);
 
 	/*
 	 * We need to re-check the vmid_gen here to ensure that if another vcpu
@@ -485,7 +490,7 @@ static void update_vttbr(struct kvm *kvm)
 	 * use the same vmid.
 	 */
 	if (!need_new_vmid_gen(kvm)) {
-		spin_unlock(&kvm_vmid_lock);
+		write_unlock(&kvm_vmid_lock);
 		return;
 	}
 
@@ -519,7 +524,7 @@ static void update_vttbr(struct kvm *kvm)
 	vmid = ((u64)(kvm->arch.vmid) << VTTBR_VMID_SHIFT) & VTTBR_VMID_MASK(kvm_vmid_bits);
 	kvm->arch.vttbr = kvm_phys_to_vttbr(pgd_phys) | vmid;
 
-	spin_unlock(&kvm_vmid_lock);
+	write_unlock(&kvm_vmid_lock);
 }
 
 static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
-- 
2.14.2
