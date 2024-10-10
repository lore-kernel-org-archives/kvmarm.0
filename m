Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9E720B1FB
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584831; cv=none; b=agwtiZMp6xLQ7pO7nFvKP8N+39VJFXfWFfJgHaSlP+c6yqJqomBnu1/jlqPksoVhy4kEMbDJRAESh8FOagr5qDi53RLm/kduoLRPm44r7Ce+LhgB3YJUecz7cPsBwBIaiLu+2mCZYinXQrUIZ8sWpw1itLvEmSwR1/1LyJq1E5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584831; c=relaxed/simple;
	bh=ffJ+Y8PQp+slQQo0S2lzOgDI6zSQ/cN8IdVD7ZeuwkM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WkwvcP2eNh7t3B3wVFxHm91r2l/yg5xQZc3mrWjzjHrj7OvJc1q63kSi0eEJxUWCZEOeI7UKZKbKpi6U1Z94iwe36uQwXa5u4Befnwm2ePFbjk8hfmAijsflZZHd479IujQJrJi7uDhXTRSdZ9EbR3aaIYii208v2lHP5zspU2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fOj6Q89V; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fOj6Q89V"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-6c8f99fef10so1638334a12.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584829; x=1729189629; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0kIT1cNFK/xt59MDB/Io88ATgyMybLemEwY+DfOgUM8=;
        b=fOj6Q89VWhNOEqARdWjJCznbsLepuQhODUetGurj2dTqOwFF6gRCh2n6bd+M5hKkMr
         Q0HaRIuLzZCQHhYDjKxSQmXV+gvhpIhtwuaeCOwu8Ce31cKhqGIvfxrRvqNA2bohM4R1
         aE0f7zx3Gn+Km6KBJ9iB+G4VVEBlU+KxmNQcHt/iWwfV/CbbWN9FbYFhL9qCnZwqJQET
         2XCkOYwqJMi2ntt/rJnHJpx3CTHPbDp7z7QS2RCcFrA2TPBMv8w4suepHitTh0i8lNze
         Pe+sAb57toW/qpRi396Pot/lFKlzb4djZOwdL2fx29lxp6hyk4tHGy5WeMo/hha/N0gG
         46qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584829; x=1729189629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0kIT1cNFK/xt59MDB/Io88ATgyMybLemEwY+DfOgUM8=;
        b=o/I4ZDODcSrFOyk4SmhFqI60vB1/DFrheG+kkDz5HRxTh5yt2r1jSQgYlS63TTJoTZ
         OSeDy7x++MeEGvRGoWdvKYZzAAViDqTQowDl4UtsjzIHv1hvvNViAHlCuv4GmO0yxKzI
         Pg/aVOpKZDa7LkZOcOyQ8tKWOCkJZy5jK18UFFdfMVEOcmdMxbDwS/TSnHmAnqdzJVP4
         tR7cTJsFduFUBlLQDowDgOTlKIXoat6skqc7EvJRJwbTyUGVlN/YvphIV+mGZvoGTVOl
         odU+VMWXNQ8GcIaJ8i80nHB8AL1irGH3REu2+a7SEMJG+AzU6prcqdnnHqsO7PYlUW/n
         fhIw==
X-Forwarded-Encrypted: i=1; AJvYcCU51nokvWZZamSMCl58XCAjbBVRJuh1SGYIJ76quySVvYPmzKnC164N16OM0vlhsmv/dzPCtyE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy47NQr+Ri3Ry2sTEA9pJk7BpX8xj2UiWBI3CkHx19Zr6LGOX1u
	eNaOZY931CGPFm0f+ay7ZMZbdLQJra3cgolYTvlkpaWfVrUx42kQBfAi213FKuvyJDOGrkVCYPX
	Q8g==
X-Google-Smtp-Source: AGHT+IEVjHGN/ZoxQo+Z413816spxD1Vig97FmVkGQ57WYZx6k/7CY2I8TFVs2SPVm+Oq4UkGx7TgXf3+Fw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:192:b0:20b:bd8d:427a with SMTP id
 d9443c01a7336-20c6377ab7bmr1062205ad.5.1728584829203; Thu, 10 Oct 2024
 11:27:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:07 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-66-seanjc@google.com>
Subject: [PATCH v13 65/85] KVM: LoongArch: Mark "struct page" pfns dirty only
 in "slow" page fault path
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

Mark pages/folios dirty only the slow page fault path, i.e. only when
mmu_lock is held and the operation is mmu_notifier-protected, as marking a
page/folio dirty after it has been written back can make some filesystems
unhappy (backing KVM guests will such filesystem files is uncommon, and
the race is minuscule, hence the lack of complaints).

See the link below for details.

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/mmu.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 28681dfb4b85..cc2a5f289b14 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -608,13 +608,13 @@ static int kvm_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa, bool writ
 		if (kvm_pte_young(changed))
 			kvm_set_pfn_accessed(pfn);
 
-		if (kvm_pte_dirty(changed)) {
-			mark_page_dirty(kvm, gfn);
-			kvm_set_pfn_dirty(pfn);
-		}
 		if (page)
 			put_page(page);
 	}
+
+	if (kvm_pte_dirty(changed))
+		mark_page_dirty(kvm, gfn);
+
 	return ret;
 out:
 	spin_unlock(&kvm->mmu_lock);
@@ -915,12 +915,14 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	else
 		++kvm->stat.pages;
 	kvm_set_pte(ptep, new_pte);
-	spin_unlock(&kvm->mmu_lock);
 
-	if (prot_bits & _PAGE_DIRTY) {
-		mark_page_dirty_in_slot(kvm, memslot, gfn);
+	if (writeable)
 		kvm_set_pfn_dirty(pfn);
-	}
+
+	spin_unlock(&kvm->mmu_lock);
+
+	if (prot_bits & _PAGE_DIRTY)
+		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
 	kvm_release_pfn_clean(pfn);
 out:
-- 
2.47.0.rc1.288.g06298d1525-goog

