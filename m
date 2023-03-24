Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43806FA1
	for <kvmarm@lists.linux.dev>; Fri, 24 Mar 2023 14:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B9DC433D2;
	Fri, 24 Mar 2023 14:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679669239;
	bh=94UwISeh0wgAFIbnn19iAAV6arHkbjP0f+mWzBW5sWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5VYAw8KYgr6l/NxzCN295enwnMIs6Angdiuly3I8J2d3Mkw6+G+NITu/cglQyXgV
	 F2gHpCXuJ/XQfN6LdTlsljixe5LPuZEsK1FcDTVNAwpAbbf9TmRRG4oNhktAxpSpuO
	 TEfu/Fbrkb2rgcC+tla/hA5bZE6WruUE8TrsQ6wPqTxQgfMxqCgsMS5JqS+Te+DzbT
	 c3hdPlrxH12sseDzcXytF1hz9qO5nZsTI9YpJO/JdGq0V36/UWzJW2yQZz+9Ar3hO1
	 W95BFFtusDL3XIEYI7PyUkxl+nypSpmGJRn7I0eCBY8tthWAfIusZYup0z3YXfdgIO
	 TOG13k3YnNW+g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pfihJ-002qBP-FY;
	Fri, 24 Mar 2023 14:47:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	dwmw2@infradead.org
Subject: [PATCH v3 02/18] arm64: Add CNTPOFF_EL2 register definition
Date: Fri, 24 Mar 2023 14:46:48 +0000
Message-Id: <20230324144704.4193635-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324144704.4193635-1-maz@kernel.org>
References: <20230324144704.4193635-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the definition for CNTPOFF_EL2 in the description file.

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index dd5a9c7e310f..7063f1aacc54 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1952,6 +1952,10 @@ Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
 
+Sysreg	CNTPOFF_EL2	3	4	14	0	6
+Field	63:0	PhysicalOffset
+EndSysreg
+
 Sysreg	CPACR_EL12	3	5	1	0	2
 Fields	CPACR_ELx
 EndSysreg
-- 
2.34.1

