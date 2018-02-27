From: Christoffer Dall <cdall@kernel.org>
Subject: [PATCH v5 34/40] KVM: arm64: Cleanup __activate_traps and
 __deactive_traps for VHE and non-VHE
Date: Tue, 27 Feb 2018 12:34:23 +0100
Message-ID: <20180227113429.637-35-cdall@kernel.org>
References: <20180227113429.637-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180227113429.637-1-cdall@kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Tomasz Nowicki <tn@semihalf.com>, Julien Grall <julien.grall@arm.com>, Yury Norov <ynorov@caviumnetworks.com>, Dave Martin <Dave.Martin@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

To make the code more readable and to avoid the overhead of a function
call, let's get rid of a pair of the alternative function selectors and
explicitly call the VHE and non-VHE functions using the has_vhe() static
key based selector instead, telling the compiler to try to inline the
static function if it can.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Notes:
    Changes since v4:
     - Removed inline attributes from static functions in arch/arm64/kvm/hyp/switch.c

 arch/arm64/kvm/hyp/switch.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index eab433fa1442..67c66b4e237e 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -86,7 +86,7 @@ static void __hyp_text __deactivate_traps_common(void)
 	write_sysreg(0, pmuserenr_el0);
 }
 
-static void __hyp_text __activate_traps_vhe(struct kvm_vcpu *vcpu)
+static void activate_traps_vhe(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
@@ -109,10 +109,6 @@ static void __hyp_text __activate_traps_nvhe(struct kvm_vcpu *vcpu)
 	write_sysreg(val, cptr_el2);
 }
 
-static hyp_alternate_select(__activate_traps_arch,
-			    __activate_traps_nvhe, __activate_traps_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
 static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 hcr = vcpu->arch.hcr_el2;
@@ -123,10 +119,13 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
 
 	__activate_traps_fpsimd32(vcpu);
-	__activate_traps_arch()(vcpu);
+	if (has_vhe())
+		activate_traps_vhe(vcpu);
+	else
+		__activate_traps_nvhe(vcpu);
 }
 
-static void __hyp_text __deactivate_traps_vhe(void)
+static void deactivate_traps_vhe(void)
 {
 	extern char vectors[];	/* kernel exception vectors */
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
@@ -148,10 +147,6 @@ static void __hyp_text __deactivate_traps_nvhe(void)
 	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
 }
 
-static hyp_alternate_select(__deactivate_traps_arch,
-			    __deactivate_traps_nvhe, __deactivate_traps_vhe,
-			    ARM64_HAS_VIRT_HOST_EXTN);
-
 static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -163,7 +158,10 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.hcr_el2 & HCR_VSE)
 		vcpu->arch.hcr_el2 = read_sysreg(hcr_el2);
 
-	__deactivate_traps_arch()();
+	if (has_vhe())
+		deactivate_traps_vhe();
+	else
+		__deactivate_traps_nvhe();
 }
 
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
-- 
2.14.2
