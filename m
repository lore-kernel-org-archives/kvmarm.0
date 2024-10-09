Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1104204F67
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489021; cv=none; b=fb9Hk9kiHGnhrDf8ebdOYIqwB8pN8fwXK7rr4n+s9DSyo9jvTj/vkljwzmZMzRaxKSf9hajD1gCeEArIYQeEtQH2VVkynGLjZnPiwwqCO5DVW3US4lpbCutdooY25U/Mgrj6L47clB7D6FHb7mpLDKBhQL9gD1tv3N5tds4fZsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489021; c=relaxed/simple;
	bh=ySYmz6+XDdTBZKIHQpIWEkeL65GnrCL3nDWRuqk8AHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HUv9Ln6oiXUHPSS+CTIsFZEVqtc5bSNNQ3CMbLBMgk+xqhsXXiLiq/vFR/29C7chRjpf2AuCKuJt0T1CISc3Sq9iTcJuerqrKg/8h25+cE4cVAuHfFSRHDPJbnY4VPv8m1QFSudd/pFx/6c5D10JLym3782XoFs0lX7327zblSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CeAOKsTe; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CeAOKsTe"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1159159528so1774682276.1
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489019; x=1729093819; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IpGlLPpdKIlhRCfJQtftwzWlWOxZ3g0ZRZhoTsEcT4I=;
        b=CeAOKsTe5z83mfIQcox38luGkecf/PjO/R26CNgwKTffgxV4dlV9h63xAJ9nZjha1F
         Tievq06pL0S8qGVWUQdutC8z8CGKlN+A61mpjOzJsq9mHN8ClpvribMjgQJse/HZN8fP
         oO+S+4tOK6JO7yJXZOpwra+Fw0Cw65UFOGQtOYFclWyDgXGL3OfHpJC8GlU38CvWNogS
         nVY15GEuDupRCXRI2/iDA9ciLz7QgRTNvVQYZwAifaENjmUrC5RjQiNHPd+7jc5bRCKL
         zFfl0Xwi8FdLtzQViCldY26WIGGN3gpa+dXtinDtkNZoD5yphYw+5R2lbw9TyIKyxpU/
         QeRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489019; x=1729093819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IpGlLPpdKIlhRCfJQtftwzWlWOxZ3g0ZRZhoTsEcT4I=;
        b=thhrYYbBiWgvERkeYLiP0/GNaXmeSOF51VH4c5Xn9/Aln50J75bb3cbw5Tqunm3n+V
         WMXnZMM9SBTbSZw470CNTQoX5I66T2GWsof15fbb/CDXvXiWZ7S+GuxNfCzQAutF5ON7
         i7beOxcs19rHSRzF5oB4eMjeEEZLrJ+2z/9EwsmzEZa2mVFuhv5sIMW+f1duVQBgvH0z
         4rez6EPelc4MoQK/bpOXCfDxQei42sSb/FAYA8gxmKLgCFxxpoZelS6KpFBat68uEgWi
         GiYA5Vco3xo0+wQi2Vcj4LPU1jDx5bAEThhjCOyRkFXRz2QDdykxpt/amlnOWgmo9Nul
         vSYw==
X-Forwarded-Encrypted: i=1; AJvYcCVm2mXLWdKzTA0SXXiLCA/ZMsU5UcJqRVDQNS5Q62o6eAdxSheFzmxWVia5kHQK9Wsa8cJgAcY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyqJSd/iK6wsiAw7NPGnClJcN45Oa0c+fz2OTtz3PqohDuBbon
	OD836FhShkck5fRIhZjWw98ghRnBelOZPVM89yzm3uhMAtaKrc7GJA56k4D1esQvIFSZEpP1Vuv
	EjA==
X-Google-Smtp-Source: AGHT+IHJrTSljEGX+w+vGWljsF6J67uTWXS92qMmyHsTMzVm3HG9JVjkOOVhTNIgejhJpa5nZzlmmTlBPQo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:8248:0:b0:e28:e97f:5397 with SMTP id
 3f1490d57ef6-e290b7ec5bdmr51276.3.1728489018761; Wed, 09 Oct 2024 08:50:18
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:50 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-12-seanjc@google.com>
Subject: [PATCH v3 11/14] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Use vcpu_arch_put_guest() to write memory from the guest in
mmu_stress_test as an easy way to provide a bit of extra coverage.

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index fbb693428a82..656a837c7f49 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -23,7 +23,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 
 	for (;;) {
 		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-			*((volatile uint64_t *)gpa) = gpa;
+			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
 		GUEST_SYNC(0);
 	}
 }
-- 
2.47.0.rc0.187.ge670bccf7e-goog

