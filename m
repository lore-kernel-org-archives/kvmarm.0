Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DD535CBB0
	for <kvmarm@lists.linux.dev>; Thu,  8 Jan 2026 10:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767869550; cv=none; b=RgzcAph3RsbUgKerj9MeEGamwPMl93Hc7ZmRCcA5lZcM/3pAhIF0W2f+mYL/0yohTkTj0GZOXcn8lw1mCZLl0uJAFd9+b80DBHPlhdLa2p+UIJAfxjydQHmv/cGqZF9DFLfV7mNAOCa8PjIlp30A5SyphawLxRLhrK0SscJJXpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767869550; c=relaxed/simple;
	bh=CEX+vCwuDDkooxC5ARTwk1yRfhNVbvlrHD+dxMr0BlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rjOYztnZJjOxkbYz9hNzpK0KRrwiWySVergpvJP2NwWO3Q9ojsW+x8dmcBPPONG3o5AVk2kE1du4ThC5TSIbBbfoj0+Q40WJ0c/NI2vUlPdRG6EPsKafiMJRY0hb5DtOfHL9Ud490QFSwYgsNKvrwvJUSkM4Jp4IOIHpw0THYVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA494497;
	Thu,  8 Jan 2026 02:52:02 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A27633F6A8;
	Thu,  8 Jan 2026 02:52:02 -0800 (PST)
Message-ID: <adcc278e-6be6-4658-821a-eb8995d65512@arm.com>
Date: Thu, 8 Jan 2026 10:52:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 27/45] arm_mpam: resctrl: Add support for csu counters
To: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>
Cc: "amitsinght@marvell.com" <amitsinght@marvell.com>,
 "baisheng.gao@unisoc.com" <baisheng.gao@unisoc.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "carl@os.amperecomputing.com" <carl@os.amperecomputing.com>,
 "dave.martin@arm.com" <dave.martin@arm.com>,
 "david@kernel.org" <david@kernel.org>,
 "dfustini@baylibre.com" <dfustini@baylibre.com>,
 "fenghuay@nvidia.com" <fenghuay@nvidia.com>,
 "gshan@redhat.com" <gshan@redhat.com>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
 "kobak@nvidia.com" <kobak@nvidia.com>,
 "lcherian@marvell.com" <lcherian@marvell.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "punit.agrawal@oss.qualcomm.com" <punit.agrawal@oss.qualcomm.com>,
 "quic_jiles@quicinc.com" <quic_jiles@quicinc.com>,
 "reinette.chatre@intel.com" <reinette.chatre@intel.com>,
 "rohit.mathew@arm.com" <rohit.mathew@arm.com>,
 "scott@os.amperecomputing.com" <scott@os.amperecomputing.com>,
 "sdonthineni@nvidia.com" <sdonthineni@nvidia.com>,
 "xhao@linux.alibaba.com" <xhao@linux.alibaba.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
 "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-28-ben.horgan@arm.com>
 <OSZPR01MB87980DA8A2534414337384608B85A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <OSZPR01MB87980DA8A2534414337384608B85A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Shaopeng,

On 1/8/26 10:44, Shaopeng Tan (Fujitsu) wrote:
> Hello Ben,
> 
>> From: James Morse <james.morse@arm.com>
>>
>> resctrl exposes a counter via a file named llc_occupancy. This isn't really
>> a counter as its value goes up and down, this is a snapshot of the cache
>> storage usage monitor.
>>
>> Add some picking code to find a cache as close as possible to the L3 that
>> supports the CSU monitor.
>>
>> If there is an L3, but it doesn't have any controls, force the L3 resource
>> to exist. The existing topology_matches_l3() and
>> mpam_resctrl_domain_hdr_init() code will ensure this looks like the L3,
>> even if the class belongs to a later cache.
>>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since rfc:
>> Allow csu counters however many partid or pmg there are
>> else if -> if
>> reduce scope of local variables
>> drop has_csu
>> ---
>>  drivers/resctrl/mpam_internal.h |   6 ++
>>  drivers/resctrl/mpam_resctrl.c  | 148 ++++++++++++++++++++++++++++++++
>>  2 files changed, 154 insertions(+)
[...]
>> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
>> index f8d8c241797a..5fde610cc9d7 100644
>> --- a/drivers/resctrl/mpam_resctrl.c
>> +++ b/drivers/resctrl/mpam_resctrl.c
[...]
>>  
>> +static void mpam_resctrl_monitor_init(struct mpam_resctrl_mon *mon,
>> +                                     enum resctrl_event_id type)
>> +{
>> +       struct mpam_resctrl_res *res = &mpam_resctrl_controls[RDT_RESOURCE_L3];
>> +       struct rdt_resource *l3 = &res->resctrl_res;
>> +
>> +       lockdep_assert_cpus_held();
>> +
>> +       /* There also needs to be an L3 cache present */
>> +       if (get_cpu_cacheinfo_id(smp_processor_id(), 3) == -1)
>> +               return;
>> +
>> +       /*
>> +        * If there are no MPAM resources on L3, force it into existence.
>> +        * topology_matches_l3() already ensures this looks like the L3.
>> +        * The domain-ids will be fixed up by mpam_resctrl_domain_hdr_init().
>> +        */
>> +       if (!res->class) {
>> +               pr_warn_once("Faking L3 MSC to enable counters.\n");
>> +               res->class = mpam_resctrl_counters[type].class;
>> +       }
>> +
>> +       /* Called multiple times!, once per event type */
>> +       if (exposed_mon_capable) {
>> +               l3->mon_capable = true;
>> +
>> +               /* Setting name is necessary on monitor only platforms */
>> +               l3->name = "L3";
>> +               l3->mon_scope = RESCTRL_L3_CACHE;
>> +
>> +               resctrl_enable_mon_event(type);
>> +
>> +               /*
>> +                * Unfortunately, num_rmid doesn't mean anything for
>> +                * mpam, and its exposed to user-space!
>> +                * num-rmid is supposed to mean the number of groups
>> +                * that can be created, both control or monitor groups.
>> +                * For mpam, each control group has its own pmg/rmid
>> +                * space.
>> +                */
>> +               l3->mon.num_rmid = 1;
>> +       }
>> +}
> 
> Dave posted the following patch, Will you apply it?
> https://lore.kernel.org/lkml/20250820131621.54983-1-Dave.Martin@arm.com/

Thanks for the reminder. I'll squash that into this patch.

> 
> Best regards,
> Shaopeng TAN
> 
> 

Thanks,

Ben

