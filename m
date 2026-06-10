Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9B7274641
	for <kvmarm@lists.linux.dev>; Wed, 10 Jun 2026 00:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781052834; cv=none; b=Aa5I7RCtkGK5U73gFVYvGvcOl6xU7lEdMqHZ+XNPwXTvJIqVOFMv+F7eHOziYpQCeifze/27zCtZYM1mxDKyz4cT1YRyW02LH/DE9X44UuZ7ukSYBzIo33sCnCX3IEySzGzUTe8zAOWNpsod/7FAEIwW2JcG5+TQSXMOAIPubq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781052834; c=relaxed/simple;
	bh=1R14fEOQLs6N966Zchktrti8uX0PorIg54QMlHvgk68=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Hwvopwn8rv9Xs/A9wgcuUzwDeo6f4di3Sukkufw4Pyo+2l8zeThNvPAPVsFugdqop6s5s3BSoZGp4D4eaPqcNaxRKwRQa1iew/XpgBaej3w6ctf20VCMLFLsd4OWRVYJTM7y5jBQNSm1RR3A6hTlxOZ+TU9grOaYBhnATpsxFrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L5Vuzvx/; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L5Vuzvx/"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2bf08c2a24bso58890215ad.2
        for <kvmarm@lists.linux.dev>; Tue, 09 Jun 2026 17:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781052832; x=1781657632; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=W9rLXq+5NYuHF5j+PqcJxTC4xDIIkyDtUExjWacEIvs=;
        b=L5Vuzvx/v+WWvcPhVBeMgJndjo1wf1TtxaoD/CWXm92uAcOUQT4/CNSlS2azhCqZ2j
         N6cUWny4UDx4pkOyHYIRJCSuWdIFM6EB4f8HZrvjpfBIjAra4Tvx78dXRGhNQyzo0te9
         ahalWmDm/UTTu2H0c3TTYEwL5ItiRMZRt6vMo0i7cHtUhVrgvfIQ4Kgx32R3rRP5KR1F
         ho67Lf3h+4voFmyo2UN9en6lXsnKm2G4ysZjNde8bqxjB/WClM2L1XdoSqmfGGj1dGpw
         qJ03zOTik3LQJUVKcb0z+nX126sF6RQdhlP4GNN1QU3sXZ/UAkmmvXp8Hv9ywjkwRJCV
         yM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781052832; x=1781657632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W9rLXq+5NYuHF5j+PqcJxTC4xDIIkyDtUExjWacEIvs=;
        b=VW2l9Ge2WERYz8ammrq4FMuNs+JKp0q4Y+dqzgaaCF2Iu+md65LXP5hhDX/iot+z78
         S3XxY9pDrjieBkmxyyDtuA0jWaM5DX1zbo/MwIWgukTFL+bM6Ao034mSGwK9twXrXV7U
         nZ6rXLPVq0SHWapOPuVLg1wsKHqsmdVQ4GZnFD+7cZDd+s4NI/m6bnhngUjeX49JXiUH
         U8swOZH8gqKyPSEuxafNbhIkaBR5yZ7qLBOhHMklr4lTJ4+xuejq4h+6UvblqaFxC6DR
         xUwmw3mVSVKG4akgcYNJhWiWZEyLtH+P5Lb7ZLpSdOmc9jr6FKNQOkBc5bHaFhDqGtDN
         3ywQ==
X-Forwarded-Encrypted: i=1; AFNElJ/wgx+jo2SLPT18eudNnqoN2iid67UHe42sf8lHAY4PyaQDuynMqvEwr3LPT5u7DE76sH0Iids=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLEEZ/FO/8vVyz0C/rgBn3YUDoZ6Cy0okMZ2CQevjiM94Lf+Et
	FIur+1drAN4IM/IkrlCKM1v7Ap4nyasop9/qWoqtmbiZtWX9VRf/Abaki0NBLHa5h0e9uikDUhc
	+jTwQtQ==
X-Received: from plbbj2.prod.google.com ([2002:a17:902:8502:b0:2bf:2098:44f4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef50:b0:2bf:23c3:34ba
 with SMTP id d9443c01a7336-2c2a1c99a9bmr63318635ad.28.1781052831902; Tue, 09
 Jun 2026 17:53:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jun 2026 17:53:28 -0700
In-Reply-To: <20260610005338.2967132-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260610005338.2967132-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <20260610005338.2967132-9-seanjc@google.com>
Subject: [PATCH v6 08/18] KVM: selftests: Add a helper to set proc IRQ
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
2.54.0.1099.g489fc7bff1-goog

