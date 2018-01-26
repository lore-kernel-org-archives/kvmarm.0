From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 01/14] arm64: KVM: Fix SMCCC handling of unimplemented SMC/HVC
 calls
Date: Fri, 26 Jan 2018 14:28:34 +0000
Message-ID: <20180126142847.31240-2-marc.zyngier@arm.com>
References: <20180126142847.31240-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180126142847.31240-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Jon Masters <jcm@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

KVM doesn't follow the SMCCC when it comes to unimplemented calls,
and inject an UNDEF instead of returning an error. Since firmware
calls are now used for security mitigation, they are becoming more
common, and the undef is counter productive.

Instead, let's follow the SMCCC which states that -1 must be returned
to the caller when getting an unknown function number.

Cc: <stable@vger.kernel.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/handle_exit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index c09fc5a576c7..520b0dad3c62 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -53,7 +53,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	ret = kvm_psci_call(vcpu);
 	if (ret < 0) {
-		kvm_inject_undefined(vcpu);
+		vcpu_set_reg(vcpu, 0, ~0UL);
 		return 1;
 	}
 
@@ -62,7 +62,7 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	kvm_inject_undefined(vcpu);
+	vcpu_set_reg(vcpu, 0, ~0UL);
 	return 1;
 }
 
-- 
2.14.2
