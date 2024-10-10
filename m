Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40FF1F9A8A
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584749; cv=none; b=l/9lJAkuBcU9qlu9vuyIJW6T4/JcetOJI8sXIbIRvA9HcvAIlWwAe8jiorZPPGengJcu0iZq+NyuVAEm2YXTTV/JpAt6AsczWfYPLnyDqAH6f/wpyFT2FrjQ9LEomL1AziFiqCHeRsa2BpAxwUzQQrB38yALwaMOt+A2baE8rVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584749; c=relaxed/simple;
	bh=wQkcrwrrK4R8UDZylZK1jjbxKHOYfzFAR77NBuuXUsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G+vssBwMNzvTFAwA8dcRQZTJMGHu994MUUuNOk7zMOrDXwUQm89xRO9Ges+a9FTYJj91WBSV/RSoXwKoNvf4OIiOR5OsmyJKGWVhBM+W+fjy4e41oKtvH7qRoX+I+mCmABOGgBGSM4bsIjKXXgndG5qq6JuXa0RnolCNmRkdv9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r6nAiQqF; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r6nAiQqF"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e2ca4fb175so1247937a91.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584747; x=1729189547; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/W6JK9yAcorM7mqEFQq2hRBqvFCoz2C4pz3yOEmiGek=;
        b=r6nAiQqF1dfcpbk5Tv2MhWXzXx2eVWgP4BD336xnj3P7QsAnS9ktK1LRKdQxx2F/zd
         ms9c8rRcme0ud5cytxPG2+ydn+zv/sLabpIFDCswdknXUWb9MKpDhlKsZ6U4Xwc1UYDV
         TLVGQ4y6+XSc1e/Ck0+1y9S4NfpN/Wq7je7sT9L19RL0NDrn8kL9Q5Xi7gmVhzH5Jy0t
         N7PN4W9k/0uqdVqR5TrDCajD6vhgO9o7zbNlFOgHopbvWxCTY3D8/Q3Ig1O3GsZ2HjOs
         5ukIA03ypzqKFBJybotClI/WlWairVg0bJ9RlJy/L+B/EmYie4VFHjfjdAwZ15v9zoim
         YtAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584747; x=1729189547;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/W6JK9yAcorM7mqEFQq2hRBqvFCoz2C4pz3yOEmiGek=;
        b=ML28nqU3wIkKzef+Y7KarWEX26LBA4RjpGASeOaNVacFGVPDSVClJTcsaUfl1bcPE+
         lyVf1v+urDcqVSSx5ppU+vgpB0Q6+KBMOktCU4NluDC0PkDHsUwiNIduTstcHwJAV/bP
         qTdkq5Z34tTG2k5Rg3OZ5Zkr1v5W2Bidw1f+niZRxGMi29tum9mFhUAxrsJTxUOCf+Vu
         omUezDW/OqxNHnBgkO5yJPIzwsoZQrPUeGP0gx0zYUJ6c3QPbUu+1OHU5pE2I0e382da
         nOiQcXFc32bhciva05vZxjSTygcqIuUHfamnI5uCaPRmvkZSRQ6ciTLwtzTel60kCncl
         mUOg==
X-Forwarded-Encrypted: i=1; AJvYcCVMhh0ZyMyTV5Q5fjc3hGEt/k5N+nF/VADgDclEPRA2ukXfibrdQcEm1gHZ4YkXYEs7KG626bQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhO9Eg/FtFjIYGvqhpyqfr9hdafKyVP23furiFOQNoEUJ0lXr1
	U7vZhOJ5I53XXvCBkDzVmEGO0flioEs3Zt34adyOknWRbY0nrfalw3inE5QLICY2i6l/sJKD8s7
	W9w==
X-Google-Smtp-Source: AGHT+IFGWHaFUEsQRxn4rcRWabj8vzxqpLHdNOXqOmiiQlX4dD6MZqF5BpShV2hVfQIOX/PTyNMVtEMSya8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9a94:b0:2e2:da81:40c1 with SMTP id
 98e67ed59e1d1-2e2f09f2280mr109a91.1.1728584746508; Thu, 10 Oct 2024 11:25:46
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:28 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-27-seanjc@google.com>
Subject: [PATCH v13 26/85] KVM: Use plain "struct page" pointer instead of
 single-entry array
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

Use a single pointer instead of a single-entry array for the struct page
pointer in hva_to_pfn_fast().  Using an array makes the code unnecessarily
annoying to read and update.

No functional change intended.

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7acb1a8af2e4..d3e48fcc4fb0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2752,7 +2752,7 @@ unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcp=
u *vcpu, gfn_t gfn, bool *w
  */
 static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
 {
-	struct page *page[1];
+	struct page *page;
=20
 	/*
 	 * Fast pin a writable pfn only if it is a write fault request
@@ -2762,8 +2762,8 @@ static bool hva_to_pfn_fast(struct kvm_follow_pfn *kf=
p, kvm_pfn_t *pfn)
 	if (!((kfp->flags & FOLL_WRITE) || kfp->map_writable))
 		return false;
=20
-	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, page)) {
-		*pfn =3D page_to_pfn(page[0]);
+	if (get_user_page_fast_only(kfp->hva, FOLL_WRITE, &page)) {
+		*pfn =3D page_to_pfn(page);
 		if (kfp->map_writable)
 			*kfp->map_writable =3D true;
 		return true;
--=20
2.47.0.rc1.288.g06298d1525-goog

