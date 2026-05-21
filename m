Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10146211A28
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 13:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779369989; cv=none; b=QDPvmeiyeqxdlLrzu2xApBYrttSsEr01AroR1pG0g2Rq1dUwoTD1EFhQQoKoOwrG8bpv7S49AL64GPN3kmHyFPBQ4fj9W8/K9P5/E3TqwapmHwieek59hX8GkuIiXeiI39y/KXBoxbARuOYgCmHxzhdp5zt0iawhcCeIz5KK/+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779369989; c=relaxed/simple;
	bh=4qNWyG9/rqhhK0Ngv0vgf96xD7URLLi+kRllF+9yecc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m/ndYhy33nfU3AmaTH72G+XmvLv4PfSuzyKkGAkuZ157Cj+ZmyAVX+n71Me6ffPHcGFJtNHjT1huCL1TEk1d3foI01RstV7ieXGXtriLZ0jLPPixNkjoD1/4nQYjmJn+tYcqqCauENmZoZnOu9ZPiVLI5YgddoQzWgit4IED9x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=C1nmKM0n; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="C1nmKM0n"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 518D23585;
	Thu, 21 May 2026 06:26:22 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 34F663F7B4;
	Thu, 21 May 2026 06:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779369987; bh=4qNWyG9/rqhhK0Ngv0vgf96xD7URLLi+kRllF+9yecc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1nmKM0nZ6FdsNb/pGKtxENYrQSpAd8KUAl1CKsARFayP2Q+qHmVucqMCXm3Dnv2I
	 WRSEzR+8DkzhGzEG3uht17kYeK8p2vX2lyVO9zZp9PV6n+UfaWBcrOrOBNNnIAt6WI
	 DzevceyRlRKWTU/Cd5kZZW4XAGTgFhUjbZdAH7cA=
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	mark.rutland@arm.com,
	maz@kernel.org,
	oupton@kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 10/18] arm64: sysreg: Add FPCR and FPSR
Date: Thu, 21 May 2026 14:25:48 +0100
Message-Id: <20260521132556.584676-11-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260521132556.584676-1-mark.rutland@arm.com>
References: <20260521132556.584676-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add sysreg definitions for FPCR and FPSR.

Some versions of LLVM will refuse to assemble accesses to FPCR and FPSR
unless the "fp" arch extension is enabled, which we don't currently do
for read_sysreg() and write_sysreg(). In general, handling feature
dependencies would complicate read_sysreg() and write_sysreg(), and it's
simpler to use read_sysreg_s() and write_sysreg_s() instead, requiring
sysreg definitions.

The values used can be found in ARM ARM issue M.b:

  https://developer.arm.com/documentation/ddi0487/mb/

... in sections:

* C5.2.8 ("FPCR, Floating-point Control Register")
* C5.2.10 ("FPSR, Floating-point Status Register")

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/tools/sysreg | 45 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 6c3ff14e561e6..fa155cd856a5b 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3790,6 +3790,51 @@ Field	1	ZA
 Field	0	SM
 EndSysreg
 
+Sysreg	FPCR	3	3	4	4	0
+Res0	63:27
+Field	26	AHP
+Field	25	DN
+Field	24	FZ
+Enum	23:22	RMode
+	0b00	RN
+	0b01	RP
+	0b10	RM
+	0b11	RZ
+EndEnum
+Field	21:20	Stride
+Field	19	FZ16
+Field	18:16	Len
+Field	15	IDE
+Res0	14
+Field	13	EBF
+Field	12	IXE
+Field	11	UFE
+Field	10	OFE
+Field	9	DZE
+Field	8	IOE
+Res0	7:3
+Field	2	NEP
+Field	1	AH
+Field	0	FIZ
+EndSysreg
+
+Sysreg	FPSR	3	3	4	4	1
+Res0	63:32
+Field	31	N
+Field	30	Q
+Field	29	C
+Field	28	V
+Field	27	QC
+Res0	26:8
+Field	7	IDC
+Res0	6:5
+Field	4	IXC
+Field	3	UFC
+Field	2	OFC
+Field	1	DZC
+Field	0	IOC
+EndSysreg
+
 Sysreg	FPMR	3	3	4	4	2
 Res0	63:38
 Field	37:32	LSCALE2
-- 
2.30.2

