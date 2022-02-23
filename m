Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2A1C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D2AF54C3DD;
	Tue, 22 Feb 2022 23:19:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rdoPVp4QNHkG; Tue, 22 Feb 2022 23:19:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ADB54C3D6;
	Tue, 22 Feb 2022 23:19:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FFC54C36A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oWQLBEfhS-WK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:08 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19D124C36B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:08 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2d7b96d74f8so25334517b3.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=EnWXwLktezdYxVf4VXehGQaziGIoOwllvHGoxXaFkSk=;
 b=NEjgsqtOFotB8rwtwgxw3nTKJIjcy3ygfSUnOerwYC8jtMBPV+WVzZP7gk6Sw+8rAQ
 slf46M+kM70WVhS9OC1Dftw3Fd9xageH2ezIhLlTlAULl2ZNqEtjXEmfHcoJ1z3leWRL
 Y2Q1TcuhaUfhM2y4Zu233zlNlZGcXS3xiPunbw9VaVelj8gALfVkGtKFjWS3HblWVNcC
 NT9R6s5QfOf9QdyEMQqnPnfyVE5Wy62eKrQt/uytmG3x55QlnmP9RAbpQYjYLerhDRcE
 OfRn3H4RXHIkN70lq1/ZumftMAc3OSme/5IwSAT1z1FCoR/lHXYabE0J7Det7jXyh8pM
 WGOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EnWXwLktezdYxVf4VXehGQaziGIoOwllvHGoxXaFkSk=;
 b=cuhwgJ5S6jjf28mz1vOnnM9XbOqI1tr0OpKtzi+v2ZbUGgh7ICNq45V5UAc0sCd+Ha
 Hm/MBVYt9+SwfI3C8nROdGlxfLxJQghTID4YZF0tjXSPoDzNd4ZeGQ7Q4nYbq8to+0X3
 /hbd0NZ3Lpejr9fsmOmtgOGLpRFKMBj5ADf1ZdkdVhA3EwZEUhu6Plc89FN/VC/1lWag
 z8as52OjkJqYcM9l4SG8cIoi4WePya5Y+osyftwHczNuOly+rm/JZ4dl0PCn4KPYuT5M
 xco+cldNGrLcO2l3DmXzCzt58d6dHWlvO4uXHlja8wVsiNDp5z7xa/7RFIMfEZS1vAqr
 IBOQ==
X-Gm-Message-State: AOAM5304+RXij1RVdbZrrH5qO0v2Gofz8DmtY0U5PFImPJMAToD6fDBH
 M0bEUhI9CPLfUKUs6/wuoqAh7czz+RC+gEzWno5MHQ7pnhytuZFuvRgvdjXGRA8gtUemE1mmwwd
 e1pZIC3zQB4sRzKTylHOVLhhAepOd1/7zb+5ZTCs/vkYWc2VW5YdQuPodosbXhjdQ0TO4oA==
X-Google-Smtp-Source: ABdhPJyjm1Ng5s7CW1KhrIyzYIpmZbuuYhZ/Y0UPWEqvGtpWPaulnfintVKcauly/pEhuTNpasU+6iJod1Q=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:8b0a:0:b0:61a:4aab:3e78 with
 SMTP id
 i10-20020a258b0a000000b0061a4aab3e78mr26177594ybl.619.1645589946470; Tue, 22
 Feb 2022 20:19:06 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:27 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-3-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 02/19] KVM: arm64: Create a helper to check if IPA is valid
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Create a helper that tests if a given IPA fits within the guest's
address space.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h      | 9 +++++++++
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 81839e9a8a24..78e8be7ea627 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -111,6 +111,7 @@ alternative_cb_end
 #else
 
 #include <linux/pgtable.h>
+#include <linux/kvm_host.h>
 #include <asm/pgalloc.h>
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
@@ -147,6 +148,14 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
 #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
 
+/*
+ * Returns true if the provided IPA exists within the VM's IPA space.
+ */
+static inline bool kvm_ipa_valid(struct kvm *kvm, phys_addr_t guest_ipa)
+{
+	return !(guest_ipa & ~kvm_phys_mask(kvm));
+}
+
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index c6d52a1fd9c8..e3853a75cb00 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -27,7 +27,7 @@ int vgic_check_iorange(struct kvm *kvm, phys_addr_t ioaddr,
 	if (addr + size < addr)
 		return -EINVAL;
 
-	if (addr & ~kvm_phys_mask(kvm) || addr + size > kvm_phys_size(kvm))
+	if (!kvm_ipa_valid(kvm, addr) || addr + size > kvm_phys_size(kvm))
 		return -E2BIG;
 
 	return 0;
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
