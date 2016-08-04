From: Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH 3/4] KVM: arm/arm64: Check for broadcast TLBI support
Date: Thu,  4 Aug 2016 11:15:16 +0200
Message-ID: <1470302117-32296-4-git-send-email-mbrugger@suse.com>
References: <1470302117-32296-1-git-send-email-mbrugger@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470302117-32296-1-git-send-email-mbrugger@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com
Cc: suzuki.poulose@arm.com, james.morse@arm.com, david.daney@cavium.com, rrichter@cavium.com, agraf@suse.de, mbrugger@suse.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com, dave.long@linaro.org, ard.biesheuvel@linaro.org, zlim.lnx@gmail.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

KVM awaits a working broadcast TLBI implementation.
Error out early when this is not provided by the
hardware.

Signed-off-by: Matthias Brugger <mbrugger@suse.com>
---
 arch/arm/kvm/arm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index f1bde7c..e627fac 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -1376,6 +1376,11 @@ int kvm_arch_init(void *opaque)
 	int err;
 	int ret, cpu;
 
+	if (cpus_have_cap(ARM64_HAS_NO_BCAST_TLBI)) {
+		kvm_err("Missing broadcast TLBI support.\n");
+		return -ENODEV;
+	}
+
 	if (!is_hyp_mode_available()) {
 		kvm_err("HYP mode not available\n");
 		return -ENODEV;
-- 
2.6.6
