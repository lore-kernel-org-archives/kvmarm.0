From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH] arm/arm64: KVM: Check for properly initialized timer on init
Date: Mon,  5 Dec 2016 10:32:11 +0100
Message-ID: <20161205093211.11870-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E42E0401E7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 04:31:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XfkQ2gT81Yf4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2016 04:31:13 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD3934005E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2016 04:31:13 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id f82so82993399wmf.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 05 Dec 2016 01:32:10 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

When the arch timer code fails to initialize (for example because the
memory mapped timer doesn't work, which is currently seen with the AEM
model), then KVM just continues happily with a final result that KVM
eventually does a NULL pointer dereference of the uninitialized cycle
counter.

Check directly for this in the init path and give the user a reasonable
error in this case.

Cc: Shih-Wei Li <shihwei@cs.columbia.edu>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 27a1f63..5c12f53 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -425,6 +425,11 @@ int kvm_timer_hyp_init(void)
 	info = arch_timer_get_kvm_info();
 	timecounter = &info->timecounter;
 
+	if (!timecounter->cc) {
+		kvm_err("arch_timer: uninitialized timecounter\n");
+		return -ENODEV;
+	}
+
 	if (info->virtual_irq <= 0) {
 		kvm_err("kvm_arch_timer: invalid virtual timer IRQ: %d\n",
 			info->virtual_irq);
-- 
2.9.0
