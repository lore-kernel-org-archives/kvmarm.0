Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A1C18C27
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 12:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EpeMe9VE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20477C433CA;
	Mon,  9 Oct 2023 12:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696853479;
	bh=DHXrkEz4uaI5EG4HiHB3b7Wj+xS82Cz4YUQVewuBUzc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EpeMe9VENZDj/tfvQ0h0WPh3VgDnpa8FPfRzTsdG29A7YqkP/rGRcPp4MReNm5Mqf
	 XL+dh1tkTPB4tmAkGuvvezJZODKRqhlqty3Gtn7cSpzoHSdWiFys190IsLcRrA/qNQ
	 XecFycrJnK5IPz64+hUm1PWC3XJhhkNVwgYteP1WFXK9SUK6ZNVHzk5fT1f7WPjvPE
	 Lpk8pYGgHNsmDAPmrjiXzMhb5PyHYMJNl82tKcWBkPNT5r2VrKXhOHOt33yjDGk6eq
	 spHqVknye6EbUuzvHgibZv9XZod9P3Km4O2q97/kcRhmrkrNvovuJgZXdp2FZqKihC
	 brKSMTrfvdrtQ==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 09 Oct 2023 13:08:40 +0100
Subject: [PATCH v6 06/38] arm64/sysreg: Add new system registers for GCS
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231009-arm64-gcs-v6-6-78e55deaa4dd@kernel.org>
References: <20231009-arm64-gcs-v6-0-78e55deaa4dd@kernel.org>
In-Reply-To: <20231009-arm64-gcs-v6-0-78e55deaa4dd@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, 
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Arnd Bergmann <arnd@arndb.de>, 
 Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
 Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, 
 "Rick P. Edgecombe" <rick.p.edgecombe@intel.com>, 
 Deepak Gupta <debug@rivosinc.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Florian Weimer <fweimer@redhat.com>, Christian Brauner <brauner@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.13-dev-0438c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1873; i=broonie@kernel.org;
 h=from:subject:message-id; bh=DHXrkEz4uaI5EG4HiHB3b7Wj+xS82Cz4YUQVewuBUzc=;
 b=owGbwMvMwMWocq27KDak/QLjabUkhlTlt1Pdnvex9je8cc6rS7n+7EuY28QjQVenuUqu+v39/67u
 v8+cOhmNWRgYuRhkxRRZ1j7LWJUeLrF1/qP5r2AGsTKBTGHg4hSAiUS7sP+VElnKb/E8ODlTp/RMWX
 yO53Ph0HtNP65adFrrXilwX7k1Qt5A02hOr5hpm+XUFWeMHa6cOGYe58P+O4Yn5295ttf7iqUu79+7
 n5QLcajt/eKb4X7v90314LuXjRJWROgsEP+dlBBzs6HsQ87ixSujmj8yVfGf0w2PjjueIPGYp9y+uo
 Hltcxn9cmVJkeO/P7lda1206ejrkdqKqyZn/Ibz2WVYXC6Jlfy//+0o4cCTv/q2K99+/ObppUMhdZn
 V7uu5r2//UZ/WGlIb+NNjtmG0V7CLkV6mkHXZH2q/68zmbUn5PP0ZV02uRzMHSsdjqhdnFL4zSgoYL
 2G0E2bRHdOcQGVI26OP/RjLf0TAA==
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

FEAT_GCS introduces a number of new system registers. Add the registers
available up to EL2 to sysreg as per DDI0601 2022-12.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/tools/sysreg | 55 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 76ce150e7347..6872bc2c26cd 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1784,6 +1784,41 @@ Sysreg	SMCR_EL1	3	0	1	2	6
 Fields	SMCR_ELx
 EndSysreg
 
+SysregFields	GCSCR_ELx
+Res0	63:10
+Field	9	STREn
+Field	8	PUSHMEn
+Res0	7
+Field	6	EXLOCKEN
+Field	5	RVCHKEN
+Res0	4:1
+Field	0	PCRSEL
+EndSysregFields
+
+Sysreg	GCSCR_EL1	3	0	2	5	0
+Fields	GCSCR_ELx
+EndSysreg
+
+SysregFields	GCSPR_ELx
+Field	63:3	PTR
+Res0	2:0
+EndSysregFields
+
+Sysreg	GCSPR_EL1	3	0	2	5	1
+Fields	GCSPR_ELx
+EndSysreg
+
+Sysreg	GCSCRE0_EL1	3	0	2	5	2
+Res0	63:11
+Field	10	nTR
+Field	9	STREn
+Field	8	PUSHMEn
+Res0	7:6
+Field	5	RVCHKEN
+Res0	4:1
+Field	0	PCRSEL
+EndSysreg
+
 Sysreg	ALLINT	3	0	4	3	0
 Res0	63:14
 Field	13	ALLINT
@@ -2014,6 +2049,10 @@ Field	4	DZP
 Field	3:0	BS
 EndSysreg
 
+Sysreg	GCSPR_EL0	3	3	2	5	1
+Fields	GCSPR_ELx
+EndSysreg
+
 Sysreg	SVCR	3	3	4	2	2
 Res0	63:2
 Field	1	ZA
@@ -2342,6 +2381,14 @@ Sysreg	SMCR_EL2	3	4	1	2	6
 Fields	SMCR_ELx
 EndSysreg
 
+Sysreg	GCSCR_EL2	3	4	2	5	0
+Fields	GCSCR_ELx
+EndSysreg
+
+Sysreg	GCSPR_EL2	3	4	2	5	1
+Fields	GCSPR_ELx
+EndSysreg
+
 Sysreg	DACR32_EL2	3	4	3	0	0
 Res0	63:32
 Field	31:30	D15
@@ -2401,6 +2448,14 @@ Sysreg	SMCR_EL12	3	5	1	2	6
 Fields	SMCR_ELx
 EndSysreg
 
+Sysreg	GCSCR_EL12	3	5	2	5	0
+Fields	GCSCR_ELx
+EndSysreg
+
+Sysreg	GCSPR_EL12	3	5	2	5	1
+Fields	GCSPR_ELx
+EndSysreg
+
 Sysreg	FAR_EL12	3	5	6	0	0
 Field	63:0	ADDR
 EndSysreg

-- 
2.30.2

