From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v3 04/10] KVM: arm/arm64: Add the EL1 physical timer context
Date: Wed,  1 Feb 2017 12:43:04 -0500
Message-ID: <1485970990-13775-5-git-send-email-jintack@cs.columbia.edu>
References: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F60240BD7
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:42:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xPAlOl8X6nwC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Feb 2017 12:42:57 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0419440C17
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:42:57 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v11He8YM001130
 for <kvmarm@lists.cs.columbia.edu>; Wed, 1 Feb 2017 12:43:18 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 8568A81
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:18 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 6E9E581
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Feb 2017 12:43:18 -0500 (EST)
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com
 [209.85.216.197])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v11HhITE019896
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Wed, 1 Feb 2017 12:43:18 -0500
Received: by mail-qt0-f197.google.com with SMTP id k15so400567726qtg.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Feb 2017 09:43:18 -0800 (PST)
In-Reply-To: <1485970990-13775-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Add the EL1 physical timer context.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 include/kvm/arm_arch_timer.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index f46fa3b..6445a3d 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -40,6 +40,7 @@ struct arch_timer_context {
 
 struct arch_timer_cpu {
 	struct arch_timer_context	vtimer;
+	struct arch_timer_context	ptimer;
 
 	/* Background timer used when the guest is not running */
 	struct hrtimer			timer;
@@ -75,4 +76,5 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 void kvm_timer_init_vhe(void);
 
 #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
+#define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.ptimer)
 #endif
-- 
1.9.1
