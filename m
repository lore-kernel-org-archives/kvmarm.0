Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A373D1CAC
	for <kvmarm@lists.linux.dev>; Mon,  9 Mar 2026 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073818; cv=none; b=bJaVtYdTR9zkbOq2Oj/YLGXxUJN3DXy/1CPCX43rhOM6+k9Xa7MpgXOBEndSFNUR4tTot34t5JCvMTMZeiZ6N+qCyBQA9y8vnOk0QzYA4oELElEV+bvkox2Yky3laIeVBLmO8AzEz8bb3B+baIIcVzDIcfiumVVvKIQX3bgi4fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073818; c=relaxed/simple;
	bh=c73/rd98H48SI3tKu0F5b6+OqHhKEttcj0DvMlxkoFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mxmdvWUcZffE8HDu0IArxjM/G9wLwUmVAlUezVgG6UFYSBUMCvaY67x1rkZE76tsjkSI/3LBPnIGkN3M8hD8oScMtG22o9xZ4LwCQipLqV6dtoTC3xenmiWH/FDZLs2BSg+6hKnKcIh4MZ/sG8lKbyoNLDv7AYNCedX2i6b/pUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D250D1570;
	Mon,  9 Mar 2026 09:30:08 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5744C3F7BD;
	Mon,  9 Mar 2026 09:30:10 -0700 (PDT)
Message-ID: <b95077d7-c036-4a8f-8e42-8f1dc0288075@arm.com>
Date: Mon, 9 Mar 2026 16:30:08 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v5 31/41] arm_mpam: resctrl: Add resctrl_arch_rmid_read()
 and resctrl_arch_reset_rmid()
To: Zeng Heng <zengheng4@huawei.com>, James Morse <james.morse@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, gshan@redhat.com, jonathan.cameron@huawei.com,
 kobak@nvidia.com, lcherian@marvell.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 peternewman@google.com, punit.agrawal@oss.qualcomm.com,
 quic_jiles@quicinc.com, reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 linux-doc@vger.kernel.org, Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
References: <20260224175720.2663924-1-ben.horgan@arm.com>
 <20260224175720.2663924-32-ben.horgan@arm.com>
 <96ffc81d-3f37-7f48-f9f4-6a58da3e0f99@huawei.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <96ffc81d-3f37-7f48-f9f4-6a58da3e0f99@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Zeng,

On 3/7/26 09:29, Zeng Heng wrote:
> Hi Ben,
> 
> On 2026/2/25 1:57, Ben Horgan wrote:
>> From: James Morse <james.morse@arm.com>
>>
>> resctrl uses resctrl_arch_rmid_read() to read counters. CDP emulation
>> means
>> the counter may need reading in three different ways. The same goes for
>> reset.
>>
>> The helpers behind the resctrl_arch_ functions will be re-used for the
>> ABMC
>> equivalent functions.
>>
>> Add the rounding helper for checking monitor values while we're here.
>>
>> Tested-by: Gavin Shan <gshan@redhat.com>
>> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>> Tested-by: Peter Newman <peternewman@google.com>
>> Tested-by: Zeng Heng <zengheng4@huawei.com>
>> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
>> Signed-off-by: James Morse <james.morse@arm.com>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
> 
> [...]
> 
>> +
>> +static int read_mon_cdp_safe(struct mpam_resctrl_mon *mon, struct
>> mpam_component *mon_comp,
>> +                 enum mpam_device_features mon_type,
>> +                 int mon_idx, u32 closid, u32 rmid, u64 *val)
>> +{
>> +    if (cdp_enabled) {
> 
> While reviewing the resctrl limbo handling code, I noticed a issue in
> __check_limbo() that could lead to premature RMID release when CDP is
> enabled.
> 
> In __check_limbo(), RMIDs in limbo state undergo L3 occupancy checks
> before being released. This check is performed via
> resctrl_arch_rmid_read(), on arm64 MPAM, which relies on the cdp_enabled
> state to determine to check which PARTID.
> 
> The concern arises in the following scenario: Filesystem is mounted with
> CDP enabled. During normal operation, some RMIDs enter limbo. On umount,
> cdp_enabled is reset to false. __check_limbo() may then run and perform
> L3 checks with cdp_enabled = false. This could cause RMIDs to be
> incorrectly released from limbo while still effectively busy after
> remount.

I think a stale limbo list cause more problems than that. If you mount
with cdp disabled, cause some rmids to be dirty, unmount and then
remount with cdp enabled then you may have some of the entries in upper
half marked as busy but when the limbo code checks them it ends up using
an out of range partid and may trigger an mpam error interrupt.

To avoid a stale list we could disable the limbo checking at unmount and
at remount remake the bitmap. This would involve some resctrl changes
which I will have a further look into. For now, to avoid the dependency
without a lot of patch churn in this series I think we can hide the cdp
enablement behind CONFIG_EXPERT. Does that sound ok to you?

Thanks,

Ben

> 
> Apologies for not providing a ready-made fix in this email. However,
> I would appreciate to hear the community's thoughts on this issue.
> 
> 
>> +        u64 code_val = 0, data_val = 0;
>> +        int err;
>> +
>> +        err = __read_mon(mon, mon_comp, mon_type, mon_idx,
>> +                 CDP_CODE, closid, rmid, &code_val);
>> +        if (err)
>> +            return err;
>> +
>> +        err = __read_mon(mon, mon_comp, mon_type, mon_idx,
>> +                 CDP_DATA, closid, rmid, &data_val);
>> +        if (err)
>> +            return err;
>> +
>> +        *val += code_val + data_val;
>> +        return 0;
>> +    }
>> +
>> +    return __read_mon(mon, mon_comp, mon_type, mon_idx,
>> +              CDP_NONE, closid, rmid, val);
>> +}
>> +
>> +/* MBWU when not in ABMC mode, and CSU counters. */
>> +int resctrl_arch_rmid_read(struct rdt_resource *r, struct
>> rdt_domain_hdr *hdr,
>> +               u32 closid, u32 rmid, enum resctrl_event_id eventid,
>> +               void *arch_priv, u64 *val, void *arch_mon_ctx)
>> +{
>> +    struct mpam_resctrl_dom *l3_dom;
>> +    struct mpam_component *mon_comp;
>> +    u32 mon_idx = *(u32 *)arch_mon_ctx;
>> +    enum mpam_device_features mon_type;
>> +    struct mpam_resctrl_mon *mon = &mpam_resctrl_counters[eventid];
>> +
>> +    resctrl_arch_rmid_read_context_check();
>> +
>> +    if (eventid >= QOS_NUM_EVENTS || !mon->class)
>> +        return -EINVAL;
>> +
>> +    l3_dom = container_of(hdr, struct mpam_resctrl_dom,
>> resctrl_mon_dom.hdr);
>> +    mon_comp = l3_dom->mon_comp[eventid];
>> +
>> +    switch (eventid) {
>> +    case QOS_L3_OCCUP_EVENT_ID:
>> +        mon_type = mpam_feat_msmon_csu;
>> +        break;
>> +    case QOS_L3_MBM_LOCAL_EVENT_ID:
>> +    case QOS_L3_MBM_TOTAL_EVENT_ID:
>> +        mon_type = mpam_feat_msmon_mbwu;
>> +        break;
>> +    default:
>> +        return -EINVAL;
>> +    }
>> +
>> +    return read_mon_cdp_safe(mon, mon_comp, mon_type, mon_idx,
>> +                 closid, rmid, val);
>> +}
>> +
> 
> 
> Best regards,
> Zeng Heng

