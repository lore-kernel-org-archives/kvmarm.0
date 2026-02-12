Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062E93382F7
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 14:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770907915; cv=none; b=QX3JZqBvmA6LvAbihIn7JWeJQvlqZgLYH0pVTKTS/jJ/Srz0rMK9SnEnhgAg1AxxrWtz/MwJ+OTCJ/oTii21uq4Fnsj0NdVpH/IYMwE7vDiHbsFhjsnwimWOlSJ6CffuQa76TZzpUczlfiyYrC++ANxS02Y/1hpZvnn3A96Z5+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770907915; c=relaxed/simple;
	bh=QvzRlTURbKV/PMDuxEaFKXVCxoUomuiSOFAYKRMnIrs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gUQKCRdhKnOXcjlSblbJS0WOJZaDRPCI41u27spW6Uz9drzn1tIIFAK2tXjk18SknkKSlB1AnenO2TXstsPMfR1Sr6VtPzK/C+AIOzY9waNLiRp2QXY7pxot+9HEiuQQQqjDRBL+3/ThdGl85fmnsvZ9JJOvV78nlZxYjI1c6aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A72B0339;
	Thu, 12 Feb 2026 06:51:45 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD4DE3F63F;
	Thu, 12 Feb 2026 06:51:46 -0800 (PST)
Message-ID: <962e8fc7-aec9-48bd-aa75-d33f3b068e2a@arm.com>
Date: Thu, 12 Feb 2026 14:51:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/41] arm_mpam: Add KVM/arm64 and resctrl glue code
From: Ben Horgan <ben.horgan@arm.com>
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
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "zengheng4@huawei.com" <zengheng4@huawei.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <20260203214342.584712-1-ben.horgan@arm.com>
 <OSZPR01MB87983A126E58D3FE8A73A98F8B65A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
 <9a8a163e-887a-45fc-aae5-45e564360c8b@arm.com>
Content-Language: en-US
In-Reply-To: <9a8a163e-887a-45fc-aae5-45e564360c8b@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaopeng,

On 2/9/26 10:04, Ben Horgan wrote:
> Hi Shaopeng,
> 
> On 2/9/26 08:25, Shaopeng Tan (Fujitsu) wrote:
>> Hello Ben,
>>
>>> This new version of the mpam missing pieces series has a few significant
>>> changes in the mpam driver part of the series. The heuristics for deciding
>>> if features should be exposed are tightened. This is to fix some
>>> inaccuracies and avoid overcommitting before needed - shout if this changes
>>> anything on your platform. The final patch adds documentation which
>>> explains which features you should expect. The ABMC emulation is dropped
>>> for the moment as it requires resctrl changes to support for MPAM without
>>> breaking the abi. The default 5% gap for min_bw is dropped in favour of a
>>> simple default (kept for grace). The series is based on x86/resctrl [1] as
>>> resctrl has telemetry patches queued which change the arch interface.
>>
>> Could you please elaborate on why fs/resctrl changes are required to support only the counter assignment part of ABMC?
>> Currently, many SoC chips have an insufficient number of memory bandwidth monitors.
> 
> Sure. When the counter assignment mode is 'mbm_event; resctrl assumes the mbm events are configurable. 
> The 'event_filter' files at
>     info/L3_MON/event_configs/<event>/event_filter 
> are used to display and set this configuration.
> 
> In MPAM event configuration is not supported and so showing a read/writable 'event_filter' file is 
> misleading to the user and needs to be hidden for MPAM support.
> 
> Just to give you a flavour of the change, here's a hack to show the correct thing for MPAM:
> 
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -2338,6 +2338,9 @@ static int resctrl_mkdir_event_configs(struct rdt_resource *r, struct kernfs_nod
>                 if (ret)
>                         goto out;
>  
> +               if (!resctrl_arch_is_evt_configurable(mevt->evtid))
> +                       continue;
> +
> 
> 
>> We would be grateful if you could support the counter assignment part of ABMC.
> 
> It is not a big change in resctrl but I thought it best to not gate the rest of this series on
> an additional change in another subsystem. I am current looking into this and hope to get the 
> patches on the list early in the next cycle.

There is another small change that will be required in resctrl to
support ABMC with MPAM. As counter assignment means that it can't be
guaranteed that each CTRL_MON group has a dedicated memory bandwidth
counter the software controller (mbaMBps mount option) won't work but
the mount won't fail. AMD doesn't hit this problem as it's MBA is
non-linear. I was hoping to repurpose the delay_linear flag to just mean
the software controller isn't supported but resctrl displays this
information to the user in the 'delay_linear' file and we don't want to
mislead.

> 
>>
>> Best regards,
>> Shaopeng TAN
>>
>>
> Thanks,
> 
> Ben
> 
> 


Thanks,

Ben

