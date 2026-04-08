Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBBF388E5D;
	Wed,  8 Apr 2026 11:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647991; cv=none; b=EMARhABevKkjHOCjkskW1qtdb1xcJJrmnm4kQHVxX7ESDH3UpbWsJO2beecOLZbDI1RaSQ0QvcmYX6OEAuxyrQzJtaW6tsKKyvXK3cPQ9doutf1R6hhtKCz5+MbTDXdGhPzFCD3PANaL9Kcb3FbS7hOt26UEoSjsXM/eMMl4NPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647991; c=relaxed/simple;
	bh=ez1JFxYvFppo+ug92qQkCyhnr0IkQ5IjpypalI2Io9c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b+1+/rFYMNvXs2ktBZQ6A7mhkiBX+v9U/gpF7vxeBJUBds7OXddqhFtTUN5heTlAwTv2XygZsyyWtHDYM1tS2CmXWsGI9AOSjabGm/GZYo6MW/bZm7TW8aKSMvAbfL+GiERiY/A4JpUD6nMhvx92wBYdv4QeGFk/QfplhYwayi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gSwmlzvy; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gSwmlzvy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Cc:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=6TzX40mZ42Ra39otAJCKSTIeu0P/Czs5MfsYtFj7/fo=; b=gSwmlzvySp4I9bHhapW2U8Puw6
	uo3jm5afYRluhqtMwvZ9J52kY8F8p/mVCtDV1z1aia/iUUbITmUAp6O9Fs0x4FJFm/0mHGWyGx3qs
	f/UnZOJZWu3DE+5Hogsb3qtdcr/z55k64TgjzJ5DGqRIrd2B546+3TmzzznNtixaffyp3uaaUnt63
	4nJG1oU+hpbKpMs6uiK+z39WyX4S1aVAkM1hPZ65PYBxR8/Ef8caMcndZgOCQx97yuv0kQ5UojHtJ
	jfsQufYmR25whddmpm1iyU/O/Js85gtQTpsGW9Nu1z3iQH+/M5vHIuBetjEmVVPPwbrGxT79ow8xJ
	W1AucIZA==;
Received: from [2001:8b0:10b:1::425] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAR9V-00000005Ier-2k1t;
	Wed, 08 Apr 2026 11:32:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAR9V-00000008n9x-0nmU;
	Wed, 08 Apr 2026 12:32:57 +0100
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
Subject: [PATCH v2 0/5] KVM: arm64: vgic: Fix IIDR revision handling and add revision 1
Date: Wed,  8 Apr 2026 12:30:31 +0100
Message-ID: <20260408113256.2095505-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

The uaccess write handlers for GICD_IIDR extract the revision field
from the wrong variable, making it impossible for userspace to actually
change the implementation revision. Fix that.

Additionally, allow userspace to select IIDR revision 1, restoring the
behaviour from before commit d53c2c29ae0d ("KVM: arm/arm64: vgic: Allow
configuration of interrupt groups") where interrupt groups are not
guest-configurable. This is needed by hypervisors that were reverting
that commit to preserve the original guest-visible semantics, and to
allow for a safely controlled deployment of the new behaviour.

For GICv2, kill the v2_groups_user_writable flag and make the behaviour 
depend directly on the IIDR. The existing default behaviour of setting 
the IIDR to revision 3 and allowing the groups to be writable by the 
*guest* but just not by userspace was just weird, and almost certainly
not intentional. (New in v2 posting).

Tested on Graviton 3 (Neoverse-V1) metal for GICv3 selftests, and
under QEMU TCG with GICv2 emulation for GICv2 selftests.

v2:
 • Fixed -Wdiscarded-qualifiers warning from 0-day bot.
 • Remove GICv2 v2_groups_user_writable flag and just use IIDR.
 • Address Marc's review feedback (no special cases in read_group,
   other minor cleanups).

v1: https://lore.kernel.org/all/20260407210949.2076251-1-dwmw2@infradead.org/

David Woodhouse (5):
      KVM: arm64: vgic: Fix IIDR revision field extracted from wrong value
      KVM: arm64: vgic: Allow userspace to set IIDR revision 1
      KVM: arm64: selftests: Add vgic IIDR revision test
      KVM: arm64: vgic: Remove v2_groups_user_writable and use IIDR revision directly
      KVM: arm64: selftests: Add GICv2 IGROUPR writability test

 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |  18 +--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   6 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |   4 +
 include/kvm/arm_vgic.h                             |   4 +-
 tools/testing/selftests/kvm/Makefile.kvm           |   2 +
 .../testing/selftests/kvm/arm64/vgic_group_iidr.c  | 118 +++++++++++++++
 tools/testing/selftests/kvm/arm64/vgic_group_v2.c  | 168 +++++++++++++++++++++
 7 files changed, 306 insertions(+), 14 deletions(-)

