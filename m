From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH] KVM: arm/arm64: inject an async abort to host if SEA handling failed
Date: Wed, 24 Apr 2019 12:41:47 +0800
Message-ID: <1556080907-25158-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: christoffer.dall@arm.com, marc.zyngier@arm.com, james.morse@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, zhengxiang9@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

If host failed to handle the SEA, KVM should inject an async abort
to guest for both SEA data and instruction abort, but it currently
only handles the data abort, so correct it.

Cc: James Morse <james.morse@arm.com>
Cc: Xiang Zheng <zhengxiang9@huawei.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 virt/kvm/arm/mmu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 27c9583..5882516 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1924,14 +1924,13 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		/*
 		 * For RAS the host kernel may handle this abort.
 		 * There is no need to pass the error into the guest.
+		 * If host failed to handle it, inject an async abort
+		 * to guest.
 		 */
-		if (!kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_hsr(vcpu)))
-			return 1;
-
-		if (unlikely(!is_iabt)) {
+		if (kvm_handle_guest_sea(fault_ipa, kvm_vcpu_get_hsr(vcpu)))
 			kvm_inject_vabt(vcpu);
-			return 1;
-		}
+
+		return 1;
 	}
 
 	trace_kvm_guest_fault(*vcpu_pc(vcpu), kvm_vcpu_get_hsr(vcpu),
-- 
2.7.4
