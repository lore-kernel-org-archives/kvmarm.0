Received: from out-199.mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE24925115
	for <kvmarm@lists.linux.dev>; Tue, 24 Oct 2023 10:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WU3amu7+"
Date: Tue, 24 Oct 2023 10:36:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698143820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RaUc/Jh4+pZIFR1fAHzmEjaXtHZw7YWxzJm5LgrjjuY=;
	b=WU3amu7+Q5EXmgP9gUt1h0OgzkOD7zhq9OHo9UNenhwInKHnBObC/0S5S+UVCgnt9ovhYQ
	jy9NQY1SpdyoSGenZuSPFLA30au1dorNNAfSfueDjGgghHaWHvXeZLTt73DcLS1qya06pe
	/ILtcar6fYZy/j4RNgVsRgm/VwQ4KQI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 13/13] KVM: selftests: aarch64: vPMU test for
 immutability
Message-ID: <ZTeeR7xHmMELgVGZ@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <20231020214053.2144305-14-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020214053.2144305-14-rananta@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 20, 2023 at 09:40:53PM +0000, Raghavendra Rao Ananta wrote:
> KVM marks some of the vPMU registers as immutable to
> userspace once the vCPU has started running. Add a test
> scenario to check this behavior.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Now that PMCR_EL0.N is the only thing that's getting the immutability
treatment this patch fails. I'll probably drop it.

-- 
Thanks,
Oliver
