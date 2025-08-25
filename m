Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3CC1DE8BB
	for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 20:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756152389; cv=none; b=Tl6zMQfjOz3XTCnXE7YKoZPrWkpf3ufAnnpegickgRK+RYn1L3WhMQwUUBTegxg+hbX7mjroiYikvWim6ElSV/V8FO6iAMsY2RHXjmMwQspRLUl6gKbiCdrSc4O/y8Jm8KoZp5yc4Plb7n6pPLPqskGcz2r8fjH9ZFhecBS2VE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756152389; c=relaxed/simple;
	bh=aOaAMFU0lRUzQeN1F6iLwL6S3YUHwj3pFv409qQl9yQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CkIs+7ssMhQXf1DtQfO6Yy73WVkHvgByqxnQFIm6qRQqx9JntmNv4iDNqBtFT1zRcvYBHYVbUSu/JMAFsCxfhtjCkPaeMrXvjlMoh3MCzPlVHe5eEdzesizrRqTpKMmCV9+1aABbP4mFhXPsQt3CGp7yzH7sODEm96nfbtRdlbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fT5M0QtR; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fT5M0QtR"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-246eb38205fso12278165ad.0
        for <kvmarm@lists.linux.dev>; Mon, 25 Aug 2025 13:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756152387; x=1756757187; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=n6KAJgpe+g35DHpdkouiNXTkH/lGhIRNqTvdrNu3evo=;
        b=fT5M0QtRLa14Oe+4G9X5ouQgV2cUZWBbaNdjl/YVYu4zI9teObyzceH+UBd0Cdp3KP
         LDtRydRDx9dUUkUDN+kIp22pmOuZvi8Z3WUOan6HF8Y2+cx7qqLv357eBpYOoT1PCq9q
         0LEcfIK6SdfD3pSVJCJpI7LBYikK9y7NNo/bkxgD71NCr7dqJI6HhY0QC29zLurgbbM8
         wz5PLykZWnniXBad/A1B5MQxVP0N01ztmF9Pn8cVxcIfXElujLF+XZPEIPe8WFxDwpeY
         1KBPDu90HeGPKt3v13veD85h2jqdn0y9PMZaWrt3WQhoz7/ODvFiBZvEzDjmNR0HwA+s
         yAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756152387; x=1756757187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n6KAJgpe+g35DHpdkouiNXTkH/lGhIRNqTvdrNu3evo=;
        b=p2js6Jgn8Mn//i6iPBfdRglWoPe5vQ6UlcTHR+v0I9Zfc6uiZ8Q1r6YbzoGViYHrfc
         5Is5iWe/F1BsiMhZ4gbJrpNGp8r9NqKLxEKR5ff6vp5UgBOpHo+PeC6Dccov0eBIDVRO
         bgbjH1Is6g0uXeXMFAu1v5GtTbEKwnagAOmc9jNvH73mlxZXRL3Um6TIIh8igpoIktxg
         xoe1h6O5Dia2JU45oh9adsEHyR9SLeQmGjMTZZ1zGhShc8NSjExR0fPKhtBpbCpV7PXr
         QJnPCGDAuXIgFq3pLjwd7P9kdrPGH2jeaRNgpJHHeuQky5qJ9LhsBRIoyG3isKniAA/M
         da8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzwsy5yCXaUf6JcaZhIu5AZdRkixMMUfPcTnFhqUMmzmbVhzMZmWyN6+piUI/PfmWINUaZ9ug=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywd/niN52Q5PvKZjueG5iY937Mzwt4wm4FWbI7F4oli2i/AJ/0h
	O7fIsTAJkowZlbQP2u2PMmS31e+JNvKMf/IK6JfcVVRksQwc9L6oHSHx/U3Z98/w8KsfIaxNbZd
	aSrY9Yw==
X-Google-Smtp-Source: AGHT+IF91dn1j6fIvX+uRWorld3If0wpZl5jf5hDJFPUly2WnQsNSAnJfoCi7L3EWOQImM7m2slTmOJmyMA=
X-Received: from pjbok14.prod.google.com ([2002:a17:90b:1d4e:b0:325:8fba:708c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:fc4b:b0:246:76ed:e25d
 with SMTP id d9443c01a7336-24676edecf2mr117886095ad.50.1756152387296; Mon, 25
 Aug 2025 13:06:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 25 Aug 2025 13:06:18 -0700
In-Reply-To: <20250825200622.3759571-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250825200622.3759571-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250825200622.3759571-2-seanjc@google.com>
Subject: [PATCH 1/5] Drivers: hv: Move TIF pre-guest work handling fully into mshv_common.c
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
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move the root partition's handling of pending thread work fully into
mshv_common.c so that the "work pending" and "do work" code is co-located.
Splitting the flags-to-check logic makes the code unnnecessarily difficult
to maintain, e.g. it would be all too easy to add a check in "do work" but
not in "work pending", and vice versa.

Note, this adds an extra CALL+RET when no work is pending; that will be
remedied in the near feature by switching to common virtualization entry
APIs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/hv/mshv.h           |  2 +-
 drivers/hv/mshv_common.c    | 24 +++++++++++++++++++++++-
 drivers/hv/mshv_root_main.c | 24 +-----------------------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/hv/mshv.h b/drivers/hv/mshv.h
index 0340a67acd0a..db3aa3831c43 100644
--- a/drivers/hv/mshv.h
+++ b/drivers/hv/mshv.h
@@ -25,6 +25,6 @@ int hv_call_set_vp_registers(u32 vp_index, u64 partition_id, u16 count,
 int hv_call_get_partition_property(u64 partition_id, u64 property_code,
 				   u64 *property_value);
 
-int mshv_do_pre_guest_mode_work(ulong th_flags);
+int mshv_do_pre_guest_mode_work(void);
 
 #endif /* _MSHV_H */
diff --git a/drivers/hv/mshv_common.c b/drivers/hv/mshv_common.c
index 6f227a8a5af7..1acc47c4be0d 100644
--- a/drivers/hv/mshv_common.c
+++ b/drivers/hv/mshv_common.c
@@ -146,7 +146,7 @@ EXPORT_SYMBOL_GPL(hv_call_get_partition_property);
  *
  * Returns: 0 on success, -errno on error.
  */
-int mshv_do_pre_guest_mode_work(ulong th_flags)
+static int __mshv_do_pre_guest_mode_work(ulong th_flags)
 {
 	if (th_flags & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 		return -EINTR;
@@ -159,4 +159,26 @@ int mshv_do_pre_guest_mode_work(ulong th_flags)
 
 	return 0;
 }
+
+int mshv_do_pre_guest_mode_work(void)
+{
+	const ulong work_flags = _TIF_NOTIFY_SIGNAL | _TIF_SIGPENDING |
+				 _TIF_NEED_RESCHED  | _TIF_NOTIFY_RESUME;
+	ulong th_flags;
+
+	th_flags = read_thread_flags();
+	while (th_flags & work_flags) {
+		int ret;
+
+		/* nb: following will call schedule */
+		ret = __mshv_do_pre_guest_mode_work(th_flags);
+		if (ret)
+			return ret;
+
+		th_flags = read_thread_flags();
+	}
+
+	return 0;
+
+}
 EXPORT_SYMBOL_GPL(mshv_do_pre_guest_mode_work);
diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index 72df774e410a..6f677fb93af0 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -487,28 +487,6 @@ mshv_vp_wait_for_hv_kick(struct mshv_vp *vp)
 	return 0;
 }
 
-static int mshv_pre_guest_mode_work(struct mshv_vp *vp)
-{
-	const ulong work_flags = _TIF_NOTIFY_SIGNAL | _TIF_SIGPENDING |
-				 _TIF_NEED_RESCHED  | _TIF_NOTIFY_RESUME;
-	ulong th_flags;
-
-	th_flags = read_thread_flags();
-	while (th_flags & work_flags) {
-		int ret;
-
-		/* nb: following will call schedule */
-		ret = mshv_do_pre_guest_mode_work(th_flags);
-
-		if (ret)
-			return ret;
-
-		th_flags = read_thread_flags();
-	}
-
-	return 0;
-}
-
 /* Must be called with interrupts enabled */
 static long mshv_run_vp_with_root_scheduler(struct mshv_vp *vp)
 {
@@ -529,7 +507,7 @@ static long mshv_run_vp_with_root_scheduler(struct mshv_vp *vp)
 		u32 flags = 0;
 		struct hv_output_dispatch_vp output;
 
-		ret = mshv_pre_guest_mode_work(vp);
+		ret = mshv_do_pre_guest_mode_work();
 		if (ret)
 			break;
 
-- 
2.51.0.261.g7ce5a0a67e-goog

