From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 29/33] KVM: arm/arm64: Check vcpu redist base before
 registering an iodev
Date: Fri,  1 Jun 2018 16:27:43 +0100
Message-ID: <20180601152747.23613-30-marc.zyngier@arm.com>
References: <20180601152747.23613-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEB334A165
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:22:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iHJn6q+Z2iHm for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jun 2018 11:22:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89A1C4A17A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:18:14 -0400 (EDT)
In-Reply-To: <20180601152747.23613-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

As we are going to register several redist regions,
vgic_register_all_redist_iodevs() may be called several times. We need
to register a redist_iodev for a given vcpu only once. So let's
check if the base address has already been set. Initialize this latter
in kvm_vgic_vcpu_init().

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c    | 3 +++
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 272af9704952..2673efce65f3 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -199,6 +199,9 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	int ret = 0;
 	int i;
 
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	vgic_cpu->sgi_iodev.base_addr = VGIC_ADDR_UNDEF;
+
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
 	spin_lock_init(&vgic_cpu->ap_list_lock);
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 3dbc057f861b..1c6c535585e1 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -592,6 +592,9 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	gpa_t rd_base, sgi_base;
 	int ret;
 
+	if (!IS_VGIC_ADDR_UNDEF(vgic_cpu->rd_iodev.base_addr))
+		return 0;
+
 	/*
 	 * We may be creating VCPUs before having set the base address for the
 	 * redistributor region, in which case we will come back to this
-- 
2.17.1
