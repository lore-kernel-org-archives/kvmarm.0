Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1081BD503
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 20:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087359; cv=none; b=hTy5t4EVef/qiaNCHBDMVSUmulKi8DQXboJx3zU+obVZFuOti4bZs2K4FiC6Cy3JjRzF2j/ECfhM82V16tkWHzSqn27FzVehmg5ffeaa5uFVJuHtpP+QPngymtswCnsbJOH0PQd1HQXFjXTKSFCY71btSDYpeTahqzdYR41OFPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087359; c=relaxed/simple;
	bh=fr34CVsgL2g82sb+1gvS8yCzrvuGG/23h2+dDn8u8kM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KgM5+Q+1E4osE83St/DuHgZbCCglBXWoXborWltcl/EeEmqAy/n2ZJ7NMIFkgBR7n/8HFrVI6qrG4LCmIOjlL902jAKQzqAyO+PxgpVbisJp8PiVuTPJT2W0YcLPSBYG7quyuDiWNWkv2J9UEp/Dp5J+J6m+Q4EVzRo6f7MdpX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M/vpPZvK; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M/vpPZvK"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e1a74f824f9so704799276.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 13:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087357; x=1726692157; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=47BQJJiikboIPrV2PD33si1kPUmickrZ0k1m7wYEIK0=;
        b=M/vpPZvKtJSpgR3Q1dnkgMSYo8pW1mo4Q+RqPabZbjCkuEylrSaEf9+ckkVMGZpmIj
         Ou/fB+NQySAyt1/nFxF9ugfHbnzfaP2+TQR8hIsASQvTfLpRmoBGcLZC9SB8/EaBY7/y
         oX9RRaL6ZlY/p9/OmgOiagY202dGZsCP2tmHbkhaK6kdU9morw2j4nDIg8MTn9kwwnzM
         7QygVxGZgoCKSIoGoGQwBbGD64PD6c1mrBbfLL8L6PaK2i/6Ns2B8hERuBTiRatqibSX
         gIrT0jXIfDG6KecCAoCj3ivHW8aWYwQJykttJnwi6n1rKoR/PB5himlJ6p4cQF7f818p
         WUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087357; x=1726692157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47BQJJiikboIPrV2PD33si1kPUmickrZ0k1m7wYEIK0=;
        b=J4a2Wpg76sSGO5P1AJepfMRkiwfTdLwG9PQCdJTjoEkcsiXEgwPyK6GORzefVmCBqS
         1scjThoL7z08oyCEbkxEkNUrQp7brrxZ0maW5dPhFzXmTfF7xDpErIt7khyvKYimEBrM
         VwIbQagQBJRHknIxIO7QXHySQILg/ygLV8r2L6oafljTc1dBmZVaKrUBkA+yfAAVPqtD
         yDNUJvOwEhSGTQZfOazjQ6oeq9+dRJUgVcC7C5W2n+GftJ245sRMiQAqwmMRWwlQ1MWi
         9yRqOnWOkj0DO9WrXGFdYSGkgzBKsUZRrQrAJBz+oae2lXCfjX5nkc6Wq++Aex/ZCR7M
         ne9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWN+OjH3TBddwbsw+tTchReEkYV/ncG7rxXNr/B3AyxMXYZoj/8jVdwdsLugSX6JbDMbCRjTD0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3Qr/GvaBpzXqrxGd0LhHM4sEA47uJHRrhKMNWNZnfu0gKFkUx
	KwWh+EvmSRznnKACrTID3N4iKLaWd2wGH+B0r+uWmCc2COgiEM2hkf35DBAObp+84xCQo4V4K26
	8HQ==
X-Google-Smtp-Source: AGHT+IGKCOrdvuPh1JFZJTD4VhxgbmNdEtpijYplyDxOyPTYxT/JV5RegfErX1F5y84KkH5DsNf+hpV7TUg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c206:0:b0:e11:7039:ff92 with SMTP id
 3f1490d57ef6-e1d9dc6f379mr708276.11.1726087357418; Wed, 11 Sep 2024 13:42:37
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:53 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-9-seanjc@google.com>
Subject: [PATCH v2 08/13] KVM: selftests: Compute number of extra pages needed
 in mmu_stress_test
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

Create mmu_stress_tests's VM with the correct number of extra pages needed
to map all of memory in the guest.  The bug hasn't been noticed before as
the test currently runs only on x86, which maps guest memory with 1GiB
pages, i.e. doesn't need much memory in the guest for page tables.

Reviewed-by: James Houghton <jthoughton@google.com>
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
2.46.0.598.g6f2099f65c-goog

