Received: from out-58.mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A43F1F93A
	for <kvmarm@lists.linux.dev>; Mon,  5 Jun 2023 15:42:00 +0000 (UTC)
Date: Mon, 5 Jun 2023 15:41:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1685979719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3vE3qz2IJG9FXtMC5do8DKxh24CXgTlhxDJppkemDRI=;
	b=PwIscskWzGW+xkGcfpDemDLACxtF5hKhwrcMhCP1iDbpL8o2YScovP64XLDLuZJNAN3598
	EDTiJB93XKt1zo8Vti55c2XI4cLsHunuwDx4e78MoJIwszv8oM1w4IEpsJIe/KT69I7x6v
	O9oqY7WzxnY2TtyL2bnTm624zUao3EM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kristina Martsenko <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/11] KVM: arm64: switch HCRX_EL2 between host and
 guest
Message-ID: <ZH4CQhZLdJy4wVni@linux.dev>
References: <20230509142235.3284028-1-kristina.martsenko@arm.com>
 <20230509142235.3284028-4-kristina.martsenko@arm.com>
 <ZHnz+Tgx8uHp5qmC@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHnz+Tgx8uHp5qmC@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 02, 2023 at 02:51:53PM +0100, Catalin Marinas wrote:
> On Tue, May 09, 2023 at 03:22:27PM +0100, Kristina Martsenko wrote:
> > Switch the HCRX_EL2 register between host and guest configurations, in
> > order to enable different features in the host and guest.
> > 
> > Now that there are separate guest flags, we can also remove SMPME from
> > the host flags, as SMPME is used for virtualizing SME priorities and has
> > no use in the host.
> > 
> > Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
> 
> Same here, it could be good to have Marc/Oliver look at this.

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
