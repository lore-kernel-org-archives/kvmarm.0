Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81C23090C5
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 19:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771530949; cv=none; b=ZWWIXGTBWmggG/WT1vvkSJX171Y+5bAiaFIXIzXX2j54IhG1kSFVFuCaLSoj2V5kfLBiKEvo4bBJjEJIAcy/BN6boZYKLS8KJEAhxFnkaY1zRMl5NPdqFTfagsylYVNsrE5fMZ9CEpfWVGrNaWUjbMojOqHLBMuJMjtCe3oH4y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771530949; c=relaxed/simple;
	bh=9dkLJcyYrJI/hl+KbQtaNiNmaXXwcbzNYCd1MB4z2eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2KZaz+Ol3N5FOoNeGEzBCnbHc0iIfs9ARXqf5AzWVvo4Uo7M4QZO3iUr2IzZbjADFLAR/EVnY45uySjpT2mOMkEqr699gRe8D9QpgfdGI2WJvqK/5CJcNEkUR1lhrxjj+neDpYKauyh+p1s9j7b/pDuwBEBPTqAy5hZHvfS3pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZjzh6Ie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZjzh6Ie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FD0C4CEF7;
	Thu, 19 Feb 2026 19:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771530949;
	bh=9dkLJcyYrJI/hl+KbQtaNiNmaXXwcbzNYCd1MB4z2eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZjzh6Ie4bAHZt3jyVKU8xhg1VINBCP9HXA6KbKl3rzGGSYI2978sNuWOUKITbpsh
	 mcDIQouok6cKsfCS/VmMep3/TnYnyGwc74dqQy4dpGbtJEwNUGD+q4IEhY2hv2ooeA
	 SKBJeXC5jTurKzNQUeOZW6XHyDCZagNGwaitTiwNHTCE1+izBY5KJXDgvs87ptlA8a
	 zXOQDewH6N4IU800GtK7uxdpN/9avZDiUz68m3NZt0k+T8NRm9T6zepT3gVJgYINvQ
	 3qxEJCKuewgDxXpqvZuTGxzuIOe8HDPt0a6KCx0IG2Q8m4yVWxrlYc14m4ibDfK3Zp
	 FMsRgdRwtKiTA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vtA7n-0000000CGHL-1eOd;
	Thu, 19 Feb 2026 19:55:47 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 9/9] arm64: Remove FTR_VISIBLE_IF_IS_ENABLED()
Date: Thu, 19 Feb 2026 19:55:32 +0000
Message-ID: <20260219195533.2455736-10-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219195533.2455736-1-maz@kernel.org>
References: <20260219195533.2455736-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that FTR_VISIBLE_IF_IS_ENABLED() is completely unused, remove it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 2731ea13c2c86..adaae3060851c 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -62,8 +62,6 @@ enum ftr_visibility {
 #define FTR_CONFIG(c, e, d)				\
 	(IS_ENABLED(c) ? FTR_ ## e : FTR_ ## d)
 
-#define FTR_VISIBLE_IF_IS_ENABLED(c)	FTR_CONFIG(c, VISIBLE, HIDDEN)
-
 struct arm64_ftr_bits {
 	bool		sign;	/* Value is signed ? */
 	enum ftr_visibility visibility;
-- 
2.47.3

