Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793296377;
	b=ZNXCM0H+hzdGfhc/WoT3mXvrWan2GbE+7vtxeklQpZZF4JzgQ4hq0b938Acf1FoYjzAK
	 EDl+PuJzcl88NtqkFGNle/vdKNHlHyofzP46wQJvGMEHJRn3ruq+/FpsSmGYtuKdUfUTN
	 0KCqsWSqOU1smvcwruzCfsIXjzKL8XJeIWeyBwLhgrF/bsfm6T2L4CQCirrGjikeT8nXB
	 MiaBDCMfUSX4LE+/twZH3tlPMBGlx15Krct1/tljjnu12V1Cpr5yx6ku7O2fsfIJMe9Vm
	 4KJuL8DS6V85YkgosuVAh4DNkTp3+C0d1CIejguai1jFbgG/ZUbjW982Ur30m1/w2jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793296377;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=V7BTev0WvCIE8h6eACl3FNzYopQ4CdXZtkVISOrxWo4=;
	b=Gxf+r18EgMgRLAEvqTuFKeJqCcJSgOo8GYkpPdVrguHQqhSRVT8e2ScjtFvtKYvmmMff
	 kQp/Mxf5hgqvjNS1qZnNhFPcIGfWvhZ8Nyqe9fSLVVWTkRusqD3HxlFcYj9iW23Ukc1nr
	 m/ph9/OUcrBoM+MZarnWrbDa+sy/rZG09XSu6XbInC+3EHxpqX8MsZGR/E3HcOgy4tIG6
	 z5ijJ5N/9nq0Wq07ZsLN+dAJ+yCqUxIDN3YNyWqF2lMtabZwKhSywsa3dKAkOC/OX3ou8
	 l0yUmv1+WXcz9V+/pcdSixYCkrJvDuNFpMpalqUlt3qXkCLFXudhJH3OsxuQPkwdtiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=u21D0kvR;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41022606A31A
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 17:52:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41022606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=u21D0kvR
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16FC91682;
	Thu, 29 Oct 2026 10:52:52 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C16FC3F59E;
	Thu, 29 Oct 2026 10:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793296375; bh=MNFLu7TIDuMgXYx4iE9e2hGmnIPJuc4afAnBP3Vqi/M=;
	h=From:To:Cc:Subject:Date:From;
	b=u21D0kvR1fNWXpIClKGGaqeqXHxTgbsSymQisb5BH1b78NUzlwCulVk/KTLyPs7mB
	 ba9oY4769umLVIEO5efHcazaKglIuThMRc7TrB1zRZwb5iJCtdbCP/Xwpf9MAdZCpQ
	 SDWHyjkgka9xfE3Dk5ufmflxBIKikBCi0t/L3euU=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v2 0/2] KVM: arm64: Dirty logging fixes/cleanups
Date: Thu, 29 Oct 2026 17:52:36 +0000
Message-ID: <20261029175238.3214788-1-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
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

Hi,

These are two fixes/cleanups I found when reading the code. It fixes
dirty logging detection in ring-only mode and updates a stale comment.
Please view the patches for more detail.

* Changes from v1 ([1]):

  - Keep memslot_is_logging() and use kvm_slot_dirty_track_enabled() in
    it. This preserves the RO memslot check.

  - Change patch 2 to updating the stale comment only, the original
    change is obsolete now.

  - Collect Reviewed-by and Tested-by tags from Fuad (thanks!).

Thanks!

[1]: https://lore.kernel.org/kvmarm/20260605153248.2412064-1-weilin.chang@arm.com/

Wei-Lin Chang (2):
  KVM: arm64: Fix dirty logging detection in ring-only mode
  KVM: arm64: Remove stale remark on canonical IPA alignment

 arch/arm64/kvm/mmu.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

-- 
2.43.0

