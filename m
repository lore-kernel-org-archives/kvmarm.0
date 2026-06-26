Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1B33C1418
	for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 21:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509751; cv=none; b=kgYwXs4awhXGGXdgBhfdvU3CTYRSfgCMBP71o/GUTTsGTnzqcPWze1YWuyv9hpCGSRsGE7Err9/ngAm4O3jbXZ0q0Eouf1hKzdQNDKf0HNzBY2hcsPAz5uuM+GPCq2n35kxtbR/kZ6Hb94YrW8moQdx+WIn1HP0qh+LvBNsrU4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509751; c=relaxed/simple;
	bh=UoTwG6R0uStGcX8LQI6mjjue0xrjLAazUf4KptVN5js=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C34tAHTl5aVYWaeqbyR2ULDi8/cIERbsxIfomFQ/me12pTLw37D6RuNZB3Wjq/NgzFP+3Nql2TAPqDyCGCoOPtqQ1IIM+3PqRDZYn1zCmZZo/Ve0gK/JcIL0gT8RJdH+xpfn5oLEcj9+CZ1VjR0zUd6jqIc05bor8H6WNk0rR3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y5ba6zvD; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y5ba6zvD"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c89956023dbso784582a12.0
        for <kvmarm@lists.linux.dev>; Fri, 26 Jun 2026 14:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782509749; x=1783114549; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SXFt4r4hF0CDqmnY5VMLGnN8mXFOQ8bAerYnb+O0pOw=;
        b=Y5ba6zvD1R9pXhMScbEUtctPM1A56xX7evrhNxpq1z4RsvsoE3qC/G61llqgp2M5py
         t8HvsuonOVzP1TSOr0kEwtNRyUpmUllok/PwYkFtoB6i4+f+zT0yPVsq6XuvwwjwHqTr
         li/0ZIK1rm2zEXBlvt+DfEhcdXJDQNZrOLLjqemzN5dPs0hePMGi440zCAQ78a+TOEY5
         HN11AdPEeQbRJm1MMGr9CUn5QLmxegoxj95dlfCj/JNqS5P57W78ok9gaoqIbr3HbE9L
         jiazBhH+guFw0fBZzwEWgGfcq4ta7Gysu9mnJ5xbsVO9nGgKvXuPrFI6xNkiuHHpumhZ
         IIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509749; x=1783114549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SXFt4r4hF0CDqmnY5VMLGnN8mXFOQ8bAerYnb+O0pOw=;
        b=nO8LzK6bTicObaZlVqNSapVtoAerR4EEugMjQxVg+CoI9Em+z/SggU0eT4eCqjdHzm
         LfRAnBDCPAtA11v/RVRFcovTB+Gw+nQ6QxkgRe6tGHEnkzkuvkot7rO0oxVu7Eg0A4qo
         V5QCysnapdG4WoOzuK8Q3jPq22jEuPZXZLiU8a3rLOypBmyMw7vK/r7nGOhSye43FO3+
         SO5Jq48MhBj1TUqZo4YhrSHmVjtNcBTX+TuJBPZsKEaloex4kOVCgQMst82SgAHdNPNn
         w5/XZ2VNn56l3sKPDOQdj6IdN+QsRfWmXPHy/wPcYj2bQRStPabtPzzTYJw4xnR2ElL/
         JpaA==
X-Forwarded-Encrypted: i=1; AFNElJ8zXLxl5FieYpJO9EmZ36Wz2KOr2gfs5bI3o0qhCnWDTwzWbpATyiEUWmBWSII3FTaa0wnres0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0ym1QtfoolMhbhYvTm6TPiPnp9SPgYwxELNNcj9t4VUjG2Eme
	nxQvejrsjE6hVg/Uqn/42BfZTrdG2CUhtnKpBFAFLghAaJXFGpuRVcpSkCPJCUXRilKFG0WXVXY
	xMWdm/w==
X-Received: from pgge9.prod.google.com ([2002:a63:db09:0:b0:c85:62f4:f188])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:8811:b0:3a0:bc61:62e6
 with SMTP id adf61e73a8af0-3bf69b3edc5mr2231510637.8.1782509748445; Fri, 26
 Jun 2026 14:35:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jun 2026 14:35:23 -0700
In-Reply-To: <20260626213534.3866178-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260626213534.3866178-1-seanjc@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260626213534.3866178-11-seanjc@google.com>
Subject: [PATCH v8 10/20] KVM: selftests: Add a helper to set proc IRQ
 affinity for IRQ test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Sean Christopherson <seanjc@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Josh Hilke <jrhilke@google.com>

Add a utility, proc_irq_set_smp_affinity(), to set the CPU affinity of a
Linux host IRQ via the proc filesystem.  Use smp_affinity_list instead of
smp_affinity to avoid having to convert the single CPU to a bitmask.

The helper will be used by the eventfd IRQ test to verify delivery of IRQs
when the affinity is randomized/modified.

Signed-off-by: Josh Hilke <jrhilke@google.com>
[sean: make the utility self-contained, drop "list", massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/proc_util.h |  2 ++
 tools/testing/selftests/kvm/lib/proc_util.c     | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/proc_util.h b/tools/testing/selftests/kvm/include/proc_util.h
index 704839b6d7af..d1ddc967d11d 100644
--- a/tools/testing/selftests/kvm/include/proc_util.h
+++ b/tools/testing/selftests/kvm/include/proc_util.h
@@ -6,4 +6,6 @@
 
 unsigned int vfio_msix_to_host_irq(const char *vfio_device_bdf, int msix);
 
+void proc_irq_set_smp_affinity(unsigned int irq, int cpu);
+
 #endif /* SELFTEST_KVM_PROC_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/proc_util.c b/tools/testing/selftests/kvm/lib/proc_util.c
index 84d30f055a0a..3960b3841d63 100644
--- a/tools/testing/selftests/kvm/lib/proc_util.c
+++ b/tools/testing/selftests/kvm/lib/proc_util.c
@@ -38,3 +38,17 @@ unsigned int vfio_msix_to_host_irq(const char *device_bdf, int msix)
 	return (unsigned int)irq;
 }
 
+void proc_irq_set_smp_affinity(unsigned int irq, int cpu)
+{
+	char path[PATH_MAX];
+	int r, fd;
+
+	snprintf(path, sizeof(path), "/proc/irq/%u/smp_affinity_list", irq);
+	fd = open(path, O_RDWR);
+	TEST_ASSERT(fd >= 0, "Failed to open %s", path);
+
+	r = dprintf(fd, "%d\n", cpu);
+	TEST_ASSERT(r > 0, "Failed to affinitize IRQ-%u to CPU %d", irq, cpu);
+
+	kvm_close(fd);
+}
-- 
2.55.0.rc0.799.gd6f94ed593-goog

