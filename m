Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA73B3939B2
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 15:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768318788; cv=none; b=Cqvy2rvn4JpyKHbZQA4500tsu0BGdSnboEtI2pFC/3bZHeXWvmUfFF2yZCVg9TA7fztH64uFq8hKMgtgLlH0iPtKtXVmcm0DI/YBqT80yyNCoEQ9O3bSwxVRgdJGCvnSGE2UYiM4f60K7G2HBF7cwwcmkee3JuneaQfc2O3oafs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768318788; c=relaxed/simple;
	bh=Kcdt6ezZS7r5e8cIC6YRtm7HY+hZIKH7R6q1b/F9slE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HaoIH+28MSpZ8K+DC3kKyj18opp96u1k+0DKIAcQ+uAwvCw+HWIlHA29B9gxarfoI/uEdGwVmfRm3YyOZSe3f9cwgDdMzurUlkQ8LSQMSv4yGHRuFPZ8r++xAAgQHK3ZeeKltdVLilwm0Pcpw0Ak2zRoxIWgFC2Wt4TLzm52xGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4drD231SJ5zHnGdQ;
	Tue, 13 Jan 2026 23:39:23 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 63C1A40572;
	Tue, 13 Jan 2026 23:39:41 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 13 Jan
 2026 15:39:40 +0000
Date: Tue, 13 Jan 2026 15:39:38 +0000
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
	Zeng Heng <zengheng4@huawei.com>
Subject: Re: [PATCH v3 41/47] arm_mpam: Generate a configuration for min
 controls
Message-ID: <20260113153938.00007d6e@huawei.com>
In-Reply-To: <20260112165914.4086692-42-ben.horgan@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
	<20260112165914.4086692-42-ben.horgan@arm.com>
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
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 12 Jan 2026 16:59:08 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: James Morse <james.morse@arm.com>
> 
> MPAM supports a minimum and maximum control for memory bandwidth. The
> purpose of the minimum control is to give priority to tasks that are below
> their minimum value. Resctrl only provides one value for the bandwidth
> configuration, which is used for the maximum.
> 
> The minimum control is always programmed to zero on hardware that supports
> it.
> 
> Generate a minimum bandwidth value that is 5% lower than the value provided
> by resctrl. This means tasks that are not receiving their target bandwidth
> can be prioritised by the hardware.
> 
> For component reset reuse the same calculation so that the default is a
> value resctrl can set.
> 
> CC: Zeng Heng <zengheng4@huawei.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

I'm interested to see how this plays out as a default choice
vs what people elect to run.  Seems harmless to start with this.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

