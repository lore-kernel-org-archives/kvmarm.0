Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E721FAA
	for <kvmarm@lists.linux.dev>; Sat,  5 Apr 2025 00:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743811849; cv=none; b=M5Ft/RXDLB/V/fYuCiaL9MSixKA5joHG37pqCu/Ji8ChafiirKOFKNqQR5l/Cn3J9vJELeKrH2ykwisYo0PZtj3OhTruyf3OnbEKQHkjcELMH3ZwslY5gkJPD7pgLqR5NajRhKz9UBWRBxyUMncSXVxpPHBDvsxRPWwxtm1UXhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743811849; c=relaxed/simple;
	bh=eb9ivKenV6eSeMfJ8jsJ4zcf/HhA0ll43TAeZRApRYE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lBLsHWWkogDf5Z3qybC0sKyqfvkl7ic+Dc5Oe5M4yVJh7q92ZXBYZBIkFDTVLLe/v1O67LOZlIduyoPTjUrYDUVjIofQsi4Op0E6gcDtWQ7leQiQw6UodPp89F0NeSM7uN1Bv3MQCwsCr8UM18LxK+si9yFdH0PWYv3nyb9ZZts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r90zgMES; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r90zgMES"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-85d9a52717aso360125239f.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Apr 2025 17:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743811847; x=1744416647; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pe2bIRfllqLhJxxHpJNmnpza0I+tDqutdvnRlHikMBQ=;
        b=r90zgMESuY10E4gPrlnPKUiThsCa1r4ayO7zTA/DyYPY8Wv2NbdVQ+m2OO5+jCQpgS
         sP73o/y1HRqrjUvZlGdm1IDAlX5ybs3Ne9tsPMCtgKi9DzX5t5I4aNfc0HqzjphDPNRa
         WzB+/xwO1njpa7uxcrW4GZxqSTrU012mDGgN7lTPH8w8UwDeRz5Ach486tkQfI14R4Pg
         cOAmPXdWdAnHm1DqCKblinnvmM38qZ4nv1ti5E969Wyx+NsTdnvksj9NoFeTZ0DeFx5z
         q86bE9eHgasKTisuQcC1hU0o2vP2gTU6rTYNXKM9vm0aHukaVYrY/2ymOJFj26g1OdBT
         nJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743811847; x=1744416647;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pe2bIRfllqLhJxxHpJNmnpza0I+tDqutdvnRlHikMBQ=;
        b=WV+va9ULczqDVH8iJ0PIM1hWU53TDXkN0z87lvqy5hoaSUNl06SK8Wgp6yC7opOEt6
         YukSXNK8QV6HOFhexiy8qqVTf+NJtb0jinUejy6StB+JX/1yogt1a5vRjCyT8JxbuN+b
         nQvjq1L3thhOcUy++ZBnAdZstAWAuLthH9TuDRRmxodEgugnYZZ4nHQ6D6LVTxgx4SjX
         PbJNW3W3pX9lk91vwZ9cFGJ8ub08dF2v6kIToeC9nDS7OF7Ba13R6A3s3phnx1xWAK2o
         WcB+Tpk+Q4Q8tGIxLfUhnHQ9PkM8YZK7EtFVfZv1RpAi6B76Hp4dsqMYgMOTHOQ50ZuL
         ZCJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLvNgmIhxg8g0zIFnhY9wyISrCyzjDM0Gisi8QK0kv/P5r9fs6CBLrC/aHtGFG06CrsqOWm7k=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpsVcRDl5k4YHI+QoZ3C+saXXJ94o35ir/f2kd3Wbott7ganp7
	dCCwXEYyMoNlkoBwPhoGMdrb1QcwqtTbUxpAqIrLKL+YQDsaiHCL7xzoauSFEapmY0hrk9r4/79
	modCG8Q==
X-Google-Smtp-Source: AGHT+IF1StR86BOR3Add0XYDFbLf59K7X1ePZtATYMdVN91h6vHs+7fhLEgNJ0U//lXVpSgwej6JAhyyVci0
X-Received: from iovo14.prod.google.com ([2002:a05:6602:13ce:b0:861:1f46:a1e3])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:3a09:b0:85d:b26e:e194
 with SMTP id ca18e2360f4ac-8611c2f92e0mr488329639f.7.1743811846805; Fri, 04
 Apr 2025 17:10:46 -0700 (PDT)
Date: Sat,  5 Apr 2025 00:10:42 +0000
In-Reply-To: <20250405001042.1470552-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250405001042.1470552-1-rananta@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250405001042.1470552-3-rananta@google.com>
Subject: [PATCH v2 2/2] KVM: selftests: arm64: Explicitly set the page attrs
 to Inner-Shareable
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"

Atomic instructions such as 'ldset' over (global) variables in the guest
is observed to cause an EL1 data abort with FSC 0x35 (IMPLEMENTATION
DEFINED fault (Unsupported Exclusive or Atomic access)). The observation
was particularly apparent on Neoverse-N3.

According to ARM ARM DDI0487L.a B2.2.6 (Possible implementation
restrictions on using atomic instructions), atomic instructions are
architecturally guaranteed for Inner Shareable and Outer Shareable
attributes. For Non-Shareable attribute, the atomic instructions are
not atomic and issuing such an instruction can lead to the FSC
mentioned in this case (among other things).

Moreover, according to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte
load/store), it is implementation defined that a data abort with the
mentioned FSC is reported for the first stage of translation that
provides an inappropriate memory type. It's likely that Neoverse-N3
chose to implement these two and why we see an FSC of 0x35 in EL1 upon
executing atomic instructions.

ARM64 KVM selftests sets no shareable attributes, which makes them
Non-Shareable by default. Hence, explicitly set them as Inner-Shareable
to fix this issue.

Suggested-by: Oliver Upton <oupton@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/arm64/processor.h | 1 +
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 7d88ff22013a..b0fc0f945766 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -113,6 +113,7 @@
 #define PMD_TYPE_TABLE		BIT(1)
 #define PTE_TYPE_PAGE		BIT(1)
 
+#define PTE_SHARED		(UL(3) << 8) /* SH[1:0], inner shareable */
 #define PTE_AF			BIT(10)
 
 #define PTE_ADDR_MASK(page_shift)	GENMASK(47, (page_shift))
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index da5802c8a59c..9d69904cb608 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -172,6 +172,9 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 
 	pg_attr = PTE_AF | PTE_ATTRINDX(attr_idx) | PTE_TYPE_PAGE | PTE_VALID;
+	if (!use_lpa2_pte_format(vm))
+		pg_attr |= PTE_SHARED;
+
 	*ptep = addr_pte(vm, paddr, pg_attr);
 }
 
-- 
2.49.0.504.g3bcea36a83-goog

