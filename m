From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH] KVM: arm/arm64: kvm_arch_destroy_vm cleanups
Date: Mon, 27 Nov 2017 19:17:18 +0100
Message-ID: <20171127181718.5290-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A945B49D90
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 13:14:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sQLkL75H2xSZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 27 Nov 2017 13:14:32 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA8BC49D7A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 27 Nov 2017 13:14:32 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Recently commit b2c9a85dd75a ("KVM: arm/arm64: vgic: Move
kvm_vgic_destroy call around") caught my eye. When I looked closer I
saw that while it made the code saner, it wasn't changing anything.
kvm_for_each_vcpu() checks for NULL kvm->vcpus[i], so there wasn't
a NULL dereference being fixed, and because kvm_vgic_vcpu_destroy()
was called by kvm_arch_vcpu_free() it was still getting called, just
not by kvm_vgic_destroy() as intended. But now the call from
kvm_arch_vcpu_free() is redundant, and while currently harmless, it
should be removed in case kvm_vgic_vcpu_destroy() were ever to
want to reference vgic state, as kvm_vgic_destroy() now comes before
kvm_arch_vcpu_free(). Additionally the other architectures set
kvm->online_vcpus to zero after freeing them. We might as well do
that for ARM too.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 virt/kvm/arm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index a6524ff27de4..c5bc79c4ccf7 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -188,6 +188,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 			kvm->vcpus[i] = NULL;
 		}
 	}
+	atomic_set(&kvm->online_vcpus, 0);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
@@ -296,7 +297,6 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_caches(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
-	kvm_vgic_vcpu_destroy(vcpu);
 	kvm_pmu_vcpu_destroy(vcpu);
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
-- 
2.13.6
