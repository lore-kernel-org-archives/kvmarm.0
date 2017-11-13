From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 03/27] KVM: arm: Select ARM_GIC_V3 and ARM_GIC_V3_ITS
Date: Mon, 13 Nov 2017 10:17:28 +0100
Message-ID: <20171113091752.10663-4-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D11649DA9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:15:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m7LvnnvL5q-p for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:15:47 -0500 (EST)
Received: from mail-wr0-f195.google.com (mail-wr0-f195.google.com
 [209.85.128.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4A3749D96
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:15:47 -0500 (EST)
Received: by mail-wr0-f195.google.com with SMTP id u40so13764930wrf.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:17:58 -0800 (PST)
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

The GICv4 support introduces a hard dependency between the KVM
core and the ITS infrastructure. arm64 already selects it at
the architecture level, but 32bit doesn't. In order to avoid
littering the kernel with #ifdefs, let's just select the whole
of the GICv3 suport code.

You know you want it.

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 4e2b192a030a..52b50af04e3b 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -23,6 +23,8 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select ARM_GIC
+	select ARM_GIC_V3
+	select ARM_GIC_V3_ITS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
 	select KVM_MMIO
-- 
2.14.2
