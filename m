Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94331D0DC9
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584700; cv=none; b=Vo/JgBRM905D37/X5FOScCw4cNu0ROgIWS5axM6MWvsCbpra3M+sp+2rDf9Znm/pl1DfKis3XXR3OcnATQ38P5+KHYVJi6VLSPIugtRziEWyHUKC0Fb/f07lEZAn+aIZxaxArqCk0X8sVCC5TuzmfP3qwhrxgss19L2o7pf0PNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584700; c=relaxed/simple;
	bh=/+UXWBjoqTQ+9Qx4e881Uho0Hr1R01lQsdRPnyHLl9M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DT6DCajhFIPK92gp+fWeVErAmcCVts0bGFbngDeZteyAa3hGByElusv9x/cKXh+CdULtISFZE7/TIhlM4hyom/2PGpB0J83DDAkE1usyAfJJ6c7/e08lDs66D8wloDezNnjBmqzBC3nKzhR2/P+t8+j7uAA0ef9+DUMvn281GFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s0vhLW7u; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s0vhLW7u"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e3204db795so21438297b3.2
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584697; x=1729189497; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4CpCR2xmh5xLGpBn2Bl3P0Y4RCeyU3sCMc2ynGYEmk=;
        b=s0vhLW7u6r+wxlfco64Ctbd9jBdreOEyavQw6XBdmjKAnt3SlYT0GCPTwVmfXXV542
         owMtBVLR0/ImSIlBrF+EUuwSt07/eNE9geLNvWYgpTUixkJRRnO8dcqBtFY3c62f/NZc
         bc5GvRctm6r3pvj+sx02gfEMtPKeUMUUW+6wvMf9yzXpwP6Dcg/y/mjFbLWfXJeWVF+E
         3ITU5eHV+QWQqGBHrJwDFvapBTKnlZzanM8nUCG/Gso0VLDh1e+DAGPFbzpeIez1Yzie
         D0VbgA72DwK5pHNC5Gn1L6m86908u6Qcl/mIqwPl0NFiDX2DImrexVTSexJeCQwzJbYN
         LlZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584697; x=1729189497;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X4CpCR2xmh5xLGpBn2Bl3P0Y4RCeyU3sCMc2ynGYEmk=;
        b=W+5kzoZ5Nz19GjWUw1H2UeazUpYwiIBoumq84odHy4HktvcCVTlhMHw54B+l3031Xl
         ALPhctZ1khzgbf5rIv/jgykCzeKKJ8TxSL6+mhpC0nvp0WGdTdICTUMkP70LhdEoMCIB
         Ic75/NztzOq0a+ZBKFK8ZAig+TXTAgyiDOy3UMTWvJYomH3ELeOG1LFHX0g/2jM1Z5f4
         4/LRrwyE9GbqofhKvluSrdHfsZ7/mPkyWfOU1/KQN1wz12xnn60GvW1C87ZZsiS/Q58U
         P8SiDCT/oAhsdt03mHkrYrMBiBSrIr9FjZWMA+1I8TDdod0Yf/3e+p2/jh37WPFaZV8h
         Ulgw==
X-Forwarded-Encrypted: i=1; AJvYcCVV2iMYqE0mBG471t1a2qJ8EzToObVNt8ydfhRMdxlJao1pm5pI7XaYe1+2P97MduWFF11yvtY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIMqc2Y0XCz5Ttv8psdowkcC4Rf6RNus+dk6PHRjvnwSeEsPIL
	ZHJhxSQWz1pjuqVnR50qvpTDklBur+4PQkNiNmOXkopX9QMI+4LVFeM5XEM5lKj2XXPWokDsNNA
	3jA==
X-Google-Smtp-Source: AGHT+IGrULPD5dT5NWC9dFAfgTsoL9JIWGzHU9t8+6e7flVyO5QHPCRlr/jDUZCu+nhXBHYl+WGzejB3KuQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a0d:e486:0:b0:6e2:371f:4aef with SMTP id
 00721157ae682-6e322168931mr204147b3.3.1728584696651; Thu, 10 Oct 2024
 11:24:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:06 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-5-seanjc@google.com>
Subject: [PATCH v13 04/85] KVM: x86/mmu: Skip the "try unsync" path iff the
 old SPTE was a leaf SPTE
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

Apply make_spte()'s optimization to skip trying to unsync shadow pages if
and only if the old SPTE was a leaf SPTE, as non-leaf SPTEs in direct MMUs
are always writable, i.e. could trigger a false positive and incorrectly
lead to KVM creating a SPTE without write-protecting or marking shadow
pages unsync.

This bug only affects the TDP MMU, as the shadow MMU only overwrites a
shadow-present SPTE when synchronizing SPTEs (and only 4KiB SPTEs can be
unsync).  Specifically, mmu_set_spte() drops any non-leaf SPTEs *before*
calling make_spte(), whereas the TDP MMU can do a direct replacement of a
page table with the leaf SPTE.

Opportunistically update the comment to explain why skipping the unsync
stuff is safe, as opposed to simply saying "it's someone else's problem".

Cc: stable@vger.kernel.org
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/spte.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 8f7eb3ad88fc..5521608077ec 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -226,12 +226,20 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_=
page *sp,
 		spte |=3D PT_WRITABLE_MASK | shadow_mmu_writable_mask;
=20
 		/*
-		 * Optimization: for pte sync, if spte was writable the hash
-		 * lookup is unnecessary (and expensive). Write protection
-		 * is responsibility of kvm_mmu_get_page / kvm_mmu_sync_roots.
-		 * Same reasoning can be applied to dirty page accounting.
+		 * When overwriting an existing leaf SPTE, and the old SPTE was
+		 * writable, skip trying to unsync shadow pages as any relevant
+		 * shadow pages must already be unsync, i.e. the hash lookup is
+		 * unnecessary (and expensive).
+		 *
+		 * The same reasoning applies to dirty page/folio accounting;
+		 * KVM will mark the folio dirty using the old SPTE, thus
+		 * there's no need to immediately mark the new SPTE as dirty.
+		 *
+		 * Note, both cases rely on KVM not changing PFNs without first
+		 * zapping the old SPTE, which is guaranteed by both the shadow
+		 * MMU and the TDP MMU.
 		 */
-		if (is_writable_pte(old_spte))
+		if (is_last_spte(old_spte, level) && is_writable_pte(old_spte))
 			goto out;
=20
 		/*
--=20
2.47.0.rc1.288.g06298d1525-goog

