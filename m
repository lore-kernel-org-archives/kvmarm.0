Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F6A1BDA8D
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 20:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087361; cv=none; b=gx/Q5X7ZUydE4jWDCG0TQI5r/+7CVLZCWd1kxqJZkxYr1gTK9qF6W7+LDb1J+xEbGNN2zN7mBZfPRP0seWEFP7827fYp9VfEF531Q4YdOg7O4SmLSzAdJtHBzTMZfNJiAS8bVHsmhYwUkv+FdDiC3va/j74KVIAV84MMuCiWzYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087361; c=relaxed/simple;
	bh=gMePtUPb5fvMNYGIlnFPhk6LbY7QAcbzAoZpHwWYGO8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LAFKfazO/IAL4oLGlNL3aV7s/41ztRWS8V+Xcy/B2j25CSGfK2GxYtQFyKfPLp50oKQsUW0zM6OyAasWOR0gwwDoI5/J9EPKVZkAu0kvXxDS+3yfZNn9NyIgEv5OCrtqcPzZXu9ai+QwStKbAuc8CCqEhn+yYb5AWFTBNC1hKJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=h0p7s6ar; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h0p7s6ar"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7c6a9c1a9b8so547306a12.0
        for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 13:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087359; x=1726692159; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4Mm6F1KdfaC470dFwf81yhaZh6FdF3AX9IDG0p0k3Sc=;
        b=h0p7s6arxdjaRma0GR1IVhVF41WVS/uxhSF2YD8hk0ONuUElGqlCW5oLJWk4OLnuLS
         4Oz3hut59lHdZRRZXLPxJ+IJ70qZ2oQWi68BMT4YtNlsmd2t0YfkIw6HKvoLs09trlzB
         zB/m4eUgwB+9S0IGL9v00Ie4v0FD1z5x6cgTKf9EUpR15ZD0SWCWl3eYiFDjnPf1mdRG
         bZqUHX62IE7OZ12iT3Fyo5CMVsPtqdmnobSGqj/DW8w9yC8PbWJGpP2dYE5BsQxiY1b9
         bYN8MNNesavcGNElmbgCV32got6g/jvn9bSepAG8N6W8DPBzTV+urvoAkytVk6ZGyKFu
         iiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087359; x=1726692159;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Mm6F1KdfaC470dFwf81yhaZh6FdF3AX9IDG0p0k3Sc=;
        b=IenPZwLoYuRBHjglHYpyJYdluHgddKsN5vtkju8ANLlvvsToINLsNMd3RAOoPaPJwK
         Q9wTgsDEqAVAltOOD4KLO25Zqrjxu7qC7DqxFZF+Vb61xE7iy0ED4MJ9QSfdSAZBEi2U
         QDwhGq36clJPKLhY0IRfZ9cVP2e022ehq3jph27/SUMVChkMt6XYO8w5tLou8sdPRPSb
         DiZw0hsfA36nuzfVJ6ZfQ6/ppydy/RaT9SqUMcwK/ys36XKVooW9s2ERYfX/7M75egU5
         CEAeXWNocXKsFMdisvVyzY/SLHg4KEFdODUF5VMER3VgdxsGMU1Rx7lvjHCM7rwLiY9j
         n2qQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzYl+pyXjG7Myt8hMV8FADUZoGo9whPOUAoixVgdATrQ2UhKpu51HRzaWznzPrh0eZdAmyumA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/ZP5Wq7uVEkrIDb9aw6W9NsnynOBPq3Hh42Svf4uXcz62+tw5
	bzbC1xA6nmfeKKDyTW6KuPhD0z6SkOLxyHnTmM/aw09ZUahlWxRWAIBf/ZE+6I/ih5puCx2miR8
	DRg==
X-Google-Smtp-Source: AGHT+IH2JHcNsNqRshbivfFJlAxw7IQtkbHmI9wZd8VBGGSLJ0WTJqdKfu0VETV264VsvIEa8GzsVh026XU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:4a5:b0:7db:18fc:3068 with SMTP id
 41be03b00d2f7-7db205d627emr1361a12.5.1726087359304; Wed, 11 Sep 2024 13:42:39
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:54 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-10-seanjc@google.com>
Subject: [PATCH v2 09/13] KVM: selftests: Enable mmu_stress_test on arm64
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable the mmu_stress_test on arm64.  The intent was to enable the test
across all architectures when it was first added, but a few goofs made it
unrunnable on !x86.  Now that those goofs are fixed, at least for arm64,
enable the test.

Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 93d6e2596b3e..5150fad7a8c0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -174,6 +174,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += memslot_modification_stress_test
 TEST_GEN_PROGS_aarch64 += memslot_perf_test
+TEST_GEN_PROGS_aarch64 += mmu_stress_test
 TEST_GEN_PROGS_aarch64 += rseq_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
-- 
2.46.0.598.g6f2099f65c-goog

