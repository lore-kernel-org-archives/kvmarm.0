From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL v2 2/6] KVM: arm/arm64: vgic-v3: Fix nr_pre_bits bitfield extraction
Date: Wed,  7 Jun 2017 19:11:48 +0200
Message-ID: <20170607171152.21874-3-cdall@linaro.org>
References: <20170607171152.21874-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170607171152.21874-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
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
