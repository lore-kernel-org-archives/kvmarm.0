Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2628C86347
	for <kvmarm@lists.linux.dev>; Thu, 28 Aug 2025 00:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756339328; cv=none; b=GzuPJGfW5DtiGH2a5MdW43x4YQ7Z4wiH6XkAw+IRVF7YrWlvCEwUZ4Ynzf+909HB+68aHDagaLbTz9bwRSi6DQbwdBO8h1qsGSQjp482fEi3IDwH8xieMowq0+Z67tJrP9/Jp0gqxBOORdUAemjoGVihZgieSaW/3NH4sgWZprw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756339328; c=relaxed/simple;
	bh=8tZ83PeYs29SmFwlLYawA90+tGBTxdUNJGqvgVUYI08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iUgfICh/IXyMZutQsVhAnenm+aqYjxz0CX3rNsnaYA42x7vHjAOcq4GM5meTnyTtP/Nf5YbdhqKY8VOVPx0/1Lj0RUP09lP5CADBYQPdv9sqqgoKisDedFQYy3ygXyW2rb5OJBG0aqksObfoqYzyg0e0Dy1gx5N8XpVM2Zta74E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OKGKmb6j; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OKGKmb6j"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-327b00af618so64550a91.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Aug 2025 17:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756339325; x=1756944125; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hDymskQNp6wG2uiiMHxVPzsL1nAJPxy4zRxFOrP95kA=;
        b=OKGKmb6j/uRRVV0zKqtoMMRqLaMcg4SgZHeMh8Rig4FYCK3NINg3VvrzFv9W35W8zU
         TQZeN1B1FtUVhKgS1UybuBVXChCfESKcC9NMUbpmDWMJnPMEgAcelFsp45r8QHbZXr0P
         L9nxTmO2Tb36C8W1QR4cuMA1UEK9VKVHCZFh9aTNrSKYvgGZOLoowugsLvU6t3biOLxg
         qxUlWLdS1pnOPq/39muD1J/yGSR4H9uuoAfMtYhNZsAn4pSKFctjvv4fIdikoO/XcLls
         o6iLqZWJMgdchz0ZyJszpd7GAOSrg7ny9XyUC4lfQmbIhoRPc8OcKPJvUc0J9SceFlN/
         nEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756339325; x=1756944125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hDymskQNp6wG2uiiMHxVPzsL1nAJPxy4zRxFOrP95kA=;
        b=v5PnWHtI7eYk95K1yzV5ioy06qs0+73sT9xiqHaD5ZPGIGcTeGoMNLn7o2Je6lvYqt
         Xby/dWPknpFvCLAI4AAmFhS49Yz1HcgJXJlPCHdsXvQ5rPELXXuAZdnrNI8OFj2YR52Q
         oTHSvxlhubIfqMTRY9zDWRm0eiWGkVoeT7hRYxcQ4o+yomlNouj5/Pj0K8ZA/PHijyv0
         4luN96g4gcyowJKK7MDkOCNGl8dAZunr2CLjPF3euLFYjnzhgdUp3l4bcNpp8ftmD1SB
         FYy84WYbV7sbrG76QeFWvF0DPBymJlTVt2gIPdJkgAClHOPmmTx3FjzfNaf4e1hHockL
         V8Fw==
X-Forwarded-Encrypted: i=1; AJvYcCXEkWOJ9YzmSnWO1+MaZ3mzFImd6za2eUmGWs2amedaQYlnVX20YUJLOqj52IJKhpsCsGqtXRE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy09Det+KWUQF8t+2N7hjJ8HtIYD4rQQOz5H+aQnFTD6J3uxDMT
	m0+NlSSULGaccvwHP7vqcFuouG8kQCX2YYXmmDHHWqNF/kDFeytLsKDbyCTeg7XASfWn4yeHceB
	/a8c8Ow==
X-Google-Smtp-Source: AGHT+IEpldWCysonYjdHETjodWyZtDlIBYcwDxX/6JZFBAIAnGNdK+zSnqMrfXxPLk2m5pFyKQhTG4/yaKw=
X-Received: from pjj15.prod.google.com ([2002:a17:90b:554f:b0:325:833b:6f27])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55c4:b0:327:aaeb:e814
 with SMTP id 98e67ed59e1d1-327aaebf1b1mr940666a91.23.1756339325323; Wed, 27
 Aug 2025 17:02:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Aug 2025 17:01:51 -0700
In-Reply-To: <20250828000156.23389-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250828000156.23389-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250828000156.23389-3-seanjc@google.com>
Subject: [PATCH v2 2/7] Drivers: hv: Disentangle VTL return cancellation from SIGPENDING
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

Check for return to a lower VTL being cancelled separately from handling
pending TIF-based work, as there is no need to immediately process pending
work; the kernel will immediately exit to userspace (ignoring preemption)
and handle the pending work at that time.

Disentangling cancellation from the TIF-based work will allow switching to
common virtualization APIs for detecting and processing pending work.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 drivers/hv/mshv_vtl_main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
index 12f5e77b7095..aa09a76f0eff 100644
--- a/drivers/hv/mshv_vtl_main.c
+++ b/drivers/hv/mshv_vtl_main.c
@@ -731,19 +731,21 @@ static int mshv_vtl_ioctl_return_to_lower_vtl(void)
 						_TIF_NOTIFY_RESUME | _TIF_NOTIFY_SIGNAL |
 						_TIF_NEED_RESCHED_LAZY;
 		unsigned long ti_work;
-		u32 cancel;
 		unsigned long irq_flags;
 		struct hv_vp_assist_page *hvp;
 		int ret;
 
 		local_irq_save(irq_flags);
+		if (READ_ONCE(mshv_vtl_this_run()->cancel)) {
+			local_irq_restore(irq_flags);
+			preempt_enable();
+			return -EINTR;
+		}
+
 		ti_work = READ_ONCE(current_thread_info()->flags);
-		cancel = READ_ONCE(mshv_vtl_this_run()->cancel);
-		if (unlikely((ti_work & VTL0_WORK) || cancel)) {
+		if (unlikely(ti_work & VTL0_WORK)) {
 			local_irq_restore(irq_flags);
 			preempt_enable();
-			if (cancel)
-				ti_work |= _TIF_SIGPENDING;
 			ret = mshv_do_pre_guest_mode_work(ti_work);
 			if (ret)
 				return ret;
-- 
2.51.0.268.g9569e192d0-goog

