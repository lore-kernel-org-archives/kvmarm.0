Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB4D207A3D
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584812; cv=none; b=QboIxaFrh9Y/aYTe+OhyFzbwfTHyTcRcYFAq3l1rlK0WtSNwHHInTJCsrBAqclZKxqq+X994fZKW7vOQ1phK5D+cp9tV7Gn0G7qwvgH5kbsYf9fPmS/GnaqFbkWSY1IA+OYJgHU0yQO8sFivN7ZKZneiUViY+QSxm335/V62Gsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584812; c=relaxed/simple;
	bh=lNDyXtKPmFS6sOILzqWSFd9L+nyXpdsd6JebnDHI5l8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lNVa+UG+95SR8Yx146PwdYufAjPRfhWvR/1/FeX6ZAoCxQ221uZea//b9LdRuCFy9FlKcMRsQTPaOmTEsidyyhVJg1wASpN0OXUUHI4t67t5iaYn/zz2D2pV+1dUZVemauGsiGCOs16XFixP28rI0e7fV+SZswSkhFdrLPYRI5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rwd405cM; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rwd405cM"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e019ab268so1589448b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584810; x=1729189610; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=K6YUqJX41UvLftiTjNafBx3/10X+6KBTIzQjXduU2xw=;
        b=rwd405cMilBheZ8xXAXWIA4NjSNO6NY276UCp2DNefq3Ih/6v7DLwXwm5I9UUzRHkA
         aEL9YL4nmTjPQiAkm3i5agREp6mWFg5VhYBCh1T/lytpNiDSAvZrt48421gus8J5gIWw
         Suqi8+ag8d6/pVdwdzqyQv2UXB3lx/r3Bps0zmvUSn/ulLvUt1LeRyWowYqBR/ZeMnkC
         d13+qPAMNnWJO6JEQYBeYfwEQ5yJMqS2jgkcv9hLP/2Pt3g1gPNq7ULbQf1NiDet9l+7
         tiXv4lnu9dAFWsglcwdoFONVnqyhcm0M6RTMeW1Yxs3lY/DTxKXmQ4e56gnNXRedA0gs
         rMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584810; x=1729189610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K6YUqJX41UvLftiTjNafBx3/10X+6KBTIzQjXduU2xw=;
        b=rVh1n70L3bfPkdz50E8ogB5x/KfPMbNNaAYdIQ9/V5NHxkEcxAtBYWclKdnANplWkH
         FNRRfkBFUEZBJoAB3TlXgpOs0g/KesKe8CXXdZNYjh+pGmzLyp+BnWzATONBmYzDqrwu
         RoTClFVWpvuViQtnklzh5hduU306dO1NKGs7SlhfhMYaBAGDEbhbVY67LMu386psCe8S
         4sFowZRiA0J1bT49uW/YFKspwiL/1DsFTyB2GgQIpTQ8yqKpN9nUP2De3Tb4GOFaabki
         KJDpxoZ8NITkIiv7idSdDp55hAwDUNSEvWBrprCUkmmkeMe7hK71+OvsUSeR2omILVM/
         oxng==
X-Forwarded-Encrypted: i=1; AJvYcCXAQblPufIyM8gWpKprEc1HwKGtGH4gLHaGj2CBsOCL8nPOSeg4jh4PFEF7sl2H8ZodnwrI8hE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4FxHMo8Nm6a9hHWMD8wglGX56ulZ47qxeF7sEizJ8gWl+zQVP
	sqFHcCwZDc8dP/xMbtYmiZofSpQTIhTW5TQ1vxUjFCJwqTZlh5kL8rdEXxqXRXIpxqmInHagtTH
	gvQ==
X-Google-Smtp-Source: AGHT+IEO1ECBC98fGvB+GRqYHAQaBdxJcqvY9DmP3QI4gZm0KdOyij1fLmFl0bPXgfvra8JJdQe8JNFxBHM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:9199:b0:71e:1e8:e337 with SMTP id
 d2e1a72fcca58-71e1dbe467fmr8496b3a.4.1728584809106; Thu, 10 Oct 2024 11:26:49
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:57 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-56-seanjc@google.com>
Subject: [PATCH v13 55/85] KVM: arm64: Mark "struct page" pfns accessed/dirty
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

Mark pages/folios accessed+dirty prior to dropping mmu_lock, as marking a
page/folio dirty after it has been written back can make some filesystems
unhappy (backing KVM guests will such filesystem files is uncommon, and
the race is minuscule, hence the lack of complaints).

While scary sounding, practically speaking the worst case scenario is that
KVM would trigger this WARN in filemap_unaccount_folio():

        /*
         * At this point folio must be either written or cleaned by
         * truncate.  Dirty folio here signals a bug and loss of
         * unwritten data - on ordinary filesystems.
         *
         * But it's harmless on in-memory filesystems like tmpfs; and can
         * occur when a driver which did get_user_pages() sets page dirty
         * before putting it, while the inode is being finally evicted.
         *
         * Below fixes dirty accounting after removing the folio entirely
         * but leaves the dirty flag set: it has no effect for truncated
         * folio and anyway will be cleared before returning folio to
         * buddy allocator.
         */
        if (WARN_ON_ONCE(folio_test_dirty(folio) &&
                         mapping_can_writeback(mapping)))
                folio_account_cleaned(folio, inode_to_wb(mapping->host));

KVM won't actually write memory because the stage-2 mappings are protected
by the mmu_notifier, i.e. there is no risk of loss of data, even if the
VM were backed by memory that needs writeback.

See the link below for additional details.

This will also allow converting arm64 to kvm_release_faultin_page(), which
requires that mmu_lock be held (for the aforementioned reason).

Link: https://lore.kernel.org/all/cover.1683044162.git.lstoakes@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index dd221587fcca..ecc6c2b56c43 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1692,15 +1692,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
+	if (writable && !ret)
+		kvm_release_pfn_dirty(pfn);
+	else
+		kvm_release_pfn_clean(pfn);
+
 	read_unlock(&kvm->mmu_lock);
 
 	/* Mark the page dirty only if the fault is handled successfully */
-	if (writable && !ret) {
-		kvm_set_pfn_dirty(pfn);
+	if (writable && !ret)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
-	}
 
-	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
 }
 
-- 
2.47.0.rc1.288.g06298d1525-goog

