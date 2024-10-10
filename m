Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069F0207206
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584808; cv=none; b=FQcMxaH8Qr6dCCrDMoB1ISAkH0cG8cj5QRedahGb3ITrFXPfUWH5XtgDLZeUNT2feCrKqyEcqHSZ26slqhsMo4nqgxfw+wo7+uQAL03muf1tWWtjpthiJ5qHzyff8/18/9CQKWhS8q+tRRo0KWsvETl7Xm3cVTHnkaLhc8BvSjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584808; c=relaxed/simple;
	bh=kbjwflG2kz8fn2XlGwl/ZUkp2MoQm+/BMH1MpANV1Tw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t3LoeXkgTHszd3eJuNc5PIaucneIKbJ0T3fLYHnEpnkt2VG+6ssn9khniXxtVA+45V5GbRcfkDQIInZcMItcdamtlkHxHk4+Tk8gn0Ttzw7xms1o0u7q3Nd0HBiIPrxQsJ9aTJXrNvhwKVOdN0ol6i0PT2XrbN2nXu6BEzBGgKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KOPgrrdI; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KOPgrrdI"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e2d3d5fb4eso897526a91.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584805; x=1729189605; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RAEBOjiR86B8MKio5svj+gL/GJb0VtWq7ImNxArS0H8=;
        b=KOPgrrdIQuxv55g2QNpQWt6OmHHUR4RKLO7D+Zc/FE9w5jHQ8QroI9PpH3788B9Cx1
         ANsuA34N227F16ki3fTO94u/rQtyI8/3d3CmDGyzTWWXKIziO8vB9w1zXlS2Ao9XXga4
         pqxx2HR73lF5P4ZBuJDKLrfXOLtGi7EVBJLZFQMdqRXqDTmKWeEFfWWIiyyUAjgfttQA
         XZOeR+aiFbCF1Wq30QZtVmYbC/FVP/HnjpieNPlc6vxLM78ocMpKO37JCfyRpKwkYlir
         RXdSMxaBdEGfI7dAkDPcnaO3vU2GUbCe+Q9Snb6Rsivl7HEHsN0QLVwY0TRIkmdBIRqt
         yarg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584805; x=1729189605;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RAEBOjiR86B8MKio5svj+gL/GJb0VtWq7ImNxArS0H8=;
        b=h69N2qJcNCMI11lVNXF6SE3F98c23ML2hEZXSEU5/242M4Nyy+1VSOVKKvLseioz1t
         yySI6x2+Tjg66cxEzwO5Oudr0xyoTZ2YrnoH79IeRzC1UbJ/Hh7rb4udwudQJb+r88Fw
         cD+MSzwREZsJH7E3lAGr3ZceOlXKi2VJyNl/E1doLnKGy+L2yNM080ehbLCPDWV3Gdh/
         phqzLmcwRGQ1Y9fFCtuRwe/Frkmx8zpGRSxvkTwhJJip8OJeuVmbNpNF30Q0VCbqd5H+
         GM0/lmy9w0ez5ZxWn4/s0H34I2sdEXOhdFW0jemhGLzc7lJMe6HlMxsieJxd+KJ/E/gD
         m81w==
X-Forwarded-Encrypted: i=1; AJvYcCVVwtTw5l5cg0y/e9ZyiMfrYqup4gvRWWOeXngjmHwB/NtswJwEoWSWSUyptKfJfJw7TmR81gI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZPIVUVLrfvDIBFgeh6Y7mtAoCn8mLrvPcjN2DJRuvlaWNX/7i
	AjzEsVQheUgcg/ohxPwxJ3fY4CB6V0oIQU0eKtHfKhDHRWiYb5jxjB7jQnRvN8hRXC8rYhLUYyI
	YIw==
X-Google-Smtp-Source: AGHT+IH3g+or1uGKI8zaqA7g6VjAId1uToioip8sNGZo/KyXggeZoODfUOK1q5z450FXHERnWYgwR7EwX2I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5107:b0:2e2:ca3e:10fe with SMTP id
 98e67ed59e1d1-2e2f0f88a54mr24a91.8.1728584805241; Thu, 10 Oct 2024 11:26:45
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:55 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-54-seanjc@google.com>
Subject: [PATCH v13 53/85] KVM: PPC: e500: Mark "struct page" pfn accessed
 before dropping mmu_lock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"

Mark pages accessed before dropping mmu_lock when faulting in guest memory
so that shadow_map() can convert to kvm_release_faultin_page() without
tripping its lockdep assertion on mmu_lock being held.  Marking pages
accessed outside of mmu_lock is ok (not great, but safe), but marking
pages _dirty_ outside of mmu_lock can make filesystems unhappy.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/e500_mmu_host.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 5c2adfd19e12..334dd96f8081 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -498,11 +498,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 	kvmppc_mmu_flush_icache(pfn);
 
 out:
-	spin_unlock(&kvm->mmu_lock);
-
 	/* Drop refcount on page, so that mmu notifiers can clear it */
 	kvm_release_pfn_clean(pfn);
-
+	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
 
-- 
2.47.0.rc1.288.g06298d1525-goog

