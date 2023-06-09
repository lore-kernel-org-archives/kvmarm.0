Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFCB408C0
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 19:08:13 +0000 (UTC)
Date: Fri, 9 Jun 2023 19:08:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686337691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B64nSOlCCnEgdMnGqkWZ1xGfnO2cFqk4dnjj/O13FsA=;
	b=uRNUS5izmpzIxz6l0qHz4bVJIwTWHCishop31ZGJRT0l6coYw9tuyCwVayXRMb+7Fjet9U
	XkpVys5wl7T9/4v1AaKe6nFKjQP73fXsagCQvwqHwv/m9wntNme+yKFNidmwtORewsVUxs
	DVRS/TZp0TlVX2hXUb1hairfkEaU1E8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
	surajjs@amazon.com, Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v12 00/11] Support writable CPU ID registers from
 userspace
Message-ID: <ZIN4lvTS6WCNwTr4@linux.dev>
References: <20230609190054.1542113-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609190054.1542113-1-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT

Hey,

For the new arm64 folks I've added to the conversation, apologies for
the rather vague cover letter title. I kept the original author's title,
but this is solely focused on KVM support for changing guest ID register
values.

As always, feedback appreciated on the whole series, but the most
interesting interaction comes from patch 7 where KVM leverages some of
the cpufeature infrastructure for ID register validation.

-- 
Thanks,
Oliver

On Fri, Jun 09, 2023 at 07:00:43PM +0000, Oliver Upton wrote:
> Hello folks,
> 
> In the interest of expediting the acceptance of the generalized ID
> register infrastructure, I have taken Jing's series and applied fixes
> according to the feedback of reviewers and my own interpretation.

[...]
