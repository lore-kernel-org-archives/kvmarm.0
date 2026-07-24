Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791523D669B;
	Fri, 24 Jul 2026 08:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784882871; cv=none; b=hdorVdVrgAt7nHoUNlOfa0yzIQmmU9QsheSC8JscPmR2kuadMJ+sJhwq62REMRTcwDX6sTtpicjt6rzY18E+931LsSlfIY+eHbKSzKNnzIxTjmIQiX+9N0npsGzfgISbY+JzjecwxVORemWCUBLgJEVN6Mj2gCDZVwcC0+jfLxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784882871; c=relaxed/simple;
	bh=pgLSBPsuW94uYqkQE0iqKvJSbBjiXY5JOe0Yc4s8dvU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SDwPkh4ijW2CqIUYPVbeLNJB9Eb3Fhj0TT6MB4C99FtUc5KRmXmKVH0LmcIYkQFIDu14MfvpyfSyNNoK17vzgrdSA3z9qyf21lk6a3MiypEpl4KGq0fPk7HmyjxRZQr8Komd2m0yCl2a7uIx8CK8f+QaVhnzRNWioIoemaqcCcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6pDOTAW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6pDOTAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B6B1F00A3A;
	Fri, 24 Jul 2026 08:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784882868;
	bh=uKLIfBLG1tq0sn4tnF1BsPaKM61vke1+Ik5sqk+B9hs=;
	h=From:To:Cc:Subject:Date;
	b=I6pDOTAWnXXAN8/KovxZG8z6DUDCbvAnAiMK/YYX3Bt5PnRAAMo1du8PdgwKMHYGJ
	 anPwADR6ZPYd1ZARervT+mqWCI/eUVva3zJVyMFl7K98e3ZpxXikvHER5kFP1w06va
	 eVcRX7nnGsEs+EjCOrzyHQ/CrdbtJwazbGbPx3C7kj+Gvy7mUa+g7A0vQWK6aUK8hr
	 UBdTNqbNMLLQfMNoCVfdZbnlWnQE6vBEaPurmu7XnCgxpqZXHizvQqrKhXnPEyx4g2
	 y1X+B9G1lbtw8gebYPDQFHdAxoQh0NjQK9HKprWnChN3lEgmwVbig1jBGUwWyOxHNM
	 78Go6NLNOH4xQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wnBZK-00000008Ls6-1roU;
	Fri, 24 Jul 2026 08:47:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Vincent Donnefort <vdonnefort@google.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 fixes for 7.2, take #3
Date: Fri, 24 Jul 2026 09:47:42 +0100
Message-ID: <20260724084742.3358321-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, clopez@suse.de, scott@os.amperecomputing.com, fuad.tabba@linux.dev, vdonnefort@google.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Paolo,

Here's another set of KVM/arm64 fixes for 7.2. A bunch of fixes for
AI-discovered issues, with two main areas of activity:

- plugging annoying LPI mapping races

- fixing corner cases in the EL2 tracing management

The rest is a heady mix of CPU errata workaround, API tidy up and low
impact fixes.

Please pull,

	M.

The following changes since commit 1590cf0329716306e948a8fc29f1d3ee87d3989f:

  Linux 7.2-rc4 (2026-07-19 13:54:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-7.2-3

for you to fetch changes up to 679d7201c1f09e37fa1c12ce28d84079c17fc87f:

  KVM: arm64: Reject guest_memfd memslots when the VM has MTE (2026-07-23 09:57:06 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 7.2, take #3

- Fix a tiny buglet when propagating the deactivation of an interrupt
  from a nested guest, which happened to trigger a gold plated CPU bug
  on a particular implementation

- Fix a race between LPI unmapping and mapping, resulting in leaked
  LPIs

- Make LPI mapping more robust on memory allocation failure

- Fix the handling of the EL2 tracing clock being disabled

- A couple of Sashiko-driven fixes for corner cases in the EL2 tracing
  code

- Add missing sysreg tracepoint for the EL2 code

- Tidy-up the mutual exclusion of guest-memfd and MTE

- Update Fuad's email address to point to @linux.dev

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: Reject guest_memfd memslots when the VM has MTE

Carlos López (2):
      KVM: arm64: vgic: Fix race between LPI release and re-registration
      KVM: arm64: vgic: Mitigate potential LPI registration failure

D Scott Phillips (1):
      KVM: arm64: vgic: Avoid double-deactivate of IRQs in the nested context

Fuad Tabba (1):
      KVM: arm64: Update Fuad Tabba's email address

Vincent Donnefort (4):
      KVM: arm64: Fix hyp_trace clock disabling
      KVM: arm64: Fix potential leak in hyp_trace_buffer_alloc_bpages_backing
      KVM: arm64: Fix hyp_trace_desc allocation size in hyp_trace_load()
      KVM: arm64: Add missing hyp_enter when trapping sysreg

 .mailmap                                    |  1 +
 Documentation/arch/arm64/silicon-errata.rst |  4 ++++
 Documentation/virt/kvm/api.rst              |  6 +++++
 MAINTAINERS                                 |  2 +-
 arch/arm64/include/asm/kvm_hypevents.h      |  1 +
 arch/arm64/kvm/arm.c                        | 25 +++++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c          |  1 +
 arch/arm64/kvm/hyp_trace.c                  | 36 +++++++++++++++++++----------
 arch/arm64/kvm/mmu.c                        |  4 ++++
 arch/arm64/kvm/vgic/vgic-its.c              | 25 +++++++++++++-------
 arch/arm64/kvm/vgic/vgic-v3.c               |  8 ++++++-
 arch/arm64/kvm/vgic/vgic.c                  | 18 +++++++--------
 include/kvm/arm_vgic.h                      |  3 ---
 13 files changed, 93 insertions(+), 41 deletions(-)
