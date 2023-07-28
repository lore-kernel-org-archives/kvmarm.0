Received: from out-80.mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFE314288
	for <kvmarm@lists.linux.dev>; Fri, 28 Jul 2023 17:12:09 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690564327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DsvnqkJx4HvTJ9g/ziqmsG1QtZPy1BU6tX/Ss7eA1j0=;
	b=njeG4Y0KJd0T+KlwnTKm965o0prvtsaWuXsyzstfvWQSdGu4lLL8ww04NF7kiLchnVTk/u
	z2wF01FY1L/QOhb/jgt301zib6zFzmLy1yZU7bD2Yh9ywlI2QBxkBSagCgDof4tgcKCcLl
	2AP7QG6ubsbH1L3ESVvkcMwSYwkwCsA=
From: Oliver Upton <oliver.upton@linux.dev>
To: Oliver Upton <oliver.upton@linux.dev>,
	kvmarm@lists.linux.dev
Cc: Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Skip instruction after emulating write to TCR_EL1
Date: Fri, 28 Jul 2023 17:11:59 +0000
Message-ID: <169056430034.3952077.3944874651084162091.b4-ty@linux.dev>
In-Reply-To: <20230728000824.3848025-1-oliver.upton@linux.dev>
References: <20230728000824.3848025-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Fri, 28 Jul 2023 00:08:24 +0000, Oliver Upton wrote:
> Whelp, this is embarrassing. Since commit 082fdfd13841 ("KVM: arm64:
> Prevent guests from enabling HA/HD on Ampere1") KVM traps writes to
> TCR_EL1 on AmpereOne to work around an erratum in the unadvertised
> HAFDBS implementation, preventing the guest from enabling the feature.
> Unfortunately, I failed virtualization 101 when working on that change,
> and forgot to advance PC after instruction emulation.
> 
> [...]

Applied to kvmarm/fixes, thanks!

[1/1] KVM: arm64: Skip instruction after emulating write to TCR_EL1
      https://git.kernel.org/kvmarm/kvmarm/c/74158a8cad79

--
Best,
Oliver
