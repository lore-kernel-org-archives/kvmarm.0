From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 15/25] KVM: arm/arm64: vgic: Stop injecting the MSI occurrence
 twice
Date: Thu,  9 Feb 2017 14:59:13 +0000
Message-ID: <1486652363-7696-16-git-send-email-marc.zyngier@arm.com>
References: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 02AC640A63
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OAZDn2hNAMVp for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Feb 2017 09:59:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CA7F40C17
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Feb 2017 09:59:31 -0500 (EST)
In-Reply-To: <1486652363-7696-1-git-send-email-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shanker Donthineni <shankerd@codeaurora.org>

The IRQFD framework calls the architecture dependent function
twice if the corresponding GSI type is edge triggered. For ARM,
the function kvm_set_msi() is getting called twice whenever the
IRQFD receives the event signal. The rest of the code path is
trying to inject the MSI without any validation checks. No need
to call the function vgic_its_inject_msi() second time to avoid
an unnecessary overhead in IRQ queue logic. It also avoids the
possibility of VM seeing the MSI twice.

Simple fix, return -1 if the argument 'level' value is zero.

Cc: stable@vger.kernel.org
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-irqfd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index d918dcf..f138ed2 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -99,6 +99,9 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 	if (!vgic_has_its(kvm))
 		return -ENODEV;
 
+	if (!level)
+		return -1;
+
 	return vgic_its_inject_msi(kvm, &msi);
 }
 
-- 
2.1.4
