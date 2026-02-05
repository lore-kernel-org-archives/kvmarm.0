Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0DE22339
	for <kvmarm@lists.linux.dev>; Thu,  5 Feb 2026 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770311165; cv=none; b=eUYBldfCjc8uTxzpANdY1l18TUWK2ADvLfHLVVPkt/53eEqimRpgE/DM3Nx9XG+mZ5hcwggkQGoLOqqaSPCaZR5FIwvNWvHUvC7nVgzEWUdhYQ0BnvtfUc70zF0yZw8b4Z1Bhz3rQNuilLwnwHdvNPc589wgAzlTor9Vxbl7DhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770311165; c=relaxed/simple;
	bh=+ggiuJ6rgpm0PJdw5izu+TS4/QQkwT9qxIic9BaESVo=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mzoaF5UXE4c3dWpivH9001xrc9i3See99jRn7QjwZ4dw1rLPDn59p0iDF7uvrkEwGbaXQJ8ri+Zo85XrXvEymQJQn5buJJubodm8+JPE9/l+9zaRdLkpivFWpxeeHj+6LSDiOHqH5oMCJreZ7xkhk2ME9qe2VuetnwS5ZiQpOqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4f6NsL2811zHnGcj;
	Fri,  6 Feb 2026 01:05:58 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 152ED40565;
	Fri,  6 Feb 2026 01:06:01 +0800 (CST)
Received: from localhost (10.48.151.164) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 5 Feb
 2026 17:05:59 +0000
Date: Thu, 5 Feb 2026 17:05:57 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	<zengheng4@huawei.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 41/41] arm64: mpam: Add initial MPAM documentation
Message-ID: <20260205170557.00000d4d@huawei.com>
In-Reply-To: <20260203214342.584712-42-ben.horgan@arm.com>
References: <20260203214342.584712-1-ben.horgan@arm.com>
	<20260203214342.584712-42-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 3 Feb 2026 21:43:42 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> MPAM (Memory Partitioning and Monitoring) is now exposed to user-space via
> resctrl. Add some documentation so the user knows what features to expect.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> Changes by Ben:
> Some tidying, update for current heuristics
> ---
>  Documentation/arch/arm64/index.rst |  1 +
>  Documentation/arch/arm64/mpam.rst  | 93 ++++++++++++++++++++++++++++++
>  2 files changed, 94 insertions(+)
>  create mode 100644 Documentation/arch/arm64/mpam.rst
> 
> diff --git a/Documentation/arch/arm64/index.rst b/Documentation/arch/arm64/index.rst
> index 6a012c98bdcd..189fa760dade 100644
> --- a/Documentation/arch/arm64/index.rst
> +++ b/Documentation/arch/arm64/index.rst
> @@ -23,6 +23,7 @@ ARM64 Architecture
>      memory
>      memory-tagging-extension
>      mops
> +    mpam
>      perf
>      pointer-authentication
>      ptdump
> diff --git a/Documentation/arch/arm64/mpam.rst b/Documentation/arch/arm64/mpam.rst
> new file mode 100644
> index 000000000000..0769bccff25e
> --- /dev/null
> +++ b/Documentation/arch/arm64/mpam.rst
> @@ -0,0 +1,93 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +====
> +MPAM
> +====
> +
> +What is MPAM
> +============


> +  MPAM (Memory Partitioning and Monitoring) is a feature in the CPUs and memory

I've not seen this style of indenting much in rst.  I checked a few
files in this directory and it's not used in the ones I randomly picked.
+ it's not what the kernel-documentation.rst file suggests is standard
formatting.

Other than that the content looks fine to me.

Jonathan
