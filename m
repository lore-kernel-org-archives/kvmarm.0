Received: from out-50.mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F2F17FE0
	for <kvmarm@lists.linux.dev>; Tue, 11 Jul 2023 20:01:22 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1689105681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e2h4ypsBiQOphjGsO3cdI2RjCfYBHTayz+CPJEIH5WE=;
	b=a+aHNmT/WiiOits20IT4rv5ZQt60Or4Nen/DJEKY4oFOXuM6gDrG08MU0uHp/xVNeDG1tc
	DfWqLpkVJBZHXbTDKTd/K62vi0XRsbrmp/VWWCClu09yAErTlqOf0B4uh0UELUS6w98aNl
	eKwYHnuhIvQcHB1NyeF1iHkD4jwO88M=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Xiang Chen <chenxiang66@hisilicon.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-v4: Consistently request doorbell irq for blocking vCPU
Date: Tue, 11 Jul 2023 20:00:47 +0000
Message-ID: <168910562681.2605377.3847832034591317861.b4-ty@linux.dev>
In-Reply-To: <20230710175553.1477762-1-oliver.upton@linux.dev>
References: <20230710175553.1477762-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 10 Jul 2023 17:55:53 +0000, Oliver Upton wrote:
> Xiang reports that VMs occasionally fail to boot on GICv4.1 systems when
> running a preemptible kernel, as it is possible that a vCPU is blocked
> without requesting a doorbell interrupt.
> 
> The issue is that any preemption that occurs between vgic_v4_put() and
> schedule() on the block path will mark the vPE as nonresident and *not*
> request a doorbell irq.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: vgic-v4: Consistently request doorbell irq for blocking vCPU
      https://git.kernel.org/kvmarm/kvmarm/c/d30ea1f31ff5

--
Best,
Oliver
