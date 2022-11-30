Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B1F1C352A1
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 055F04B269;
	Wed, 30 Nov 2022 18:10:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NCUPnjyzT9ox; Wed, 30 Nov 2022 18:10:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B177B4B3C0;
	Wed, 30 Nov 2022 18:10:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68B0B4B3E3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yeYAyc8U6BJm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:16 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6CD54B199
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:13 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 j16-20020a170902da9000b001893d5da3acso19289220plx.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=grdSlJzFo0VwdV8xgzvuVpRwKnA9GO3Mob4PH+ot8/0=;
 b=CQKSwij2dM5sxTN5vEM9Pg0UGQR7vXxLholFOCIYMDxZ1/3rA7vH+RqFmN1n0beWlD
 7+BAU4/MoU1Z2zohEeDLQA2mrNFcLMI1vaNT8JUT+3n3Smxr3wpQu7rVUMeYIUjzYrKM
 QQRXU+fmSvdsXsp/lH1ncccopWZ+njKFlSsnkmBo5RgV0L2uInmLnHD4wZGB2dqPvFNW
 AFZHsbz5az7ZAwj41de9s/UvOppce1LN8jHb5JWdYWBnJ4FReLvafLy5jclWK6UngF05
 cPIBeGpzAB3DL/mtUhAd3V5apiG8/mbBEcTlCsb8iWOJpXlQdaq+hFXcxIhaHoaH5jmv
 rjIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=grdSlJzFo0VwdV8xgzvuVpRwKnA9GO3Mob4PH+ot8/0=;
 b=PDz+9wT1RWdQvLUU08bhjuIrRX3s8F4Uj9YGyl+qBfzxdKtbCgfqjbnnslzfXxW2ke
 FAsSHlThP2OgSiQffjlsUngBjlccF1e9Z43UZtKiFuvyPF+s/Rt06DXvo5+oMHuWDOOF
 VOvPzUIw0Zqz6DhpHU2C79E/OqIVYorDIlXbY63tJfS4nz2fKtv5p0+1PsDdEarQjDQP
 +lszd6qeb0PurBMz6GwX+8zREMlhzyuT+CJ4E8XLEv4QOzmVPZpl3C3biI7hWnwtpW5Y
 3DR6QYVaOpKl2DpJREAoksX54Q/5raI/W9w1r9I+ErwNdh9OSIEupXBSpoD7AqomvwX+
 uPSQ==
X-Gm-Message-State: ANoB5pmDsPxGjZSiDaocFA3L6hdkeY/6J4BvleOkGmR6NJVWeVwzg9Oa
 y11EovN9rdB7ElQ5XdZvgq0OSI933EY=
X-Google-Smtp-Source: AA0mqf5utOkOs36wj8G4rTpG0ELlL4JMVDy82zEmZIH7sIXiucVOps+Q5AZsFyLWVU+C/qKz+GIkdE+8/9Y=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:648a:0:b0:572:76dd:3756 with SMTP id
 y132-20020a62648a000000b0057276dd3756mr45058073pfb.9.1669849813287; Wed, 30
 Nov 2022 15:10:13 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:05 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-22-seanjc@google.com>
Subject: [PATCH v2 21/50] KVM: MIPS: Hardcode callbacks to hardware
 virtualization extensions
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

Now that KVM no longer supports trap-and-emulate (see commit 45c7e8af4a5e
"MIPS: Remove KVM_TE support"), hardcode the MIPS callbacks to the
virtualization callbacks.

Harcoding the callbacks eliminates the technically-unnecessary check on
non-NULL kvm_mips_callbacks in kvm_arch_init().  MIPS has never supported
multiple in-tree modules, i.e. barring an out-of-tree module, where
copying and renaming kvm.ko counts as "out-of-tree", KVM could never
encounter a non-NULL set of callbacks during module init.

The callback check is also subtly broken, as it is not thread safe,
i.e. if there were multiple modules, loading both concurrently would
create a race between checking and setting kvm_mips_callbacks.

Given that out-of-tree shenanigans are not the kernel's responsibility,
hardcode the callbacks to simplify the code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/include/asm/kvm_host.h |  2 +-
 arch/mips/kvm/Makefile           |  2 +-
 arch/mips/kvm/callback.c         | 14 --------------
 arch/mips/kvm/mips.c             |  9 ++-------
 arch/mips/kvm/vz.c               |  7 ++++---
 5 files changed, 8 insertions(+), 26 deletions(-)
 delete mode 100644 arch/mips/kvm/callback.c

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 28f0ba97db71..2803c9c21ef9 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -758,7 +758,7 @@ struct kvm_mips_callbacks {
 	void (*vcpu_reenter)(struct kvm_vcpu *vcpu);
 };
 extern struct kvm_mips_callbacks *kvm_mips_callbacks;
-int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks);
+int kvm_mips_emulation_init(void);
 
 /* Debug: dump vcpu state */
 int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu);
diff --git a/arch/mips/kvm/Makefile b/arch/mips/kvm/Makefile
index 21ff75bcdbc4..805aeea2166e 100644
--- a/arch/mips/kvm/Makefile
+++ b/arch/mips/kvm/Makefile
@@ -17,4 +17,4 @@ kvm-$(CONFIG_CPU_LOONGSON64) += loongson_ipi.o
 
 kvm-y		+= vz.o
 obj-$(CONFIG_KVM)	+= kvm.o
-obj-y			+= callback.o tlb.o
+obj-y			+= tlb.o
diff --git a/arch/mips/kvm/callback.c b/arch/mips/kvm/callback.c
deleted file mode 100644
index d88aa2173fb0..000000000000
--- a/arch/mips/kvm/callback.c
+++ /dev/null
@@ -1,14 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2012  MIPS Technologies, Inc.  All rights reserved.
- * Authors: Yann Le Du <ledu@kymasys.com>
- */
-
-#include <linux/export.h>
-#include <linux/kvm_host.h>
-
-struct kvm_mips_callbacks *kvm_mips_callbacks;
-EXPORT_SYMBOL_GPL(kvm_mips_callbacks);
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index af29490d9740..f0a6c245d1ff 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1012,17 +1012,12 @@ long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 
 int kvm_arch_init(void *opaque)
 {
-	if (kvm_mips_callbacks) {
-		kvm_err("kvm: module already exists\n");
-		return -EEXIST;
-	}
-
-	return kvm_mips_emulation_init(&kvm_mips_callbacks);
+	return kvm_mips_emulation_init();
 }
 
 void kvm_arch_exit(void)
 {
-	kvm_mips_callbacks = NULL;
+
 }
 
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index c706f5890a05..dafab003ea0d 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -3304,7 +3304,10 @@ static struct kvm_mips_callbacks kvm_vz_callbacks = {
 	.vcpu_reenter = kvm_vz_vcpu_reenter,
 };
 
-int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks)
+/* FIXME: Get rid of the callbacks now that trap-and-emulate is gone. */
+struct kvm_mips_callbacks *kvm_mips_callbacks = &kvm_vz_callbacks;
+
+int kvm_mips_emulation_init(void)
 {
 	if (!cpu_has_vz)
 		return -ENODEV;
@@ -3318,7 +3321,5 @@ int kvm_mips_emulation_init(struct kvm_mips_callbacks **install_callbacks)
 		return -ENODEV;
 
 	pr_info("Starting KVM with MIPS VZ extensions\n");
-
-	*install_callbacks = &kvm_vz_callbacks;
 	return 0;
 }
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
