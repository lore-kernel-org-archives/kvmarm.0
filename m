Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A658B2185B8
	for <kvmarm@lists.linux.dev>; Wed, 18 Jun 2025 04:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750220681; cv=none; b=SODcVijY2E8KhfkAAtEHYLVMjucmktk8/W+Z8J4/1Yy7OFIEXzuw/p4uxfXCCzk7ieGXtJEo8ECBXPjnyjWrv4wpeV5tyugMWohK2Pk4KZakAXe3DTgTGrwvsrkshDmZpfBiHhNOkyZFFV4uXnbE/j1qh2eJps9RLad2Zo6/Yl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750220681; c=relaxed/simple;
	bh=M4cA5QCIbC4IC69I7rkdIXP2+hXIfCYUAcCljeAUiHs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YSRGMQdMpAxL+1q+coaA/cjMjl1kop+TZ5XaRGO/AneJC9NvE7RmUIfft+Z3r2yljFxbXXtqxFnwLzDB1iEcNx9Fjvgb9ZZW395FlZktOrYW6qWKAPHpP8GbZRIq6+hFcg/yBZIdeAwAak4L63zz82Nv8isnX/sHiMHCvgNGxU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ONhaT982; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ONhaT982"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2356ce66d7cso105770145ad.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 21:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750220679; x=1750825479; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7EMNAB7VqggYskY7+oMW704PIZytljaHYvhJuoy4xGs=;
        b=ONhaT982bd6jlsMSiuurUDalmUKBKjcxUZZjui7U9XtgoLie9lLTx+BQHsreI9Kj51
         sAHIGEfikwWkzJjgF2oBZN8rRarZtQ0OO+z709Khp8sj8Q5r3GzyDyKlDNDkh/xJRzT/
         Cxz9Z41STE2Y51iQgHe4Bb8p2BWoZT5Fq6XgvFfqr8YvRbsmXVf1E0Cdz/TzcJ2VeHPS
         LpmaLxdMBEF3bj68YuZ5WrD1QNOMCEtMkv84GVDc32o+s9ypMruBqOEh/NGJdS0LktBi
         hlwRZSgmi/nTBZiYymGSIfRCt7twO+X7f8oCc/9ngFoXof5xkj9ZmId/boqAeT67iLh4
         /zVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750220679; x=1750825479;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7EMNAB7VqggYskY7+oMW704PIZytljaHYvhJuoy4xGs=;
        b=KUhhO6IT2oT3QtHamNvYMB3WMpgYyAMoSAsZkgo+oJiUUR9MCRdFCe9agY8tbB+u4l
         LXum7sC10qmYhQnGdb63hQ3w0TH4YVFCRZFArjooeWWvos8tPNTfEkeHqBhBE0BXbTFk
         PiAIEihjUYsZ68jvvi2UZqfUOfeRSwcODB8S6aDyHa9yfC2nHbkLw2LUbzfmoMLecUFs
         3H+u4rgOCpkFy+3G1GI0K/EQ03MqKHI6vziMdc4nmlydILrJg+Mw2yvcEDZaieS2TJUd
         ig2zfdVaeJN0Pj1jb3XkAN6a9BbC2ptZTRiKJnqfylwEfZj/0Kr5pXWPUT8wZxtKY5Vx
         EDsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVo/LQa2WeuIevPcx/l7D8nVGOWzJbXW/MroHaSWj1BJIhWaIEOI/8oSKca+6Q6yIMOZsuC9uM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxxSlNEV+rAF8xQ+qnRJb8qW6lS4VINhqmU0Zdep4UnP78K7GPS
	IhtcCyStEA2gL7XQGT8LqeQZED17IlbQp2olcwyjkvseqbY4mLFg4lgH9jSmFclxbbEMYey5pFi
	t1GQnA1/aP6fk1XlT1fQo2w==
X-Google-Smtp-Source: AGHT+IHf6vnwz6tnrJF7nGJhTQOliXFukjknoI4nKYkvX84klDeaakiCUnur6sPI4XGwPrQLqZt03lOgVrYxLq6x
X-Received: from plbks6.prod.google.com ([2002:a17:903:846:b0:231:c831:9520])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d2c9:b0:224:23be:c569 with SMTP id d9443c01a7336-2366b32a5a5mr279237755ad.22.1750220679165;
 Tue, 17 Jun 2025 21:24:39 -0700 (PDT)
Date: Wed, 18 Jun 2025 04:24:17 +0000
In-Reply-To: <20250618042424.330664-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-1-jthoughton@google.com>
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250618042424.330664-9-jthoughton@google.com>
Subject: [PATCH v3 08/15] KVM: selftests: Fix vm_mem_region_set_flags docstring
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

`flags` is what region->region.flags gets set to.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a055343a7bf75..ca1aa1699f8aa 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1200,7 +1200,7 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot)
  *
  * Input Args:
  *   vm - Virtual Machine
- *   flags - Starting guest physical address
+ *   flags - Flags for the memslot
  *
  * Output Args: None
  *
-- 
2.50.0.rc2.692.g299adb8693-goog

