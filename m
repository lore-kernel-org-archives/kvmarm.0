Received: from out-103.mta1.migadu.com (out-103.mta1.migadu.com [95.215.58.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD87D160
	for <kvmarm@lists.linux.dev>; Mon, 30 Jan 2023 23:05:33 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675105998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bEgfb7WC/FbKfkUgiPWhmA26LlczTITd+x7HMoE+TUo=;
	b=gDaUtIjfgDNSE4Msu5ujMGoB4zZWEhCaltCNnH8DYKe4cYm1Fvz/tbPNAeN40y4B0zReqb
	gILZ0QnkubKW7YUPqRjFeZTjsLOyV0770X7ANY6xBI6e4O++7pveK4Hapbj7gbC9mgEVVp
	cY9yiMSJVQPpwq1JP3aeUWXVtbWs8N4=
From: Oliver Upton <oliver.upton@linux.dev>
To: maz@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Cc: pbonzini@redhat.com,
	linux-arm-kernel@lists.infradead.org,
	seanjc@google.com,
	catalin.marinas@arm.com,
	suzuki.poulose@arm.com,
	james.morse@arm.com,
	will@kernel.org,
	linux-kernel@vger.kernel.org,
	yuzenghui@huawei.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] MAINTAINERS: Add Oliver Upton as co-maintainer of KVM/arm64
Date: Mon, 30 Jan 2023 19:13:10 +0000
Message-Id: <167510336268.1083059.4102647014719707182.b4-ty@linux.dev>
In-Reply-To: <20230123210256.2728218-1-oliver.upton@linux.dev>
References: <20230123210256.2728218-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 23 Jan 2023 21:02:56 +0000, Oliver Upton wrote:
> Going forward I intend to help Marc with maintaining KVM/arm64. We've
> spoken about this quite a bit and he has been a tremendous help in
> ramping up to the task (thank you!). We haven't worked out the exact
> details of how the process will work, but the goal is to even out the
> maintenance responsibilities to give us both ample time for development.
> 
> To that end, updating the maintainers entry to reflect the change.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] MAINTAINERS: Add Oliver Upton as co-maintainer of KVM/arm64
      https://git.kernel.org/kvmarm/kvmarm/c/58817be46762

--
Best,
Oliver
