Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B5D33A9C4
	for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 10:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769424297; cv=none; b=rM0mOw69ixwYaOyMkgUkJjCjU5ucihnCkEGTtsuVEXB+TUwW3FXcVYcta/CyZEvQWw/w7Zm5bn2PGYr18MpTvITV0zhcDL0jexZpqiKVsIodReLC1uBK8wQZd6f9nIgbqSzSTMTN4GSFtcIHzNndmqpyTAiW1HJdNLr8ytIVLE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769424297; c=relaxed/simple;
	bh=jc/1tMtJgbj0D+3+RNgTcGKl6/fF2uDcmqUjShgP6kg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=miYuqpvKiOiXp5CxzTP3tAxi14Adi2ZfJwD4U1rK3lvhhGAMSEKQd62S7RZhssiqT/oH2G8/LNFjKlgm4tQcjf2McBnWDBe+HV5umV8yZuwNlkUVfwREpqG8y4uW6YKgueTSj8FI4ii770Gk9p7Gr2qy2/o7VSKBHx2gExXGDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FcYQfSFs; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FcYQfSFs"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47ed980309aso30759635e9.0
        for <kvmarm@lists.linux.dev>; Mon, 26 Jan 2026 02:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769424292; x=1770029092; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NT+CpEP6PzXqQH6e99olRbkgz8yl4Nh6CScVnzMBNjw=;
        b=FcYQfSFslmLHHjxoDz1DjU4ZELDF1GSLSBqHT3N11Yq36F7L22g1spem7YTvns3sVc
         pA1xXvGWBcPleD6b6lO87Bv+eWz9JdxqfY+HMjT5rm6Zofn0w7D1ctw7BD/p8QV95OUW
         FWeuBd4lMbrvbkG+1RjbJfcqnwrHBJ5EW6K2wxF6mjVEV7HHibR3mYhfyijOazp1jUpO
         1TNtah5V6W3IBHP5Afv1hmfGOnDrl31XazisBnw9pUmfdvc6PiF58XlVyEYcDCLaiBuZ
         KADBWnqx0VCqqobgs0kXrt9z8LMQufM5WRn5tPadxctktpiCizKvQQY5J4YQYOyQ/Xi1
         UEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769424292; x=1770029092;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NT+CpEP6PzXqQH6e99olRbkgz8yl4Nh6CScVnzMBNjw=;
        b=tHuAgRVaQ8RCUmzicRxlbtgqIRjz0/r1eSQkyjPqO+6JcHNSsh/T73Ma2wlO2/8QGs
         VguadPrg/Wn3xvc/NfB0/sOnoRFWKTMK856SHKLHOfZ/6RUItN7Lrmq8o+rzhEfRV7Wv
         p8gUf/n9MDRh15NC/0kSbuaBxpeGQgC2zwEFNu3mPwfAFuqpJ1K+j2+eD8ng1XpT2pL6
         gRjU+sJfA7R8X5MO/CCDLzeFfTP9mPZ0Xhl5Lf5HVKVNA9CWOFZJTNzmM+RmC4OdRmLE
         YKgvigAtTxZK6EMAGT2t221U3nliIWYWZB/oj6h+0sMm/he/EB/tvTfZRd8Dg7skfcHm
         BePA==
X-Gm-Message-State: AOJu0YyJnkKNyfeygcHaEpzH/REqb6t+WLD2pb9DeRrI1VGwO60SsOMT
	rT43poYiI9pcydqKE4UiQRTPFS6g0DLVPS8SkPa7jQBvUpjwN7Jl0usJrnEm4/AaD9ZT/q+p9Rb
	hhQgpKkt1RmrijS7hmqFxdg==
X-Received: from wmcv18.prod.google.com ([2002:a05:600c:4292:b0:47e:e776:2495])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b6a:b0:477:9e0c:f59 with SMTP id 5b1f17b1804b1-4805cd0e356mr65382385e9.2.1769424292276;
 Mon, 26 Jan 2026 02:44:52 -0800 (PST)
Date: Mon, 26 Jan 2026 10:44:18 +0000
In-Reply-To: <20260126104419.1649811-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260126104419.1649811-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260126104419.1649811-30-vdonnefort@google.com>
Subject: [PATCH v10 29/30] KVM: arm64: Add selftest event support to nVHE/pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a selftest event that can be triggered from a `write_event` tracefs
file. This intends to be used by trace remote selftests.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f8fa556ec3e1..c045c074614b 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -96,6 +96,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___tracing_update_clock,
 	__KVM_HOST_SMCCC_FUNC___tracing_reset,
 	__KVM_HOST_SMCCC_FUNC___tracing_enable_event,
+	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 221a1dacb2f0..743c49bd878f 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -46,4 +46,15 @@ HYP_EVENT(hyp_exit,
 	),
 	HE_PRINTK("reason=%s vcpu=%d", __hyp_enter_exit_reason_str(__entry->reason), __entry->vcpu)
 );
+
+HYP_EVENT(selftest,
+	HE_PROTO(u64 id),
+	HE_STRUCT(
+		he_field(u64, id)
+	),
+	HE_ASSIGN(
+		__entry->id = id;
+	),
+	RE_PRINTK("id=%llu", __entry->id)
+);
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e1d4a53260ff..5655c1690f4a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -643,6 +643,13 @@ static void handle___tracing_enable_event(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __tracing_enable_event(id, enable);
 }
 
+static void handle___tracing_write_event(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(u64, id, host_ctxt, 1);
+
+	trace_selftest(id);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -691,6 +698,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__tracing_update_clock),
 	HANDLE_FUNC(__tracing_reset),
 	HANDLE_FUNC(__tracing_enable_event),
+	HANDLE_FUNC(__tracing_write_event),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 1ad6a55ba95c..c1e28f6581ab 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -348,8 +348,30 @@ static int hyp_trace_clock_show(struct seq_file *m, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(hyp_trace_clock);
 
+static ssize_t hyp_trace_write_event_write(struct file *f, const char __user *ubuf,
+					   size_t cnt, loff_t *pos)
+{
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	kvm_call_hyp_nvhe(__tracing_write_event, val);
+
+	return cnt;
+}
+
+static const struct file_operations hyp_trace_write_event_fops = {
+	.write	= hyp_trace_write_event_write,
+};
+
 static int hyp_trace_init_tracefs(struct dentry *d, void *priv)
 {
+	if (!tracefs_create_file("write_event", 0200, d, NULL, &hyp_trace_write_event_fops))
+		return -ENOMEM;
+
 	return tracefs_create_file("trace_clock", 0440, d, NULL, &hyp_trace_clock_fops) ?
 		0 : -ENOMEM;
 }
-- 
2.52.0.457.g6b5491de43-goog

