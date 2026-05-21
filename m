Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713403DD863
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374191; cv=none; b=Qi2DlmmUFsdseEcvKlw2Nnm5Mk/a7W2Tvwhk+GQ11GH6hBS+lDDmhDthVyXTaNtnPQvVO7aSPw9Fo/mBk4fzn1cx6MxwMubf40Vakj9pX36BpwMvCU/ulsreKahR0Bg5IQnujaxWp+KUjsfqLmS+Y7a/fDD8xezsPE4SeGDTgJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374191; c=relaxed/simple;
	bh=79ocH2gGd4aBjBAy1gGKwX98DE01AUVqjTREiP5QiXA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=AeefE8+YUhSycgQKH32QKvL93g+9RpIwhVC/LwZozVSCxLyFa25ycQaWowUrXic+FAsFhEgPM7/HoiODCKSiOvZM8VeSpHLhsoSfdHtR7s2BDkfVr2WSJUg0sNlNj6b8YMHIAE9CUNpPJhY4gDZZpKXbwpPWOLOUdKVuuQabrm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Im3C6PE9; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Im3C6PE9"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48a589c7879so46736925e9.1
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 07:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779374189; x=1779978989; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T/CKmmYoXfOPyCGY+f2aKlu9jEIQ4PB7UXOrFoPQagc=;
        b=Im3C6PE9AC646YUusfc2cOHLNKkseUbJeXTRTBw+l0AvVrgA3+0s0+Me3Xk4ZBQKe8
         +7xWa9N83sYod064Zca9zFoYPiSkJw9mQ6ecpfpDEjmKC3JUsYJjBdldZ+3MA9wtf0z5
         oonoE8OJOyZ5xxcgY5nTCiwd9dEUyw6s5S4lIOt1YvFcKXTen/J/hGcIU64EOSXtryt4
         RR9brmTLNnGDuWW145iqekJYT2AaJ3OQLBxcdNao1fDsTfIjEX44P8oWtZ62wqMNbQ8j
         G5r1iyrN8LDYMEygFH1XUD3fybOkwrggdiIv5Y9di6SISLMorO6ZCo7k4JS8avQh+bAE
         pViQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779374189; x=1779978989;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T/CKmmYoXfOPyCGY+f2aKlu9jEIQ4PB7UXOrFoPQagc=;
        b=nqILI+lrdaX4ehTyolxqssdLO8Wj+9+IkAkuqs1Ap7tK6qYguqZknt1HZyNMD5nIO5
         ON7004cbxpe9gnW1aQzmKxeRe0n/jH3Dk0Akfrnx3Ge5R5htj5TpBoRUfauDB266KnHv
         PSvo9Aq7xwyJbH8mFBr1rBTPeekeL0SUF4CsvWI8a3UFYCQZ4+WKH2ytpyxE0GJslRv2
         c0jr5Ex/+x4X2DzjVD+c1r073UW6bpkNbSn2QuQuS4oFUqqtOYcC6pmxZdXZDSQryoRl
         lAUv4ai2Ce9BQB+gfM4T6JLABw4mSVGcCJ9Aqn9RVzxZVdzVSrTldNzKZdyopeUUOJen
         ShuQ==
X-Forwarded-Encrypted: i=1; AFNElJ8wJXiYGVY5cFuzeBGry9x3f6P0cYQChYkgbNcOGBPF6AVe02cYFvqIJXHqvFVlhXooOnmC+6w=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7cvGLUNk8vX4KJthkR9E1kB/2w4GrlKxY+DlkdJOL9BZ6J4wt
	uv2q4A7WRIQD+OUrRSh0PbWNZuXI1tv+DlcRawfuDiPiKDMvZNgmSc9tzLlhXz6WtlqRCHKGqai
	QM1r9n6aKO6EYCH2hokmlsw==
X-Received: from wrsh4.prod.google.com ([2002:adf:fd44:0:b0:449:b698:a193])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c04f:b0:48e:8eb0:4957 with SMTP id 5b1f17b1804b1-49035f2527amr36717905e9.2.1779374188575;
 Thu, 21 May 2026 07:36:28 -0700 (PDT)
Date: Thu, 21 May 2026 15:36:23 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521143626.1005660-1-vdonnefort@google.com>
Subject: [RESEND v3 0/3] Fix __pkvm_init_vm error path
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Sashiko reported a potential refcount leak in the unlikely case where
insert_vm_table_entry fails.

While at it, I have added a fail-safe to __pkvm_hyp_donate_host to ensure this
function doesn't allow leaking refcounted pages.

Changes since v3:
 
  * Enforce order-0 for external pages, making the vmemmap ->order field
    completely private to hyp_pool.

Changes since v2 (https://lore.kernel.org/all/20260521102149.804874-1-vdonnefort@google.com/):
  
  * Proactively init hyp_page order field in hyp_pool_init  

v1 (https://lore.kernel.org/all/20260521081250.655226-1-vdonnefort@google.com/)


Vincent Donnefort (3):
  KVM: arm64: Reset page order in pKVM hyp_pool
  KVM: arm64: Fix __pkvm_init_vm error path
  KVM: arm64: Add fail-safe for refcounted pages in
    __pkvm_hyp_donate_host

 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 35 +++++++++++++------
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 21 ++++++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 ++-
 4 files changed, 45 insertions(+), 16 deletions(-)


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.54.0.746.g67dd491aae-goog

