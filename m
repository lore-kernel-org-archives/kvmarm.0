Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E1E17597
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 00:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732755364; cv=none; b=sEpq1tJW6rHnjk6sLPThFPXryU8eBl9RPKQVPhup4dAoh+H9ALCFct/GklHOOW3HZgAGYV6TT2XBfNZgfToGt2su+5fyNUheQanATBemPGm5I/rb1y/zp87DFqeu3fXuMuzJIScadlzm0ArUG+04KHXgKtt+Y5H31S+qi14xTEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732755364; c=relaxed/simple;
	bh=EYB3L6b74MhfJrPzvb7T9WOOU7QX9pbOjbRmtOdicCg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sPL0eiqUciC5U5phs/cBSTQJJSCwaV/uv/hhP/09WFBz+iBc3NBkFAp2vdtzi5HtFJ7U4ekg4aCnND811sQV5WyYEdLDCVbvyt9Cze+T0i/4cnsu1c2FX7XDdbjHO0BAx0KEz6/YxvVRfspvpkWXsLzmGjbJymGzzDOEi8MCkh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fCOO0X8i; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fCOO0X8i"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-72524409ab8so327961b3a.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Nov 2024 16:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732755362; x=1733360162; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7/2VfJdiek5/ConUN3oh8Dq9U963aWvO6yCMgPFkp+8=;
        b=fCOO0X8i2rtBwYd4PRx+jVwhyr6ulUKhsT//f6CdM+S9E7TyDyTmg7uUKvMJkHBOsC
         NeZYNDxpZurmqifYYUcctI4LPueiVYEmk2rmeFwck+WxciUWQ/tKTWb69JV+oI4ZqtoS
         88iDh10kaVoD7d4xl7rqnjufUWJC/Ihrjyx6Vt4gC0ns4wKljokYLufrRBJFUgxCc7wx
         8WJ07qY3PiQsKGzr78Uyw3oQTSP9aMGOOcwf0jMdbXR0sBlj7P93GzcRMD2FAKVtQcGd
         I2J3EM5XyC/WL57Eb9s0ejIZtrZKhWaFakJQ11w902DEpc6Y4k3NCYISIEhMF5DZXjta
         Tdyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732755362; x=1733360162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7/2VfJdiek5/ConUN3oh8Dq9U963aWvO6yCMgPFkp+8=;
        b=sLVZhHVyTlNywhTux2QeGxo+RXMIvkqR0Yopu82xmvcCt9iOf8aGkliRvqW15nlBQz
         QfVaz7YiCsPyS0e+LC6Qj1xhsCDO9yy5qBW+rINLLQP6TxxAk1nwxESnLleTKedeRLsI
         1NDd97WFHWvXhcy4yoK30xoUsZRCW31LNbkna6Am27wlGcFyjUWgcnKLH1smF47D227B
         ptLZfPqQWw8M3xZvQGW9lir8SvZCaq8Qe4g8oyszGZkNXjO547kJo2SqH86iQr0oQpDy
         2+jLhnLogKNT5Wk+NKKwgUZ+wmjhKm/0Ch1/uX/oBo+c9w8cT4Rh/xHVwRNcov06g5aR
         3l1g==
X-Forwarded-Encrypted: i=1; AJvYcCWOIRsiUuXf2PopJEr77SMdwhcHC8ESNcjwVVh6ZSP4QfjFYr10ttCpXbioBjtWG4atWupKfg0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCbU8eft9TzdjsOU4BYrm4PZ7ICbH6czsTLjZtsCrBH0L2LpT1
	je2lhdaaYDyX/mfX+d4yiiM7sPfdo3po4vJpgp9SUvP2ZTpE9m4zNL63ssRHCxjRunqYje5pZ1S
	MNw==
X-Google-Smtp-Source: AGHT+IH/oCUXOezhQ0A565EEmfthxQY0rCc4VbVmqRSwagA0iA03VskT3jIu5Z1zmAcsnP7ZOJe6QkUN4cI=
X-Received: from pfbeb15.prod.google.com ([2002:a05:6a00:4c8f:b0:724:e5a7:e33d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4654:b0:71e:6c3f:2fb6
 with SMTP id d2e1a72fcca58-7252ffd753emr8477585b3a.8.1732755362168; Wed, 27
 Nov 2024 16:56:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:55:38 -0800
In-Reply-To: <20241128005547.4077116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128005547.4077116-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128005547.4077116-8-seanjc@google.com>
Subject: [PATCH v4 07/16] KVM: selftests: Compute number of extra pages needed
 in mmu_stress_test
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

Create mmu_stress_tests's VM with the correct number of extra pages needed
to map all of memory in the guest.  The bug hasn't been noticed before as
the test currently runs only on x86, which maps guest memory with 1GiB
pages, i.e. doesn't need much memory in the guest for page tables.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 847da23ec1b1..5467b12f5903 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -209,7 +209,13 @@ int main(int argc, char *argv[])
 	vcpus = malloc(nr_vcpus * sizeof(*vcpus));
 	TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
 
-	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+	vm = __vm_create_with_vcpus(VM_SHAPE_DEFAULT, nr_vcpus,
+#ifdef __x86_64__
+				    max_mem / SZ_1G,
+#else
+				    max_mem / vm_guest_mode_params[VM_MODE_DEFAULT].page_size,
+#endif
+				    guest_code, vcpus);
 
 	max_gpa = vm->max_gfn << vm->page_shift;
 	TEST_ASSERT(max_gpa > (4 * slot_size), "MAXPHYADDR <4gb ");
-- 
2.47.0.338.g60cca15819-goog

