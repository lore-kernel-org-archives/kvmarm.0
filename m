Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB66A36E497
	for <kvmarm@lists.linux.dev>; Wed, 14 Jan 2026 06:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768373537; cv=none; b=cNBEkShJU6VTuxCBLUMdvq+1b10rcHYhn7tldT1ciqGbclTDEHeSfg9ufQwrzwV3YvBCCJQh9+3+S18btiGjBs+yiWQaA1g2fEiH7HMKUOQqF6v+8Bu+LImFtWi8DRbliayNMQFBm/EJQV//WQluD+lUmYDa4F89AfDhs6RunZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768373537; c=relaxed/simple;
	bh=tLNh2wA/PXAzn5iAOzhN43zmPYjTGCcMX1amUvUYELw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dH8vZZ5CVjLsFrydL2200e2aHtt/ob5Yd5lEBOh0QZM0orQtqh/JmfMnGRE0BoB4APp3gDtvnkwVb+Ai+0Jtfs6I57cOwNUA1eDjK3RYBXDierCLtCZawHnLAFEgUY2Cy+TsfFl+e8u4P1DZS/JnZ7T/jsk6K9T7FprBz0tbQeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=cAeCk5aS; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="cAeCk5aS"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=tLNh2wA/PXAzn5iAOzhN43zmPYjTGCcMX1amUvUYELw=;
	b=cAeCk5aSt31IFJZVOgpRVLQd5E4a4/SD9DTZ8Zil5w1wDc9RLEHtPYlgfO5rtdQfw9QVQp4Il
	9T/BCYndRyvQ34KwYERbF8Ca4Zmc0bn7+Vxdqc6MP87Yh3iEMWWQat/juVEltnU6BBYYJ3tWn7h
	vinYn2O43UlvcRKNXbFIk+o=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4drcCW4JrZz12LKT;
	Wed, 14 Jan 2026 14:48:55 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id DA5EC4056B;
	Wed, 14 Jan 2026 14:51:55 +0800 (CST)
Received: from huawei.com (10.50.87.109) by kwepemf100008.china.huawei.com
 (7.202.181.222) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 14 Jan
 2026 14:51:54 +0800
From: Zeng Heng <zengheng4@huawei.com>
To: <ben.horgan@arm.com>, <james.morse@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<catalin.marinas@arm.com>, <corbet@lwn.net>, <dave.martin@arm.com>,
	<david@kernel.org>, <dfustini@baylibre.com>, <fenghuay@nvidia.com>,
	<gshan@redhat.com>, <joey.gouly@arm.com>, <jonathan.cameron@huawei.com>,
	<kobak@nvidia.com>, <kvmarm@lists.linux.dev>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<maz@kernel.org>, <oupton@kernel.org>, <peternewman@google.com>,
	<punit.agrawal@oss.qualcomm.com>, <quic_jiles@quicinc.com>,
	<reinette.chatre@intel.com>, <rohit.mathew@arm.com>,
	<scott@os.amperecomputing.com>, <sdonthineni@nvidia.com>,
	<suzuki.poulose@arm.com>, <tan.shaopeng@fujitsu.com>, <will@kernel.org>,
	<sunnanyong@huawei.com>, <zengheng4@huawei.com>
Subject: Re: [PATCH RESEND v2 0/45] arm_mpam: Add KVM/arm64 and resctrl glue code
Date: Wed, 14 Jan 2026 14:51:49 +0800
Message-ID: <20260114065149.1108631-1-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260112165914.4086692-1-ben.horgan@arm.com>
References: <20260112165914.4086692-1-ben.horgan@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf100008.china.huawei.com (7.202.181.222)

> From: Ben Horgan <ben.horgan@arm.com>
> Date: Fri, 19 Dec 2025 18:11:02 +0000
> Subject: [PATCH v2 00/45] arm_mpam: Add KVM/arm64 and resctrl glue code
>
> One major departure from the previous snapshot branches referenced in the
> base driver series is that the same MPAM setting are used for kernel-space
> and user-space. That is, MPAM1_EL1 is set to the same value as MPAM0_EL1
> rather than keeping the default value. The advantages of this are that it
> is closer to the x86 model where the closid is globally applicable, all
> partids are usable from user-space and user-space can't bypass MPAM
> controls by doing the work in the kernel. However, this causes some
> priority inversion where a high priority task waits to take a mutex held by
> another whose resources are restricted by MPAM. It also adds some extra
> isb(). I would be interested in opinions/data on the policy for MPAM in
> kernel space, i.e how MPAM1_EL1 is set.

Another advantage is that, given the small size of the L2 cache,
frequent switching of MPAM configurations between kernel and user modes
can cause cache-capacity jitter, making it difficult to isolate
interference from noisy neighborhood.

However, in addition to the issues mentioned above, updating the
MPAM1_EL1 configuration also exposes interrupt handling to the MPAM
settings of the current task.

I still agree with the current modification of setting MPAM1_EL1 to the
same value as MPAM0_EL1. However, the ARM MPAM hardware supports more
flexible configuration schemes than x86 RDT and another approach is also
worth considering: Software can let a control group choose whether
kernel mode follows the user mode MPAM settings, or whether the kernel
mode configuration is delegated to the default control group, though
this may change the existing user interface.

At the LPC resctrl micro-conference, Babu also mentioned the PLZA proposal
as an attempt to address the issues raised above. Seems like no clear
interface was presented yet. Wait to see what new interface that solution
will introduce.

One last thing, please add me to the CC list for future MPAM patch series.
I'll provide timely testing on my local aarch64 environment and review
feedback. Thanks.


Best Regards,
Zeng Heng
