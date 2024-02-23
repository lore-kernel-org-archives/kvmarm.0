Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35ADB10A31
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 00:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648995; cv=none; b=i5N+Di/4Qhq3+eobkm0hCxuxZDj1+dBHDAzcBPOeoD2AeUyr1IJlAMXRX3B/YmAVdrwP4820c86uiXNIZ3K+LU9Hwv2T1kyof77XT8EeSkUn2M0GZIgoWOjHVi7SFokRh/gCWMAgk1NvkUT8jDp0qVzvSdJCgoVowrRkHOLmFnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648995; c=relaxed/simple;
	bh=EB42Jl+Du5RKKydkq6dHRGJLTaF7jM5r9fOKhUyQo/g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NCODju+FnLP9ax1IQQXUswkCUuZoUv87wnqieudD5ZTFw5Rln3kJwogrbnrW0L826IT1S6o3p06eQ7X/CrQjHjVvKxg1TAjj7saLxX217SBsDhC01jz9WCKo3ZLu6hZXsAEiyTx2nolepu7ap+Q8hLzzh0WJzHcHg2eip2moeDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0xMZbsyN; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0xMZbsyN"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5dcab65d604so242261a12.3
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648993; x=1709253793; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VHEHpfFT3fq5ZUYVbA7KHyxL3TWLbo6jAAmdD67Ha7M=;
        b=0xMZbsyNzy3uTtk+zgDjnH1ZduVv0562V3mBOpRZ97kRWP/tbAqLXYkPO0nhDg28A7
         gqsRhxnv8KN1+GooN9dEoi3/yGt82xNvCqdwLUU0SJhwySQyBTeBjDp2AUgzIZkh/OtS
         7uwU9hCW5SoyYjRPnqHc+4D9P/cEXDqo+TO5iN38hf3Ip0wchDlDlKeN419o7OApBHNA
         v1fCxQuPeyccdcaPPHkkTo384ala1LCrvyOEY1TN0WG0ax5IMT1m+cePTZhTC/is2O+o
         m+UlrbZShMVaAnq1w18DJqyJnb4ldGVSAOVv2NsEjI8YY8R8Iz/M7pgvMa8rCcErhs/z
         Codg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648993; x=1709253793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VHEHpfFT3fq5ZUYVbA7KHyxL3TWLbo6jAAmdD67Ha7M=;
        b=vmZedxo9RoLNob2WZoz96Dv+m7CYifhtdgejrHe8CwTGYXjrhTlK7LLBSf4AVDtVUq
         AWjoKXBQqS/FsEvsVxV5KA4FbN+HaLoDG5krSJuuEJa4KuhHW+VrJpF6NPhuBmrKdnPM
         nZF5MKLt6uQ7UpKC7qtZghe1y5ujk5Jh/GSsd7ZtLKxZcSZWwnArFYHnVoAackuAq/Op
         CiaeoI0KxrQHg2XuOCD+Cn6MXIDSdD2svImZ3saoglTCVKhXLWeUDwCn0tYFPEyEpzEx
         z0Hpcqo+HUK9AMkkdM+OfRjggN5+DcYzykTo96a4e4fa/dVsDziUBgBLEHLGtflxSAyZ
         f32w==
X-Forwarded-Encrypted: i=1; AJvYcCVPHB5GB/jXU2wx9j0ie+Pwptc+zInne6+iT0SO4WtIeN1ZWWPLR3AeyYpU4N0x43RHGXU5sMsmVtFIi+NKlWtKOBV957Y2
X-Gm-Message-State: AOJu0YwHGVb/CEvk+gJWLQoFeY+u8r/T0p39nWb/k0a1wjvRCHqme/Hz
	v50o1LN7Bs0jeaAJl347IQpsoqy5OnS2KfUziKGRGQRRjeVQ/iqgHQLi8iDThOG/SgJ7wvn/XwO
	Bow==
X-Google-Smtp-Source: AGHT+IHOzHa69AmDUbZ+OQC4gdWd8eKNcA+4/Rl+KkHknT13uIbfHPqOmsB/BAUR4nyvpq5uPcFzKjJ/Uj0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6d14:0:b0:5cd:9ea4:c99 with SMTP id
 bf20-20020a656d14000000b005cd9ea40c99mr900pgb.6.1708648993312; Thu, 22 Feb
 2024 16:43:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:53 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-7-seanjc@google.com>
Subject: [PATCH v9 06/11] KVM: selftests: Explicitly ucall pool from shared memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Gonda <pgonda@google.com>

Allocate the common ucall pool using vm_vaddr_alloc_shared() so that the
ucall structures will be placed in shared (unencrypted) memory for VMs
with support for protected (encrypted) memory, e.g. x86's SEV.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
[sean: massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/ucall_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 816a3fa109bf..f5af65a41c29 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -29,7 +29,8 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	vm_vaddr_t vaddr;
 	int i;
 
-	vaddr = __vm_vaddr_alloc(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR, MEM_REGION_DATA);
+	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
+				      MEM_REGION_DATA);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
-- 
2.44.0.rc0.258.g7320e95886-goog

