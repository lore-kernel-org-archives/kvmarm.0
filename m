Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845AB1684B4
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767712463; cv=none; b=SmN6cGR4d7v7ohIEZH1KjBj+ebOXez8OA/cATLc9sdxW2Q1O5s5ri991F3iRTv7/+U7LZUTfK+nqtKGk6Q6RihaOdCJqsAiItYrq7mz9Rxfk60p9lyNvVBhgTtE155bdZhRiEMgLAKi+pGsz50EJ1nLYPpSS/cm1+Sh539fmYcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767712463; c=relaxed/simple;
	bh=qJjWFMrm2lSltPboaeRjtY/9lwQapGTPtRXjwelNq4Q=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eWyl8LA2LbDRluK7SpoU1Dts9W9Oj0U/sLt9wrBpyrc5GRyI1PxSv5ul1pstkpFl2NGdj3Aq3DNj3PQKFmFAud3gOImEJud0t3lfwIK0zixJM/JriWf1KYtddHtlfCyNrG2ezPd8nmSSRSBhnp/v87qiYAEOeSu3NTXFwAn8eXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlvpG2c3zzHnH4v;
	Tue,  6 Jan 2026 23:14:14 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id B759240539;
	Tue,  6 Jan 2026 23:14:18 +0800 (CST)
Received: from localhost (10.195.245.156) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 15:14:17 +0000
Date: Tue, 6 Jan 2026 15:14:15 +0000
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
Subject: Re: [PATCH v2 41/45] arm_mpam: Add quirk framework
Message-ID: <20260106151415.00002119@huawei.com>
In-Reply-To: <20251219181147.3404071-42-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-42-ben.horgan@arm.com>
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

On Fri, 19 Dec 2025 18:11:43 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: Shanker Donthineni <sdonthineni@nvidia.com>
> 
> The MPAM specification includes the MPAMF_IIDR, which serves to uniquely
> identify the MSC implementation through a combination of implementer
> details, product ID, variant, and revision. Certain hardware issues/errata
> can be resolved using software workarounds.
> 
> Introduce a quirk framework to allow workarounds to be enabled based on the
> MPAMF_IIDR value.
> 
> [ morse: Stash the IIDR so this doesn't need an IPI, enable quirks only
> once, move the description to the callback so it can be pr_once()d, add an
> enum of workarounds for popular errata. Add macros for making lists of
> product/revision/vendor half readable ]

Review comment that got left over? 

Otherwise looks fairly standard for quirk handling.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> 
> Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>

