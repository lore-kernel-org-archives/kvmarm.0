Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BD62F5A09
	for <kvmarm@lists.linux.dev>; Fri,  7 Nov 2025 01:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762478934; cv=none; b=sDIluVujKibVEntYirP/zEWPDXYFv2FqtXTa90O0OMLEfTFdKTJ6fngcewfrfhrV6x6ASJJ3X+HqrvcNw682MHZWacjjD5XBvqG4/RddhCLqmde1x1aGBvJ9IhR3I/YSI0byV3BZc07RgHSGm91pA4kTt0bOwOoTrcR+CEMQENc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762478934; c=relaxed/simple;
	bh=c2e47lympQD3wVjQGVdtG8qTNTMhJePixA7Ed6yK78M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JaICTvbJRxurSoMPp+JGrW8q/5b8TbAcSP1LDyHvk/MwlDRX/Ia33h815Fv98/N4EUUxg9qTflOdm/l4A/sHk/9GS4Q+gUgsxTmHlvZMJpQoNlY5urr57sR2V2JF4cuFXgFMk/a72y2XFbOOKEgY0v7zJ1njMfngWYeXaKg8jiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgUUBmr0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgUUBmr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75059C116C6;
	Fri,  7 Nov 2025 01:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762478933;
	bh=c2e47lympQD3wVjQGVdtG8qTNTMhJePixA7Ed6yK78M=;
	h=From:To:Cc:Subject:Date:From;
	b=RgUUBmr0ag6+Oa/O18qIGCpV6TnRiE0y52UIbGiH7MPSzizvv+Drg1dATYeUjOMTS
	 0LH3BcxGIK9NS54JDZb95OF6jH95BcOQvbY2Cdl7h6sc+4r19KCwWxDkRl0EpmUdin
	 F+/B/Wdh3MnUjlxDiIpFjiSnycuDBKgSAMsQyqCYXjQwi1it1wX2S+EpHLy3ANgm82
	 ODc39CW+i7MXHHuJLva/rtYGfZxFDdUpqs6is+IW29fZEQxSGph6tFYFbqCQ1oKWCZ
	 c0f52cb18agVzRd3CasZC0ywd6KfG9/P2z6zbKcGzipk2GIM2h0e1+ErMI895Cg1Rx
	 qxaWNCIStOfuw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH] MAINTAINERS: Switch myself to using kernel.org address
Date: Thu,  6 Nov 2025 17:28:25 -0800
Message-ID: <20251107012830.1708225-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I've been running into issues with the linux.dev email
semi-periodically, switching to my kernel.org address while I go figure
out a better home for my inbox.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 .mailmap    | 3 ++-
 MAINTAINERS | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index 369cfe467932..c8f5f36993ae 100644
--- a/.mailmap
+++ b/.mailmap
@@ -605,7 +605,8 @@ Oleksij Rempel <o.rempel@pengutronix.de>
 Oleksij Rempel <o.rempel@pengutronix.de> <ore@pengutronix.de>
 Oliver Hartkopp <socketcan@hartkopp.net> <oliver.hartkopp@volkswagen.de>
 Oliver Hartkopp <socketcan@hartkopp.net> <oliver@hartkopp.net>
-Oliver Upton <oliver.upton@linux.dev> <oupton@google.com>
+Oliver Upton <oupton@kernel.org> <oupton@google.com>
+Oliver Upton <oupton@kernel.org> <oliver.upton@linux.dev>
 Ondřej Jirman <megi@xff.cz> <megous@megous.com>
 Oza Pawandeep <quic_poza@quicinc.com> <poza@codeaurora.org>
 Pali Rohár <pali@kernel.org> <pali.rohar@gmail.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 46bd8e033042..5481e24e84cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13656,7 +13656,7 @@ F:	virt/kvm/*
 
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
-M:	Oliver Upton <oliver.upton@linux.dev>
+M:	Oliver Upton <oupton@kernel.org>
 R:	Joey Gouly <joey.gouly@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Zenghui Yu <yuzenghui@huawei.com>

base-commit: 6146a0f1dfae5d37442a9ddcba012add260bceb0
-- 
2.47.3

