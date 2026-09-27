Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028033B19AF
	for <kvmarm@lists.linux.dev>; Sun, 27 Sep 2026 16:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790526918; cv=none; b=fSxaqifL1jdFigYX7iEgv7ne6UEEE3lJnZSqN6HOC+82TpStJWf/2lWAxtHUjkmWBwVEija0rY9JBhGAOI7jKmy7ePOM0LmFsE6D9DrE0JnxclunVDdu4m7Ap2huS8+dfLwUmVbkbVPAcutQfDdLkKvWUyHxbyyBGcijkhXORhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790526918; c=relaxed/simple;
	bh=zzR1GBlatYIVXlYdwq1GoRBuCLS+Ksa0qVLVV1fWkYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mc0YSwF/4ZMRFVh+khdKEkLUVfikKIPVX6nr0yHhpNgfbzH9EhrRqv6cJ8WjF4t/Ixh1cTxFfjGKjbSyGGQ8N2Hv8qzcBxh540cvC3KKKfBfVpZz+miY2F6iihfCQElfrbbHa+//qFvqqUua+e7QeMWiToGfKTDhEMzE/DT+6go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IN8Fdi0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IN8Fdi0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C6D1F000FF;
	Sun, 27 Sep 2026 16:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790526916;
	bh=TDbZyGGFBP9eRmkAQH9I9cvotS6ESn1jbu9Gooo903A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IN8Fdi0MoUEdZdXcpinsQhC6TT/NgBySUO13qZw0oRL0GY6+/GP6qeVDZcXpntnSL
	 bZJMRt97jWseNirMzkftBQkp3QP6vha/ScbyKsN1dZdtIJvCrO+VRHgsb7YSaJjs/h
	 aNOKKS0i5AIw6YyfXI5eSE2xCuJ0dXoFHLvusgXlm6T1SMofedlrzIdsWfeKZZbcbn
	 i9VPBkPOqsO1iWQZh3gklHeHqZnRpE7yRqnZ+gRWthMKpyck+NBXSAPVhnHP8PnYh4
	 jpA2K0b4/71XOlHfYqkNwC68OApiZ6NH0RaUZyf4PjwtvWRdCVF70NZoP8TXM11+y6
	 nxrwAdQBbYhkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xArqM-0000000E2St-3Rlt;
	Sun, 27 Sep 2026 16:35:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Vincent Donnefort <vdonnefort@google.com>
Cc: joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kernel-team@android.com,
	fuad.tabba@linux.dev
Subject: Re: [PATCH v2] KVM: arm64: Disable stage-2 ptdump of pKVM
Date: Sun, 27 Sep 2026 17:35:09 +0100
Message-ID: <179052685158.3528802.17360317443596680597.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260924100459.831013-1-vdonnefort@google.com>
References: <20260924100459.831013-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, vdonnefort@google.com, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, fuad.tabba@linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 24 Sep 2026 11:04:59 +0100, Vincent Donnefort wrote:
> With pKVM enabled, guest stage-2 page tables are owned and managed by
> the hypervisor. The host's pgt is uninitialised.
> 
> Skip registering stage-2 ptdump debugfs files when protected KVM is
> enabled.
> 
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Disable stage-2 ptdump of pKVM
      commit: 0dea17ffe6757a6249d143e607e786144aceee9c

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


