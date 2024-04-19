Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1839947F6C
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 07:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513588; cv=none; b=dcDLPC9PE+wcDN97h9Qa1bLxqFtTeC/jXLvtfA8yRmGjKXEjti2Kh2qQz6paxyyzG0SeaTarn2Lhk9qSLXvusalH4kTQnK+7HCQfk8oYqlQAJ+LQphaT4ALywjQTs3NfW1uFzy3PrYk6LDisURbNvZ9fPY/XSn0Ong5FzXi6xus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513588; c=relaxed/simple;
	bh=BShtqt08ogWEX4QFSRTIZr7L2RF+3WFNe2hPtYtmZTY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ERYbzgJucmp5vQim+h5U25I+nUi4iaxV4OOoJLqtyUOmTaQvhK07zySLu3NbEklu59l+INQ4pnoUVwTIViDwHQgCGLs9ATwrglwGb4usEKZ2EkG7Zlt9by95V++fuES2yfLFoZb3ef/fG/9IKTvnjECx2aVjHTgGkOHumK1Lwzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ukebp6LI; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ukebp6LI"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41485831b2dso14454525e9.3
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 00:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513585; x=1714118385; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=arQC4jBKrcnS/52i0oXg3O8S03FeaxatNMzzV7zmtr8=;
        b=ukebp6LIb2GMOwyJPFr1GqxB/Xe2YLx4ZkCHct5m6Tai/2UscJyjenz1sSNN/uuTiN
         P0FsXqxnUZ7DF9jeYzX76BkVDA7VvlIx0Pn77pFQkp4umEfkqnERn/bE//mKfCD26dZg
         INsBTNWd5DdArUkrdF2NDwJ9GR8UuSQJ/PVRl9km1JICWELOGDsga/lkpM1aOlZfEHJu
         jZVl4er1KaQWzXI/HTx6eDAWqImhHgYyEVviIsXz6nEg15XiP6uBh0drz8xqXslJd+tN
         KrPXMG+Mbjc2jeyt177VSWvZy962J/rtfdYX/3U5AO2fvEXVdUIwrelde6VhDUsy3o+9
         Jaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513585; x=1714118385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=arQC4jBKrcnS/52i0oXg3O8S03FeaxatNMzzV7zmtr8=;
        b=WkgrexgAk/7AkdMyEe28eoi9reR/GDlT5Gw9ptYUNBPyCMlBTXuz2CXwiPcxotsZyG
         D5wZVhXwfO+/i1uprz4ORCgiQxxIG6gVjaaE68chOXjl0cTjAzYoegzj7GPzVqt+xHzW
         /4C7s5o/1Uq82qBrOL8xD4qouMIyoLkAAxlQF445/0GoZmjThqEF4xeXMFKbncGoQiR5
         Vck/vF4oJqK+xM5tnI5GXn12qU5bLRJfmlE4HceK2DFyTey3P0spa8+1ku553oIkqw3H
         loaedk/e0UyzyziYwZJtMDmmGNZMU5ldaBJul3UNdqS45TeKlcazlMV+e8cxS3WBm6RK
         bz6Q==
X-Gm-Message-State: AOJu0Yy+d4H4QLgFFrrkIOR2BzSPRH9yUkk887lFt7XoPtisU159MiSN
	XPDIHJEd16k3WTjABgXr1RCu0S3hiBO+JH1FyRnBEe01h4OxVwbVON/di74w3WLXbjnCBKrv+SX
	Rf4dWoXUJ6Fvw9i2DxfDGZR++YY5+ovgyd2LSwsj92gyZ0rsv56j8mR1c8nHajbgjknM8c1nWPy
	O8e+wHtWZhcqMdkbtDg4wg31OB7xA=
X-Google-Smtp-Source: AGHT+IEI7voauUp5u2J1dvcwsUJ8m5ZO+2e6cSJAzJlLQOMPzWo8fF+CSNCeQzM3lPWcvFlao23lNXlVFQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:e0c7:0:b0:33e:d448:987d with SMTP id
 m7-20020adfe0c7000000b0033ed448987dmr3888wri.6.1713513585474; Fri, 19 Apr
 2024 00:59:45 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:11 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-2-tabba@google.com>
Subject: [PATCH v3 01/31] KVM: arm64: Initialize the kvm host data's
 fpsimd_state pointer in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Since the host_fpsimd_state has been removed from kvm_vcpu_arch,
it isn't pointing to the hyp's version of the host fp_regs in
protected mode.

Initialize the host_data fpsimd_state point to the host_data's
context fp_regs on pKVM initialization.

Fixes: 51e09b5572d6 ("KVM: arm64: Exclude host_fpsimd_state pointer from kvm_vcpu_arch")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c        |  1 +
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 82b3d62538a6..20c3f6e13b99 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -54,6 +54,7 @@ pkvm_hyp_vcpu_to_hyp_vm(struct pkvm_hyp_vcpu *hyp_vcpu)
 }
 
 void pkvm_hyp_vm_table_init(void *tbl);
+void pkvm_host_fpsimd_state_init(void);
 
 int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 		   unsigned long pgd_hva);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 26dd9a20ad6e..492b7fc2c0c7 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -247,6 +247,17 @@ void pkvm_hyp_vm_table_init(void *tbl)
 	vm_table = tbl;
 }
 
+void pkvm_host_fpsimd_state_init(void)
+{
+	unsigned long i;
+
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		struct kvm_host_data *host_data = per_cpu_ptr(&kvm_host_data, i);
+
+		host_data->fpsimd_state = &host_data->host_ctxt.fp_regs;
+	}
+}
+
 /*
  * Return the hyp vm structure corresponding to the handle.
  */
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index ae00dfa80801..859f22f754d3 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -300,6 +300,7 @@ void __noreturn __pkvm_init_finalise(void)
 		goto out;
 
 	pkvm_hyp_vm_table_init(vm_table_base);
+	pkvm_host_fpsimd_state_init();
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
-- 
2.44.0.769.g3c40516874-goog

