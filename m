Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC51A93D
	for <kvmarm@lists.linux.dev>; Tue, 31 Jan 2023 20:18:08 +0000 (UTC)
Date: Tue, 31 Jan 2023 20:17:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675196279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=skSmAFiSE0Dtjhlb7qVhiSxPiwmHcN8uiIj+E97KPGs=;
	b=hob2ahBgh81EXOzW/21K6FclEBEe0sNozI9s3tH5sajZiBz20jaAUbHK7dhpp6znM/qryH
	A4ljDdRyvRZyeVOmhmwzefAI1gIcWcCQD9MVQIaXZ5sgFqpzdmo4/D5UPxBtDWN50at4Hy
	GBg6MrEZjDfS0AOI0AlrjzyEdRcbxNI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v8 09/69] KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2
 to sane values
Message-ID: <Y9l3bofl5nMWy3wZ@google.com>
References: <20230131092504.2880505-1-maz@kernel.org>
 <20230131092504.2880505-10-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131092504.2880505-10-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 31, 2023 at 09:24:04AM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> The VMPIDR_EL2 and VPIDR_EL2 are architecturally UNKNOWN at reset, but
> let's be nice to a guest hypervisor behaving foolishly and reset these
> to something reasonable anyway.

Must we be so kind? :)

In all seriousness, I've found the hexspeak value of reset_unknown() to
be a rather useful debugging aid. And I can promise you that I'll use NV
to debug my own crap changes!

Any particular reason against just using reset_unknown()?

-- 
Thanks,
Oliver
