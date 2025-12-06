Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA133081BA
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980330; cv=none; b=j9K89Kk5e8cd3DsfsVFo16opUk8fm2/AQVBGwkT8T4GOe5W61Q0p7NFMEgIcSEI92Sewt5xgQE3z6o/sbiMukYbdt7kq0g0djkr6aA2x3O/BYw6Of3wDP/rjUc3hH9ftnKalf2cc1Eco1bb+zUd4ovo2HvM7UAd48wjfv4TkQ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980330; c=relaxed/simple;
	bh=B/6xHmD7dd8wWjqN/hAhxWOoQSEJgrYoSRISc3YL0mc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qyt/2Vtl0UDEWmzCwrPQKmhe1ARxZNnDQX2Uuc0bZBNPiBH2BA/AX9QsHJKs9gKjOlR7IzM5WJmiWnFfedKZgLh/hKwiDq1NmcuA/POxyaHSXYwjglzu92/NcClg8FZ6aN4EDCmf7FoRon6a1JKB9HrlcZa3RCVWaFXytZ9yMAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GpNvDYmc; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GpNvDYmc"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7ae3e3e0d06so2381197b3a.0
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980328; x=1765585128; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=56r/hH7ijnps8qr4K++rAycxqMKLQxyC6YFw0gfnCKk=;
        b=GpNvDYmcxEc9EjVGqXc1TE7H9JtrscqsczTSP6Nv192zVGg6zjhgrRPE8SNb28taoY
         zN6JJugv/juvK6I2Z1SCLZOboZ7+1XJ7YQgO1qR97VKjpDEhUP8EYSSQDp8ariBy6WX3
         2sNqNOhyKV/3Osh6Cxb2mI9lxkdaNTIDhbnybkAZVv28QnrA3ag40SAnkbQlung1MueC
         Rb/2JtO9V/72jEgZyzcqvXN27Zh39MT4ETqxjIcwW/hlsvLBmLsb74B7fX5gMw7TX9IT
         ClKB+p87qWRi5t3bVVrFDdZR45LDTpAhFOwAjxplyY2+jKecU/t6Fw6DqVw9j7jQj+Ct
         WlQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980328; x=1765585128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=56r/hH7ijnps8qr4K++rAycxqMKLQxyC6YFw0gfnCKk=;
        b=UOExLJTRtdfmXkFqHKs1UPxcOcX4DvQ8jpGlILF1IW2CN//GbpQ+Jovngq3VeMRvOp
         xnkgFev9+p5oG7+z1v1LuCjPB9LjLUhoAGg8eu9WTL8PIndSFWrOXfrolA3B4JtK4J9R
         EmCDdiFpataZaQk3kTZ4LNTNs2GBveotbHNn5giuXxXNkgHjz/pdWEEOwiIxHguTYVDQ
         jXhbE9I4GiaDn2q7HSrimOIZKTKt0uXFHoEDxyUgKWTijREnQF80KmEW7yaN7+oXjMa9
         o27neYMdRtOMQ7x0PW7fuYZP7+4fBzVl9l4jaPQKTsAD7/ju6OBTZGgt99y6tpimwXfH
         RVag==
X-Forwarded-Encrypted: i=1; AJvYcCUucWWGp91qqWtzi6jfysTAwuct+D0KOlSfSHXFE7/9YAXGpjkmYKecZ6DH4Yv5gyj5RMa7Lbc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtqLUtClMwUs1v5yfiJSgX5BDPRNtcbMrS/ocnuYbzpHGEtj6r
	/qYvE/RpU/DC53wYJie4A0cOyt5F0qE0F3sK3QPKYVQwd5jAZsMXUzdtCC1E9Gcv7hBI/x/n16x
	iNfZfBQ==
X-Google-Smtp-Source: AGHT+IGLiFKCkiAoyo8w1adxKIx9TSOzM2AC83Bo64USM+supssaEydukBJfVufrwhWzLpi5mXFgs4LcC10=
X-Received: from pfbmy25-n2.prod.google.com ([2002:a05:6a00:6d59:20b0:7e5:4656:9d96])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d90:b0:7e8:4471:8ca
 with SMTP id d2e1a72fcca58-7e8c6dac0c1mr746508b3a.43.1764980327560; Fri, 05
 Dec 2025 16:18:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:16 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-41-seanjc@google.com>
Subject: [PATCH v6 40/44] KVM: VMX: Set MSR index auto-load entry if and only
 if entry is "new"
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

When adding an MSR to the auto-load lists, update the MSR index in the
list entry if and only if a new entry is being inserted, as 'i' can only
be non-negative if vmx_find_loadstore_msr_slot() found an entry with the
MSR's index.  Unnecessarily setting the index is benign, but it makes it
harder to see that updating the value is necessary even when an existing
entry for the MSR was found.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2c50ebf4ff1b..be2a2580e8f1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1141,16 +1141,16 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
 
 	if (i < 0) {
 		i = m->guest.nr++;
+		m->guest.val[i].index = msr;
 		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
 	}
-	m->guest.val[i].index = msr;
 	m->guest.val[i].value = guest_val;
 
 	if (j < 0) {
 		j = m->host.nr++;
+		m->host.val[j].index = msr;
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
 	}
-	m->host.val[j].index = msr;
 	m->host.val[j].value = host_val;
 }
 
-- 
2.52.0.223.gf5cc29aaa4-goog

