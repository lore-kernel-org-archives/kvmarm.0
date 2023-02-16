Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB57AD31D
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 14:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814C1C433EF;
	Thu, 16 Feb 2023 14:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676557875;
	bh=AXe3+d84n0T3lT9bC+GGjquzOfxEYZEi3/W6fF4dWR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmWGv3+ZvoZ/CXpnluQ71vpkUpvqIFAOrD+mKmHhM5tmjZrg96OmNh65Ix3dvaPk6
	 VTiAPH4vdU1GP3ZWaVsOx16wDzAdqn5oqIAjbdpQvB28QPqteK9vj1ucqqXn1yK7bp
	 tylTyK72AcEh4ysEHijUbfJ8CWuSvDkwFjrz9jMkt7kCepOrSMIoVB2hWENv+TYKtt
	 402lm3eq6miyxOl5MkxzHcr3ZZlEXowp3f0R0FJ7ebm9ZJbzJhFQcWvLZlSQcstTnf
	 UbPAUwVnpvQgeCzJBGf/HtBhUReN49y9oRF9sY1oZjG06hBL/46pcDYUOFXkEKOOTV
	 m2tyCJcgzPCzw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pSf8w-00AuwB-Tr;
	Thu, 16 Feb 2023 14:21:50 +0000
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
	dwmw2@infradead.org
Subject: [PATCH 16/16] KVM: arm64: selftests: Deal with spurious timer interrupts
Date: Thu, 16 Feb 2023 14:21:23 +0000
Message-Id: <20230216142123.2638675-17-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make sure the timer test can properly handle a spurious timer
interrupt, something that is far from being unlikely.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 62af0e7d10b4..3f6f0bfa68a2 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -158,6 +158,9 @@ static void guest_irq_handler(struct ex_regs *regs)
 	uint32_t cpu = guest_get_vcpuid();
 	struct test_vcpu_shared_data *shared_data = &vcpu_shared_data[cpu];
 
+	if (intid == IAR_SPURIOUS)
+		return;
+
 	guest_validate_irq(intid, shared_data);
 
 	WRITE_ONCE(shared_data->nr_iter, shared_data->nr_iter + 1);
-- 
2.34.1

