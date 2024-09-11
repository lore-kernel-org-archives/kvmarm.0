Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BE11BDAA8
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 20:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087363; cv=none; b=n8v5RqERocE+FcILNwKUoQP7wMnriNGsALxkJqY2Id66uGm34jtVJKiEHcTmTbri2gLPJ+W5QG4Tg81ilsQ3RtldSA4Yxy7mxeqsIXTTRjE+ASVUB4r424LOpKb/KSQjScQJ9BO40OmImRl8iuE432QoSxnzdg3Zd9u4mvhuE9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087363; c=relaxed/simple;
	bh=hTKlj60rYtk0bD0DOzR2zSTjrZ18AZM0vgeJHBtr2dM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AIrdb2Qqm3da6Jx0NVwYSVWi+Hs1Qeu0ISUUfDYfYB7e88jlf9yxFcUbwaYVg6QAJ7j2RDXQe1OLvZeCNOROY6HLDhSHAW18E/skW/0d9VE67980UmuDwmadqche+pK9/fqNUg7jmB8E8oE2zKnkC5RM/5H9XVegMOAoPgkIOPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SpTsyTcc; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SpTsyTcc"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7cd7614d826so1604291a12.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 13:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087361; x=1726692161; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5I/tJcOHFIa65Wz9gc3TwU6W0/w2a3V6j4MGXxqQ3K8=;
        b=SpTsyTccGfO+OCfnmZp6rU+A8mHnGgdP2iC8MoBJzSHCrM7cqAbwpyJQSsg9lMYbE1
         a1AGTy8Nzr1nF4yDvgiXA9VnudkUmobNxd95zQBBuWoTFnlqAaE7z1lTbejKXbxtn0Zm
         2zxDGfAVjGm8tP29GDD0PZBK1fTQdHSBnJScWplY74Fe3K7CG+d1F7UGI1bmAUdDnhhM
         BQG/Ag3q8Oh8HSn9iyx/47WPb+ajKsVwoLT4nMOCAM/HCW7eAHm6k2g6Eu7rHFYDWhw6
         mXGlalWwiVkRTLVj8HHzKsPq2ED6rQaeCsg6QPEA4wyh4AVGbbvjxfK6t4LuKJVDOBRM
         Iq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087361; x=1726692161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5I/tJcOHFIa65Wz9gc3TwU6W0/w2a3V6j4MGXxqQ3K8=;
        b=VFMWe1sdRg3Q4ztqseUoh41noZK/z8XUCguY66WmQ6fY4VglDoptyJhY9N/jRrF2ki
         MNuF7AANQb1HJ6T803JD6aSvdIHr6Ri430Fva0sNK0morYhSmxHky2XrVwcc5NCKHkiT
         xbh8U7qtfjupXVeUlFEl+r8iumrpzeKEhdMNoC/s/BeqqxaxvCc6CzcIi7y6CaDqay+L
         zq/NdtzDRvHu7BMbXXAXb1uqATcEuNaQ7quKUWyLzYtH5CFvJ0YK+FWE/sHq4tX5qyLl
         zoEQYCxjyG51tsu5D67z5pXPLPa4v+Iq2xn7qjk6e/Eta1zLWbAjidSTvsy9n9f48ba6
         85zQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8PAcRdYngchvQiFH9OgKmY1R7E7tnosW8hO1hwh8QVNC/PhF6yupQA6+6MgaGZ5vTdr5P+Hw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwesrXlZksBokWg0z6SNzL4HKCb9IE5Fo3mu/ot8RwyW/W6xP3K
	QVtfN34AlRb2ohzpn4jFaYg0jVGgWJUofRzbQXZhyz7321R37hkrxrFNwZbcMplOXitHVy/zzn9
	zZg==
X-Google-Smtp-Source: AGHT+IFOw2zNAqVhdCkeZdNi5IKOGHn5wgnynX/KErJqxVULBd4txDltmiT4cacd3crmvx8FKohy/M+nAhA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6fa6:b0:2d3:b1af:ae48 with SMTP id
 98e67ed59e1d1-2db9fcb47f3mr17342a91.2.1726087361313; Wed, 11 Sep 2024
 13:42:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:55 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-11-seanjc@google.com>
Subject: [PATCH v2 10/13] KVM: selftests: Use vcpu_arch_put_guest() in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Use vcpu_arch_put_guest() to write memory from the guest in
mmu_stress_test as an easy way to provide a bit of extra coverage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 5467b12f5903..80863e8290db 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -22,7 +22,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 
 	for (;;) {
 		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
-			*((volatile uint64_t *)gpa) = gpa;
+			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
 		GUEST_SYNC(0);
 	}
 }
-- 
2.46.0.598.g6f2099f65c-goog

