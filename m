Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBC5329C7A
	for <kvmarm@lists.linux.dev>; Tue, 23 Dec 2025 12:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766491832; cv=none; b=F/L+GxnWMSmfd91gZiVbZL3yB0eEc21Xcw9N2hsDg3Qli+RiScRkGcGjsi7dOvYQ7QAU5FDLi35uPdtWkOyEg0yg/nfSXlccmakxOyhxdKY5O4CQb4wGwsLwSb3+FlQmnK60bSR01wQeL24iDA86nqr0SoO+KLuELZydsNknGQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766491832; c=relaxed/simple;
	bh=jojUnKKtKVeQuNtHocg++VDejjBu6EtR5efk02nhObs=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F+t49bRT1V41c50Z1qwCYdvyVhYl0c1VPTZPMyNFZJBUabCgjVqHQQniL6c/L5yPCChSlAD9D2nAEnRAspbynIxLZ4VZQdO2czBxd+SJq7Ef0lQYyWOW2q81MQVvnJddf6xF2by7wt/Ghr21lQoZs7dYhBZDdyPBASWIuOvIXe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dbDMx65qPzHnGkK;
	Tue, 23 Dec 2025 20:09:49 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id B2AF540571;
	Tue, 23 Dec 2025 20:10:26 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 23 Dec
 2025 12:10:25 +0000
Date: Tue, 23 Dec 2025 12:10:23 +0000
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
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, Abaci Robot
	<abaci@linux.alibaba.com>
Subject: Re: [PATCH v2 02/45] arm_mpam: Remove duplicate linux/srcu.h header
Message-ID: <20251223121023.0000200e@huawei.com>
In-Reply-To: <20251219181147.3404071-3-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-3-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:04 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> ./drivers/resctrl/mpam_internal.h: linux/srcu.h is included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=27328
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Acked-by: James Morse <james.morse@arm.com>
> [BH: Keep alphabetical order]
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
