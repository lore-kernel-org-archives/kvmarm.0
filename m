Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B794DDAE
	for <kvmarm@lists.linux.dev>; Sun,  4 Jun 2023 16:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D687C433EF;
	Sun,  4 Jun 2023 16:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685895808;
	bh=lUrm+PEuJ42JVt5iXc2aFfMeyCqoaeWTJYNhcIoFNic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRa/eNO5IbQ4eWC6ONJjq0r7WMGBye7BPwyfeDgxpspFSLIPDdbDps+/6CRcaeCr3
	 85t/b+KUkW4MOEB/gH9HhDqCJgaSc7XS5ecT0An0OcMCq/DFY12jLlZjRo4B9PyqU9
	 S+IK/H3vL0G/aDwFRbtHGD7yFR6tOSAEILyRI6gJGBZTzR2HtaAvzZdDQ3gD6f62SC
	 8crV5xAxxaUegbHDDdIcU8aH+0IUR8Cfu02LVS168shhh1X9t+9CXXIeav3Uud50Gj
	 tmEc8YuerHDn2IXyCoqLvYgX/cCuvFPlnv6OS+/GYxUDAqaN+yFqFte82l62kH2Ite
	 JNOzir/0dxSNw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q5qVp-002jga-NC;
	Sun, 04 Jun 2023 17:23:25 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Reiji Watanabe <reijiw@google.com>,
	Will Deacon <will@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Rob Herring <robh@kernel.org>,
	James Morse <james.morse@arm.com>,
	kvm@vger.kernel.org,
	Shaoqin Huang <shahuang@redhat.com>,
	Ricardo Koller <ricarkol@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v5 0/2] KVM: arm64: PMU: Correct the handling of PMUSERENR_EL0
Date: Sun,  4 Jun 2023 17:23:22 +0100
Message-Id: <168589579607.1101692.3753432023819504330.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230603025035.3781797-1-reijiw@google.com>
References: <20230603025035.3781797-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, catalin.marinas@arm.com, mark.rutland@arm.com, reijiw@google.com, will@kernel.org, yuzenghui@huawei.com, suzuki.poulose@arm.com, robh@kernel.org, james.morse@arm.com, kvm@vger.kernel.org, shahuang@redhat.com, ricarkol@google.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, rananta@google.com, alexandru.elisei@arm.com, jingzhangos@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 2 Jun 2023 19:50:33 -0700, Reiji Watanabe wrote:
> This series will fix bugs in KVM's handling of PMUSERENR_EL0.
> 
> With PMU access support from EL0 [1], the perf subsystem would
> set CR and ER bits of PMUSERENR_EL0 as needed to allow EL0 to have
> a direct access to PMU counters.  However, KVM appears to assume
> that the register value is always zero for the host EL0, and has
> the following two problems in handling the register.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: PMU: Restore the host's PMUSERENR_EL0
      commit: 8681f71759010503892f9e3ddb05f65c0f21b690
[2/2] KVM: arm64: PMU: Don't overwrite PMUSERENR with vcpu loaded
      commit: 0c2f9acf6ae74118385f7a7d48f4b2d93637b628

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


