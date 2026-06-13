Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E25028313D
	for <kvmarm@lists.linux.dev>; Sat, 13 Jun 2026 00:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781310050; cv=none; b=emy3tGxuv5deoHLEbAyIOWh+P6g7XguQE8bTdUynYYoNb4p9GTQf9G80iutqvtibz2DnmsQiDgm5iWdWayKmO9rMaXnDJdZOsTPlbpGgfc2SadpBBOuR7FxmJ5QShAyxWljhksqXPDHC38zT57nrpiKrXELxxPrdzUCP0Wx3kF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781310050; c=relaxed/simple;
	bh=/fkbGKcR+7Oi0MNRIDMSgWen89S/kkyrbYx8GFItGdg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hvrdllDwRr0aDT5Anz31lzhCcwCv1dPBIepB8+5ouu4+A3RXxXD7kpuMUGQ9wEzaq9F8FNBUIxqXuryPelxiyAsrYh4ecskhqG52q4CGfSApjFPx2coAacTVicDRQXY4kYQ+RTewHACY+vttqgRwbBKTAEG1dwkpQQQKgQsFoQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qB5KDClg; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qB5KDClg"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c85a2c0b56fso1278389a12.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 17:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781310048; x=1781914848; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TrhMXXAaZNAJ6oA/gSoBLS4pvmJFJO85iDVA23KYXYk=;
        b=qB5KDClg0VZ9NojbGWI4Cm5VQWVuadpIbeDQ5iN+QI3goEE2R6x21qzpv063mlDB0A
         e68IJdYejaPNy2EpQmjDCQFcAZEJwh7nC8mVu6neO61hluh2bOu915bXDKBRYVeWY8xC
         5BCdIx7EYxHm72HKH4Qo/Wt1NFRON+B+N7DDQsVSfovBy6VUUXYyc6azljMeGDwc433e
         jy/0g70H8ZhnJbwqMa6E+YXgFHF75SKI5BcxNIevnYGmbrFM0NjwfpHc6pHkuqV0+gds
         2RF0AMK2B7IzNP3SPUDUJcY3NGkXSwUBkVHOUntiho2Srrq+mJo5PXe/nFGt4KOpahh6
         qd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781310048; x=1781914848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TrhMXXAaZNAJ6oA/gSoBLS4pvmJFJO85iDVA23KYXYk=;
        b=bVSvhQoDH+L8IhSMykbvx8NcXOZ2Skkftt58j2SKVZVEa7Wav7uxHQFBhEhNDcpcHw
         znbFxV6qanTnmG7xvhL1JisfneFL6fVn/zb8N6PiBK6V/AMe3lnnm5J65L/4w9htbRlD
         MSybFughDOl07AwLu9y7j2NU9qoQDJEodzBDVpsAZkf6u8VuOF3dutKgvcdpEkmCVs10
         OiGcnZNCg/92o+/IhCyzRgyGzL6pi9G8k3KxbuMsUe74YP9TwUStWaA6fPctNAPvicuW
         dJ4D5bQ+Rm06bigR61fKostKkdkQ41JLm4tpi+J+fHts1xUEq5Egp6D3dx1Q5UpwZPZe
         kZ0A==
X-Forwarded-Encrypted: i=1; AFNElJ+Wdk2QfbtcM3NaXT/m234tXELnZbsNncFQcYHa+cRA2TQi7vTT3gw/J7GwZhxp0Xy7wOO8tyo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwT1pa347QHrs/47wsjagMyp/HdObW9sEdkaTkPi8UY9IpKVcHR
	FAqwiBvnt+9o2LFXDsmdnWCpZt1fw1090yTLlK3iOpc8a2qKAHgdI/a7UebOM+16ucys3xQti9B
	gXVjwbg==
X-Received: from pgbda9.prod.google.com ([2002:a05:6a02:2389:b0:c85:6307:e80c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a11c:b0:398:77ae:8d8b
 with SMTP id adf61e73a8af0-3b783b7e9bbmr6211375637.10.1781310047646; Fri, 12
 Jun 2026 17:20:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jun 2026 17:20:21 -0700
In-Reply-To: <20260613002031.745413-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613002031.745413-11-seanjc@google.com>
Subject: [PATCH v7 10/20] KVM: selftests: Add a helper to set proc IRQ
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
2.54.0.1136.gdb2ca164c4-goog

