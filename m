Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717E91F130C
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584730; cv=none; b=JGAtN1qocYDiucAIgBL5TkOY/J9HeFxaI5ECDhrrUrLsBT/Xm3EGrjca7d0cMthFpnJOHOMKJQZcGhvFZz5CJ+yTup+vDBrk54K4hOyVlbaNw3VM/g9DY9GQ6Nqza4GbwGKjYWiqNth/JiH+oO5r2diUIjV8mJyPdC5mySup2h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584730; c=relaxed/simple;
	bh=vtDT6oLoOmF91AiioFXu5/ol9RZL+XplRHPVYvyqLOQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tXY2z1L3biN0pqJX9EgTIg1Czq9fuyHaet8DSB44dvmfiSofgx7RptE16cSuxRueBWtmlbj7IsbP0VzwLWwWsv807lt1s7irWbXzDVwfoytavkLERJxgJdqYdcczYdHzeixRwUXhcPQmq25nYRXTVdoho1+oMBuZXpIxBLiN1I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bpj6f6Kz; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bpj6f6Kz"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20bb491189aso16352675ad.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584728; x=1729189528; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5N9i4qcLR1M4w0icoJwy+0qPwifBeFycVmWqg2S4YD0=;
        b=Bpj6f6KzfTaSay+6D89ezug3bwSil8UvFXIViiT3zPYTRsItN8g05ICgnIcLigiDJN
         W1SV79p8Cysz5He8FVwByvaD6YZyS4qbEX8NGiyK7TlBJ3jHZe50CSVzT9WOgbh1xWDW
         YV1VbaTdD7e+EZESzGp7hKUCnvFyS8cF0MsuGoATgS4wUV3z4qWCQGVT84A18XhkdYly
         qCpJ4HIjG3DkiKsDr5B73KhPoupxAcRAX7h5jI3cs5XovJeEQOEoZTmSbpJ1hb955EUG
         z9jaM11yFQwuHsi0yzElhulbFtEF1JO7TT4DXOybo1QTzDHCppicHvZiFDkjjPbOEJrI
         XIBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584728; x=1729189528;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5N9i4qcLR1M4w0icoJwy+0qPwifBeFycVmWqg2S4YD0=;
        b=MLALgDd2Fx8YeEO1k8E2S3RBt1s7rT0/d85yYOU+GwxcYZiZyFNtgbJnrMXEyAUZDS
         iM7VHrkfjkGyCuuibBztjER0RmKxfI0FeBfiVOhM6gpxb9PglmMooDGIQARAV1GLvsZj
         40nLKk4Uznen40oVFfNJCHOgoWt43nSeHV3QPxxm3ijsrp25+FfoStOIsgLoH3/QuiTL
         ziQQ1RfYfyfHYAUXdPahwg81Rv/qxx5sdwPjHSOKRcTIkOPfzND0+7z1Ex0vzLZc4psX
         hABq3cQMtyQ5UCzL2W7ziTs3wZrzdv57QT5Nq8bOpkUE+5RLfgxbkMLFlxOQWo1PCmKP
         VVEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnDxihSqWW5SY7XRp7aL35rL8EhhK2fUt8rAhyMWhuH4f3HyZ37jcohviasXw4jhLWWIlt5co=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzsldvx2y29T5Rqrol+eU6RRVjqaoBo9cPaAhwJix/Em42KF4Ok
	O9MLaURcz6KpCFcpJhYjjT3kCBgrN/jeVQcL0OBrGVXghwxrqO/dMi6ifWdtLjzFkwOr51VOMQD
	PYg==
X-Google-Smtp-Source: AGHT+IHx3wOCIkhIacFyS0KkUCfogOtyOnmQIp9NOdA3rn83blMwYV/7exbhoH/uHIfky6alS3vCfOjmfpM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:902:d502:b0:20b:7ece:3225 with SMTP id
 d9443c01a7336-20c6358fdd3mr1169885ad.0.1728584727745; Thu, 10 Oct 2024
 11:25:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:19 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-18-seanjc@google.com>
Subject: [PATCH v13 17/85] KVM: x86/mmu: Drop kvm_page_fault.hva, i.e. don't
 track intermediate hva
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

Remove kvm_page_fault.hva as it is never read, only written.  This will
allow removing the @hva param from __gfn_to_pfn_memslot().

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 5 ++---
 arch/x86/kvm/mmu/mmu_internal.h | 2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fa8f3fb7c14b..c67228b46bd5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3294,7 +3294,6 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *v=
cpu,
 	fault->slot =3D NULL;
 	fault->pfn =3D KVM_PFN_NOSLOT;
 	fault->map_writable =3D false;
-	fault->hva =3D KVM_HVA_ERR_BAD;
=20
 	/*
 	 * If MMIO caching is disabled, emulate immediately without
@@ -4379,7 +4378,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault
=20
 	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  NULL);
=20
 	/*
 	 * If resolving the page failed because I/O is needed to fault-in the
@@ -4408,7 +4407,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault
 	 */
 	fault->pfn =3D __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, true,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  NULL);
 	return RET_PF_CONTINUE;
 }
=20
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_interna=
l.h
index 4da83544c4e1..633aedec3c2e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -238,7 +238,6 @@ struct kvm_page_fault {
 	/* Outputs of kvm_faultin_pfn.  */
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
-	hva_t hva;
 	bool map_writable;
=20
 	/*
@@ -313,7 +312,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu=
 *vcpu, gpa_t cr2_or_gpa,
 		.is_private =3D err & PFERR_PRIVATE_ACCESS,
=20
 		.pfn =3D KVM_PFN_ERR_FAULT,
-		.hva =3D KVM_HVA_ERR_BAD,
 	};
 	int r;
=20
--=20
2.47.0.rc1.288.g06298d1525-goog

