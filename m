Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6E9C47088
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A45424B2FF;
	Wed, 30 Nov 2022 18:10:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9zI1+PL-DMbb; Wed, 30 Nov 2022 18:10:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 881154B18F;
	Wed, 30 Nov 2022 18:10:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE01040A93
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E4cxWJ-vmPAB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:09:59 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1F7F4A0DA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:09:58 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 pa16-20020a17090b265000b0020a71040b4cso161959pjb.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=7yWYfpXTDQbZLx47MbNcDj0N66CBaR6qG+PnY/I15CM=;
 b=bT3dL2RNgcw1MpeUO77l7FsTfdHMpEPlJatekk/DzFXJMm693HavywTCaGv6OqR75P
 CEGSx4lH9Jtd0fa2semdatuM2+6/GtUmIUJQimOKEXQM8pMgCWT8njsrI/UOhbCPveML
 q4zrbtboaVnIfVEgvLRQEAam2V+r4+zAGV7lL18Zl2LduEOPaMTpPlFnw/B6EsrXnukj
 2pbaAxvJ9zg/7eNsW555x3IFXEMVva/FgAmoY74Di0SuLoDCFLXDc3bBoL6HnnnAq35N
 reo1l2pMb3FCDaYjA4+6K/LTtV98kIt8jz3I1oCTyDyB/5twL2Ezyrmfizfy7s3Xbw19
 DN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=7yWYfpXTDQbZLx47MbNcDj0N66CBaR6qG+PnY/I15CM=;
 b=ugkQ9kUsnokenwoEL+zUEjqN14bGVICYiZ4cWIKgj1LGay803U/jLv6OTvkhLyKbf0
 L6t/7WD3yvk0yO6Z4+eXcwIzcCwKqs8UOhAP/NzwRRnnVqFEc3b3hyC4v6Bcc+WP6+0O
 lEEkZ62rlYgIDKgpwjsNgo1Wpbs+XvQEe+JtJ25B32Ax75+MYg0Pifyy7xISCr+QaMRd
 Wqr8J+OOjBrDRScvRbgVwQupMIwnCqQciSfAX3gu2h6YpdKlfWqvXUP1ZsX0F/EHxhwO
 tSMmtFFCoxhSwUIKQ+MuZO3Q/QPsVI4RJgs/QllnTMkQDXPbai/kfWZfsEjEt64yIHbl
 gxcA==
X-Gm-Message-State: ANoB5pm9FaVeXgYMpE00C+bNuI5tDJNfuhdMpxbOPAD/T9rVlUSogsoP
 Cr66Ja1z5ZigGjOPBbpwKo7SrYR5oSQ=
X-Google-Smtp-Source: AA0mqf63J5CYVyPrHNleGtfRjvZIjPjkTqLR79wPGUIq9AORVm0CVLKuvvqzhbFB0T9FDbVeahYix13Gv4o=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ee55:b0:176:a16a:417d with SMTP id
 21-20020a170902ee5500b00176a16a417dmr47218439plo.46.1669849797761; Wed, 30
 Nov 2022 15:09:57 -0800 (PST)
Date: Wed, 30 Nov 2022 23:08:56 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-13-seanjc@google.com>
Subject: [PATCH v2 12/50] KVM: VMX: Move Hyper-V eVMCS initialization to helper
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Anup Patel <anup@brainfault.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, linux-riscv@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, Chao Gao <chao.gao@intel.com>,
 Yuan Yao <yuan.yao@intel.com>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@linux.ibm.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Sean Christopherson <seanjc@google.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Move Hyper-V's eVMCS initialization to a dedicated helper to clean up
vmx_init(), and add a comment to call out that the Hyper-V init code
doesn't need to be unwound if vmx_init() ultimately fails.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 73 +++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c0de7160700b..b8bf95b9710d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -523,6 +523,8 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 static unsigned long host_idt_base;
 
 #if IS_ENABLED(CONFIG_HYPERV)
+static struct kvm_x86_ops vmx_x86_ops __initdata;
+
 static bool __read_mostly enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
 
@@ -551,6 +553,43 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static __init void hv_init_evmcs(void)
+{
+	int cpu;
+
+	if (!enlightened_vmcs)
+		return;
+
+	/*
+	 * Enlightened VMCS usage should be recommended and the host needs
+	 * to support eVMCS v1 or above.
+	 */
+	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
+	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
+	     KVM_EVMCS_VERSION) {
+
+		/* Check that we have assist pages on all online CPUs */
+		for_each_online_cpu(cpu) {
+			if (!hv_get_vp_assist_page(cpu)) {
+				enlightened_vmcs = false;
+				break;
+			}
+		}
+
+		if (enlightened_vmcs) {
+			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
+			static_branch_enable(&enable_evmcs);
+		}
+
+		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
+			vmx_x86_ops.enable_l2_tlb_flush
+				= hv_enable_l2_tlb_flush;
+
+	} else {
+		enlightened_vmcs = false;
+	}
+}
+
 static void hv_reset_evmcs(void)
 {
 	struct hv_vp_assist_page *vp_ap;
@@ -577,6 +616,7 @@ static void hv_reset_evmcs(void)
 }
 
 #else /* IS_ENABLED(CONFIG_HYPERV) */
+static void hv_init_evmcs(void) {}
 static void hv_reset_evmcs(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
@@ -8500,38 +8540,11 @@ static int __init vmx_init(void)
 {
 	int r, cpu;
 
-#if IS_ENABLED(CONFIG_HYPERV)
 	/*
-	 * Enlightened VMCS usage should be recommended and the host needs
-	 * to support eVMCS v1 or above. We can also disable eVMCS support
-	 * with module parameter.
+	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
+	 * to unwind if a later step fails.
 	 */
-	if (enlightened_vmcs &&
-	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
-	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
-	    KVM_EVMCS_VERSION) {
-
-		/* Check that we have assist pages on all online CPUs */
-		for_each_online_cpu(cpu) {
-			if (!hv_get_vp_assist_page(cpu)) {
-				enlightened_vmcs = false;
-				break;
-			}
-		}
-
-		if (enlightened_vmcs) {
-			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
-			static_branch_enable(&enable_evmcs);
-		}
-
-		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
-			vmx_x86_ops.enable_l2_tlb_flush
-				= hv_enable_l2_tlb_flush;
-
-	} else {
-		enlightened_vmcs = false;
-	}
-#endif
+	hv_init_evmcs();
 
 	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
 		     __alignof__(struct vcpu_vmx), THIS_MODULE);
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
