Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D13E4C1
	for <kvmarm@lists.linux.dev>; Fri, 10 Mar 2023 22:14:19 +0000 (UTC)
Received: by mail-pf1-f202.google.com with SMTP id b8-20020aa78708000000b005eaa50faa35so3546159pfo.20
        for <kvmarm@lists.linux.dev>; Fri, 10 Mar 2023 14:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678486459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pE0BeI9z8Btfvf5fmHYTFVBRcoqQtEODzvdHtDO3xCE=;
        b=nRb2x/Az02iItbQ3I1bSF4yJ9xu29h0hIwwWhVNSJNRSMZNeINtGtQihw8x/ogzEwj
         Vd5WHSRuHp58cuzg+TBKg88rjb8fidPwPHdxzg3JtQyhLzyp6UXqN+RgK2NB0Vv0eP8j
         RyIk8lIGN74xRgM5GkcSf7HJJDRvg87Kooip0b7WCcy3+vUFeTtDqXBYfFNpHldfChxg
         P5F6EEbuDxLxeqSmK6GaQy17ujAAN0c5HgbwydDUWLCR30mDFyMVo62MgbmKkdNIoQHG
         WWx2BBn6pbm6Ecxov3jmRE3kuoJEy5J0lX4KhD6cm6eJrDSn+8pst2PuKMNhZrxIxurE
         M/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678486459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pE0BeI9z8Btfvf5fmHYTFVBRcoqQtEODzvdHtDO3xCE=;
        b=TPS39Fio8FdHV7WuBfjPnJ9qvGl2ktdIT0k1Obh6++md7zRVJ6KUqyws1jKuunvnDz
         qSxtdjfv1l06H7faP7CfR+kpamwXYg+1RmZZCt310FA9QO/VDjfGULuzdLw4ld3cmAFT
         UeqbEi1OuP1OszpTLMinEW0HbrjSVO7u8scnK5xbQeVoUYoypUIAktvOuwU6z8A4lQ7H
         MBrfiiCw0Kj8+G1pZIGCvZVgAB18DrVWsX1tj0liYep1qYsn89m2FPJL7WCYUhZIujlH
         3eFNyAyff2995BWALPdQQtPsvbaSxyEhJc/7z9S20hqC7kMNvceXvdKkRxlRvOHo9wDm
         u7nA==
X-Gm-Message-State: AO0yUKUXfgCwzuTkLVj9DS5tFOBXk566cU05EZkHZFK49muBtKEMN4qg
	m66I68lJUWywGHyxSRZ/vgcdexX6ndA=
X-Google-Smtp-Source: AK7set/UaGZlFDNJJDtnC1S1I4yxriVlz2I1afrzyalSLmeX7FDonyxhmqzPFzIIW/vSmY89hMYR7KUSZJs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f783:b0:19e:2a1b:2798 with SMTP id
 q3-20020a170902f78300b0019e2a1b2798mr10477888pln.4.1678486458964; Fri, 10 Mar
 2023 14:14:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Mar 2023 14:14:13 -0800
In-Reply-To: <20230310221414.811690-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230310221414.811690-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310221414.811690-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: Use syscore_ops instead of reboot_notifier to hook restart/shutdown
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	Huacai Chen <chenhuacai@kernel.org>, 
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, kvm-riscv@lists.infradead.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Use syscore_ops.shutdown to disable hardware virtualization during a
reboot instead of using the dedicated reboot_notifier so that KVM disables
virtualization _after_ system_state has been updated.  This will allow
fixing a race in KVM's handling of a forced reboot where KVM can end up
enabling hardware virtualization between kernel_restart_prepare() and
machine_restart().

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc: Anup Patel <anup@brainfault.org>
Cc: Atish Patra <atishp@atishpatra.org>
Cc: kvm-riscv@lists.infradead.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d255964ec331..6cdfbb2c641b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5211,8 +5211,7 @@ static int hardware_enable_all(void)
 	return r;
 }
 
-static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
-		      void *v)
+static void kvm_reboot(void)
 {
 	/*
 	 * Some (well, at least mine) BIOSes hang on reboot if
@@ -5223,14 +5222,8 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
 	pr_info("kvm: exiting hardware virtualization\n");
 	kvm_rebooting = true;
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
-	return NOTIFY_OK;
 }
 
-static struct notifier_block kvm_reboot_notifier = {
-	.notifier_call = kvm_reboot,
-	.priority = 0,
-};
-
 static int kvm_suspend(void)
 {
 	/*
@@ -5261,6 +5254,8 @@ static void kvm_resume(void)
 static struct syscore_ops kvm_syscore_ops = {
 	.suspend = kvm_suspend,
 	.resume = kvm_resume,
+	.shutdown = kvm_reboot,
+
 };
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
 static int hardware_enable_all(void)
@@ -5967,7 +5962,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 	if (r)
 		return r;
 
-	register_reboot_notifier(&kvm_reboot_notifier);
 	register_syscore_ops(&kvm_syscore_ops);
 #endif
 
@@ -6039,7 +6033,6 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
 err_vcpu_cache:
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 	unregister_syscore_ops(&kvm_syscore_ops);
-	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 #endif
 	return r;
@@ -6065,7 +6058,6 @@ void kvm_exit(void)
 	kvm_async_pf_deinit();
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
 	unregister_syscore_ops(&kvm_syscore_ops);
-	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 #endif
 	kvm_irqfd_exit();
-- 
2.40.0.rc1.284.g88254d51c5-goog

