Received: from out-15.mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF0DA926
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 12:19:22 +0000 (UTC)
Date: Wed, 14 Jun 2023 12:19:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686745161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1ziofaVaQl/PXTbCpHDOShli8oK6ZMZB0tTbh4LFMVw=;
	b=SMO9mvVJcjYnn/P4bCdCBz3lAN2DM5NLKp00ItLTi14hFU1FT1BIpCk2cjrgwZl0xjZc1y
	/FofN9ECBlWroHu8kHgTRvxfS0gDNIC0hbKdjeyZrENf2Yu1A//GlFTw/U4bWtErShWk+6
	/898KScKPS3+hua5w8WLamES+SvnJhI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 0/7] KVM: arm64: Add support for FEAT_TLBIRANGE
Message-ID: <ZImwRAuSXcVt3UPV@linux.dev>
References: <20230606192858.3600174-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606192858.3600174-1-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Raghavendra,

On Tue, Jun 06, 2023 at 07:28:51PM +0000, Raghavendra Rao Ananta wrote:
> The series is based off of upstream v6.4-rc2, and applied David
> Matlack's common API for TLB invalidations[1] on top.

Sorry I didn't spot the dependency earlier, but this isn't helpful TBH.

David's series was partially applied, and what remains no longer cleanly
applies to the base you suggest. Independent of that, my *strong*
preference is that you just send out a series containing your patches as
well as David's. Coordinating dependent efforts is the only sane thing
to do. Also, those patches are 5 months old at this point which is
ancient history.

> [1]:
> https://lore.kernel.org/linux-arm-kernel/20230126184025.2294823-1-dmatlack@google.com/

-- 
Thanks,
Oliver
