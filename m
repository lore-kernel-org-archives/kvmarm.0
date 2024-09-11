Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418F01B9B58
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 20:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087367; cv=none; b=lGhluiN23ha26LdP/Ku532EC6cYPokfUM7x1+9siagzAvknp9z7b+YNwbr2dYTIZSryDiWNzxKMhdXDEvMwwsjOGejeQe36qK0Fx+CXI/FVUVwCU74X5gVd7cS3qWPjhFNWk3fXxi3BFRr/VSmtqQjCbRSpctMMjqP7fQWff5Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087367; c=relaxed/simple;
	bh=8oi3u31KxpdCNwifk0F+crB0nVZG46vd0de0WiqVC9c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gqz+Vqi73WBdq5LMO6P9QsVdqca6CXgB/0txOBRK9GJZSCGCHn3IiUtsnY+6X+yHjK0r37BAmSVRXOr9vT2XFS9BYwbJ4wn1QBXnA1uo3Omi7aygwHHcuXNJh1zYNkKGZuIv3iDnB8Vqp0zzU2Tbgu0barfAj6pHUkM6cR2GVaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BKdx9+Hi; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BKdx9+Hi"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-206d8c47496so5453165ad.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 13:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087365; x=1726692165; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hqBHipBEc9VIgDpl6wbsMWiAPCMzGAxUDsb/VQrQ1Fg=;
        b=BKdx9+Hi+V1IR3Jja3hOpZ0EBQKu3C2XwkDkmGE2dt0Z8/OXybUbCVRK5wY0koMhsq
         XIyl4b7l655C23J7Oq1UNqQJswQoYzMD9lgT2eXFRqFTBgDkBMwNHUpdDCDy4LonZ90i
         uuQ2kKjEWdvn576QXuNJ6CkURfXSDySCAltW/OjcnB8WX+d71tfmDv3NkTINbgnCNHvu
         NLVXUwCGFmrKTOcZSC0K2d4NTtoW6WsC/ydgRaM6H4Y3p4ic39t8sPDtYpkmn21i3ffT
         +qfZ9tngS5+xkMATqpxqcJyHZSmLgu/8Xe/c3JM5AKgzdLzv+NsjfynRDUhqwFHgH8ah
         m1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087365; x=1726692165;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hqBHipBEc9VIgDpl6wbsMWiAPCMzGAxUDsb/VQrQ1Fg=;
        b=sPL0LLM7kbXvfBeYCaSOaPArxWROKgpubqXOA/veHFpJOhUF5yc8nTmW51j8qWyHX0
         NC97RLbALzOmpKSKgWYeLcpv9fMclb9gYxdt7EUb/sNYj748dCp9iu9VY7I5e+mCFVAl
         yXu20/kEbAkpIIjORKoylxpcWXEISVPuBuykaAy8Nr9WprQhnkwfr7vme2y84IBp1Wb3
         slOp//45S1tgmwtBBJJNBTfW8DAiUI7q/4okBgujAz1LCsqZLObJzhGBZMOC3OonGDVP
         5JqrVT/VS315zK6dU5StgqGwlROJ+gdOE7lhthmQ8QBx0ahoLLqxpESaITBLTy0m0HfQ
         Wdeg==
X-Forwarded-Encrypted: i=1; AJvYcCUsqFMf5qmswhr9KnRbtRyj5TgPR4DulW9acGx5IGtV290YBIrebADvQWfuuOIMRlTNWDcN/f8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxM/MwC2cYWbBzrXW0wPSKRQ11j1dDv0kW6Yl2hqmwP+WvOOIwf
	nBur8Q3g2kw1pBroh7XmIDDbR7V0xVFx7JAPkX/xGcEegT5z9ivFE13O7r81xVD6MLxg7XhOa/K
	UJA==
X-Google-Smtp-Source: AGHT+IGFL4zTHrWHCMVM8aBCteHxHmYI7HhRHME2L0vYSDU/f35eVCRnBetmKBLszuGgfMu2jElNurnmeFg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f90b:b0:205:937f:3acb with SMTP id
 d9443c01a7336-2076e4768d5mr74435ad.10.1726087365359; Wed, 11 Sep 2024
 13:42:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:57 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-13-seanjc@google.com>
Subject: [PATCH v2 12/13] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
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

Add a third phase of mmu_stress_test to verify that mprotect()ing guest
memory to make it read-only doesn't cause explosions, e.g. to verify KVM
correctly handles the resulting mmu_notifier invalidations.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 9573ed0e696d..50c3a17418c4 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -27,6 +27,10 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 		GUEST_SYNC(i);
 	}
 
+	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+		*((volatile uint64_t *)gpa);
+	GUEST_SYNC(2);
+
 	GUEST_ASSERT(0);
 }
 
@@ -94,6 +98,10 @@ static void *vcpu_worker(void *data)
 	run_vcpu(vcpu, 1);
 	rendezvous_with_boss();
 
+	/* Stage 2, read all of guest memory, which is now read-only. */
+	run_vcpu(vcpu, 2);
+	rendezvous_with_boss();
+
 	return NULL;
 }
 
@@ -174,7 +182,7 @@ int main(int argc, char *argv[])
 	const uint64_t start_gpa = SZ_4G;
 	const int first_slot = 1;
 
-	struct timespec time_start, time_run1, time_reset, time_run2;
+	struct timespec time_start, time_run1, time_reset, time_run2, time_ro;
 	uint64_t max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
@@ -278,14 +286,20 @@ int main(int argc, char *argv[])
 	rendezvous_with_vcpus(&time_reset, "reset");
 	rendezvous_with_vcpus(&time_run2, "run 2");
 
+	mprotect(mem, slot_size, PROT_READ);
+	rendezvous_with_vcpus(&time_ro, "mprotect RO");
+
+	time_ro    = timespec_sub(time_ro,     time_run2);
 	time_run2  = timespec_sub(time_run2,   time_reset);
-	time_reset = timespec_sub(time_reset, time_run1);
+	time_reset = timespec_sub(time_reset,  time_run1);
 	time_run1  = timespec_sub(time_run1,   time_start);
 
-	pr_info("run1 = %ld.%.9lds, reset = %ld.%.9lds, run2 =  %ld.%.9lds\n",
+	pr_info("run1 = %ld.%.9lds, reset = %ld.%.9lds, run2 = %ld.%.9lds, "
+		"ro = %ld.%.9lds\n",
 		time_run1.tv_sec, time_run1.tv_nsec,
 		time_reset.tv_sec, time_reset.tv_nsec,
-		time_run2.tv_sec, time_run2.tv_nsec);
+		time_run2.tv_sec, time_run2.tv_nsec,
+		time_ro.tv_sec, time_ro.tv_nsec);
 
 	/*
 	 * Delete even numbered slots (arbitrary) and unmap the first half of
-- 
2.46.0.598.g6f2099f65c-goog

