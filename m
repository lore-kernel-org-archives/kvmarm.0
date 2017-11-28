From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] kvm: arm: don't treat unavailable HYP mode as an error
Date: Tue, 28 Nov 2017 15:18:19 +0000
Message-ID: <20171128151819.18669-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4452149D6B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Nov 2017 10:16:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fQtVSsv+Y8EG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Nov 2017 10:16:02 -0500 (EST)
Received: from mail-wr0-f196.google.com (mail-wr0-f196.google.com
 [209.85.128.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 106DC49D09
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Nov 2017 10:16:02 -0500 (EST)
Received: by mail-wr0-f196.google.com with SMTP id v105so372012wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Nov 2017 07:18:53 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Since it is perfectly legal to run the kernel at EL1, it is not
actually an error if HYP mode is not available when attempting to
initialize KVM, given that KVM support cannot be built as a module.
So demote the kvm_err() to kvm_info(), which prevents the error from
appearing on an otherwise 'quiet' console.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 virt/kvm/arm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 772bf74ac2e9..988c888a9667 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1460,7 +1460,7 @@ int kvm_arch_init(void *opaque)
 	bool in_hyp_mode;
 
 	if (!is_hyp_mode_available()) {
-		kvm_err("HYP mode not available\n");
+		kvm_info("HYP mode not available\n");
 		return -ENODEV;
 	}
 
-- 
2.11.0
