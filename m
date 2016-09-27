From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 47/50] arm64: KVM: Remove duplicating init code for setting VMID
Date: Tue, 27 Sep 2016 20:05:55 +0200
Message-ID: <20160927180558.14699-48-christoffer.dall@linaro.org>
References: <20160927180558.14699-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 196B849B79
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id R+emIOtsOZyU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 13:57:14 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C02EA49BFA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 13:57:11 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id l132so26967786wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 11:06:35 -0700 (PDT)
In-Reply-To: <20160927180558.14699-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Vladimir Murzin <vladimir.murzin@arm.com>

By now both VHE and non-VHE initialisation sequences query supported
VMID size. Lets keep only single instance of this code under
init_common_resources().

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 12 ++++--------
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
2.9.0
