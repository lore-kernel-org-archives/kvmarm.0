From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 0090/1529] Fix typo
Date: Sat, 21 May 2016 13:48:35 +0200
Message-ID: <20160521114835.4026-1-andrea.gelmini@gelma.net>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: andrea.gelmini@gelma.net
Cc: trivial@kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 arch/arm/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 237d5d8..16e38f4 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -376,7 +376,7 @@ void force_vm_exit(const cpumask_t *mask)
 
 /**
  * need_new_vmid_gen - check that the VMID is still valid
- * @kvm: The VM's VMID to checkt
+ * @kvm: The VM's VMID to check
  *
  * return true if there is a new generation of VMIDs being used
  *
-- 
2.8.2.534.g1f66975

