From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2 12/36] KVM: arm64: Remove kern_hyp_va() use in VHE switch function
Date: Thu,  7 Dec 2017 18:06:06 +0100
Message-ID: <20171207170630.592-13-christoffer.dall@linaro.org>
References: <20171207170630.592-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171207170630.592-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

VHE kernels run completely in EL2 and therefore don't have a notion of
kernel and hyp addresses, they are all just kernel addresses.  Therefore
don't call kern_hyp_va() in the VHE switch function.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp/switch.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8f32f8dcab65..eac2202a179c 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -349,9 +349,7 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
 
-	vcpu = kern_hyp_va(vcpu);
-
-	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
+	host_ctxt = vcpu->arch.host_cpu_context;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
 
-- 
2.14.2
