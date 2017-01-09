From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 23/55] KVM: arm64: Forward WFX to the guest hypervisor
Date: Mon,  9 Jan 2017 01:24:19 -0500
Message-ID: <1483943091-1364-24-git-send-email-jintack@cs.columbia.edu>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A499940194
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qrTvjMkUy5Na for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jan 2017 01:24:24 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 015A4403F8
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:24:23 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096PWtv005289
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:04 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 8DB0495
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:04 -0500 (EST)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id AF4BF8F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jan 2017 01:26:02 -0500 (EST)
Received: from mail-qt0-f199.google.com (mail-qt0-f199.google.com
 [209.85.216.199])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v096Q28M042256
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 9 Jan 2017 01:26:02 -0500
Received: by mail-qt0-f199.google.com with SMTP id l7so63076987qtd.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 08 Jan 2017 22:26:02 -0800 (PST)
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

Forward exceptions due to WFI or WFE to the guest hypervisor if the
guest hypervisor has set corresponding virtual HCR_EL2.TWX bits.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/handle_exit.c        | 11 ++++++++++-
 arch/arm64/kvm/handle_exit_nested.c | 18 ++++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 620b4d3..8d36935 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -2,4 +2,5 @@
 #define __ARM64_KVM_NESTED_H__
 
 int handle_hvc_nested(struct kvm_vcpu *vcpu);
+int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 #endif
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index ce6d2ef..046fdf8 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -101,7 +101,16 @@ static int handle_smc(struct kvm_vcpu *vcpu, struct kvm_run *run)
  */
 static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	if (kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
+	bool is_wfe = !!(kvm_vcpu_get_hsr(vcpu) & ESR_ELx_WFx_ISS_WFE);
+#ifdef CONFIG_KVM_ARM_NESTED_HYP
+	int ret = handle_wfx_nested(vcpu, is_wfe);
+
+	if (ret < 0 && ret != -EINVAL)
+		return ret;
+	else if (ret >= 0)
+		return ret;
+#endif
+	if (is_wfe) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
 		kvm_vcpu_on_spin(vcpu);
diff --git a/arch/arm64/kvm/handle_exit_nested.c b/arch/arm64/kvm/handle_exit_nested.c
index a6ce23b..871ecfc 100644
--- a/arch/arm64/kvm/handle_exit_nested.c
+++ b/arch/arm64/kvm/handle_exit_nested.c
@@ -25,3 +25,21 @@ int handle_hvc_nested(struct kvm_vcpu *vcpu)
 {
 	return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
 }
+
+/*
+ * Inject wfx to the nested hypervisor if this is from the nested VM and
+ * the virtual HCR_EL2.TWX is set. Otherwise, let the host hypervisor
+ * handle this.
+ */
+int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
+{
+	u64 hcr_el2 = vcpu_el2_reg(vcpu, HCR_EL2);
+
+	if (vcpu_mode_el2(vcpu))
+		return -EINVAL;
+
+	if ((is_wfe && (hcr_el2 & HCR_TWE)) || (!is_wfe && (hcr_el2 & HCR_TWI)))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_hsr(vcpu));
+
+	return -EINVAL;
+}
-- 
1.9.1
