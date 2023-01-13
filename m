Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8583AD4A
	for <kvmarm@lists.linux.dev>; Fri, 13 Jan 2023 17:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDDBC433F0;
	Fri, 13 Jan 2023 17:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673630732;
	bh=GLsGai/HaLX4rlQF1y+E+eiiJYqVXPvgiCUVO/iODC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzmhEF9Dtrwr2Wgs5zPIv+FcdFKirg2OCG3DDBEaTWvW2XahQnc+0Pg2UdVutjuXi
	 gkt3xDri07c7khkZhvWeffUeVVZDBeeoYE4Y3aU7LwyfLqmU8ZWF/97aBu7ba6aAqD
	 c94Q2HJwLlgQK+ODsDJUxRmG1XpfNTPZKfkNi+qDyqOKx9ChlCKQOSQAeEiCND1gIK
	 /iavORKQo9MRf/9KPHbeFsXyEu5FzlrQj4ZRyVy/zu+AtLz4FZQtk7Ca0T039mIBoN
	 0ddl4fwkl4Qi6vjae5aENV4EswKkt70pWz7zVYeAomg9OhbIrCFUfUasdN22OeHhhg
	 3t0ioO51D15hQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pGNo2-001bBu-Do;
	Fri, 13 Jan 2023 17:25:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/2] KVM: arm64: Disable KVM on systems with a VPIPT i-cache
Date: Fri, 13 Jan 2023 17:25:22 +0000
Message-Id: <20230113172523.2063867-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113172523.2063867-1-maz@kernel.org>
References: <20230113172523.2063867-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Systems with a VMID-tagged PIPT i-cache have been supported for
a while by Linux and KVM. However, these systems never appeared
on our side of the multiverse.

Refuse to initialise KVM on such a machine, should then ever appear.
Following changes will drop the support from the hypervisor.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..508deed213a2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2195,6 +2195,11 @@ int kvm_arch_init(void *opaque)
 	int err;
 	bool in_hyp_mode;
 
+	if (icache_is_vpipt()) {
+		kvm_info("Incompatible VPIPT I-Cache policy\n");
+		return -ENODEV;
+	}
+
 	if (!is_hyp_mode_available()) {
 		kvm_info("HYP mode not available\n");
 		return -ENODEV;
-- 
2.34.1

