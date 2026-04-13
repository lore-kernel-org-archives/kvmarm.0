Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05393DEFE4
	for <kvmarm@lists.linux.dev>; Mon, 13 Apr 2026 14:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776090772; cv=none; b=IqpaztUuIc3a1z399PUZHz6sEY/W/681MXe5eyopDOR6kXWXfEFyDodXBI9CLK0L124u1L6EC9pOywcLWXLoTfuGKQ3PY6KG9Ebq8VvNaMMYU/Z6ZpfBiPYrWl67USUSPh682KijbPO2L/kkXB2DTUILbLtXoc6QhfHAYCo6XOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776090772; c=relaxed/simple;
	bh=7esCCBp/1znd/3tqEVLoiCm1WeU7CehMh8AEaX3CYEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=meCEdf2v/oCWNQcThMsyYsZXgmHugI2oVRIgnVIdsn+2qyjywTZAp3Gh/1cISZMy3ho7rkFsbMNj9nAjhMXSPhNoQzdXaSWHxJqa7KA8GFGWXfQ4B425BVR0BpyAhTlC+dfkQEFSIByKveFBEUAM/XIP8yO98fPf/0u7CR7tuyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k4BtU/Q0; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k4BtU/Q0"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7979E357A;
	Mon, 13 Apr 2026 07:32:44 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CAAE3F641;
	Mon, 13 Apr 2026 07:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776090770; bh=7esCCBp/1znd/3tqEVLoiCm1WeU7CehMh8AEaX3CYEE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k4BtU/Q0snstkGHJl172mBwQTR3q9jPRBVpFiOeH7UiXZtvFzMev4irKp6FbXlovt
	 SqakMn2ZGK4kZYlg8xh/oQNnOtCy6HKHw49B32HzQE9VVmHfNXjL9AlodhGN2SoOVw
	 7Ass3DpEcmHG3uPOcqV6vH/qigUD3feVoVuhfw/Q=
Message-ID: <992f8a41-14df-40e1-a7d6-e4337514800b@arm.com>
Date: Mon, 13 Apr 2026 15:32:44 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
To: "Rose, Charles" <Charles.Rose@dell.com>
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
 "tan.shaopeng@fujitsu.com" <tan.shaopeng@fujitsu.com>,
 "xhao@linux.alibaba.com" <xhao@linux.alibaba.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
 "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "zengheng4@huawei.com" <zengheng4@huawei.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <DS7PR19MB6351DBDFED61A8C9A89DB391F351A@DS7PR19MB6351.namprd19.prod.outlook.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <DS7PR19MB6351DBDFED61A8C9A89DB391F351A@DS7PR19MB6351.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Charles,

On 4/3/26 00:38, Rose, Charles wrote:
> Hi Ben,
> 
>> This version of the mpam missing pieces series sees a couple of things
>> dropped or hidden. Memory bandwith utilization with free-running counters
>> is dropped in preference of just always using 'mbm_event' mode (ABMC
>> emulation) which simplifies the code and allows for, in the future,
>> filtering by read/write traffic. So, for the interim, there is no memory
>> bandwidth utilization support. CDP is hidden behind config expert as
>> remount of resctrl fs could potentially lead to out of range PARTIDs being
>> used and the fix requires a change in fs/resctrl. The setting of MPAM2_EL2
>> (for pkvm/nvhe) is dropped as too expensive a write for not much value.
>>
>> There are a couple of 'fixes' at the start of the series which address
>> problems in the base driver but are only user visible due to this series.
>>
> 
> I tested cache occupancy and memory bandwidth allocation on a Dell PowerEdge XE8712 with NVIDIA Grace A02P. Both seem to work as expected.
> 
> For the series:
> 
> Tested-by: Charles Rose <charles.rose@dell.com>

Thanks for testing!


