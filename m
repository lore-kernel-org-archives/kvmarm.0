Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A6BC4321E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC8F402ED;
	Wed, 30 Nov 2022 18:10:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RQf+4fKvIT0g; Wed, 30 Nov 2022 18:10:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F32904B621;
	Wed, 30 Nov 2022 18:10:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B574B5F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UphWHHvyG6zZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:30 -0500 (EST)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BE3B4B5E8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:27 -0500 (EST)
Received: by mail-yb1-f202.google.com with SMTP id
 d186-20020a25e6c3000000b006f384608ed4so14686027ybh.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=OieTjXt168G/Xjnld4ZlmtAw/6/4OJXm7SHd++1umI0=;
 b=ZPl5I1zJcqiE0l+4F/p8x6MLz2tSOeT/JZaLfE85w0lTajS4YSXdVr0RiZjkgSEqwa
 4ZgU2COJfSsknurs5ma4q7/tOV6Gnl6zIYDu75IjmXc0cmaezZcggCRChMBWOsGfJN3u
 aG4Vf+GA7ibgun2XkOoNom2MZ7Avlb1XoX9hweZFFf+ZDAOgyYhM5lVfcYQhIkiKBYr6
 L8+d26lEXIAkz+yw7+S1z80LAtEvQ2PSmnrtxAiADFN6FS/yNg/pKsk42Q/SzOKPkyuh
 ophht1lsuYKEpGQB+6NLnN2Em3iy4MyMlv0s/808Yh5Ot/5JFY+xj86MEAcGBgxZMese
 FYEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=OieTjXt168G/Xjnld4ZlmtAw/6/4OJXm7SHd++1umI0=;
 b=Sopg0ij3UqbObtiofG+NUplc5Z1HvC/UCIIBIHTuhFZXUvCT+dS91kfr3+/FjiyO1B
 x2mXzIqOl30nUyTPxFdhG0UeL3PCu7bICGey+3/7tFiI1fZhVIdakrjc5+cwHG+29T1h
 a/PwvuKEha1CkqPCKyMELsgXFpyQWhUx+MpdQZtdpULgsozmjXnHJ+4H6pSnHyN1aaFu
 Ru8xpA6VXv69M9ov6mau7c4Bxx5bIuvywFAcC1RSczi+x4kUhwMBBigzBD0VCwaeZVMu
 j40Qk/mFuccI99TQo7sZD4hc60E/qRUNyo2uNIcs+8LVpNZiExXKrJ5RKD34Tbn7XmJd
 zs1g==
X-Gm-Message-State: ANoB5pn3RqOh7pJU7c6eO/7TI4rZiuZ3YvwLU9D/QL4k9ARXGp2l5exi
 DjJv+U0gkfHQLUFPQ2Ov0RK7rV9Djec=
X-Google-Smtp-Source: AA0mqf7doE3KsN0pmH7Rc4o01wWXfMkyHfPIY/F3jF9M2I4m4Ef8qW3AG+neuaJOQfJatrp6XEk3w2N5lcM=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2d4d:0:b0:6f2:b3f7:7a44 with SMTP id
 s13-20020a252d4d000000b006f2b3f77a44mr29050195ybe.370.1669849826261; Wed, 30
 Nov 2022 15:10:26 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:12 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-29-seanjc@google.com>
Subject: [PATCH v2 28/50] KVM: s390: Mark __kvm_s390_init() and its
 descendants as __init
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

Tag __kvm_s390_init() and its unique helpers as __init.  These functions
are only ever called during module_init(), but could not be tagged
accordingly while they were invoked from the common kvm_arch_init(),
which is not __init because of x86.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 arch/s390/kvm/kvm-s390.c  | 4 ++--
 arch/s390/kvm/kvm-s390.h  | 2 +-
 arch/s390/kvm/pci.c       | 2 +-
 arch/s390/kvm/pci.h       | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 1dae78deddf2..3754d7937530 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3411,7 +3411,7 @@ void kvm_s390_gib_destroy(void)
 	gib = NULL;
 }
 
-int kvm_s390_gib_init(u8 nisc)
+int __init kvm_s390_gib_init(u8 nisc)
 {
 	int rc = 0;
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8c4fcaf2bd36..66d162723d21 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -366,7 +366,7 @@ static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
 #define INSN_SORTL 0xb938
 #define INSN_DFLTCC 0xb939
 
-static void kvm_s390_cpu_feat_init(void)
+static void __init kvm_s390_cpu_feat_init(void)
 {
 	int i;
 
@@ -469,7 +469,7 @@ static void kvm_s390_cpu_feat_init(void)
 	 */
 }
 
-static int __kvm_s390_init(void)
+static int __init __kvm_s390_init(void)
 {
 	int rc = -ENOMEM;
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index d48588c207d8..0261d42c7d01 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -470,7 +470,7 @@ void kvm_s390_gisa_clear(struct kvm *kvm);
 void kvm_s390_gisa_destroy(struct kvm *kvm);
 void kvm_s390_gisa_disable(struct kvm *kvm);
 void kvm_s390_gisa_enable(struct kvm *kvm);
-int kvm_s390_gib_init(u8 nisc);
+int __init kvm_s390_gib_init(u8 nisc);
 void kvm_s390_gib_destroy(void);
 
 /* implemented in guestdbg.c */
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index ded1af2ddae9..39544c92ce3d 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -670,7 +670,7 @@ int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args)
 	return r;
 }
 
-int kvm_s390_pci_init(void)
+int __init kvm_s390_pci_init(void)
 {
 	zpci_kvm_hook.kvm_register = kvm_s390_pci_register_kvm;
 	zpci_kvm_hook.kvm_unregister = kvm_s390_pci_unregister_kvm;
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 486d06ef563f..ff0972dd5e71 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -60,7 +60,7 @@ void kvm_s390_pci_clear_list(struct kvm *kvm);
 
 int kvm_s390_pci_zpci_op(struct kvm *kvm, struct kvm_s390_zpci_op *args);
 
-int kvm_s390_pci_init(void);
+int __init kvm_s390_pci_init(void);
 void kvm_s390_pci_exit(void);
 
 static inline bool kvm_s390_pci_interp_allowed(void)
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
