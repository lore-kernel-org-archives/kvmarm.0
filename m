Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1692BC4321E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B72294B28D;
	Wed, 30 Nov 2022 18:10:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9prQCH-4YQy9; Wed, 30 Nov 2022 18:10:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B68B4B63C;
	Wed, 30 Nov 2022 18:10:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25ED44B3DE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4N6FhzYZcmIg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:27 -0500 (EST)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 312744B3F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:23 -0500 (EST)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-3d2994e2d7dso46600077b3.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=Ajf/v6plBmBpvMRb25eu7yZbuYHVVa1MLg3BBW1ApnM=;
 b=Q7q/5TXzNDPohOMoxUDiD0nnqEk1FoSW4RF/EEt8HMYjM52gPxj46PgYF/68/eUC70
 R52IpECaCvp222vr9xTL7j44GbL8VsDvPS5HArvcL4xJanWkN6UNBVlmOIcOzEnjqYoe
 h8mvG1+Ri644iv9eVrF8AA62rM3of5sqQn2h8l1NJ4Hp9LBXQlFjVGfCJ0M8iuidAG/g
 r3QoWBzS8+6cQpNc7qHKOescERK5wH+DxZ5oURQjRLgPy9Nq0G8eKIEZQN5DdxTswpJO
 dO7YdMWEfCe6tuDQ8/4qvPOOW5vLDHcu9lY8BtQx5KXbThVrpdnPftQhmMi0Ij7DKBRT
 iKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Ajf/v6plBmBpvMRb25eu7yZbuYHVVa1MLg3BBW1ApnM=;
 b=bqw66vpxO7wjW1bnTN3FhKY17H3FwV23DY8iNNmyAywxybU9xQDEH/d7758JwLvzIt
 zvhZDkEy3b0dm7DLGpGZUERfAByHDcXi9b/P26jzp1lyEIj0W/h5EPuGvMCK1he8HXQG
 w86BlzwYK/4EbwEQBELSknG37CA8uB0jRGKEtAUiYamjB6P6qFKnx5Sy5AWSugOu0Pls
 dLium2Pn1dy0bETK9Ds3N/0nCNBxcAWOTLGHnEfLcNGr+FCmBlZD9Bop36/cvXxMjkny
 8GV/vVRqFGisBYWkpCrxfd0+bgJGQyHXMJSfJatNtzQprvRrGl4DEiuYn0FtYvPWAxqb
 eWcQ==
X-Gm-Message-State: ANoB5pmmF7CqnAEPUUetoNwgiBlqEPghIBd+vgOZxnZzLWs/R8o1R3Fq
 XubL7sBe/pGWoLrILXeIYlcEmeurwRk=
X-Google-Smtp-Source: AA0mqf6Y4D7Qf+J2WKP5H4v6O2gU4VSt61bmL1SListQ4TvwmtEqTFXL/Zt8AS/4xR6esIpeSKRCzrkbQ9o=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8401:0:b0:6f1:4590:92b9 with SMTP id
 u1-20020a258401000000b006f1459092b9mr33613349ybk.430.1669849822483; Wed, 30
 Nov 2022 15:10:22 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:10 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-27-seanjc@google.com>
Subject: [PATCH v2 26/50] KVM: PPC: Move processor compatibility check to
 module init
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

Move KVM PPC's compatibility checks to their respective module_init()
hooks, there's no need to wait until KVM's common compat check, nor is
there a need to perform the check on every CPU (provided by common KVM's
hook), as the compatibility checks operate on global data.

  arch/powerpc/include/asm/cputable.h: extern struct cpu_spec *cur_cpu_spec;
  arch/powerpc/kvm/book3s.c: return 0
  arch/powerpc/kvm/e500.c: strcmp(cur_cpu_spec->cpu_name, "e500v2")
  arch/powerpc/kvm/e500mc.c: strcmp(cur_cpu_spec->cpu_name, "e500mc")
                             strcmp(cur_cpu_spec->cpu_name, "e5500")
                             strcmp(cur_cpu_spec->cpu_name, "e6500")

Cc: Fabiano Rosas <farosas@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_ppc.h |  1 -
 arch/powerpc/kvm/book3s.c          | 10 ----------
 arch/powerpc/kvm/e500.c            |  4 ++--
 arch/powerpc/kvm/e500mc.c          |  4 ++++
 arch/powerpc/kvm/powerpc.c         |  2 +-
 5 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index bfacf12784dd..51a1824b0a16 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -118,7 +118,6 @@ extern int kvmppc_xlate(struct kvm_vcpu *vcpu, ulong eaddr,
 extern int kvmppc_core_vcpu_create(struct kvm_vcpu *vcpu);
 extern void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu);
 extern int kvmppc_core_vcpu_setup(struct kvm_vcpu *vcpu);
-extern int kvmppc_core_check_processor_compat(void);
 extern int kvmppc_core_vcpu_translate(struct kvm_vcpu *vcpu,
                                       struct kvm_translation *tr);
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 6d525285dbe8..87283a0e33d8 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -999,16 +999,6 @@ int kvmppc_h_logical_ci_store(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvmppc_h_logical_ci_store);
 
-int kvmppc_core_check_processor_compat(void)
-{
-	/*
-	 * We always return 0 for book3s. We check
-	 * for compatibility while loading the HV
-	 * or PR module
-	 */
-	return 0;
-}
-
 int kvmppc_book3s_hcall_implemented(struct kvm *kvm, unsigned long hcall)
 {
 	return kvm->arch.kvm_ops->hcall_implemented(hcall);
diff --git a/arch/powerpc/kvm/e500.c b/arch/powerpc/kvm/e500.c
index c8b2b4478545..0ea61190ec04 100644
--- a/arch/powerpc/kvm/e500.c
+++ b/arch/powerpc/kvm/e500.c
@@ -314,7 +314,7 @@ static void kvmppc_core_vcpu_put_e500(struct kvm_vcpu *vcpu)
 	kvmppc_booke_vcpu_put(vcpu);
 }
 
-int kvmppc_core_check_processor_compat(void)
+static int kvmppc_e500_check_processor_compat(void)
 {
 	int r;
 
@@ -507,7 +507,7 @@ static int __init kvmppc_e500_init(void)
 	unsigned long handler_len;
 	unsigned long max_ivor = 0;
 
-	r = kvmppc_core_check_processor_compat();
+	r = kvmppc_e500_check_processor_compat();
 	if (r)
 		goto err_out;
 
diff --git a/arch/powerpc/kvm/e500mc.c b/arch/powerpc/kvm/e500mc.c
index 57e0ad6a2ca3..795667f7ebf0 100644
--- a/arch/powerpc/kvm/e500mc.c
+++ b/arch/powerpc/kvm/e500mc.c
@@ -388,6 +388,10 @@ static int __init kvmppc_e500mc_init(void)
 {
 	int r;
 
+	r = kvmppc_e500mc_check_processor_compat();
+	if (r)
+		return kvmppc_e500mc;
+
 	r = kvmppc_booke_init();
 	if (r)
 		goto err_out;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 5faf69421f13..d44b85ba8cef 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -442,7 +442,7 @@ int kvm_arch_hardware_enable(void)
 
 int kvm_arch_check_processor_compat(void *opaque)
 {
-	return kvmppc_core_check_processor_compat();
+	return 0;
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
