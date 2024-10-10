Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F097520823C
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584817; cv=none; b=FLeu8opNbbGgSm0M0v7dcuKgxywplfI9zSg6u6SLu8TbW6PaRmfef+vPGfDzvPNboR7fXw0sX9/tZ8GhExcOYwRxKKG54vcGVuWgWcNeBXa3QbpxLuOLEM+Ch8EpAzw6C5MzAIPYUJS0YqBreiThDc5ILluIY3X+8NjsDR3y/R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584817; c=relaxed/simple;
	bh=tUWxw/XFi5Jjw4MLGoQx4yzkrGK2c3j8OG0Ux9/pXvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oE+0VSTOa7K758VRLV2wJ2EdsTTSk7FXsn63kvfe6vqSic4DxgNTNsDArZvT4rSykifIzzawGM/ru7sYmfcsorYoNlCIs9CcpeqTe5o8yG5Jf7bCMsondaPikMV7+akqheq5A0D+EPQgpIdLGHYkkZvj+V7qbsdMEZ0MxMIqyJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xno7LoFA; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xno7LoFA"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e1fbe2a6b1so23290187b3.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584814; x=1729189614; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9PLNR7J7/StxhsadOj2FvapRbIqIfrDfQ6nFmhEUvk8=;
        b=Xno7LoFAh3nM4XUMx7Ta9TmdfZf0rO+kbt4WvFQD7HTO3ReKHI62l53hFFy8NuGWFs
         VEWZTy47S4+gKeWu9H7R+d7f1wNn1K5DtrsOfW1I+KEXVml+2j/gPuARUHYK9ImqC6oc
         hkBU8m09PesYvGJnto/SdYEw+pAvs/QJXjlcoKcZ08IHaXtsZdGfRWiDn9XRTW37qJEN
         Gz2Addar7TXCeE8w4exFdkbhtrxT0ZPlaYPgpx1j+LtsNpVhtn2kVmfN3u+NKxtwarxM
         akU7Dab4i1kqK04ZlEYCQFzbhVk2R32uIOoeuKi8nK3zm9GuXjsylDNseKPU8ggh0Dnd
         J8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584814; x=1729189614;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9PLNR7J7/StxhsadOj2FvapRbIqIfrDfQ6nFmhEUvk8=;
        b=DTK+kIjivYVoS2tAzhN6tMQ2oCiOKmNqA9dG2PwSWob+IxgJVx55LwMtuyRJFAs/tC
         u58mRHd8VkLxZhDp3pSVHntI5DbhSsgxboUh5KnNsKZEQQl9Ik3m2QdtxcU4ykr1o4eP
         D4W72ZUk2p45Ab3N46MvAjtEy5Bvtbtv7QlEREbyJVdTlO3GW7AGCo0B+w/XuiTqZKtH
         AG4wCta4CP4ZphUPRK31ch7wBnZsfKyGlnfBiKvawazCnzDkDbHIbuvEietgJkhVI9PB
         qkVHF6lY2E2p0huzm8vAJvKyyGDuzGA2Cw9zOd/3P/ENXNS6PahXtrGuG1DvAXEeo+2P
         7qIA==
X-Forwarded-Encrypted: i=1; AJvYcCUpZA7DuZEPIAvzsPrMkbJ3NJNMCYA71hBsuJCu4Ewy2NBEa/gAE190H450pWV/xQBRCQVFeD4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8Vfj+kilIeq3buhnZhDcsaxvbbw1V49DyXEOwtzv+ereX1HQ6
	/9x4I5OO/WLy/iYMii5EPf3sBaVMHBNTb/+Ft0AX+XPi4oDta5FG1zjBJADE1OnzytaEL75t/8F
	9lw==
X-Google-Smtp-Source: AGHT+IFTz5/NgoL1lG2XSkf5pquU6CJl4M8l3x57mh4U7FbzzS84rW+oHIk+OXb87gKu92fZB4cgNqwOitE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:46c3:b0:6e3:21cf:a67f with SMTP id
 00721157ae682-6e32242fb5emr1006557b3.7.1728584814138; Thu, 10 Oct 2024
 11:26:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:59 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-58-seanjc@google.com>
Subject: [PATCH v13 57/85] KVM: RISC-V: Mark "struct page" pfns dirty iff a
 stage-2 PTE is installed
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

Don't mark pages dirty if KVM bails from the page fault handler without
installing a stage-2 mapping, i.e. if the page is guaranteed to not be
written by the guest.

In addition to being a (very) minor fix, this paves the way for converting
RISC-V to use kvm_release_faultin_page().

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Acked-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/riscv/kvm/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index b63650f9b966..06aa5a0d056d 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -669,7 +669,6 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		goto out_unlock;
 
 	if (writable) {
-		kvm_set_pfn_dirty(hfn);
 		mark_page_dirty(kvm, gfn);
 		ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
 				      vma_pagesize, false, true);
@@ -682,6 +681,9 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 		kvm_err("Failed to map in G-stage\n");
 
 out_unlock:
+	if ((!ret || ret == -EEXIST) && writable)
+		kvm_set_pfn_dirty(hfn);
+
 	spin_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(hfn);
 	kvm_release_pfn_clean(hfn);
-- 
2.47.0.rc1.288.g06298d1525-goog

