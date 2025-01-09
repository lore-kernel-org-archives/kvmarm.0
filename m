Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F276C200BA8
	for <kvmarm@lists.linux.dev>; Thu,  9 Jan 2025 20:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455808; cv=none; b=b2WtkifZZ5M9TzIIHeADUedBpcBw512lZeIrLQOPx4+nptNjB3tf7lCSZC2XgDVQdRLpAm+w1bXA4O3qnQjTvwXMAqF99BENTqMe3jw1mEYgONb/1hI0UJ0ZJLOJ5iMco7UGEUlHa5jDD/s0Pw0HwTJmIDQgkK+bClp4dp/VWgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455808; c=relaxed/simple;
	bh=0eyMEtCsJeYENXDg27iZXcBn86i7IQLtffZKe3KbKs0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f3529iyHgGG2nKa57MPnr8hh9cRGwDTJCsshFzPxZZ2eSMTGPIrf13ZHIVTMJ5TqU1so65Xq/mCJIxSPBAyoC+4D7c2yF8IFgYRbn2OvmtCAM42hfNKVoyZsyBR6uSY1+eKiRVH/JZQeBAmqoge/+eozaToFKiaHcAd6Y4Jdh6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rDVh9eZi; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rDVh9eZi"
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-85bb64ec69cso198529241.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Jan 2025 12:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455804; x=1737060604; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A4uSddURoLEbUkGuIhSA7RvXzffvl1Ath1WbpEvQHEc=;
        b=rDVh9eZin2zKTPFwGqRN/0iJ3BBTnRRw5QlGvc70TGCHV3nUHY0O/BU/wpvJPD0o5B
         I/BwXh7E1u2smr/Xfk89OJGLMWSuFqtm9xmKLNzp6v0bC5aaLbAl/FZ7vWvk/3oHAahH
         3paRe1+k/GEI/rV8D/zBvvAOowCSKfQhxBAKJsX5uxoonaIt5NCat5ycjPbfgwxlteD6
         HlN3j4l+lJJJIju+hDGBC/UW//XllNxUW2rmdt3Hk2z30abZd7T8VycRirAiyWK58A1/
         eF8W6lfZxRUgpCJxZjb/6FIfdKtt0EjmF9YrcyVVlwu8CYRCZax9Ecacn3NMfq7DxUv/
         6tew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455804; x=1737060604;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A4uSddURoLEbUkGuIhSA7RvXzffvl1Ath1WbpEvQHEc=;
        b=ErS8XGxnM6rhq67PpjEP+0tdcWgfuvkZjwik1wPSSMt3tjj0jiaWrzjzKNg1ag9qoE
         fZ66Z36bO+njE5ZNikMtCBDaR+cofGCr4y5pNErG6vUbWPsUdamMLfgIwYeopynHNr5A
         LCg6ev+S3HGpLUhRkcnKx18I5tndrXtti5NWXuetXbED25/LNxbwcRei1dPGHnif8RsZ
         BpsjwpdB7S23o0dvHhivs9oTCeg5iRnhbi3wf0Bt3DO8wMb0jtWlYungeZCUuY8emclg
         VaFyzn4bH2NVWv58PYmG9quwznvQdfKWCBsfkZiEnRNATnblT94oCs5DQ8xjjwSAhPf0
         QV/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXFcrv0c/Kpw/wAgApPsH4hhhDTnUfZpEfL21JZrKVNbsnUTIMLeA9/s5GdIP+iod+aWA/O/G0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzDQu8LkM5zFoGgINl0XEHAXLymyl9SJhi3kzVMl7//v/2RSmgw
	JCoRIuYpBInluVIBvoHT0Z4bkAkSXu+nch/L1Mh780jOgG9Eij9PSQDY0tP3ztNrRW6j2XspiGa
	+rvg3D2jj1MJaqrU28w==
X-Google-Smtp-Source: AGHT+IHUcz3SJhDUBT3AFAphG25I/PCLrMSFE5oskoAYquhM4FPeQ8hRbnzHYl6jdbwhQgIl3dB0klJ9OTTcUSfO
X-Received: from vsbic11.prod.google.com ([2002:a05:6102:4b8b:b0:4af:dad1:fc51])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:3e20:b0:4af:e5fd:77fc with SMTP id ada2fe7eead31-4b3d0d75fcfmr8791219137.3.1736455804705;
 Thu, 09 Jan 2025 12:50:04 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:27 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-12-jthoughton@google.com>
Subject: [PATCH v2 11/13] KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	James Houghton <jthoughton@google.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

The KVM_MEM_USERFAULT flag is supported iff KVM_CAP_USERFAULT is
available.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 86ee3385e860..adce75720cc1 100644
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
2.47.1.613.gc27f4b7a9f-goog

