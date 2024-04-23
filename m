Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F8613BAE8
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884746; cv=none; b=sQaI7AHLk465iR8Rfw7txXojYNrzz6mwADjlDoyl8RmlAP2yWIHMuVgQMSP9BxDh4b/N33njlR9AMT9H6tdvpkm1Qq9PgKKhhDOIShPTCEwVc6G+xTdnVa9UwwCOYyAlsveKrr8SYtbWaayTPQbu3MSLIEaUcRjO+J4uU1qxxyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884746; c=relaxed/simple;
	bh=BShtqt08ogWEX4QFSRTIZr7L2RF+3WFNe2hPtYtmZTY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sW742UaLHU8pe0xNCZYwkYGkj4URkiaEFjf9JbBUABLBAsZtnOmMX7Asb9k+h3NT55IrL5IYNLWplKoWlri7cjAf+Wbf9GNT+gK590MgLY9TQ5e1xxJDjF82fZUzzpLeiCKr0uHx8wG6B5DnH3ch0/sYOmn9IcISfQLa6Cpr5cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bPb8CDTQ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bPb8CDTQ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-41a38f6e371so11470545e9.2
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884743; x=1714489543; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=arQC4jBKrcnS/52i0oXg3O8S03FeaxatNMzzV7zmtr8=;
        b=bPb8CDTQqcdC8B8BNYFVqZF4ud15nc5TLRlhcAsqOUiuGiqQmx5M8ZzHDzD8L02KTQ
         Li0L7IoMuOm2T4eb607xzO9B08MwrvahmgyRhn+BH0Dhvzy2PCjpEinCVUQg5SIg0AU0
         /TtS3QodXFE5x2H21vzekXTJMam7+vYzedml6OEGCCAvMQs17iUdgju7CpACiAKK9vyR
         At0IL6IW8THZtN6egKP5OANIYzS19ZVbwodmxUABaAfuVmYAEq05GDwEhrvexEYtsYRP
         8X7jIaHq2FdTXGxZ8NGR+uHbfgdKjuXHJNPcNw/UFluhlm7sHaDrEvh+2Zo2was0B0fQ
         rz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884743; x=1714489543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=arQC4jBKrcnS/52i0oXg3O8S03FeaxatNMzzV7zmtr8=;
        b=nFUsivj+LCZVEFJgVWQuf5gMcuRsz5xlzV7PksqXaRLtJ00ZFWdrWPuea/yqaNnTIi
         V5owOSnLVMSdWWser87vV4rck4meByxlRHUdE843RbF6ARfEO3NOtElV9SXOVAdlmLDY
         vGy5XwfiQ0QORkm8rCRJrDME2dZ1CCzuUKhElw5TCIdwGYm8/akv2bO41uX+NY1Lzuh7
         L6bgOM4A6j60b0kf20xZZLnOmZ2lXN1voMaTxyofxXGXJcc4+uvUX4IusAvRDdiIdBCX
         4yH0sH4/ueHbbOOP2GSpG1cVWHil/hJDCdKUbFDr7SkpnF3hd6+ISHUHRKm4fwxcQC8A
         VagQ==
X-Gm-Message-State: AOJu0YzWYLQ0YvqwMoiBihojj7Oz3ECnZs9jQXz6UtACHJVOjyV1oSGb
	DltvdDIIVVyb1z5GqpOVV+TWppEmiU+ec3qlVOM4Ap6VwknPa5S0dpJCYSBb2FsmASbpaURcZvk
	Yn0K6sw6PWOfpzaBMVzvK14jAR7e1KJ4EdCBs8XRy3E8J9mRHiCFCzSqP8Nysf6S+b+5dYJzUL6
	w5irweQIGC6tjNCeHfu12KxIgNCqQ=
X-Google-Smtp-Source: AGHT+IGUW30a8wEF/i6HCpIxFxq9/XJdvSiHMe1w8KpRJj180gqLkvy0mkV7qWf4rcdQuRESpoufEL088Q==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:450b:b0:418:e3c6:1832 with SMTP id
 t11-20020a05600c450b00b00418e3c61832mr86481wmo.2.1713884742853; Tue, 23 Apr
 2024 08:05:42 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:09 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-2-tabba@google.com>
Subject: [PATCH v4 01/30] KVM: arm64: Initialize the kvm host data's
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

