Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4BA3C6A45
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 14:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807785; cv=none; b=I2hPGsbY1q5rxq37XuYUZJrgtmz34og/ICj+QzUexKleu5iLE8/C8IL+HwAt7eDBwaTjtKgTB1mKl9E7438ljodEErjDLVBbvwmybXhb7L5ZUtM1kUY/LEVHTjwbc209Rg3fxuHRDrTgldntMDgp+e37pV0a3Grkp+thLFbGdiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807785; c=relaxed/simple;
	bh=Hq3pw944yEctnZlP5UAA9Ov4xnMxVYtjU2DXhQ3r5cM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=utobt8rUPM1/wHuv25RlJPXscGy41BKPQM7YyXY8IXmxmHO1CkHdIUvW9XjlXOmvCVKOSLD2cS7huGFR9TIENEvFf/wuo5IMHZPqE3273Wkid0mIWUyGWgKNiJ/zVF4ejI1ww4IuDLGXwdeQJeAVeTPKDlwcadm9Zr+pa9VXH5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lOzZnm7p; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lOzZnm7p"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48372facfedso83409815e9.0
        for <kvmarm@lists.linux.dev>; Fri, 06 Mar 2026 06:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772807782; x=1773412582; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VBnYryU8DAHWNMJIKaPrPbk+603MWk0xgkkJlIYXdOA=;
        b=lOzZnm7pDaAT2F/EgHTN3DDL4upDiCUgL2NwMk/oIxZB+JsKwFYhMzKOwO6TJeoaed
         5w/VROdvNmZwvjEvqpOkT30CtKOeRaHEmDK/lgYT/ZAHnDYFQEmPVb2bEZaKsanXZozN
         Lv2QFv2owoaVW4pepC5VKoj0ydrf+ZphSPKRXbEV8fCw/rl0fV64t55yZvz7BORdNraE
         MTXlOq4BzBKmNSwokwGnEBq8URfnURDEiF6R5x9m2lHHJkXphVGyGRWZj8Ikfh9/sB84
         vxjGp+dQvMR2cIBxq2SAvOvc/Uv98nWIhdduJLKApI05+go+0WNNZH0dLig1BT8PnXPl
         00lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807782; x=1773412582;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VBnYryU8DAHWNMJIKaPrPbk+603MWk0xgkkJlIYXdOA=;
        b=j/gXQJa3Nr9kmt2DTQjGOSgi19S9StTDGshywRtGWkAwjU3fJKmbIyiTn1WrJhZwj7
         3FP664tNUOR37ZnIIYLlZ5kVrV12RkAlzq7ICcA1WEm88ogFUeR9MzLY1BE4olhjD41O
         lLi4zbC03OQsV99bVOSJNes4yZbsUXQIm+6RCdMTQDCKLIjQZkJDgW12fDry6s5debbq
         HQcvWhubILjYZFenxwjW6aNm6TiBYOzDjvu8rAInRWCbzcqJParE5xyp/nmnOTijt8D7
         qRnRn2pxpQH05Nmb2ImGf2yNLfMTdheTfmYzt3idXkU+/294xloGLyI84YK5vUTFf1kY
         Jjmw==
X-Gm-Message-State: AOJu0YwJuB05ijbV6dc1prpRGpruNxAkCrABt857cxF159qzTihW07i3
	D8eKx0UWtvuCnBD+29OrIPWB4WlSw67GAhzzpQUxvbf6LXfdXcsddQTjNeBAWhXNkjpxoIq2YzZ
	sBSm9Nzm10U96PvBjO2Q6ZQ==
X-Received: from wmna22.prod.google.com ([2002:a05:600c:696:b0:480:2051:60e1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc4:b0:483:6d9e:e4f5 with SMTP id 5b1f17b1804b1-4852671c9a6mr36238685e9.5.1772807782036;
 Fri, 06 Mar 2026 06:36:22 -0800 (PST)
Date: Fri,  6 Mar 2026 14:35:33 +0000
In-Reply-To: <20260306143536.339777-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260306143536.339777-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306143536.339777-30-vdonnefort@google.com>
Subject: [PATCH v13 29/32] KVM: arm64: Add selftest event support to nVHE/pKVM hyp
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
index 47d250436f8c..c8eb992d3ac8 100644
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
index 547d63679022..eff9cb208627 100644
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
2.53.0.473.g4a7958ca14-goog

