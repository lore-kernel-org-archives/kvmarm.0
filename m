From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 26/26] KVM: arm/arm64: fix the incompatible matching for external abort
Date: Tue,  7 Nov 2017 11:47:59 +0100
Message-ID: <20171107104800.30021-27-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Dongjiu Geng <gengdongjiu@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Dongjiu Geng <gengdongjiu@huawei.com>

kvm_vcpu_dabt_isextabt() tries to match a full fault syndrome, but
calls kvm_vcpu_trap_get_fault_type() that only returns the fault class,
thus reducing the scope of the check. This doesn't cause any observable
bug yet as we end-up matching a closely related syndrome for which we
return the same value.

Using kvm_vcpu_trap_get_fault() instead fixes it for good.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_emulate.h   | 2 +-
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index dcae3970148d..3d22eb87f919 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -233,7 +233,7 @@ static inline u8 kvm_vcpu_trap_get_fault_type(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_dabt_isextabt(struct kvm_vcpu *vcpu)
 {
-	switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
+	switch (kvm_vcpu_trap_get_fault(vcpu)) {
 	case FSC_SEA:
 	case FSC_SEA_TTW0:
 	case FSC_SEA_TTW1:
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index bf61da0ef82b..5f28dfa14cee 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -240,7 +240,7 @@ static inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vcpu)
 
 static inline bool kvm_vcpu_dabt_isextabt(const struct kvm_vcpu *vcpu)
 {
-	switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
+	switch (kvm_vcpu_trap_get_fault(vcpu)) {
 	case FSC_SEA:
 	case FSC_SEA_TTW0:
 	case FSC_SEA_TTW1:
-- 
2.14.2
