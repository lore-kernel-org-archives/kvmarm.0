Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9275B340DB8
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 09:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763545105; cv=none; b=P9VT85Kdz4NTs7d+c/nn0bYCEeaZ96Gi3eFoIzFD/FDx+IHFx3l7IVAuKngvHBqttlaDWIfL00NWHp7GKfUwHUTYYSn6Op27RYs+BJVnYIoo5qezF5GfMKaVV6GMFidy86L9BP7tqW/fmCxRgJQ15xKylSH81fzem10xnpXBFIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763545105; c=relaxed/simple;
	bh=X0L77YyazSjOvh+2lUEvU1sJo4TjbW9NdjYdCtvGDHs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gMyE2AelnlEa7t9Wk9EnB6/2+F1/rJGvPr5c2cl9rWK8g2xdOXTHXuVvfuh81cydqTuw2F0shd5/g7ggV3qaZC4VQLpMQ8LJBlC4oyK3easJ13Ie3d0smsxTzwepxzZ7WSc9KehANFyTCCU/lw50DqYWtqBrpEOgpt+RH+Z2WAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=to4hz1Mz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="to4hz1Mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8456C4AF0E;
	Wed, 19 Nov 2025 09:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763545105;
	bh=X0L77YyazSjOvh+2lUEvU1sJo4TjbW9NdjYdCtvGDHs=;
	h=From:To:Cc:Subject:Date:From;
	b=to4hz1MznWImQC/5ceqogslILAE9yn7yJupzWzbx3UJsH9PRA6g947zXWN7Grn5zj
	 zmfH60SB/JBxwfxZGvNtJeQzUqIPw73jd5TetCHY/8Jo8wv2GfMIK19nnLWaHLQJd4
	 mAEap6rFqLYgmt2DvYr0/OAGeYUsX2z9y8V9ICQ4TX6i9pzr6zRj/idscOx7LrKQsV
	 3PCILIy57aZnGldK6wa2LTd3pRp9XrssRRlAw9JQv4lMwfceZ+yf8uLf4oQdQZjtCM
	 06nxmHQNJB0qUN2KqLe4x5n+maNaffHJl3bX9XSbodmans14lOnIivM7hDGSbjUyo3
	 O0lD+p8FrOg+Q==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: Fixes to KVM struct allocation
Date: Wed, 19 Nov 2025 01:38:20 -0800
Message-ID: <20251119093822.2513142-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Small fix to drop __GFP_HIGHMEM from KVM struct allocation GFP flags,
which was always completely pointless and now trips a WARN for passing
such an unsupported flag to vmalloc().

Oliver Upton (2):
  KVM: arm64: Drop useless __GFP_HIGHMEM from kvm struct allocation
  KVM: arm64: Use kvzalloc() for kvm struct allocation

 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.47.3

