Received: from out-220.mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621B514014
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 17:15:04 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695057302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f5gDnQ+vbW/swFSOMqP5K+xBHb3CMY5siz4f0e8auM8=;
	b=ZGgsZz13jPr+JKAe5V3bNFFEBoUqQMRSHEpo/5seHdo5o/ew8PFGZM+CF8fmgDrWvBEzfz
	F2XfWJsDj4i6Is2y8CKYshuwbDMHKwqQHtK6S17K8utdFrXge5wVel9Xj4WBxPD5m0G6m1
	hm1sLiPE2t4vNPqIVasDSXoFcoJrxXA=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't use kerneldoc comment for arm64_check_features()
Date: Mon, 18 Sep 2023 17:14:50 +0000
Message-ID: <169505728619.3220441.6873711747214008692.b4-ty@linux.dev>
In-Reply-To: <20230913165645.2319017-1-oliver.upton@linux.dev>
References: <20230913165645.2319017-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 13 Sep 2023 16:56:44 +0000, Oliver Upton wrote:
> A double-asterisk opening mark to the comment (i.e. '/**') indicates a
> comment block is in the kerneldoc format. There's automation in place to
> validate that kerneldoc blocks actually adhere to the formatting rules.
> 
> The function comment for arm64_check_features() isn't kerneldoc; use a
> 'regular' comment to silence automation warnings.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Don't use kerneldoc comment for arm64_check_features()
      https://git.kernel.org/kvmarm/kvmarm/c/7b424ffcd458

--
Best,
Oliver
