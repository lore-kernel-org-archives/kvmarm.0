Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A4AC47088
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:10:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 313C44B6C7;
	Wed, 30 Nov 2022 18:10:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iX7YMZuR2p+C; Wed, 30 Nov 2022 18:10:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5920D4B650;
	Wed, 30 Nov 2022 18:10:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 39B264B62B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qu9PUYBDqvvH for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:10:41 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D19B4B688
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:36 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 z4-20020a17090ab10400b002195a146546so3775077pjq.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=Vo4Z77dzNvKrehTzYt4K2iI8Cmx6h54XHztU8GehcL8=;
 b=hivL5TC6LdtOW2OmuNQou4Gy4U4tXiu2+6M2wfmsMZujN2ItoQgS8dZtbchvpp7Sy7
 gQP8KJQ85CZqnMEDc6KXPFPpNulQ0aQGew3NpHF0ryb6ACX+mCcZQj6XUPxiNhI1xHp0
 rD08FH6W6Tc9mMBWGEmLcFaU5I8qQn9La/dT9kb2EVRIeOnNi6kCex/5Q2SGr2bRQoGy
 G1EteOn3rd3vULZF1PgE4auaSNRlpUDh4ixH2iWSNr973dhsYVWWF6gRbX3Yo5SuVqh0
 qNdORoE9jtDj45oUX7KBmjx++vi1W+JogYW4rHwuh1tKXtb0Sz6z/D5a80vr3bmmUG42
 8e0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Vo4Z77dzNvKrehTzYt4K2iI8Cmx6h54XHztU8GehcL8=;
 b=MBfZAjdlcUoMEYRD7z5vPkPzqgSvVAdA7D6dcGYZlTqoeoxxJj9TYLNfZKeTAFCg5V
 DTnD0Jn1gr2ayfPc6lh5OxwJ/KT8zTxDrSXkseZ/XuxvZ1Jv32duPi9KMu9zdRENcVsq
 sq75Wcuf36RC5jmMKsMGcg9dbq9fnJxIp+sG1puAKd+DImMCvxznKd2stIh4wwda+azA
 iQbOF7D6BZr4qXZmU8XMqZu/ntf7U3ITKd0iK+GlXCAvg3U0D/19wrvgtecJBBzCq0l9
 oSbuATkPtsJDHZtxRSIOFetlExn760tMe4M2lafqSFysIX5ycqR/RFRmjU8Waa0eybg3
 5ddA==
X-Gm-Message-State: ANoB5pmiZmCoVybsUQpTix4jEfdmFaTsl0tuEZpjoxRujDRqX1URkB6W
 rlfhzjxS7sV3LGpodUYA3vdb45FqJZw=
X-Google-Smtp-Source: AA0mqf57HeX+xXTuMleSA1eLy2x+uTa7n6xyJaGs3rJOB3hWgy2t3owM2xuaTXoQ+YAD0k4pCSHrJ5hlSv0=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:f89:b0:219:5b3b:2b9f with SMTP id
 ft9-20020a17090b0f8900b002195b3b2b9fmr848562pjb.2.1669849834864; Wed, 30 Nov
 2022 15:10:34 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:17 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-34-seanjc@google.com>
Subject: [PATCH v2 33/50] KVM: x86: Use KBUILD_MODNAME to specify vendor
 module name
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
index d9a54590591d..a875cf7b2942 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4695,7 +4695,7 @@ static int svm_vm_init(struct kvm *kvm)
 }
 
 static struct kvm_x86_ops svm_x86_ops __initdata = {
-	.name = "kvm_amd",
+	.name = KBUILD_MODNAME,
 
 	.hardware_unsetup = svm_hardware_unsetup,
 	.hardware_enable = svm_hardware_enable,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b6f08a0a1435..229a9cf485f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8102,7 +8102,7 @@ static void vmx_vm_destroy(struct kvm *kvm)
 }
 
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
-	.name = "kvm_intel",
+	.name = KBUILD_MODNAME,
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
