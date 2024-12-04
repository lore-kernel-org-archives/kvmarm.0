Received: from mail-vs1-f73.google.com (mail-vs1-f73.google.com [209.85.217.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2637A206F1C
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339669; cv=none; b=AodAZMUyQLATz6b92np3F82uBNxauFo9JCDZZHeryvUjmVHypt5nbH2h+pnSlR0kfSaZjZ4l5Ych9aOMtfRk55+n5p3joFfHzVVUNLWkZx/p3x5x6Fzo0weaTKdv09+VOMmCrjcKWQvVPPOJyXZesQAYkeiPdvTulwqzfLMlZSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339669; c=relaxed/simple;
	bh=DB3D34LMo76wSyQOQTjLpchEbwFt3tbBmtNUE1453so=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cI9ZUD2ZHusiuEVrPzOMhmnXPUSZi1aLgSXrGrC0DxaIMYVjIx0oY5VzqCbdkcUpR4KhneuDwbbhRGA+MWbGZZEhDynlTbvKE4utFCF23dioU66psUQcOLUFGPrZmMszsEjnkiTLBSAPMVS4OJIBYSy3LiXFj2aP7EDb5apsxOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2qDq3dHj; arc=none smtp.client-ip=209.85.217.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2qDq3dHj"
Received: by mail-vs1-f73.google.com with SMTP id ada2fe7eead31-4af01bb6fb4so8682137.3
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339666; x=1733944466; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s5zlVcABwgcAqDrk/hYCqATZ71WnZcE4eWZqt1Al9mM=;
        b=2qDq3dHjNwOwLDMJmd0jFUJ4dZTyWrQz4FoZBxvQ/NvODgXQrEhBmjtUxShau+v+fB
         GtRaQh0yaEOgIKaMAWF+ckFOO+3+6KmcvwV6WkigZ/MA9B7B7Hfzn6uCd4DLcyoIgzSU
         eHXULNYVEDH8hrR3G+RlavhuIGBvlCY+wBC+D8un73K/YJa0Y28Y7zy5eXWLj/Fzs8FE
         6IPeZkUwHxfGjidBLM1xSHJDUOz/vh9r2D2uFxqWCVFZS7gml+lW4PqYF8psnGQlHnNC
         /YfnfeomKuFKKnVEwcI9Bk+yS7ng42YP2rUMOF9QJDZtb8uqLSuSZbz+DBEqe7lJHx5U
         lOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339666; x=1733944466;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s5zlVcABwgcAqDrk/hYCqATZ71WnZcE4eWZqt1Al9mM=;
        b=r8QodNc+KiPVCg0BjJqrL5T/nl9XqvdtOAoOgGmuGD2G9qw0SagaO6Jj6lPQCBzZW/
         RZKqom6HVaZXPPidsgQxq7ZjG7pKffu8iy6rPX8i1ZJQDdHSjE22EIaZhuOBz/sPCDSn
         DgxbSrGQ6spUWVDaG/7l+XLaLZbd5VXST21yNzmqonMIbkO894v77zickRD+D7D0sgib
         FftlEevWV8AdXsa8R9/RbNJLgH02mbULdP67XVfD4C0AuG4QRTcoeK58vKSAbaqyhS3C
         6M91JJWLhFwXuVN+sVyVq8zD4h/tz4Bcq/H2/LzepyFKRJgoBeXGWK1gy/LWqW7uDBzE
         ob9g==
X-Forwarded-Encrypted: i=1; AJvYcCUnmFYfUtHoCfITw4gtQknw11YEedRJIP1FQWYGc2QTXvWKuPy8OlEQVXFyiPKhIljWwND9eGg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoUMO+chv0Ty80WFEoXm8IDVK6Y7NTRQOP389FF8I2cARc3+pP
	XvD8ct4t0T5StFkPWdUJtuZxWsqCSbAOxw23qBQguYfUW/I3Tm6pmxPQ3KQClJneKvQ/smNxdSg
	zT82ICPbgP5pw52p+gw==
X-Google-Smtp-Source: AGHT+IF2FEM1OG8guhI8P1BVhXWIFhfslfAcmBKz5oOAxjNRJSTj9A5XfYD8J6BgPkOCk8O5eB0FX2IaOdHwSH+I
X-Received: from vsvj20.prod.google.com ([2002:a05:6102:3e14:b0:4af:5a9b:90bd])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:3ed0:b0:4a3:ab95:9637 with SMTP id ada2fe7eead31-4af97243dc7mr11657456137.12.1733339666111;
 Wed, 04 Dec 2024 11:14:26 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:46 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-12-jthoughton@google.com>
Subject: [PATCH v1 11/13] KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
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

The KVM_MEM_USERFAULT flag is supported iff KVM_CAP_USERFAULT is
available.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index a8267628e9ed..d233cdfb0241 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -364,6 +364,9 @@ static void test_invalid_memory_region_flags(void)
 	if (kvm_check_cap(KVM_CAP_MEMORY_ATTRIBUTES) & KVM_MEMORY_ATTRIBUTE_PRIVATE)
 		supported_flags |= KVM_MEM_GUEST_MEMFD;
 
+	if (kvm_check_cap(KVM_CAP_USERFAULT))
+		supported_flags |= KVM_MEM_USERFAULT;
+
 	for (i = 0; i < 32; i++) {
 		if ((supported_flags & BIT(i)) && !(v2_only_flags & BIT(i)))
 			continue;
-- 
2.47.0.338.g60cca15819-goog

