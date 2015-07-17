From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 12/12] remove KVM_CAP_MAX_VCPUS hack
Date: Fri, 17 Jul 2015 17:02:18 +0100
Message-ID: <1437148938-5394-13-git-send-email-andre.przywara@arm.com>
References: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1437148938-5394-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, kvm@vger.kernel.org
Cc: Szabolcs.Nagy@arm.com, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we now have the header file in our repository, we can safely follow
the recommendation in kvm.c and remove the hack adding the
KVM_CAP_MAX_VCPUS macro.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 kvm.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kvm.c b/kvm.c
index 5222e1e..53e5c6b 100644
--- a/kvm.c
+++ b/kvm.c
@@ -223,14 +223,6 @@ int kvm__recommended_cpus(struct kvm *kvm)
 	return ret;
 }
 
-/*
- * The following hack should be removed once 'x86: Raise the hard
- * VCPU count limit' makes it's way into the mainline.
- */
-#ifndef KVM_CAP_MAX_VCPUS
-#define KVM_CAP_MAX_VCPUS 66
-#endif
-
 int kvm__max_cpus(struct kvm *kvm)
 {
 	int ret;
-- 
2.3.5

