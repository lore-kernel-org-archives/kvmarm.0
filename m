From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm/arm64: KVM: Feed initialized memory to MMIO accesses
Date: Wed, 17 Feb 2016 15:34:20 +0000
Message-ID: <1455723260-23793-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On an MMIO access, we always copy the on-stack buffer info
the shared "run" structure, even if this is a read access.
This ends up leaking up to 8 bytes of uninitialized memory
into userspace.

An obvious fix for this one is to only perform the copy if
this is an actual write.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/mmio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/mmio.c b/arch/arm/kvm/mmio.c
index 7f33b20..0f6600f 100644
--- a/arch/arm/kvm/mmio.c
+++ b/arch/arm/kvm/mmio.c
@@ -206,7 +206,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	run->mmio.is_write	= is_write;
 	run->mmio.phys_addr	= fault_ipa;
 	run->mmio.len		= len;
-	memcpy(run->mmio.data, data_buf, len);
+	if (is_write)
+		memcpy(run->mmio.data, data_buf, len);
 
 	if (!ret) {
 		/* We handled the access successfully in the kernel. */
-- 
2.1.4

