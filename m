Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17846D516
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:09:43 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id pi2-20020a17090b1e4200b0021834843687so3835937pjb.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kawSfeiAQQiBaQdAeCS12WX5tLp3dBMfNzsm6MZMVDM=;
        b=FuPyDk5HrtCF5qsfcl43lYyhvkgSpcbbsM90YW/3vO3HUB6l7+MBsntxd3/q8gIxoj
         rdKuy8tsa4qXKw46UszgYe7A8/TdMyQmeCoF+YYW9dIEj0dViDiBTtgxBOSRXDRa96/f
         KliWaD9EYRQHMZlNfki4Q8T7/+zZVlwydZoPGCadpemWGxJB7IFN8q6Q93mpMbE0d+Tv
         Gf+jRZICWLnpxC3g1kbOTurVfxPkN8C+UYy/6R3UIEQErk2k3Er1Jkq5UmKt+OcBkjXI
         DwaZ1o75hI5oxdTAgGbi6NECIv+ulAm+Z4MzH2VhP/t3nIxcOzScSD0PtVDNJOMhMUZG
         LZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kawSfeiAQQiBaQdAeCS12WX5tLp3dBMfNzsm6MZMVDM=;
        b=AiVpLKfl+QCEgbOUiYI3l4nxPt4Z2YFk2soTtanuhmggj/ukW1EY6rgIshK0y2fizq
         QVO5OPwqC0X2RZC9AoB4GgcGaB4luBgRzAqYcB1Frayg9id04lIJjCWSXDmvoyyDmOAU
         2jF7fUymkne+S8h3GtJVdKpzL0BQKsH2LToFbcChXaxESWZ9J0ZVBzdabJWhhLuHHh9o
         4hyuAnxSGcYukpE2bEo87SLfNEyaPXdozReky11qBTSshCoKMVp5OPmQx+n60yNL3fzt
         1cIYYA5UIGwz4a2ggMkBf+Xurt12xyIWoRXQfvA/W/QfgHn2qU7aEAhCc+dMqekd6nqa
         ouQQ==
X-Gm-Message-State: ANoB5pmdoWWOyUlZjL+ehFEXmvfl7lv8+c6vL8FmXXUYfwigWptO0rtV
	wJqsVfjhU/WumMw2welW/l+XnN6MkPY=
X-Google-Smtp-Source: AA0mqf6wj4HWNV+5cP60rIX6ofADo44xPOiR/JXYf/UmKFCdE5+oZoM8ajSF5PuZFF+kh92E+ZGoi4VvFjg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:82c7:0:b0:575:398:468c with SMTP id
 w190-20020a6282c7000000b005750398468cmr21072041pfd.23.1669849782508; Wed, 30
 Nov 2022 15:09:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:08:47 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-4-seanjc@google.com>
Subject: [PATCH v2 03/50] KVM: Allocate cpus_hardware_enabled after arch
 hardware setup
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
Message-ID: <20221130230847.jWSVDfVMReGoGkyk-iBFuXbJCJB_kaQQgOFcaxLnqoo@z>

Allocate cpus_hardware_enabled after arch hardware setup so that arch
"init" and "hardware setup" are called back-to-back and thus can be
combined in a future patch.  cpus_hardware_enabled is never used before
kvm_create_vm(), i.e. doesn't have a dependency with hardware setup and
only needs to be allocated before /dev/kvm is exposed to userspace.

Free the object before the arch hooks are invoked to maintain symmetry,
and so that arch code can move away from the hooks without having to
worry about ordering changes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
 virt/kvm/kvm_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 43e2e4f38151..ded88ad6c2d8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5862,15 +5862,15 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r)
 		return r;
 
+	r = kvm_arch_hardware_setup(opaque);
+	if (r < 0)
+		goto err_hw_setup;
+
 	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
 		r = -ENOMEM;
 		goto err_hw_enabled;
 	}
 
-	r = kvm_arch_hardware_setup(opaque);
-	if (r < 0)
-		goto out_free_1;
-
 	c.ret = &r;
 	c.opaque = opaque;
 	for_each_online_cpu(cpu) {
@@ -5956,10 +5956,10 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 out_free_2:
-	kvm_arch_hardware_unsetup();
-out_free_1:
 	free_cpumask_var(cpus_hardware_enabled);
 err_hw_enabled:
+	kvm_arch_hardware_unsetup();
+err_hw_setup:
 	kvm_arch_exit();
 	return r;
 }
@@ -5986,9 +5986,9 @@ void kvm_exit(void)
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_irqfd_exit();
+	free_cpumask_var(cpus_hardware_enabled);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
-	free_cpumask_var(cpus_hardware_enabled);
 	kvm_vfio_ops_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
-- 
2.38.1.584.g0f3c55d4c2-goog

