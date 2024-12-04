Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com [209.85.160.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E83F202C2F
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339665; cv=none; b=sO9jVdGiQrfSLuTqQNMV8iLRi7V+/ZufgCg8yNTToMRRJYhfSXvJWAfnrI/in2ojizDapIdhqmSZorITm/YZt74t7P80v0aaJXLZYz8sBQlvnpwDazszg8xujlzcVwEvMaf9Ya3x47UjWkerc4aUMlISHwTjk8bR+B5uFGRdyic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339665; c=relaxed/simple;
	bh=xFw8gMJXJ08WDMuWWWZTgPnAYLLdNgG37mOiDKQ6GfI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D+dq1PsvYWDuXjeUz4li8afmS6cWttBsV487svbEihRMkfEkPbAXcxXUjpoHk5s3PfONIYPtR1F9RSMXXVpbqsz72NR77Mg/6xM7S3zxZvJBOWMw6Oqk0y87pn8hc/WC1lgHn35SJWXg8+9RtffMnGShewH4893ugpr6wUE+YDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qb6/oV5Q; arc=none smtp.client-ip=209.85.160.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qb6/oV5Q"
Received: by mail-qt1-f201.google.com with SMTP id d75a77b69052e-4667932b9acso2018661cf.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339662; x=1733944462; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D0Bh/8/p57GgUO0KFv6z2qw3B4ssWvPHnpaRRwgHkKo=;
        b=Qb6/oV5Qccz4ZF39DxpWhjR78TEeXOh3m70CEweTa+ibwlZjniUI7pc6dTkptj+aJX
         WNCTtEOLX4aAnp1Na4HuWGr0ebWu+mN/CYS5ySo7qmqgs1lBnaZl9vCPCJuLE7IkR6lC
         0RLgvHCk4YZhDzuE2QxgIRFo/oa2U2fXssAZWBuoX9GnHNrPXwsAeKnkxtXV7essuItV
         UhK4UPVEMrmRTwIPF600wsJW0tRq509K8o/BQ4MAv4qFovMCjnBY9Sefe2VGXm0OPuz1
         zKjNuaeQj+18MUemGM7FK5I28JV7GjgtaJ39SYGGulpCoOojjLLdlSBnAGN4dQcHL7gN
         jZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339662; x=1733944462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D0Bh/8/p57GgUO0KFv6z2qw3B4ssWvPHnpaRRwgHkKo=;
        b=F4qEt50cyTnhvEZoK/3OB2FLaFQ/4kxQUL5+pjdBPodJboUAAXw2Pr0YOHmuQ4rJ4a
         4R9Q4Vvfeb3wk3WBuN6JeHb+wFC70tszcBcx49Rp3fn4J9LWp1GROvzWnpL7vOo++M2I
         qQ9BIiCbph5en66aHe7S8BLT+HqJDmbeR5U63/Zx8NZ19+ALt8WOW0LG2bA1EJPUC21d
         IVeup7BmRwqvbrsv6G8fQ1bzajhEmohtWUMpUR9OsNSGpHEBo7A/MhmtlBgSlN/sa/H1
         IQ9gv1zvFoAJjDMAwm8U0i4Fl6NhRsQy+bEZBKvI79MjjyeUGcfQcXdAFdMsM6hgMpKD
         oqaw==
X-Forwarded-Encrypted: i=1; AJvYcCVhFhcLzUwe7SE0ySB91Vib0WJS/us9Y2ttH8k08lOQg3Kb2aBTWNtfaNhTgsWbqe4W/sdbCk8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFAJ9xJi4aJFeH32F+3baidTvPUJUm6vvXD9tSJ8Bgmop8T1GS
	ZzPg30065m5I1B+Dnd60AeCNnNNu9ZmmkHKSyU/HqUXbX+WObiXdfjgYJfnCS+IpNZnMKNMd0xX
	/tTRB3Ie3hbyMQj2eBA==
X-Google-Smtp-Source: AGHT+IFL6Yzt0JAsezCjVnC1Ege7Dcb8t0Na16LNTuDgarqYjisKQzOlRXRbl7knWaQbVhi5EaZ6me/AizxIjPXb
X-Received: from qtbcf26.prod.google.com ([2002:a05:622a:401a:b0:466:a2a5:c51f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:ac8:7fc4:0:b0:466:7a01:372b with SMTP id d75a77b69052e-4670c0c1884mr95272281cf.30.1733339662158;
 Wed, 04 Dec 2024 11:14:22 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:42 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-8-jthoughton@google.com>
Subject: [PATCH v1 07/13] KVM: selftests: Fix vm_mem_region_set_flags docstring
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

`flags` is what region->region.flags gets set to.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 480e3a40d197..9603f99d3247 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1124,7 +1124,7 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot)
  *
  * Input Args:
  *   vm - Virtual Machine
- *   flags - Starting guest physical address
+ *   flags - Flags for the memslot
  *
  * Output Args: None
  *
-- 
2.47.0.338.g60cca15819-goog

