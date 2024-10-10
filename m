Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415FE210C2B
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 18:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584844; cv=none; b=WJlEldTrvu6vDTKI33Th2mG5JCS3xwSsnRt4uKoYSX6LTFDhK+5JRiFECZxVz/ohNDWM4H0FnxnYw9SL7JxqM/ibWIc00D5kUcx1hp/uxcojfBFh5gRBQPJdmRpPN4gGmqDtjaXRYUiI4MfSXg1zNWdKQ0o6LGpPSpB4pdFI1EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584844; c=relaxed/simple;
	bh=Q0WfZXD0AwljsCbiw/O0WdULhXfIX1X/By/5X/lP1LI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mQFdC3J/BOE+L/9wgsUTDvRN8TKy5gug4zOrQZ8b585mfEw5g4Bwr6yuxgDRZuya3P+5UZFFpWNECeZCWKg6eCKMX4nP+JkVatHBeJK3GX669XlhrqNzXz6Mz/FQ4EQgE1OUdtdQ7ISnrgsVfepfxJIK5sdp7WZjp+IIFfbe8lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JvmfSPaP; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JvmfSPaP"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e284982a31so22467057b3.3
        for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 11:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584842; x=1729189642; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OZ/c8QPJoSxQXGCWT5aWp1nMy1t7EEzE7+N8fqq+BFY=;
        b=JvmfSPaP8jNp20a3Fl2D8EJQb2eyVbDOAlLJZrVdMxVeEPZEn9Ny0blAGNQ4CqNhiX
         Tp5SRoG4qqdcjYZJMI8p3A+iauImA+wOzv6rtX1dHsM/jAbsHXoTpWiabnFcCfgJPqNh
         tRGo2kuQV4LhQoz/LXr18B3q60kDKR74UsyHpfy3n9Z3Nq/j2kUz5WYQ6a/fjPKpCftB
         TN3mP/DLX1+et8NZJJO1OteGcLZzHLNyfuWbHNvYD5nHoxQhQEjCjOIwcKz5VjJhQK7W
         9HJvNgkioqKeygSkByzknPjrSCjf3RPgEB49jbsFA/6gAlz5AVkpPzAbtNKUmu2O80Qy
         eJqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584842; x=1729189642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OZ/c8QPJoSxQXGCWT5aWp1nMy1t7EEzE7+N8fqq+BFY=;
        b=lguvMvEGBTTrdjP/7/lxNdJVa3PWcCisyNMqBj5RylzMjhcW1mjAtdKcdc+BJgl54F
         e6hhSuwCLmEsB75b46fBETomFzp/zwTQvXc/7XM8ruFjjZ5i+g1OOkOKz6gtBOB9V6Ux
         Gzzbb8V9EM0w1/rcehCbycycoPzgR1ReF6SaZ6z3xfQlhBfd/i5xbxTCN/JFv6v9h+rv
         Hkfxk6GKsnCJpVGsiVlEnWBEsToLbCODZtWE30PaYvKlOfOoyfh62XUPPWH0HDWMe+FZ
         pcSVHQpfyoa5wYAfH3yv5API6KEnv1OZ4XqQ0TE8vadfozQ/Nf+YOHB4UzeSgwCCmGoA
         02Yw==
X-Forwarded-Encrypted: i=1; AJvYcCWTjEanyBdbUR604e0QMYkMuXWJNAJeOYkw179tP5TgtGGrwhanIgq/UI5PXCxAehpt44EVKwE=@lists.linux.dev
X-Gm-Message-State: AOJu0YznfumbqSx1oIw78gVvovL+NpJh+iUxJjek1e3cgjxBZaCnVvMv
	wrsoDK2gvoI67TU6hBZzFcUeuTRQGbWdUbXiwqxyt9vbMiafKMWqBFAQaPJCeWJROr4FvwzettB
	5jw==
X-Google-Smtp-Source: AGHT+IHhD+Vk6TwFIS5v8fA24SNPRWU4vCcQM+1g+zVw6L+6pfrMpIdoNti+PehtHCeQDGmk8Jps/9lQ5Ek=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:d30a:0:b0:e28:fe07:9cc1 with SMTP id
 3f1490d57ef6-e28fe4a3a81mr68085276.3.1728584842321; Thu, 10 Oct 2024 11:27:22
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:24:13 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-72-seanjc@google.com>
Subject: [PATCH v13 71/85] KVM: MIPS: Mark "struct page" pfns accessed prior
 to dropping mmu_lock
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

Mark pages accessed before dropping mmu_lock when faulting in guest memory
so that MIPS can convert to kvm_release_faultin_page() without tripping
its lockdep assertion on mmu_lock being held.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/mips/kvm/mmu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index f1e4b618ec6d..69463ab24d97 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -634,10 +634,9 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 
 	if (writeable)
 		kvm_set_pfn_dirty(pfn);
-
-	spin_unlock(&kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
-	kvm_set_pfn_accessed(pfn);
+
+	spin_unlock(&kvm->mmu_lock);
 out:
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 	return err;
-- 
2.47.0.rc1.288.g06298d1525-goog

