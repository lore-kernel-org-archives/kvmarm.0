Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850993D3305
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292576; cv=none; b=uhMJFotcJp9FB63BNYKOPhM92rjL6SbGb/JCGA+A1VBnivsTGzKJhR0pfu7DJ5HypLza4F3qkEowekttzD/IqnStZSuMjrQeQ/CV/k5UG/KLyPpkoA9wOew2V/re6wkkwrhAEuDRmSFEZaYmtJlsD7hnk9VqqeMsOmfKNZT0iC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292576; c=relaxed/simple;
	bh=HBuFwboneQNMp7qglhgXk7alnCfDwtLSxYiguum4PxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IZatjSw+6i5yotsDobxWRCRMyl9exOKS+E58ZeHQC+IshVUiiv2uk/4eGpl6kKIglFNvz55H3aHpIQafJGinGKacnwFPDB942QrGQBFX0J/wGVOltJukQZuTXWPNQFIIO7GrumegYHSpjREhd/xtRS7FiCWPh5E7wLSxdPEKYZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=et0+4EVf; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="et0+4EVf"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-48576b309c7so1808887b6e.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292568; x=1781897368; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lI2FhZeVSW/rDbtlOOBPVMTchx/8Z69t0suel1yDoGI=;
        b=et0+4EVfgED5bHl7ixgu5ADA1meUgK9yjjpwLb55Kt4UqPNpJOhHy/0YQhy5A2gzXu
         ZdscsOCFQT3Qk0DRzIIYZ1pAEZSfHodLhemCGe1AA6Iz1qOdDzxeJ4GEybhTxKbx8mvf
         jd3ZNmAlNVh9OVNqsQh0nsoKvwtvJDqS9kMa/3pWwXRM/UcqT1YtkEBvcyctDu2EfpwI
         EQlAnsCPfFGPTBY2KyoECztG8rFh2eUuORS3Si34bX/j2m4940xtyFEzoe5kgzc4GCcv
         P0x+KzHXpzGQ2xGMuW0MhNaqiCQbGlKoUxYhYGoUh1ju/yMxl6hNnF2aHr5Hvjz3TU0A
         DBLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292568; x=1781897368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lI2FhZeVSW/rDbtlOOBPVMTchx/8Z69t0suel1yDoGI=;
        b=iSIHpncA6dcUiwlVPaSGxd5UySsCc83i7p4hL5gwUmFJzqLRioO7W56w1WSW1U43n1
         azLo0IQyn2zdms6dhJ74bt70b5gJZLiSOOJJdQtoVeT/pdqnH0fKmtY43hKgpaR4pgmX
         YPEcgu1ja8xNs1pzXDEJFRC2xm7pbLz5IJ4E+DglqUato9KTpYEuxyhAhqlBddgdmoOC
         bLmE/+Ft/+IWnh4De86UDzRDCXavoSWWA3eTw3kAp8pQsptH6Iw7BFv0mcCEMlNTdAZ0
         i3w/g5WxjNRf0zkDWTAZiCz6j9+JSmwSFcdtrtUM8mbqcXZigCSSYxuXmcOQaA6sVJib
         kChQ==
X-Forwarded-Encrypted: i=1; AFNElJ/EBz9q9Ij1wmh04oXq3DvqcxG5GdzMaGibVlDfwAe+R9O1EmoshziKP8gqG13tLq8OOni8/Pw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yws2WcKGG2iBRSpUfLLiOIkklvk/+ldnfsGR8WUUSLVhSeyb7N7
	ssRtW2A282W7aaMr/oGLQtAgenCwjA71FkWGptLlrkmqdWTq+1zP5lereWY5pyuli866AD+Yx23
	yYCV/J79SQwIxAfCBFx950dnF5w==
X-Received: from iljq18.prod.google.com ([2002:a05:6e02:1072:b0:500:26db:d9ff])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1b2a:b0:485:467f:a306 with SMTP id 5614622812f47-4872f352d35mr2615199b6e.4.1781292567951;
 Fri, 12 Jun 2026 12:29:27 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:29:07 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-20-coltonlewis@google.com>
Subject: [PATCH 19/21] KVM: selftests: Add find_bit to KVM library
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Some selftests have a dependency on find_bit and weren't compiling
separately without it, so I've added it to the KVM library here using
the same method as files like rbtree.c.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm   | 1 +
 tools/testing/selftests/kvm/lib/find_bit.c | 2 ++
 2 files changed, 3 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/find_bit.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 9118a5a51b89f..fa7a2746b1c13 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -5,6 +5,7 @@ all:
 
 LIBKVM += lib/assert.c
 LIBKVM += lib/elf.c
+LIBKVM += lib/find_bit.c
 LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
diff --git a/tools/testing/selftests/kvm/lib/find_bit.c b/tools/testing/selftests/kvm/lib/find_bit.c
new file mode 100644
index 0000000000000..5534248c663f7
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/find_bit.c
@@ -0,0 +1,2 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "../../../../lib/find_bit.c"
-- 
2.54.0.1136.gdb2ca164c4-goog

