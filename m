Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C647613C
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 00:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648987; cv=none; b=ht/rTd+vOkHEutu0jDWo47s3nyD08mHOvyxRQP6LqA7yDx6tMNkSM3ZxSFbbvw4pXscVMvxCQsG5tkTRfTjNSrSI0+T363WGXT5abfiU2V0PR07Ytvr/D4xz8XfLNBxukWWgxZfRGw21F6iTAvhaWBMLy4E6XnZ7/IQkrc9aTpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648987; c=relaxed/simple;
	bh=e0zqvQX4ZlL0fPn4DwqoWoLqJX7b6wznfe/Oj9KjKhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ONV0GdYwqGI5l9ngYHvxNaYTlkWZNYNxib2qF2V3zi7wCGGtOIV1jOsH00bH/I2ACHh/wzPxnczNQ9HTX1nyMN5k1le9IgblklRQAsWO3zie9Wg0YIHsJCMM5T3t1AWc4Fzspk3XVXv/UoPJcqOngNgAAxB5z2fssvp0w8mycg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0QyiWtDx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0QyiWtDx"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dc30bbb7b6so2411335ad.1
        for <kvmarm@lists.linux.dev>; Thu, 22 Feb 2024 16:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648983; x=1709253783; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=S8c8bYa8F6WSgYnQg5Ml3mIasYavsfmgJ65i8xz9FOg=;
        b=0QyiWtDxgCgly27dIQ90gvubTddwNTmX1pK2IpsXReZxA5jkDj6Co4ihretxPchU6K
         r6cP9aGIhFV4sfl9FzxtYK/bNEy4oMENqcpBPjddr0f2Al3UJ2WftP+ZrSNW/yz+v15C
         WoS9RkhxBf7PUhTkBPjxj1zRVV3qbQKL4XkyruzVGdjHTZc9KQIg26WAVOQzl50O844N
         sqA+UBe0dTmSp99sU5yQ/iIgXVVZ6cwnznSnRloMxOvFK0vGbPTn1SzRo7ZwTY7orxqx
         Kho0xOuWcYl56Y03Hcc8IcFgHSW1tVjFd+227PxU06Bgb7Wj4MNF34u4Ouw4l6hS2+qo
         +Utw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648983; x=1709253783;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S8c8bYa8F6WSgYnQg5Ml3mIasYavsfmgJ65i8xz9FOg=;
        b=IU2ajDHw7v02PsvQpteOd6bxQwf5QPM1DDarEf+flwY0EvuO+rc22qME3Y6qVbYkTx
         rk3snO5S3YsfDKNxoYzrHIPQDtvLbwedOwS5AIs7m9hdCMu2kScdg4BzSCURqjyf0may
         AXNKK5cfY7iAFIWpyqyxqbbZNuzshZhzW4QVjB5dFykc2AHkdm9DXmxf28pJfagFmIgA
         aPb46x1hiAfs17cHTjuqvQIPmdqpaIRVoR34CeuMOdhEBBffRvIEU2IodKVrZNCvgRY7
         b9H1Un5b0tv5WLVqeubutNQxXhl4YGXiedg0jh97HwtTOD5sBRIdhJ5Cp/fen41EZPay
         PQuA==
X-Forwarded-Encrypted: i=1; AJvYcCXRRVhsAaLgiJpakiXCWJYwp97f63HA08UEHWbyp33H9SNb13XCUoPy+P6Hfh4NyjKUNtMysUSA13nWv35p8CUC9gHyhexG
X-Gm-Message-State: AOJu0YxDjmElGIaL3+lf6UJ2LWCWbnSN1rRvs3rqHi5GxYWeX2QZ5mO/
	pnYsoUfXjTMbkRNYEY5D2TfNiGZ64LrfCXX4VV3KwDGeu+fgfi1DHBLxeXgv0L+gWz/BCpfgkVd
	Olg==
X-Google-Smtp-Source: AGHT+IEpcCEeeYEZT1g6/yIIR7SqlJXRiXUY/d+cOATbynjlJc6ZG004EnWI8Es0Ckg1caDaoicixhIztHg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2d2:b0:1db:d810:89a5 with SMTP id
 n18-20020a170902d2d200b001dbd81089a5mr26791plc.0.1708648983559; Thu, 22 Feb
 2024 16:43:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:48 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-2-seanjc@google.com>
Subject: [PATCH v9 01/11] KVM: selftests: Extend VM creation's @shape to allow
 control of VM subtype
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

Carve out space in the @shape passed to the various VM creation helpers to
allow using the shape to control the subtype of VM, e.g. to identify x86's
SEV VMs (which are "regular" VMs as far as KVM is concerned).

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 9 +++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c          | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 070f250036fc..d9dc31af2f96 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -90,6 +90,7 @@ enum kvm_mem_region_type {
 struct kvm_vm {
 	int mode;
 	unsigned long type;
+	uint8_t subtype;
 	int kvm_fd;
 	int fd;
 	unsigned int pgtable_levels;
@@ -191,10 +192,14 @@ enum vm_guest_mode {
 };
 
 struct vm_shape {
-	enum vm_guest_mode mode;
-	unsigned int type;
+	uint32_t type;
+	uint8_t  mode;
+	uint8_t  subtype;
+	uint16_t padding;
 };
 
+kvm_static_assert(sizeof(struct vm_shape) == sizeof(uint64_t));
+
 #define VM_TYPE_DEFAULT			0
 
 #define VM_SHAPE(__mode)			\
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4994afbdab40..a53caf81eb87 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -276,6 +276,7 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 
 	vm->mode = shape.mode;
 	vm->type = shape.type;
+	vm->subtype = shape.subtype;
 
 	vm->pa_bits = vm_guest_mode_params[vm->mode].pa_bits;
 	vm->va_bits = vm_guest_mode_params[vm->mode].va_bits;
-- 
2.44.0.rc0.258.g7320e95886-goog

