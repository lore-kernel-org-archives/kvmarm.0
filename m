Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A3B3A6EFC
	for <kvmarm@lists.linux.dev>; Tue,  2 Jun 2026 23:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780444497; cv=none; b=d4+iX4ju+mDbNC4+eHUQPPAckNzdg2NhlJMI0N73hS2O8lBV7O8vi/idD+JKiL3HhzOWhdlOOYkLxJiL2pMZ3jRY0pmufSxtLsfGpLcMMmuYZKXUnCchqK87Ar7XCWrF0CpcdA9dK3dE24re/Hff539tVOUxBsJEXbskrvaYZ8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780444497; c=relaxed/simple;
	bh=zreFA6evpq5ZmEPzt1b4qX3c8KQ/fVv8f7/N+OOL4ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PKULC1X1X+7TIjlbQVPzbiiIeX7+FiHBY8RYIw/tyat66JxYovo28s9sQbWpm7Ka0o3R6ZMlurB/cqxo2FPwLWEO7Mr8obz+X7ARs7J+3bijBcwX1aKVfOi0yCrnEcrz8LkdeMCixFNP8AqdZsfqwBlW+7P5CNDZciXmRi8aqz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PgDEb7Df; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PgDEb7Df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB14B1F00893;
	Tue,  2 Jun 2026 23:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780444495;
	bh=wHsuHu5uAndYyZpvzHuiEEAHKix99kGoueiqPvxxG70=;
	h=From:To:Cc:Subject:Date;
	b=PgDEb7DfcB08IepgJs8O7cl2+Zz6cL2q6b4Gns8SOZ4X7LM4b3iw5kJWjfy/fgIjV
	 08LG/9dj2fjFEQc2D5abLXba9Of0j3rgIq3PZHrNFikXp3TlVlRqDdOPJ0xNQ44N6D
	 eloEvq7gCAFS5t1XeUv3brv3zPqcKQGrWvHcw8zeYbCD+SnTiUB9PsaNHFlki53ZrR
	 qbxXSvstYboy3GlZYSKTvTq4iynwV8omVpOUMkFnSS4ueYF3rE3HOqjj8oI03plnA7
	 Q/006YMOgw7/Aox2tLTZuPBKaYkemRa5c7EW8iDlPYMN0ImhW2dfEXJNNNFHolk8Fu
	 eIe3azS2Uc8tQ==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 0/5] KVM: arm64: nv: MMU fixes for 7.2
Date: Tue,  2 Jun 2026 16:54:45 -0700
Message-ID: <20260602235450.103057-1-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I've accumulated a small pile of nested MMU fixes as part of a larger
series, flushing those out as a separate thing that can land for 7.2. As
is the trend these days, some of these bugs were found by sashiko
review and others were found in the process of fixing the AI bug
reports.

Oliver Upton (5):
  KVM: arm64: Don't leak PFN when kvm_translate_vncr() races MMU
    notifier
  KVM: arm64: nv: Fully update VNCR fixmap state in kvm_translate_vncr()
  KVM: arm64: nv: Inject SEA TTW when desc update can't write to GPA
  KVM: arm64: Restart instruction upon race in __kvm_at_s12()
  KVM: arm64: nv: Restart stage-1 walk if stage-2 desc update fails

 arch/arm64/kvm/at.c     | 14 ++++++++++++--
 arch/arm64/kvm/nested.c | 38 ++++++++++++++++++++++++++------------
 2 files changed, 38 insertions(+), 14 deletions(-)


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
2.47.3

