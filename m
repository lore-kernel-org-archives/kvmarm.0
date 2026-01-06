Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A19D330311
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767711005; cv=none; b=Ic4XQCrDB1vUq+vQJkw6YpC9v4jkCJ/m17LXOqDH8GFcAGp9xb0jRPjYNcZwBKUzQztHdIinGE0/DJro1ouzyCixbJTMHA0IcrH8i71lgzNqj1AkUbjwURV2eIKnzgeCn5f8Y2OG7AtZZOuOutzXqkHBXQJ3QebNyK+t4aDQxxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767711005; c=relaxed/simple;
	bh=qmk9IHicIfsxj2E5iwdPSUw7497OAhZX+qC604ylSAU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ix84kAplGuGTZ2hSHtpUCOGdXWBXakGvQOYR1nuweULKnDa5IjtdMe6tp/FMjRf+o2Yz9h13i7uTSyHR5kvtrdP0ei4Qvmy/EL4w2TOT2LjjYnx7dqI4ROY2EcCEYXS0NOXUCiQ+2mUuEv0fw+qUNXD3jEmzS51FQ5B/dnlfokE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlvGF1gFnzHnHGH;
	Tue,  6 Jan 2026 22:49:57 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F2A240086;
	Tue,  6 Jan 2026 22:50:01 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 14:49:59 +0000
Date: Tue, 6 Jan 2026 14:49:58 +0000
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
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>
Subject: Re: [PATCH v2 38/45] arm64: mpam: Select ARCH_HAS_CPU_RESCTRL
Message-ID: <20260106144958.00005a5c@huawei.com>
In-Reply-To: <20251219181147.3404071-39-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-39-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:40 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> Enough MPAM support is present to enable ARCH_HAS_CPU_RESCTRL.  Let it
> rip^Wlink!
> 
> ARCH_HAS_CPU_RESCTRL indicates resctrl can be enabled. It is enabled by the
> arch code simply because it has 'arch' in its name.
> 
> This removes ARM_CPU_RESCTRL as a mimic of X86_CPU_RESCTRL.  While here,
> move the ACPI dependency to the driver's Kconfig file.
> 
> In anticipation of MPAM being useful remove the CONFIG_EXPERT restriction.
Lol. I hope it is useful :)
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
