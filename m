Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A2F218ABA
	for <kvmarm@lists.linux.dev>; Fri,  4 Apr 2025 22:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743804427; cv=none; b=Slr0uD4j3bp74LoOWEZE1hRmz/ougVIeHXz/lUemi5aRAFqtij7ws1GNJGnzN5PEQIhOcWPurvmOURkIqd8b+f3ygbhKt1zo9pQNjr2B6J8dn7zDF2SIG5qwAtnHe3AVCO+xkct5XBzk/qejFiPvWcQQ2AKzN+URIUu8+4YDy1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743804427; c=relaxed/simple;
	bh=E4YqHNQ4gPeYFwy7PnyB6caqFhd7nH8+voL1clFcF6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Trqt3gG8noP3qBoP7WH5NEtUDnO3NRB2EgU6MMinxMJ7dkOMgkS9p8sb0GnNskXjM66qakcdq8X0zfEOA9SH2/4DlPWd/nCf4sWLf+5RpkukBcK67BEEX2/zg1QMBUZkVA5NiLjaTNQxoxfuS9X+/lLVpppxwnTJH8B2DPa4o4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2SnLl/yB; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2SnLl/yB"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-85dad593342so250249939f.1
        for <kvmarm@lists.linux.dev>; Fri, 04 Apr 2025 15:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743804425; x=1744409225; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pc9BIslmRtbzEaqCHxhWv7mDukpJW925YKmou2T40Cs=;
        b=2SnLl/yB1e1E/aO3hlNSkyN1dge1C5WarvTbcx2WFDMyccfaAmOxz+faCH1ShA+4lu
         nlqRq/UBz6yxqSQi8i0zbr/pu8XsXLu97MrMZIb6RvlveuHf5EWU3GJFWLAzWdAKjwI1
         dSoJW7BVWDXeiJN7Cb1HXywiGYZNc2bkJ5XhifUHQPMFIyBs/slhEix4pTp3Wxc8RNzd
         ZNjTkwzIeSrNNbr5vR9L7BcXkPTIPQePFkQyuQwDAQ+PkaePaVCMmvY5c8Jr5QiIpv23
         3gSft9LceKYG5IvBN3RfjGUlCmnizcecg0qrWPx5n3mCSyt4eBEAyn1zLugB04Q8pagZ
         BkjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743804425; x=1744409225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pc9BIslmRtbzEaqCHxhWv7mDukpJW925YKmou2T40Cs=;
        b=S/gF7uYmdL3/9eK2TjzUiultAUQ9jdPp1Flb0WQUuoOzXSWTlmMgS0iB1JjDPCc+sc
         1EvWef00Q3E5qXs/0PsQGlEM7hdubNVxYtHGo6uey7wT4HY+VZmSpiwyq4gMeOMKds9v
         6eoK/BualvKQaqwzwlfywurC8IF2o0UgfsisahTgvC0KVJYvs/pa5YseWVYdBF9tMW5A
         XMGsMZfNi8FB2KXFHThSeQZpqfwAOhaOdR5U3A1utPTjIKM19PbczgGdyNwM3QpaopmA
         T94nuzOqJKkebTWVI8ocZJcfCuvNU/wt5qXz9Z5gkVY3ryhsE4cimszJoEE5c/+mcQmF
         KxYQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7/sjT6bqwtiaRht3plPZvJ5wFu8K7aZSO9IPhdnAlSo0X9NuwdDZC6r16cBOZyKUN4l3Fwek=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6+S8WaRhOX+5aoMQKJ5u+0vb9SWc/kaYZr+Z1i0P0PQjjJxR+
	g7tMioHD1d9OCN+sd8I3aJlzOcRheytKCOctVTNKzRTULKKzup9cuimzpIxQpaBH7hncofenDq3
	EVZbEnw==
X-Google-Smtp-Source: AGHT+IHdes02xNhbHRa4hrCg2N+VywWvzx8Vq2+IoHciYVBDcUnJpNkQ4rg+6l0nOZiDn4tZhimhX6EbrE0g
X-Received: from iobbf5.prod.google.com ([2002:a05:6602:3685:b0:85e:9686:d0f0])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:6a46:b0:85b:46d7:1886
 with SMTP id ca18e2360f4ac-8611b49b398mr539039139f.7.1743804425293; Fri, 04
 Apr 2025 15:07:05 -0700 (PDT)
Date: Fri,  4 Apr 2025 22:06:59 +0000
In-Reply-To: <20250404220659.1312465-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250404220659.1312465-1-rananta@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404220659.1312465-3-rananta@google.com>
Subject: [PATCH 2/2] KVM: selftests: arm64: Explicitly set the page attrs to Inner-Shareable
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

According to DDI0487L.a C3.2.6 (Single-copy atomic 64-byte load/store),
it is implementation defined that a data abort with the mentioned FSC
is reported for the first stage of translation that provides an
inappropriate memory type. It's likely that the same rule also applies
to memory attribute mismatch. When the guest loads the memory location of
the variable that was already cached during the host userspace's copying
of the ELF into the memory, the core is likely running into a mismatch
of memory attrs that's checked in stage-1 itself, and thus causing the
abort in EL1.

Fix this by explicitly setting the memory attribute to Inner-Shareable
to avoid the mismatch, and by extension, the data abort.

Suggested-by: Oliver Upton <oupton@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/include/arm64/processor.h | 1 +
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 691670bbe226..b337a606aac4 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -75,6 +75,7 @@
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

