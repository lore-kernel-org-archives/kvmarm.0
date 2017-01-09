From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 16/55] KVM: arm64: Forward VM reg traps to the guest hypervisor
Date: Mon,  9 Jan 2017 01:24:12 -0500
Message-ID: <1483943091-1364-17-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FBF0400FC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tLBHEoCjPPF7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:12 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 764AE406B8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:12 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PWY7017300
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:54 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 1AFEA86
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:54 -0500 (EST)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu
 [128.59.72.13]) by hazelnut (Postfix) with ESMTP id D60AE8E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:25:53 -0500 (EST)
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com
 [209.85.216.197])
 by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Praj040819
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:25:53 -0500
Received: by mail-qt0-f197.google.com with SMTP id a29so74187434qtb.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:25:53 -0800 (PST)
In-Reply-To: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, vladimir.murzin@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, james.morse@arm.com, lorenzo.pieralisi@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, shankerd@codeaurora.org, geoff@infradead.org, andre.przywara@arm.com, eric.auger@redhat.com, anna-maria@linutronix.de, shihwei@cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Forward virtual memory register traps to the guest hypervisor
if it has set corresponding bits to the virtual HCR_EL2.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/sys_regs.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b8e993a..0f5d21b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -90,6 +90,23 @@ static bool access_dcsw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool forward_vm_traps(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
+{
+	u64 hcr_el2 = vcpu_el2_reg(vcpu, HCR_EL2);
+
+	/* If this is a trap from the virtual EL2, the host handles */
+	if (vcpu_mode_el2(vcpu))
+		return false;
+
+	/* If the guest wants to trap on R/W operation, forward this trap */
+	if ((hcr_el2 & HCR_TVM) && p->is_write)
+		return true;
+	else if ((hcr_el2 & HCR_TRVM) && !p->is_write)
+		return true;
+
+	return false;
+}
+
 /*
  * Generic accessor for VM registers. Only called as long as HCR_TVM
  * is set. If the guest enables the MMU, we stop trapping the VM
@@ -101,6 +118,9 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 {
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 
+	if (forward_vm_traps(vcpu, p))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
 	BUG_ON(!vcpu_mode_el2(vcpu) && !p->is_write);
 
 	if (!p->is_write) {
-- 
1.9.1
