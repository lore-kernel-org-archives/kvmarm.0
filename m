Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48105732B
	for <kvmarm@lists.linux.dev>; Mon,  1 Apr 2024 23:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712014202; cv=none; b=oTFzNVStCkRHc0XXK5aziUI9gxByu6VIZ1a9CiyY5RaLNkST0mSo4HqUuKYvI/60h9M+OfOGUsH03VpDDa9lX65l9cgKH4BT+ngfGQ7skmBG5iNsA6ZC9Wyhlw8Vdw7UeMlxrs0ZsRotepPRGwV8UQ6XIftq9rQYSWC/+2C3yVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712014202; c=relaxed/simple;
	bh=6SjX+fdRUwbegUJJFXD27Uh0qk0JttGkcP5G/eXp4z4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RoWAX3pv9NZHBjDD6eQjk87P5D3Y0ayt8eU6YJsf68+d1b7SLEUW79TxLzfdrAq1DQzMA6zt6rNh6IizdUSdcsStlRTCAUny2pZeSjTj/LAlsSmgdvCBddVZ/xMFN1bUhAwMCpbBXk6EfwJF+IIIqjPi7N8ZspQQ3trozEYDRJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EZXFOAXm; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EZXFOAXm"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dd8e82dd47eso6071455276.2
        for <kvmarm@lists.linux.dev>; Mon, 01 Apr 2024 16:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712014200; x=1712619000; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nylYGqt19cj6oDr0RFoeiQ+kw/0yLdSX5tVYYbKq8QU=;
        b=EZXFOAXmm90fiA0v+WQgMfI5h3AA3JGBmjY6npnuOlxcSwFu6hBPSVza4NH9wi39fQ
         ybCFbbeI02PyIOTIEtFoX5Xta4S8bKNyPtCx0gnetGRustcxo/Gq1lpjJwoifSa8GsDo
         yyCJ5N7U6lgAtJEZf4yFduqUFyyR0Q2dCXeIwL7v6wLyzPzyCJWCGWvOyHF6ZX3nAp19
         /6S8f73RN2a8NrLcXMIY+Dmxza72P3/nCzMr2K12YmV0SBT9p6vqOEEBPxU2pZPNP0aJ
         SZJgVZO1gELnHsvk4HgiMl0O7U8d+ZmuJPTa1vJQ+pc2ajSYAYIdgAuNaYeE6QEqEw13
         PbvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712014200; x=1712619000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nylYGqt19cj6oDr0RFoeiQ+kw/0yLdSX5tVYYbKq8QU=;
        b=Vdx6JLL1MDJCkSEFtN6ir/SSzNfST7r1+dcPSPL7DBGjmc18IyVNj8rbv9plJyqwqx
         878r4AuEZMH0BUnSpPmDc0d0/OWt1EV2ikNLssVwF80WK+AuqUMLxHLAa7Jsy/23LPdi
         GlhvzyC4wNFV6pFFiMig6HxqW7Yf7Famz5/7zX0Y3EtY+FS8R/1wNt4HMOSwh/7zD/kV
         JZBPcag2bu96K0gUUE7OOKbk/0mEa6zcv6JHOm0GLdPsD7aWhrjfYj5TnUel+jEJxA1S
         34QI+/JcyvvMkkLjvB41n2+bF6ONrOqG0tNbFhH6tcwkg1KG6mnMfl7Xp/5AorubDhP+
         /ZIA==
X-Forwarded-Encrypted: i=1; AJvYcCVdcofL0Me6KK1hCewsb550rd881o5Wq74TytxsPL09mCDnDBlb+CW4rBAtlSyMhfq8CHHhtny9WlsViAQFH39UyMtmm1RZ
X-Gm-Message-State: AOJu0YyXQSJFkP3Js7PcsdclRfBRxfjQrDE/h0OsVoSShijXNpeokwcd
	MLXhWrZtblI6vVXhfgLmN24iuzXE81mrc7mKlZ4IFl77KaPkXcWS4pMXiiOfNQLddc9LGaX91aV
	kqSww3IzXOgvvGyfJMg==
X-Google-Smtp-Source: AGHT+IH11gFjd5KLSe+p+dgHN5WTYlvUkDoQzbaal5VNFeM0iKdCiBmTQIhFAj+2vV8eggKrfvh7CUqHaFUquRNc
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2182:b0:dcd:2f3e:4d18 with
 SMTP id dl2-20020a056902218200b00dcd2f3e4d18mr765892ybb.12.1712014199648;
 Mon, 01 Apr 2024 16:29:59 -0700 (PDT)
Date: Mon,  1 Apr 2024 23:29:43 +0000
In-Reply-To: <20240401232946.1837665-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240401232946.1837665-1-jthoughton@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240401232946.1837665-5-jthoughton@google.com>
Subject: [PATCH v3 4/7] KVM: x86: Move tdp_mmu_enabled and shadow_accessed_mask
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Jonathan Corbet <corbet@lwn.net>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Gavin Shan <gshan@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Rientjes <rientjes@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Yu Zhao <yuzhao@google.com>

tdp_mmu_enabled and shadow_accessed_mask are needed to implement
kvm_arch_prepare_bitmap_age().

Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/include/asm/kvm_host.h | 6 ++++++
 arch/x86/kvm/mmu.h              | 6 ------
 arch/x86/kvm/mmu/spte.h         | 1 -
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 16e07a2eee19..3b58e2306621 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1847,6 +1847,7 @@ struct kvm_arch_async_pf {
 
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
+extern u64 __read_mostly shadow_accessed_mask;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;
@@ -1952,6 +1953,11 @@ void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
 			     bool mask);
 
 extern bool tdp_enabled;
+#ifdef CONFIG_X86_64
+extern bool tdp_mmu_enabled;
+#else
+#define tdp_mmu_enabled false
+#endif
 
 u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 60f21bb4c27b..8ae279035900 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -270,12 +270,6 @@ static inline bool kvm_shadow_root_allocated(struct kvm *kvm)
 	return smp_load_acquire(&kvm->arch.shadow_root_allocated);
 }
 
-#ifdef CONFIG_X86_64
-extern bool tdp_mmu_enabled;
-#else
-#define tdp_mmu_enabled false
-#endif
-
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index a129951c9a88..f791fe045c7d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -154,7 +154,6 @@ extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
 extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
-extern u64 __read_mostly shadow_accessed_mask;
 extern u64 __read_mostly shadow_dirty_mask;
 extern u64 __read_mostly shadow_mmio_value;
 extern u64 __read_mostly shadow_mmio_mask;
-- 
2.44.0.478.gd926399ef9-goog

