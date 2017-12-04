From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 18/19] KVM: arm/arm64: kvm_arch_destroy_vm cleanups
Date: Mon,  4 Dec 2017 15:03:47 +0100
Message-ID: <20171204140348.21965-16-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andrew Jones <drjones@redhat.com>

kvm_vgic_vcpu_destroy already gets called from kvm_vgic_destroy for
each vcpu, so we don't have to call it from kvm_arch_vcpu_free.

Additionally the other architectures set kvm->online_vcpus to zero
after freeing them. We might as well do that for ARM too.

Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index ca65d06b38a8..675844c2174a 100644
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
2.14.2
