Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2146820C48E
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584835; cv=none; b=Z4JoBIskTPzONbHAaGliW1HhUubVtrwH9fBx8pJ0P/oirh42hyqhC4SwcUfGlRbPgkw18XEIJeNxjOo9HMOEk6jYGx2N2UF5yBegaM+w7LNXRPtRb4ve3iKldz+etl4ikhS4B7kiSl7CDV77dG29jNohmxxd3CfafDlv+q125FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584835; c=relaxed/simple;
	bh=+TpPAbVVI1obWW7OdvHKpXsCMwy9+BV5v8TfW2u9vbU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kCMiDNio8VnqaackX8RE5gq3fxurGIeGii5BjJpICE2atjjBx3Ajjaises4Ozin6+LGcDcs2ChdyAKG8xF6SHVD0QhXWjfSpNKmct2WRYsNTN4piL86PKl28WC5tCbZd4pWZvzzu65sMG2u01MReKt9iXLgwC9ewdc7X/7ozzMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2N978RkW; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2N978RkW"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e2a013a01bso1335888a91.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584833; x=1729189633; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=3FFUjrr9Bcuid6sLVD5OEsWVTb8VG25P9bGjkNYbAzk=;
        b=2N978RkWIQUvkWuVvKWYf9UZqZkyhLFGAxgb8FV/gEADYQhjtYfVjx+gQ0CBbLYpTT
         u8AacHs/vjjrhnrcDc2kXfL++7c73Dw8khcLy4XUB0at+YhPvUrNaVHpSiPfJ1eSjpzT
         KGE4cI6vFHpBRVPtnti9m6h3RRqZSXPGTlb4w2Kp37b4EnXqxvJv/gTZMgWJvAlHD4UU
         TvBjzfzavr78myKCcQcr7Ol7ifqZ4pGEyoSQpvATc1DET1oHq2vVzIoW9rdRdqC/X6BT
         zfax2F6G9eX1c6gBN8bJUexbjtRO8tnHVbV1bTDG546b4PSrdfmBOL/U35yr8uxrwzi1
         +nKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584833; x=1729189633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3FFUjrr9Bcuid6sLVD5OEsWVTb8VG25P9bGjkNYbAzk=;
        b=tmIOr5ZDPC2XomKZF4Ap0i7ka5eg86skuLDKTOedjGaB3FOzzkBIivVJpIit+Li/Db
         fgkJKPOPFe4barEGl7bvfriwGb3FJCuMmb0eay4tqDw7bdax2Lvm+4pvlUuDsH+rRgW6
         El9D4UwJOegX9XEqVjtTxestA5yl/lv0jkeW1g2i/b2xsEVk4zFOq3UA/xE5a6sPIPmp
         fONPPVB4Acecdq06UnoRDJNA5mUGTrjjuNrPqQ9wGffXywCAJIPL2CiulLB1NJmxboCy
         /V+b7IuzVSXneHcOxg6eXH1u6uwbkYutFoqJuZULbk+3keqXB5ry9nnm+QWZOKQJkjRO
         uObw==
X-Forwarded-Encrypted: i=1; AJvYcCUT/C9rx11185BiHIEytoX7MvUSEOdcPrXhgaYKHH2xdSi3iv3NNCdR94dfegHc53QU+BwPJdU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxALAxsEAlDmShr2zlQm7E+snAetbXzPFqdEcriboPjUG3igN5v
	kPcsvNuYVBKHnKbStPd5Bsb0KltZktnhK6ZgJ5CPSr3qfldTh18MIknQ5fDK8qtKMBSlXFhUIvV
	OyQ==
X-Google-Smtp-Source: AGHT+IFpwqxWKAWfrUvKF1EatvnBv5g5CrzcpgT/ZTuiTODJnzoCoYK053S1MFwF0WyL9wI3LVhDYDAiv74=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:46d4:b0:2e2:e148:3d37 with SMTP id
 98e67ed59e1d1-2e2f09f1a56mr94a91.2.1728584833102; Thu, 10 Oct 2024 11:27:13
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:09 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-68-seanjc@google.com>
Subject: [PATCH v13 67/85] KVM: LoongArch: Mark "struct page" pfn accessed
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
so that LoongArch can convert to kvm_release_faultin_page() without
tripping its lockdep assertion on mmu_lock being held.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/loongarch/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index ed43504c5c7e..7066cafcce64 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -902,13 +902,13 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 
 	if (writeable)
 		kvm_set_pfn_dirty(pfn);
+	kvm_release_pfn_clean(pfn);
 
 	spin_unlock(&kvm->mmu_lock);
 
 	if (prot_bits & _PAGE_DIRTY)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
-	kvm_release_pfn_clean(pfn);
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return err;
-- 
2.47.0.rc1.288.g06298d1525-goog

