Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E501E47B2
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584827; cv=none; b=AiPd0SLqpI31qksWUHT7icDDqYEg4swG3/cUf6BNmqr52IPCCH509SYgcVEN0AcNF1iYhIUIqKLLBy1YnmgvwbXrdWRVtmbKrS2T03c7zAAHXYUxQP+osZspswJxfI8XPMSYhF/PY1h7Si+gVyGI6YowmFaA8XttrVS8TaR4eEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584827; c=relaxed/simple;
	bh=PLrYiBlw82beEM6tLfodLLTPBglt9VZ+TVoJtuJPFlg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oUAP0sW2jZ4Ldb5IpKHai+wGAYcY3x42BIlESZPay3j3B3K0JF0oiwyjBKehBz7+hPPHplX9CCx2F+9QZ9IcP2DD0ZBbeaaCeot+jAv0+XNIQppIBNxHQ+9Df8zs9cGnPzY3S3jUDUqdD9zl4kovP3r28fr0JluR7dJDsTFy9FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sxLMZ1H3; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sxLMZ1H3"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7e6af43d0c5so1109388a12.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584826; x=1729189626; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=I+2gp5vLlKRJWMtv7YF+IvP9h9YjJXEpCIK4AMigCis=;
        b=sxLMZ1H3ZUAHlcbtzuhSJMClLc1zD+k4rTudd2nVByrJShXsvIoTCkhuy1av0HIqZT
         LUfuiY2psHKwPXv4oNPmAEXxKLaTGa2l/feLJMuhMW62Mn52323nqLs82iN9a9R8nDUm
         u+jfnfiRDhsrS45I0JFHwKI/pDjybOwP6TOogX76dYy1PCgV3iFla+KI/rnx3luxDdAB
         sTKotoRxxGCfdNjBvb2QrH2BLNbwnDZd9Wb5X6Vg7xo2Oc8GhfnFzQyC9NLA52y4A60+
         dCfvgYNYiI8bHermL5SK8vcjoVQERxE0a8MuN9I5QB6QIkhu3OgqTF3dHwtDAqUq4DKH
         qk2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584826; x=1729189626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I+2gp5vLlKRJWMtv7YF+IvP9h9YjJXEpCIK4AMigCis=;
        b=J0UutHcBrAiL2+MqojhHkn8qgu7qTiIHdu77p4/bgdCZ6JXlc65o0vJf8lsTkA1zNl
         oYhc04Z0PMRN3hDjmn4Mu2M27ATs92cEKaD3LMX6Inw1qa3G5lGIAGwZgeDOT5Nsp2LZ
         QVH2x6LnLBg/zWvRvc38y2eNp+0wZnfNFx2FP9FwvpFOLMVxrv137mfGnttItTymELZw
         ghXTpGn1M2ghZOd1g68dPoc7pOVWD630Uzw/8a8ooOjfvXg46CkeU4+dcBnl/B6vw8a5
         5WW6kwKCCXNn8unThjkBoeIJk3QA7H/AkoRahNIGi/ycQMOZjc0QycSNjEyKi3MtX32S
         xXlw==
X-Forwarded-Encrypted: i=1; AJvYcCUryZ8Qd+zRo6hoXNgN73PINwpOaem5oJVqLXsEOccwPF5I3ahCLX+nwSpU1GsnABVK/4sy1Mw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvdwExy4TzVCfVEQrdeYJuMNP5HnR4pUEAuO9687wWfSjJKWP1
	ANmWHws4efcknTnD7fEjD21+wdj2Z6WIPY2KjWghMehNKzKjxMU8HqRVCZ4XhBXBygYFOu94EGr
	qVQ==
X-Google-Smtp-Source: AGHT+IEBzxfSdV5URAWtipQSxApJSdWqJAcjcFibIBQs32g4G2eVPMYjVJgo5zFwBPuTEySHq4oumcdrCOE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:e546:0:b0:684:6543:719 with SMTP id
 41be03b00d2f7-7ea535307afmr40a12.4.1728584825522; Thu, 10 Oct 2024 11:27:05
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:05 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-64-seanjc@google.com>
Subject: [PATCH v13 63/85] KVM: PPC: Book3S: Mark "struct page" pfns
 dirty/accessed after installing PTE
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

Mark pages/folios dirty/accessed after installing a PTE, and more
specifically after acquiring mmu_lock and checking for an mmu_notifier
invalidation.  Marking a page/folio dirty after it has been written back
can make some filesystems unhappy (backing KVM guests will such filesystem
files is uncommon, and the race is minuscule, hence the lack of complaints).
See the link below for details.

This will also allow converting Book3S to kvm_release_faultin_page(),
which requires that mmu_lock be held (for the aforementioned reason).

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_host.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_host.c b/arch/powerpc/kvm/book3s_64_mmu_host.c
index bc6a381b5346..d0e4f7bbdc3d 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_host.c
@@ -121,13 +121,10 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 
 	vpn = hpt_vpn(orig_pte->eaddr, map->host_vsid, MMU_SEGSIZE_256M);
 
-	kvm_set_pfn_accessed(pfn);
 	if (!orig_pte->may_write || !writable)
 		rflags |= PP_RXRX;
-	else {
+	else
 		mark_page_dirty(vcpu->kvm, gfn);
-		kvm_set_pfn_dirty(pfn);
-	}
 
 	if (!orig_pte->may_execute)
 		rflags |= HPTE_R_N;
@@ -202,8 +199,11 @@ int kvmppc_mmu_map_page(struct kvm_vcpu *vcpu, struct kvmppc_pte *orig_pte,
 	}
 
 out_unlock:
+	if (!orig_pte->may_write || !writable)
+		kvm_release_pfn_clean(pfn);
+	else
+		kvm_release_pfn_dirty(pfn);
 	spin_unlock(&kvm->mmu_lock);
-	kvm_release_pfn_clean(pfn);
 	if (cpte)
 		kvmppc_mmu_hpte_cache_free(cpte);
 
-- 
2.47.0.rc1.288.g06298d1525-goog

