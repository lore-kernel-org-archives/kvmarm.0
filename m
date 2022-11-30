Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F705C4321E
	for <kvmarm@archiver.kernel.org>; Wed, 30 Nov 2022 23:11:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DE134B6EB;
	Wed, 30 Nov 2022 18:11:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v-yEre9etXtO; Wed, 30 Nov 2022 18:11:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1D514B796;
	Wed, 30 Nov 2022 18:11:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D49E4B636
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:11:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O8suNBITeNlS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Nov 2022 18:11:03 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B70B94B73E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 18:10:56 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 w2-20020a17090a8a0200b002119ea856edso3789451pjn.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Nov 2022 15:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
 bh=feUvU0TLPbMF/Oljy4/vBwowA1Kv3aShJc2OjvbIIRg=;
 b=XCz6nxyHGgxyXLRmcMfZAC0EtbhsJIztANoSGpUb1GyxR0U89bx0wlthHvMKMPI0ma
 xTY/WZ7Fnj2wVoHKg3Vrqyc1suf4XCMLsHgGlIH3pS8IMgIqbDNn8Omsv3AOuHpjB+t4
 oJgjvYZQ+8fVUpIqLH/jYWFcOCZ826P4/OUhmmvNmOkV9CXcwA4ogZ7MlttInnuYA3IQ
 qZwoJRmoUlDf0X9EXI/DaNlV615GX7fyKck9fxTOKS6fYcbuWk1qBQZKq1fDAhiXHC8W
 oTikmOFUnyHawi/4Gg7a9PphvtU6rlpDzwiPDXnAHDvGYvOqtwCfNDpZ92x3xkT78SFn
 sWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=feUvU0TLPbMF/Oljy4/vBwowA1Kv3aShJc2OjvbIIRg=;
 b=4ZPgyBrPC0JWhQxGXg7g5rKRzX1wCmZJguyFSZYi5U0FAhmp+HQe7xSY9sFORuZNeh
 0By4q4WuIhMDA1c+I+8Izv5tyuOxNj1Sz0ptnq/DBNt8A6aV1nSFcHa0xQNzqohnDtTn
 +UgISz9ruQmwTt2V7qiDPwOvvHWOlhy+UeBPPJH86jTpvAEBDIGpcoOcG+Gy1q78Z6sk
 pXHdTU7V1OUxYHjawSy5Cmdc552gEhDYDZZ54UlDWQF4EfNqmbH5pw4I8XXTtZOoACKi
 g4U9Rn8s3pY6Aosff8+ubuTfucGixhyKqz7IuMc1u+hH2bphs6u25K8UXzmvFku2yvhs
 o/yA==
X-Gm-Message-State: ANoB5plGgdzZ5A1ZJXaPeGLRRjFPdzRbOxSQEdhGJYZuDciyEhqoPpgE
 tB5stZYnPInZyQOzjj7A9eXInYrOp3I=
X-Google-Smtp-Source: AA0mqf7uQUQw4xuwzzaB6cJbzF2qtgtcI8g7o82e8li02vBC7sSOacIeo1pVvgKatFPeZtczncyD3ypFXvs=
X-Received: from zagreus.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:268d:b0:189:a50d:2a23 with SMTP id
 jf13-20020a170903268d00b00189a50d2a23mr7180858plb.32.1669849855698; Wed, 30
 Nov 2022 15:10:55 -0800 (PST)
Date: Wed, 30 Nov 2022 23:09:29 +0000
In-Reply-To: <20221130230934.1014142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221130230934.1014142-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221130230934.1014142-46-seanjc@google.com>
Subject: [PATCH v2 45/50] KVM: Remove on_each_cpu(hardware_disable_nolock) in
 kvm_exit()
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Drop the superfluous invocation of hardware_disable_nolock() during
kvm_exit(), as it's nothing more than a glorified nop.

KVM automatically disables hardware on all CPUs when the last VM is
destroyed, and kvm_exit() cannot be called until the last VM goes
away as the calling module is pinned by an elevated refcount of the fops
associated with /dev/kvm.  This holds true even on x86, where the caller
of kvm_exit() is not kvm.ko, but is instead a dependent module, kvm_amd.ko
or kvm_intel.ko, as kvm_chardev_ops.owner is set to the module that calls
kvm_init(), not hardcoded to the base kvm.ko module.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[sean: rework changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6a8fb53b32f0..a27ded004644 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5981,7 +5981,6 @@ void kvm_exit(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
 	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_irqfd_exit();
 	free_cpumask_var(cpus_hardware_enabled);
 }
-- 
2.38.1.584.g0f3c55d4c2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
