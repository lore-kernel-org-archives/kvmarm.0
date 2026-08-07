Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A3E2EEE9E
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 10:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786099283; cv=none; b=YL+t0y6nk0+LW4wCWXtKzrZbglXPIk/nJ2FJqt8E4W74MWFQw/gvymwH/lBXrgQpfrxchCiQExEJVhYrkoJ/mgmr+JKZ2Lp0MiVJ3Y6++T4Geq91ryL6EzrbeGlgYM0qUj7L+73WxqqrVlyPl7o5VKMC1sxj4Zeh39LxwSWEVGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786099283; c=relaxed/simple;
	bh=a5VWfKfLFu0WLEK5/JAgYfptxlU4x7ZtoLJpeQ5bBv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iaqYf9BUOn+rbycFNqfuUlMloaBHV8m8tXhHZUELVn3mowic5CSDk3Jm8EfAEpY5pJVrff5Ew1NzTEkUxC8LTVsHRP1NDfnw8wP99trPScKHlc7AMTU0MCCn9Q81qO8MM271ghGq8+4IZH8wyy/XnOvZn3l9wA6xs0mK72/PHss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hfyUC4DT; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hfyUC4DT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786099279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EuxLL5anSxH0ImkGmtlRd/tPm7fjlfNIOn8PqzfUkSE=;
	b=hfyUC4DTnMqdKE6bKBikrIsAS8bO140kIo7H8WY4M6xfeOHd/+8S+/y39XXrrCyg69PpQ4
	NOt/PJKlUyuGSLEv1LHrDS5zTZDzsgn5Lz7CO2JIDuMxLVlpQ4J+ltOq8u+8iUeZbIK1X1
	4JZdLtzlnabW4+3v0hyUwgHgcbPgR2c=
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] KVM: arm64: vgic: Fixes for ITS table save and init retry
Date: Fri,  7 Aug 2026 11:40:58 +0100
Message-Id: <20260807104102.2410744-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi folks,

Respinning today since I am travelling until the 17th and will be slow to
reply.

Changes since v1 [1]:
  - Patch 3: check the collection ID with vgic_its_check_id() instead of
    bounding the walk by the table size, so a collection the table cannot
    address is not saved either. Retitled to match. (sashiko)
  - New patch 4: skip the ITEs that are saved as invalid when computing an
    ITE's next-event offset. (Oliver)

Three unrelated vgic fixes, and one follow-up to the first of them.

The first is the one that matters the most. A guest that issues MAPD,
MAPTI and then MAPC(V=0) leaves an ITE mapped with no collection, and
the next KVM_DEV_ARM_ITS_SAVE_TABLES from the VMM oopses the host. That
is three ITS commands and an ordinary migration save, with no race and
no allocation failure.

The other two are weaker and come after it. The init fix stops the SPI
array leaking when userspace retries KVM_DEV_ARM_VGIC_CTRL_INIT after a
failure. The collection table fix stops the save writing past the end of
the table, and stops it saving a collection the destination will reject.

Patch 4 is not a fix. It makes the restore scan skip the invalid entries
patch 1 writes instead of stepping through them one at a time.

Patch 1 is unchanged. Oliver also suggested deleting the ITEs when their
collection goes away, but I do not think it removes the need for the
check here: vgic_its_free_collection_list() reaches the same state with
the ITTs intact, and that path is not UNPREDICTABLE.

Patches 1 and 3 are reproduced, each with a selftest that fails on an
unfixed kernel and passes on a fixed one. Those are not part of this
series, happy to post them separately if they are worth having.

Based on Linux 7.2-rc6 (075b74841bd00).

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260805093828.3626610-1-fuad.tabba@linux.dev/

Fuad Tabba (4):
  KVM: arm64: vgic-its: Don't dereference a NULL collection on ITT save
  KVM: arm64: vgic: Don't leak the SPI array when init is retried
  KVM: arm64: vgic-its: Don't save collections the table cannot hold
  KVM: arm64: vgic-its: Point saved ITEs at the next valid entry

 arch/arm64/kvm/vgic/vgic-init.c |  3 +++
 arch/arm64/kvm/vgic/vgic-its.c  | 26 +++++++++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
2.39.5

