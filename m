Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BBD23D7C2
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 13:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781701961; cv=none; b=ZCBFGicKnUwMVTqGN1cFtgx/8rz9fzR/75CC8bk/ucmHtTVBciS+XcxzKLmcdov31DMBll7Gwih4metWpS+TK+bBzRC5YlDXBwmvtuNAavVK0ISD7bZFy/5d8aSUpuC+8hROdfA0lHNtuldcXqbXcqhL2u4b5n7OU5rWuiRBls0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781701961; c=relaxed/simple;
	bh=eg7H94VTr9ptGOsBnrR/DzymoHjiT5DB4lHq2xmOgRg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=QiK2wUT9p+OFbhuX/rCMtp7ZjfrKIrlNXd+G6mPbcH0fipGddNjUWHb5fzKLdmaD8xdJL1lff7U4mJdgmJkl8YTjhZE1Mm5kb/MiI+KJYGZcBolC/7wqHuyifdJrwBzpObEuUAObzS8v6DN9XC+5iJCiucqbC660YyYJZj+z36o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=duRFtXRV; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="duRFtXRV"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b0682d2fso53389655e9.0
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 06:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781701958; x=1782306758; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qjkZjhMKdgVqRMkCoanmUdUt3sYnMDgOICyf5NDOycQ=;
        b=duRFtXRVf6B8Gd8rfZxzfzs6Cr2ehrvar4pZu6JOST2BYgI6f/dzDd1Taxvq7kioUl
         9zDBkKAN/qzMJP+59f7SF7KfM+oL+QM6KYtJ05QdIcPmaKb5RlxKzTS0bSOZqRxusJR4
         6ScA0fDf2RUKDu5/2UzQ3iqk3ruT1bbjM6yB5grhCNotXUItjUJfmEj6a9KjDtTaadC/
         PJU7mhPm9CDu1cIt7KX6tCLdkz6Z5PHeCqlgweRfMPj3fWiV4WvGhy9MsavvtcD7paEg
         TMhKxItbgGFzhVF8JxaFuAmokIGCrMh2plCM3wM2N2eGgqXIZAaS9gtwhlLzjLmJILfr
         jBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781701958; x=1782306758;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qjkZjhMKdgVqRMkCoanmUdUt3sYnMDgOICyf5NDOycQ=;
        b=nC1999/paWAtLdyFQd2uiTYaqGqhOl1PGnFP+XkNxuNjpZDPohNRWA0UOIYIVk1tDU
         +2+TFh0Kb8lD9m5fdGwyQyBNy8fDTgdZJoxufCawiIGBMDoLJJ6s/+woG3YJRvP9NQza
         5SVY2zNMNrjxylmWDJfJwKmXl2Rcqmz2/1C5WG2g3dgHp1gIUkdACLZe0tCTKGbuFavJ
         yc9v5MAqGavdtx1uUW7EwS4Smu9W3O5taE5xl2VrMqrfxViVUR0ii5cVPgS+yHFQMt0V
         PqDTUNLVD9HDCL3v6Kzj6b1AplHXsK59cr+rmBjzCHCdjWyWpk/KZ3+v123MD9FYNuOm
         u8eg==
X-Forwarded-Encrypted: i=1; AFNElJ8UY8FHni+8M3aDigllzlpRGcUQW8c68jlbDEika8QuHU9bUm3ubXw6EQqadT3ukd0f8MQf4jQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw39KSNgY4qLUSsXVjl0TDaq0bklsCKJKFza32pZ51uaJgZDwhP
	9RR9U2rPVFuOPyUDUHtio5M50bMu6yArL17Z+IPTItHqf2lYrhc4/EzAiAXjsP1hvrhWm4O61k8
	4Cw==
X-Received: from wmsk20-n2.prod.google.com ([2002:a05:600d:8494:20b0:490:b475:af3a])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19c8:b0:48f:d1b8:9ab1
 with SMTP id 5b1f17b1804b1-492333aa56fmr66371605e9.9.1781701957711; Wed, 17
 Jun 2026 06:12:37 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:12:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260617131237.2842619-1-tabba@google.com>
Subject: [PATCH] KVM: arm64: Add Fuad Tabba as a reviewer
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

I have been working on KVM/arm64 for a couple of years, mostly on
pKVM, and am currently upstreaming protected guest support, with more
to come later. I already review KVM/arm64 patches more broadly, and
am happy to continue doing so in an official capacity.

Add myself to the KVM/arm64 reviewer list.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3fe46d7c4bc..61eb5dc2bd03 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13991,6 +13991,7 @@ F:	virt/kvm/*
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
 M:	Oliver Upton <oupton@kernel.org>
+R:	Fuad Tabba <tabba@google.com>
 R:	Joey Gouly <joey.gouly@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Zenghui Yu <yuzenghui@huawei.com>
-- 
2.54.0.1136.gdb2ca164c4-goog

