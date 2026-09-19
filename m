Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977ED22D792
	for <kvmarm@lists.linux.dev>; Sat, 19 Sep 2026 12:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789821116; cv=none; b=BCpCTCS+MdvPdGEmtAYOdAiJ5XmeZukSKaDQfSUEE7KD0vyHN/n7xwOXcGKLbAZQPhOwovvcjX1Z16/tQ9g6ArrQjsJeUDWasrrYtcZSz/ErTF9zLjR98ZF3Wy7oH/wWCXrum+EOmZiZGWIIqrRz6WrdC3/bh5vAbkYObKSYT9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789821116; c=relaxed/simple;
	bh=+toKym1tQBxTcwVBdTspUrU3Y48hYMXLlkplFnqZERM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I54uEArZuqV9/CN792nvn1zldQeJKMXxpmu3aDE4BUlldGsNN2qz/z0ZScs5mpvMcMZyhMkuMTIPdBvKc21Tq5BaxQPxZcy3Gx75QFg4IJN7vIqKYwuF4kB6V0ahOLWWqkMK+IqCj5r5aQD/fJJqDNfX3Te1h57tkdzO/0tZGeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyhswBnB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyhswBnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366CB1F00893;
	Sat, 19 Sep 2026 12:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789821115;
	bh=Thp73DKm6JO24PWrqan5R+YfnElzkHZpkgKKuA6jZCM=;
	h=From:To:Cc:Subject:Date;
	b=WyhswBnBmEtrQyxk43p2ixsKmtp5K3L0JKNkJJ85FTbVTbvooGVitehSP4Le+7XKr
	 e/TDJhf2XlzeSoZA243M192/jUtbmkJ5tFeJle9SmCFoezZ+ghcdTMAKfLNJFFiFpF
	 0Io+2Fzl6sxXwMKcfWmciNYJKCe0Pxf0TwPaLm+s3s8pQRvm0xV/gkIDJ5NgBBovmb
	 2OZ0f9zw0GgHtjFWljwhgjFxyrsabTRopatzBKgEZMqsNRflIBoYuDhI/Gin+jFna6
	 lPGEr0YrpmH+AnZyH+c6igSMyQrLlovdhYErmGh6Xtc1iMv20YpPe+xNAGJHdTixOF
	 EJlqRiSzLSEuw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x7uET-0000000AwvV-0OcV;
	Sat, 19 Sep 2026 12:31:53 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 0/4] KVM: arm64: vgic-v5: Random sparse fixes
Date: Sat, 19 Sep 2026 13:31:46 +0100
Message-ID: <20260919123150.3283606-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The LKP bot has been reporting a bunch of sparse warnings in the newly
merged vgic-v5 code (mostly in the table code) that we could do
without. I've therefore investigate those, fixed them, and some more.

I'm queuing this on top of the existing branch.

Marc Zyngier (4):
  KVM: arm64: vgic-v5: Drop __iomem attribute from {vmd,vpet}_base
  KVM: arm64: vgic-v5: Correctly reset h_lpi_ist to NULL
  KVM: arm64: vgic-v5: Tidy-up programming of vpe descriptor address
  KVM: arm64: vgic-v5: Correctly handle host ISTE __le32 conversion

 arch/arm64/kvm/vgic/vgic-v5-tables.c | 24 +++++++++++-------------
 arch/arm64/kvm/vgic/vgic-v5-tables.h |  4 ++--
 2 files changed, 13 insertions(+), 15 deletions(-)

-- 
2.47.3

