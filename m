Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09F3D50F
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:10:31 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id m2-20020a17090aab0200b002188c801f92so169860pjq.4
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gGlMYVi+8cq5eUoZ5sdih51J8dbFvJ7SNZIQRLoo5uo=;
        b=fV1/K+jF8pmsrix+k0p4fqdMLOZW46RiubsdWwI2sgpOZ9mSf0o8kQB+E0gdgHGg9/
         eAw8H+6GYUyvY58pud7hGaMaECg17r4h3ufqi+AQiO/cd2K2PsiQx/t0E+ow2b29O1kq
         mE9Nc5EOzaOOCFpHTdWVwQd3VK8VqaamiQrK4JT5brdDF2lU7pSMAn1NZk1aO9R2/+nZ
         HvMEU0WPaG/hIKRtGO8ZlmpBj18ocxONAB+T3MZL6DtiiV1jniXaBXq2MSSMS+Eff7NV
         6zujBbiUfcV5uJuTUyGLRufJIGyZXhMyG5dt8JA41iQvZmB19fSGzEz6eLd/dvmJ66Ev
         FrGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gGlMYVi+8cq5eUoZ5sdih51J8dbFvJ7SNZIQRLoo5uo=;
        b=rglaIA3pJJM7xdV5Z+hNLC0yCMbE4r+DxTkitfbecaAEgjG2Tz9gs9XKmhQEYnSxOJ
         6+pjLjPNDJo3L4ZEhwIv50ae2b6AZepBciXmZA7NlDYmjicA6LNm9LpM99OLU2Jwf9SY
         ngZvbm01qG36zgRkkkcp4JlF4Gw2Q5TstCBPGwVaXft5zoEBwFSHFQRcNb9ebqbhNWWJ
         /XtSTkQ/beOK5y72trgdSd9dbpKTdLCes2h04XE+Py+oghKFEIdtmACoMnJn+E+LAPKj
         OYhg1P2zITzzw6BKJFbtozqseA9NWSphNVn1Sv+H1s4w9NHKmpykZwtb/QuDSPXC/S/q
         1O2g==
X-Gm-Message-State: ANoB5pnHPjGy16EDBdLvnr2obR4N8fNaks7uO3kvfGbD0+cCjv2l4zyB
	0JSqXvcFdjlq/LresGLjMCsDFCyXWX8=
X-Google-Smtp-Source: AA0mqf7tkua9h/cWBirbpjwcNsrjWIz0JrBzEezpRIm7lfNzo4PInvRMnHehpz73z+PXMVC4o8EwEkWCrGc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8bc1:0:b0:575:bfb9:b1fa with SMTP id
 s1-20020aa78bc1000000b00575bfb9b1famr7675712pfd.62.1669849831189; Wed, 30 Nov
 2022 15:10:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:09:15 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-32-seanjc@google.com>
Subject: [PATCH v2 31/50] KVM: x86: Do CPU compatibility checks in x86 code
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
Message-ID: <20221130230915.7pLwNxNEBOhyf9Ng24F9VXYbprGadzYcFsBijpehgrY@z>

Move the CPU compatibility checks to pure x86 code, i.e. drop x86's use
of the common kvm_x86_check_cpu_compat() arch hook.  x86 is the only
architecture that "needs" to do per-CPU compatibility checks, moving
the logic to x86 will allow dropping the common code, and will also
give x86 more control over when/how the compatibility checks are
performed, e.g. TDX will need to enable hardware (do VMXON) in order to
perform compatibility checks.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     | 49 ++++++++++++++++++++++++++++++++----------
 3 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 19e81a99c58f..d7ea1c1175c2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5103,7 +5103,7 @@ static int __init svm_init(void)
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
 	 */
-	r = kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
+	r = kvm_init(NULL, sizeof(struct vcpu_svm),
 		     __alignof__(struct vcpu_svm), THIS_MODULE);
 	if (r)
 		goto err_kvm_init;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 654d81f781da..8deb1bd60c10 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8592,7 +8592,7 @@ static int __init vmx_init(void)
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
 	 */
-	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
+	r = kvm_init(NULL, sizeof(struct vcpu_vmx),
 		     __alignof__(struct vcpu_vmx), THIS_MODULE);
 	if (r)
 		goto err_kvm_init;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 66f16458aa97..3571bc968cf8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9277,10 +9277,36 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 	kvm_pmu_ops_update(ops->pmu_ops);
 }
 
+struct kvm_cpu_compat_check {
+	struct kvm_x86_init_ops *ops;
+	int *ret;
+};
+
+static int kvm_x86_check_processor_compatibility(struct kvm_x86_init_ops *ops)
+{
+	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+
+	WARN_ON(!irqs_disabled());
+
+	if (__cr4_reserved_bits(cpu_has, c) !=
+	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
+		return -EIO;
+
+	return ops->check_processor_compatibility();
+}
+
+static void kvm_x86_check_cpu_compat(void *data)
+{
+	struct kvm_cpu_compat_check *c = data;
+
+	*c->ret = kvm_x86_check_processor_compatibility(c->ops);
+}
+
 static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 {
+	struct kvm_cpu_compat_check c;
 	u64 host_pat;
-	int r;
+	int r, cpu;
 
 	if (kvm_x86_ops.hardware_enable) {
 		pr_err("kvm: already loaded vendor module '%s'\n", kvm_x86_ops.name);
@@ -9360,6 +9386,14 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (r != 0)
 		goto out_mmu_exit;
 
+	c.ret = &r;
+	c.ops = ops;
+	for_each_online_cpu(cpu) {
+		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &c, 1);
+		if (r < 0)
+			goto out_hardware_unsetup;
+	}
+
 	/*
 	 * Point of no return!  DO NOT add error paths below this point unless
 	 * absolutely necessary, as most operations from this point forward
@@ -9402,6 +9436,8 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	kvm_init_msr_list();
 	return 0;
 
+out_hardware_unsetup:
+	ops->runtime_ops->hardware_unsetup();
 out_mmu_exit:
 	kvm_mmu_vendor_module_exit();
 out_free_percpu:
@@ -12037,16 +12073,7 @@ void kvm_arch_hardware_disable(void)
 
 int kvm_arch_check_processor_compat(void *opaque)
 {
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
-	struct kvm_x86_init_ops *ops = opaque;
-
-	WARN_ON(!irqs_disabled());
-
-	if (__cr4_reserved_bits(cpu_has, c) !=
-	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
-		return -EIO;
-
-	return ops->check_processor_compatibility();
+	return 0;
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
-- 
2.38.1.584.g0f3c55d4c2-goog

