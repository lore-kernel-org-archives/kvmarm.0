Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD6E1CA81
	for <kvmarm@lists.linux.dev>; Thu, 28 Aug 2025 00:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756339325; cv=none; b=pJHmzqcb5UqOfRAE48OqvunlNRk292LsrQXfQzPF6jZrJTbO34HwYWOo+Op9vkjOpJxvZLb6hZKXPOYjgotWkRf55OwaCcxb2anl7K8KGa1YfGXizp5ddJ6j1r9FNOSKC9xLm8cjwnakBeG5xZTHlSSXDItLRYXpTZVlnn/b0Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756339325; c=relaxed/simple;
	bh=yezIQljWRff+Ph2Kkfldm8tP8XBUOynmTR8J0FoBino=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qeo8rCmWZJrNbiSxbJtrGawtjH7g1WQf65EXSiXBp4875RlsI+bbVDrPDMoOzR46rtLuHKBgJdZX24FuQj4Xu7/OKEotLqKbPHcgLstUIgEqStlKiQJPz6xWqpyoTy/UpwdwvGEBw21K7mNnEEWZTGru9PciDQku/sw1CsHKAaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AX9OpaFi; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AX9OpaFi"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-771e2f5b5dcso522132b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 17:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756339324; x=1756944124; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kCYLCx+qR2vxxpcmuDTRXW8z6xS3j6g2rCWoMpSsv0A=;
        b=AX9OpaFiQA5dPOAepdiqHO1hiY8gzdBDsDyZJaCQWOFKqj3SPEzxxKDVVlg3pDawVB
         T0PNIbzPoht70Ta7i0JmaWv55l1Pc9YbJnNjDQdFeOABjY/JJFtvo03oPYRLuAhhcYk9
         3n6Q16SQq2MMI0J1tQFt259g1O8qtL6Yw54Nr4+O0dJXaB6sH5FccWGzPv9Skyom9qoU
         Df0IwC6180zp7C/S382RDQI2xrHD1NqhZoTZ0kUbPsV65ZxNXGIY4GU30p3o+3yobr/d
         RJlIBEfjDdmxXqKYRtB4zdd4ydpyUrEBTVJQQ/roVE4bPXaVu2ZrYvODMcY0TF9fKwkI
         b7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756339324; x=1756944124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kCYLCx+qR2vxxpcmuDTRXW8z6xS3j6g2rCWoMpSsv0A=;
        b=j9KEIpTV+xWlXatBbZy8I/Z3n8JmnUgad+Xv9jr9XS9IOm4tP6/7EJ2+2uV/JaaPw/
         2zauIUVB/uQW9T9QPBgOlVZ2irgHZh/Qnvn8Nb+QkUwRlxX/kCDUh0TzKljpu72qrntp
         EkDPmng6t8vzyVMXkVh5wF1uNveM4D0ybmJcNF9oOD56oT1hhYEzZMaaIdNP7TqoEwBR
         ZuTGHtEgHcwhCHiuzR3jf+kYOfgHYkBq6M/bzbrR3ykv4UP6dgit8um6cvIQLC7KKhgz
         AmnMhUzwBGfhfF6P5s/osGYFd6OV7TguUQ6JbIPfHy9NBzvGL2UJTDSch6Du+Twzs7I0
         QI9A==
X-Forwarded-Encrypted: i=1; AJvYcCUcPsDK6oCocnP6bZQmr2qM6NdvuDTPyNKbjc5JUrykRFLs54xO0At8MWO5lX+3lPItZvOXLVk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZC886dpnKnF8yd2vRxBwW2cA4w/albMEgNUW3jhGbY9hhm9aF
	PgKRSdj74KwMCnGMZ7FBtCW/UGn6m4+J7+tYRUrOf5pgUntKUA7kN8bb6eP9qgOY5zsg/UU6hz/
	wMoHrlg==
X-Google-Smtp-Source: AGHT+IHDUlpPfgfETOO31fD//wXWMymV5Mnw/Y+lifpogBKPY1IBHbcv76HZ+xFt3eQXYgFR8TyJX2ZK1/M=
X-Received: from pfgs8.prod.google.com ([2002:a05:6a00:1788:b0:771:f315:17c4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a85:b0:76b:d8f7:d30b
 with SMTP id d2e1a72fcca58-7702f9f4896mr22345026b3a.10.1756339323354; Wed, 27
 Aug 2025 17:02:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Aug 2025 17:01:50 -0700
In-Reply-To: <20250828000156.23389-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250828000156.23389-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250828000156.23389-2-seanjc@google.com>
Subject: [PATCH v2 1/7] Drivers: hv: Handle NEED_RESCHED_LAZY before
 transferring to guest
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org, 
	Nuno Das Neves <nunodasneves@linux.microsoft.com>, Mukesh R <mrathor@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Check for NEED_RESCHED_LAZY, not just NEED_RESCHED, prior to transferring
control to a guest.  Failure to check for lazy resched can unnecessarily
delay rescheduling until the next tick when using a lazy preemption model.

Note, ideally both the checking and processing of TIF bits would be handled
in common code, to avoid having to keep three separate paths synchronized,
but defer such cleanups to the future to keep the fix as standalone as
possible.

Cc: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Cc: Mukesh R <mrathor@linux.microsoft.com>
Fixes: 621191d709b1 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Fixes: 64503b4f4468 ("Drivers: hv: Introduce mshv_vtl driver")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/hv/mshv_common.c    | 2 +-
 drivers/hv/mshv_root_main.c | 3 ++-
 drivers/hv/mshv_vtl_main.c  | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/mshv_common.c b/drivers/hv/mshv_common.c
index 6f227a8a5af7..eb3df3e296bb 100644
--- a/drivers/hv/mshv_common.c
+++ b/drivers/hv/mshv_common.c
@@ -151,7 +151,7 @@ int mshv_do_pre_guest_mode_work(ulong th_flags)
 	if (th_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		return -EINTR;
 
-	if (th_flags & _TIF_NEED_RESCHED)
+	if (th_flags & (_TIF_NEED_RESCHED | _TIF_NEED_RESCHED_LAZY))
 		schedule();
 
 	if (th_flags & _TIF_NOTIFY_RESUME)
diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index 932932cb91ea..0d849f09160a 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -484,7 +484,8 @@ mshv_vp_wait_for_hv_kick(struct mshv_vp *vp)
 static int mshv_pre_guest_mode_work(struct mshv_vp *vp)
 {
 	const ulong work_flags = _TIF_NOTIFY_SIGNAL | _TIF_SIGPENDING |
-				 _TIF_NEED_RESCHED  | _TIF_NOTIFY_RESUME;
+				 _TIF_NEED_RESCHED  | _TIF_NEED_RESCHED_LAZY |
+				 _TIF_NOTIFY_RESUME;
 	ulong th_flags;
 
 	th_flags = read_thread_flags();
diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
index dc6594ae03ad..12f5e77b7095 100644
--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -728,7 +728,8 @@ static int mshv_vtl_ioctl_return_to_lower_vtl(void)
 	preempt_disable();
 	for (;;) {
 		const unsigned long VTL0_WORK = _TIF_SIGPENDING | _TIF_NEED_RESCHED |
-						_TIF_NOTIFY_RESUME | _TIF_NOTIFY_SIGNAL;
+						_TIF_NOTIFY_RESUME | _TIF_NOTIFY_SIGNAL |
+						_TIF_NEED_RESCHED_LAZY;
 		unsigned long ti_work;
 		u32 cancel;
 		unsigned long irq_flags;
-- 
2.51.0.268.g9569e192d0-goog

