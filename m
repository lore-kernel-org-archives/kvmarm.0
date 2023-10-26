Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C86F2D782;
	Thu, 26 Oct 2023 12:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VZ9j04vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C4CC433CC;
	Thu, 26 Oct 2023 12:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698324414;
	bh=bZPOq75obKgR16PHbo86C4WPqSIy0lDpy+567+6KdtA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VZ9j04voioUdaBycGNSzqTlU6jt2ZX21l8S3Cv5onpRT0ybfRy46GbUaOKuLlwxFC
	 IxmAuzT49WZKLWAzr3WNIVNUrud/7pfA7wOgj1q+0FUoEkYtG4Fk1g1X0+g1MFFCir
	 XXPgX+1WfvEeeg1XZCrcVRWGdezWksoAkuzCfgUeoDOPVNeqREtZsr30IsYmte7fJm
	 P4WUR0fIlKwpJWr59VV8a1xQLcQOv7XvaBqKHDwIsLxPCfGAIbwo9xcBbi8wb1jSDB
	 WENfgGZTmXdWLrSXI+fhx2Um0ruFpZ4KT5nu4vtHVPpO2zYck/oYZnPHQDGISfe2/n
	 q7GAVYEOXMI+w==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 26 Oct 2023 13:44:21 +0100
Subject: [PATCH 07/21] arm64/sysreg: Update HCRX_EL2 definition for DDI0601
 2023-09
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231026-arm64-2023-dpisa-v1-7-8470dd989bb2@kernel.org>
References: <20231026-arm64-2023-dpisa-v1-0-8470dd989bb2@kernel.org>
In-Reply-To: <20231026-arm64-2023-dpisa-v1-0-8470dd989bb2@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-0438c
X-Developer-Signature: v=1; a=openpgp-sha256; l=666; i=broonie@kernel.org;
 h=from:subject:message-id; bh=bZPOq75obKgR16PHbo86C4WPqSIy0lDpy+567+6KdtA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBlOl+ZKpBn2quw+JMOA0wd9IcOAen3LFzhH3lZPbjF
 67bDa5qJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZTpfmQAKCRAk1otyXVSH0Be7B/
 0ZNb48Xv/lVy/VBrcStmABmWW9LC6FiiPirjjfQ8/Fp1JOrtI/9R0v4o61LHJKocZRJLXF6x/sPNh1
 SAqdEFkEiArmAeBbjOMS0z1O/Jye1GneG3YH11Bgs2ulbyTCPQ2JBHeqTqBvWOXFkMqktKaYrS2/SB
 Zrg7vO3Cy+rq6ZvobAsxgkTDMKxF8ZTlWN1ZR2mnBlb77UVFHo/8tAd8k4XBg25/oHexuRSKDLMhWK
 q/snGPjl4jj/iZYxP9P67e99vQ3bjeb/iPpYgpWcsZfb4/BVp1+ooMP2Npgu8ugcwNUnVR7yWY0SI8
 Zwze0pXLG07ZkHk0J8eLE14xO2j741
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

DDI0601 2023-09 defines new fields in HCRX_EL2 controlling access to new
system registers, update our definition of HCRX_EL2 to reflect this.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 97d0da472328..e603a6153527 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2406,7 +2406,9 @@ Fields	ZCR_ELx
 EndSysreg
 
 Sysreg	HCRX_EL2	3	4	1	2	2
-Res0	63:23
+Res0	63:25
+Field	24	PACMEn
+Field	23	EnFPM
 Field	22	GCSEn
 Field	21	EnIDCP128
 Field	20	EnSDERR

-- 
2.30.2

