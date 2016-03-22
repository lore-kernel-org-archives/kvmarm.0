From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 1/3] KVM: arm/arm64: disable preemption when calling
 smp_call_function_many
Date: Tue, 22 Mar 2016 09:19:34 +0100
Message-ID: <1458634776-18388-2-git-send-email-christoffer.dall@linaro.org>
References: <1458634776-18388-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66BD940FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 04:18:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zToooluSronO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2016 04:18:40 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C2BB407AD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 04:18:39 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id p65so151942097wmp.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2016 01:19:18 -0700 (PDT)
In-Reply-To: <1458634776-18388-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

Preemption must be disabled when calling smp_call_function_many

Reported-by: bartosz.wawrzyniak@tieto.com
Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 3e0fb66..6accd66 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -373,7 +373,9 @@ static void exit_vm_noop(void *info)
 
 void force_vm_exit(const cpumask_t *mask)
 {
+	preempt_disable();
 	smp_call_function_many(mask, exit_vm_noop, NULL, true);
+	preempt_enable();
 }
 
 /**
-- 
2.1.2.330.g565301e.dirty
