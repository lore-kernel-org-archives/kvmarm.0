From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 12/12] arm64: [HACK] Check that out-of-range SVE register
 IDs can't be dumped
Date: Fri, 18 Jan 2019 16:14:21 +0000
Message-ID: <1547828061-20462-13-git-send-email-Dave.Martin@arm.com>
References: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AF944A3C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:44 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nq1Dis0xcvUZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jan 2019 11:15:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D8814A3E3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jan 2019 11:15:41 -0500 (EST)
In-Reply-To: <1547828061-20462-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

As a sanity-check that invalid SVE register IDs can't be accessed
via KVM_GET_ONE_REG, this patch adds code to attempt to do just
that (at the expense of making dumping even slower).

Because of the way the register IDs are encoded, out-of-range slice
IDs may still result in a valid register encoding, so there is
nothing to test for that case.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arm/aarch64/kvm-cpu.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 28c5010..6b1580c 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -247,7 +247,7 @@ static void show_sve_zn_slice(int debug_fd, struct kvm_cpu const *vcpu,
 	sappendf(&strp, &strsz, " Z%.2u/%.2u:", n, i);
 	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
 		dprintf(debug_fd, "%s(%s)\n", str, strerror(errno));
-		if (vcpu->kvm->cfg.arch.has_sve)
+		if (n < 32 && vcpu->kvm->cfg.arch.has_sve)
 			die("Z-reg unexpectedly absent on SVE vcpu");
 
 		return;
@@ -256,6 +256,9 @@ static void show_sve_zn_slice(int debug_fd, struct kvm_cpu const *vcpu,
 	if (!vcpu->kvm->cfg.arch.has_sve)
 		die("Z-reg unexpectedly present on non-SVE vcpu");
 
+	if (n >= 32)
+		die("Out-of-range Z-reg unexpectedly present");
+
 	sappend_bytes(&strp, &strsz, bytes, sizeof bytes);
 	dprintf(debug_fd, "%s\n", str);
 }
@@ -292,7 +295,7 @@ static void show_sve_pn_slice(int debug_fd, struct kvm_cpu const *vcpu,
 
 	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0) {
 		dprintf(debug_fd, "%s(%s)\n", str, strerror(errno));
-		if (vcpu->kvm->cfg.arch.has_sve)
+		if (n < 16 + 1 /* FFR */ && vcpu->kvm->cfg.arch.has_sve)
 			die("P-reg unexpectedly absent on SVE vcpu");
 
 		return;
@@ -301,6 +304,9 @@ static void show_sve_pn_slice(int debug_fd, struct kvm_cpu const *vcpu,
 	if (!vcpu->kvm->cfg.arch.has_sve)
 		die("P-reg unexpectedly present on non-SVE vcpu");
 
+	if (n >= 16 && reg.id != KVM_REG_ARM64_SVE_FFR(i))
+		die("Out-of-range P-reg unexpectedly present");
+
 	sappend_bytes(&strp, &strsz, bytes, sizeof bytes);
 	dprintf(debug_fd, "%s\n", str);
 }
@@ -406,9 +412,9 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 		dprintf(debug_fd, " ZCR_EL1:0x%lx\n", data);
 	}
 
-	for (i = 0; i < 32; ++i)
+	for (i = 0; i < 32 + 1 /* should fail */; ++i)
 		show_sve_zn(debug_fd, vcpu, i);
 
-	for (i = 0; i < 16 + 1 /*FFR*/; ++i)
+	for (i = 0; i < 16 + 1 /* FFR */ + 1 /* should fail */; ++i)
 		show_sve_pn(debug_fd, vcpu, i);
 }
-- 
2.1.4
