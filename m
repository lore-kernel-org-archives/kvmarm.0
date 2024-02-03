Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF709A32
	for <kvmarm@lists.linux.dev>; Sat,  3 Feb 2024 00:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706918966; cv=none; b=Cpa9/Wh/RGfqvMTCgCI3uzQY+kvo8ZvEsXG1A9ruaqNucc5qm6BKe9BvtvaStbSrQidHbAm1i+Zn1FYzOh57KtmuYqUfTh4nQONK2F+IJlXG2qRhzaPkUjWHXfLLrfHQPFqe6hLwxfVi5e8jQO8wZ920xQ56L0B9ovXFaU4diZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706918966; c=relaxed/simple;
	bh=DQsGPwFy3v7uPs21OAJ9r/tyAnYHLR0BBzOxzUXWZ6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nnws2YhLWxqIJAyi4Bo/KS7jEas+P6MtC3Zh5e/IJSv0ANZt/ngWLnSmsPvxhj5Ylc/gT0gPz1SJQ/30YfIzclgnmjXb8TvaAJPLFXd4o+eofkdxHOPHeVd+sTZu5m7ScPZwr5ne1PJlr8iOV0wJmO2B8iTOEaC1fr9mDL8ElKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QkRa2zEb; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QkRa2zEb"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6040607c642so51030907b3.3
        for <kvmarm@lists.linux.dev>; Fri, 02 Feb 2024 16:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706918962; x=1707523762; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OEEHd6q2TChurvVJ9QWQDtWt/fR7D+phxscUNFsCU/w=;
        b=QkRa2zEb8zTdd+bDcY92+ELrJFJesNw8Yg6it5smUi6eqN32Z5jiKEHsVU1+og+1tA
         oVMwC9COE65ohQ65+fPeD7/IagoxCPHwBVlwLhwHqhCt5qdiEC59iKl+6TXPuFWGtP19
         SmTNmITM688pUzTxDBzLE+rE9eZQ8eb6NhpbMIfy2vBmSBnLzQq3WWL7pITb5vogrrjf
         dei+OSmThHT3Lls7+QrjECf2gDyb3TUrYBYIN8EKa+GOVqD3+5kk1hyZSsZ/vT+VQhu/
         Q01EspAbbZtnFNmeTOk11iUDw82P8PM0YlGnEswph20hkV18s9Fn1ZKn7ABShUlubYUV
         fhZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706918962; x=1707523762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OEEHd6q2TChurvVJ9QWQDtWt/fR7D+phxscUNFsCU/w=;
        b=K4CnyNKdwdlDSK0TSClZ1KBs9u5mARbRX5w0l7uVbnH3JkZPHERQAFhwoFJya8fTcC
         KleXohjX3bsqO7PEm5opmULBuRNCu0lxuzMrJq+dhYTAY/Sb53IE47BEend7N0WX0LI+
         mN1GI31otH5t5zqdcGkCU6ihHvmZyiq/9ueYl0OG2jkJ+R+WfzP/U9hA5a8ZNEihXVlY
         1J8V5aAFeJxApxOjEwBO19LfbM8sxPRCD8nUmxDvqk5+WUEtsJHGPG3bRsdgX8ZutgVC
         6pWKLB3aW3SljZQTmaNtNbKXX9tVRwI6XGhwIaNqfBTgceaCUfxN23LsVmoYNY2WKFcS
         sQsw==
X-Gm-Message-State: AOJu0Yx4vZgj4SpGYGrjtASbhRr79l6+tC8bHubPxx0rCNMbNPYMOO82
	fNhatfx+tKJiq9F4IFYQdiRUgxC0JF6uGYtr8evGnKSqiR3mqXG+l5qOmXEmQMxnOVMSOWjfpTX
	Xng==
X-Google-Smtp-Source: AGHT+IEcnlTVvkgM/agP2AI7SK0XtZwpf1RNWRzpnYbOzQzjKWA86nEjOukuZ0+7uKPyvsge0rWvGPAYF88=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2402:b0:dc6:e7e8:caae with SMTP id
 dr2-20020a056902240200b00dc6e7e8caaemr1059362ybb.0.1706918962763; Fri, 02 Feb
 2024 16:09:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Feb 2024 16:09:07 -0800
In-Reply-To: <20240203000917.376631-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.594.gd9cf4e227d-goog
Message-ID: <20240203000917.376631-2-seanjc@google.com>
Subject: [PATCH v8 01/10] KVM: selftests: Extend VM creation's @shape to allow
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
	Michael Roth <michael.roth@amd.com>, Peter Gonda <pgonda@google.com>
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
2.43.0.594.gd9cf4e227d-goog

