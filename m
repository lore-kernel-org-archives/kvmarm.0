Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598A1D2F6
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 09:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC37DC433D2;
	Wed, 31 May 2023 09:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685526553;
	bh=4jykXwP+lKWkfwQ4vtODSm1LzEsTikJ0LsadQGsSeXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ik/9hYZITPmW0uKQI7stLxn10xtxISPpIF0aA/f3wk5/CeNAHSeSDPjAuJ/qlPmNw
	 y+6f+1ZMnmneS5zn7x3KOA40dXz8IAZypYABMLhsSdNcdULp5bbNx17EO6ZlynA3lA
	 SAhY5a1siBjNdF4A5P4H6h3+24ItVkk7XmxsnCDtWos6IWMALY/0Igk0+DIYpXyqLI
	 sXluxbhD3zotG2lhXmA6wImsMRYTx9B+2d4+90icIeyOMpyQXnnjoJfZrVUq3chhlE
	 en/Xp7OeRkGzyc2C4a6JK8ZV7A0plAnyEYldXW3F6LDsShUzhlYwgWYmE/+Y8HGcHk
	 b5LBmFy+9mgvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q4IS6-001ZxQ-Mw;
	Wed, 31 May 2023 10:49:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	mark.rutland@arm.com,
	Peter Zijlstra <peterz@infradead.org>,
	Reiji Watanabe <reijiw@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	James Morse <james.morse@arm.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: Fix for probing default PMU
Date: Wed, 31 May 2023 10:49:04 +0100
Message-Id: <168552653957.429005.4230504598358428557.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230525212723.3361524-1-oliver.upton@linux.dev>
References: <20230525212723.3361524-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, suzuki.poulose@arm.com, mark.rutland@arm.com, peterz@infradead.org, reijiw@google.com, nathan@kernel.org, james.morse@arm.com, ravi.bangoria@amd.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 25 May 2023 21:27:20 +0000, Oliver Upton wrote:
> Follow-up to the discussion in [1].
> 
> KVM uses a junk perf event to probe for a default PMU instance to use
> for the guest, which depends on perf finding the right PMU instance
> to use for the event. Looks like perf is going to rely strictly on
> the specified PMU type, breaking the entire scheme.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Iterate arm_pmus list to probe for default PMU
      commit: 1c913a1c35aa61cf280173b2bcc133c3953c38fc
[2/2] KVM: arm64: Document default vPMU behavior on heterogeneous systems
      commit: 40e54cad454076172cc3e2bca60aa924650a3e4b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


