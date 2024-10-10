Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0B1210187
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584840; cv=none; b=Zbrv9lZDvqexL0VD1YMqNLinJjvincb07XQhbJo2fBCSbjFkm0O3QM8azmihHzh8iNEmGLndpq9D69SmXmoAOAob5rMIqVo3XZZwq0Vx8+28b9HzHiNCLQ8LuOqewCSa6c4TNfhEhfaeaY9MAHFpdQVwiUgvYkhfTGxlWDC/ncA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584840; c=relaxed/simple;
	bh=qdVWvBqKE29lnYElhxBDh75UWFXRti117FkDAjCdYI0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e9QPt+HrgCSC6Hm5gZd4aBHkzjfvxeqicotGxrC8l17VQ8i8i60y8Mgi46hqH4P3y+/NpiGlCZjJpCvQQthHIDtyLGY9CGFsJiUptLLLQYng20ct+Sy7P1brmigak3H0GScK4ooR2QLU6l4LJiMAgxiJVUsoMmqY2hK/HLHig/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GKj4Fz/i; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GKj4Fz/i"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e2906efc0eeso1521804276.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584837; x=1729189637; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Sag0fj8OwucY2qRogRu5ELvjWktNcy71jZ/+qgEdHaE=;
        b=GKj4Fz/iw8bFFJUgsnr80k9421gN25NyJzaYX+ZSTvAlo+TAgJdJoGz3cKUfpATRGF
         mAMlBUGRjSMd137P6L79oGTaZ7E3mhPzZ8GxYExx8f15mnSTLNCi2oUJaKcja37nH6Rw
         X0mjXh+YUdwJlBpzsIRTQkk+9FNxu/IxzZzp41OsRoB7krQFyVxfx0XhUw0ilKGKrSQU
         E9EIKpmDp8bTmzy6B3776iPu/+MJ8YZChAGKwNiqF6bj797OeU4GAZjpeiyYuazAqwQB
         K6mBgPs8ZUqyYV/6fY+yZCpJD7fEB61PvUSChknkSk87J5GAQZxs0Z3ap4THa8A47QDN
         szLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584837; x=1729189637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sag0fj8OwucY2qRogRu5ELvjWktNcy71jZ/+qgEdHaE=;
        b=HCSb6HrwdWxjGCJZff2EWmw/ngY07vyVePX3H7cIDzXXvAvB6v0++TK5RYFKA7ZyBa
         ktgdZALzN2yAQAsB37/Q3eFQaxz2/ylaO+o1mJuyfqDnFVq8Jb9dluE57Cx54NJ8FKLf
         AKdWu3c0vx6QX98Uzx/SNlUFqk4+oiX589L2nLcZxGDejU/Edz2qvHysNoZhBr/IwWz2
         xcQJw6Dz/FmnH/unKtOJOAZm9xs5on3q8FUtfLt0cxFmtuQVUEmux2HOYFHktyhBB/Cm
         L3IU9DvtJSrQDUxjjctKhUwWYUJrlWXfUdfi9UIGCHwgizP4kryzgXBIhpINHJVvEcLS
         xAWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEV52kdfbXdv+TR7mEJK7UFnmZfgcfiM2SMiUnhBVqhk3D+1dr701Uo3/Z0Mq5WOpsluWKUpc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRj8wobU1vFS+kJVX1bCEMITKdPNHC+95X3kQoYkFeCYsaHVfG
	TLl7OGoY/7krtQG6WlAlPKY47OHz/51fLmXccahHy6Wh7fjNcYzU96r3s64mhEEHYs30syL9J4k
	ruA==
X-Google-Smtp-Source: AGHT+IEjJriLMGICq9yty21Fx3Z3FQyTG0XCg9lS5qhc+MvTVoRASG8drmw0OxSoWZyAtrQmM3pJDo8jQYk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a5b:a4c:0:b0:e28:f454:7de5 with SMTP id
 3f1490d57ef6-e28fe52740fmr75826276.6.1728584837458; Thu, 10 Oct 2024 11:27:17
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:11 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-70-seanjc@google.com>
Subject: [PATCH v13 69/85] KVM: MIPS: Mark "struct page" pfns dirty only in
 "slow" page fault path
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/mmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index c17157e700c0..4da9ce4eb54d 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -514,7 +514,6 @@ static int _kvm_mips_map_page_fast(struct kvm_vcpu *vcpu, unsigned long gpa,
 		set_pte(ptep, pte_mkdirty(*ptep));
 		pfn = pte_pfn(*ptep);
 		mark_page_dirty(kvm, gfn);
-		kvm_set_pfn_dirty(pfn);
 	}
 
 	if (out_entry)
@@ -628,7 +627,6 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 		if (write_fault) {
 			prot_bits |= __WRITEABLE;
 			mark_page_dirty(kvm, gfn);
-			kvm_set_pfn_dirty(pfn);
 		}
 	}
 	entry = pfn_pte(pfn, __pgprot(prot_bits));
@@ -642,6 +640,9 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 	if (out_buddy)
 		*out_buddy = *ptep_buddy(ptep);
 
+	if (writeable)
+		kvm_set_pfn_dirty(pfn);
+
 	spin_unlock(&kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
 	kvm_set_pfn_accessed(pfn);
-- 
2.47.0.rc1.288.g06298d1525-goog

