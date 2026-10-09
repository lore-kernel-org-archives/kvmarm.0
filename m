Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFD83DDDBE
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 08:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791535552; cv=none; b=h/4kDVdbiuvlMM1WjZ+vOIHW2naDCHB8hBC2gMmMhe+hXI9kueZRej796ace2hwi2hjVIGBXPVk62PMlsEjmctYEnOEBYs5XggS0Xf/nh1Vtt8D61lTSQ7piFkkY2MKD+mkWSbXUo4m/TVukhPkeYxIndKrItgnEu/Wq95dgcUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791535552; c=relaxed/simple;
	bh=rr/cSP3qAQ6A5c5kAR8YIJQqjcKmys/CxSIO9WFPZ90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hw3/Fnr7vqbZQp/ZqzWjEHLGmiLgHrTQulDxfm6bd8x6+Iybcrrj4ObMGfy0ULdOYJR2rjpXY+lx8muFPmBg1rGjuR1ENiY5ttYm1qjjXX6zoEtaBROfZSNZHjXG7hISKyBELdr28sYuAZZGLYfmnDzsYzVzYb9OC1sJuMQ2Ce8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UDO5esu5; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UDO5esu5"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a009f82bedso35531025e9.0
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 01:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791535549; x=1792140349; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kYQM2I+r8judSPngvWcWEJb9im+ycy9cxj2LUpGCt2I=;
        b=UDO5esu5L/a7NpNytPIbWTfQf6AxA+ivxDk2BerLaREq1INLqMnaIORfUbkjMMIsrf
         nwRjc/5dSJfy8n37CsN8h9r1zSGFY6cMYXBVMK7SsQVmwBV9z0ZzjvFIGVCH0StgWmwW
         Kvk4FiRUFreES/SK7dfrE3lsjr8Ds/VUgDQzUmYsSJe+8lDqYaoVvyhqxCiUoxKMuVge
         GYJ0Sx1iywEL0aT+hrzpWQMn84LQSK7P/p9wRFQs+CCpNMvPQFSczOt/dabZ0L1U+Fzq
         XfAjkjIny+FpTf8jeuSJvW7lpEceF5GyRtgrOXEwN1g1Rf1QOZwxswxSNd5DDHalKTYw
         sYaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791535549; x=1792140349;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kYQM2I+r8judSPngvWcWEJb9im+ycy9cxj2LUpGCt2I=;
        b=LJBViLLjPpS9dMqwJ8pKoUKbztZNf6aaV+bh3MA7YUJxViZfcC+iRiNU4ksSbOOPJO
         rrujwJvxrl903x4jI+24M0dZpvV5I27FdrYi0RYpLWIOfMmWUZLvkYrS0E/ExiIk8RIX
         7hzZEoCEnaZaPjpDNOQwJvLEEL8wXX+feb8TMsErGHUbt/QoEzdr//GsiZqL27UAm4nc
         UAJh087sqjOBU8INLQJJDjefVtUI+gOFTv2ij53rQoqM9HL5Cd9h18N/z+P31nEESjjb
         D4QaarUoLanCs28rad/tGZ+WG+gr43WXokZhq02NfAqcoiLH5zeGo395KRR7yTvsFyPK
         pYdw==
X-Forwarded-Encrypted: i=1; AKwUvBzz/CVX5B0EzFtLLz26pgn7MvjinWt9QK/wb747MvR6vFU9jyv0qptQtksuQTju9+QzJxk4fbQ=@lists.linux.dev
X-Gm-Message-State: AFuF++n22ygqafE6X57agXvGY1RRs/ZvJlj3QxSYdfNyResXtyz2/4/F
	BO5UMSWsjPY+iWshI+mtKaX9jAiURyHlJqkED4dI2jhAU79ZZHc/n8Jehce/YhsRJq9Hxx5huJC
	bBh170IT8/OUi9IQIyfeWpg==
X-Received: from wmdv21.prod.google.com ([2002:a05:600c:12d5:b0:4a1:7101:895d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4ecb:b0:49f:f099:6fb1 with SMTP id 5b1f17b1804b1-4a18e4adcd0mr22678935e9.15.1791535549080;
 Fri, 09 Oct 2026 01:45:49 -0700 (PDT)
Date: Fri,  9 Oct 2026 09:45:29 +0100
In-Reply-To: <20261009084529.462577-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261009084529.462577-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009084529.462577-4-vdonnefort@google.com>
Subject: [PATCH v1 3/3] KVM: arm64: Add host_hvc hyp event
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a host_hvc hypervisor trace event to log host HVC call IDs and
return values.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_hypevents.h | 13 +++++++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index c1239d78c8f9..a37ba9db1cc7 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -60,6 +60,19 @@ HYP_EVENT(selftest,
 	RE_PRINTK("id=%llu", __entry->id)
 );
 
+HYP_EVENT(host_hvc,
+	HE_PROTO(u8 id, u64 ret),
+	HE_STRUCT(
+		he_field(u8, id)
+		he_field(u64, ret)
+	),
+	HE_ASSIGN(
+		__entry->id = id;
+		__entry->ret = ret;
+	),
+	HE_PRINTK("id=%u ret=0x%llx", __entry->id, __entry->ret)
+);
+
 HYP_EVENT(guest_hvc,
 	HE_PROTO(u32 id, u64 val, u8 handled),
 	HE_STRUCT(
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 76d08c503dc0..579615e3b2dd 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -996,6 +996,8 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 0) = SMCCC_RET_SUCCESS;
 	hfn(host_ctxt);
 
+	trace_host_hvc(id, cpu_reg(host_ctxt, 1));
+
 	return;
 inval:
 	cpu_reg(host_ctxt, 0) = SMCCC_RET_NOT_SUPPORTED;
-- 
2.56.0.385.gd3acb90ef8-goog

