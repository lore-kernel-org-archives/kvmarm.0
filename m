Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D39920338
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 16:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FGy5oKhO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698425215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/gwQv8qy443fb2wqDjI8hOdX2omLUKf6t4hBomdgNUg=;
	b=FGy5oKhOPqivU6LBAEY0Utp8SoLLK2KUi4uRZpFgVEEFcuY3zLJd8SFtAFvJwPWuVHuN3J
	dSaH9BzTaIJFxJKo9NybBPc0RrqTlt2GkdaxFtDe+Ai9PaFmLI3XeI0bw+ZOjZtjTCsRKX
	Gm/FQHbzdHPEeQA4w5eNZBsBuCE0hMA=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Add tracepoint for MMIO accesses where ISV==0
Date: Fri, 27 Oct 2023 16:46:42 +0000
Message-ID: <169842519565.3393490.939837360614388920.b4-ty@linux.dev>
In-Reply-To: <20231026205306.3045075-1-oliver.upton@linux.dev>
References: <20231026205306.3045075-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 26 Oct 2023 20:53:06 +0000, Oliver Upton wrote:
> It is a pretty well known fact that KVM does not support MMIO emulation
> without valid instruction syndrome information (ESR_EL2.ISV == 0). The
> current kvm_pr_unimpl() is pretty useless, as it contains zero context
> to relate the event to a vCPU.
> 
> Replace it with a precise tracepoint that dumps the relevant context
> so the user can make sense of what the guest is doing.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Add tracepoint for MMIO accesses where ISV==0
      https://git.kernel.org/kvmarm/kvmarm/c/9ec605adafbd

--
Best,
Oliver
