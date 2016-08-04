From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 8/8] arm64: KVM: Set cpsr before spsr on fault injection
Date: Thu,  4 Aug 2016 13:40:36 +0200
Message-ID: <1470310836-10371-9-git-send-email-christoffer.dall@linaro.org>
References: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E27A249AF5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:34:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nMBWKfDWdUsi for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2016 07:34:16 -0400 (EDT)
Received: from mail-lf0-f54.google.com (mail-lf0-f54.google.com
 [209.85.215.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE8A4410B5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:34:15 -0400 (EDT)
Received: by mail-lf0-f54.google.com with SMTP id b199so180624619lfe.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2016 04:41:08 -0700 (PDT)
In-Reply-To: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andrew Jones <drjones@redhat.com>

We need to set cpsr before determining the spsr bank, as the bank
depends on the target exception level of the injection, not the
current mode of the vcpu. Normally this is one in the same (EL1),
but not when we manage to trap an EL0 fault. It still doesn't really
matter for the 64-bit EL0 case though, as vcpu_spsr() unconditionally
uses the EL1 bank for that. However the 32-bit EL0 case gets fun, as
that path will lead to the BUG() in vcpu_spsr32().

This patch fixes the assignment order and also modifies some white
space in order to better group pairs of lines that have strict order.

Cc: stable@vger.kernel.org # v4.5
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/inject_fault.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index e9e0e6d..898c0e6 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -132,16 +132,14 @@ static u64 get_except_vector(struct kvm_vcpu *vcpu, enum exception_type type)
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
-	bool is_aarch32;
+	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
-	is_aarch32 = vcpu_mode_is_32bit(vcpu);
-
-	*vcpu_spsr(vcpu) = cpsr;
 	*vcpu_elr_el1(vcpu) = *vcpu_pc(vcpu);
-
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
+
 	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
+	*vcpu_spsr(vcpu) = cpsr;
 
 	vcpu_sys_reg(vcpu, FAR_EL1) = addr;
 
@@ -172,11 +170,11 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	*vcpu_spsr(vcpu) = cpsr;
 	*vcpu_elr_el1(vcpu) = *vcpu_pc(vcpu);
-
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
+
 	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
+	*vcpu_spsr(vcpu) = cpsr;
 
 	/*
 	 * Build an unknown exception, depending on the instruction
-- 
1.9.1
