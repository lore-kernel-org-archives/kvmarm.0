Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F22821D583
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 04:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220698; cv=none; b=Zl/59OZQKWGtoGjLMqHV71TjTssyISees3wiZoR5MsvaEryLapUtmSzo967W3DAKhMsJrqkm7G6QsnErBXsa3RBzI3NsSzDzAurwpRCeBj28xGZ2nPzGp1MdO+zndPRRCR++LFc13LJHc6KUweQ+fi8G36B+L0FP5zkIB7Cdx0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220698; c=relaxed/simple;
	bh=pBsXSmQz4NiPuEOYLkwfwEN5cJ0gqQwNFVp5scXJ8tE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fqAYlwD8xwpCEmyLx/d6iMyHOHLb/ITcL/d4/CxJCUNLW0xNrslIqQOHgoP3SdDLh3dx/GoxGzypvD2GAl5uxNcOjARArreNU+XONyoLAQS/okiUMmPYzzeQeaz3WY8ainJ26P7BLh7raTC7R4kJ7iK6Vn+1foZSJq8658at+wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XnLlgMSd; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XnLlgMSd"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2fa1a84568so325714a12.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 21:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220687; x=1750825487; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IPfdrb3qNj0vF7Vvj49qyj4bUirkHon/mzHMR4ThfgQ=;
        b=XnLlgMSdm78K3ipIi5n0uWP6N1s3a7CRBQppVBzt/QYNE5o0KJPEx7WVf/5WzyAJ7u
         uLYxYxReILVhFoOBr4KqobiuavGvDFSVW9J5BjoG4lSe7EuoRiCu7ySQ3v2QeMjTrg36
         54vmBvLQ/xQ7MPYrZd+zevFdU6xXPdRNIZMbUCJf42H8mGss+XA/7iaYCgkAcVPC1HvT
         DHF7S9YHxGUaxsLZHTWAfUjSMR99K6EhOYMd+GUY6OfGIGj5EqCfyuDuF4ZzKQrP3u1y
         MNDdzeZx+nr5OlHZccoEUiwJQDfeM6gRUuhU79O80r6qJfXIDCxrs/+qqmruwUVeh5zY
         ZXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220687; x=1750825487;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IPfdrb3qNj0vF7Vvj49qyj4bUirkHon/mzHMR4ThfgQ=;
        b=tDZb2D1/MOIQng8xmIRloF1A1a/2XNnWLLy2YpDjlfRiXh6faRCyI4tza7fL33uJuF
         GJafil/bxHDEpWMAAu0sQ71zBqdyHxe3ADH1AbsTjkljPOEfpIHXLVc/VyJzM47/n61A
         +8mfNHlBXS5sLP4rIrtbahMQPC1k5HKJoJqa8QQo0B9fPqUor1RCNxjvkBC5ujQ8nNg4
         CWa35w608WUryO0uGNFAVp9GlQ2lGfFq3ALaBUObbQK0XtPQhfGUU7q7CI7wmbdV1ndW
         l9jnaFda5jE0l0RWKCHDzlJM+4x1RpSstTo/YXvCDFdZcmDgk4E4mlZhDB2dh50Wp3b+
         7JNA==
X-Forwarded-Encrypted: i=1; AJvYcCUcp8YBHrGUdCWe+D3UTxQrEdi9VqoNIwhb3NLifYtgp3VOeb0h3kleUiRGnKp+8v+epOPD9BU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7qC84hxWRgNOaDdJNZnKDPEt0uEbTaw1hqCzKd3dlS8pYZd0e
	wod8cmkqwY6d/Vkuq6XtgsClBhRFmwi0YAn1EX5NJw8rPEhTqk/G+uQ0xWn8oMFYYlLyOlGgG4Z
	43ey0CSi1P7BaqbWhmtFucQ==
X-Google-Smtp-Source: AGHT+IEwWie/mYOzWzkPEMzzYrHW7iM/BMlWT3ZNJE+z50G+eg48u4nBoLAfK8Q5b1sDwPdBgQjlTM5R7I81KayS
X-Received: from pfbgt12.prod.google.com ([2002:a05:6a00:4e0c:b0:746:2524:8aab])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7492:b0:215:d1dd:df4c with SMTP id adf61e73a8af0-22003686bacmr2081008637.6.1750220686708;
 Tue, 17 Jun 2025 21:24:46 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:22 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-14-jthoughton@google.com>
Subject: [PATCH v3 13/15] KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd
 toggle tests
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

Make sure KVM_MEM_USERFAULT can be toggled on and off for
KVM_MEM_GUEST_MEMFD memslots.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index ba3fe8a53b33e..3f77abb257601 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -606,6 +606,35 @@ static void test_mmio_during_vectoring(void)
 
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
@@ -633,6 +662,7 @@ int main(int argc, char *argv[])
 	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {
 		test_add_private_memory_region();
 		test_add_overlapping_private_memory_regions();
+		test_private_memory_region_userfault();
 	} else {
 		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");
 	}
-- 
2.50.0.rc2.692.g299adb8693-goog

