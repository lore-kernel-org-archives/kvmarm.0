Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604C8254B1F
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 11:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742384347; cv=none; b=lT+fKazRZXHtaVw/ATDD30dsshHVWvqzB4Mv9Q2e5zZT5A0S8m7isGFYCFzdXrr20YWgG68kKy0e9UWabU2hU+ikLWZOlrJhG3yiKmo74K/sGXvSzIlWY99GCfWDOhcdDo2If76y57Wnlo4lz3KoRj9mZtbIHhOv028pYzXJfhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742384347; c=relaxed/simple;
	bh=/ViqIW2rQ9pRcpWe1ja+iMw9gioppsGYG5b7wTCDJeo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=jLljZ2AQLQt3Z8qa7ogpXDEsatKAdi+bdF4VqrBTIwNXmgtyn76Aa4vCtjrYS7CUSwHPLcxE4+AdndWOJQKAQX6a0MKA86lv8IqlZsVwjnwYYouiBnp2LQgtuP+7nGz/uGQHQBkX68ld5wNPDqSGziHU7mVdepMdE5bIssnHHjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=VgnPfZnN; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="VgnPfZnN"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-223a7065ff8so42205535ad.0
        for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 04:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742384344; x=1742989144; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oc66l7/d0Jjz8FMmOmNrv+ltKHYwWToN6Hiwa3da7k0=;
        b=VgnPfZnNg5SbrwQgpEkOUVidKSKQD5VIWEP6Dhvno7MSN6GqeSMrz3/iojtM07NyWO
         xiQgXFIox60ObXxXMGz58NfOay83ropcfFHTFMSJ3w8QIColMV7ZzY19Rff5yxJR3pIK
         M2gEja1WrynOpl2CBUog/Ma5uKoMma3Rnnn8Yr3fIT1LlLGDtVK93h326QJ1LbGIpoiN
         PgR8z1IItOkFVGpOzPGOI9mVUsDH04orR621/sSv2r6jwE6nTVm9RHQ/xc29eyIGmBn1
         HJ4vV+K3H2rb59q0++j/jLAZCUajmALvtbe2pQzboXD/pu1tcdpUcCqbZ0igKq3XD5eY
         8M+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742384344; x=1742989144;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oc66l7/d0Jjz8FMmOmNrv+ltKHYwWToN6Hiwa3da7k0=;
        b=QkRp9p9VKlxpBAXgkwofbn+j0cnIiY7eLuLupv1MvOELiU0wn/5NN8IB6YpPQ8ZY+e
         BWtyoviS1s+3tXTHUUtnykYMAMDYTdc6MGpJhjBeIrbCTTzgUrhtCrLZIyuXuufq6tLS
         SNB1592VtZCXATk/d6m/TYu6YeRZ0cCgJZxG6L436pBuY5JjhCW9fE8Vh1ZfGhrESa5L
         BkrAYS4OWmdN2q3b4JNPuDDSmqkyVMVcrILdfE3ZdKKUoVjQbnKndSyu0vWVtGMcBv68
         ZVF4Anuc9RnhdutQMCZAfCjhNSCONQWZO7l+lqA/amqsBg9MduVSuT9gbL1bCLcXQsf1
         8Slg==
X-Forwarded-Encrypted: i=1; AJvYcCXJDHt1FEdKMGAU6U7GdD9NUn2jFSrk8ppwYSUbidmL5E5BDCGK+iWwSry5VSfqUKQlbJyB37I=@lists.linux.dev
X-Gm-Message-State: AOJu0YxnURx8wSOSpPu35mTii5kEU5TOYuxgz+7q7mrkgurcLAZtaWPQ
	jjd4WRN4HDcOLZSxisfxOD8IixVNnH5p9gr4mCgOesoIYOUwz62trp9+Q6u9YkQ=
X-Gm-Gg: ASbGncu+yvUIanFAnBHPYKRjX3NrHHNHYytITeA4TX2X+51wwykdf+okpucBFzeU7qh
	LdyrSjJ91exVm42TwsmJLvH+HfwOhVoAuYyv/RBmOtw/LBU680WpRd0ftTflpUwnFnFojGkuZf6
	hgT+cczVehsZuEZSmzKoUYIjWqiMddtsDND3vixOFtjwx6jiQaAfHbpDeMCOoDAgAq+YhcvqEoD
	B0mh/NnrY/l/5RKp/8VuJ0KHkXKVNp+1p/SC+yg1jPScQx9fai/mNCAVkszHKkJBsx4Ev2EnQhY
	u341cDPR0U0zag3aR2CN5XvKTGFAJxlLYuY5nqdHIuCxjkWm
X-Google-Smtp-Source: AGHT+IGSv0AJ8KwpE6fQl4DpNJB/7VkQwjj59TCcKQRqKU8wam5+t3NXf5mYBQBcpLosGuAKvIYqVA==
X-Received: by 2002:a17:903:1790:b0:224:283f:a9ef with SMTP id d9443c01a7336-2264981d654mr33063775ad.6.1742384344597;
        Wed, 19 Mar 2025 04:39:04 -0700 (PDT)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c6bd5ce5sm111657845ad.252.2025.03.19.04.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 04:39:04 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 19 Mar 2025 20:38:55 +0900
Subject: [PATCH 1/2] KVM: arm64: Trace values with kvm_sys_access
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250319-trace-v1-1-0fff03204efa@daynix.com>
References: <20250319-trace-v1-0-0fff03204efa@daynix.com>
In-Reply-To: <20250319-trace-v1-0-0fff03204efa@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

Tracing values written to or read from system registers.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/sys_regs.c          | 24 ++++++++++++++----------
 arch/arm64/kvm/trace_handle_exit.h |  6 ++++--
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 14f66c7a4545..362e2758d101 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3994,23 +3994,27 @@ static void perform_access(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *params,
 			   const struct sys_reg_desc *r)
 {
-	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
+	bool skip;
 
 	/* Check for regs disabled by runtime config */
 	if (sysreg_hidden(vcpu, r)) {
 		kvm_inject_undefined(vcpu);
-		return;
+		skip = false;
+	} else {
+		/*
+		 * Not having an accessor means that we have configured a trap
+		 * that we don't know how to handle. This certainly qualifies
+		 * as a gross bug that should be fixed right away.
+		 */
+		BUG_ON(!r->access);
+
+		/* Skip instruction if instructed so */
+		skip = r->access(vcpu, params, r);
 	}
 
-	/*
-	 * Not having an accessor means that we have configured a trap
-	 * that we don't know how to handle. This certainly qualifies
-	 * as a gross bug that should be fixed right away.
-	 */
-	BUG_ON(!r->access);
+	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
 
-	/* Skip instruction if instructed so */
-	if (likely(r->access(vcpu, params, r)))
+	if (likely(skip))
 		kvm_incr_pc(vcpu);
 }
 
diff --git a/arch/arm64/kvm/trace_handle_exit.h b/arch/arm64/kvm/trace_handle_exit.h
index f85415db7713..b0308d95304d 100644
--- a/arch/arm64/kvm/trace_handle_exit.h
+++ b/arch/arm64/kvm/trace_handle_exit.h
@@ -88,6 +88,7 @@ TRACE_EVENT(kvm_sys_access,
 
 	TP_STRUCT__entry(
 		__field(unsigned long,			vcpu_pc)
+		__field(u64,				regval)
 		__field(bool,				is_write)
 		__field(const char *,			name)
 		__field(u8,				Op0)
@@ -99,6 +100,7 @@ TRACE_EVENT(kvm_sys_access,
 
 	TP_fast_assign(
 		__entry->vcpu_pc = vcpu_pc;
+		__entry->regval = params->regval;
 		__entry->is_write = params->is_write;
 		__entry->name = reg->name;
 		__entry->Op0 = reg->Op0;
@@ -109,10 +111,10 @@ TRACE_EVENT(kvm_sys_access,
 		__entry->Op2 = reg->Op2;
 	),
 
-	TP_printk("PC: %lx %s (%d,%d,%d,%d,%d) %s",
+	TP_printk("PC: %lx %s (%d,%d,%d,%d,%d) %llx %s",
 		  __entry->vcpu_pc, __entry->name ?: "UNKN",
 		  __entry->Op0, __entry->Op1, __entry->CRn,
-		  __entry->CRm, __entry->Op2,
+		  __entry->CRm, __entry->Op2, __entry->regval,
 		  __entry->is_write ? "write" : "read")
 );
 

-- 
2.48.1

