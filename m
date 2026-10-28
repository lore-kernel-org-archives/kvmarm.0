Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.241
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793185668;
	b=sZyFyRZOXQnfSQteMpgXuB44GcJwzXvjhghGJjQZ2CkPFAIvnRc3WaZozyCKk2g+AACB
	 6Fmj8a5I8xk50EfCyMvevhoX7J/4ICNp51vEEVhykC6TZvw9PJWNk32dBNbZCGH+4RkQ4
	 PP51VpyCG0CulWBRor5E4OLCdBNsmtMcq98O8AvhayWv6xR7747sgtaXY8LYdx6Q5ViGr
	 LpN5gYTTlnbErn2OAfBpJDBv7ZTlxOzX9GlmXMMi6EbqXXepKMjMrd5Om0ygWv7JdEjv/
	 6YRnsngTowNiXWtMbXLdSajjc1rE4EIj3meD4/qV/GevOBmGpT1SD9slKjAGENU08UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793185668;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=miIuE2N/e+SG7Kz34MMJd25ETZ3yxYFkA9Zemr87Wgo=;
	b=y16vg7FcHUPD+OjoqcFu8Rf9dBa2jlexLD+1JIkG05SwopgtUfgw0ucWL6UW2rhdz8vF
	 ydCBQEoI4LbJF2Npl4Q+D2TdZLBJGYQrbPkfiCfP057zR0Mc0qHrGUvfvcRomqz7mHjWM
	 QWNqF+X6KIzpD4DIgE0oUrN/TAMV7xF6k+hkuZaewzFqhQeFACnNvI8KJJihfVVpys9fQ
	 V682KdhFJhlWsv+VK3Srd2ZU7mJWHs5pyQxTLsPLt9fRHqbwsiB5QwAIkTza76+s5bHJl
	 XdKLU8gE2at0ytc/3phMmPSztEOOZUFM0JyvJQTc3XNYYmONXnTdpiUumrKXrB3+B8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JbcWMaMv;
	arc=none smtp.remote-ip=95.215.58.241
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABC0606A31D
	for <kvmarm@lists.linux.dev>; Wed, 28 Oct 2026 11:07:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9ABC0606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JbcWMaMv
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Pg95Y+xFHx1ZIocuSPAyjynJpdUBiCDULSiHROnP0Os=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793185664; v=1; x=1793790464;
 b=JbcWMaMviRNJd8kBhaAtmLnWIDfterzdjIYllNK0xeavjxLbiYJigDFfLD4lnLenqGBmg2Lu
 6yi6fwWuojUcQRLIJIfxP2O7WheAQYb7kHPt+Ckh2WrDB0scnRejCZqMW7mzMP7kVjq4rr2fNRI
 j9CMEK6tunROWqpFNsf898ik=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e69cc8713850fd5b;
	Wed, 28 Oct 2026 11:07:44 +0000
X-Mizu-Trace-ID: e69cc8713850fd5b
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
Subject: [PATCH v2 0/3] KVM: arm64: Fix PMU handling in pKVM
Date: Wed, 28 Oct 2026 11:07:36 +0000
Message-ID: <20261028110739.2366566-1-fuad.tabba@linux.dev>
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

Changes since v1 [1]:
  - Gate __pmu_stop_host_counters() on system_supports_pmuv3() rather
    than v1's per-CPU HAS_PMUV3 flag. (Marc)
  - Collected Vincent's Reviewed-by and Tested-by on patch 2. (thanks!)

Two fixes and a hardening patch for PMU handling in pKVM, as one series
[2].

The first is Vincent's rework of his HPMN fix. It supersedes his earlier
posting [3]. Rather than read nr_event_counters through a different
accessor, the host copies the hypervisor's kvm_host_data before it's
deprivileged, so host_data_ptr() returns what was set up at init.
Otherwise, HPMN is 0 and a non-protected guest's event counters don't
count.

The second is the non-protected half of Oliver's patch from 2024 [4]. It
passes the host's PMU events to the hyp vCPU of a non-protected guest,
whose counters otherwise all read 0.

The third covers the protected half. It stops the host's counters while
a protected guest runs, so the host can't count the guest's cycles and
events. Side channels are outside pKVM's threat model, so it carries no
Fixes: tag.

Based on kvmarm/next (dd0bc00e3e920).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261027081147.498183-1-fuad.tabba@linux.dev/
[2] https://lore.kernel.org/all/86bj8kzix4.wl-maz@kernel.org/
[3] https://lore.kernel.org/all/20261023092007.3918848-1-vdonnefort@google.com/
[4] https://lore.kernel.org/all/20240305184840.636212-2-oliver.upton@linux.dev/

Fuad Tabba (1):
  KVM: arm64: Disable host PMU counters for protected guests

Oliver Upton (1):
  KVM: arm64: Pass the PMU events to the hyp vCPU of non-protected
    guests

Vincent Donnefort (1):
  KVM: arm64: Synchronise kvm_host_data before host deprivileging

 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c   | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/pkvm.c              |  6 ++++++
 3 files changed, 41 insertions(+)


base-commit: dd0bc00e3e9201fd49b62ff9cc07890c89003afe
-- 
2.47.3

