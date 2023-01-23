Received: from out-30.mta0.migadu.com (out-30.mta0.migadu.com [91.218.175.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26ECC880A
	for <kvmarm@lists.linux.dev>; Mon, 23 Jan 2023 20:45:17 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1674505785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s7uWOQiGnXz9rty7WDFE/6lr0xLCnEzP+kCHJVNsyu8=;
	b=BQCycvmR+WEPCW8uGqOyR2epN3QS0cR/5wtSqToPWu8I3vmMirtFzIgB0FeYSBa1m9RBBR
	oJV/NdMyKLTiNqifs2is/Iuomc/KCfWDgtFQJZhrfpvbi1EbaP7K6hVGFR/3WnP4qyOVGW
	443CcowABS2GIg/NDdidBpYRo3ztLsQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.cs.columbia.edu,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 0/6] KVM: arm64: Parallel access faults
Date: Mon, 23 Jan 2023 20:29:38 +0000
Message-Id: <167450408288.2570239.4393473053122002662.b4-ty@linux.dev>
In-Reply-To: <20221202185156.696189-1-oliver.upton@linux.dev>
References: <20221202185156.696189-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 2 Dec 2022 18:51:50 +0000, Oliver Upton wrote:
> When I implemented the parallel faults series I was mostly focused on
> improving the performance of 8.1+ implementations which bring us
> FEAT_HAFDBS. In so doing, I failed to put access faults on the read side
> of the MMU lock.
> 
> Anyhow, this small series adds support for handling access faults in
> parallel, piling on top of the infrastructure from the first parallel
> faults series.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/6] KVM: arm64: Use KVM's pte type/helpers in handle_access_fault()
      https://git.kernel.org/kvmarm/kvmarm/c/9a7ad19ac804
[2/6] KVM: arm64: Ignore EAGAIN for walks outside of a fault
      https://git.kernel.org/kvmarm/kvmarm/c/ddcadb297ce5
[3/6] KVM: arm64: Return EAGAIN for invalid PTE in attr walker
      https://git.kernel.org/kvmarm/kvmarm/c/76259cca4795
[4/6] KVM: arm64: Don't serialize if the access flag isn't set
      https://git.kernel.org/kvmarm/kvmarm/c/7d29a2407df6
[5/6] KVM: arm64: Handle access faults behind the read lock
      https://git.kernel.org/kvmarm/kvmarm/c/fc61f554e694
[6/6] KVM: arm64: Condition HW AF updates on config option
      https://git.kernel.org/kvmarm/kvmarm/c/1dfc3e905089

--
Best,
Oliver
