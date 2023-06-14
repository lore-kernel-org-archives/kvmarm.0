Received: from out-46.mta1.migadu.com (out-46.mta1.migadu.com [95.215.58.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9420101F7
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 15:31:46 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686756704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CYKbp9Q0BeM52+XXi3aMvjzJfNpfbqXByiTdIuieW4g=;
	b=ejyEaxmgzfyiMYJ2Vleh7ornI7PLLaFCXL0QtoGCEzSqXZeE+aeSAHa9bGs8qcEfvN+GdI
	6QBiDAhRREsBGwDEHb0do6SgyuATtK5gKrAL0AETuPTeqL2mRZM939ezA8/a7/MJ6DBnmu
	hE3lVIU9tPflVcLqFu/8HdfnZ2QR9og=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	maz@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	catalin.marinas@arm.com,
	yuzenghui@huawei.com,
	tabba@google.com,
	kaleshsingh@google.com,
	suzuki.poulose@arm.com,
	will@kernel.org,
	james.morse@arm.com
Subject: Re: [PATCH v2] KVM: arm64: Use different pointer authentication keys for pKVM
Date: Wed, 14 Jun 2023 15:31:28 +0000
Message-ID: <168675651878.3255755.17510485264525909343.b4-ty@linux.dev>
In-Reply-To: <20230614122600.2098901-1-smostafa@google.com>
References: <20230614122600.2098901-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 14 Jun 2023 12:25:59 +0000, Mostafa Saleh wrote:
> When the use of pointer authentication is enabled in the kernel it
> applies to both the kernel itself as well as KVM's nVHE hypervisor. The
> same keys are used for both the kernel and the nVHE hypervisor, which is
> less than desirable for pKVM as the host is not trusted at runtime.
> 
> Naturally, the fix is to use a different set of keys for the hypervisor
> when running in protected mode. Have the host generate a new set of keys
> for the hypervisor before deprivileging the kernel. While there might be
> other sources of random directly available at EL2, this keeps the
> implementation simple, and the host is trusted anyways until it is
> deprivileged.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Use different pointer authentication keys for pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/8c15c2a02810

--
Best,
Oliver
