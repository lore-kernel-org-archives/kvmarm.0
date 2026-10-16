Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F994E5321
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165198; cv=none; b=kNPNgd8ZFTOxkbpiccmiS2OVG244jM99fS5N5Uq1aOmA3oLIIkl+BVi3vHY3HrEWyTTUymATUF0NbOUbCD19Vnj2BQD/ky3njWnZBI2VHuwAYQgE5Th9w1Lc1weioL9ZtKO2PGMYaeOquS1r6qMkvrnL++/si+aFoOq1fQuW17U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165198; c=relaxed/simple;
	bh=trwyaXsF1WTqd7Gouxn+zpzAuN1OvEr1aTuTAYpTzN8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AOEFZhBmcFkgi9fCfHNLNaxm1TvPJqpug6RxGwQ0qBZO0UwTVDRpk4JtZlkv4lpsci23KQCTv5wdSh48ZLMcvmc9jVHIM0XRBsi77QXWvli7PIWhIptvlB6mJuOFLuKuoc0OoaEqabNdnUpIz4GObPKUrHDahwBvjrBZ9qPUANI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Uw5IIAOo; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Uw5IIAOo"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F398143D;
	Fri, 16 Oct 2026 08:39:53 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84EA73F673;
	Fri, 16 Oct 2026 08:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165196; bh=trwyaXsF1WTqd7Gouxn+zpzAuN1OvEr1aTuTAYpTzN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uw5IIAOosUQdfayxqbOX1mXbH0/KO+/Xga7b8HHiYNnARHt35GZ8vb0jBFmVPCc9X
	 WCNMzf+DRr3nInI2QkeeQ7cQSgcxfDIAurXXcv99sUS48dY0WkOZO0CCwC/iXczYFR
	 6mc6tqw5uT4cU2M+cRxLgXKJZ9P5f/+D91uZxBGM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 01/21] arm64: Propagate IRQ routing initialisation errors
Date: Fri, 16 Oct 2026 16:39:19 +0100
Message-Id: <20261016153939.913764-2-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

irq__routing_init() can fail while allocating entries for the default
routing table. gic__init_gic() currently ignores that error and
continues with a partially populated table. Return the error before
the VGIC is marked as initialised.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/gic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arm64/gic.c b/arm64/gic.c
index 1e400962..debb0381 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -344,7 +344,9 @@ static int gic__init_gic(struct kvm *kvm)
 		}
 	}
 
-	irq__routing_init(kvm);
+	ret = irq__routing_init(kvm);
+	if (ret)
+		return ret;
 
 	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &vgic_init_attr)) {
 		ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &vgic_init_attr);
-- 
2.34.1

