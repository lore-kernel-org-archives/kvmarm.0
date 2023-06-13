Received: from out-42.mta1.migadu.com (out-42.mta1.migadu.com [95.215.58.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553003C25
	for <kvmarm@lists.linux.dev>; Tue, 13 Jun 2023 12:16:25 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686658583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBZSAkJAmjdtGZukyV0Gel5hklORumrE8fQLoKUpCwU=;
	b=sFCltlm5AhnbFv4QFXD/QC5q7yMPfKrNOErbqYwG6Xy7f+NkHWrjtmVA7STa65u6PGvw/s
	xJMDtoRZhHsT9hIvRbJlaNw/SHRa0ElwjULMihHNChia3ft70gTF0gR55TWVLmm8yEVS23
	h2ClNu/t8BNLU53ZLQcNBdNTYMvkhB8=
From: Oliver Upton <oliver.upton@linux.dev>
To: Mostafa Saleh <smostafa@google.com>,
	kvmarm@lists.linux.dev,
	maz@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	suzuki.poulose@arm.com,
	kaleshsingh@google.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Use different pointer authentication keys for pKVM
Date: Tue, 13 Jun 2023 12:16:02 +0000
Message-ID: <168665854178.2681974.13725664134174024912.b4-ty@linux.dev>
In-Reply-To: <20230516141531.791492-1-smostafa@google.com>
References: <20230516141531.791492-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 16 May 2023 14:15:31 +0000, Mostafa Saleh wrote:
> When the kernel is compiled with CONFIG_ARM64_PTR_AUTH_KERNEL, it
> uses Armv8.3-Pauth for return address protection for the kernel code
> including nvhe code in EL2.
> 
> Same keys are used in both kernel(EL1) and nvhe code(EL2), this is
> fine for nvhe but not when running in protected mode(pKVM) as the host
> can't be trusted.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Use different pointer authentication keys for pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/fb737685beee

--
Best,
Oliver
