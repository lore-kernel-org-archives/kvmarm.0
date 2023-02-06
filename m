Received: from out-27.mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430D053BB
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 19:20:27 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1675703438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7XA5QSv63VPLcx4lyZYrcadMEE8df20CdUUmx5nHgas=;
	b=Ocq17HFPSuGO2rdJRrkICnLujG+dbdeX0meG860noBXqCG/ROK7nBXtflFJw8c5eX0EAlY
	d5U2LuHdv+Y/bhg6wJ2+rsViGK/A78siNc/CLB7/VpIhj258kPzj1DKCi7t+A9gYlvsBzg
	a3eUGpQ3OljGSXbZGr0tLnKiKn5oJ00=
From: Oliver Upton <oliver.upton@linux.dev>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	maz@kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	james.morse@arm.com,
	Abaci Robot <abaci@linux.alibaba.com>,
	catalin.marinas@arm.com
Subject: Re: [PATCH] arm64/sysreg: clean up some inconsistent indenting
Date: Mon,  6 Feb 2023 17:10:27 +0000
Message-Id: <167570340669.3821815.15020392607863462264.b4-ty@linux.dev>
In-Reply-To: <20230131082703.118101-1-jiapeng.chong@linux.alibaba.com>
References: <20230131082703.118101-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 31 Jan 2023 16:27:03 +0800, Jiapeng Chong wrote:
> No functional modification involved.
> 
> ./arch/arm64/kvm/sys_regs.c:80:2-9: code aligned with following code on line 82.
> 
> 

Applied to kvmarm/next, thanks!

[1/1] arm64/sysreg: clean up some inconsistent indenting
      https://git.kernel.org/kvmarm/kvmarm/c/242b6f34b5b5

--
Best,
Oliver
