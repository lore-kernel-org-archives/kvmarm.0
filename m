Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B147A180A92
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038038; cv=none; b=XFlr+7dgjnxpKWPAdotecad5wEjeylhSsZOJyic/r/CV4wGMraGTmApa7WnkxT07WCx1AIswtxU+3QTvCPWeHxtkFDduv7/LCtiglsL6z+UsmgVi4eiOQvPiqvXtYXJYtPTi8nDypud7XbyKHK4rBrDJSAQ3ShVb7h0fyOv4yBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038038; c=relaxed/simple;
	bh=LBKPMXijjb0wTzjBJsxSrtcd3ZT6pYGX5pSqb6D2ibs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MeYGiMP/Bfx08ZLRC6oIaV4ttnlTBoTLkDFvNkvQ1iczMkvQH2+0qOUE8QwVT+wgJiAfZhBYdSdl27pi+gvnUMorWA5eQ14353XFXvjK6tdgyfEwaWwl9ISjL44Zk/GntCP4/c9buDekkBqhoZ0/9ZfQYhhAlKWo4P8G9qIthvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UB1O/+L4; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UB1O/+L4"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a242496838so1280386a12.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038036; x=1722642836; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=G6XdYYnK6SmaIVsSbjLWLiXTD6vQEkdodh0PTaLJXbU=;
        b=UB1O/+L4NgNY3eLEpC9iZycrVEZjnKXtGoqCuTs1tFzSxMKdGzUCVPSjPG6Ug9qgbj
         fO2SFCRVa3XtS7asCw8UH0+5hHgP6zDlzO+GX/WmHjNJtkeKVGKY+acYefQx9gYAbbva
         zR3eCF92zb5O7SUCxTnxcXl4EXPVxRjUTbyKTELVqNCfBFQ3Ipj3qQPHckxdzoCVDKUv
         ecAtBm/ajrJM5aUPLO9FLXAno69arXbrSvNi8+zcUO9RX6pLHVf8JYccbK3681wdKi/Z
         +LtumVo2CSXvESHXQ0RfT14pkmeAgs0Uw/cbl97ZwdNcFx6R9/RExjkIu98rX36RE8bc
         l5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038036; x=1722642836;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G6XdYYnK6SmaIVsSbjLWLiXTD6vQEkdodh0PTaLJXbU=;
        b=GyrZkqUeU97AX2+J0hsN7lxOjJTuCjNX6RRCjQOdKPx1MnyOeNlZXrPIR+0TBX8jrp
         XUN2vQkfdIVo+wq83O2aVD7l4akIXsObqVgx6HthA/GMsyfLz61IAz3CPl45O1ZLKP6I
         EesMyd40CocjFBwWPc2DqGppKHnlgWeKnFahtF9TSA4NuxRwNbOthxvrZwhXh5TCW4vs
         CaQ91EeBHXcaGtQmPDbZe9YukTAntyHzpOFQ1QLbrJbgPZKvEXvLTDZj0KJqMp3vVvUV
         xX+7krnKwi6BjZYP/y1vu2pruZmCjVMuDy3UwrPMQXR1zZsXkvHQQGBVAu0D72X/VDlv
         CwYg==
X-Forwarded-Encrypted: i=1; AJvYcCUXhz/YFuMFXp4+Vavyl4M3S5hsIopoNGToU07e5JuXxSMJJG07dy65FcBe+n75/HTXTpOQtKGQiSVyG0QIhmRWiBKWTUos
X-Gm-Message-State: AOJu0YymFk9wBWTV5e+VEvPyPnEiccpyfdxZTYFMSIU51uPXdJ+qN8YX
	nNWSGqsgbjJAydEb54oSnvhvHGQyv8wEwQH4GFJZHenRfLbpDVTt8A7cgq+PEcJhcp+zCQh5gAL
	xsg==
X-Google-Smtp-Source: AGHT+IFqcJX/9FY6hmZYd8EnC/sSURY7mS/rFneQMUHDSr3ovaE0Tb6dbx+RwJc5DGDg7FZUxHqlUK5Q8cY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c945:b0:1fc:733d:8465 with SMTP id
 d9443c01a7336-1ff0488cadamr598725ad.8.1722038035986; Fri, 26 Jul 2024
 16:53:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:47 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-39-seanjc@google.com>
Subject: [PATCH v12 38/84] KVM: x86/mmu: Put direct prefetched pages via kvm_release_page_clean()
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

Use kvm_release_page_clean() to put prefeteched pages instead of calling
put_page() directly.  This will allow de-duplicating the prefetch code
between indirect and direct MMUs.

Note, there's a small functional change as kvm_release_page_clean() marks
the page/folio as accessed.  While it's not strictly guaranteed that the
guest will access the page, KVM won't intercept guest accesses, i.e. won't
mark the page accessed if it _is_ accessed by the guest (unless A/D bits
are disabled, but running without A/D bits is effectively limited to
pre-HSW Intel CPUs).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4d30920f653d..0def1444c01c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2919,7 +2919,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 	for (i = 0; i < ret; i++, gfn++, start++) {
 		mmu_set_spte(vcpu, slot, start, access, gfn,
 			     page_to_pfn(pages[i]), NULL);
-		put_page(pages[i]);
+		kvm_release_page_clean(pages[i]);
 	}
 
 	return 0;
-- 
2.46.0.rc1.232.g9752f9e123-goog

