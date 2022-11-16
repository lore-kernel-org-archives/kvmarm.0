Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CAE7F
	for <kvmarm@lists.linux.dev>; Wed, 16 Nov 2022 07:27:33 +0000 (UTC)
Date: Wed, 16 Nov 2022 07:27:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1668583652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QTadVoqTlZKm9VTvcDO0wveHBTpSFQKiIG+uKAG+8kM=;
	b=V9pS43higRceJa5AF+9MmdQqVOFLDPCAwKI1AmsPGuPobz+Q0p1LSPwm1Q5+C4DFql5b7T
	MijRBdX22IcazcREY5/9LVAwgx3USgWhVzi5ei6y2tHNSKu4G261ko5CYgb7yp2YwvSH8D
	fEAuY323ZCDbqMrpdyfbPkYtQwA5GCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Don't acquire RCU read lock for exclusive
 table walks
Message-ID: <Y3SQ3wogsVUEu1Qe@google.com>
References: <20221115225502.2240227-1-oliver.upton@linux.dev>
 <868rkbppdq.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868rkbppdq.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221116072727.8C5N7D8y3uM53xo-CvnAInr-a2Ra9qghvgurRvy9smI@z>

On Wed, Nov 16, 2022 at 03:08:49AM +0000, Marc Zyngier wrote:
> I'm not crazy about this sort of parameters. I think it would make a
> lot more sense to pass a pointer to the walker structure and do the
> flag check inside the helper.
> 
> That way, we avoid extra churn if/when we need extra state or
> bookkeeping around the walk.

Sure, let's go that way instead. v3 on the way lol :)

--
Thanks,
Oliver
