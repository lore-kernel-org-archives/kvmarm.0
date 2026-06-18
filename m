Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C39C2EFD95
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 15:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781797839; cv=none; b=Bil4Yg0rsokr/MeoraAdqJojCESEgX94du4EL76EpQp/Qn8peTkpLUSPE5ULpxdrsemI4bBhLaEW0iChHMhUNHuBuUHQEAgle24cQkJUxg1D0/JHyD8pKjk22lGDg9VTUnlkZ53Ak8hYTs46PjWse5f0HE2s8KhqzFlXy0pcOg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781797839; c=relaxed/simple;
	bh=Ko2VFee+16pvwP91baMpmxl8dSwJJTNI/GiDgni5tAg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cOL9yJi1mT3ryaaJmeYQt49eGxSE9PjZVSuOmWZxMnCPbDeng6mLMrEaEdNNpRIVEz0ZtVFra6fEQehLPWKHlJwyhWcImXaHizLh/V2Y3z8/TXsv7dgrAnxNDwFPYGe0Anf7wQzr+x7a9s1SIWsCc1Z6xgI7KbHr09+dKNJZ4z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FbOJbtQ6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FbOJbtQ6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5284D491F;
	Thu, 18 Jun 2026 08:50:32 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 918A63F62B;
	Thu, 18 Jun 2026 08:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781797836; bh=Ko2VFee+16pvwP91baMpmxl8dSwJJTNI/GiDgni5tAg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FbOJbtQ6uvaSmA7sqJTrUyCaIgJp0iIB0zoWhwFEu3FK37bHmNHFTNRF4m+BuZrhP
	 lsTc8Uy3M5p9eJjUMch7mrMmtJ6toeOffA/4eFXXDzLycAtMkVOobYoUEnoXGIHT75
	 AuHZ/GawB/49b3bRMM7zmwFkhOQNQ75OVt4UxMz8=
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org,
	oupton@kernel.org,
	jean-philippe.brucker@arm.com,
	andre.przywara@arm.com,
	suzuki.poulose@arm.com,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH kvmtool v2 1/7] x86: Define bioscall only in 32-bit mode
Date: Thu, 18 Jun 2026 16:49:55 +0100
Message-ID: <20260618155001.226266-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618155001.226266-1-alexandru.elisei@arm.com>
References: <20260618155001.226266-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The gcc online docs define the behaviour of the regparm attribute for
x86-32 targets [1], and there's no mention of the behaviour for the 64-bit
version of the architecure.

gcc version 16.1 throws this error when compiling for x86-64:

x86/include/kvm/bios.h:91:43: error: ‘regparm’ attribute ignored [-Werror=attributes]
   91 | extern bioscall void int10_handler(struct biosregs *regs);
      |                                           ^~~~~~~~

but there's no such error with gcc version 14.2.

This patch author assumes that somewhere between gcc 14.2 and 16.1 the
compiler behaviour was modified to treat the regparm attribute on x86_64
as unused. Fix the compilation error by using it only for the 32-bit
version of the x86 architecture.

[1] https://gcc.gnu.org/onlinedocs/gcc-16.1.0/gcc/x86-Attributes.html#index-regparm_002c-x86

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 x86/include/kvm/bios.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/x86/include/kvm/bios.h b/x86/include/kvm/bios.h
index 6f4338d50717..76beb2e0a46b 100644
--- a/x86/include/kvm/bios.h
+++ b/x86/include/kvm/bios.h
@@ -62,11 +62,15 @@
 #define MB_BIOS_SS			0xfff7
 #define MB_BIOS_SP			0x40
 
+#ifdef CONFIG_X86_32
 /*
  * When interfere with assembler code we need to be sure how
  * arguments are passed in real mode.
  */
 #define bioscall __attribute__((regparm(3)))
+#else
+#define bioscall
+#endif
 
 #ifndef __ASSEMBLER__
 
-- 
2.54.0

