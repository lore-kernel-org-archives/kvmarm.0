Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8B5E4C1
	for <kvmarm@lists.linux.dev>; Fri, 10 Mar 2023 22:14:21 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id b20-20020a253414000000b00b305140e33cso3024443yba.0
        for <kvmarm@lists.linux.dev>; Fri, 10 Mar 2023 14:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678486460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2opxKga+fb5i4H+BY6IhBhjz7Vmgmcavrh6WO0nAabw=;
        b=XANFaeRYOx5Rd/kapDHhNmO90qoMVlvQlylWOJKFiusgRTk50x3TP11Tb99KjhRtRp
         Ilp6Fnx2ETLBE3ONxbTQK/JHBUg90svkVN5Ksjq6gDLd6XGGLH3cF/yhlaBgocMStinz
         BgYUmwsqJH2QawF4/6NH9+aU6CFGqKWcG0poEIYHj6EwiQB9E2zPA277B2ph+E8+ViKI
         skXt6AXZdpliK6f0KboRPpk16NPL23XsUnuJZwzJxP6uQZnZFD4DhdkN8ZAiCA34+SyC
         eiBTO57MgJwbaZpawRvV5J7htbbDb96jJ2ohiFCXMIPVyvl34nTNPoV17hacH1Od+NjM
         RPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678486460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2opxKga+fb5i4H+BY6IhBhjz7Vmgmcavrh6WO0nAabw=;
        b=U9gmExcXr6iCwH/3yYCs5vC7Gp1X8XE1ubaXxh7nYaoASRyrPexI2nUBjmvs7BxcW3
         N9Mi+veh0hIzKB6m136jtx8GwahuOX32hub9n7Lr05w0oADn1zDgGDOWRPBASU7KqABc
         NQTggPjEoBz4FoGsOmsgXcprHMM4pbNH9bshUwAfTjkdOxPKFFn52p2h0DCtOV1W86ol
         cgS2AroMSAfEm6YFgsARjMPD/OftIL/cEFX/tLoVn8HNEBv2jRmXi7q6wqT6rMOXLmeJ
         y+oHXy62nkujvGQfuN6TBnI7X1nxoNIGPlx9/W2xmu90knyCBCpGBD6ME5d4uzbH4Q90
         Povw==
X-Gm-Message-State: AO0yUKUnxyKuaXdd7uLnAL4W5v/ENaOU//rBL7ROhkGxBw5McfNnANir
	wUcFHecWrbjda2hjmdS1qsByAOg5NLg=
X-Google-Smtp-Source: AK7set9W78UovW/m1wQ6WBrZF9xvfIQRknxFWcTaYsNYshb2LLp3atXf4mwpxmtOXFU5GAMHzAFXebzuJ+s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1149:b0:8da:3163:224 with SMTP id
 p9-20020a056902114900b008da31630224mr2418826ybu.0.1678486460678; Fri, 10 Mar
 2023 14:14:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Mar 2023 14:14:14 -0800
In-Reply-To: <20230310221414.811690-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230310221414.811690-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230310221414.811690-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: Don't enable hardware after a restart/shutdown is initiated
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

Reject hardware enabling, i.e. VM creation, if a restart/shutdown has
been initiated to avoid re-enabling hardware between kvm_reboot() and
machine_{halt,power_off,restart}().  The restart case is especially
problematic (for x86) as enabling VMX (or clearing GIF in KVM_RUN on
SVM) blocks INIT, which results in the restart/reboot hanging as BIOS
is unable to wake and rendezvous with APs.

Note, this bug, and the original issue that motivated the addition of
kvm_reboot(), is effectively limited to a forced reboot, e.g. `reboot -f`.
In a "normal" reboot, userspace will gracefully teardown userspace before
triggering the kernel reboot (modulo bugs, errors, etc), i.e. any process
that might do ioctl(KVM_CREATE_VM) is long gone.

Fixes: 8e1c18157d87 ("KVM: VMX: Disable VMX when system shutdown")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6cdfbb2c641b..b2bf4c105181 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5182,7 +5182,20 @@ static void hardware_disable_all(void)
 static int hardware_enable_all(void)
 {
 	atomic_t failed = ATOMIC_INIT(0);
-	int r = 0;
+	int r;
+
+	/*
+	 * Do not enable hardware virtualization if the system is going down.
+	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
+	 * possible for an in-flight KVM_CREATE_VM to trigger hardware enabling
+	 * after kvm_reboot() is called.  Note, this relies on system_state
+	 * being set _before_ kvm_reboot(), which is why KVM uses a syscore ops
+	 * hook instead of registering a dedicated reboot notifier (the latter
+	 * runs before system_state is updated).
+	 */
+	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
+	    system_state == SYSTEM_RESTART)
+		return -EBUSY;
 
 	/*
 	 * When onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
@@ -5195,6 +5208,8 @@ static int hardware_enable_all(void)
 	cpus_read_lock();
 	mutex_lock(&kvm_lock);
 
+	r = 0;
+
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
 		on_each_cpu(hardware_enable_nolock, &failed, 1);
-- 
2.40.0.rc1.284.g88254d51c5-goog

