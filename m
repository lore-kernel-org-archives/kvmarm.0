Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584E0C4332F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:20:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 161694B7EF;
	Wed,  2 Nov 2022 19:20:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BKlaO+RuQy25; Wed,  2 Nov 2022 19:20:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 351B54B848;
	Wed,  2 Nov 2022 19:20:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29C2C4B811
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gNtFYret17VC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:19:59 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 441544B797
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:19:59 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 83-20020a630156000000b0046b208f6ae3so83230pgb.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=w/Q7bH8THgyaKP3B1ctDp6/bth9WI6Zn0uJypuG9eac=;
 b=hkPOoen/pyqZsKi1YCSawLdA3GEp9C4f3mv9W0KoQWrN/JmnscJ/7nrSl0bhgo5kc/
 284CZWTN6cQtZyS3BcYl1rO3d2JXX3uptOp6QgDDXHKKXwZWYnEXXtfdURHWu0sgST7b
 SR2jmNv70MkTjk45xUfHV7CREolEUHHjBimLzgCj57Qvy29dchlrARjt1C82JrSjtdvz
 CjPyz+19dEzhNchjZdr/kuW84eKlMR1llHgovF4ZVnGabG/rB0khgL15izrPpgwurgg8
 AnCmcr2wDk7Yyae3uT31jet5RZCDh/LNmD6fqF7lWW4xFuTB9UT2b6Ep4Ac5WXcUuWtP
 s9ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=w/Q7bH8THgyaKP3B1ctDp6/bth9WI6Zn0uJypuG9eac=;
 b=5qdgUmJh9N4i3aHZk17P4CpM/Qu/FeGeipROgBzRnegyjnItqeM6uWkoAyMWvmqFWo
 74Fmqpy11kvCqdzzTQTfBnrU7skqAXMj9WIEv14jY0OqAIcVJFPAgcg9j+Ryh4kRvQSK
 E3Bws8ExEoQtLmiExsADYju2YrmFODEsUIY+XkhzPkid5fByoViFJA1r6EzvmoXbU4QD
 c7wfYXI2ro5u28XxLve4SrZz+cw0X0J45YuiD8jDAlAz0YmNY7nyapXvqgAyeC4l9NCn
 grOvd1d6H0ivquugunnuZwAdfI7Z8LRK6vsxCAkTeGMne3h5dz+rO4kJN4VyFUHbOFtP
 GbWQ==
X-Gm-Message-State: ACrzQf1w1Obbiht2qhmhFkGPN0NPq7VkBpj98/ZW7+pRRqEJMJ/ceKdh
 IS0j1TuUPQ+DdenBYAaiqINE+nq12kk=
X-Google-Smtp-Source: AMsMyM52tU6iRK0I4Ec35KUAzBrT1sghmvSrKR24lxi1BsrlBLfXrWc/1+j2917tMPr6x8h/JqOXwdenWAg=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:852:b0:56d:e2bc:1978 with SMTP id
 q18-20020a056a00085200b0056de2bc1978mr8835032pfk.47.1667431198455; Wed, 02
 Nov 2022 16:19:58 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:18:53 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-27-seanjc@google.com>
Subject: [PATCH 26/44] KVM: s390: Mark __kvm_s390_init() and its descendants
 as __init
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
 Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Atish Patra <atishp@atishpatra.org>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
 Chao Gao <chao.gao@intel.com>, Yuan Yao <yuan.yao@intel.com>,
 kvmarm@lists.linux.dev, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
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
---
 arch/s390/kvm/interrupt.c | 2 +-
 arch/s390/kvm/kvm-s390.c  | 4 ++--
 arch/s390/kvm/kvm-s390.h  | 2 +-
 arch/s390/kvm/pci.c       | 2 +-
 arch/s390/kvm/pci.h       | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index ab569faf0df2..bf9d55fbc21a 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3416,7 +3416,7 @@ void kvm_s390_gib_destroy(void)
 	gib = NULL;
 }
 
-int kvm_s390_gib_init(u8 nisc)
+int __init kvm_s390_gib_init(u8 nisc)
 {
 	int rc = 0;
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e1c9980aae78..f6ae845bc1c1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -358,7 +358,7 @@ static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
 #define INSN_SORTL 0xb938
 #define INSN_DFLTCC 0xb939
 
-static void kvm_s390_cpu_feat_init(void)
+static void __init kvm_s390_cpu_feat_init(void)
 {
 	int i;
 
@@ -461,7 +461,7 @@ static void kvm_s390_cpu_feat_init(void)
 	 */
 }
 
-static int __kvm_s390_init(void)
+static int __init __kvm_s390_init(void)
 {
 	int rc = -ENOMEM;
 
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index f6fd668f887e..e7f6166129eb 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -467,7 +467,7 @@ void kvm_s390_gisa_clear(struct kvm *kvm);
 void kvm_s390_gisa_destroy(struct kvm *kvm);
 void kvm_s390_gisa_disable(struct kvm *kvm);
 void kvm_s390_gisa_enable(struct kvm *kvm);
-int kvm_s390_gib_init(u8 nisc);
+int __init kvm_s390_gib_init(u8 nisc);
 void kvm_s390_gib_destroy(void);
 
 /* implemented in guestdbg.c */
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index c50c1645c0ae..60548791c077 100644
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
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
