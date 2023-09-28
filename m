Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFD24C7E
	for <kvmarm@lists.linux.dev>; Thu, 28 Sep 2023 22:19:43 +0000 (UTC)
Date: Thu, 28 Sep 2023 22:19:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695939581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yGg7pY7KhRw+YOmFUl/1WZXjN2FD7xN06g/pv2WG4WM=;
	b=CBhdNxghpB0mVzHuuSrw6OO1UOX2NdQT+l0g3mJkq8XiaAoFRUSGq02uLp1lXMIYGt7fyh
	24AHdiCCyF/bnXzHtA20ShPSFQvWnPxZGxb5sL5HqFfMz6rTxvSiuXXBzo3ZfxvUjjeLWh
	21juYxDuBNTUCaOJWDVgbaNNRkdXw78=
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
Message-ID: <ZRX7-EJ9w-Nmyxjz@linux.dev>
References: <20230922112508.1774352-1-kristina.martsenko@arm.com>
 <ZRPE9OcB9ndgFxbs@linux.dev>
 <6687f58c-0da9-0583-2dc1-2089f292b745@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6687f58c-0da9-0583-2dc1-2089f292b745@arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 28, 2023 at 05:55:39PM +0100, Kristina Martsenko wrote:

[...]

> > Perhaps I'm being pedantic, but I'd really like for there to be some
> > documentation that suggests MOPS exceptions can happen due to context
> > migration done by a higher EL as that is the only option in the context
> > of virtualization.
> 
> That's a good point. This shouldn't affect Linux guests as Linux is
> always able to handle a MOPS exception coming from EL0. But it would
> affect any non-Linux guest that pins all its EL0 tasks and doesn't
> implement a handler. It's not clear to me what the expectation for
> guests is, I'll ask the architects to clarify and get back to you.

That'd be excellent, thanks! All I'm looking for is something to point
folks at if/when they complain about MOPS behavior in KVM guests.

-- 
Thanks,
Oliver
