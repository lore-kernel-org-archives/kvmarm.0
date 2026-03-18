Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A315D285CA4
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 10:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773829400; cv=none; b=kOmOif3mGlcVxCc6jyg2yWfGTIrXtbeAgNAjiGjsJOpraWtkC7Ofc+ZiBVBGvW59Tg4K43tKqJdEkFjiqFfSN5bWRqUg3aWIaHtPE1qxV3sriLRbgLB0Lv/kENmyEgEcJ/zAlNHwVVhKtFq4hunl7Ld80d9kX6fApPE0iVveOWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773829400; c=relaxed/simple;
	bh=LsIrpFeSekN7KOklsxZzgD+7XI89OQyVLIQAft+DfLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lT5jT9SvOsFlKlg7JHNWOu89tYz+PhJtPt/tISGOted6ixBq+zwQPulCrk9D88pcfdct2BMYPYp0bZwq76/jjNxcX0GVZGqV117fJCTw2VTfs3ZyuqwzrgWDFhdWz2fIMxkSGiZYxZahW3GX5qHvu/Le47hHztVMmxBdi3h/vGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0B0D01E2F;
	Wed, 18 Mar 2026 03:23:12 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6FAE23F778;
	Wed, 18 Mar 2026 03:23:14 -0700 (PDT)
Message-ID: <ddcf317f-6366-4814-948b-bdd0c69152b0@arm.com>
Date: Wed, 18 Mar 2026 10:23:13 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH v6 00/40] arm_mpam: Add KVM/arm64 and resctrl glue code
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
References: <20260313144617.3420416-1-ben.horgan@arm.com>
 <TY4PR01MB1693015592F173098A0C5A2A48B4EA@TY4PR01MB16930.jpnprd01.prod.outlook.com>
Content-Language: en-US
From: Ben Horgan <ben.horgan@arm.com>
In-Reply-To: <TY4PR01MB1693015592F173098A0C5A2A48B4EA@TY4PR01MB16930.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/18/26 08:09, Shaopeng Tan (Fujitsu) wrote:
> Hello Ben,
> 
> I retested this patch series and there is no problem.
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>

Thanks!

> 
> Best regards,
> Shaopeng TAN

