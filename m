Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2837D33FF
	for <kvmarm@lists.linux.dev>; Tue,  3 Jan 2023 12:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC687C433EF;
	Tue,  3 Jan 2023 12:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672749593;
	bh=DayNbxlWjObga1POZwVWqqYGle8SgTc7y5WtKCXJ8Kk=;
	h=From:To:Cc:Subject:Date:From;
	b=pFznceRPvQwrVmtkaU2N0VC7FOdFtQcVmxwsuNM27APSsZ3m0qnTkFE20g0Kdl/n1
	 TKB+ov5+JEOV8CFxYJMwpZgzen2Y3auZtGylKQgOwT6J85e6fSg0wu2sBIoNT+SQWg
	 UHAEb9LIvNNjpcknbyx1yvBUiRD8XZ3d2qzBsnesyAAq+xucW900XbC1oHfSdArM0N
	 mkqc1X097W7kJnZptxALipe18TQygVqhTbSPJ1tzYHkcAez7A+fKvCWL/HJyzVqCaG
	 U4BTlQwEpPvctLIjFREp82eyvhg+d2Sqs2kpsZ423YBW4rVSYHcBthoRKuPlEBxEpx
	 SNXqSXZIkSYNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pCga7-00GVQe-I3;
	Tue, 03 Jan 2023 12:39:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: <kvmarm@lists.cs.columbia.edu>,
	<kvmarm@lists.linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] MAINTAINERS: Add Zenghui Yu as a KVM/arm64 reviewer
Date: Tue,  3 Jan 2023 12:39:33 +0000
Message-ID: <20230103123933.3234865-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, will@kernel.org, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20230103123933.AdiqRMMK6nOY2P5j92dZgiB40EnUAYG2sFzU1fUWooU@z>

Zenghui has been around for quite some time, and has been instrumental
in reviewing the GICv4/4.1 KVM support. I'm delighted that he's agreed
to help with the patch review in a more official capacity!

Cc: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f61eb221415b..551544d877a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11359,6 +11359,7 @@ R:	James Morse <james.morse@arm.com>
 R:	Alexandru Elisei <alexandru.elisei@arm.com>
 R:	Suzuki K Poulose <suzuki.poulose@arm.com>
 R:	Oliver Upton <oliver.upton@linux.dev>
+R:	Zenghui Yu <yuzenghui@huawei.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	kvmarm@lists.linux.dev
 L:	kvmarm@lists.cs.columbia.edu (deprecated, moderated for non-subscribers)
-- 
2.34.1

