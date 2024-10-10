Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2984220409B
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584785; cv=none; b=LjB7Yj1i/BvnTgY02uAcW5N2Co5KjCbIoP8qhxN1xDM78qpHaXhzgkTztLGmqBAeJJQkb610OVfiWEjzn7xboOpfStOvSJrazeoln3KzfWVZWHQM6m/IfAgHAlSc5eZ272i1z2oR6VQuww0ZNeANbcbIw8W2oB/K57m9VElmFQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584785; c=relaxed/simple;
	bh=Hkx6OqV7mFxqog7S2nXIkbHpJQToxM9/kCtdODEngY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T5mqv6aQ59A6AzTutDYi/pYDJVB5NW37nMWR0g+ziMW4JH7Xg6Pq49bs+FPKl9NkbL4Rs4+Ie/w8ADNNYNoBAE7yqCoK8/xh1/xALG+xevfPnqSi2CMemHhE+HyNEPR0KjixaU0HHhEVWQGufOKwYrUlSy+9pn0WyBg0Q0vi9Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SmGnE6gL; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SmGnE6gL"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6818fa37eecso1273914a12.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584784; x=1729189584; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O48RmE1hmLPs0qNEdPIh+k/rpCPu+e8A6GC4+tMXVMw=;
        b=SmGnE6gLk2M4+z5pmAOqfRo0n335oIBtzAYKDmdvAfH1rm6rwZjhkQ9tQR7097XP1P
         ERyIeJJ+PTgBGrLMsuw423kamKRrhpJQhn4zoALb1fWUWfgB/MR7r0gMKTFtI1Pbw+0x
         SbkZxdV2RiI7SeMzSQl43X9ZvRtYz/FD3S5zMhglCcanZ/EnLCrOH8sTgwZo+ilzjUa9
         +CLz2w2d+YSKnjEpJYUDOIrWhKxTiiJJFQrbxJXyINFgQ3spvrVY6+LxGMlYD58IFCsl
         Bf7CuKcXX9EWGlfeNT4MCcBYpOtWgAoGDsOcu7Ri/EcLWjXijmX63FTVkSxC53SCsStM
         rxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584784; x=1729189584;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=O48RmE1hmLPs0qNEdPIh+k/rpCPu+e8A6GC4+tMXVMw=;
        b=oMaxINsXU4gPbEvX9bqwMwrLgTTrgSMw07gNvGH8om3rNw47KrELp7NzZ74L1ck7xC
         T8ce2CUyA3kb+s2htD8AFr7MeuN85q+/zIIrgunN8doMx9USL4Boba+rcCQTrinEWQSK
         BH30nciHSGkJNcCHAwDL4Jh7ZaHKC+rjc/dQ3jh2hBUECgciH78qmr+me8ixPlZBNnfw
         wDIFSlRn2UK38BsV6yrsIxS7MXKXfq5ee4MxNSq8BqvbKhc4MMVWVsrJxEfX1fgGqA8r
         hX7eHBexPlFI8w9+aIcC/Q75Hs8D286YxbKlFgcxIiSgZ9tCXYyck/2xrE9CpXpZ6Zbn
         PtUw==
X-Forwarded-Encrypted: i=1; AJvYcCXAoctX+VNcUPLa3NLk6fSQjqAGtizDgS7eRBeJEB89Q8qcGRiFjBjrzRrNr1QUKZWfNE3xC8E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyd1JpMRIHcRHXFfbKiVVAVa07o871uaKkSC2LuRFF+9a9ppljE
	i8T+WklUZ6YPPIdi+jZwpZjHQ6VijYpf4yXn2WRrbQXukAR0XH9FSMHW4e9gftBCJoy0NGH2eXp
	Udg==
X-Google-Smtp-Source: AGHT+IGY3J0AFIsOlJbVDrqn6majLeEUOkcp3LAakwsbgSwDXT3SnAGgA9L20idMLdLGQvBeoRsHZDJxo50=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:2445:0:b0:75d:16f9:c075 with SMTP id
 41be03b00d2f7-7ea5359cd2amr19a12.9.1728584783356; Thu, 10 Oct 2024 11:26:23
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:46 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-45-seanjc@google.com>
Subject: [PATCH v13 44/85] KVM: x86/mmu: Convert page fault paths to kvm_faultin_pfn()
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
Content-Transfer-Encoding: quoted-printable

Convert KVM x86 to use the recently introduced __kvm_faultin_pfn().
Opportunstically capture the refcounted_page grabbed by KVM for use in
future changes.

No functional change intended.

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 14 ++++++++++----
 arch/x86/kvm/mmu/mmu_internal.h |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f730870887dd..2e2076287aaf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4416,11 +4416,14 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_v=
cpu *vcpu,
 static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 				 struct kvm_page_fault *fault)
 {
+	unsigned int foll =3D fault->write ? FOLL_WRITE : 0;
+
 	if (fault->is_private)
 		return kvm_mmu_faultin_pfn_private(vcpu, fault);
=20
-	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
-					  fault->write, &fault->map_writable);
+	foll |=3D FOLL_NOWAIT;
+	fault->pfn =3D __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
+				       &fault->map_writable, &fault->refcounted_page);
=20
 	/*
 	 * If resolving the page failed because I/O is needed to fault-in the
@@ -4447,8 +4450,11 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vc=
pu,
 	 * to wait for IO.  Note, gup always bails if it is unable to quickly
 	 * get a page and a fatal signal, i.e. SIGKILL, is pending.
 	 */
-	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, true,
-					  fault->write, &fault->map_writable);
+	foll |=3D FOLL_INTERRUPTIBLE;
+	foll &=3D ~FOLL_NOWAIT;
+	fault->pfn =3D __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
+				       &fault->map_writable, &fault->refcounted_page);
+
 	return RET_PF_CONTINUE;
 }
=20
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_interna=
l.h
index 59e600f6ff9d..fabbea504a69 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -238,6 +238,7 @@ struct kvm_page_fault {
 	/* Outputs of kvm_mmu_faultin_pfn().  */
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
+	struct page *refcounted_page;
 	bool map_writable;
=20
 	/*
--=20
2.47.0.rc1.288.g06298d1525-goog

