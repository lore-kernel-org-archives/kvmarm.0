From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v6 5/6] arm64/kvm: control accessibility of ptrauth key registers
Date: Tue, 19 Feb 2019 14:54:30 +0530
Message-ID: <1550568271-5319-6-git-send-email-amit.kachhap@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

According to userspace settings, ptrauth key registers are conditionally
present in guest system register list based on user specified flag
KVM_ARM_VCPU_PTRAUTH.

Reset routines still sets these registers to default values but they are
left like that as they are conditionally accessible (set/get).

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
This patch needs patch [1] by Dave Martin and adds feature to manage accessibility in a scalable way.

[1]: https://lore.kernel.org/linux-arm-kernel/1547757219-19439-13-git-send-email-Dave.Martin@arm.com/ 

 Documentation/arm64/pointer-authentication.txt | 4 ++++
 arch/arm64/kvm/sys_regs.c                      | 7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/arm64/pointer-authentication.txt b/Documentation/arm64/pointer-authentication.txt
index 0529a7d..996e435 100644
--- a/Documentation/arm64/pointer-authentication.txt
+++ b/Documentation/arm64/pointer-authentication.txt
@@ -87,3 +87,7 @@ created by passing a flag (KVM_ARM_VCPU_PTRAUTH) requesting this feature
 to be enabled. Without this flag, pointer authentication is not enabled
 in KVM guests and attempted use of the feature will result in an UNDEFINED
 exception being injected into the guest.
+
+Additionally, when KVM_ARM_VCPU_PTRAUTH is not set then KVM will filter
+out the Pointer Authentication system key registers from KVM_GET/SET_REG_*
+ioctls.
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f7bcc60..c2f4974 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1005,8 +1005,13 @@ static bool trap_ptrauth(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static bool check_ptrauth(const struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd)
+{
+	return kvm_arm_vcpu_ptrauth_allowed(vcpu);
+}
+
 #define __PTRAUTH_KEY(k)						\
-	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k }
+	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k , .check_present = check_ptrauth}
 
 #define PTRAUTH_KEY(k)							\
 	__PTRAUTH_KEY(k ## KEYLO_EL1),					\
-- 
2.7.4
