From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 08/12] ARM: kvm: psci: fix handling of unimplemented functions
Date: Fri, 19 Jun 2015 13:53:12 +0100
Message-ID: <1434718396-13110-9-git-send-email-marc.zyngier@arm.com>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB67C561E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:43:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q-JZ6y8RENYk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2015 08:43:12 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1353561D7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:43:12 -0400 (EDT)
In-Reply-To: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org, Firo Yang <firogm@gmail.com>, Sudeep Holla <sudeep.holla@arm.com>, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, Tiejun Chen <tiejun.chen@intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

According to the PSCI specification and the SMC/HVC calling
convention, PSCI function_ids that are not implemented must
return NOT_SUPPORTED as return value.

Current KVM implementation takes an unhandled PSCI function_id
as an error and injects an undefined instruction into the guest
if PSCI implementation is called with a function_id that is not
handled by the resident PSCI version (ie it is not implemented),
which is not the behaviour expected by a guest when calling a
PSCI function_id that is not implemented.

This patch fixes this issue by returning NOT_SUPPORTED whenever
the kvm PSCI call is executed for a function_id that is not
implemented by the PSCI kvm layer.

Cc: <stable@vger.kernel.org> # 3.18+
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/psci.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/arm/kvm/psci.c b/arch/arm/kvm/psci.c
index 02fa8ef..531e922 100644
--- a/arch/arm/kvm/psci.c
+++ b/arch/arm/kvm/psci.c
@@ -230,10 +230,6 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 	case PSCI_0_2_FN64_AFFINITY_INFO:
 		val = kvm_psci_vcpu_affinity_info(vcpu);
 		break;
-	case PSCI_0_2_FN_MIGRATE:
-	case PSCI_0_2_FN64_MIGRATE:
-		val = PSCI_RET_NOT_SUPPORTED;
-		break;
 	case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
 		/*
 		 * Trusted OS is MP hence does not require migration
@@ -242,10 +238,6 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		 */
 		val = PSCI_0_2_TOS_MP;
 		break;
-	case PSCI_0_2_FN_MIGRATE_INFO_UP_CPU:
-	case PSCI_0_2_FN64_MIGRATE_INFO_UP_CPU:
-		val = PSCI_RET_NOT_SUPPORTED;
-		break;
 	case PSCI_0_2_FN_SYSTEM_OFF:
 		kvm_psci_system_off(vcpu);
 		/*
@@ -271,7 +263,8 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		ret = 0;
 		break;
 	default:
-		return -EINVAL;
+		val = PSCI_RET_NOT_SUPPORTED;
+		break;
 	}
 
 	*vcpu_reg(vcpu, 0) = val;
@@ -291,12 +284,9 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 	case KVM_PSCI_FN_CPU_ON:
 		val = kvm_psci_vcpu_on(vcpu);
 		break;
-	case KVM_PSCI_FN_CPU_SUSPEND:
-	case KVM_PSCI_FN_MIGRATE:
+	default:
 		val = PSCI_RET_NOT_SUPPORTED;
 		break;
-	default:
-		return -EINVAL;
 	}
 
 	*vcpu_reg(vcpu, 0) = val;
-- 
2.1.4
