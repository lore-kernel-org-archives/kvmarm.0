Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792808699;
	b=k+lMfoHKx0/kLUYw1CHTD1kk+aMjtAQ/sDhC7rDlT3vBsZ+1uAh6ORpgFs+ug2rOxshz
	 X2ZJVSJI1e233P+rQvJ0+fziUM6YXY4EIkvIPIUFQXGuwXx/XLaK5aZmOoEBqza+X+XSH
	 eqqFC3f7LkgCzitC5G0TfglFieGxmNtHljy32WsQlmRg5BnYY89ivTEWL/1oP3xx0dF1c
	 7KF5502SDPan2X0J0up8/3iu+veZ6m8ZhYOu5WZ5v0syl1CVxklcadgeYXTcnApX/nS/k
	 WLHMsysCxcaHLoEnNfEuzgXevd8zSy+6+AlUckbtuko6NSlguUMXwnw9zvZScdafPzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792808699;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MwaAPfyutmKmJPECsVQASiFKd+n4QdGa9vMFjSb1Ixo=;
	b=PN3Jjg5LN28oLFnFM5oHps0Ql2+PutmcIzr1wW2lVngEa5/alO/XZWN1rguP5QFvCqTq
	 GIFeUUzUWgfmP3hZLiLAGpcChNE47cJhq/DRymMX5Dvx24eMJisrBKdQ867cwMz4ZGLlF
	 An/6K9N8SQBNZJbqaGavy2L6AyB5CBgqogPxIak1MiyRfKisdvKXk931BmCo1SrJ86Kp5
	 QIKNWIlysnyNcZDIRNEAgjQrancr9dhLwpKoqzV2ithW4FgjoQ/tP3jjGLSeFHY/KimPe
	 Eu6HsCcTE8IZ4QCJYRv6TOIDLdej2AuliYT4QPS7NmSOQkIFuu3h50jGzF0ROW9MoZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MJfrKXQc;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7B3606A32E
	for <kvmarm@lists.linux.dev>; Sat, 24 Oct 2026 02:24:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E7B3606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MJfrKXQc
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso14925915e9.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 19:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792808697; x=1793413497; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MwaAPfyutmKmJPECsVQASiFKd+n4QdGa9vMFjSb1Ixo=;
        b=MJfrKXQc1HcF/suEifZwCRLp5UVe9uOx1bp9fGkL9FUDDlZaxfJfbaiz5YMeo6LGVv
         VEiwNyJNBQ5skQ/Oz/nOyt/4A9lhkoRuBntGprn4bHbBLH4H2EwX4+PObUob/faeCgJ4
         PtpEAtYaBItYG97CJxPV/zzNRN2050BL4PczOTjS9mh6Gs62WnpqF7tUb6Cwajxw4iDA
         PCRwDcKjqlgNXbLRtF9r4Zlc+MCQi7HhG2VVZu5gu3NS3sQMxkvqMIqfrpYUN57NVXH5
         FoqibgL6/kH9i+pFApzHlR94pk1UDW9fgJNVdgrFcaxWyBMNsOPuoK43ii7QwiJoNqQU
         9eFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792808697; x=1793413497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MwaAPfyutmKmJPECsVQASiFKd+n4QdGa9vMFjSb1Ixo=;
        b=ijjFYY893tG6GJZKuaqY3iJQY9eXfVNpa9C1tqJRbzsduVxj72dG8ycKf7Xy8h2JhV
         RN0Ug+/2HpKJAgC9Rgd1RgFWyeh/9a+rhlNjEKmuuSaTnSGCKFfH6JuqvBMBMeA4XJdx
         TDHdB3cPfQBS+c46Kv0Tj2vlP9uYWD5jKI68g7JVoJbDMdvM7XEOtDnZvTBReve1NEq+
         rtGtbH6tmmeSAkqMkDPb1zDk6E2vOaid5uwXaLwneqCOS+1WoCDc5b7RJwty25i1X6f1
         v38bi/ymWy3g0XOSVJLL2Rz1b6J87AgzvUJuLJTsdKkeCiiwJ4fW0dHL/8LoC9wU7Q4A
         Lk6g==
X-Forwarded-Encrypted: i=1; AKwUvBwtINWv9woKuzXXiMZ7jvKKjSNAmrJChQT9+QH6VuFH028HfSAQLoPVZlsn/6o4FM5UqOxH79Y=@lists.linux.dev
X-Gm-Message-State: AFq9FYI4uFnCxmELdTPY3yCDeYJWYvxTUMsb0Io5c5jiM9Se2HNqynQs
	zAFqrdZmD2DvJJw1Uh+nkIKmmczxG0r9Nmqk19ru10zoRRyCzCy8uy9l
X-Gm-Gg: AYBFou2Ml0X3YDg0JsJ358zg9jpoiMUecJFImchpeRlqH8lqYujn0vPFhZw++T+qI00
	Vk7ViSsv58ccptlN9b94I2QNmqZyl/3ZDJy4xJFkte7DFvn9BLVB40BFi9kFEN+e6fp8SFC8NXa
	900UXEZe2ZCfrzNaWRYqurKbsXnhaNJq5UCn7lcLzBPnvvDay5KwP9kaM5lQ6wqvCzxzXL1pMcQ
	Etjtdnm2R3j2JEiwrxAaLCmubus20OXspFIg8+TkhyrEH1cBqHTVSmvNh00LhZbHA/iRbGyTMh1
	0hKs6FGHbUgrSqejEXJ9XJ86TGVVPIT8oZlpenCcIUlYbKgQu5hZPMS7uyUkfkt5KUpOsvbh2CM
	JX/gmGRnbqEg/FBTkFSzHyBZT5PBWQYU001esWpXXj2OiXbefJht94M0umQcLLDn54atwK3VCIR
	TAit07MNep4BVX8xi7FjIf3pTajxowoApVcnIIb0nuUDhdcd+4H4UnzfWQYbt7So+sUdHvv2gNs
	MKoqH8Dck0sQTCoNffJ0jGwqUp5lBMezRHoGcC/m0t4QxQnaM/w4VhRkPTz2xWsarcHSjE1aw0y
	JdTR
X-Received: by 2002:a05:600c:4ece:b0:4a1:6c0c:ab93 with SMTP id 5b1f17b1804b1-4a35acb5854mr8241675e9.28.1792808697511;
        Fri, 23 Oct 2026 19:24:57 -0700 (PDT)
Received: from ASHA ([2001:630:3c1:164:1a66:daff:fe85:4026])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a5698f1sm21088415e9.8.2026.10.23.19.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 19:24:57 -0700 (PDT)
From: Amir Noohi <amirmnoohi@gmail.com>
To: Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Radu Rendec <radu@rendec.net>,
	Igor Velkov <iav@iav.lv>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Christoffer Dall <cdall@linaro.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Amir Noohi <amirmnoohi@gmail.com>
Subject: [PATCH 2/2] KVM: arm64: timer: Avoid the irq descriptor lock on vCPU load
Date: Sat, 24 Oct 2026 02:24:50 +0000
Message-ID: <20261024022450.629980-3-amirmnoohi@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261024022450.629980-1-amirmnoohi@gmail.com>
References: <20261024022450.629980-1-amirmnoohi@gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the host interrupt controller has an active state, every vCPU load
sets the active state of the host timer interrupts with
irq_set_irqchip_state(): once for the virtual timer and, on VHE, once
more for the physical timer. On GICv5 hosts the state is also cleared on
every vCPU put, and with a userspace irqchip it is also cleared after a
guest exit when the virtual timer is not pending.

The timer interrupts are per CPU interrupts, so all CPUs share a single
interrupt descriptor and irq_set_irqchip_state() acquires its lock. CPUs
which load vCPUs concurrently therefore serialize on that lock, although
each of them only writes its own redistributor (and, when setting the
active state on GICv3, reads it back while holding the lock) or, on
GICv5, a system register.

This does not require over-subscription. On a 32 CPU Ampere Altra
(Neoverse-N1, GICv3, VHE) with an in-kernel GICv3, a test which makes N
vCPUs exit to userspace in a loop, each vCPU thread pinned to its own
otherwise idle CPU and running from its own guest page, gets 319694
exits/s from a single vCPU, but only 119943 per vCPU with 16 vCPUs and
58722 with 31. The aggregate rate stops growing at 8 vCPUs. At 8 vCPUs,
122800 of the 122847 lock contention events within 5 seconds had
__irq_get_desc_lock() or irq_set_irqchip_state() on the stack.

Use irq_set_percpu_irqchip_state(), which does not acquire the
descriptor lock. All callers of set_timer_irq_phys_active() run with
preemption disabled, and the timer interrupts are requested in
kvm_timer_hyp_init() and never freed afterwards. On hosts where KVM
stacks its own interrupt chip on top of the timer interrupts, its
irq_set_irqchip_state() callback masks or unmasks the parent interrupt
on the calling CPU, which is equally CPU local.

Same test and kernel configuration, exits/s per vCPU, mean of three 5
second runs:

                in-kernel GICv3           userspace irqchip
  vCPUs       before      after          before      after
      1       319694     324584          319670     345088
      8       278579     328736          112423     343984
     16       119943     328887           56120     282905
     31        58722     326056           28114     250586

With an in-kernel GICv3 the per vCPU rate no longer depends on the
number of vCPUs, and at 8 vCPUs no lock contention events have either
function on the stack.

Fixes: b103cc3f10c0 ("KVM: arm/arm64: Avoid timer save/restore in vcpu entry/exit")
Signed-off-by: Amir Noohi <amirmnoohi@gmail.com>
---
 arch/arm64/kvm/arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6ac3321f4c57..a9103625dea3 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -679,7 +679,7 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 static inline void set_timer_irq_phys_active(struct arch_timer_context *ctx, bool active)
 {
 	int r;
-	r = irq_set_irqchip_state(ctx->host_timer_irq, IRQCHIP_STATE_ACTIVE, active);
+	r = irq_set_percpu_irqchip_state(ctx->host_timer_irq, IRQCHIP_STATE_ACTIVE, active);
 	WARN_ON(r);
 }
 
-- 
2.53.0

