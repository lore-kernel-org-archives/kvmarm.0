Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1DA158D76
	for <kvmarm@lists.linux.dev>; Fri,  3 May 2024 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714760267; cv=none; b=hHXuEJLgKObpn2PsH92PL5yZhBKFlPcaz+gI80GyHYBudebCfRcz4EM/R5X896QF0VYqMhmsOPNg2PoLJlqB5MBfZALnHw/C6uPSvZGjqCRyjS5GSi7yC1tiYBG83rwErx9lTTEBXZJ1jvDT1QJRUpKuNHzF3ymnP/LeEqrMO4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714760267; c=relaxed/simple;
	bh=MnH1Wy/qfGLoK8pqY0vb3YbaD+FyQMej5pfO9Kyf6Bw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RD8iS9ci63Fc/C/WVAvLxIGMDP0rMRJflFLus6rCOsEexF9W9WijuRDYpBo5wOCedcRwpCAu0NRxa6E/xAhNcUjfOhvOhHjZHIW/NhXDQxI148HFWnpPdr5+r3FrbWUrAwVwVdqChbwm/dHp5oqkCwS3RT0v3rriPz6BeOHaf40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tqGXMHtr; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tqGXMHtr"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61b1200cc92so176567147b3.0
        for <kvmarm@lists.linux.dev>; Fri, 03 May 2024 11:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714760263; x=1715365063; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XCWz5AboezUKY+fKcSkwtkc56yFvTydQOL6+C1uV1TA=;
        b=tqGXMHtreE8S4BP3RxrJfRJdrllPmr+pdP88DXFRRgDiR4M0pNeBlRNhBX9mVCVAgo
         zR1d30pMBmQpyeJjsLYNu7U5p0s/4lwbjcoXdepcErgZvPy1NPyqxCovF5CmNwnVrFf3
         tMG21Z67FY2SAtTomIQsf/BoPAekDqmfFgGc4/keHj9p5NYW/sHIi/TMnBJH8lF9Rpzo
         IctzPUVwpg0BUy2KpMcx/vS1ewRQJiubZyO3G0vQqhcpdwVkNJH3BF2JwviRVP0yqlu2
         D2/cCohE0eKw6VymufC00ADD0IYPErxqQFje2ButMjyqjV30+C2SbKR+hIMnRlnrpAfq
         9rRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714760263; x=1715365063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCWz5AboezUKY+fKcSkwtkc56yFvTydQOL6+C1uV1TA=;
        b=L+4wt7scwAQJyQsbr/IGWj907KTmZi6aIYao7288IG4rTEPI1aHhM4g0VrYGVnp0R4
         /NcfLvojyx2ixE2oDFY2eIduEApa7m4oI8Y+IcZQwc86PgP3qVNf8FjXFcgK1z0sb7iY
         ad53GdxhdVbQ0hNcHGupfmmCbAJyVon0hp0ZNKfTRTtoNKrvW3Dce2fSN3XLZqZJ9GlQ
         gQok9LCipjtmfeVuE6WPO+V0yDys3gA4WcNld1i/LTIH3KmaDJI8Afh5f8r6tViyVkIk
         WYN/RHx9J6gT7pJa53aEW2Hg+lZWa8OVvttygp7TxB5fRrWfuvZ5c/MUFjuTP9HWGKSD
         8/XQ==
X-Forwarded-Encrypted: i=1; AJvYcCXID6zL3JNw1BiMACYe1mpQ5Lz59UHRAt5YBhQH8pOvIoRdH5RzCSB90a5cjS1hKmZqN4ydp4dAUW5PgQ6Ij6HOL+bYYWBU
X-Gm-Message-State: AOJu0YyYh1WV7Wb63R/KKCqosl2abLTy5dt61UcD9CgwbOh56B5fmF/y
	HnpvwKzWARVi2YDTgFdGfG8iIqp68EzyX5Lg9jDrMBn+JOfS3gw6FjWYwCcjAdj2y61TXQSbUoB
	FnfrWWTct/w==
X-Google-Smtp-Source: AGHT+IG8z91B85kZw12g8ILejBDce9nCeI6uZrPNjYvj7vQXfcVKq57xpnYqIWHHCJ8gvpfpvg4aSbrDSFG7Mg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:ea05:0:b0:61b:7912:6cad with SMTP id
 t5-20020a0dea05000000b0061b79126cadmr815080ywe.2.1714760263504; Fri, 03 May
 2024 11:17:43 -0700 (PDT)
Date: Fri,  3 May 2024 11:17:34 -0700
In-Reply-To: <20240503181734.1467938-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240503181734.1467938-1-dmatlack@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240503181734.1467938-4-dmatlack@google.com>
Subject: [PATCH v3 3/3] KVM: Mark a vCPU as preempted/ready iff it's scheduled
 out while running
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Mark a vCPU as preempted/ready if-and-only-if it's scheduled out while
running. i.e. Do not mark a vCPU preempted/ready if it's scheduled out
during a non-KVM_RUN ioctl() or when userspace is doing KVM_RUN with
immediate_exit.

Commit 54aa83c90198 ("KVM: x86: do not set st->preempted when going back
to user space") stopped marking a vCPU as preempted when returning to
userspace, but if userspace then invokes a KVM vCPU ioctl() that gets
preempted, the vCPU will be marked preempted/ready. This is arguably
incorrect behavior since the vCPU was not actually preempted while the
guest was running, it was preempted while doing something on behalf of
userspace.

This commit also avoids KVM dirtying guest memory after userspace has
paused vCPUs, e.g. for Live Migration, which allows userspace to collect
the final dirty bitmap before or in parallel with saving vCPU state
without having to worry about saving vCPU state triggering writes to
guest memory.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2b29851a90bd..3973e62acc7c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6302,7 +6302,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 {
 	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
 
-	if (current->on_rq) {
+	if (current->on_rq && vcpu->wants_to_run) {
 		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
 	}
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

