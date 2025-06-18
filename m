Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A2A21A455
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 04:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220683; cv=none; b=TOO+ijxmcWhu8qvAi6bZjOW0ape/IjJ2agPmE5nyeLToJGZU9NToZL78ChgkE25HZraFuNNJ8vc05H5fucG4nb8/WhBZYhaiBJJe+7G+DEuedqagP97OJg9XxbWetk5SNALLvKkFuQPP4tEyuPJ7GcwpHmeX1XZcAT14XximZ5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220683; c=relaxed/simple;
	bh=2bZIqpioQGHINFU/EiphRLQAzeRmXnkDiiTDnIIiQmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hOoidbKwEPnUM8YoVn42gO9aN+dxGEpX5vPhRijltdY0WrcA+m+msscJDb/sMhIoDjBe85KIVRUM4o/2on+v6Z++CGULogRStDOCLbdImPqiyscPq4/BdswbsiTwO+W6TI6MtOKQkJTtFJdZ/XV2tVaYJLTFSO1VHfanXFGzj+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=llfiJDLn; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="llfiJDLn"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235e7550f7bso59124295ad.3
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 21:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220681; x=1750825481; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mIb2ZAeP1IApX8KajcoQdMg+K+X03gdKKVOXgy4uxAM=;
        b=llfiJDLn6yQ5aQcMZ48EOBOaGBRlnSC7TkKz1k8aMuqneICm1JUg1npbi5rDsB34Wy
         elUgyKvydxsok6nPNDqmpPyZpzcW4034Ty0tRJl4FfMHL2Lf5BZWZiY2/PZotQ81rGmc
         iTnQvnphBcaH2FEQeTvnLl8YH/LilvfGccZ4zj4P1u9ngeuO/TppUHqr6DQ0uqE4G3rC
         wxyxq+Egkc89m78V1TtZ8r0Nfq799MCTlUli/6/yFURTL//1qFNu3h6rGJqdHk+bFAWZ
         Uwv4jhZ049gap4rPiiP8o3v1ypBvZ3HL7O3iLEw5/9XJVX2uNRt0m94nbSGbFxzyi7FE
         XgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220681; x=1750825481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mIb2ZAeP1IApX8KajcoQdMg+K+X03gdKKVOXgy4uxAM=;
        b=XJHaEw9ZSyfonodiwPUJG+8KrYJ5mcTfNiSUXNiC3EjAGF7ze1GoV7RysW4THY7Rf1
         yb8xWT6hO9R0Nhss3aUP3Xxq0p5p6FbrHTTheCig8lzOVn6WwI/NuOP1pTQg0DbQayhM
         h6M2T0GXVK3CxyLBVd7aR9KugPJ8fe2vRYWKWziBQsL9927XCixyqHga4+ZG/09AmQb9
         4Cs0NnAgq8hvUY1TFULl2MrbfqTPMf7AiGdt4ljZvm0G3gFsUpwSWJmDsY3IQpKBxaRx
         TlvYchp1rvYklDVgUMjNk+hNt4+eIU8Z3ZSZiNKoRF5tynERwAMKO5u0HLrpKiG/EEFJ
         w6dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEtSRXQfaYM5WKZ/WfQkOZwy9pv4ib+fOjXO5krYN6kk7+3wOwjSnMxYXCFq0QkpfJs7Azyr8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0yCDSs1vRXsULzQrIZBBBRL8rnpRcyMvo2Ni3BK/oBxGe2y8w
	JHKGKxY89u0jUiUEmt23aqcL57lzHhC79CfmyOuHDd+i5s4DFRnimyjkN65ZTPjwul/vxdro1+1
	iLqFYYv1q/Q4dhxfOw0q9Rw==
X-Google-Smtp-Source: AGHT+IHIvgUZR0zBF5d+sewo95QOsT/HjDVkEn+tDLrOgLskqZ9xDvbZRR23CwdW2Cit9o8BMVaShYmHas3nnjqN
X-Received: from pjbmf13.prod.google.com ([2002:a17:90b:184d:b0:312:eaf7:aa0d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:228b:b0:235:655:11aa with SMTP id d9443c01a7336-2366b17b16bmr234970365ad.39.1750220680638;
 Tue, 17 Jun 2025 21:24:40 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:18 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-10-jthoughton@google.com>
Subject: [PATCH v3 09/15] KVM: selftests: Fix prefault_mem logic
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The previous logic didn't handle the case where memory was partitioned
AND we were using a single userfaultfd. It would only prefault the first
vCPU's memory and not the rest.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0202b78f8680a..315f5c9037b40 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -172,11 +172,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
 	if (p->uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
-		num_uffds = p->single_uffd ? 1 : nr_vcpus;
-		for (i = 0; i < num_uffds; i++) {
+		for (i = 0; i < nr_vcpus; i++) {
 			vcpu_args = &memstress_args.vcpu_args[i];
 			prefault_mem(addr_gpa2alias(vm, vcpu_args->gpa),
 				     vcpu_args->pages * memstress_args.guest_page_size);
+			if (!p->partition_vcpu_memory_access)
+				/* We prefaulted everything */
+				break;
 		}
 	}
 
-- 
2.50.0.rc2.692.g299adb8693-goog

