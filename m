Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793606331;
	b=pyUrh2Jkuxl7+wxmvuxECglLiFAw6387DpvdOqQLWlS9cJ+VhK9MumnytH4zocCdkJiK
	 6O14aes89fGLJS7bZtAPoLnRECvLfk/uMMHWItf/14SaY3evk98Q3eUcCKUdg4SskBZ8Y
	 eqo2ITPKHjCVabgsj9ukBm5DuneJJvg0DCz1oL3hsyGfocF3lHtuN5m+D3b5EsShMN9M1
	 e6Kdwk3bswHh7QJbKAIKgFVKR37I51oeFdIdxKFaU9tr85703r/DwdYUJLr4sA35i1EI3
	 eAIOmq5F/BQuvMxIwKGOOTHo7L4MPjc23EZdXOYgUme7tLtP3osRt92wnAaILABkVmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793606331;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=+JdS4G63s5YrX6ja9msk8fkBfAQWzo4U4td4gFNglHI=;
	b=lGBqrxItOFSakDCZvX3xMuiAHY5Shi859th/4mZwnA4fYO/ka3w7ARVhYNm2mqGX3FWt
	 jvvGD5xFPCtRqZEg6y9FmDNDvUEPhKZQQj+gNPtlAPIJ2NZiefNvkm2DSRDJjadrV2D20
	 sj+kteCQ/M25vqM0sIlXS4jI5CssJ78acVhum1rp05d1LkYnKDtIAy7DvO0MfBhRAmfQu
	 +wDzohC9r1czA1hlTPHbXgbRysuOj03nvDKn3C0W/V+h2ZjtYmGbvz5U+1CLOjAHqjl5g
	 cgXDch/NKERfLBJH6blv9vczANJTuw0Sfp3xjN1Est9zhiZSH66WtU+5LFnB+gn1mcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="l8fM/8oX";
	arc=none smtp.remote-ip=91.218.175.62
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F32606A329
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 07:58:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34F32606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=l8fM/8oX
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=OPCNKwKilXKP7yPXswDvwmi3hPbRw7m/9nNCGlJWJ7g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793606328; v=1; x=1794211128;
 b=l8fM/8oXnEBp1ZMX+BTQ0PLIAisq+rvezWYZWxHTJ7z38YaWoyG4vstEyCCdbQnk2cdx3mHM
 xesZPrn2UKdNn4H+vE8A8SU+5MhBgh0VMbUh+FSpK5ANedsEX9z04YavgM1RrTci0OHv4cBtsVB
 qPG9BNi5kGfr3xXgquHJUwAk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 483c354dba814e72;
	Mon, 02 Nov 2026 07:58:47 +0000
X-Mizu-Trace-ID: 483c354dba814e72
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jack Thomson <jackabt@amazon.com>,
	Congkai Tan <congkai@amazon.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v4 0/2] KVM: arm64: Clear VM-wide state when kvm_setup_vcpu() fails
Date: Mon,  2 Nov 2026 07:58:41 +0000
Message-ID: <20261102075843.2556018-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

Changes since v3 [1]:
  - New patch 2, clearing the default PMU left set by a failed INIT.
  - Reworded patch 1's commit message.
  - Rebased on 7.4-rc1.

A KVM_ARM_VCPU_INIT whose kvm_setup_vcpu() fails doesn't undo its
changes to VM-wide state. Patch 1 clears the feature bitmap, which the
PMU attributes read before the vCPU is initialized. Patch 2 clears the
default PMU, which a retry with KVM_ARM_VCPU_PMU_V3_STRICT would
otherwise inherit.

Tested under QEMU on a host without FEAT_NV1 (an Apple M2 MIDR,
for which has_nv1() returns false), with a reproducer that fails an
INIT and then initializes the PMU, directly for patch 1 and after a
STRICT retry for patch 2.

Based on Linux 7.4-rc1.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260921190843.107881-1-fuad.tabba@linux.dev/

Fuad Tabba (2):
  KVM: arm64: Clear the VM's feature bitmap when kvm_setup_vcpu() fails
  KVM: arm64: Clear the default PMU when kvm_setup_vcpu() fails

 arch/arm64/kvm/arm.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.3

