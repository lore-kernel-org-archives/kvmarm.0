Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006377C
	for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 20:25:52 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674505551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qA/YV51x0NzBgSINPoR//MrOdoxZaOLSq8U1gyTnrk4=;
	b=qWEhA45TXBuxhF+vl52y/3zWz2cXV0daunb7EabtOQLzm/+kO+uQ0jESmd/SEjh/Ii4Qk9
	MPmSWGPb8HuPmdypo59cKjmFeLA4/Ga4oKmEgz8V/nX4YThMMdHFf8KTIeCg8qBzIHc2Oj
	nEh2g9uT4hX0yUZwC/a/90FiWxJHVoY=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kernel-janitors@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2] KVM: arm64: vgic-v3: Use kstrtobool() instead of strtobool()
Date: Mon, 23 Jan 2023 20:25:37 +0000
Message-Id: <167450419464.2571033.6082403533536145707.b4-ty@linux.dev>
In-Reply-To: <f546e636c6d2bbcc0d8c4191ab98ce892fce4584.1673702763.git.christophe.jaillet@wanadoo.fr>
References: <f546e636c6d2bbcc0d8c4191ab98ce892fce4584.1673702763.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sat, 14 Jan 2023 14:26:15 +0100, Christophe JAILLET wrote:
> strtobool() is the same as kstrtobool().
> However, the latter is more used within the kernel.
> 
> In order to remove strtobool() and slightly simplify kstrtox.h, switch to
> the other function name.
> 
> While at it, include the corresponding header file (<linux/kstrtox.h>)
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: vgic-v3: Use kstrtobool() instead of strtobool()
      https://git.kernel.org/kvmarm/kvmarm/c/016cbbd2ba55

--
Best,
Oliver
