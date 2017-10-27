From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 05/26] KVM: arm/arm64: vgic: Move kvm_vgic_destroy call
 around
Date: Fri, 27 Oct 2017 15:28:34 +0100
Message-ID: <20171027142855.21584-6-marc.zyngier@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A115549D37
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:27:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OrlOJb-Iz33a for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 10:27:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1F2449D46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:27:57 -0400 (EDT)
In-Reply-To: <20171027142855.21584-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
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
2.11.0
