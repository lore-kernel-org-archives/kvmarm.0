From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 19/19] KVM: arm/arm64: Fix broken GICH_ELRSR big endian
 conversion
Date: Mon,  4 Dec 2017 15:03:48 +0100
Message-ID: <20171204140348.21965-17-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC3AF49DB5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:01:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G48-HSxkcE8e for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:01:15 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93D3849D9D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:01:06 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id t8so6002397wmc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Dec 2017 06:04:14 -0800 (PST)
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

We are incorrectly rearranging 32-bit words inside a 64-bit typed value
for big endian systems, which would result in never marking a virtual
interrupt as inactive on big endian systems (assuming 32 or fewer LRs on
the hardware).  Fix this by not doing any word order manipulation for
the typed values.

Cc: <stable@vger.kernel.org>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/hyp/vgic-v2-sr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/virt/kvm/arm/hyp/vgic-v2-sr.c b/virt/kvm/arm/hyp/vgic-v2-sr.c
index a3f18d362366..d7fd46fe9efb 100644
--- a/virt/kvm/arm/hyp/vgic-v2-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v2-sr.c
@@ -34,11 +34,7 @@ static void __hyp_text save_elrsr(struct kvm_vcpu *vcpu, void __iomem *base)
 	else
 		elrsr1 = 0;
 
-#ifdef CONFIG_CPU_BIG_ENDIAN
-	cpu_if->vgic_elrsr = ((u64)elrsr0 << 32) | elrsr1;
-#else
 	cpu_if->vgic_elrsr = ((u64)elrsr1 << 32) | elrsr0;
-#endif
 }
 
 static void __hyp_text save_lrs(struct kvm_vcpu *vcpu, void __iomem *base)
-- 
2.14.2
