Received: from out-62.mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6019B23A2
	for <kvmarm@lists.linux.dev>; Wed, 19 Apr 2023 15:24:30 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1681917867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m86z6TjGCOBoXSNzNwtLMXD/iZmdf3W5Gw5h8rvIoAI=;
	b=oq44kOU9awqCFwyB2yikfxbaYzGRqiFfCntRr08cArTayptvIrhpBu4PxFRZCqpkS7Nb5k
	5Elf+0QYbb6344t2HvaKGdhsBN8PzyADSMcSeVIXdRvJ2VcqZcNMFInKkwmbHDEjhx2SVf
	hIpPsJsiJdhqonkQ8J7dyI4fhdjIdoY=
From: Oliver Upton <oliver.upton@linux.dev>
To: Dan Carpenter <dan.carpenter@linaro.org>,
	Andre Przywara <andre.przywara@arm.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kernel-janitors@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Eric Auger <eric.auger@redhat.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
Date: Wed, 19 Apr 2023 15:24:10 +0000
Message-ID: <168191777947.3194294.8892452744513533065.b4-ty@linux.dev>
In-Reply-To: <4efbab8c-640f-43b2-8ac6-6d68e08280fe@kili.mountain>
References: <4efbab8c-640f-43b2-8ac6-6d68e08280fe@kili.mountain>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 19 Apr 2023 13:16:13 +0300, Dan Carpenter wrote:
> The KVM_REG_SIZE() comes from the ioctl and it can be a power of two
> between 0-32768 but if it is more than sizeof(long) this will corrupt
> memory.
> 
> 

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Fix buffer overflow in kvm_arm_set_fw_reg()
      https://git.kernel.org/kvmarm/kvmarm/c/a25bc8486f9c

--
Best,
Oliver
