Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9723D516
	for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 23:09:44 +0000 (UTC)
Received: by mail-pf1-f201.google.com with SMTP id y23-20020aa78057000000b00574277cb386so162986pfm.16
        for <kvmarm@lists.linux.dev>; Wed, 30 Nov 2022 15:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=E8JVGgtDpa1adQbcFKdjF0h5x+zc5eW3OzNDv17W+I0=;
        b=DS5tl3JZt5ENZ41z8LWoU7l/LLAZg0bKxr9NB64mArQBR7Z4xQ54gwA8E1Foi7ucUI
         WLpYLHet6DIopxUbH10y1vLmghI4adUhheVz2l+sfpolKRTogMb2+JXMX5kC+1I07F/z
         xq02cwtlNoKx8xWnfdsY/DFfLTDmRaQZCHvCCDtocOPTXWGXE+6cy/K/TTmkXZECJ1T5
         UPbbMU++Q0JdnDp6PdsJU4We1R6snVfDObMmpUXwD7SotdnLb3fRUaZHvapd0uWqxFq9
         B+vmtfzyaE3KTk8T/zN+WUL7QMUukMAgZHVrZIfnA64+0ySQ/W2zwvQkWpKfKL7fFmQx
         zvng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E8JVGgtDpa1adQbcFKdjF0h5x+zc5eW3OzNDv17W+I0=;
        b=qLpOfRHYrBM3RsxRjC9QYncyl1h6axl5J7Tls25Fp47ATFssx0n7Xfd3A/kg0M9UKK
         k3Nz6eJ0rlCEXmxLNBvdHiuWmF6UW3qVAC6pgXYw7yX0oNoGce0xd+nl6PU7oOAVYLnm
         mab0NM8DBwSRgecAoM7WAay34FuhSh9eKyfBJXzTNbhjjvushCnTWoaWtja8mDhwDEyw
         0MBwtOmUi7nVpd2pg9UbGYCUAc9KKMBg+FlbO2B9TuV3a1SxKitqypzu6E9O4dE+ISru
         huyC91JE9WDuXBGYQzJlb8IYR/yYrcTKK8ml8Oxt8aqHy1BdpsCDv1+zCwU6xyDsrkhp
         pTZw==
X-Gm-Message-State: ANoB5pnoiThA+hfGQYPkXsi46Qx7Ayz0Q0npmwpOiWwBRP9swyD+oEn9
	vnI/4LxpfHDZnrUw50yP1elUQmzCV5s=
X-Google-Smtp-Source: AA0mqf6Q0BFR2rWNLKbL3PfSbJ45azh4M9K0FqaT09LmFusT3iMI987lBa2MWHLHJI40i8Y0hHfQV/M7a6M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e887:b0:189:1fcf:6ceb with SMTP id
 w7-20020a170902e88700b001891fcf6cebmr43466277plg.45.1669849784316; Wed, 30
 Nov 2022 15:09:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:08:48 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-5-seanjc@google.com>
Subject: [PATCH v2 04/50] KVM: Teardown VFIO ops earlier in kvm_exit()
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
Message-ID: <20221130230848.9SL6fQYmONXq14vsEl9pSSQueSDlY8rc9MCnk7nciTw@z>

Move the call to kvm_vfio_ops_exit() further up kvm_exit() to try and
bring some amount of symmetry to the setup order in kvm_init(), and more
importantly so that the arch hooks are invoked dead last by kvm_exit().
This will allow arch code to move away from the arch hooks without any
change in ordering between arch code and common code in kvm_exit().

That kvm_vfio_ops_exit() is called last appears to be 100% arbitrary.  It
was bolted on after the fact by commit 571ee1b68598 ("kvm: vfio: fix
unregister kvm_device_ops of vfio").  The nullified kvm_device_ops_table
is also local to kvm_main.c and is used only when there are active VMs,
so unless arch code is doing something truly bizarre, nullifying the
table earlier in kvm_exit() is little more than a nop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ded88ad6c2d8..988f7d92db2e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5980,6 +5980,7 @@ void kvm_exit(void)
 	for_each_possible_cpu(cpu)
 		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
+	kvm_vfio_ops_exit();
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
@@ -5989,7 +5990,6 @@ void kvm_exit(void)
 	free_cpumask_var(cpus_hardware_enabled);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
-	kvm_vfio_ops_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
 
-- 
2.38.1.584.g0f3c55d4c2-goog

