Received: from out-194.mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21C1154A0
	for <kvmarm@lists.linux.dev>; Wed, 27 Sep 2023 06:00:27 +0000 (UTC)
Date: Wed, 27 Sep 2023 06:00:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695794425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3hbQpc4UesV7IX0JvCrTUx6QA3LAg9gDtHymuaQldZw=;
	b=eifoM+TFNp9/h7Xw9Ksm3RmCyTja/wb9Dr3OWTc22KJpHs9wmNbtVeET3FYkloyTu7fIjd
	E4bRUlHqgYeMPyaiXAUsLVgNAXBqbN2+i4L2JojMXPPPRKd61taTGJJYHyYST+kc+3gprs
	QgKoQIfrsbwo964baGJO29+Ss2z6v/0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Kristina Martsenko <kristina.martsenko@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Colton Lewis <coltonlewis@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM: arm64: Support for Arm v8.8 memcpy
 instructions in KVM guests
Message-ID: <ZRPE9OcB9ndgFxbs@linux.dev>
References: <20230922112508.1774352-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922112508.1774352-1-kristina.martsenko@arm.com>
X-Migadu-Flow: FLOW_OUT

Hi Kristina,

On Fri, Sep 22, 2023 at 12:25:06PM +0100, Kristina Martsenko wrote:
> Hi,
> 
> This is v2 of the series to allow using the new Arm memory copy instructions
> in KVM guests. See v1 for more information [1].


Thanks for sending out the series. I've been thinking about what the
architecture says for MOPS, and I wonder if what's currently in the
Arm ARM is clear enough for EL1 software to be written robustly.

While HCRX_EL2.MCE2 allows the hypervisor to intervene on MOPS
exceptions from EL1, there's no such control for EL0. So when vCPU
migration occurs EL1 could get an unexpected MOPS exception, even for a
process that was pinned to a single (virtual) CPU implementation.

Additionally, the wording of I_NXHPS seems to suggest that EL2 handling
of MOPS exceptions is only expected in certain circumstances where EL1 is
incapable of handling an exception. Is the unwritten expectation then
that EL1 software should tolerate 'unexpected' MOPS exceptions from EL1
and EL0, even if EL1 did not migrate the PE context?

Perhaps I'm being pedantic, but I'd really like for there to be some
documentation that suggests MOPS exceptions can happen due to context
migration done by a higher EL as that is the only option in the context
of virtualization.

-- 
Thanks,
Oliver
