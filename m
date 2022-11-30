Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3917D516
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:10:35 +0000 (UTC)
Received: by mail-pl1-f202.google.com with SMTP id y6-20020a17090322c600b00189892baa53so12014329plg.6
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
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
        b=JKH5oBDtbWsG/W+dkCFBqGJ/5os0L8gLryguLIbsA3rY/t3kWYn04okqSJCQjm5hUU
         IY8HO6lPwUYlVEN8KXAmOQLZaourKQnvc9iUf0NkHvnMGvmyiQRS+vcO2sZX/1JMpig7
         8uhZ4CSKzpL/XOWR5qm1Ff1lR1QT3zBsk5kKEsriNRAha8kJ5DmvSSec35xyEltNcVbc
         vE8FCXohxOQogy8ABHqSLf2GK4WqZ9rgGrC7yBEjVqyahrvNV5ASUJge3Q+kiqNQnEGv
         pDdWNOr0H6sMUo+wr/hssjQJI4UZMTb6bxAu3WPtWezJtYllPE3ug4Jvk1yQw0Lz8nCK
         c2jg==
X-Gm-Message-State: ANoB5pmNJxrcAW/O6QebbohDnjRTINLNnqD+OB9vh9al5tNYcw0/9vvV
	yAFqVv9xrwOkZTkTvXSQ+Yfw32jM530=
X-Google-Smtp-Source: AA0mqf57HeX+xXTuMleSA1eLy2x+uTa7n6xyJaGs3rJOB3hWgy2t3owM2xuaTXoQ+YAD0k4pCSHrJ5hlSv0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:f89:b0:219:5b3b:2b9f with SMTP id
 ft9-20020a17090b0f8900b002195b3b2b9fmr848562pjb.2.1669849834864; Wed, 30 Nov
 2022 15:10:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:09:17 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-34-seanjc@google.com>
Subject: [PATCH v2 33/50] KVM: x86: Use KBUILD_MODNAME to specify vendor
 module name
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
Message-ID: <20221130230917.i6xOLYClGxDG_BwGWTDNRa-sQ7in0S1PvOYiB48SKCc@z>

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

