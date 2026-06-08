Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED69D345751
	for <kvmarm@lists.linux.dev>; Mon,  8 Jun 2026 16:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780935291; cv=none; b=Gl/U5rb5S2WD/fozTp7JAFgogOO7TluNwd5w25Ej7PxxhElGhfqy8qXPTDwL6svFlI4HXe4MK7qqrcuZd/9EAzPCW+7QjTK1zqpvqPXEGjKS/Ene/AbZuSHrwn5jnFf4yb1WnMMww4pmwHEB05/OpaCO1lC1PmmbAHtP3vxjlAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780935291; c=relaxed/simple;
	bh=9SH/cudvX52DGv2ny9DurWlRxZr4Qlwgq8m3z+lEx9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=upsaUoPZWZrS3lKen3dftbCamyjEKJTdlHWthGk+muJsYQIKyWgQtEECUC4cs2Xz9ihF7N/PdlhrE80XWgJCKIKTKh4NuKmX3wQjnngnVDF+nXzrbBtEA1ddaJWJHc9N4O1X8RKU9WLscJqsKzd6pGPkoYgPMwcpZnpt26uNKVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsdwI373; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsdwI373"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7DD1F00899;
	Mon,  8 Jun 2026 16:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780935289;
	bh=U/5xc3RPnZ2BKXwM5O535wYk/P6ZtZfpSjfrj8XileE=;
	h=From:To:Cc:Subject:Date;
	b=MsdwI373bC++px3UtIr8JAfDZZUuc3bFxvylxV/+WACXiZzh1YqqdGDJOSlXbTWmz
	 UzvFzTKoizT0mr5y6XbYFnrxV7Vh+27BxkgDVkwqGq7scvSnSNun9fY2oV3hkjg6xM
	 3wvV9fE0j1Hw8SjctxaY2qP+r2ng9OE9ECq1l92w84iEv3EisafwKN8676DCf6PGOI
	 4XK1VLmz+WULlVz7kKhBHUIF7zXZT0pLravJ6lFRctX2mathX7uDmP0wba0B/7LNVl
	 ARYJaNvXTDqlkpl/4Wz2TUVaa2YUdml3MrdQ3uXkfyLAXU/sgZBEIGirHmNzv9AFwD
	 QBdQgBFiOZPEA==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 0/2] KVM: arm64: nv: A couple more VNCR fixes
Date: Mon,  8 Jun 2026 09:14:44 -0700
Message-ID: <20260608161446.718957-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Another day, another handful of ugly MMU bugs.

The first addresses an issue where the host stage-1 VNCR mapping only
relies on the guest stage-1 permissions, potentially allowing RW
accesses to an RO PFN.

The second avoids a BUG_ON() in the case that the output of stage-1
translation exists outside of a memslot, and instead does the usual
thing and injects an SEA.

Based on kvmarm/next since the first pile of MMU changes was taken
(thanks!)

Oliver Upton (2):
  KVM: arm64: nv: Respect read-only PFN when mapping L1 VNCR
  KVM: arm64: nv: Inject SEA if kvm_translate_vncr() can't resolve PFN

 arch/arm64/include/asm/kvm_nested.h |  8 ++++++
 arch/arm64/kvm/at.c                 |  8 ------
 arch/arm64/kvm/nested.c             | 40 +++++++++++++++++++++--------
 3 files changed, 38 insertions(+), 18 deletions(-)


base-commit: 406f0c31f47877db036e885f15830106b89ca950
-- 
2.47.3

