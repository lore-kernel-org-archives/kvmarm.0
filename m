Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542C47E
	for <kvmarm@lists.linux.dev>; Thu, 20 Oct 2022 09:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E24C433C1;
	Thu, 20 Oct 2022 09:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666257391;
	bh=2eNqWN4PbAgzkaOx6mNpZevPq0uMwSWGGxKeEeSAMyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3dS9ql0M8AGPz8g57P+rjNfF/9WYQmyolI4TQYa+m6GGzENYzt6eAoprJqWEjumX
	 T9i/iwyoegWahWQwezcNs/wNgutLxy+U1JZhoElpzqVPT1dUS03dQTVkpLvl/zPHSL
	 06m6zDRJhXTmWP1aR3+XDLPM3PP5cjKv4BGDr++Pl5xjADtzQHdYiXVcg9nMQs0bAv
	 TY5DnzkHVoDhpse6crIaWsjxJatc2Tmz0gkhiLO+NELUtkMmqLN/uS8txuOTJqYXde
	 UWO8wTNNkwRK6CyRu0LpGReyKLK0J6ncys8pZB8Fx+UJCZV5otroQLMdg9gSXUrGMJ
	 1O9ad/acRILog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1olRWc-000Buf-Ku;
	Thu, 20 Oct 2022 10:07:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 16/17] arm64: Allow arm64_sw.hvhe on command line
Date: Thu, 20 Oct 2022 10:07:26 +0100
Message-ID: <20221020090727.3669908-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221020090726.NghtQfcgTS9aNvPzR4qNpcssB-LvKEuarCsfUWTGzgs@z>

Add the arm64_sw.hvhe=1 option to force the use of the hVHE mode
in the hypervisor code only.

This enables the hVHE mode of operation when using KVM on VHE
hardware.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/idreg-override.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index 4e8ef5e05db7..7f3d7835ceaa 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -137,11 +137,22 @@ static const struct ftr_set_desc smfr0 __initconst = {
 	},
 };
 
+static bool __init hvhe_filter(u64 val)
+{
+	u64 mmfr1 = read_sysreg(id_aa64mmfr1_el1);
+
+	return (val == 1 &&
+		lower_32_bits(__boot_status) == BOOT_CPU_MODE_EL2 &&
+		cpuid_feature_extract_unsigned_field(mmfr1,
+						     ID_AA64MMFR1_EL1_VH_SHIFT));
+}
+
 static const struct ftr_set_desc sw_features __initconst = {
 	.name		= "arm64_sw",
 	.override	= &arm64_sw_feature_override,
 	.fields		= {
 		FIELD("nokaslr", ARM64_SW_FEATURE_OVERRIDE_NOKASLR, NULL),
+		FIELD("hvhe", ARM64_SW_FEATURE_OVERRIDE_HVHE, hvhe_filter),
 		{}
 	},
 };
-- 
2.34.1

