Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D84C30C35F
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 16:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767631442; cv=none; b=MVs8MoVTC+4L4rXXhqnwftG0iVdcB/dfhHGu5jHH+FyWI7op/+gOubp7HQqakNzst1vWiFqJwD+P4p/qKpDMn5kZa3fzU0WIepQ2bAnbQqvffiDAJ/zbKiHOuKjIZ/+OCBE8tveHTndUfvSLVegS9hzIYcSgH7KLH0d9FjARyFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767631442; c=relaxed/simple;
	bh=5wvBUuUMJ1rvgRQBArsVsAzHb1Q/NkrYlzjfQ9EbY5Y=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WFrXhsXfiakqOvM1EOlxwQLd9zzyjpwerAm5BoJOXaAdZBDP5BsGX6eJc8xaIawnDp3MnfFDHhUnv8rzLKhW0akDgfbjEU2MjPv0ktbUnaMGy0XpL9lkxZQnF3t6N4HJpIDSQTCOaPzwsna2sPsLf1rV41cp9mjwy9I9ESaJ9ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dlKq35SSczJ46DD;
	Tue,  6 Jan 2026 00:42:55 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 61DA240086;
	Tue,  6 Jan 2026 00:43:56 +0800 (CST)
Received: from localhost (10.126.174.38) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Mon, 5 Jan
 2026 16:43:54 +0000
Date: Mon, 5 Jan 2026 16:43:52 +0000
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
Subject: Re: [PATCH v2 05/45] KVM: arm64: Preserve host MPAM configuration
 when changing traps
Message-ID: <20260105164352.00001e3c@huawei.com>
In-Reply-To: <20251219181147.3404071-6-ben.horgan@arm.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
	<20251219181147.3404071-6-ben.horgan@arm.com>
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

On Fri, 19 Dec 2025 18:11:07 +0000
Ben Horgan <ben.horgan@arm.com> wrote:

> When kvm enables or disables MPAM traps to EL2 it clears all other bits in
> MPAM2_EL2.  Notably, it clears the partition ids (PARTIDs) and performance
> monitoring groups (PMGs). Avoid changing these bits in anticipation of
> adding support for MPAM in the kernel. Otherwise, on a VHE system with the
> host running at EL2 where MPAM2_EL2 and MPAM1_EL1 access the same register,
> any attempt to use MPAM to monitor or partition resources for kernel space
> would be foiled by running a KVM guest. Additionally, MPAM2_EL2.EnMPAMSM is
> always set to 0 which causes MPAMSM_EL1 to always trap. Keep EnMPAMSM set
> to 1 when not in a guest so that the kernel can use MPAMSM_EL1.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Seems to match what I'd expect from the spec, so LGTM.
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
