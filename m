Received: from out-13.mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC74563B3
	for <kvmarm@lists.linux.dev>; Sun, 21 May 2023 19:20:03 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684696801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UU9OP6GElzHy+Yh91vI4KeIdi/8W8EkfCUnsjLKuS98=;
	b=a5yVA71H13P4BRMca95xZA700GNT5VmrQydDHolH2mP8Y5bhZD7LgbRbrmUN9d5n91PZFv
	hmkPvdTlFF+wVs845PLlK53SaSEYe/Ov0flRT4UjCqL8RpcA8fFKXc2z1nbVpAVZCxvL+Z
	+8Z3fPI5bgmSbCMyCvooPVVCigkOZtg=
From: Oliver Upton <oliver.upton@linux.dev>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Relax trapping of CTR_EL0 when FEAT_EVT is available
Date: Sun, 21 May 2023 19:19:50 +0000
Message-ID: <168469633655.1380373.17609383771397650020.b4-ty@linux.dev>
In-Reply-To: <20230515170016.965378-1-maz@kernel.org>
References: <20230515170016.965378-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 15 May 2023 18:00:16 +0100, Marc Zyngier wrote:
> CTR_EL0 can often be used in userspace, and it would be nice if
> KVM didn't have to emulate it unnecessarily.
> 
> While it isn't possible to trap the cache configuration registers
> indemendently from CTR_EL0 in the base ARMv8.0 architecture, FEAT_EVT
> allows these cache configuration registers (CCSIDR_EL1, CCSIDR2_EL1,
> CLIDR_EL1 and CSSELR_EL1) to be trapped indepdently by setting
> HCR_EL2.TID4.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Relax trapping of CTR_EL0 when FEAT_EVT is available
      https://git.kernel.org/kvmarm/kvmarm/c/c876c3f182a5

--
Best,
Oliver
