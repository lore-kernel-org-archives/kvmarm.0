Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69D34C89
	for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 01:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716342020; cv=none; b=ISwgSXiJQqg24EqeFdrqH054G3dGHLD9frqwHYCzzK8KXp56o8lzlw1yDpuEHbnYedRQP4fr6dugWPTWYIk9gFuytd67k+t+/co2JfEyrzj43C8LLk5Ovg0zd7kZyVaKCh6d7CNy7hyX1+D0jRhyt/leH8XdWWDoVHePy0i71tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716342020; c=relaxed/simple;
	bh=8WkgXvFVZEpynasJJ48aoJTH4+LPLoJyE+T2vpEb3+o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QJrqe4XRzcUCWbV1QZJfxhDuPxry5wnZiwDBRV7ZEecOacz41T8Q4SK2rDmb6mQebMvjmEIEeh9G78zZtBDdq8e6c59PeFwblK4yM4OK05KrFmnHLlhjstTvPqHzFqciWkTAPcwKEqa4wQhFnVqX5r0WNl6WyKWuw1Uw8AaeNQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lO4A1vfh; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lO4A1vfh"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5c66a69ec8eso10774992a12.3
        for <kvmarm@lists.linux.dev>; Tue, 21 May 2024 18:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716342018; x=1716946818; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ksrstYm4acNB+vq44uyCoC45OYvJ0DDPXjwdxHvKYos=;
        b=lO4A1vfhwt0qTTTDDIOuKRLrw5mFYnvigdVdYGYRdtFTkc86ekrW7YZMPKTOatdnTq
         zafmEgDK/N/wSgo/KCKHPcKsFEvxmPGGTrX/wz1gwrE6MH5QS2CfzpWS0w39y0vmtuiN
         iszfRvDRKxp50+R4FHZVZ9R4IgB5zComHt7jfPGB1GuPAYWkHF9AkTC3Rt5Yil5rRlLd
         9wVLdmac/JlOjlivQ1Ey8E1c+oK5itTaYQ8oXMTumC9rHHn71+9Id6ybyBoL7WOw/bKM
         NVgir+uyW3A5dCa6ETWbAumd8PHCvMiUW1+pUzLzaKtLuXkR9oUeNTvcYTz30HYdWrt2
         hccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716342018; x=1716946818;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ksrstYm4acNB+vq44uyCoC45OYvJ0DDPXjwdxHvKYos=;
        b=tnByoL6zudCI1im0UxV5WL6qZY9zmLhikZmI6xTkXGfTUAUqGvEXDlefN9bnshJTgt
         kUhQF90P28/tmNdhpUcvewbGvxz5fyzF7npKp/9g71iTHAZW/6uXOQf3+Ddx7Ss4cAXf
         aAkQtQ0RdBl30csJBxylkOQVFLgZ4+7M5WtGF3MR5xnWTMHB2vxXHVt6DehUTPRMo0JW
         T/9rXXMWXakMaLpG429yh1lHmI8hALA4F1hGhDhnNCvzxLjQ58CQ3V7kTEgyjuVglHbI
         bs7ZM1aU64o+BI8LbqIex+tnNMKlO7Z8fG/CTOilpV9Jr8WpBcYsEdBnw2obdi4pKicb
         fz1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWSwvM3kM8CGAgM16mp0Hkd1VBcTWuS4+A2IdMKL7TQEEuxw2gp2m9AurOVI8mgRyRc3adTUpUTVjv6Z+lG/uplQozBZ7Mi
X-Gm-Message-State: AOJu0Yzv8PFZo+Dq81oqxeim+QReWL0Q+lNVslFf7ES6tG4tD4qyL6mb
	9wy1T+tckVfFy3l0TIPG9brHSagNYOP0WKcjcl3G6jpjX3BHNXm8jZP7c8H8fYIqissdw4Dw/JV
	g1A==
X-Google-Smtp-Source: AGHT+IHJLNUzIn6ctcMF+INwxFBaLeFnt3jt+tGT+n5clQV+H1h//pkXMDRUR1aNO5clBwbY0FCScT/OPUo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:484:b0:5dc:5111:d8b1 with SMTP id
 41be03b00d2f7-676492dc83emr2297a12.5.1716342017980; Tue, 21 May 2024 18:40:17
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 18:40:08 -0700
In-Reply-To: <20240522014013.1672962-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240522014013.1672962-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522014013.1672962-2-seanjc@google.com>
Subject: [PATCH v2 1/6] KVM: Add a flag to track if a loaded vCPU is scheduled out
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a kvm_vcpu.scheduled_out flag to track if a vCPU is in the process of
being scheduled out (vCPU put path), or if the vCPU is being reloaded
after being scheduled out (vCPU load path).  In the short term, this will
allow dropping kvm_arch_sched_in(), as arch code can query scheduled_out
during kvm_arch_vcpu_load().

Longer term, scheduled_out opens up other potential optimizations, without
creating subtle/brittle dependencies.  E.g. it allows KVM to keep guest
state (that is managed via kvm_arch_vcpu_{load,put}()) loaded across
kvm_sched_{out,in}(), if KVM knows the state isn't accessed by the host
kernel.  Forcing arch code to coordinate between kvm_arch_sched_{in,out}()
and kvm_arch_vcpu_{load,put}() is awkward, not reusable, and relies on the
exact ordering of calls into arch code.

Adding scheduled_out also obviates the need for a kvm_arch_sched_out()
hook, e.g. if arch code needs to do something novel when putting vCPU
state.

And even if KVM never uses scheduled_out for anything beyond dropping
kvm_arch_sched_in(), just being able to remove all of the arch stubs makes
it worth adding the flag.

Link: https://lore.kernel.org/all/20240430224431.490139-1-seanjc@google.com
Cc: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7b57878c8c18..bde69f74b031 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -380,6 +380,7 @@ struct kvm_vcpu {
 #endif
 	bool preempted;
 	bool ready;
+	bool scheduled_out;
 	struct kvm_vcpu_arch arch;
 	struct kvm_vcpu_stat stat;
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a1756d5077ee..7ecea573d121 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6288,6 +6288,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 	__this_cpu_write(kvm_running_vcpu, vcpu);
 	kvm_arch_sched_in(vcpu, cpu);
 	kvm_arch_vcpu_load(vcpu, cpu);
+
+	WRITE_ONCE(vcpu->scheduled_out, false);
 }
 
 static void kvm_sched_out(struct preempt_notifier *pn,
@@ -6295,6 +6297,8 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
+	WRITE_ONCE(vcpu->scheduled_out, true);
+
 	if (current->on_rq) {
 		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
-- 
2.45.0.215.g3402c0e53f-goog

