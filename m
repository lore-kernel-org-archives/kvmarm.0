Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F333E1F5403
	for <kvmarm@lists.linux.dev>; Wed,  4 Dec 2024 19:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733339666; cv=none; b=WEDyEcOHt3q+jQRr+nMuZTO4Z0lgcxJ0mJtHCVO7vaa45J0HL0A4/QsdCCxxj2E7gtezop21lSo61p5vAz6dfuQTlWH9yn8UmxZBJ/gxJJBzsD230aPCApYobbTOHKIrZd5HvpIjKE3nLimBov4HdM5XYVgcEstNM+HWFr0o9PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733339666; c=relaxed/simple;
	bh=g0rkDGLpu4v+ug31ibm4fJibfbopHH42jmhVi9EOmqs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YgGlcwRjSG6zm5PjrYXmygKfOnIfOTbXoxNYf72q7AKZuUxklt9tCazusuAKemKyA/t8znB7QvMHFQhUJiaTP/9LsRFhIm34wjLU3MBcgFnJA44o4gLx+/Vco5UV18bwKzqo0NFh3LxPuEyURusSqlYzPD9icqxnRe/QYUasvS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lLS/iLtn; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lLS/iLtn"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-5f1ee87f67aso136718eaf.1
        for <kvmarm@lists.linux.dev>; Wed, 04 Dec 2024 11:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733339663; x=1733944463; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zFzCtU30qR2oi/Is6fdl592GY3fZRLXfeluJtZi8G84=;
        b=lLS/iLtn+9Usqm16oOE8DbAdi2AW8qixc9u5gT5TC4YhUXvxian8L+hAjHn/G62Pc5
         q1h32up6ZWNOMD1THrFBQgeNwawBp8hrbHKTXiIXmCImdTjDiCHzVPwi6KMkMGyE3d2i
         fEKOGpb6yYIMFKsPl0/QVZmyEwdoY+DkNahrJaIODbWyG4QXMENFN8ZVwqQZ7J3HHGET
         Cy7fbe7+xwqN7zwTXtblONqS1BRDA/uCKwEq5+Cjo8Fjs1+azNTxIKWO1Jhbg7hQUszm
         o/xycxK1MlmHcUyytMpXfghtZLO0vQtTRWMqzcneqQyaHa6pIQH1CncIeBVh33a6/L/j
         PfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733339663; x=1733944463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zFzCtU30qR2oi/Is6fdl592GY3fZRLXfeluJtZi8G84=;
        b=X90t8UO9enFKxxaqT7jvVQKjVBuh1nJZ7ci0h6ZiN1c+mepQTeA/Wmzx4JZpq7zimA
         14ZnRaPp6GOSCWkk1ZYCwv09dSFZ4hCAjK0nP2J5RFy+OJXEAj41GbLTbPy5KydsFR26
         jhLIxAz3c8MQ49gz+lQqVJQBTTpItDFvjlBIKXcEVnfsXgyPcadSK8t6tckAWFjcdm3r
         6wCIA0s1gl5oR+TBQ18GhvUs+ZjX0pPMflkHvJ1qCK55M2K3qDWS4LF5/YjpHfmnrOmj
         3nlUWtRb4JZWBxylICAo+7CxDZvgeZkgnJGjTSUry+0nrJ16B5JikBJpm74QRLY5UGuq
         6Kkg==
X-Forwarded-Encrypted: i=1; AJvYcCUP4QuJqbYKSOnDICZVXp3WD75YPlUQoOObembndgjfBFpM/gt3ERpkogFofKCIzdEjyz6M0bE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIElCOYJVAfP8BwNpDurT3h6joBNpBhOQ2yF3HETs/Uew2GtTt
	fpbgrNi52l08Dg8pyCJbvIBBz9dviS+icOnyOLJdPpzHLHEf5YwNDgC1CXdkx4+hgjJZ9/Ot5co
	oOmsbgm4aDidhE51IZg==
X-Google-Smtp-Source: AGHT+IE0Bvu2wb5sZ62wPHnkPebE9DLvFVJFuHpqNaMFqI9+9IIU97LvrniH728q/X5uxBPvfLsjs32/EpieLb++
X-Received: from uad11.prod.google.com ([2002:a05:6130:800b:b0:855:e8c8:6d6c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6218:2812:b0:1bc:45bc:81f0 with SMTP id e5c5f4694b2df-1caeaab608amr694161055d.11.1733339663073;
 Wed, 04 Dec 2024 11:14:23 -0800 (PST)
Date: Wed,  4 Dec 2024 19:13:43 +0000
In-Reply-To: <20241204191349.1730936-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241204191349.1730936-9-jthoughton@google.com>
Subject: [PATCH v1 08/13] KVM: selftests: Fix prefault_mem logic
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

The previous logic didn't handle the case where memory was partitioned
AND we were using a single userfaultfd. It would only prefault the first
vCPU's memory and not the rest.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0202b78f8680..315f5c9037b4 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -172,11 +172,13 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	memset(guest_data_prototype, 0xAB, demand_paging_size);
 
 	if (p->uffd_mode == UFFDIO_REGISTER_MODE_MINOR) {
-		num_uffds = p->single_uffd ? 1 : nr_vcpus;
-		for (i = 0; i < num_uffds; i++) {
+		for (i = 0; i < nr_vcpus; i++) {
 			vcpu_args = &memstress_args.vcpu_args[i];
 			prefault_mem(addr_gpa2alias(vm, vcpu_args->gpa),
 				     vcpu_args->pages * memstress_args.guest_page_size);
+			if (!p->partition_vcpu_memory_access)
+				/* We prefaulted everything */
+				break;
 		}
 	}
 
-- 
2.47.0.338.g60cca15819-goog

