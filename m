Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3C17E0E8
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 20:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758141098; cv=none; b=KZWdeF4gVCHWjj1klIx8WO7nQPk6cL8Ja+NzfjFNF/NCRPeyvThpd53wTJun9eXPw/sd8xN4nbZ7Pg5w4+83Fa5LL7vxQoTLnsVQZ3W6bgHUHgh4OzsK2wIgjeRa05om8VyM6J4SwQSKRNwVjyUalfPT2OGhH5EkXuVC39rJMxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758141098; c=relaxed/simple;
	bh=6N/MIBsxXgYX3akD4VzxOpKq8vwRPVZlQyeNtLW01sY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RnX/j1JCp65JCE6bHdgRL33k3L8Aa2W63Uc5eDDb4QaYGRfm7AGwcygwsO/k38DyhqlcmAbVEZsAiNvHS4PdOIhJVXT1GgEvrXCwy7EJ+AxTx6YJJlQhnwDfat2A6AVsFGCDM46DoBqcQzkkrsJE6vrFElWmi0o4ajBnL2J01ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iUuoEMPJ; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iUuoEMPJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758141093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=NOirs6iTmsiiTW2caB6fYpkZEPTBeRYw/OmERRiILS4=;
	b=iUuoEMPJH59kqVcYS2uX6xXogfF+u2JUZ1PYd6Qn/QICXHUXA3iv323DdVAkumOv3jCInl
	m+Ucz+DKY0QXNFBBZ9MFu7ipCy31DtjUb3mAhRS0F7eUH42U1aK6FwJRcEsHqKl1ZpVkht
	6iXAvvHBC5CkBkQBkJJ4daCXGgMSdS4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: nv: Fixes for handling debug, MDCR_EL2
Date: Wed, 17 Sep 2025 13:31:23 -0700
Message-ID: <20250917203125.283116-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As I was working on EL2 support for KVM selftests I realized that use of
self-hosted debug inside of the VM is completely broken. Further
inspection reveals yet another case where FEAT_NV2 does something
insane -- MDSCR_EL1 is redirected to the VNCR page in spite of affecting
the EL2 context.

The situation can be remedied with traps. And after implementing that it
became clear we make no effort of honoring the guest's MDCR traps.
Whoops.

Small series to tidy both of these issues up. While FEAT_FGT provides a
precise trap for MDSCR_EL1, I don't have access to such a system and
would rather send something out that works for now. We can worry about
making this fast later.

Applies to 6.17-rc4.

Oliver Upton (2):
  KVM: arm64: nv: Trap debug registers when in hyp context
  KVM: arm64: nv: Apply guest's MDCR traps in nested context

 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/debug.c              |  3 +++
 arch/arm64/kvm/nested.c             | 30 +++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.47.3

