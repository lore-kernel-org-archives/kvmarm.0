Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3982824BD03
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 02:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749782226; cv=none; b=iExC+yIck2SN3yOMw4UjoMZHds8XA/XdRX/9tk2DcgodgdBs3H9/lZz02mh+zavOdoJipeRPi52w0qPiJhE3j8j8yFLRWGnGLBdvbkYdig6lxFa8Zy6CS3odPJo+fTP7TooX7tDiUILXYHFP1OG89rcPMlFbuxuvu06J2VkDN+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749782226; c=relaxed/simple;
	bh=uMLZZIGntfima+Z+v7TifEE3E+4sqrRZ2e8DOcSjaoU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EjUJq3cXQgGGrGUFPBU5Ygj6LeNx7YuzXLv8JQ+Slv81DTMgB28RY4U+ZQSpxDdjUi+pL6f7KXU/d6s55oZgQyX/PE0qnmsbWXY6tJaVLzttVYDK88OESr7KfhOBYTQsqrjNHXHkSAN+8pi4slxoBs/rPBRvFfNqLPnJDDGpDCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 597D81D14;
	Thu, 12 Jun 2025 19:36:43 -0700 (PDT)
Received: from a076716.blr.arm.com (a076716.blr.arm.com [10.164.21.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A571B3F673;
	Thu, 12 Jun 2025 19:36:59 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH V5 2/2] KVM: selftests: Change MDSCR_EL1 register holding variables as uint64_t
Date: Fri, 13 Jun 2025 08:06:46 +0530
Message-Id: <20250613023646.1215700-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250613023646.1215700-1-anshuman.khandual@arm.com>
References: <20250613023646.1215700-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change MDSCR_EL1 register holding local variables as uint64_t that reflects
its true register width as well.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 tools/testing/selftests/kvm/arm64/debug-exceptions.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/debug-exceptions.c b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
index c7fb55c9135b..e34963956fbc 100644
--- a/tools/testing/selftests/kvm/arm64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/arm64/debug-exceptions.c
@@ -140,7 +140,7 @@ static void enable_os_lock(void)
 
 static void enable_monitor_debug_exceptions(void)
 {
-	uint32_t mdscr;
+	uint64_t mdscr;
 
 	asm volatile("msr daifclr, #8");
 
@@ -223,7 +223,7 @@ void install_hw_bp_ctx(uint8_t addr_bp, uint8_t ctx_bp, uint64_t addr,
 
 static void install_ss(void)
 {
-	uint32_t mdscr;
+	uint64_t mdscr;
 
 	asm volatile("msr daifclr, #8");
 
-- 
2.25.1

