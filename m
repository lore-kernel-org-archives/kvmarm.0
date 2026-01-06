Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35DC32BF4B
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 12:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767702646; cv=none; b=P8Zhnd03X9QPEUQsXJw/66xwyMXL+UahL8N7c5Su3LeHKLcNzXON1YKMSTLoY5+schmof0kjFM2O/3vTzvEgmqWyQWXkUG7sQXmXQ6OBGQRksco82pHHIGQLZ5w7cvDOMPAHBhTwO1KxsHzhPSCEgGX3mnLP/41h0GN4FSPwa/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767702646; c=relaxed/simple;
	bh=XbRk/0mkagbwPwkjXPqucfxdB/jtUjW0ixZ+BxUpamY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EYnRN2HXcV6q8KGpi2UaWw3gKRSydH5oqM9rP2U66RYPmGwYFlECgHZIJCKt1ZEy4PrmX5Jfgz3mIX3bMfwUsd92D/DYG8yOpDpnvqBZfslaYAeBIWG/Rq1C6gRe67wbdI42zrb8BH42ZhlWa9/QRnyfDE7M39gHK80iqXR3AMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlr9W422czJ46qH;
	Tue,  6 Jan 2026 20:30:39 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E6BD40086;
	Tue,  6 Jan 2026 20:30:41 +0800 (CST)
Received: from localhost (10.48.155.65) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 6 Jan
 2026 12:30:39 +0000
Date: Tue, 6 Jan 2026 12:30:37 +0000
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
Subject: Re: [PATCH v2 26/45] arm_mpam: resctrl: Add kunit test for control
 format conversions
Message-ID: <20260106123037.000039d0@huawei.com>
In-Reply-To: <20251219181147.3404071-27-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-27-ben.horgan@arm.com>
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

On Fri, 19 Dec 2025 18:11:28 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> From: Dave Martin <Dave.Martin@arm.com>
> 
> resctrl specifies the format of the control schemes, and these don't match
> the hardware.
> 
> Some of the conversions are a bit hairy - add some kunit tests.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
> [morse: squashed enough of Dave's fixes in here that it's his patch now!]
> Signed-off-by: James Morse <james.morse@arm.com>
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
I took a fairly quick look at these and they seem sane.
Very valuable to have these tests.

Trivial stuff below and a request to carry the reference over to the
code rather than just having it in the tests.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> diff --git a/drivers/resctrl/test_mpam_resctrl.c b/drivers/resctrl/test_mpam_resctrl.c
> new file mode 100644
> index 000000000000..d0615aa7671c
> --- /dev/null
> +++ b/drivers/resctrl/test_mpam_resctrl.c

> +/*
> + * Mysterious inscriptions taken from ARM DDI 0598D.b,
> + * "Arm Architecture Reference Manual Supplement - Memory System
> + * Resource Partitioning and Monitoring (MPAM), for A-profile
> + * architecture", Section 9.8, "About the fixed-point fractional
> + * format" (exact percentage entries only):

This is the reference I'd like alongside the conversion code.

> + */
> +static const struct percent_value_case percent_value_cases[] = {
> +	/* Architectural cases: */
> +	{   1,  8,    1 },	{   1, 12,  0x27 },	{   1, 16,  0x28e },
> +	{  25,  8, 0x3f },	{  25, 12, 0x3ff },	{  25, 16, 0x3fff },
> +	{  35,  8, 0x58 },	{  35, 12, 0x598 },	{  35, 16, 0x5998 },
> +	{  45,  8, 0x72 },	{  45, 12, 0x732 },	{  45, 16, 0x7332 },
> +	{  50,  8, 0x7f },	{  50, 12, 0x7ff },	{  50, 16, 0x7fff },
> +	{  52,  8, 0x84 },	{  52, 12, 0x850 },	{  52, 16, 0x851d },
> +	{  55,  8, 0x8b },	{  55, 12, 0x8cb },	{  55, 16, 0x8ccb },
> +	{  58,  8, 0x93 },	{  58, 12, 0x946 },	{  58, 16, 0x9479 },
> +	{  75,  8, 0xbf },	{  75, 12, 0xbff },	{  75, 16, 0xbfff },
> +	{  88,  8, 0xe0 },	{  88, 12, 0xe13 },	{  88, 16, 0xe146 },
> +	{  95,  8, 0xf2 },	{  95, 12, 0xf32 },	{  95, 16, 0xf332 },
> +	{ 100,  8, 0xff },	{ 100, 12, 0xfff },	{ 100, 16, 0xffff },
> +
This blank line doesn't add anything.

> +};
> +
> +static void test_percent_value_desc(const struct percent_value_case *param,
> +				    char *desc)
> +{
> +	snprintf(desc, KUNIT_PARAM_DESC_SIZE,
> +		 "pc=%d, width=%d, value=0x%.*x\n",
> +		 param->pc, param->width,
> +		 DIV_ROUND_UP(param->width, 4), param->value);
> +}

