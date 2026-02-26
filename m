Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0BA28643A
	for <kvmarm@lists.linux.dev>; Thu, 26 Feb 2026 03:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077636; cv=none; b=skxrczebbbJyCVAud32eqwp41sGEAadno3p01qU02ZoRG3WcF+QC8mcVbN+PePVdpEdwxW2htnj4YT8d9+zHacv5UuXtoA0eAho7NvXn5eNyOU5+xVA1BFyoJUp5Yq0vYkV/M7DGQ4Aug883WoDj8sFITEq4ICA5PDwfQJ1CPwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077636; c=relaxed/simple;
	bh=DgcHV64u/KU+43pcZb7S7+aPM4uc5MTJd8qN6hmqOf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eP79rnR7rUE9Hru6wl0ZtDvjtMZUaCzVTCiRGJSJ2mhY/bmKu+yWkuljw+EYPYm6i01sntBGaN7ldAMlMzFIr7cj70J92CIMRC4P2zx+y6X8GS2o40A1PiMhTVQZWNIlAJkqjMG2F7xcXwv6IKV3XIpQBAogFz/DbY3J65XSf84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=TpNrMO5t; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="TpNrMO5t"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zpOcL0ziINMymFoHRJ16r3+sAg9l6JOyaWH0iH3kEnk=;
	b=TpNrMO5tMamcUYE34ZtOd8fhD7qRlgJcnuAIgdVYuUQbh1gYTmY4S8LgH/VmE1IaScVKfU6+u
	mY/PtGpXKs8FW8TLWAcUfmJN6PHZh4+b5WFtsvz3JARxaB91fKCEX+8e7bn3vieTfNWhHCUazhc
	mArLMgNsx9Id86HUknjWIWE=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fLy2B1J1lz1T4Fh;
	Thu, 26 Feb 2026 11:42:10 +0800 (CST)
Received: from kwepemf100008.china.huawei.com (unknown [7.202.181.222])
	by mail.maildlp.com (Postfix) with ESMTPS id 0E0C0404AD;
	Thu, 26 Feb 2026 11:47:03 +0800 (CST)
Received: from [10.174.179.37] (10.174.179.37) by
 kwepemf100008.china.huawei.com (7.202.181.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 26 Feb 2026 11:47:01 +0800
Message-ID: <d233d198-9c68-b32e-4a0f-73a9314bdedd@huawei.com>
Date: Thu, 26 Feb 2026 11:47:00 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 26/41] arm_mpam: resctrl: Add monitor initialisation
 and domain boilerplate
Content-Language: en-US
To: Ben Horgan <ben.horgan@arm.com>
CC: <amitsinght@marvell.com>, <baisheng.gao@unisoc.com>,
	<baolin.wang@linux.alibaba.com>, <carl@os.amperecomputing.com>,
	<dave.martin@arm.com>, <david@kernel.org>, <dfustini@baylibre.com>,
	<fenghuay@nvidia.com>, <gshan@redhat.com>, <james.morse@arm.com>,
	<jonathan.cameron@huawei.com>, <kobak@nvidia.com>, <lcherian@marvell.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<peternewman@google.com>, <punit.agrawal@oss.qualcomm.com>,
	<quic_jiles@quicinc.com>, <reinette.chatre@intel.com>,
	<rohit.mathew@arm.com>, <scott@os.amperecomputing.com>,
	<sdonthineni@nvidia.com>, <tan.shaopeng@fujitsu.com>,
	<xhao@linux.alibaba.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <maz@kernel.org>, <oupton@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <kvmarm@lists.linux.dev>,
	<linux-doc@vger.kernel.org>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-27-ben.horgan@arm.com>
From: Zeng Heng <zengheng4@huawei.com>
In-Reply-To: <20260224175720.2663924-27-ben.horgan@arm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf100008.china.huawei.com (7.202.181.222)

Hi Ben,

On 2026/2/25 1:57, Ben Horgan wrote:
> Add the boilerplate that tells resctrl about the mpam monitors that are
> available. resctrl expects all (non-telemetry) monitors to be on the L3 and
> so advertise them there and invent an L3 resctrl resource if required. The
> L3 cache itself has to exist as the cache ids are used as the domain
> ids.
> 
> Bring the resctrl monitor domains online and offline based on the cpus
> they contain.
> 
> Support for specific monitor types is left to later.
> 
> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
> ---
> New patch but mostly moved from the existing patches to
> separate the monitors from the controls and the boilerplate
> from the specific counters.
> Use l3->mon_capable in resctrl_arch_mon_capable() as
> resctrl_enable_mon_event() now returns a bool.
> ---
>   drivers/resctrl/mpam_internal.h |   7 ++
>   drivers/resctrl/mpam_resctrl.c  | 142 +++++++++++++++++++++++++++++---
>   2 files changed, 139 insertions(+), 10 deletions(-)
> 

[...]

> @@ -922,6 +1000,20 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
>   	} else {
>   		pr_debug("Skipped control domain online - no controls\n");
>   	}
> +
> +	if (resctrl_arch_mon_capable()) {
> +		mon_d = &dom->resctrl_mon_dom;
> +		mpam_resctrl_domain_hdr_init(cpu, any_mon_comp, r->rid, &mon_d->hdr);
> +		mon_d->hdr.type = RESCTRL_MON_DOMAIN;
> +		err = resctrl_online_mon_domain(r, &mon_d->hdr);
> +		if (err)
> +			goto offline_ctrl_domain;
> +
> +		mpam_resctrl_domain_insert(&r->mon_domains, &mon_d->hdr);
> +	} else {
> +		pr_debug("Skipped monitor domain online - no monitors\n");
> +	}
> +
>   	return dom;
>   

I noticed that resctrl_arch_mon_capable() only performs checks for L3
monitoring functionality. This leads to an issue on platforms that
include L2 monitoring capabilities, where the code incorrectly enters
this branch and triggers the following warning by
mpam_resctrl_domain_insert():

[   22.867070] ------------[ cut here ]------------
[   22.867073] WARNING: drivers/resctrl/mpam_resctrl.c:1495 at 
mpam_resctrl_domain_insert+0x74/0x80, CPU#2: cpuhp/2/25
[   29.376035] Modules linked in:
[   29.379080] CPU: 2 UID: 0 PID: 25 Comm: cpuhp/2 Not tainted 
7.0.0-rc1-g4288ec146462 #30 PREEMPT
[   29.387853] Hardware name: To Be Filled By O.E.M. 183.0/To Be Filled 
By O.E.M., BIOS 183.0 02/12/2026
[   29.397058] pstate: 61400009 (nZCv daif +PAN -UAO -TCO +DIT -SSBS 
BTYPE=--)
[   29.404007] pc : mpam_resctrl_domain_insert+0x74/0x80
[   29.409048] lr : mpam_resctrl_domain_insert+0x34/0x80
[   29.414088] sp : ffff8000876abc60
  ...
[   29.488625] Call trace:
[   29.491060]  mpam_resctrl_domain_insert+0x74/0x80 (P)
[   29.496100]  mpam_resctrl_online_cpu+0x2b4/0x428
[   29.500706]  mpam_cpu_online+0x274/0x298
[   29.504618]  cpuhp_invoke_callback+0x104/0x20c
[   29.509052]  cpuhp_thread_fun+0xa4/0x17c
[   29.512963]  smpboot_thread_fn+0x220/0x24c
[   29.517048]  kthread+0x120/0x12c
[   29.520265]  ret_from_fork+0x10/0x20
[   29.523830] ---[ end trace 0000000000000000 ]---


To preserve the existing public interface of resctrl_arch_mon_capable(),
please consider the following approach:

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 694ea8548a05..b06a89494ff0 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1563,6 +1563,10 @@ mpam_resctrl_alloc_domain(unsigned int cpu, 
struct mpam_resctrl_res *res)
         if (resctrl_arch_mon_capable()) {
                 struct mpam_component *any_mon_comp;
                 struct mpam_resctrl_mon *mon;
                 enum resctrl_event_id eventid;

+               /* TODO: Only supports L3 monitor type currently. */
+               if (r->rid != RDT_RESOURCE_L3)
+                       return dom;



Best regards,
Zeng Heng
