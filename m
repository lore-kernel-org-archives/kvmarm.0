Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1F879CE
	for <kvmarm@lists.linux.dev>; Fri, 13 Jan 2023 13:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E4CC433D2;
	Fri, 13 Jan 2023 13:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673616497;
	bh=p0imUzLtfN9VVvFHx51VODYdDfWqho2b57JiDvRO62k=;
	h=From:To:Cc:Subject:Date:From;
	b=tvkjA53rvtl38GhbLyIwUnmaBSUXtSQFTj6a8uhOgvm7kpJgxdiEEZMeWIB1kLC5I
	 gRaDW+cRVyqO10K0ywxnrEk8XFPpFVpYGsl8/PhaK9aPvQYKsxmItukkwFi5iIfcFk
	 vJNqOy+zEAgsan6p4IB9CerrCedRw7Ee0jVbdUvMR2gDbZuf0aK3Rzsj777AzuxK4i
	 lvVpXa3LDf7oUDaLd3Y2vx1VfgdKNuOGXaX/Wn3mtSxiqMbLKvZpmqiqSy0N7k4Kg2
	 1+1AMNE3HAmtIMtd3H8mOc5UCGhVj72TbJS/4giyyFTzzerVEdmuJJQEE3/NM+PheO
	 JI0MnuKfgjdJQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pGK6P-001WXZ-9H;
	Fri, 13 Jan 2023 13:28:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Drop Columbia-hosted mailing list
Date: Fri, 13 Jan 2023 13:28:09 +0000
Message-Id: <20230113132809.1979119-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

After many years of awesome service, the kvmarm mailing list hosted by
Columbia is being decommissioned, and replaced by kvmarm@lists.linux.dev.

Many thanks to Columbia for having hosted us for so long, and to the
kernel.org folks for giving us a new home.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6a0fc23455bd..d9a359a65d0f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11361,7 +11361,6 @@ R:	Oliver Upton <oliver.upton@linux.dev>
 R:	Zenghui Yu <yuzenghui@huawei.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.linux.dev
-L:	kvmarm@lists.cs.columbia.edu (deprecated, moderated for non-subscribers)
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
 F:	arch/arm64/include/asm/kvm*
-- 
2.34.1

