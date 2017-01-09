From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 22/55] KVM: arm64: Handle PSCI call from the guest
Date: Mon,  9 Jan 2017 01:24:18 -0500
Message-ID: <1483943091-1364-23-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCA5C404E4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TTWkE5gcJs6s for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:20 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0141840696
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:20 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PXvI017320
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:01 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 973E86D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:01 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id 711636D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:01 -0500 (EST)
Received: from mail-qt0-f197.google.com (mail-qt0-f197.google.com
 [209.85.216.197])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q1DE042205
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:01 -0500
Received: by mail-qt0-f197.google.com with SMTP id f4so58596159qte.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:01 -0800 (PST)
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

VMs used to execute hvc #0 for the psci call. However, when we come to
provide virtual EL2 to the VM, the host OS inside the VM also calls
kvm_call_hyp which is also hvc #0. So, it's hard to differentiate
between them from the host hypervisor's point of view.

So, let the VM execute smc for the psci call. On ARMv8.3, even if EL3 is
not implemented, a smc instruction executed at non-secure EL1 is trapped
to EL2 if HCR_EL2.TSC==1, rather than being treated as UNDEFINED. So,
the host hypervisor can handle this psci call without any confusion.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/kvm/handle_exit.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 208be16..ce6d2ef 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -64,8 +64,27 @@ static int handle_hvc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	kvm_inject_undefined(vcpu);
-	return 1;
+	int ret;
+
+	/* If imm is non-zero, it's not defined */
+	if (kvm_vcpu_hvc_get_imm(vcpu)) {
+		kvm_inject_undefined(vcpu);
+		return 1;
+	}
+
+	/*
+	 * If imm is zero, it's a psci call.
+	 * Note that on ARMv8.3, even if EL3 is not implemented, SMC executed
+	 * at Non-secure EL1 is trapped to EL2 if HCR_EL2.TSC==1, rather than
+	 * being treated as UNDEFINED.
+	 */
+	ret = kvm_psci_call(vcpu);
+	if (ret < 0) {
+		kvm_inject_undefined(vcpu);
+		return 1;
+	}
+
+	return ret;
 }
 
 /**
-- 
1.9.1
