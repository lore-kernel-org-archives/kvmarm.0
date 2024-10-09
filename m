Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8A1204F97
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 15:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489024; cv=none; b=WUu8pDxFOkwB30rlL9xypJL4grrsHz9Hc8fTm+r+gbR62xqRf9N3vA2SLPLLfZyO+E7b/gquZtWBKG6l5q6oCQjWANc/ZKX+tjOgrA99jN52bXMX8rnnMiPpRxqHao7zbyXl+ADB6RwV+PYFrjsMqbdK/mSdyJcAfP+uSJ9APyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489024; c=relaxed/simple;
	bh=L+zYpIw4P5/gRa37oTXv0c2QuaS7Yn3cq9MWxsxRKK4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l2kG8erQ8FkO59uUGTyPuDu8onczyVuW602/FqlMLVaFniJ9p64Ja7SKsOBqYl86rvmIx7QUyxn5CYyuOD4YANWvEajNjhJgdFIn8u0xXGqli2LzRJOxH5VE3iv31eqlUIphP9gKp+CALtMjfztAHuJvLfPokGHe7knPw4NZyas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kY5/mvwN; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kY5/mvwN"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7db9418552fso6250031a12.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Oct 2024 08:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489023; x=1729093823; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EGuxTu/doK/WQ641h0uZhH1HM6LHjGgjZS75tNbw6SU=;
        b=kY5/mvwNM92eZUbhQPPnInTjlN0K52bq3ehHxwlrfbZw6PNi164+vfE4UtaG+YEV19
         +jb+DUGg25xLfLQny9Og+sDd2ImtblHxokL2lfqI3cVqU/fCF4odv+O5xbi1fG9CBAfq
         nZUbkrSEXCr3bSbIPqEOEp8IPu0xtUNJaacKN97VpYN3XNagwBGk8JL7OdMji9z4bir3
         0TBq0rnGAPP4iTF4vf8El9a1ItZy+pZfMQfGoWtHyDe43POPWKt2T35yupvqqmxK0b0B
         MpnZ+xiWrZS02cHjB4UPCABaB8P7TV2TRj6K/sNF7YGcI2X3/gO+ZWjcW7Nc5mFXAR3r
         v1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489023; x=1729093823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EGuxTu/doK/WQ641h0uZhH1HM6LHjGgjZS75tNbw6SU=;
        b=qy3JjFusdx/L8Kpx83QhxTWf+M00qmmep85+6Z3oNT75TYNWL9NF0R986MLl/3U1Ep
         HlhEZC/uvnDNAXIz6OJz23SOfI8sj5wvZAMJWEhbKqWdLo9p1+V+5OG4bISfHTmY5PwV
         mZGCWky/ZB6T1DwX14I/YZ+j0HydhUcJK828KXVCi3W85sAEpb0FmirP5bb/4pR+ByVK
         I9+vSC2fKSAMQT+hao5GCS+tr1JM54U4M9zt1cRqTRD6lEfwP8y9DxQUwwOqzWBcyRqp
         9cvcMPN0IurKdBP0yPU5I5CLI5+FOTPZhgT97yMmY41D+Cuugsu4YL7FXnfw68U0S5Q+
         NRDg==
X-Forwarded-Encrypted: i=1; AJvYcCVHr6fKed82airGeXZfjMfUyVLuvJu5+IOBMarmzsFiv6ymQuK3GwHTVtllxBTYzzThWwc/O6s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSgpT47aSkOat6XomKLMO2LJ1BALbnLWBmWjj9CPgRdmPR7uMv
	p1WeP19I0IWJZnNvHN+4BbDSu32goSzvRvs1Jayyp1gKkW2x47E/LcoYcFusk3I0LR/aCZsvCHa
	/jw==
X-Google-Smtp-Source: AGHT+IG8czWnoykzOejAJo4GJw9hcMcaR/sDDZx+5vRUFyaEmI5qH9Oe9i56gZjLIllNwEPwjpmEWoICf38=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:704c:0:b0:7cd:8363:9f29 with SMTP id
 41be03b00d2f7-7ea320345ffmr3164a12.2.1728489022361; Wed, 09 Oct 2024 08:50:22
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:52 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-14-seanjc@google.com>
Subject: [PATCH v3 13/14] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
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

Add a third phase of mmu_stress_test to verify that mprotect()ing guest
memory to make it read-only doesn't cause explosions, e.g. to verify KVM
correctly handles the resulting mmu_notifier invalidations.

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index c6bf18cb7c89..0918fade9267 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -28,6 +28,10 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 		GUEST_SYNC(i);
 	}
 
+	for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
+		*((volatile uint64_t *)gpa);
+	GUEST_SYNC(2);
+
 	GUEST_ASSERT(0);
 }
 
@@ -95,6 +99,10 @@ static void *vcpu_worker(void *data)
 	run_vcpu(vcpu, 1);
 	rendezvous_with_boss();
 
+	/* Stage 2, read all of guest memory, which is now read-only. */
+	run_vcpu(vcpu, 2);
+	rendezvous_with_boss();
+
 	return NULL;
 }
 
@@ -175,7 +183,7 @@ int main(int argc, char *argv[])
 	const uint64_t start_gpa = SZ_4G;
 	const int first_slot = 1;
 
-	struct timespec time_start, time_run1, time_reset, time_run2;
+	struct timespec time_start, time_run1, time_reset, time_run2, time_ro;
 	uint64_t max_gpa, gpa, slot_size, max_mem, i;
 	int max_slots, slot, opt, fd;
 	bool hugepages = false;
@@ -279,14 +287,20 @@ int main(int argc, char *argv[])
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
2.47.0.rc0.187.ge670bccf7e-goog

