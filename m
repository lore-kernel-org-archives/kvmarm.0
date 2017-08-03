From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/4] KVM: arm/arm64: Handle hva aging while destroying the vm
Date: Thu,  3 Aug 2017 16:28:56 +0100
Message-ID: <20170803152857.32055-4-marc.zyngier@arm.com>
References: <20170803152857.32055-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170803152857.32055-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Alex Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>, Suzuki K Poulose <suzuki.poulose@arm.com>, Suzuki K Poulose <Suzuki.Poulose@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <Suzuki.Poulose@arm.com>

The mmu_notifier_release() callback of KVM triggers cleaning up
the stage2 page table on kvm-arm. However there could be other
notifier callbacks in parallel with the mmu_notifier_release(),
which could cause the call backs ending up in an empty stage2
page table. Make sure we check it for all the notifier callbacks.

Cc: stable@vger.kernel.org
Fixes: commit 293f29363 ("kvm-arm: Unmap shadow pagetables properly")
Reported-by: Alex Graf <agraf@suse.de>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0e1fc75f3585..2ea21dac0b44 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1718,12 +1718,16 @@ static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 {
+	if (!kvm->arch.pgd)
+		return 0;
 	trace_kvm_age_hva(start, end);
 	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
 }
 
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 {
+	if (!kvm->arch.pgd)
+		return 0;
 	trace_kvm_test_age_hva(hva);
 	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
 }
-- 
2.11.0
