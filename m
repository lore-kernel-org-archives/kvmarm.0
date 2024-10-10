Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD7C216432
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584853; cv=none; b=MnGqhEXdnHnx3rL4d5p3YgOy4elwU6gyXGMP5DEv66+f3yZqypE/5gAJ1bQmEexrF8qr4sCuDZt3en7rjGZqSj639KqFKvwkOKnWrD9k0EufDtWd+k6PkOWufC5/7z5vPJslGOwL52a059wAGloxbUJgmMIqtOI8n9/gYO10VV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584853; c=relaxed/simple;
	bh=69Upu5+wnipQK1zG8Arq0ad1gowf7mjUzNjaillb+fY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LECeGv0sKsIg/0K9Fm6hh2zpcB3uGirFekE7VHUq/K1Gxoz62hCfGb49DzhCI+sqzjzcbZrVlyFBKZhEgvE+psDT+zJSQjISiD/zL8ZSGReaFsxDVa4jd0MLn99Fu9jCxCPdp8++n6zLjyeIb7tP7lhHEGAGqaZ9adP24kEhEro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JOIzmuyH; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JOIzmuyH"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e32e920cf6so23672807b3.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584850; x=1729189650; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DOlbrv8SiXT4cHz79KGvl4RMUSE/a2Kzzqa4ZWuWNYk=;
        b=JOIzmuyH6pU7Rfh9Z2hOZCQpbw7puZaQ7lZ97xrSbZfZtv9CIACFspuFOH3CbnUZCH
         B6Ef9MI06eW8gTa9OaNucOJGLIiBl97ZxYan2cdAEgEC9JrlOMgq68AW7tCaPJ5aabEH
         IddbJG+yiBYYo4eMH+BeLfjZgxhVDQcLFuVJjb7lZJNzx53Ctg5vfyNvOB/kEtI4SOqO
         Jc5WgcCTD+evSrOM9VGBmUA+O8Det+uffZi5QbYF7RtoVXy0hQ5Dqaxqe92VaafUxyEB
         7fXGN62QTSuOQpvkJ8L32GfEGOBEefNYvdGPo2cV6LzkV5ll8MqEb30z6+N0Ezf2eckK
         SZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584850; x=1729189650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DOlbrv8SiXT4cHz79KGvl4RMUSE/a2Kzzqa4ZWuWNYk=;
        b=t2GSpf4zYG/y7dzn4XaBIEtVRZ3XCfNxHdTq6UylHhzztm4P1Lt0YtT7LRWbTruUhO
         xlH6WT2KbqkpTe17m7PA2P60mQXP4q+wpSq4ljF7mXYISdXIJTBvp5gysuSJCoX7Abvv
         ThYCF1CiGFToODAs6pazjyFjz9ipIWNnVVbti+QEN9oHci5JX4pWQwoNbaa2zZINJ8C7
         Q8D6Lh+CYRXjX206I1+HL8UNRYxFbnuIU7KegqvcCPEuOF5io/er4CUG9UMODw7IKP8I
         v3BmP3XzSxxuMNioJ33jVW+kvrPPiVaqLUmibc/RYI+5zu7R5GNg97A2wc9GkJ4quc6z
         lR/g==
X-Forwarded-Encrypted: i=1; AJvYcCVFtJhm1zmgIgbWeAI0zN0SLTWlCQdLD/pfvwarMFdEr8WPk/pqU5bAas97ZgNNRDGyyO6hhNo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7epm8U9C2/ULm34HavdilK0rPjGYSJgPBJswxNARvwbESrppr
	CZoa6TmrvBAPYxA6jQO7fCisgTdpuwiLpUFXLzCinETALYGrYGPVQdcZYvL1avH7v0CW2AeBgSF
	lAA==
X-Google-Smtp-Source: AGHT+IFYivPtvbNeJBK5QJ/MFgPKbd4XQ4GDAEMeTnfD7MuZnOh5ZwxKPEpX2RNQ0xKTZSwXcPzTQuagswA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a0d:f043:0:b0:6db:c6eb:bae9 with SMTP id
 00721157ae682-6e3220dbc31mr798327b3.2.1728584849896; Thu, 10 Oct 2024
 11:27:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:16 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-75-seanjc@google.com>
Subject: [PATCH v13 74/85] KVM: PPC: Use kvm_vcpu_map() to map guest memory to
 patch dcbz instructions
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

Use kvm_vcpu_map() when patching dcbz in guest memory, as a regular GUP
isn't technically sufficient when writing to data in the target pages.
As per Documentation/core-api/pin_user_pages.rst:

      Correct (uses FOLL_PIN calls):
          pin_user_pages()
          write to the data within the pages
          unpin_user_pages()

      INCORRECT (uses FOLL_GET calls):
          get_user_pages()
          write to the data within the pages
          put_page()

As a happy bonus, using kvm_vcpu_{,un}map() takes care of creating a
mapping and marking the page dirty.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_pr.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index cd7ab6d85090..83bcdc80ce51 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -639,28 +639,27 @@ static void kvmppc_set_pvr_pr(struct kvm_vcpu *vcpu, u32 pvr)
  */
 static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, struct kvmppc_pte *pte)
 {
-	struct page *hpage;
+	struct kvm_host_map map;
 	u64 hpage_offset;
 	u32 *page;
-	int i;
+	int i, r;
 
-	hpage = gfn_to_page(vcpu->kvm, pte->raddr >> PAGE_SHIFT);
-	if (!hpage)
+	r = kvm_vcpu_map(vcpu, pte->raddr >> PAGE_SHIFT, &map);
+	if (r)
 		return;
 
 	hpage_offset = pte->raddr & ~PAGE_MASK;
 	hpage_offset &= ~0xFFFULL;
 	hpage_offset /= 4;
 
-	page = kmap_atomic(hpage);
+	page = map.hva;
 
 	/* patch dcbz into reserved instruction, so we trap */
 	for (i=hpage_offset; i < hpage_offset + (HW_PAGE_SIZE / 4); i++)
 		if ((be32_to_cpu(page[i]) & 0xff0007ff) == INS_DCBZ)
 			page[i] &= cpu_to_be32(0xfffffff7);
 
-	kunmap_atomic(page);
-	put_page(hpage);
+	kvm_vcpu_unmap(vcpu, &map);
 }
 
 static bool kvmppc_visible_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
-- 
2.47.0.rc1.288.g06298d1525-goog

