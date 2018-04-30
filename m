From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v6 08/12] KVM: arm/arm64: Check vcpu redist base before registering an iodev
Date: Mon, 30 Apr 2018 13:48:34 +0200
Message-ID: <1525088918-8600-9-git-send-email-eric.auger@redhat.com>
References: <1525088918-8600-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525088918-8600-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

As we are going to register several redist regions,
vgic_register_all_redist_iodevs() may be called several times. We need
to register a redist_iodev for a given vcpu only once. So let's
check if the base address has already been set. Initialize this latter
in kvm_vgic_vcpu_early_init().

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>

---

v4 -> v5:
- added Christoffer's A-b
---
 virt/kvm/arm/vgic/vgic-init.c    | 3 +++
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 6456371..7e040e7 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -82,6 +82,9 @@ void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu)
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
 	spin_lock_init(&vgic_cpu->ap_list_lock);
 
+	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
+	vgic_cpu->sgi_iodev.base_addr = VGIC_ADDR_UNDEF;
+
 	/*
 	 * Enable and configure all SGIs to be edge-triggered and
 	 * configure all PPIs as level-triggered.
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 3dbc057..1c6c535 100644
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
2.5.5
