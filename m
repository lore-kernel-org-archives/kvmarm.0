From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 06/37] KVM: arm/arm64: Only load/put VCPU state for KVM_RUN
Date: Thu, 12 Oct 2017 12:41:10 +0200
Message-ID: <20171012104141.26902-7-christoffer.dall@linaro.org>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171012104141.26902-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We only want to do things like invalidating TLBs or load timer state
onto the physical CPU if we really intend to run the VCPU, not if we are
simply retrieving some in-kernel value from userspace, for example.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 6e9513e..d495453 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -338,6 +338,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
 
+	if (vcpu->ioctl != KVM_RUN)
+		return;
+
 	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
 
 	/*
@@ -359,6 +362,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	if (vcpu->ioctl != KVM_RUN)
+		return;
+
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 
-- 
2.9.0
