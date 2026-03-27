Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A36335966
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 15:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774626434; cv=none; b=CqdRO8Gf4BWdjSFe4L+KJ3exV0SW8bdWs8mMWnaGuWNhjEYpoZMvxixS3pHrEb0PeKoLl+B6BoQS/VNx8n+aFBQvWpZ9sGIyIlnN0yk1xARbQpgq1RSywMJxoZMIMON8hSaDKnCOw1wVDnMc6js7DzAN2O7NckJ1/hLfBQ4PhmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774626434; c=relaxed/simple;
	bh=FwlH74TR5RapPRWbQ8EZJzyzw7m7rDT/kv8QOqeRWLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4A7VS6VmLh571hSrqXsQ3mi7WE4Tt8K9o8qi2yWt4EcKrUNhOk5+fDKV/n1QdUtCrd1uX3Y5bKwunt9vmGXSbHultca89URgep3nDwMvknSeMLuGQ47yfZHw+8gQI7DOkulV4b9CC2ZOqR0jPpXpFU0IbzUnEEOs2PMshkNImY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Pn20w3r6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Pn20w3r6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6C9D35E4;
	Fri, 27 Mar 2026 08:47:06 -0700 (PDT)
Received: from [10.1.196.96] (eglon.cambridge.arm.com [10.1.196.96])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD5713FBF8;
	Fri, 27 Mar 2026 08:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774626432; bh=FwlH74TR5RapPRWbQ8EZJzyzw7m7rDT/kv8QOqeRWLk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Pn20w3r64JfebMfmtSSXpMWLvZj0MW+93FnR/sIQAHXY3Yh+woGkOkAEN7/vouEe8
	 rMQt2APDwyIa+dvsmtRvzT2LBNxcN/Hp+0fUyqh8m4c5rC16B34QqkzETJw1qYEnxz
	 ns9SzT3OlvGzT4iOmXuuQP6ir2beZrTs4/b/DXvQ=
Message-ID: <85c10fab-9b4e-4a57-9b4e-42adcd069a5e@arm.com>
Date: Fri, 27 Mar 2026 15:47:02 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 22/40] arm_mpam: resctrl: Convert to/from MPAMs
 fixed-point formats
To: Gavin Shan <gshan@redhat.com>, Ben Horgan <ben.horgan@arm.com>
Cc: amitsinght@marvell.com, baisheng.gao@unisoc.com,
 baolin.wang@linux.alibaba.com, carl@os.amperecomputing.com,
 dave.martin@arm.com, david@kernel.org, dfustini@baylibre.com,
 fenghuay@nvidia.com, jonathan.cameron@huawei.com, kobak@nvidia.com,
 lcherian@marvell.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, peternewman@google.com,
 punit.agrawal@oss.qualcomm.com, quic_jiles@quicinc.com,
 reinette.chatre@intel.com, rohit.mathew@arm.com,
 scott@os.amperecomputing.com, sdonthineni@nvidia.com,
 tan.shaopeng@fujitsu.com, xhao@linux.alibaba.com, catalin.marinas@arm.com,
 will@kernel.org, corbet@lwn.net, maz@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev,
 zengheng4@huawei.com, linux-doc@vger.kernel.org,
 Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <20260313144617.3420416-23-ben.horgan@arm.com>
 <bd450f1f-05a3-44d6-9bbc-1c48d967baa4@redhat.com>
Content-Language: en-GB
From: James Morse <james.morse@arm.com>
In-Reply-To: <bd450f1f-05a3-44d6-9bbc-1c48d967baa4@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 23/03/2026 22:49, Gavin Shan wrote:
> On 3/14/26 12:45 AM, Ben Horgan wrote:
>> From: Dave Martin <Dave.Martin@arm.com>
>>
>> MPAM uses a fixed-point formats for some hardware controls.  Resctrl
>> provides the bandwidth controls as a percentage. Add helpers to convert
>> between these.
>>
>> Ensure bwa_wd is at most 16 to make it clear higher values have no meaning.

> One nitpick below, but this looks good to me in either way.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>

Thanks!


>> diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
>> index 0e5e24ef60fe..0c97f7708722 100644
>> --- a/drivers/resctrl/mpam_devices.c
>> +++ b/drivers/resctrl/mpam_devices.c
>> @@ -713,6 +713,13 @@ static void mpam_ris_hw_probe(struct mpam_msc_ris *ris)
>>               mpam_set_feature(mpam_feat_mbw_part, props);
>>             props->bwa_wd = FIELD_GET(MPAMF_MBW_IDR_BWA_WD, mbw_features);
>> +
>> +        /*
>> +         * The BWA_WD field can represent 0-63, but the control fields it
>> +         * describes have a maximum of 16 bits.
>> +         */
>> +        props->bwa_wd = min(props->bwa_wd, 16);
>> +
> 
> 16 may deserve a definition for it since it's a constant value and referred
> for multiple times in this patch, if we need to give this series another
> respin :-)

Hmmm.,. I've left this, I'm not sure what you'd call it. U16_BITS? That sort of thing
might be needed for long/int etc. Here there is either a comment, or its
accepting/returning a u16. I think its fairly obvious where the number 16 is coming from.



Thanks,

James
