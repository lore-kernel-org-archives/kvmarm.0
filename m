From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 04/26] KVM: arm/arm64: vgic: Move kvm_vgic_destroy call around
Date: Fri,  6 Oct 2017 16:33:39 +0100
Message-ID: <20171006153401.5481-5-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The way we call kvm_vgic_destroy is a bit bizarre. We call it
*after* having freed the vcpus, which sort of defeats the point
of cleaning up things before that point.

Let's move kvm_vgic_destroy towards the beginning of kvm_arch_destroy_vm,
which seems more sensible.

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 7ac4ecba9ebd..5d5218ecd547 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -177,6 +177,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 {
 	int i;
 
+	kvm_vgic_destroy(kvm);
+
 	free_percpu(kvm->arch.last_vcpu_ran);
 	kvm->arch.last_vcpu_ran = NULL;
 
@@ -186,8 +188,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 			kvm->vcpus[i] = NULL;
 		}
 	}
-
-	kvm_vgic_destroy(kvm);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
-- 
2.14.1
