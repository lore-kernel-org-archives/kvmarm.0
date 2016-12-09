From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 5/6] KVM: arm/arm64: timer: Check for properly initialized timer on init
Date: Fri,  9 Dec 2016 15:53:30 +0000
Message-ID: <1481298811-30798-6-git-send-email-marc.zyngier@arm.com>
References: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Andre Przywara <andre.przywara@arm.com>, Longpeng <longpeng2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

When the arch timer code fails to initialize (for example because the
memory mapped timer doesn't work, which is currently seen with the AEM
model), then KVM just continues happily with a final result that KVM
eventually does a NULL pointer dereference of the uninitialized cycle
counter.

Check directly for this in the init path and give the user a reasonable
error in this case.

Cc: Shih-Wei Li <shihwei@cs.columbia.edu>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 17b8fa5..ae95fc0 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -425,6 +425,11 @@ int kvm_timer_hyp_init(void)
 	info = arch_timer_get_kvm_info();
 	timecounter = &info->timecounter;
 
+	if (!timecounter->cc) {
+		kvm_err("kvm_arch_timer: uninitialized timecounter\n");
+		return -ENODEV;
+	}
+
 	if (info->virtual_irq <= 0) {
 		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
 			info->virtual_irq);
-- 
2.1.4

