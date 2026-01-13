Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641EC2D5950
	for <kvmarm@lists.linux.dev>; Tue, 13 Jan 2026 14:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316147; cv=none; b=VRA2yRjCSELZviHSSJ2FM8yaH0mgfyMoJ+eQJGHt9gYKlZ0vHoaxuKgDSorUELq3JCN/wtrlWfb/lXCEIrc+D6QDXCcpy12pXpissyfGlIhDqV+0Wc9e0/W8MoACw7impGTrx7q3w0TTvYlh6CKy+ZxJiIrmvWSsSzka6Eahs/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316147; c=relaxed/simple;
	bh=f0pijcQ+ScNURV3JE7cr711JsK3by115WJQl0YPkpE4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qq30oxFzF1OigEC1VDiUCqukMhA3rFDCxS/iS6OiOwKReLhId0pyWN//p5KwXjBnEU85Y8gSv+iUyhfJq0ENKoe4gP3BMF8HXQqo5m2NwCdHDXn78J1mjYRYEfVtgY0Erekt1ziMzii/DC41hR9r2jVOZxF5vyk2IFTaESH9u8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4drC3Q012nzJ46BR;
	Tue, 13 Jan 2026 22:55:30 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 2853740563;
	Tue, 13 Jan 2026 22:55:43 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 13 Jan
 2026 14:55:41 +0000
Date: Tue, 13 Jan 2026 14:55:40 +0000
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
Subject: Re: [PATCH v3 24/47] arm_mpam: resctrl: Add rmid index helpers
Message-ID: <20260113145540.000026d5@huawei.com>
In-Reply-To: <20260112165914.4086692-25-ben.horgan@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
	<20260112165914.4086692-25-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Mon, 12 Jan 2026 16:58:51 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> Because MPAM's pmg aren't identical to RDT's rmid, resctrl handles some
> data structures by index. This allows x86 to map indexes to RMID, and MPAM
> to map them to partid-and-pmg.
> 
> Add the helpers to do this.
> 
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Much easier to read. Thanks!

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
