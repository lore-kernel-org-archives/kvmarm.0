Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEF321D5BC
	for <kvmarm@lists.linux.dev>; Fri, 23 May 2025 17:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748019735; cv=none; b=Qns3zwlWEfW0rlt6svx26Z7uJdpl5eNLl9jJ8vbXdje897Ryz679J+2J+ME+L5Rmvy2Rbk3wVBcsmdfer2VrA9tvdeT2mU9525wIDgRXLKgSSTxV9VOZNp5+qeNcuetgm0wIqlPpDpoS709uITZN07mXt5MNLEw2XjGxo55s4eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748019735; c=relaxed/simple;
	bh=XfBSdfdD/kXxiwUBFnPdb6JpH5LmGZGFFN5ATSPDw7U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sjCNW9hmtCKoosW/5OjiTXWUf9sqNlMfyqcyO4SR2rtJrIf2t8OtJNoTS34sc5zPB5WwwiS5FZSBVH5hXVnpmYihsB8j++iJ/2cjay8Yk9S+clbvNjXcfdQWmFk4ATygH3eVlIyriXvqG9CI7wCbyj2cBSfkQ1lszhNb9SotyqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BZxla8oC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BZxla8oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8E4C4CEEF;
	Fri, 23 May 2025 17:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748019733;
	bh=XfBSdfdD/kXxiwUBFnPdb6JpH5LmGZGFFN5ATSPDw7U=;
	h=From:To:Cc:Subject:Date:From;
	b=BZxla8oCDH2AcyoUG4Dlxq243yQYJ3i1MsuTn6NMZi2sG1qJLY+RfF8hSOs1iTp+t
	 2Hb3buvxctMEXV/u6Yj0VVk06w5SCsp3MK9BzfY79XjVyuaGngO30ICFSkjBM462LF
	 wy1cUq4+PzCuynbcBvu6kl7i4rWgcdKodZidlA2qofZdbm1waAnrwalLtvVsYv88P5
	 dp46LYL4G6M4k9aWCxdP33rO13b4L4uRfyFAzG2PtCYBgOze7n91jsXDO5WhJ2+gBe
	 0AuOXhLh0j8hNseJ0iL7arlgd7dzjnZQUHqJw6lhnefBFT12UcKWE4L/JJEa7HAmZq
	 HQa7rpE6RHnNw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uIVmd-0003gD-AG;
	Fri, 23 May 2025 18:02:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Mark Brown <broonie@kernel.org>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: [PATCH] arm64: sysreg: Drag linux/kconfig.h to work around vdso build issue
Date: Fri, 23 May 2025 18:02:08 +0100
Message-Id: <20250523170208.530818-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, broonie@kernel.org, scott@os.amperecomputing.com, catalin.marinas@arm.com, oliver.upton@linux.dev, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Broonie reports that fed55f49fad18 ("arm64: errata: Work around
AmpereOne's erratum AC04_CPU_23") breaks one of the vdso selftests
(vdso_test_chacha) as it indirectly drags asm/sysreg.h.

It is rather unfortunate (and worrying) that userspace gets built
with non-UAPI headers. In any case, paper over the issue by dragging
linux/kconfig.h in asm/sysreg.h. It is the right thing to do, at
least from the kernel perspective.

Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: fed55f49fad18 ("arm64: errata: Work around AmpereOne's erratum AC04_CPU_23")
Link: https://lore.kernel.org/r/aDCDGZ-G-nCP3hJI@finisterre.sirena.org.uk
Cc: D Scott Phillips <scott@os.amperecomputing.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index cd853801a8f7b..f1bb0d10c39a3 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -12,6 +12,7 @@
 #include <linux/bits.h>
 #include <linux/stringify.h>
 #include <linux/kasan-tags.h>
+#include <linux/kconfig.h>
 
 #include <asm/gpr-num.h>
 
-- 
2.39.2

