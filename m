Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335D41DF97C
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769195803; cv=none; b=g2UdhulTAt1smmXJ2IEgQL5bkoy7arqVOOISAl0zBvWddky1SUt7DxTRRqZgo3K2x/hrWs2XO3FrLDDBkJEdJGju4/d9mMUzGhKKBqY8upsI+gnzmT2ZX9wkbO3Z5WSQ/KkcJrYt8f4sMNRRgWlAorhCL5VHy1jVKUcbNqJRRJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769195803; c=relaxed/simple;
	bh=IUD3nTPA9qQNHBqt4olcYwi3n/JoCOTBd4pADTKpWb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IR0FCYqpHOS1U+0+UKa0vSg1YxpfmiwbxwGIzEUx/R2lV4z3wZ2xw3GPuBIlQdsu4Fzw/EaSmEFQmSPiqpjscUCZSm68tdy13ppsfWSs8m/s+WebJUgcrOgmsV2reFHvxqREFe2h6likOP/o0FidZrgiUrs+RzNLXg5kWKkfx94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y25Zu1cL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y25Zu1cL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF69C19423;
	Fri, 23 Jan 2026 19:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769195802;
	bh=IUD3nTPA9qQNHBqt4olcYwi3n/JoCOTBd4pADTKpWb4=;
	h=From:To:Cc:Subject:Date:From;
	b=Y25Zu1cL9t4B9XYzyz7O9EcnPR9g4B2TFROwn+TmDIAilw/JLu6ALrrDJmOIwahRh
	 2AIeG0jruLZdkryWduaLuR0Jh7ekHMfiOE2JMLaX91ZI0X5yZBI/9ZgPEiC+hEcf84
	 J3k7l9VDMTaU1HGcyJRAL7AcEaD6SA6v5y+WS57GPxTKy1wjfPbPIYoV01IEzCjpv0
	 ZlQ4QsA+Bf7PuYWjhdvJwb8OTX4znkStitXUdoNtzEqtc7b23VHikDfSSrbgVC3k5g
	 8D6k27kbxuEsOEWZIHZnOzkmup1+4kacregSheXi6LxFEnsWG67uRvSQ6fYZN0j3wy
	 v0BJRe7Z+Uftw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vjMe8-00000005A2V-2Lq2;
	Fri, 23 Jan 2026 19:16:40 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 0/5] ... and FWB for all
Date: Fri, 23 Jan 2026 19:16:32 +0000
Message-ID: <20260123191637.715429-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

[Yes, I have since learned that FWB doesn't always mean "Force Write
 Back". I'm not judging.]

This is v2 for this small series teaching pKVM about the benefits
(haha) of using FWB on the host S2 page-tables.

* From v1 [1]:

  - Dropped the stage2_pte_cacheable() hack after both Will and Alex
    made the valid point that I can't read

  - Killed stage2_has_fwb() altogether

  - Collected RBs and TBs, thanks to Joey and Fuad!

[1] https://lore.kernel.org/r/20260119105651.255693-1-maz@kernel.org

Marc Zyngier (5):
  arm64: Add MT_S2{,_FWB}_AS_S1 encodings
  KVM: arm64: Add KVM_PGTABLE_S2_AS_S1 flag
  KVM: arm64: Switch pKVM host S2 over to KVM_PGTABLE_S2_AS_S1
  KVM: arm64: Kill KVM_PGTABLE_S2_NOFWB
  KVM: arm64: Simplify PAGE_S2_MEMATTR

 arch/arm64/include/asm/kvm_pgtable.h  |  7 +++----
 arch/arm64/include/asm/memory.h       | 11 ++++++++---
 arch/arm64/include/asm/pgtable-prot.h |  4 ++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  4 +++-
 arch/arm64/kvm/hyp/pgtable.c          | 26 ++++++++++++++------------
 5 files changed, 30 insertions(+), 22 deletions(-)

-- 
2.47.3

