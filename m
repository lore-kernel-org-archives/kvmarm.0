From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 17/58] KVM: arm/arm64: timer: remove request-less vcpu kick
Date: Fri, 30 Jun 2017 09:44:33 +0100
Message-ID: <20170630084514.6779-18-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Alexander Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>, David Daney <david.daney@cavium.com>, Eric Auger <eric.auger@redhat.com>, Hu Huajun <huhuajun@huawei.com>, James Morse <james.morse@arm.com>, Mark Rutland <mark.rutland@arm.com>, Stefan Traby <stefan@hello-penguin.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andrew Jones <drjones@redhat.com>

The timer work is only scheduled for a VCPU when that VCPU is
blocked. This means we only need to wake it up, not kick (IPI)
it. While calling kvm_vcpu_kick() would just do the wake up,
and not kick, anyway, let's change this to avoid request-less
vcpu kicks, as they're generally not a good idea (see
"Request-less VCPU Kicks" in
Documentation/virtual/kvm/vcpu-requests.rst)

Signed-off-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 5976609ef27c..7933b1f8f7b7 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -95,7 +95,7 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
 	 * If the vcpu is blocked we want to wake it up so that it will see
 	 * the timer has expired when entering the guest.
 	 */
-	kvm_vcpu_kick(vcpu);
+	kvm_vcpu_wake_up(vcpu);
 }
 
 static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
-- 
2.11.0
