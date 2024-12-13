Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDD51EC4D0
	for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734101904; cv=none; b=JyqC+o9Y3NenYPy0GL+lMPPgtAUitU+1/w2olJn9UEIdl6UC69b6zQPlRdYhPv1uk+ldxByIJBKRjhKZEcfllIdVWL48X2sbLPfndBUszpvBe3Rj/7oqH3MShcoHPPphPs6gBqv+Y1esNcumI+CS61fujTTz8J2n8pxxi3d1NwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734101904; c=relaxed/simple;
	bh=XvAzclflr2UpwBopbbcBeEOopsATykat3oD2rQeOkiA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FHSO006VH5z3A9+8vcjLlABNoNJJRfZv4gqqYxscOw9GBtFZreRVVMv70zxk8098dOcy14wOireE3Rp8g1dAlUuWZJ+yqSUQHu2eiCPajdCwivleKxcJulQy06eoCd3mpwefMEwkNGPjShN10bDDfoiqie/Sql6yX72cdCzaLsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P43fSH9L; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P43fSH9L"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5d3d2a30afcso3134595a12.3
        for <kvmarm@lists.linux.dev>; Fri, 13 Dec 2024 06:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734101901; x=1734706701; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WIAyRklPQmqf9KZJxMUGFpriShtgf5N1bsq1t9wgGwE=;
        b=P43fSH9Ll3sYe0CC80wWfUbnFQXLOxT4wmC47xjKAwSTZ0GE6d3vVIqgiw+zCEkzWf
         CNv+oXY6j6k5WoO+/3a7pZUm+lZiq+zNqNJTzoPv46dGUr7ECeNXC7cXWlwcqVAo0Dfc
         flIDvbV3Te4pT6LAgDFK2P2cLakfiTRDBgKK9bz+tTq9OGZjQPNNyYvoj68PutvNKx9J
         h6N2SiB+06jjhrt4MyY5ljIaGm3y/BZisPnd4z8dxIaqvVnP3JaPrP9nh2nNBFlkHuII
         dWeoB0QkSB+oIirp/JjW2m+in7yBFH7LrETIBwGfZgCjVGcQ0wLAm8jSRdNhid8nYeW2
         Gp0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734101901; x=1734706701;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WIAyRklPQmqf9KZJxMUGFpriShtgf5N1bsq1t9wgGwE=;
        b=noCS1ZedRDvaGbo4xbWpCxsh1c4kRiNm1k/4jydXj4Gg52ism7xU+pZUPWTflND36j
         nDmhLVvWXq6VjXBKwnX9xLCMbTxsXU6Qyk5sUXSs/vPWmIIuMVg8/7Q8q2ElkNlw3wkV
         nK8AAZ3UA1AmAyDjVrD/E+dRrkbrpzeNgViKALg4ksbS5iLd99rx9tVsXE7SpTpVx61J
         UwDpRflQZwYnDID7PjlnSExWA+5TNQuJ6/MD5EDDmkVT2qscTD5LOcmHZ19MOjfzKJEZ
         lKOl5JkDNdfZtYixJh+DRtQPcsrO5l5S7PqY8IMCRuGqb8GzPov09GSYnVkAmhONNcgD
         JEUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzJCf/6JJ2q6jCeoBPAHiYN38Z/D3S5wyD+AcjNQB5iT9j6/hY+gHW3l4M9sVUYY6rSoBySE4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMDwbLPs7iRylIzgTFLvQMxdfdLuiUu5+XP/O88Saw+avBBVgq
	sWvgSEtSN9eXiWLpRFv9ljIMjRKkERh0n6BqxE2ZN+iNy9pJ1/cx
X-Gm-Gg: ASbGncu8VxDiXdRCzjrez9DhF5ocqyc4LDoLuyjgKqm9ln5c/UViYLyh3hK7G2bQDG+
	6JNBZZQ8yjZxNviqt3zXRn9SM7d5vu/3YESZabcql3l09F8b5JVq0iorEoPIQxMPSXoDW/1ko4F
	JCmfiszKf2Gw3e3xuep49Ac5pIPDf21m6jzTw2nkwAmFhHeMM6ewmVOg5oYZq/zlpJt36/C/NkG
	q8mxg6PHBaoen0wFaOESAKqGcmqtJIGvP4uPjfLM7FQpeAsBNYT2pMVAcduZUsyOg==
X-Google-Smtp-Source: AGHT+IH1tqiOuYhFc9ioeNHPkf8qQaZvXIjpk64aKZaDXNtayA3HfPmpe9Y22E4UKaBziVSZVldg9g==
X-Received: by 2002:a05:6402:3890:b0:5d3:cd85:36c6 with SMTP id 4fb4d7f45d1cf-5d63c3ac2a0mr2656510a12.24.1734101900740;
        Fri, 13 Dec 2024 06:58:20 -0800 (PST)
Received: from localhost.localdomain ([46.248.82.114])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d3cedbb8fesm10048424a12.22.2024.12.13.06.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 06:58:20 -0800 (PST)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 1/3] KVM: arm64: timers: Fix percpu address space issues in kvm_timer_hyp_init()
Date: Fri, 13 Dec 2024 15:57:52 +0100
Message-ID: <20241213145809.2918-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cast return value from kvm_get_running_vcpus() in the __percpu
address space to the generic address space via uintptr_t [1]
to fix a couple of:

arch_timer.c:1395:66: warning: incorrect type in argument 2 (different address spaces)
arch_timer.c:1395:66:    expected void *vcpu_info
arch_timer.c:1395:66:    got struct kvm_vcpu *[noderef] __percpu *

sparse warnings.

There were no changes in the resulting object files.

[1] https://sparse.docs.kernel.org/en/latest/annotations.html#address-space-name

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 1215df590418..a13bb9e8dc19 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1392,7 +1392,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
 
 	if (has_gic) {
 		err = irq_set_vcpu_affinity(host_vtimer_irq,
-					    kvm_get_running_vcpus());
+					    (void *)(uintptr_t)kvm_get_running_vcpus());
 		if (err) {
 			kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
 			goto out_free_vtimer_irq;
@@ -1416,7 +1416,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
 
 		if (has_gic) {
 			err = irq_set_vcpu_affinity(host_ptimer_irq,
-						    kvm_get_running_vcpus());
+						    (void *)(uintptr_t)kvm_get_running_vcpus());
 			if (err) {
 				kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
 				goto out_free_ptimer_irq;
-- 
2.42.0

