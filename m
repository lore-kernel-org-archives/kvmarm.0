Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD21B33E34E
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767630885; cv=none; b=dHo/g2J+PpxKMt49YvsB1rxGo/fsuLCDpCQc5+TyBLf2sXBTuq/AT6lxNYv03FxMMfObvTh55/NiXnMFexcUkX+R/wFen+qyD5oUkzydpPVL/MZhrO9tswstbCJzX8jj51xn/GyHYkl/LWBWtxIc3fCT6SWRNngM0gNz4k/nRN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767630885; c=relaxed/simple;
	bh=TfjKrmXxJPeOsl4i6aYog6sxW8rVl4IWIVyggbgz+zE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gLCWekOe1dm+wC2jLGQEf6E0jtbI+8/CDl8gDZL5muIZpynlJa2yjLzGwjifxfxAwNCHQjMx6j5ijaHHQRUKXf7Q1Etzeeqcsqhn7YKb8oVBVP3Q+tTtJE5GXSWpzFdsB5uDxFdK7lHSuC1K3DtMla95vR1td/ukomIzm41EQ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlKcM6dllzJ46Ck;
	Tue,  6 Jan 2026 00:33:39 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 87DB940569;
	Tue,  6 Jan 2026 00:34:40 +0800 (CST)
Received: from localhost (10.126.174.38) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 5 Jan
 2026 16:34:38 +0000
Date: Mon, 5 Jan 2026 16:34:37 +0000
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
Subject: Re: [PATCH v2 03/45] arm_mpam: Use non-atomic bitops when modifying
 feature bitmap
Message-ID: <20260105163305.00002306@huawei.com>
In-Reply-To: <20251219181147.3404071-4-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-4-ben.horgan@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500009.china.huawei.com (7.191.174.84) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Fri, 19 Dec 2025 18:11:05 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> In the test__props_mismatch() kunit test we rely on the struct mpam_props
> being packed to ensure memcmp doesn't consider packing. Making it packed
> reduces the alignment of the features bitmap and so breaks a requirement
> for the use of atomics. As we don't rely on the set/clear of these bits
> being atomic, just make them non-atomic.

oh. That's a bit horrible.

Whilst I guess no one is likely to 'upgrade' these it feels odd enough that
I'd be tempted to leave a breadcrumb of a comment next to them on why
they must be the non atomic versions.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

Jonathan


> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
>  drivers/resctrl/mpam_internal.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 17cdc3080d58..aaaf31ca9210 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -200,8 +200,8 @@ struct mpam_props {
>  } PACKED_FOR_KUNIT;
>  
>  #define mpam_has_feature(_feat, x)	test_bit(_feat, (x)->features)
> -#define mpam_set_feature(_feat, x)	set_bit(_feat, (x)->features)
> -#define mpam_clear_feature(_feat, x)	clear_bit(_feat, (x)->features)
> +#define mpam_set_feature(_feat, x)	__set_bit(_feat, (x)->features)
> +#define mpam_clear_feature(_feat, x)	__clear_bit(_feat, (x)->features)
>  
>  /* The values for MSMON_CFG_MBWU_FLT.RWBW */
>  enum mon_filter_options {

