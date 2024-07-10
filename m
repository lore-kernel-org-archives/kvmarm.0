Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AF016D333
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654979; cv=none; b=CWk2S6LALlmPfbvkkgcBqnEA8hw0KGdriyDLgV/lzqXia/4iDxluvPBjjD7e4O/MBuaSbTuOpMu9MXluj/CBDJwlCPMA0uebaVGkiv0zNtkuN6cj8Xm38htyFKYMRGeEx+kKKYRV8i4cHydDyB6+z8pcNLcTCB/WMKx5ANZYl9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654979; c=relaxed/simple;
	bh=iHtMvGL4vF0q+lVnlkIHLSBIYFMj+gNaWi3Gs2hOk8E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YiEQTOkPfUlMIGPAQ1VbkLJe33ZTHRg0xJ5duk7y2EPLelYz9mS283AwHeCR3rPBRTxPmRme9RXHPrmSxPb+ZtlWQICEFav063Rt4fF7infuOh5VMhLJaqUkdQXxBiAQCRtv576AhLfdqKrwfjXXomiphA0ec+TI+NsHuh8oaLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wTwAC9O0; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wTwAC9O0"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e039b77a040so476520276.2
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654975; x=1721259775; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=x2NbmmZjpjJMl8d0fx4CDZHX67FcpWijiAzz4EJchKg=;
        b=wTwAC9O0nm266QNYOr1c9CalibKNvoqQgoetmKVNBp/lTzADXyNlLYZoVVWCjMzjKf
         jzEwxhr9cl+V+9j7LQbFXidHqzcEly4RaZOp0Er/UDYbrYNolC5Ys4JJwm+1UFipn3Ux
         5yqL/61pzXxuJVuD9lmgndJenXGn/al8BTyjh1n+TXCC5dPMBy+OdpflAnvXixe8TshL
         hwabkNzpGI4GmHx1DjViz97FSH1sBlzBzucuhW1F7DgKom1a5gw6ldH5z711hzB0OoXw
         Mt2kvr5eVTE1ris0f2oKtIenrCbyLgu6YQB4aA87Kvh3C+3VOLb4Jp5uXcK0llFzmPZJ
         VfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654975; x=1721259775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x2NbmmZjpjJMl8d0fx4CDZHX67FcpWijiAzz4EJchKg=;
        b=SdELatunGWRY/4hb71uT0xyPTaQM76W2cp2uSj+g/NXmr0Bm4VmD94uXoXyXepvWhR
         L6UnaFiWj5juKeR4gH1H+q7cSIoS8xlYiLfVru634OV4QJ0+ZvQznhSn/m9yzQFYBQlm
         e1kh/EQtVC9f4ptx4T9NynPtRpzg9GMbaa6gM+6yqFffSQ4CI33hf0GjwJRvT/3KFE8T
         QNNqzJKZVv09B1EZREkvSYcEexR3A8Yiv7Dpx5q0Ynom/u0JdADv9V1HrakQd7fW5rnr
         oqcNDA4ri1vndiTvHnlkKbhsrEE0WbGES4TFIAzax+FYZPewKyofnvPeeqd9e0iWTFIV
         Y3WQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrU32keBxp+pV9h5eAV00vdjADI1ClM4hqbqFCJidUwSoEJL/h2S79suUR3JzRDRDdG4j7Nk/anN/OLn+fHruRXg8l9413
X-Gm-Message-State: AOJu0Yzo710dr6GxgHF180DmOXkRvTsVCCvw54efDcSnSjVlPyYvxnp4
	4eb7BHOywnYnPxEzxk6YeA4nEqHjuD82p7blcZNh/bX6Mdo7kq8iKXoyfLSoPm4Y0Xa9EKZr8Da
	U2212BLlc7fKsYnwKbg==
X-Google-Smtp-Source: AGHT+IHxJ11Jc4Pg7WkmO3SlYHVbY6IW+Wqfxro8+OBFjX0tT/erDtqX8VfrApEznbWBw0W1kCfLjttZO6MW2F1P
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:2604:b0:dfa:8ed1:8f1b with
 SMTP id 3f1490d57ef6-e041b039d25mr256249276.1.1720654975664; Wed, 10 Jul 2024
 16:42:55 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:22 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-19-jthoughton@google.com>
Subject: [RFC PATCH 18/18] KVM: selftests: Remove restriction in vm_set_memory_attributes
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Allow the test to run with a new attribute (USERFAULT). The flows could
very well need changing, but we can at least demonstrate functionality
without further changes.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 63c2aaae51f3..12876268780c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -384,13 +384,6 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 		.flags = 0,
 	};
 
-	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
-	 * need significant enhancements to support multiple attributes.
-	 */
-	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
-		    "Update me to support multiple attributes!");
-
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
 }
 
-- 
2.45.2.993.g49e7a77208-goog

