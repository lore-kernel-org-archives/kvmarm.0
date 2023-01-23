Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C9F7C
	for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 20:29:21 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674505759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JNKgjEey+jD1QCB2y7BoSEW91Ll3Cspvy/BSqQryTQo=;
	b=cZjkYP94sB3Uph5potWP3gkjVjMey9Xpxkp9Id1CgSUufnH3qAUwbszZoxjyO0oGn3vqk/
	zOFccW7rLYVq+vweDrlnZdpewe1i+Ndp0B62ri8RpDUSfCqKOlrRSmT21vOP8szG8+zeJ/
	UI8pvBHKq+aSBu565/V4Ugr45ZgdLvI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Limit IPI-ing when accessing GICR_{C,S}ACTIVER0
Date: Mon, 23 Jan 2023 20:29:09 +0000
Message-Id: <167450419462.2571033.11871060147028793348.b4-ty@linux.dev>
In-Reply-To: <20230112154840.1808595-1-maz@kernel.org>
References: <20230112154840.1808595-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Thu, 12 Jan 2023 15:48:40 +0000, Marc Zyngier wrote:
> When a vcpu is accessing *its own* redistributor's SGIs/PPIs, there
> is no point in doing a stop-the-world operation. Instead, we can
> just let the access occur as we do with GICv2.
> 
> This is a very minor optimisation for a non-nesting guest, but
> a potentially major one for a nesting L1 hypervisor which is
> likely to access the emulated registers pretty often (on each
> vcpu switch, at the very least).
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: vgic-v3: Limit IPI-ing when accessing GICR_{C,S}ACTIVER0
      https://git.kernel.org/kvmarm/kvmarm/c/fd2b165ce2cc

--
Best,
Oliver
