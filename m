Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE6A28312E
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 00:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661190; cv=none; b=BKjhU6JojPcAQL2c7BwY4gEOXaCxUTMwc9lT+t6HAvMdzBcokWbk7BL/rl0MZAAIDCKEW60PbqykEOMffn8GXUl0dWZFsYx9ytormrYtsrBI7pKRRDJV/rWmyvFZy9XrIDBOUpl0CxdZd9clQkKf2i16DnLt1S0Vu+uP776ONY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661190; c=relaxed/simple;
	bh=wYAEXPYHa2xMErFCIfNovZ590pxCtOKCG7ZgmLDnGp4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wb/y5LH8b3Q7MGEK2ZGI4cEM568YpReqX+74VpuLgdXksmNtk+75Oe/Z2GMgHhLWInbUCvX+M9j3UeYRM25yRCXB6ODpDmstJBHYwAQ7hcqqf9MCmWhvbPG8h3ujrteaVfyTrI3vsSrLoXXMfY5d8eCyMMJlV1r4MER2+jp1rOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e5vFgEJR; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e5vFgEJR"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339b704e2e3so1368351a91.2
        for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 17:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661188; x=1761265988; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ylyqozer80U4wIAhCrbCm8kORDI60jP8QTvjhJUGpZY=;
        b=e5vFgEJRY5JMf9yreZ7TncZrC3CxhDEu9K6rhT8CuEp8dNqG0bMw9C2YZVtPeZEugl
         fxKFJKiOMpJXZGYTaLSHF3eECi+ihRSpp1vlEonkoAapQnEAM2UGz71V+P3beY6NarAH
         e4fBstMoAfudCr+z35w5qtZLxDjkynw8kGEtyJEfZsQ0buS8eDQ1D6OnLowg0SF+/6ze
         N3NjUcKZg4+Xi4V1mBzu6+1giBbIFUjgTtYfv1jWB27wkK0m5uXJA16GBqhRu0NRrhC6
         +9W21UwXDCpA9wZ8pmw2BL/hTuconI2Y9f1Y2u/6culzyVPiABvLRxL/jKae40FAX7wF
         93Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661188; x=1761265988;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ylyqozer80U4wIAhCrbCm8kORDI60jP8QTvjhJUGpZY=;
        b=Wjfp6CZeW8ayT2BHth9qScGpfZMh2ta76X+51KGgurjDp1wut7l9PVLyWjPsnIUEek
         ENCb/3BswrhQWwWgtYyYuaOHd5+cj6afIPEHlAGSEDhkos4zC7x+2MYAamJGubnoHA0N
         sWaIFeZdFMiJUJteEpY6Nd3BG5RH3fK0rxuJ7nQeBqqrOlDpBSntiehw3YB75yLEYNFr
         1wrc4qDm6Kg4dj/s2nazc9UkQ1WDCEe6j2Jk/qjZtqMqeKaLzC/cr0RdLasl+zQJqFip
         GeQb0MwONgALXLVIefNBW1C+sVe7va/N/UD0MVIfmqkzgtmYBBohQMaPNgvApCTx9z1e
         vigw==
X-Forwarded-Encrypted: i=1; AJvYcCX4BQLBsjlhzggTutwb/oyOwnQ5DThZqGcxnZxYh+AGp4Pch30EYhrD9uH+46+YtEgBe+f6fSw=@lists.linux.dev
X-Gm-Message-State: AOJu0YybQX5590knIXVeBkboR5HrJ7AhmU/yrw0NJPp1S4twKFk3KMNn
	99iTbmMOFOt3LkHp46sv1fklXTiIffrIZyT4Yt0AVhMe/ZyBPaG+WSv39frHX71NCfJzmft2Nhc
	+aTyp+w==
X-Google-Smtp-Source: AGHT+IFv5wQBYU08VlWSJ3YEyBvWx6CUl5P/6vzeOVA3OyqdlNjTdwYkeUoBdZlGjRBJoj7p6GD6I+E30lo=
X-Received: from pjbnc11.prod.google.com ([2002:a17:90b:37cb:b0:33b:caf7:2442])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f8c:b0:32b:a2b9:b200
 with SMTP id 98e67ed59e1d1-33bcf87ab38mr1930441a91.13.1760661187797; Thu, 16
 Oct 2025 17:33:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:29 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-12-seanjc@google.com>
Subject: [PATCH v3 11/25] KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte()
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Return -EIO immediately from tdx_sept_zap_private_spte() if the number of
to-be-added pages underflows, so that the following "KVM_BUG_ON(err, kvm)"
isn't also triggered.  Isolating the check from the "is premap error"
if-statement will also allow adding a lockdep assertion that premap errors
are encountered if and only if slots_lock is held.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f5cbcbf4e663..220989a1e085 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1721,8 +1721,10 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 		tdx_no_vcpus_enter_stop(kvm);
 	}
-	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
-	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
+	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
+		if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
+			return -EIO;
+
 		atomic64_dec(&kvm_tdx->nr_premapped);
 		return 0;
 	}
-- 
2.51.0.858.gf9c4a03a3a-goog

