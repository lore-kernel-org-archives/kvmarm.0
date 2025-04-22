Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C64D1A317D
	for <kvmarm@lists.linux.dev>; Tue, 22 Apr 2025 12:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745324788; cv=none; b=dqsZVlXx23Vwqa8Zc3mn8FfOwUcvum0t6X8jzEYlBQ1kgLOEKD9USCImPfrFWdEQ0RM/2uKm75g2GStKSf9V1ntMK7S07GcdYp90XPcFyoscgYHzKBZSGJGwoQJLkHSCe65dRDxLm7xoyEan3Rag6kVFv6+49PDBLgqoX6bh2Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745324788; c=relaxed/simple;
	bh=pqH1yDInLKI3DmlVSaEG6piUtYhC27nXCsEvC9U0OYI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rDMMzXAfYcjzcQgof+RnIpMXjkf3P3oOIYjDcLMS37aFLirFKDh0EpYaQE0uOgUZFhsCDDcTi8NeYW64D8k61Erdk/ocNulTTTQ1R99v2CKT9QHnxmGh5+9wazP6Huul0Ot+bcGIvm0C3BmuFQW4efmmd9pzqzvQPLt27yZyVus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJK1WV7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJK1WV7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2790CC4CEE9;
	Tue, 22 Apr 2025 12:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745324788;
	bh=pqH1yDInLKI3DmlVSaEG6piUtYhC27nXCsEvC9U0OYI=;
	h=From:To:Cc:Subject:Date:From;
	b=FJK1WV7ZEOCjLnItS+7ihH1OuKUXfnW9H8+QUS5fw44WHz6UyzeRt3ZYI+OldCndF
	 NNEsMCa3QRPV3kF3aBoA11QEQu2Bt2sP5Q3HUzRoIFAErqtN5sl19o0CQ5Lz3AUEvG
	 ESJERqFnpFV9yMyjxi015+IdoQRVhwNkBjxfUT8m7+aczRHYnh0xKOps+ulbgQfA7Q
	 ErXTSmB4QfT9ALGTHHbMKy3crEYjNczOkmj+0CL/nn29qyFr2wmXsYL80g3n6CWhge
	 /I9Botvdf+wUCFyZpIuFMeb2A7Mm8a9HrQVT/aK8AXDIj4OoGy7mP+l0zbNueOMyUB
	 4Pf8c0OCQdbqQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7Chl-007c9q-JA;
	Tue, 22 Apr 2025 13:26:25 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	D Scott Phillips <scott@os.amperecomputing.com>
Subject: [PATCH 0/3] KVM: arm64: Address Translation fixes
Date: Tue, 22 Apr 2025 13:26:09 +0100
Message-Id: <20250422122612.2675672-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, scott@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Here's a small series of fixes for KVM's implementation of address
translation (aka the AT S1* instructions), addressing a number of
issues in increasing levels of severity:

- We misreport PAR_EL1.PTW in a number of occasions, including state
  that is not possible as per the architecture definition

- We don't handle access faults at all, and that doesn't play very
  well with the rest of the VNCR stuff

- AT S1E{0,1} from EL2 with HCR_EL2.{E2H,TGE}={1,1} will absolutely
  take the host down, no questions asked

Patches based on 6.15-rc3.

Marc Zyngier (3):
  KVM: arm64: Fix PAR_EL1.{PTW,S} reporting on AT S1E*
  KVM: arm64: Teach address translation about access faults
  KVM: arm64: Don't feed uninitialised data to HCR_EL2

 arch/arm64/kvm/at.c | 59 +++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 23 deletions(-)

-- 
2.39.2

