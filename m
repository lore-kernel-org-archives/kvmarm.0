Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.212
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793088721;
	b=wIHDVvSZmHkWqgcEgN62GdiO2a7FuHJjKLNQoSeaPvTRCn/04oclvaZUST2+Z2iq/BXY
	 OBcHAUcAniCAUJE2rc19YTHgUYjy6Gaq8LioWG3ddSnMj4M6c7+HOT7byOwaYVrHKgcpT
	 Q+7LLf2IaszsZTnLZWrwRDCH1XUJwN99zl2YnRaBJRZ5qqdYrYBz24Kr980xr5m7WHhoX
	 NV8CgtQnxKtKVOp9K9A1a5oja3IHdKZjmGBmAjoK0k0C8UIimnSoCCUo/6L8Xw9/2Hkxa
	 sH/Gc2Eohr4+8TlXfDfUwMuqof0RBg5lCL4KWj/d/T9mv0ez+oKHSltNHj8tEipc1+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793088721;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=gb5sZs9kXKkHxMOBK0QCN7nKSbVD+3tuMPiUXhvbYWs=;
	b=ZSY2wuE8mMzxlRQXcTjUZpOWzf9SWdvKrRQD+hn9i22a9oo86aBgl1iBFL8n6qcYpI0f
	 o2Ogn8I9MbW6EIrcjKkCMD7c44BuiD3cw0bLzX8BnVm3JcNeqn8fdR5RSXwqX+TSTgwlb
	 kNvAVKu+sMjJkABIzF4ZsKOtN2IhachlAZBvVrTFLvWjj2DgMeJ4/PSfUIf6CAiC89xNA
	 8ZrLc5dmdQvDNSVYLp5e7pmti80ggqYoTYgyc/4zT64yvXHogXswXy6PITD1BocSuudwC
	 kCp1benpFeQrPCk1NgSDM6991rH6ghPQ8OZdIuWInlD6Hhu5syJ0INHlhDsePsz/9wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=91.218.175.212
Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D644606A31B
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 08:11:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D644606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=uPm1bCuVoiN/lEjit+HbKmRBz2Yja0dVUN8FPqoeyWI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793088712; v=1; x=1793693512;
 b=U0BJUmhX6RzNk2/1qkmWnQdb3QryqZz51xgBbvnMpozZvRbiaxWB2hkdQ53sMVYEDPg7u+Cg
 YqMPfztZI0Y8rZdq9z+651ka5O8LUIvsiXN3dfQe5V4FBJlC2sv1ty+cL9uBOmba9HluKY/CZ7B
 MmXHxSp6221CY4ky4tZmTbHE=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 45e916e20e21a3dd;
	Tue, 27 Oct 2026 08:11:52 +0000
X-Mizu-Trace-ID: 45e916e20e21a3dd
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	Oculytic <oculytic@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 0/3] KVM: arm64: Fix PMU handling in pKVM
Date: Tue, 27 Oct 2026 08:11:44 +0000
Message-ID: <20261027081147.498183-1-fuad.tabba@linux.dev>
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

Two fixes and a hardening patch for PMU handling in pKVM, as one series
[1].

The first is Vincent's rework of his HPMN fix. It supersedes his earlier
posting [2]. Rather than read nr_event_counters through a different
accessor, the host now copies the hypervisor's kvm_host_data before it's
deprivileged, so host_data_ptr() returns what was set up at init.
Otherwise, HPMN is 0 and a non-protected guest's event counters don't
count.

The second is the non-protected half of Oliver's patch from 2024 [3]. It
passes the host's PMU events to the hyp vCPU of a non-protected guest,
whose counters otherwise all read 0.

The third covers the protected half. It stops the host's counters while
a protected guest runs, so the host can't count the guest's cycles and
events. Side channels are outside pKVM's threat model, so it carries no
Fixes: tag.

Based on kvmarm/next (dd0bc00e3e920).

Cheers,
/fuad

[1] https://lore.kernel.org/all/86bj8kzix4.wl-maz@kernel.org/
[2] https://lore.kernel.org/all/20261023092007.3918848-1-vdonnefort@google.com/
[3] https://lore.kernel.org/all/20240305184840.636212-2-oliver.upton@linux.dev/

Fuad Tabba (1):
  KVM: arm64: Disable host PMU counters for protected guests

Oliver Upton (1):
  KVM: arm64: Pass the PMU events to the hyp vCPU of non-protected
    guests

Vincent Donnefort (1):
  KVM: arm64: Synchronise kvm_host_data before host deprivileging

 arch/arm64/include/asm/kvm_host.h  |  1 +
 arch/arm64/kvm/debug.c             |  4 +++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c   | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/pkvm.c              |  6 ++++++
 5 files changed, 45 insertions(+), 1 deletion(-)


base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
-- 
2.47.3

