Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539DA220F3F
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758214005; cv=none; b=ZU6JQWHYZMN8/1qihYWxSU/lWA3oaRgROtWr+ob1cSht9nNguu4sJx5eXvKo9IdUpGNjRsrCoNvUS2ZzUbaA8eJ6xaJeLXl+9ISR2s5ITLsfciXleF/lude/YLpeep8DgZJz53EoBu103/EFC4ky3BWXeu9k4PyVLuJKVcJmeCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758214005; c=relaxed/simple;
	bh=beUteRQjvMB3m7FhkWzxhZMY0r1Fsk90pOMqKn3So5g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QwpaTeMZGTMb0XUotJDDazv7xmoC/8ziLjoQr2eOcQfhOTVY6YKdtrrFSW9+L7BnqbZWdPD+x+gc5nFJqgDj5tISn894YvDX+wqzKkCaa/0jfoRVacf6ITyPsTgoHZYp1qUJScriS34HpMhC5pY3qqTYpNwsnh09teISN4fVdsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HtRUqXsE; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HtRUqXsE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758214001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XEgMtaUtnYgTp0CTc/UmfbPTf5CJVtEQn37G9wjzMWI=;
	b=HtRUqXsEa8HNsrdidLAp3fJ1vlBLQ638i8NbqEF/zgad8/USE/BpdanpOYIQGaIv2hoGk1
	am4cpKxaUlgW2H0/GRojUJ/YVixhavnmWfQzRk5ojsbpSb+SHcyH8YR3aGUQ1LGACLaSBF
	qcxlZYlWGBKT3ltjWJj7k6pV/aHBiW8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 0/2] KVM: arm64: nv: Fix SError injection at EL2
Date: Thu, 18 Sep 2025 09:46:30 -0700
Message-ID: <20250918164632.410404-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

FEAT_NV2 keeps us out of the loop on changes to HCR_EL2. That really
sucks when the guest hypervisor toggles bits that affect the hyp
context, such as TGE and xMO.

The architecture now allows an implementation to treat HCR_EL2.AMO as 1
any time that HCR_EL2.{E2H,TGE} = {1, 0}, effectively allowing us to
hide what would otherwise be a quality of emulation bug in SError
injection.

Unfortunately there's nothing to be done for E2H0 VMs, although given
the direction of the architecture the offending hypervisor should just
get with the times...

I've included the selftests change for demonstration purposes only, I
plan to incorporate it in my EL2 selftests which it currently depends
on.

Applies to 6.17-rc4.

Oliver Upton (2):
  KVM: arm64: nv: Treat AMO as 1 when at EL2 and {E2H,TGE} = {1, 0}
  KVM: arm64: selftests: Test effective value of HCR_EL2.AMO

 arch/arm64/include/asm/kvm_emulate.h          | 14 +++++++
 .../selftests/kvm/arm64/external_aborts.c     | 38 +++++++++++++++++++
 2 files changed, 52 insertions(+)


base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.47.3

