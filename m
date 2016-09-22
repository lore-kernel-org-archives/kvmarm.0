From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH] arm64: KVM: Remove duplicating init code for setting VMID
Date: Thu, 22 Sep 2016 09:18:01 +0100
Message-ID: <1474532281-37917-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4796549B47
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 04:09:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lqnBp+uxdd7n for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 04:09:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1FF341267
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 04:09:10 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

By now both VHE and non-VHE initialisation sequences query supported
VMID size. Lets keep only single instance of this code under
init_common_resources().

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/kvm/arm.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 75f130e..85a3f90 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1178,6 +1178,10 @@ static int init_common_resources(void)
 		return -ENOMEM;
 	}
 
+	/* set size of VMID supported by CPU */
+	kvm_vmid_bits = kvm_get_vmid_bits();
+	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
+
 	return 0;
 }
 
@@ -1243,10 +1247,6 @@ static void teardown_hyp_mode(void)
 
 static int init_vhe_mode(void)
 {
-	/* set size of VMID supported by CPU */
-	kvm_vmid_bits = kvm_get_vmid_bits();
-	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
-
 	kvm_info("VHE mode initialized successfully\n");
 	return 0;
 }
@@ -1330,10 +1330,6 @@ static int init_hyp_mode(void)
 		}
 	}
 
-	/* set size of VMID supported by CPU */
-	kvm_vmid_bits = kvm_get_vmid_bits();
-	kvm_info("%d-bit VMID\n", kvm_vmid_bits);
-
 	kvm_info("Hyp mode initialized successfully\n");
 
 	return 0;
-- 
1.7.9.5
