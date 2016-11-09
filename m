From: "Longpeng(Mike)" <longpeng2@huawei.com>
Subject: [PATCH] arm/arm64: KVM: clean up useless code in kvm_timer_enable
Date: Wed, 9 Nov 2016 10:50:14 +0800
Message-ID: <1478659814-364872-1-git-send-email-longpeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: pbonzini@redhat.com, rkrcmar@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zhaoshenglong@huawei.com, wu.wubin@huawei.com, "Longpeng(Mike)" <longpeng2@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

1) Since commit:41a54482 changed timer enabled variable to per-vcpu,
   the correlative comment in kvm_timer_enable is useless now.

2) After the kvm module init successfully, the timecounter is always
   non-null, so we can remove the checking of timercounter.

Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
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
1.8.3.1


