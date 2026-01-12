Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F97E34DCF7
	for <kvmarm@lists.linux.dev>; Mon, 12 Jan 2026 16:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768236365; cv=none; b=qjgL9dBdxBKZJoyYBdYEYteifKzX2kS2aaPsCHL2HCgXB1vWtYvU8LoUadw62NOqMuv1KMBX8n3uuYWwDY9sKw3353oCp1ohqd89xB47tjhOX+Ag0BjpcGtZFM/xULkx67IEOKy+bUo+Rn1klGFbs7unnhuxP8xNATiEuCS28OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768236365; c=relaxed/simple;
	bh=V9n3/b41okkgq5OYMtIUAnW35o5EQjM/7E/5PAAvxyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bLLunKRlQ8XWs++Z2SRiji9QBnAAxSQhCNnD7q3CeIbiA7GvNgVCm4vos/pbKHrdF/m9yzhQoAJJcvRyflQ+fbY8jpiMCgj8YStHZrAym3g3Oia2gfgmpSvst7AM84w78GEA/AVJX0n3OjNIBo12oW4CWBxMUgeM/5VGrJsui5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63C03497;
	Mon, 12 Jan 2026 08:45:49 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 23FB13F59E;
	Mon, 12 Jan 2026 08:45:50 -0800 (PST)
Message-ID: <02781a6f-fc15-4eef-8747-90dc2ba4e20c@arm.com>
Date: Mon, 12 Jan 2026 16:45:49 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 25/45] arm_mpam: resctrl: Add support for 'MB' resource
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
 Zeng Heng <zengheng4@huawei.com>
References: <20251219181147.3404071-1-ben.horgan@arm.com>
 <20251219181147.3404071-26-ben.horgan@arm.com>
 <OSZPR01MB8798E323F3DC4A528C411FB58B85A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <OSZPR01MB8798E323F3DC4A528C411FB58B85A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaopeng,

On 1/8/26 10:42, Shaopeng Tan (Fujitsu) wrote:
> Hello Ben,
> 
>> From: James Morse <james.morse@arm.com>
>>
>> resctrl supports 'MB', as a percentage throttling of traffic somewhere
>> after the L3. This is the control that mba_sc uses, so ideally the class
>> chosen should be as close as possible to the counters used for mba_local.
>>
>> MB's percentage control should be backed either with the fixed point
>> fraction MBW_MAX. The bandwidth portion bitmaps is not used as its tricky
>> to pick which bits to use to avoid contention, and may be possible to
>> expose this as something other than a percentage in the future.
>>
>> CC: Zeng Heng <zengheng4@huawei.com>
>> Co-developed-by: Dave Martin <Dave.Martin@arm.com>
>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>> Signed-off-by: James Morse <james.morse@arm.com>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>>  drivers/resctrl/mpam_resctrl.c | 212 ++++++++++++++++++++++++++++++++-
>>  1 file changed, 211 insertions(+), 1 deletion(-)
>>
[...]
>>  static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,
>>                                       enum resctrl_res_level type)
>>  {
>>          struct mpam_class *class = res->class;
>> +       struct mpam_props *cprops = &class->props;
>>          struct rdt_resource *r = &res->resctrl_res;
>>  
>>          switch (r->rid) {
>> @@ -361,6 +531,20 @@ static int mpam_resctrl_control_init(struct mpam_resctrl_res *res,
>>                   * 'all the bits' is the correct answer here.
>>                   */
>>                  r->cache.shareable_bits = resctrl_get_default_ctrl(r);
>> +               break;
>> +       case RDT_RESOURCE_MBA:
>> +               r->alloc_capable = true;
>> +               r->schema_fmt = RESCTRL_SCHEMA_RANGE;
>> +               r->ctrl_scope = RESCTRL_L3_CACHE;
> 
> Could you please elaborate why RESCTRL_L3_CACHE is required here?

The location of the mba control in resctrl is named using the id of the
l3 cache and so needs to associated with it. James is working on some
documentation that will mention this along with other things.

> 
> Best regards,
> Shaopeng TAN
> 


Thanks,

Ben

