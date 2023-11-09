Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C04B374E8
	for <kvmarm@lists.linux.dev>; Thu,  9 Nov 2023 21:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d62fM0iX"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5a7cf717bacso18736317b3.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Nov 2023 13:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699563825; x=1700168625; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qijOPy0ERXUhax/ZBRVntyygIlckAr4kgGgQkmlO6nw=;
        b=d62fM0iXx0dAJaHguBRlDoZSJlMTg1PxQ4nzfWnDwZ7uBZG6bLHDIua1Z//t8SCnE+
         1NE5J8UhZx0ol/6W1iq6RBzEjKc4PCOta7IJ1TO55VTbxALp77YOzN/QBLbqsi6A6tYy
         0ACNIYs0AK/9CaW3rWYk+fiN+xMWCT0v50/3PrXgEWI3oU5R2lWbP0xz7Vf/feii1miY
         D4lvvTRmc/CnprfMDnqQQa/gnPs25Z9L3OIf5D9eZhNR8ryGmgLSC/Lq/bDpFeWQCc1j
         6qQ9PGacPrlxzCshda/aI5iffCaTtfB7UzGmEStix2QzS3t7ubx/bW26wGkx665nuQq1
         FkwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699563825; x=1700168625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qijOPy0ERXUhax/ZBRVntyygIlckAr4kgGgQkmlO6nw=;
        b=E+rc26BJIf8LhsJBg8EbCocYMOVQJtns1stpELB3S7AZLqnEM2zArjttLZWxvDB7w1
         iizet6C5z9rSxVkg6Arl0Uziyrv21Uh/t3y/v+odLpLruN5367ZmbM7p0KAJOgs+kEi0
         qDCb/f6aITHzrDDXRm48prTwaJnEdvFNrKzrOB9BL/Rwf+EY8R6g+tocBlcA6w+QgTqI
         OUWvND6cLGhSugrE8vJMfhx8gR0MN/jI3kxFGRZ8eeq4xhdUm6aJ5/j61rjRSyS4kgOW
         edCXi1Uk0Fn7/M9bHnAhVjlHLEIjQkDUXTKOMU7OIb2TliDF12Lq5GKxBNu1jgMFwWDg
         SW9A==
X-Gm-Message-State: AOJu0Yw7oCra6HL85vETL6LPqek3mhwOJwj76U3nhoGzgoryWXbTZqKx
	q5v3Rn/GRRK0zwgEvOBcqMk7l/0zc08PfQ==
X-Google-Smtp-Source: AGHT+IHnmQkK4g0KoxqixIoEiE1OXZsGIcaGUD3aF5w4eY/4zuUTkKMYBZztpx1oc2DM9MDYdS3CIiEG7TrJVQ==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a0d:d78d:0:b0:59b:f138:c835 with SMTP id
 z135-20020a0dd78d000000b0059bf138c835mr167156ywd.5.1699563825368; Thu, 09 Nov
 2023 13:03:45 -0800 (PST)
Date: Thu,  9 Nov 2023 21:03:13 +0000
In-Reply-To: <20231109210325.3806151-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231109210325.3806151-3-amoorthy@google.com>
Subject: [PATCH v6 02/14] KVM: Documentation: Add docstrings for __kvm_read/write_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The (gfn, data, offset, len) order of parameters is a little strange
since "offset" applies to "gfn" rather than to "data". Add docstrings to
make things perfectly clear.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 687374138cfd..f521b6fd808f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3328,6 +3328,7 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+/* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
@@ -3429,6 +3430,7 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+/* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
-- 
2.42.0.869.gea05f2083d-goog

