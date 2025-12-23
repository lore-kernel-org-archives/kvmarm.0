Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BB5324B23
	for <kvmarm@lists.linux.dev>; Tue, 23 Dec 2025 11:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766491090; cv=none; b=RNPA6ksjGylYa8DSpA75M7aABPn323Gq7Lef1AR0tVKpzRZMLUQaIcv6jfKgx19119EamuvHdmyj35gobcdqCPdFzkAaLyTiIZrk/YO+ws6GGBaSE9cEsRPU8w20fhsOb1InKK9kdpJMSTIXk9W+RN5BMhx0Lt85/7WoxQLmbI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766491090; c=relaxed/simple;
	bh=b1DMSRx0tnwZHhc07Y+xnNyYOeXmednPEt+Tg6t//es=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lly6B7G7heyuysq3Qj0d1h4vQcxviDPi4BVz/nypAtgJU0a8LWpRt2VcazE6d09NSyEuDYpJuAWlgIuTqVIIJ4baVSJehZ8R0HTSBNroeCiqxyt804AFyDRNMJEIhmDeFnb32+F6umiCVQNypqrcbgeHi9qhhNwBP8yFokbBEUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dbD5d2j4KzJ46Zh;
	Tue, 23 Dec 2025 19:57:25 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 709B940539;
	Tue, 23 Dec 2025 19:58:04 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 23 Dec
 2025 11:58:03 +0000
Date: Tue, 23 Dec 2025 11:58:01 +0000
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
	kernel test robot <lkp@intel.com>, Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH v2 01/45] arm_mpam: Stop using uninitialized variables
 in __ris_msmon_read()
Message-ID: <20251223115801.000033cb@huawei.com>
In-Reply-To: <20251219181147.3404071-2-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-2-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500010.china.huawei.com (7.191.174.240) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:03 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> Dan has reported two uses of uninitialized variables in __ris_msmon_read().
> If an unknown monitor type is encountered then the local variable, now, is
> used uninitialized. Fix this by returning early on error. If a non-mbwu
> monitor is being read then the local variable, overflow, is not initialized
> but still read. Initialize it to false as overflow is not relevant for csu
> monitors.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202512091519.RBwiJcSq-lkp@intel.com/
> Closes: https://lore.kernel.org/r/202512100547.N7QPYgfb-lkp@intel.com/
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
