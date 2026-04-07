Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6827237AA94;
	Tue,  7 Apr 2026 21:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775596211; cv=none; b=sa/HjUD1sGw6EC5kFJiE9kJuWH3CZWs8v2xB6nqID7sZPRUTOA6d3/9c5OvmBGb+drxAD5PisnOGIn8KuwMxcVRuG9nsV41R7CmU2lGAHaShShNbalo0vWnoSaWYiUryNAbscX+XCvtjnGKhLSjdo7FGt0TXC6rdIKlOKuEH8A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775596211; c=relaxed/simple;
	bh=lXsl8ibSsadbUCnfx1SxHJTkQ/CRmJTImtRAdgEs0bc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=aaXqhTtXkxo3UugsSk4H+VG0mCngQ0qme2I7tAmdR+8JPolKtU3QrlIstDaXbqYbsjv/vXnSI0yOqwBXY/JeKy3c4RBQgi1hLaLYzEvSahICeup9+gBAqqn2RxY+Fmu+MKLtKEaWgRXwLtFxukjQRxj51I9NuMzKlfI45xtQYhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EbSVYnC+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EbSVYnC+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Cc:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PnND6iHBMV6WE1ZHJaECUBIFEEiEhNHhl942sAfaZN8=; b=EbSVYnC+aoucRZI1t/3rJLmcgk
	SNk5+GvL37isalRUjPlqIJjPz6o2HlMFTzBTXkduIEJm5ameGW+WG53vYY1Z771BNYaMQABDakZb6
	2LTG4Vktm8Xb2RlPvOlBTAp3Qvun+8KOHjDSq1FekuKcUoafrmG2YFG3uJN0t/+zcArnBUW0XDz89
	bEFz0EkIh28qL1DNxgTZvcL/JsdJhAS14t5/f6QyZQcbyAloDnVnouRXNt4y1Eaud/WGR15fp7xS+
	A1LbgqzHmow88ah2ZNLXlU616ZEyBBgrzK3otVYBdWbPp5EeSlS9hXdw7FNwCOMDwuHInAqoBN3gh
	Eh/OEGhQ==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wADgI-00000004GbB-3Zu8;
	Tue, 07 Apr 2026 21:09:54 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wADgI-00000008iI5-1hTK;
	Tue, 07 Apr 2026 22:09:54 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Eric Auger <eric.auger@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/3] KVM: arm64: vgic: Fix IIDR revision handling and add revision 1
Date: Tue,  7 Apr 2026 21:27:01 +0100
Message-ID: <20260407210949.2076251-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

The uaccess write handlers for GICD_IIDR extract the revision field
from the wrong variable, making it impossible for userspace to actually
change the implementation revision. Fix that.

Additionally, allow userspace to select IIDR revision 1, restoring the 
behaviour from before commit d53c2c29ae0d ("KVM: arm/arm64: vgic: Allow 
configuration of interrupt groups") behaviour where interrupt groups are 
not guest-configurable. This is needed by hypervisors that were 
reverting that commit to preserve the original guest-visible 
semantics.

When revision 1 is selected:
 - GICv2: IGROUPR reads as zero (group 0), writes ignored
 - GICv3: IGROUPR reads as all-ones (group 1), writes ignored

The IIDR revision comments in both vgic-mmio-v2.c and vgic-mmio-v3.c
are updated to document all three revisions.

David Woodhouse (3):
      KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value
      KVM: arm64: vgic: Allow userspace to set IIDR revision 1
      KVM: arm64: selftests: Add vgic IIDR revision test

 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   7 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   6 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |  15 +++
 include/kvm/arm_vgic.h                             |   1 +
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../testing/selftests/kvm/arm64/vgic_group_iidr.c  | 112 +++++++++++++++++++++
 6 files changed, 140 insertions(+), 2 deletions(-)


