Received: from mail-vs1-f73.google.com (mail-vs1-f73.google.com [209.85.217.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EF9204F8C
	for <kvmarm@lists.linux.dev>; Thu,  9 Jan 2025 20:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736455800; cv=none; b=ZuNeF0kHcG3asxd1r/ox1TEfQ1nWikYQqOBrgCwSZfxqg70YsEs9v7+EEMznW5ui5pTylIboOLe4ksi897tHHXLi947SMfJqIWp5JI1qRi13N2CSKwHfc2xQew23Ofv5703UJ7eZmgSN7KHqVZicvc2SZjC3c8aCMTqNvPImh+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736455800; c=relaxed/simple;
	bh=CmgtQ2eKueuvA0O3zOIgnVmBoSBMqtMP0Wab4N434t0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O4LRR6Vn7ZlpLj3BisDETdVt12Vu0/svCRceT/K8X4PnPaalpAzLmRA+D/S05u3+DUt6+81mYoSAZyTkyc0YwPydZ4uMsKwsQDSV0+FF/pdhXmrC+U5WLAgKg2Z9jYnzhZ0zE7a1U23JvA/2jf6beEorhusBCL4OSVkzKvWazMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q1kBfd7a; arc=none smtp.client-ip=209.85.217.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q1kBfd7a"
Received: by mail-vs1-f73.google.com with SMTP id ada2fe7eead31-4afb0276095so232730137.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Jan 2025 12:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736455797; x=1737060597; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=inJmWA70Ac+hZHw9fDPSAlORU93rduBYUNSCVpvyraE=;
        b=Q1kBfd7aJcpuQiUP/YsrX5st9JAWw1QpuBnFnaIXgQ/T7Kc7/YA8KGjeFhr7W5nSba
         RKU94snlEkCb9pc95GiuGGPOrCuFv+36W8wcHRZZUtEuh08JetvzuzN4YpESxoi+VbI1
         N5V58b9FJSD6BI6Hi8vvYfI/KzxpmwQuS8SXjjyOQHkTTNH0ZqKnOH/X72s/2KsSt1rC
         oeKXASCmSdmZPuYZZ6m5TT+KgOB+EPBBXKKGdhPXeAdsXb3xf6ZR3HcdgR/tATJF0dZF
         abKUA3gSpBBVXfUL4hsAtQN3uZv91cWM1GF/jEBOpPKklBk9JLeyc8zQoNtkcoeejF1S
         Csjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736455797; x=1737060597;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=inJmWA70Ac+hZHw9fDPSAlORU93rduBYUNSCVpvyraE=;
        b=Xxi3yCxIH9QRgrp9+qY8PUNTK7OXU8z9qI9oQAWPFCTyfCs9iRFNcctOvr6mBSrtYi
         IhhM/73eAG9Xd+QuvEKbDrNJIED2mWVKdx/35SMH432mZD62FVm8nSo5GYkQUNBhGZqn
         0ksGBCYflGtLDTRZK5OsqsL18V5W009Eka1eEnk2FtU0vb9ypSABRJwvfBCg16yk8Zod
         jbcPqUcoWri5UmFaozjD3JvFi0HYeQgMyMYwjuRFxy+654OPhFJ/fFSgf7URfao4CybD
         qyl3AuJVd8Qj+bpRTbn6gamAkA1+l1d35DuVkneYl8H6vUPfG3XlcjjXxG2G2T/44kLH
         whMw==
X-Forwarded-Encrypted: i=1; AJvYcCXfDQ2GJxVAdi3fZ8z0uFFh35wgIUYmd5vmWhnPojGnEhJINdOWcqBWLkS7NvKP+KGnh2c6bro=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw4DxfY/A6e87Afd7rvh+JYDxL44o32Avy9udHkILtbcu5ZX30u
	BCyZampCNanyMzX0/UikfhtcBwZl5IC8LyLFaOpUBqoYybNq/TukFkytMIfR6r5s/WSMnrFWVsX
	0bOAULCQe3ED10cP3VQ==
X-Google-Smtp-Source: AGHT+IGmWC0I9uhGcwdr2Gd8ZWKOxj9FqNl2pt1I3pHNzlZaCTTUBXu0xZZz+qkK1VqDCdKw56Aw4mYDSrKY0XUr
X-Received: from vsbka9.prod.google.com ([2002:a05:6102:8009:b0:4b4:eb7c:c900])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:38cd:b0:4b2:adca:c13a with SMTP id ada2fe7eead31-4b3d0f05fbamr8311073137.12.1736455797065;
 Thu, 09 Jan 2025 12:49:57 -0800 (PST)
Date: Thu,  9 Jan 2025 20:49:18 +0000
In-Reply-To: <20250109204929.1106563-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250109204929.1106563-3-jthoughton@google.com>
Subject: [PATCH v2 02/13] KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
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

This flag is used for vCPU memory faults caused by KVM Userfault; i.e.,
the bit in `userfault_bitmap` corresponding to the faulting gfn was set.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7ade5169d373..c302edf1c984 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -444,6 +444,7 @@ struct kvm_run {
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_FLAG_USERFAULT	(1ULL << 4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
-- 
2.47.1.613.gc27f4b7a9f-goog

