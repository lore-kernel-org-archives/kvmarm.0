Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com [209.85.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29621207644
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339671; cv=none; b=tidrAxV95vVl2msBK5F42JQa+NuMl3Qy1svkWRrJZ79o+Xaw4ZORVUdgBHbk0t/LenohUr4Fc/vr9ec7N/nSIyuOdrEOuTS2xnrBoRsYWTuOzlDvMnjDczHoij00t9Pb8jr8FsEgbqvyVXl9KC3x4yl7Konh7diJ8kruRN2lsT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339671; c=relaxed/simple;
	bh=Jp+x9mfldwtvN108bvLRJrP/iKtS1pLZnKipgWETFWY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qdyNnzShy38dpwzydYKgohN1DehHn5aZMAJut6YYZ6CPZMb335MG+ACj1J7tAkq1qEZbZm7owCsnYGfSdgt80D0BGzFPIHsCKbce+NPYiSE6kqA2CFMaK1jC4i3RaiJ7tMsVwdjNN/+FS8iyJE1mesmb+UszMBJdNmDU+dOPKAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m7fkGTvT; arc=none smtp.client-ip=209.85.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m7fkGTvT"
Received: by mail-vk1-f201.google.com with SMTP id 71dfb90a1353d-50db8e947c1so30988e0c.3
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339667; x=1733944467; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X68RCfWU06ROg+bUYFUfNwQoohzZnJeYoYKE3JS2eGc=;
        b=m7fkGTvTORUEO09PSW7J8odyAGpz6SLxFyeRQQVOlCdADDDKINTMUpmU9U35SAkNj+
         BBzyEAkQTL7OopVP6YmYwVMPpYyNCmrhRK1ihtS28AC5WV/03/nlFGZ5Vt3sya3qaG7K
         7SCUQdLlFdhrmuyTx/imrT9d2dc3t6MSfWnxRylcKh34wXqTXhiMEioVMydQbE/faryT
         P9TDLFsfH5NntfTICS5g6se0vXwHNuS+3ASHIpcDFSSIRVvraIbaZPGFeiGSxyYrZutk
         v5UdmuPNp908EhOf4BjsQtH6/D7FusSbcu3U/Gvx0MW/nLd64Y96/qOvxvH97SVYA2Su
         08Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339667; x=1733944467;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X68RCfWU06ROg+bUYFUfNwQoohzZnJeYoYKE3JS2eGc=;
        b=N1GlT8op1x2CcKxgpEA/jbC9ngLi2Qxaqzjb0pSTy/fneZOnPw+u5WEWkM6WF6CIfs
         1ADx8QfhuaCr19nmF8jWVTPu+L0G0Q661DjY9ZD6eoDo0J/es0VFxXrf2x4Fp4kzhMKg
         zdpffd+Pdh8X91shDeknu1rteUefWszjn6o8LjaOK9A8Eg2ypdWFYtD6pzlQC7UWyrjt
         dvye2JDxZHHx++se01UXTIzdiWfTxdtOP+D0/r6jz0BiBSZ3HoDZjbHFGdUj0hHgeohM
         Hu4UGrKAg+e1S4DGvwqJZ0DSmUF6PmYOjVqb9hPAnb2mnIY07uBLkfTi+ds6s1ka1i4t
         Zv3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVcPmGIzZ94apWfFgNOjEWFpqqu48RhgZOyzFm24kVjxY55Ph0MXcWqmGU2ADH1KKjbg+1qujA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzwMO35vUXbkAUOg80lr7AAomRrUgxDqljPayAhbjjo4mEAmM5e
	cYkJuCT6gGmD3D++f/eGAmpwDrsAFBFeU+PZBz51HakGAbOXvXoY5lHl6P+al2ehaYBXeH2Bfhv
	aO0MdbHtjKw6KgcLuyw==
X-Google-Smtp-Source: AGHT+IGSL6/LfQGJ9Uj3DkWwK1IsrYPhpONzXFegfmhrDCtj+kw22erCa4lpakX9RjG5PxsHges9rOrFeGcBxOQ3
X-Received: from vkbr6.prod.google.com ([2002:a05:6122:6606:b0:515:3ac1:ec42])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:a25:b0:515:5008:118d with SMTP id 71dfb90a1353d-515bf2a393bmr10094302e0c.2.1733339666972;
 Wed, 04 Dec 2024 11:14:26 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:47 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-13-jthoughton@google.com>
Subject: [PATCH v1 12/13] KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd
 toggle tests
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, Wang@google.com, Wei W <wei.w.wang@intel.com>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Make sure KVM_MEM_USERFAULT can be toggled on and off for
KVM_MEM_GUEST_MEMFD memslots.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index d233cdfb0241..57b7032d7cc3 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -556,6 +556,35 @@ static void test_add_overlapping_private_memory_regions(void)
 	close(memfd);
 	kvm_vm_free(vm);
 }
+
+static void test_private_memory_region_userfault(void)
+{
+	struct kvm_vm *vm;
+	int memfd;
+
+	pr_info("Testing toggling KVM_MEM_USERFAULT on KVM_MEM_GUEST_MEMFD memory regions\n");
+
+	vm = vm_create_barebones_type(KVM_X86_SW_PROTECTED_VM);
+
+	test_invalid_guest_memfd(vm, vm->kvm_fd, 0, "KVM fd should fail");
+	test_invalid_guest_memfd(vm, vm->fd, 0, "VM's fd should fail");
+
+	memfd = vm_create_guest_memfd(vm, MEM_REGION_SIZE, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_GUEST_MEMFD,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT,
+				   KVM_MEM_GUEST_MEMFD | KVM_MEM_USERFAULT,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	vm_set_user_memory_region2(vm, MEM_REGION_SLOT, KVM_MEM_GUEST_MEMFD,
+				   MEM_REGION_GPA, MEM_REGION_SIZE, 0, memfd, 0);
+
+	close(memfd);
+
+	kvm_vm_free(vm);
+}
 #endif
 
 int main(int argc, char *argv[])
@@ -582,6 +611,7 @@ int main(int argc, char *argv[])
 	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {
 		test_add_private_memory_region();
 		test_add_overlapping_private_memory_regions();
+		test_private_memory_region_userfault();
 	} else {
 		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");
 	}
-- 
2.47.0.338.g60cca15819-goog

