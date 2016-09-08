From: Rob Herring <robh@kernel.org>
Subject: [PATCH 2/2] kvmconfig: add virtio-gpu to config frag
Date: Thu,  8 Sep 2016 13:41:02 -0500
Message-ID: <20160908184102.8592-2-robh@kernel.org>
References: <20160908184102.8592-1-robh@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160908184102.8592-1-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

virtio-gpu is used for VMs, so add it to the kvm config.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org
---
 kernel/configs/kvm_guest.config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/configs/kvm_guest.config b/kernel/configs/kvm_guest.config
index 9906505..8d96437 100644
--- a/kernel/configs/kvm_guest.config
+++ b/kernel/configs/kvm_guest.config
@@ -29,3 +29,4 @@ CONFIG_NET_9P_VIRTIO=y
 CONFIG_SCSI_LOWLEVEL=y
 CONFIG_SCSI_VIRTIO=y
 CONFIG_VIRTIO_INPUT=y
+CONFIG_DRM_VIRTIO_GPU=y
-- 
2.9.3
