Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4050A259C9C
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 14:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768314070; cv=none; b=aeHr6Udm3AW9Frcxt1jacg/RtGvXIvxjbmxJkK5MV4QkO+6c3VNK6HEyVLWlrJOq5+Epbz7mbxn+Vd9cH3hoz8IVlKIOoL69YBMrjT4MX1qpqNTJHaPqLvb84pF3N+/LnJmJmwWgQyxlE7wFfp77XQArun+lq5F4lEvEBcjuwFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768314070; c=relaxed/simple;
	bh=0BQWiz8SX07eje7WjPsQJTGhZVVXklD3eZ7nPpNNYVI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K5E4G+tVaMc745mQv/BWL0JT+1LoWRtkIaHqPKcZDeMdXbJ2/NyowMw1fuIfXrA1l424kYo8Nmcv8OQWdpeaXcLPirzv+OmilzJc6JgqzKG1OTvWHRr3rTzwKWiGWQ0XsXFdTA4+osEWAXiJktwZO+TycG2sSsnHxq1V8ibHJ2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4drBHT5c2LzJ46ZX;
	Tue, 13 Jan 2026 22:20:53 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id D801340585;
	Tue, 13 Jan 2026 22:21:06 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 13 Jan
 2026 14:21:05 +0000
Date: Tue, 13 Jan 2026 14:21:04 +0000
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
Subject: Re: [PATCH v3 13/47] KVM: arm64: Use kernel-space partid
 configuration for hypercalls
Message-ID: <20260113142104.00002641@huawei.com>
In-Reply-To: <20260112165914.4086692-14-ben.horgan@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
	<20260112165914.4086692-14-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 12 Jan 2026 16:58:40 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> On nVHE systems whether or not MPAM is enabled, EL2 continues to use
> partid-0 for hypercalls, even when the host may have configured its kernel
> threads to use a different partid. 0 may have been assigned to another
> task. Copy the EL1 MPAM register to EL2. This ensures hypercalls use the
> same partid as the kernel thread does on the host.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
> Changes since v2:
> Use mask
> Use read_sysreg_el1 to cope with hvhe

nvhe
