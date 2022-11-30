Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F4ED50F
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:10:27 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-352e29ff8c2so171099777b3.21
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=4Gr1Jfa7yHEEgZz9xPhvkFL/F5fGbcOBXHZzdI2oBiBYvLpCTW7OqjU0Ydiyg+ZSis
         1NS6FTFfQOoQMhVEHvlE1Zd0tamHiZHTNfcokhCfsnEqrK2FdpNKxOnLhj+YdsigzNpy
         LQGQZAqdXgX8B+opoKaOgXR4oU7g9SCEOXfewQltKv/gAk+WjItFg+7P6Uz9QHgYJHJ5
         AbVlAINpv2Wf8O1y1fHYc67+dFj7d7VWAMa2cKyrynCcf24gc7AyXzHorEwSLL0FIAlZ
         e2SFWdFwMCqZmIQvMbLJ3cCURqPd9ljrUHOAKh8ZvqakjC98leQ+DeQ1mXeZuDCuNmMn
         p+SQ==
X-Gm-Message-State: ANoB5pmRCZfvbvF143TfbBfIVe8incYIdOfDKdbM0EuscrfWvZdH6U0g
	7HwZHi55YF51F2Xi0LXKUc8CrcDHoME=
X-Google-Smtp-Source: AA0mqf7doE3KsN0pmH7Rc4o01wWXfMkyHfPIY/F3jF9M2I4m4Ef8qW3AG+neuaJOQfJatrp6XEk3w2N5lcM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2d4d:0:b0:6f2:b3f7:7a44 with SMTP id
 s13-20020a252d4d000000b006f2b3f77a44mr29050195ybe.370.1669849826261; Wed, 30
 Nov 2022 15:10:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:09:12 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-29-seanjc@google.com>
Subject: [PATCH v2 28/50] KVM: s390: Mark __kvm_s390_init() and its
 descendants as __init
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>
Cc: James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Atish Patra <atishp@atishpatra.org>, David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>, 
	Cornelia Huck <cohuck@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Fabiano Rosas <farosas@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221130230912.xu7YRxW4HwI35j5SdNMctATZNeBp2kjgcQvRpaKz1G0@z>

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

