Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA93728F0
	for <kvmarm@lists.linux.dev>; Mon,  7 Nov 2022 08:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B49CC433C1;
	Mon,  7 Nov 2022 08:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1667811297;
	bh=Y6xxfM4ND10MuEIQCLvziXMSdXkZfkvKinsYllpKaj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5ASzgfNLAduhtODIQEPaUOcvUX4YnmwCPsrH+yAayzfTaVeKKsTQSVnUG7EwznZg
	 /v26etvjxOzYle4fisZrq9knNl4SrozJIu/i21f33sVxbCx+lcrQ4PD7RYHlIDK5OT
	 QlwCrv3iXagWXuWJqMRD1ymXxmbeR8vErXNWxn09RnJQ+hvpINEfadJLglNlVNhVb5
	 BJP43HTb+VP3al2IZfKzSjGxjQnuZnrgeThQeA93XaL8GnTW0zt4xwnwSBq4dmj5lp
	 1Irkt8SstcaAvfAfwua0HKWGmOkESGYQ5XYYRKGYrMuxdKnrpGWsi4D6f8/1le6518
	 SjM3r56tWvQsg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1orxuB-004KxX-Gc;
	Mon, 07 Nov 2022 08:54:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	<kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Ricardo Koller <ricarkol@google.com>,
	Reiji Watanabe <reijiw@google.com>
Subject: [PATCH v3 01/14] arm64: Add ID_DFR0_EL1.PerfMon values for PMUv3p7 and IMP_DEF
Date: Mon,  7 Nov 2022 08:54:22 +0000
Message-ID: <20221107085435.2581641-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221107085435.2581641-1-maz@kernel.org>
References: <20221107085435.2581641-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221107085422.x2AH3bWai1gV7s1JzRafTkY1x6F_GJ4KMnQnnDnWGvU@z>

Align the ID_DFR0_EL1.PerfMon values with ID_AA64DFR0_EL1.PMUver.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7d301700d1a9..84f59ce1dc6d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -698,6 +698,8 @@
 #define ID_DFR0_PERFMON_8_1		0x4
 #define ID_DFR0_PERFMON_8_4		0x5
 #define ID_DFR0_PERFMON_8_5		0x6
+#define ID_DFR0_PERFMON_8_7		0x7
+#define ID_DFR0_PERFMON_IMP_DEF		0xf
 
 #define ID_ISAR4_SWP_FRAC_SHIFT		28
 #define ID_ISAR4_PSR_M_SHIFT		24
-- 
2.34.1

