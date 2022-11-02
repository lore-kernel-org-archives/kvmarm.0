Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CEBC4167D
	for <kvmarm@archiver.kernel.org>; Wed,  2 Nov 2022 23:20:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E50364B862;
	Wed,  2 Nov 2022 19:20:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1UZGgU-rHFst; Wed,  2 Nov 2022 19:20:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E60F24B85B;
	Wed,  2 Nov 2022 19:20:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B940E4B84C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I7-EINn1oq+t for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Nov 2022 19:20:08 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 874094B846
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Nov 2022 19:20:07 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-37360a6236fso800017b3.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Nov 2022 16:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=xdi2HIR5lDsLzEB1UZrukxTClMK6e7wt2nFiWo5gXdY=;
 b=sb/k/6YChcjl+a9VYlAXhWYOgQyjQV32YX7EFiw9qqpx/WWSDY3oo2CdFxdxpN5cQ+
 bsen7KFdwbaDgiY7tE/ARuN34CNUQVNfQj40KonMSYzWyRevQJIJ8ucvWSt+5e0xldbM
 dG1h+yI8VvXovjZl23qRN2G1h0VDtyVIK/a8wCZyDk3med1nNg8la66zBWDcMMULCuHG
 GgMxZJTuhnm9Kg3Kf6izcH6H9MKXIo5IEEs5iURRrxNb+NCxH6KXLxeRheLVzOIs5Da0
 /j3GVJG8PRl/KZMyimVoe+5FEyijlgyVWBHJWpAL02rmgy07fT/EQi1GCc1WFNc58HpZ
 GW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=xdi2HIR5lDsLzEB1UZrukxTClMK6e7wt2nFiWo5gXdY=;
 b=0HYpqTPk8CgWv9ENTH/VhYsGUzhujLrGy709hsy/NFqq8uNCcmLKFgy6DuLgX9hKdT
 q7gyU7x1mMSMuQZXWiFvQ8eKgPxm2DuKGj1VT0TzoHynak6FhlikUxsQ8SJ/VW1TgrM2
 6LWYCLmV+vXjO7caXj8kx80+gE7p87CST4s/lMNgrONuksh1bucEnFG8BTuDg9iDP2sP
 Z2FJHchU2/2W1eZ3QXUuGsNt3hRyAC3GxYhxh6IcxmvWrPYTXVmAXL/OP4Z87QJYYPAk
 2+e2LdLG3NDCrqIk4h6YIiFeQ8DvpzGaosCu2s5aueYXoIZAB+NxBBN0UTk1vnV4OIcf
 AZcQ==
X-Gm-Message-State: ACrzQf3uHNHQHP9k4GKxz+UaHjWc7O5jlUhgXE8B+nE49afopUGWSydZ
 jJZeVXb6YgGUOroSE1FvxaqNZ7G+y2w=
X-Google-Smtp-Source: AMsMyM7e+TGdJRwAqNyPJfnKmxSn80oz3hoXq+YWtTdlfH8WIBioJcR7xPecdYC8HpWoY/uUAUWZTvNWC7g=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:443:0:b0:6bc:e3d1:8990 with SMTP id
 s3-20020a5b0443000000b006bce3d18990mr28148778ybp.191.1667431207141; Wed, 02
 Nov 2022 16:20:07 -0700 (PDT)
Date: Wed,  2 Nov 2022 23:18:58 +0000
In-Reply-To: <20221102231911.3107438-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102231911.3107438-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102231911.3107438-32-seanjc@google.com>
Subject: [PATCH 31/44] KVM: x86: Use KBUILD_MODNAME to specify vendor module
 name
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

Use KBUILD_MODNAME to specify the vendor module name instead of manually
writing out the name to make it a bit more obvious that the name isn't
completely arbitrary.  A future patch will also use KBUILD_MODNAME to
define pr_fmt, at which point using KBUILD_MODNAME for kvm_x86_ops.name
further reinforces the intended usage of kvm_x86_ops.name.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 99c1ac2d9c84..13457aa68112 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4737,7 +4737,7 @@ static int svm_vm_init(struct kvm *kvm)
 }
 
 static struct kvm_x86_ops svm_x86_ops __initdata = {
-	.name = "kvm_amd",
+	.name = KBUILD_MODNAME,
 
 	.hardware_unsetup = svm_hardware_unsetup,
 	.hardware_enable = svm_hardware_enable,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 25e28d368274..a563c9756e36 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8074,7 +8074,7 @@ static void vmx_vm_destroy(struct kvm *kvm)
 }
 
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
-	.name = "kvm_intel",
+	.name = KBUILD_MODNAME,
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
