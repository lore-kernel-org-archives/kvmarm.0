Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C522E1F8F1B
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584745; cv=none; b=TdMDMPtkXbDBahR6zez13qmKhmrWc66cwbGWi+8Am/vMvfr6YJH00A23Giyc2GEyBKMz7ed75Sv0UDvv6N+3yNaQ2rc8f5KWi0Ngne3IzX9WJlNkD7SjVsbm5HbQAHXaqVT2o/X5U+xL/YIEtjkYygoDEafYAq2K33r1hARS/3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584745; c=relaxed/simple;
	bh=QVyL+E+J2Fu+8nHNQtozyIIO+ywn/WvnTCVSYx092RU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n+JFqhZa9hUc43g5KnXDLRtNby31r7NrKB7Hl4A4WtQgSiXewYhBU90NaxrwhAMvSmbv1WbRlhZSKzuTDcUx2U3OjJF8k2pgDH0CWAgfq9QWQLX2D4aLixWOpV+uP/SUQm9Xt5kE/IvfPUujJJl7G/WCXdOLTSJ+Wf+op/sCiRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f1NW+ObY; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f1NW+ObY"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e25b39871fso27043617b3.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584743; x=1729189543; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eHAZpPaCzYnE+TRrbh6ni4wh+Yys2pChavpSnHk2YEU=;
        b=f1NW+ObY9HQUeFikUyHMScVJb5q5N4Q+JBmAPsX52TfNRr4E7GAx12gemrszQ3JAOK
         O3IQzntsN0sf2LArlaLt25F0jQuJMK0Kr95UJbAihvJ8f6LhArZLFH5nlIHL+ngp6Om2
         h12VxuE6B11MOxu0EfjlYVNqtFOgtJdFOLWa7F+wfP4xfmyOpBQg8gc4lW21xmbxAZRx
         PimkBmug8wRi6zItJCWiBtULPuS64adc72OKFfvqXR3kFjyI7CcyCIIAkzBui9+5r9eC
         MCG9Lmi6spO2g6geiAJHTfLqco5nfdqZ4MgYG8TwlGYMNEyu1F7zeKqJWvdlHyOJIaDj
         3EpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584743; x=1729189543;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eHAZpPaCzYnE+TRrbh6ni4wh+Yys2pChavpSnHk2YEU=;
        b=NVWPqBN7nw4BQ6natgV4af2gW0yDTjgbNW/fdRShVJ8HP2+1IypOuaTwZo1DgQEKgt
         jwyW0B6GsEuSBNhJtpdTkLbznc5PbDB+dtv0AlTelTTCQrG5Xwxs1GHMUZCYsu2vQvrf
         BN5GiIJg7t1kjh71qid11EzDeNWIcl8M90GtPX3wGMbelYYIVUCnyEYKOdgGf3RF1etK
         rTJr11QDG5t8G7efrCqqBauFrkQHk/WpqHinvHKw5fyZYdqy7QpNsfzsRElO+QhUf1g1
         bvUOInk+sRW1QY5hSr7iSc70G1L57mdKOiXSsxpzo/8pOHZeTxhl/8/KRYjQvIpo3U+M
         0BNg==
X-Forwarded-Encrypted: i=1; AJvYcCWAZBVBxQixdtlY2LHQJyD5/vwut3mzm/IIez3R2zQ2sJ6h2FrkfN7aT0rDCGkR89FeStMDzFA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxM+WVGs1n8q2a1Jq3bUEoSTSSpQtcS6CUEmRgFr/aXDl1cFwyF
	ABycXiPtpRzdNESHyzS5EKvBsSU5jJonQk3eue+cbfe2ztE1WXmGEVJXJ+DeL/QUpZXJ21Ahd2D
	dtA==
X-Google-Smtp-Source: AGHT+IGUAGxjHNELfO1gnQBoxyShlnhLiinRslmifWPsD1igdN7s2BU3B9tdatRPL4jwPkA1Z0qI9X+JjYQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:9346:0:b0:e28:fc1b:66bb with SMTP id
 3f1490d57ef6-e28fe4f0fddmr4836276.6.1728584742775; Thu, 10 Oct 2024 11:25:42
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:26 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-25-seanjc@google.com>
Subject: [PATCH v13 24/85] KVM: nVMX: Drop pointless msr_bitmap_map field from
 struct nested_vmx
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

Remove vcpu_vmx.msr_bitmap_map and instead use an on-stack structure in
the one function that uses the map, nested_vmx_prepare_msr_bitmap().

Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 8 ++++----
 arch/x86/kvm/vmx/vmx.h    | 2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e94a25373a59..fb37658b62c9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -621,7 +621,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct=
 kvm_vcpu *vcpu,
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 =3D vmx->nested.vmcs02.msr_bitmap;
-	struct kvm_host_map *map =3D &vmx->nested.msr_bitmap_map;
+	struct kvm_host_map msr_bitmap_map;
=20
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -644,10 +644,10 @@ static inline bool nested_vmx_prepare_msr_bitmap(stru=
ct kvm_vcpu *vcpu,
 			return true;
 	}
=20
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), map))
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), &msr_bitmap_map))
 		return false;
=20
-	msr_bitmap_l1 =3D (unsigned long *)map->hva;
+	msr_bitmap_l1 =3D (unsigned long *)msr_bitmap_map.hva;
=20
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
@@ -711,7 +711,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct=
 kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
=20
-	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
+	kvm_vcpu_unmap(vcpu, &msr_bitmap_map, false);
=20
 	vmx->nested.force_msr_bitmap_recalc =3D false;
=20
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2325f773a20b..40303b43da6c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -200,8 +200,6 @@ struct nested_vmx {
 	struct kvm_host_map virtual_apic_map;
 	struct kvm_host_map pi_desc_map;
=20
-	struct kvm_host_map msr_bitmap_map;
-
 	struct pi_desc *pi_desc;
 	bool pi_pending;
 	u16 posted_intr_nv;
--=20
2.47.0.rc1.288.g06298d1525-goog

