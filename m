Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862A71BC2A
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755373; cv=none; b=toXYE1WfjSIP8yAC5f9dlCTTKFghB3+exosRIxor2q8Gvu7aZOXthOypxxkSGde/4ou7TVWMeSsCNCyT4+zxArMnJRYYwuJs03Sbbx7vMS+2Z5iPYyaJ1Jv7bVMgn4O5gFwMl/MY5TKgQY2S+JK+swMun7T3534tmHvv3rAQBJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755373; c=relaxed/simple;
	bh=Pl/WDPJJFpEGoonemEpYTO8CqOvLteUalaJutLV+GEI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=juz5h5sdYeUmerYkCLngDPqRoDbVmdRetSUgCTHN+CpSAq2D4CLagBvCa0ztdzLTv+YDEhDdaElebt0bBE0W4yXf1WLeOx5g4sIDEx7E9P5NSOPIJaOu9Vrv/goVMNhZfE9UveVTyAzP1i0/1Bc6WvI3HNmcEQ7L9wDey9TXlOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X9q2Fqyj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X9q2Fqyj"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2edba08c89bso354604a91.1
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755371; x=1733360171; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GWRtxUB7qEaUtLrlQ1xtfEnMmWvmcI3LuUmySZ8Q/Js=;
        b=X9q2FqyjQvdt+sitnMSgF0kWhDew5IYQIZO1e2EjmvXglkq7nrHuxfjKl+1xpzONXu
         eZ9j379Oqt/Tvu43i4+dG3/ioYZijMFYGLZs1IYgX5WSSw1unETVRweKEMZhbyHFfrLL
         Lnd+UqZU9p7lhkoaPr2Zz3oEaOUqmUNoOeQ1jEzeVmTycI9OH7F0a4bmk3Fhhv7RweLx
         AbV8yOfWPFl8QG0MkH10uZZpPkhewVwg5GHprZzvbpFMTDMqtIKD5WS6e5hGVsi/6Yhb
         qj5mQhWA1mn382Y4OXsb80X13DmL9fVbyuimAzt7/ojzELqr14uokGF+E0wWbhDvr7VL
         spwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755371; x=1733360171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GWRtxUB7qEaUtLrlQ1xtfEnMmWvmcI3LuUmySZ8Q/Js=;
        b=nQW7/R+aKp5R+dN+71ocnPVYnwECwH/ihvOrO+Z9z8BywMYDdEzQ4ZSK+ZQ1QpnR3d
         QV+9vfQCxoLo4gUzvhzKwNFolibMSAFB9XIZarThr3HTw3wqkgBL030IIbS5uuSm6D1+
         yGKwN7rbh4hPpI5yRGAZT57EIvZ/cUyIlyk+kJF+eb/ILjZolGV114dLoPzX7weyFvzN
         nvLNuIfhPa42JROIbDkeYdW9CChXP7MqD6XeHY+TeOBCSs9TDYNLOED87pRQhuBL1yfh
         zpTDDIshoxq8XGI7HRtdHtpqM1KV2C3oxjAex/DgEebYlkRnmn98q8OMj1ZA/NPY38Be
         i9gw==
X-Forwarded-Encrypted: i=1; AJvYcCWL2AFgc3NTWnsRxmDHdAoM6/WqW2IbWMoeSW0QoD259+TvbWI0DXECnKOlb2w+RtFb4lI30Pk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFeGEUhO459ovL4E/s50pMI/+qS2cXwOmrhNL28h6BaGMxdaws
	AISqzG72HLTFGUfED2z+6a3t7oTTonWiMYAFrrXKRccnDK9GOxMWOInSOvVlvtGrdbHf1P+oZDk
	S3Q==
X-Google-Smtp-Source: AGHT+IFMaJnuqI9F/c4uFlh6+NRFxIyg9v4WX4blDwY4PB6trx1cbKx2cypM7Azi46JxvUwmbV0z2d3j/+0=
X-Received: from pjbqd8.prod.google.com ([2002:a17:90b:3cc8:b0:2ea:7fd8:9dca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0d:b0:2eb:140d:f6df
 with SMTP id 98e67ed59e1d1-2ee08e9bd21mr6479606a91.1.1732755370916; Wed, 27
 Nov 2024 16:56:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:43 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-13-seanjc@google.com>
Subject: [PATCH v4 12/16] KVM: selftests: Add a read-only mprotect() phase to mmu_stress_test
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

Add a third phase of mmu_stress_test to verify that mprotect()ing guest
memory to make it read-only doesn't cause explosions, e.g. to verify KVM
correctly handles the resulting mmu_notifier invalidations.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
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
2.47.0.338.g60cca15819-goog

