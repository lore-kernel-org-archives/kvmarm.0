Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89BB320E
	for <kvmarm@lists.linux.dev>; Tue,  3 Jan 2023 12:07:53 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F5D71516;
	Tue,  3 Jan 2023 04:08:34 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BEE8A3F587;
	Tue,  3 Jan 2023 04:07:51 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH] MAINTAINERS: Remove myself as a KVM/arm64 reviewer
Date: Tue,  3 Jan 2023 12:07:36 +0000
Message-Id: <20230103120736.116523-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.39.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Haven't done any meaningful reviews for more than a year, and it doesn't
look like I'll be able to do so in the future. Make it official and remove
myself from the KVM/arm64 "Reviewers" list.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7f86d02cb427..813673637500 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11356,7 +11356,6 @@ F:	virt/kvm/*
 KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)
 M:	Marc Zyngier <maz@kernel.org>
 R:	James Morse <james.morse@arm.com>
-R:	Alexandru Elisei <alexandru.elisei@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Oliver Upton <oliver.upton@linux.dev>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
2.39.0

