Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 687481CC172
	for <kvmarm@lists.linux.dev>; Thu, 22 Aug 2024 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724339494; cv=none; b=uZzpdADTz79kKfNiUIsSGpjMnMRcZQNmdDGhrc9i8i319cjEu683UH9RLI438GvunCH0R0NNQx35v2+eRidtCXneRkS0V9RccDMrJwmYPawbkZyYUDM5TINzQWZR0mzfcKgySER/8xlM2CPmdWKp3fkEzbu8TKUIqcI5OWvNjJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724339494; c=relaxed/simple;
	bh=OgOF4aP3d/eoPRqHdpUelEtCRZwNWw2rYjXXBRVelPE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jwcNxfZg5F0NA7vVeo4OWhGC1iLZNwfrbIEsuMh4549RcHRq7iMN+f7QKRHO6TFGZvheRZEpjtN3pbGQKDrTwl36oo3AmCRlE1ScUQkOPpBNlfB7CCoB6je4N2wtyniuu17WUTXYQYR3awOCdNsD7ihXBUmJoSEjzAVeFJqR8GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 037931576;
	Thu, 22 Aug 2024 08:11:59 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D92D73F58B;
	Thu, 22 Aug 2024 08:11:28 -0700 (PDT)
From: Joey Gouly <joey.gouly@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nd@arm.com,
	akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	aneesh.kumar@linux.ibm.com,
	anshuman.khandual@arm.com,
	bp@alien8.de,
	broonie@kernel.org,
	catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	joey.gouly@arm.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	maz@kernel.org,
	mingo@redhat.com,
	mpe@ellerman.id.au,
	naveen.n.rao@linux.ibm.com,
	npiggin@gmail.com,
	oliver.upton@linux.dev,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	szabolcs.nagy@arm.com,
	tglx@linutronix.de,
	will@kernel.org,
	x86@kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v5 02/30] x86/mm: add ARCH_PKEY_BITS to Kconfig
Date: Thu, 22 Aug 2024 16:10:45 +0100
Message-Id: <20240822151113.1479789-3-joey.gouly@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240822151113.1479789-1-joey.gouly@arm.com>
References: <20240822151113.1479789-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new config option specifies how many bits are in each PKEY.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
---
 arch/x86/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git arch/x86/Kconfig arch/x86/Kconfig
index 007bab9f2a0e..683c0a64efe2 100644
--- arch/x86/Kconfig
+++ arch/x86/Kconfig
@@ -1889,6 +1889,10 @@ config X86_INTEL_MEMORY_PROTECTION_KEYS
 
 	  If unsure, say y.
 
+config ARCH_PKEY_BITS
+	int
+	default 4
+
 choice
 	prompt "TSX enable mode"
 	depends on CPU_SUP_INTEL
-- 
2.25.1

