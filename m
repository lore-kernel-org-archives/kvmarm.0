Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143723CAE8F
	for <kvmarm@lists.linux.dev>; Wed, 24 Jun 2026 20:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782332693; cv=none; b=MXLo/CE4fYFQp4WRCM1Mm3d85N8KAjhg+t5Ify9KwdvTVaB/YKnnMKa9I3PMIVPQJyL0cVY6SW6hA8JAuprUI0SiaQXE0qST6RMOUraaVL/J0nFnXNyxli5D1gmH/KqZRMUlYw6nZ/rt2BRleOab8zMLV3Y0Dvk8sbLfHUZC1QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782332693; c=relaxed/simple;
	bh=Lkc7uLS8VxnjJBferNZDb+CE75aLMSWaijr6HEzt2zY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LoSJI6MPKthvsZJYeGth81H90hJzq8QsTdlbYsxufZhD6t3NCCAXL2ZmDCMDzbQLx0cvz5Uw8opQHJJ+7tMwQ8s0UamgwDn89zIhqJTs5cT24Ax3d9UaXbDjiwp4opo7H7S+DLFaJKKghjpehI6L6uvCt5tysRPXOgyB4faLYPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FhtgRjYK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhtgRjYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B451F000E9;
	Wed, 24 Jun 2026 20:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782332691;
	bh=SaiY0PYRzfPbuUuxkZCNtIA7XEVg1ACBGxyfc2892eQ=;
	h=From:To:Cc:Subject:Date;
	b=FhtgRjYK4T2XoyEHDu+W5mpKmK5J2vass89Ff2ffTAouBATeml2YawdE6S+M7h0y6
	 yfUfUJp3z4JLve6ww11c1yu0kMCqx10mGOOvB7cre6Zncm8kv9eVoPXIWMKGewQ8AR
	 UG/ZJkkHkbuHaLtDloruxixF6rXxnI56sMugGgc+3q+HuwyznJsL5hWOBoQZLWNlr2
	 egzeSdnhiLRSLft3GwRNFqVoEQ9UepsISGzm3Ysd2IXuYgq5DPStr/NorSKqaWKiif
	 j6HfZpggaKO5ZRUh+PYh/qtKOkTMWfvlvD3qAhHEMj3CaACoxQP0w+N2hWQOvghaCp
	 XU+NR+idNV/Kg==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 0/2] KVM: arm64: nv: Fix permission checks for S1PTW faults
Date: Wed, 24 Jun 2026 13:24:44 -0700
Message-ID: <20260624202446.1698535-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Small series that papers over arch ambiguity around S1PTW permission
faults.

As kvm_s2_handle_perm_fault() wasn't checking for S1PTW instruction
aborts, it was incorrectly evaluating the execute permissions to decide
where to send the fault.

Fixing that uncovers another issue in that kvm_is_write_fault() assumes
any S1PTW permission fault was due to write. Nested screws this up since
an L1 hypervisor could use write-only permissions at stage-2.

We end up papering over architecture ambiguity by potentially evaluating
*both* read and write permissions for S1PTW, assuming any fault with HA
set to require write permission (in addition to read).

Applies to kvmarm/fixes.

v1: https://lore.kernel.org/kvmarm/20260623211310.1529760-1-oupton@kernel.org/

Oliver Upton (2):
  KVM: arm64: Only consider S1PTW a write fault if HA is set
  KVM: arm64: nv: Treat S1PTW permission faults specially

 arch/arm64/include/asm/kvm_emulate.h | 22 +++++----------
 arch/arm64/include/asm/kvm_nested.h  |  2 ++
 arch/arm64/kvm/at.c                  | 42 +++++++++++++++++++++-------
 arch/arm64/kvm/nested.c              | 20 +++++++++++--
 4 files changed, 58 insertions(+), 28 deletions(-)


base-commit: d098bb75d14fde2f12155f1a95ec0168160867ce
-- 
2.47.3

