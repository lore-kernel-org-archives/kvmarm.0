From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH kvmtool 1/2] Prevent segfault when kvm_pause is called too early
Date: Fri,  3 Nov 2017 11:38:40 +0000
Message-ID: <20171103113841.3066-2-jean-philippe.brucker@arm.com>
References: <20171103113841.3066-1-jean-philippe.brucker@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171103113841.3066-1-jean-philippe.brucker@arm.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, andre.przywara@arm.com, punit.agrawal@arm.com, will.deacon@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

When kvm_pause is called early (from taking the rwlock), it segfaults
because the CPU array is initialized slightly later. Fix this.

This doesn't happen at the moment but the gicv2m patch will register an
MMIO region, which requires br_write_lock. gicv2m is instantiated by
kvm__arch_init from within core_init (level 0). The CPU array is
initialized later in base_init (level 1).

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kvm.c b/kvm.c
index 9078a026411b..7de825a9d063 100644
--- a/kvm.c
+++ b/kvm.c
@@ -512,7 +512,7 @@ void kvm__pause(struct kvm *kvm)
 	mutex_lock(&pause_lock);
 
 	/* Check if the guest is running */
-	if (!kvm->cpus[0] || kvm->cpus[0]->thread == 0)
+	if (!kvm->cpus || !kvm->cpus[0] || kvm->cpus[0]->thread == 0)
 		return;
 
 	pause_event = eventfd(0, 0);
-- 
2.14.3
