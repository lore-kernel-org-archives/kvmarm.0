Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8634145B26
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755370; cv=none; b=Diyuf0uHeO08xXpe5nalNsb8jPFrrTN8dufpjK/No/HHkKa3HaExsSE5KHDQnHGhotcaaFOCVtIU31kfV4qEVd43Cekkw1HhO3oCk+DHcSHhT6osLj29q9ptgOHJKoApmYUbvdl/6fblmh3chw6qG83TTQyjdddrUEzKEPPvCIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755370; c=relaxed/simple;
	bh=q3F91ck+dBrsVmQtOZTwjIV0fTw2GsZHZwmuMtwW+6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qBkj/hpyBm4hPnLhrl4V0fjPKHsHizk/fdFtomEZjNgJoZKvGjo+0rHOwxHpk7vGDv+MPQuIgmQsz5aK6Xgxz3ZGcqIKq8MFVV9Jtrd7/sN/wG2SbI7+YYW01moOyuqel8K86KOi4mSgowyfCDIYQY1+kJa0iBy+TdPaZf1GYJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p1gN6MbG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p1gN6MbG"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e95713327eso356865a91.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755367; x=1733360167; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Agu6M4WZdSaan2rYdaSmo6PpiQZ+ciRGpotTGWqZBGc=;
        b=p1gN6MbGoEbh5XTWb0PHtXiLljheBc5P0RSGGFdqjb8Jzl7PpAZn8tACoasUTphsY8
         QFHt+CZgTYZqVf6OkJj7HJHQpbc9mJa7RBkIEy6u+Nvh5fVb94BtJ1R4tORWKYBT45JR
         Tbtp3jxTiesz+jqKoUirkzHAlEztSs507zg5VDeZmRh+Drtk7tMhXPGwrIxV0aQH5NN1
         UEF1uTiLMGiIVcIqAlq5eoVRiyolLGAuecGP6CBG48BGyYi0a2lpD11f+gLVoMlhwSJ2
         kB1okVBB2hxKSMnKarQlB44I+Do+KM6G3/LIClz8TJvy5GUWxqq/oSN4PCyfGZGOMO2p
         w9VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755367; x=1733360167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Agu6M4WZdSaan2rYdaSmo6PpiQZ+ciRGpotTGWqZBGc=;
        b=LEnaToIdGpk3LsEZh5gPeB20H5NtGOTlUHgDxQoS2LcdHc+v2dYDKyhiq02wxeKvjb
         lZ3e+ayp7i2APInMAC+83L0MOTIQc09/9fOvszCyBrBtOfPxLECc06OwsHTaRHBem4bf
         8wrpRgTv8tY0mCnvJkjMvBLjuRbJoto1J8KMLksY4Gisuz+Q1j9pw3f041EbBj8//Xrv
         CV3AfpZZBJwvs7QEe+fVPd60pjaOK5Y4U961bU0Z4TqABaMl3BzuHd/Wb3griITI1vB+
         mic7fkRyl7dE1BVLsEW7p5ZlpegVlJOVO6asSfH9cFWrmyP4Y2iPx5LtNwCNDm+beOxR
         68fQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcyIRPlD+pwPmoqRdqhOgOo3BAwqRa1dtYpXyo5Oq2nbSwsxZk86uwAqUSW11aNkLmBppdUew=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOk2dTb6cn54Q5M+3Z3CUOvzcctb47veZcUWN17eV9tb7XxiqS
	0N1BRa1DIWS/h5TLL86GY09IIV5gOekksO9Y1jcuM/7FNOvT61OxxKdJ7a+ONw00xwmOm9lnE8E
	xMw==
X-Google-Smtp-Source: AGHT+IHzlIPOR1Dozv2+kADz6uvilkOgvJy6Ih7MLR3sUMAMwXrp/UBNznMIvAz/TeA8dqsISkWCfiSMkjQ=
X-Received: from pjbcz13.prod.google.com ([2002:a17:90a:d44d:b0:2ea:63a6:d869])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c04:b0:2ea:7329:43
 with SMTP id 98e67ed59e1d1-2ee08e97ff9mr6674171a91.6.1732755367252; Wed, 27
 Nov 2024 16:56:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:41 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-11-seanjc@google.com>
Subject: [PATCH v4 10/16] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Content-Type: text/plain; charset="UTF-8"

Use vcpu_arch_put_guest() to write memory from the guest in
mmu_stress_test as an easy way to provide a bit of extra coverage.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
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
2.47.0.338.g60cca15819-goog

