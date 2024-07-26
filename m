Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416B418F2EE
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038109; cv=none; b=iS0SxCTBEck9YUJd+jNEjqc5ZGxIlc2/fm+j5ae3LZe544FR3UFYztB5E2NnfQho5MLtIp65nF6t0LPC91rgf+hVEuZnwrxeqAdDp6jlDWA1kva4N3i5zQux6ZWTVrRUUUD8gWhuGAD+u0JKKU1kH1YnpImFeHV6890VQGkRxi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038109; c=relaxed/simple;
	bh=LwnbsVmoSkGUot+G6cbXgIy7tatzU4elH4imBAcWXlg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Weqy7k/OhpHhqr2g81gmuTU1lNme7v1kPzeoSgmLvBw8q+9dyofEyhv66u54v2jjoOJjP/YV5IRwHYGjQXVxDz4btt7eMvVRiHELRCLJz25uawFMGuF5MByCRbESVdTzIi+GsUJAdAe4B6e17bSTQlZRxwEBO/1ETn+jtsfM+HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XAHScmxJ; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XAHScmxJ"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fed6fe8002so10220705ad.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038107; x=1722642907; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Agw1NDopTbJHSwXqEMTAoK1oQKqohLcT4CyuwhV7hPY=;
        b=XAHScmxJljyuSgz3r0dENRNqN4UToS4c1qEfVpWdWMp4boIY41WHAXKcEpg4Wx3wuv
         hDYoERY7RNNVLi8H4LLx4en9VbhULqK9Q3OwAesZt07C0MCPXXny8zm2Q0pSEEH6fP1f
         Vu3TsTmMbCaLQx/wxm4QgB4WeVFU7h+vJiofVsDRc2YKGKC8HSRb5y36MKR1vpLBg9ue
         0NfSiiSG8MTc5Nfjy9y7KCjo1WfD301s+/qBfIPtD+53XuhSJr8cw11G73JzasTMT3fp
         19NOLt0HTyf7k/8Apju3Gsz7CRNoedyDLIcxvd3YPxbC3Tz+VEbiWwecU7WW3HTI0we2
         2gyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038107; x=1722642907;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Agw1NDopTbJHSwXqEMTAoK1oQKqohLcT4CyuwhV7hPY=;
        b=H5isYSdcDfoCBxNkdf9VJ4Q7S9HFeZ1bzWXTTSbLPyu2uEfnRTIhFIfIFl9JUOfXut
         d2HUgd2fbKWSELe/eUBp7mNwKtXYTfINgPa04TJiua9J4IrEXgk7IC0Hq0oqNoqmqZJl
         wiWPOpmsSO5VO8Vp/Z9sY+AII6mmn7GNttROaMjDNdtTq5EkhAMvxtrEDzaVo6afWN1b
         jk/lsrIfvfjjqyGrUNI6evPSBHDWYXV1rFZ+NiXMunV6pGHDuIDyNyxN0niHVUD5uZYr
         J9azMXscPla71+gYgvrcSi5EhvB0Eo+Aa1+QEYsbq//tssQHWypKmWSUzg2MtuF5IMv4
         Dgig==
X-Forwarded-Encrypted: i=1; AJvYcCVX5hiw4sgat5CNkjzWG6vHklvD+MujsDInO4r5j6nri+zfDWVZSCeabISQf9pXS2ce/2JNK7KgcHR6vSh+JoV5go3sCD70
X-Gm-Message-State: AOJu0Yz2PlllwqyKrinzC04ccbjn0Vul+r7eruILzGw+J5y4kQfMFrDw
	rf1Ee0JB2yjodbZ/WCMIH0N2iznJBNevT7QDVJjF6LqYiGAq3PXyX9TZqy9atwfo/3XpbHJWzxL
	8cA==
X-Google-Smtp-Source: AGHT+IHxZ9LAKt5vIHU7V05HDfJ12gC6skwH/WeW9XOXHpR7B1c0ubRWlOUtq2UiALskA4rClXraM4lFVDE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b18d:b0:1fd:8ebf:672c with SMTP id
 d9443c01a7336-1ff047d8f61mr25415ad.3.1722038107293; Fri, 26 Jul 2024 16:55:07
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:52:21 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-73-seanjc@google.com>
Subject: [PATCH v12 72/84] KVM: PPC: Remove extra get_page() to fix page
 refcount leak
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

Don't manually do get_page() when patching dcbz, as gfn_to_page() gifts
the caller a reference.  I.e. doing get_page() will leak the page due to
not putting all references.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_pr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 1bdcd4ee4813..ae4757ac0848 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -652,7 +652,6 @@ static void kvmppc_patch_dcbz(struct kvm_vcpu *vcpu, struct kvmppc_pte *pte)
 	hpage_offset &= ~0xFFFULL;
 	hpage_offset /= 4;
 
-	get_page(hpage);
 	page = kmap_atomic(hpage);
 
 	/* patch dcbz into reserved instruction, so we trap */
-- 
2.46.0.rc1.232.g9752f9e123-goog

