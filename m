Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA13414F118
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037962; cv=none; b=J/p+k4lL5/02KQb/oGPDGCTtSots+A5IuHaocSmQbGOV202rx4ma12iCjWteqa8FHarhx+bacaneY2BA2m5sFQQy4szlnun0T3D7hU1Upl/WWopkHGCEveEOWH4vq/zW3XjLbYegV3ooyZnLJ5znhkmeylCraBK4nJFdB2VONTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037962; c=relaxed/simple;
	bh=24lki3QCeS0kH+gNN4dUIYpp1e6lnIRlAVL0zCm0YAQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lY+l24ty+ri/n2npPts7mm2EldRhyQU17mbPeqY2sDUngIrOYARXwGTOzmZlIoxpcPo/DvGDficSBUlexRQdzx+giesOnn6NcjIRwU26+h1yc5A6d3aZRb01Ex4WtXu/WR4jrB4lKW58gT5KkFaEltWbjpqmy1GuUL0YncWpwqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DQ2wIosC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DQ2wIosC"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc658a161bso8410515ad.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037960; x=1722642760; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B44llYCZd4EZ9BiHApjJ5QQ8CK6GbkfpTxw4rYmbmqk=;
        b=DQ2wIosCtjWr3MSBrMh63dKyCKJSAHwvBVaUuLV03dEEoDYkCGjpSoELgW0bWQK/ap
         jsIVnlbu/TPQ/PQ+7mkrxQ47x1E1olnt0/gwshwAPijdME4c6b6ptZjzuZ3ahzneyY7A
         e4C94qYPvIfXpvNHFdDGN0/woYne4Xr6N/tusOJ6W9cweWcY2ZWahRDo9m1JNrSCAtj7
         d5Su3EzQ2ksv8m5x0xJSp/dF4UK/AjsSJe2jYi3MTEfTVmxfg4iLoUkPLJLQtkpSeSu/
         AY4EAlRwcEfMxVBHZupmAS7ugGIHbYqFFtVKIXyrJUcM3EhQZLwg5Effwg+XiCrq2S2f
         /jvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037960; x=1722642760;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B44llYCZd4EZ9BiHApjJ5QQ8CK6GbkfpTxw4rYmbmqk=;
        b=tnwGtM5H22BdxSkBxcGFpbft2YOdBU4HjhvB9o3nTbhEsVF8w9JnT9lW0bOrBnkd8d
         dZ37E3e7g8dXjQyH9apGcnb4SG8QiYKalfPgcaKM7E1vx/rJs2oVjLfY7zN2TSr3ZHB0
         z4frpNzTUXefWMNp+J7g6QwT4Okjp/Qcdd/Kn3wuSIFGEbKeCOvhI6MEifYDPmoxKDBA
         H4wL1BXjWYRyiUyeh3mTGWFoEROR26eVUSvDQeZ89FIKasUuRMPreuJ/nRrK+a29wsS2
         ZffL/O7+Vl0ZYV15J6S8i6WSyuNH6KECLPgwqqs0kohSD1dT0iKWh6WC3QIgPqePLMEB
         6/iQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTEalFdnqlvaO+NyxpvHlmHm7RfsfjipPl3+YRvTPXSxUktD1FKS5S52i3oSzzGSMm27sVq+7e2Ddbiw+Qr/ZlT36ioVHW
X-Gm-Message-State: AOJu0YyV3shVmUsvY5vtd8/FDH3fvY617pIZwvxqQMHSCj38V9otwJEF
	3JIeqrR/awR8ijhwB0Jw+30fHyZGq1W37ILo3dtlQEiC5kA8AGUncGXlBkf6x2OvvxZeKnamtvn
	/jA==
X-Google-Smtp-Source: AGHT+IEjG0ZQEVlDvyCmqtjyibvaIBPxkBHQDdDjj94pZYYC/xb/lJ2iSbTktb4rvu/gOGNYLlpIc1q2Vcw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2b0e:b0:1fd:7097:af5c with SMTP id
 d9443c01a7336-1ff048d8505mr410065ad.11.1722037959655; Fri, 26 Jul 2024
 16:52:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:10 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-2-seanjc@google.com>
Subject: [PATCH v12 01/84] KVM: arm64: Release pfn, i.e. put page, if copying
 MTE tags hits ZONE_DEVICE
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
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Put the page reference acquired by gfn_to_pfn_prot() if
kvm_vm_ioctl_mte_copy_tags() runs into ZONE_DEVICE memory.  KVM's less-
than-stellar heuristics for dealing with pfn-mapped memory means that KVM
can get a page reference to ZONE_DEVICE memory.

Fixes: f0376edb1ddc ("KVM: arm64: Add ioctl to fetch/store tags in a guest")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/guest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 11098eb7eb44..e1f0ff08836a 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1059,6 +1059,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 		page = pfn_to_online_page(pfn);
 		if (!page) {
 			/* Reject ZONE_DEVICE memory */
+			kvm_release_pfn_clean(pfn);
 			ret = -EFAULT;
 			goto out;
 		}
-- 
2.46.0.rc1.232.g9752f9e123-goog

