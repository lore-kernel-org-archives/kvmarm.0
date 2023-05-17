Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24691111AD
	for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 20:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958E6C433EF;
	Wed, 17 May 2023 20:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684355038;
	bh=M1muL6P9balayQTirNwNw7ozwMwB4GRF5EDrvyljyDw=;
	h=From:To:Cc:Subject:Date:From;
	b=RS/yL6l/vCWKXEPfvT+pPNWM5hgDu9e51+o6EU6T+haO2y02zgKBySeHRS9htKr2J
	 5XTwCb4gdfKu7wRPGdeIcbbg4Y0TfD47pzLPt0LnFVDte3Da0vw5/ejCm238U/VKnC
	 l/HK9uVCjFTgzSiANETHWbM6F8aOjcGiIcwM1znLlMxqNqmqt5u2YhjF8E9tWFd8ur
	 o6P4D5jD4R0xzQp3OLes5YqA3NMx/NRt4n+5SzaRtfqRKScGjSqvK1xCAKoblwYO5R
	 aKZmlX4ZfNTPfsxMiqRzucpzLAh+EGQQDqn1+vqcZIMN9wDMvb2xYbfGIlPh2qOfHP
	 H632CwXXX0iKQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	Gavin Shan <gshan@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: kvm: avoid overflow in integer division
Date: Wed, 17 May 2023 22:23:39 +0200
Message-Id: <20230517202352.793673-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The newly added kvm_mmu_split_nr_page_tables() function uses DIV_ROUND_DOWN_ULL()
to divide 64-bit addresses, but this requires a 32-bit divisior, and PUD_SIZE
may exceed that when 64KB pages are used:

arch/arm64/kvm/mmu.c: In function 'kvm_mmu_split_nr_page_tables':
include/linux/math.h:42:64: error: conversion from 'long unsigned int' to 'u32' {aka 'unsigned int'} changes value from '68719476736' to '0' [-Werror=overflow]
   42 |         DIV_ROUND_DOWN_ULL((unsigned long long)(ll) + (d) - 1, (d))
      |                                                                ^~~
include/linux/math.h:39:47: note: in definition of macro 'DIV_ROUND_DOWN_ULL'
   39 | #define DIV_ROUND_DOWN_ULL(ll, d) div_u64(ll, d)
      |                                               ^
arch/arm64/kvm/mmu.c:95:22: note: in expansion of macro 'DIV_ROUND_UP_ULL'
   95 |                 n += DIV_ROUND_UP_ULL(range, PUD_SIZE);
      |                      ^~~~~~~~~~~~~~~~

Since this code is only used on 64-bit targets, DIV_ROUND_UP() can deal with this
more easily, as it already takes 64-bit arguments.

Fixes: e7bf7a490c68 ("KVM: arm64: Split huge pages when dirty logging is enabled")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/kvm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3386bd28d267..6db9ef288ec3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -92,8 +92,8 @@ static int kvm_mmu_split_nr_page_tables(u64 range)
 	int n = 0;
 
 	if (KVM_PGTABLE_MIN_BLOCK_LEVEL < 2)
-		n += DIV_ROUND_UP_ULL(range, PUD_SIZE);
-	n += DIV_ROUND_UP_ULL(range, PMD_SIZE);
+		n += DIV_ROUND_UP(range, PUD_SIZE);
+	n += DIV_ROUND_UP(range, PMD_SIZE);
 	return n;
 }
 
-- 
2.39.2

