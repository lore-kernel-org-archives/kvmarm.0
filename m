Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97EE4305E19
	for <kvmarm@lists.linux.dev>; Wed, 18 Feb 2026 16:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771432949; cv=none; b=gConLxIWUZj0D2/qW2c0qXRQ67lLC2DDMq7PZEgUkamBA5vjlrI5QAwct7d9WVa2RjpfdJ9OUk3Ax5NN/SkIHP3IfvMUi06PoRYqJm0zKPI65AsdjNshiDIToRw8sIQ04MoppWjuF/OJyFb/SrULFWSGEPrsy0wbYvYG0vqvRxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771432949; c=relaxed/simple;
	bh=QFJ80ZejVD3OJcw4POFeYv5atW2IP+NwxY2WLHTmoj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cNCGX0g3+tlvhqlhtdof8TMToNVjQoR7hZRGEbt+6gixfilmTVr5EfWaRJZzrPT82e0Hrt1ZoaXc9LvgMfWeiobUhuofQIUUCeBEAN/fFhGDtwn4kV13LpFzle2sPrSYVA08IncBae1B9TVuKkgacvTxpx8AUU+Cv5BVwV17bP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 961A3339;
	Wed, 18 Feb 2026 08:42:19 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C15FF3F62B;
	Wed, 18 Feb 2026 08:42:20 -0800 (PST)
Message-ID: <b761ec67-5ba8-480e-965e-b163f9056da2@arm.com>
Date: Wed, 18 Feb 2026 16:42:19 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 26/41] arm_mpam: resctrl: Add support for 'MB' resource
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
 <20260203214342.584712-27-ben.horgan@arm.com>
 <OSZPR01MB8798A3301B1E802173FF551E8B62A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <OSZPR01MB8798A3301B1E802173FF551E8B62A@OSZPR01MB8798.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Shaopeng,

On 2/10/26 06:20, Shaopeng Tan (Fujitsu) wrote:
> Hello Ben,
> 
>> From: James Morse <james.morse@arm.com>
>>
>> resctrl supports 'MB', as a percentage throttling of traffic from the
>> L3. This is the control that mba_sc uses, so ideally the class chosen
>> should be as close as possible to the counters used for mbm_total. If
>> there is a single L3 and the topology of the memory matches then the
>> traffic at the memory controller will be equivalent to that at egress of
>> the L3. If these conditions are met allow the memory class to back MB.
>>
>> MB's percentage control should be backed either with the fixed point
>> fraction MBW_MAX or bandwidth portion bitmaps. The bandwidth portion
>> bitmaps is not used as its tricky to pick which bits to use to avoid
>> contention, and may be possible to expose this as something other than a
>> percentage in the future.
>>
>> CC: Zeng Heng <zengheng4@huawei.com>
>> Co-developed-by: Dave Martin <Dave.Martin@arm.com>
>> Signed-off-by: Dave Martin <Dave.Martin@arm.com>
>> Signed-off-by: James Morse <james.morse@arm.com>>
>> Signed-off-by: Ben Horgan <ben.horgan@arm.com>
>> ---
>> Changes since v2:
>> Code flow change
>> Commit message 'or'
>>
>> Changes since v3:
>> initialise tmp_cpumask
>> update commit message
>> check the traffic matches l3
>> update comment on candidate_class update, only mbm_total
>> drop tags due to rework
>> ---

>> +/*
>> + * Test if the traffic for a class matches that at egress from the L3. For
>> + * MSC at memory controllers this is only possible if there is a single L3
>> + * as otherwise the counters at the memory can include bandwidth from the
>> + * non-local L3.
>> + */
>> +static bool traffic_matches_l3(struct mpam_class *class) {
> 
> An error reported by checkpatch.pl is as follows.
> 
> ERROR: open brace '{' following function definitions go on the next line
> #826: FILE: drivers/resctrl/mpam_resctrl.c:826:
> +static bool traffic_matches_l3(struct mpam_class *class) {

Not sure how I let that slip through. Fixed now.

> 
> 
> Best regards,
> Shaopeng TAN
Thanks,

Ben

