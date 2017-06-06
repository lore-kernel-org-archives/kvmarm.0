From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 2/3] KVM: arm/arm64: vgic-v3: Fix nr_pre_bits bitfield
 extraction
Date: Tue,  6 Jun 2017 15:56:28 +0200
Message-ID: <20170606135629.31664-3-cdall@linaro.org>
References: <20170606135629.31664-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F34A140B58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 09:52:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2R398KZx7VMz for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Jun 2017 09:52:42 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EC3FC40C1D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Jun 2017 09:52:41 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id x70so37753199wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Jun 2017 06:56:47 -0700 (PDT)
In-Reply-To: <20170606135629.31664-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We used to extract PRIbits from the ICH_VT_EL2 which was the upper field
in the register word, so a mask wasn't necessary, but as we switched to
looking at PREbits, which is bits 26 through 28 with the PRIbits field
being potentially non-zero, we really need to mask off the field value,
otherwise fun things may happen.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/hyp/vgic-v3-sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
index 32c3295..8794036 100644
--- a/virt/kvm/arm/hyp/vgic-v3-sr.c
+++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
@@ -22,7 +22,7 @@
 #include <asm/kvm_hyp.h>
 
 #define vtr_to_max_lr_idx(v)		((v) & 0xf)
-#define vtr_to_nr_pre_bits(v)		(((u32)(v) >> 26) + 1)
+#define vtr_to_nr_pre_bits(v)		((((u32)(v) >> 26) & 7) + 1)
 
 static u64 __hyp_text __gic_v3_get_lr(unsigned int lr)
 {
-- 
2.9.0
