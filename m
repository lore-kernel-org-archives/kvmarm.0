From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 27/27] KVM: arm/arm64: enable KVM_CAP_IOEVENTFD
Date: Thu,  2 Apr 2015 11:05:31 +0100
Message-ID: <1427969131-8445-28-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>

As the infrastructure for eventfd has now been merged, report the
ioeventfd capability as being supported.

Signed-off-by: Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>
[maz: grouped the case entry with the others, fixed commit log]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index e98370c..6f53645 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -172,6 +172,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
 	case KVM_CAP_IRQFD:
+	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SYNC_MMU:
-- 
2.1.4

