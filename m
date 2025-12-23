Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B343043BE
	for <kvmarm@lists.linux.dev>; Tue, 23 Dec 2025 19:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766518666; cv=none; b=K4tSqMxZc9lCqZbdHKhW8OAAzhonTTb4NOa91p/4IhCHWT6YXyX4p4noKELjEY+wZvqZc2x4jadTFz1dyef6S49skd67HBcccHFcWHx2wF9tkBiKirRNnfe3bTDcyCXsSipWT/7YHEKBiwHN+95k2C5xwYSMpMUqlRVl5ex9djE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766518666; c=relaxed/simple;
	bh=ln/VbRia+w4cejCBZYJ0Aic1cDCWAri8br6Ajm6FYT8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sritp3lr/2Hh/UMbYR8daC4KUW1ZoAgYAHwczBzcpDHpOtD3UbfPsSi79bEQ/HCWdT7OA619US1h6mtMQxTRI0p3u6DVwcR06NsqtPQX5w+UtS3LjPrFao4dV1UNUj0ap2HWGrkxiI1do9GrmS2f1V8fCFXuwetzI1+ESRWGn6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--pekangas.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bb0YpbJt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pekangas.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bb0YpbJt"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0d59f0198so70245155ad.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Dec 2025 11:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766518664; x=1767123464; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mpE2cHSu7VEJSV8o9XAdCC+Pqd8elvYLdca31NEtq6Y=;
        b=Bb0YpbJti0ASkbrENgR1swyTQL4qNH/ovBuNOK2C3OXeJ8bsfXHDvGr11cuIMyek2X
         rheSI8KfulakmGogD9xKWMyz09tAOA0qVb5l4gKb4WglP3kdn90P3zLR8NcksEKHQsiz
         a0IoWg0ryxRjr0zhoxQxJk3QtQ9xQZ4r/dIEsLovaZaT5Jot7Aqi8XS1yTkGQHZvCzWl
         eSdWPbvUQuPtvThv1Re32DXbPrmoCTttVbbKcAcP6eH6R/WXzjQabygdN2+xfJVRcXh3
         qCYk4Ib03BhvppTSqEgUQfrIPxSyKsOBGyFm2vA0TXFHbNZQLvB13q5UTr7hhnA44fi2
         PxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766518664; x=1767123464;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mpE2cHSu7VEJSV8o9XAdCC+Pqd8elvYLdca31NEtq6Y=;
        b=H7wz3eSmkgV0EBDUXjIRQlYOMcChQscdqT+gnerpYAkecdbcRgH4D2Pq/tUFZ+ysoO
         ID/Uv6YtkigndOpotZGwN1e4QhtT38liDXwvWWb5qbNBtztUF6zxzZmjps4Em8tve2FJ
         hvrn6XghxqJgncoVUAXo5YEe0RwtUIXU6B/aU9MyvAdIqGs+ILh5Sl9A1kcCCwsHlfzX
         SFtXyi1AXMxMUhrcIgWhCHL+kZ+H4lisaCB1s9fA6jDlZrgMglh8nb9mWQRmd9hNi5HF
         /T1eyR+Ew2XAJxLRgWzgH2+FcQP2tkOmp7SdG9z6BcSSmy/kBZwCvJpg5EwndHO6vzBw
         adXQ==
X-Gm-Message-State: AOJu0YwTX+JnzJJhqxf7rxs5iZXGhv3R7RYqNxhFtqVDtK8LCAtzZH1B
	CesMcu44C9lyis2vUH62OGk8aDDVlmn4q6vqRGV7UWsDkVQkfM7B/9jEvX/VLubGLo2HXtY1+AE
	yNKyvvKYODTqKJmFxkLH5kY4GHV/K41g0DTuNs0oaEzEHxaW4mKj7eMyMwRReEkHUCY5Oz0DAV1
	QHXVgNLsaV4MSmOrhngT4BUGwGYrrM+vsUy7JFU9c7LC592PA=
X-Google-Smtp-Source: AGHT+IF83L91Gh8tBV6+mxWodX8HXmAQvfSbCEAss+zVjQUMiFCvaVUUpvJKxJPo6RfJA6Fdt7OWobxVaK6jag==
X-Received: from dlbto10.prod.google.com ([2002:a05:7022:3b0a:b0:121:7a50:e97b])
 (user=pekangas job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2214:b0:11a:23fb:16e2 with SMTP id a92af1059eb24-121721aab8fmr17386955c88.9.1766518663824;
 Tue, 23 Dec 2025 11:37:43 -0800 (PST)
Date: Tue, 23 Dec 2025 19:34:39 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251223193440.1441657-1-pekangas@google.com>
Subject: [PATCH 0/1] KVM: arm64: Fix hyp VA size between layout and MMU
From: Petteri Kangaslampi <pekangas@google.com>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Vincent Donnefort <vdonnefort@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Petteri Kangaslampi <pekangas@google.com>
Content-Type: text/plain; charset="UTF-8"

All,

In the KVM initialization code, kvm_mmu_init() and
kvm_compute_layout() use different logic when determining the
hypervisor's virtual address space size. Specifically, the MMU code
uses the larger of vabits_actual (the kernel's VA size) and
IDMAP_VA_BITS (48 bits), while the VA layout code just uses the
kernel's VA size.

This means that if the kernel is configured with a VA size of less
than 48 bits (like happens in our environment), the assumptions used
to calculate hyp_physvirt_offset and the code that determines VA
ranges to use for mappings in hyp/nvhe/mm.c get out of sync, which can
results in mapping failures.

The immediate fix is pretty obvious and attached here. This is against
6.12 but I don't think this code has changed recently. I think longer
term refactoring knowledge of the hypervisor's address space into one
place might be helpful; currently it is a bit spread out.

Petteri Kangaslampi (1):
  KVM: arm64: Fix hyp VA size between layout and MMU

 arch/arm64/kvm/va_layout.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

-- 
2.52.0.351.gbe84eed79e-goog

