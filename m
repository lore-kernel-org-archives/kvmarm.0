Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C59B153BDE
	for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708618277; cv=none; b=RcukBpUXeM3FS7VDvPrdXllH3zHsb90UEKL1iWagLdSsxmhZ2u/inSvtvsBdxfWUHrCJg0IJBj9fi1cqO0k2bzI+T14VqiUEtRXhvIruDzFQeXNlYxZ+76amdYxKChFUa9C2M1orclQnYJm9fBRdOP6MXPd3MN81/reuMynPasI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708618277; c=relaxed/simple;
	bh=87Gp+Jzp2QxMm4ODcUrxrx7UgutY2NvawjWw5n50K1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gU2hreSR/YG4gf1l4YCES+KkBy1VjA+9F1z+I5pZFsQa1YqkzQKjTmaqKuRv401ALGJ7OF1zAbjaaB3KU18uDTv4+UwQNN7vt9fUxGzMYRu5dCn+83bTMCfDfo5kEqlR/q+uVgvdoOfUd3r1Ii3TS1qQzVEy+BYh3mDeXAgF95g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mmVgMtdQ; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mmVgMtdQ"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4125670e7d1so4897865e9.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 08:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708618274; x=1709223074; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DTAPsCidsFQm2FQiq7NglRpJEY0jsUEiaTOsAjZvPK8=;
        b=mmVgMtdQpcW8OPXKt7eWfRPd1ChlKf5OZc7eyEGEXpChRLN/ATp6yBFmqS1vfja91c
         cbHJ4Z5QwG5Tg0hb2dX8CqdXhdsPwYOm7wHED82oeiKokqCXveHVxcwJDjjILbx7WWs1
         94ZHfcynEATZ0z6FtzCX6pveVXJGMJRXuNAR6TbBlUsieH3rEB15FFsuksaecJ5hwXLV
         ScBR4csZks4n8BREdJZzt069rpE7XM8QIpu8+bo0Ixmgsyha85I7YIBujMC86gnmsRz7
         d6+oBal73n6s4bODoEhEvWpARLXQarnSPk07nKSYlGFu015c9m6zCLdTT3cOxvrkdOyS
         Gpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708618274; x=1709223074;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DTAPsCidsFQm2FQiq7NglRpJEY0jsUEiaTOsAjZvPK8=;
        b=ITlYuttgT4CT/M2sTifmv1Eo/YlznttKdYkVnBadJQpDs4F//nKUMrfPb97Vrpf6r1
         N8O0bVDpYgOCiRtF7r1gl+DZK7aoq2+47aLyUn5EVIX0UnGL8ALnZ2gzqCxg22Fo31pL
         cDG4ckQSV6PB5ih+EsUVQQSQJ+j/JKOFCtCYmFOwSQus2Pdfq1yqh6QOlMRP/r1jCy5Y
         bKzf34aFAO8YTOrecjp3S1hyXilEx/6KeTgOcaWFTWVdrJPm2jTZdEFG+AGJcNaAPnE9
         2/4SiXoAeyCpqBL3sh7NTxsuxn8d3JH8xtvNXqIU5Fg1DmqwbzIxKZebTLQPSHzXpuBa
         smUw==
X-Forwarded-Encrypted: i=1; AJvYcCW9iagnLMrnHHLMm0SQEzVOzIvytsWECfqVUR6Ua0uRhG2nnQuhs2pKkajYdshCC+Y2prklh476EnG3FQckrpgrCTI2xcFH
X-Gm-Message-State: AOJu0YwWKrV20dEJZEbe7t4kNe04er0dxX4YECH4bSNPdf9KJ7k233Y1
	JC1XIg8IMnxJpD/7jlzq8CepLbSGlec+0a+rvfQNo1AjapkIVlR6rF1WvYtS/Zr1hVNmff2MxA=
	=
X-Google-Smtp-Source: AGHT+IHvNF8y7PWGRXSHAC22nIJTTDdyX/V+eUGWRSqzOZ4Mt5/e5XWmA6cYwSHs0FNnAIiCY0PdlGk9FQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4fd2:b0:412:6c73:a647 with SMTP id
 o18-20020a05600c4fd200b004126c73a647mr100415wmq.0.1708618274543; Thu, 22 Feb
 2024 08:11:14 -0800 (PST)
Date: Thu, 22 Feb 2024 16:10:31 +0000
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240222161047.402609-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Message-ID: <20240222161047.402609-11-tabba@google.com>
Subject: [RFC PATCH v1 10/26] KVM: arm64: Avoid unnecessary unmap walk in
 MEM_RELINQUISH hypercall
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

From: Keir Fraser <keirf@google.com>

If the mapping is determined to be not present in an earlier walk,
attempting the unmap is pointless.

Signed-off-by: Keir Fraser <keirf@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 405d6e3e17e0..4889f0510c7e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -378,7 +378,7 @@ int __pkvm_guest_relinquish_to_host(struct pkvm_hyp_vcpu *vcpu,
 	ret = kvm_pgtable_walk(&vm->pgt, ipa, PAGE_SIZE, &walker);
 
 	/* Zap the guest stage2 pte. */
-	if (!ret)
+	if (!ret && data.pa)
 		kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE);
 
 	guest_unlock_component(vm);
-- 
2.44.0.rc1.240.g4c46232300-goog

