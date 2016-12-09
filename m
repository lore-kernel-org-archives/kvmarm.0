From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/6] arm/arm64: KVM: Clean up useless code in kvm_timer_enable
Date: Fri,  9 Dec 2016 15:53:28 +0000
Message-ID: <1481298811-30798-4-git-send-email-marc.zyngier@arm.com>
References: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1481298811-30798-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Christoffer Dall <christoffer.dall@linaro.org>, Will Deacon <will.deacon@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, Andre Przywara <andre.przywara@arm.com>, Longpeng <longpeng2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: "Longpeng(Mike)" <longpeng2@huawei.com>

1) Since commit:41a54482 changed timer enabled variable to per-vcpu,
   the correlative comment in kvm_timer_enable is useless now.

2) After the kvm module init successfully, the timecounter is always
   non-null, so we can remove the checking of timercounter.

Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/arch_timer.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 27a1f63..17b8fa5 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -498,17 +498,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-
-	/*
-	 * There is a potential race here between VCPUs starting for the first
-	 * time, which may be enabling the timer multiple times.  That doesn't
-	 * hurt though, because we're just setting a variable to the same
-	 * variable that it already was.  The important thing is that all
-	 * VCPUs have the enabled variable set, before entering the guest, if
-	 * the arch timers are enabled.
-	 */
-	if (timecounter)
-		timer->enabled = 1;
+	timer->enabled = 1;
 
 	return 0;
 }
-- 
2.1.4

