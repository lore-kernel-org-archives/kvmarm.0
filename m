Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693809;
	b=IPuKneom/Om8Eb6Pr2haUOGBHZ3sc2HLjw7/UPxNsMjAXJRqPpACUGY4voRTWoGdmnIm
	 2+/LchttLPQKF+h+GkhWHZD0a9CgoOyPZ9dWGd1G1EabEyoq7I/UxrVbDedmXYghaSK19
	 Q31rgqCKrxJ/o3rxj7LaAMR6Oyucs7mgkWSKs5fomaMsFlNT4FE5ea2DDf3yORdvsKbbE
	 S6adPHTjsoJNq5B+FM8vOZkJdJzGoxCUAkiWvwfCiAbvge0itP3KJQ3mvahhTCq5t7QWq
	 3C16jWhJG0LB2SYaBIXyKbcv4RezZSM8eFGlT8+tRSWDDc4x2NYvhk4w/QkbyFmBRIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693809;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=2S/oZLZTT9f3qlYq/XC7o5Hag90eTEHtjkMZtGEzJxs=;
	b=B2JvC0iCVvMZLOFfuowhy95aD1OJwrr64obNcaXFiLwQbOAL41m/cWD04V7HhNbS7V+u
	 MIq4PNnDQ6+IY5adIEc7QypZpHuK/7ETZULM3Ch2wbcazoZxXBwuI/AFfRB6jSpT5wruc
	 jJQxrraaNYoFL/YHQCD6/1TmxuSGxp0X0A8kx0og376dRfHkgYDumASzh5w/hGTbdouQx
	 SNWSvyIROlwBSo+nh+/kp6aotAnRvCYqAhRE8kKtBa3l+YdZHzbLrn1UnTdy3Trix4PGI
	 BuBeeEUupnu4/NtJxdro9Qx9zJ2vXZiJmrkyFdlugz3BBTGvFID8q4lW+uFQOtS9dRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=g7L2HRRN;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456DE606A31E
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 11:50:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 456DE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=g7L2HRRN
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B843A1CE2;
	Thu, 26 Nov 2026 03:50:05 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 556463F632;
	Thu, 26 Nov 2026 03:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693808; bh=qJYRR+auXt60sDD5z7pZDCBtdiRPKzJH61ZeXsXTu3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7L2HRRNlf9cMEVESKmWUZNsFgw2UWg5mPpQlYEQQcpnWpkT/NRDGHk2kdXiCE9Jl
	 PTjFBFzgAZMw+iKRetgUAgF6/rQJ65WRLfGINWXP6qmE3GvGRG6zu/3fkcVVbPeLJ+
	 80qCxZg+9QTMiU3NRp5zv5asd9cyKvj6VSNi2hEg=
From: =?UTF-8?q?Kristina=20Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-efi@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [RFC v2 01/13] arm64: sysreg: Add definitions for TLBID
Date: Thu, 26 Nov 2026 11:49:24 +0000
Message-ID: <20261126114936.864256-2-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261126114936.864256-1-kristina.martsenko@arm.com>
References: <20261126114936.864256-1-kristina.martsenko@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Describe new system registers and fields added by FEAT_TLBID, so that
later patches can use them. This is based on the latest system register
specifications (version 2026-09, see Link).

The size and number of fields in VTLBID* registers is determined by
information in other registers at runtime, so can't be described
statically here.

Link: https://support.arm.com/architectures/a-profile-architecture#Downloads
Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 arch/arm64/tools/sysreg | 53 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 997c62ab72e6..d7fbffba9235 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4374,7 +4374,9 @@ Field	0	nPMECR_EL1
 EndSysreg
 
 Sysreg	HFGRTR2_EL2	3	4	3	1	2
-Res0	63:15
+Res0	63:31
+Field	30	nTLBIDIDR_EL1
+Res0	29:15
 Field	14	nACTLRALIAS_EL1
 Field	13	nACTLRMASK_EL1
 Field	12	nTCR2ALIAS_EL1
@@ -4594,14 +4596,16 @@ Fields	ZCR_ELx
 EndSysreg
 
 Sysreg	HCRX_EL2	3	4	1	2	2
-Res0	63:35
+Res0	63:37
+Field	36	FNB
+Field	35	VTLBIDOSEn
 Field	34	NVnTTLBOS
 Field	33	NVnTTLBIS
 Field	32	NVnTTLB
 Res0	31:28
 Field	27	NVTGE
 Field	26	SRMASKEn
-Res0	25
+Field	25	VTLBIDEn
 Field	24	PACMEn
 Field	23	EnFPM
 Field	22	GCSEn
@@ -4751,6 +4755,38 @@ Res0	25:19
 Field	18:0	INDEX
 EndSysreg
 
+Sysreg	VTLBID0_EL2	3	4	2	8	0
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBID1_EL2	3	4	2	8	1
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBID2_EL2	3	4	2	8	2
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBID3_EL2	3	4	2	8	3
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBIDOS0_EL2	3	4	2	9	0
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBIDOS1_EL2	3	4	2	9	1
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBIDOS2_EL2	3	4	2	9	2
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBIDOS3_EL2	3	4	2	9	3
+Field	63:0	TD
+EndSysreg
+
 Sysreg	DACR32_EL2	3	4	3	0	0
 Res0	63:32
 Field	31:30	D15
@@ -5798,6 +5834,17 @@ Res0	16
 Field	15:0	PARTID_MAX
 EndSysreg
 
+Sysreg	TLBIDIDR_EL1	3	0	10	4	6
+Res0	63:45
+Field	44:40	NVOS
+Res0	39:37
+Field	36:32	NOS
+Res0	31:13
+Field	12:8	NVIS
+Res0	7:5
+Field	4:0	NIS
+EndSysreg
+
 Sysreg	LORID_EL1	3	0	10	4	7
 Res0	63:24
 Field	23:16	LD
-- 
2.43.0

