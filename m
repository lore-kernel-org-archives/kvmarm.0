Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162467462
	for <kvmarm@lists.linux.dev>; Mon, 30 Sep 2024 06:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727678026; cv=none; b=tbb2so3VoTpnKJbiQpfmE4+mSQONocaurPsAyk7+Rmgv+slO02sekYE9Z747E/JNw3iYF/8Sem84AcGO73P7k0ZBgnq7XcTFzOk44OJxAZ1CSKe2T8SPPYMoQQC2mIRTlWBMyX6blR0aSlV/sehstyd+Inu5J/DbANpcYs5hANQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727678026; c=relaxed/simple;
	bh=x5Zzwz6Qe5nWXlRjzgsELDkYNpv75JkjFDVHGPw/gQE=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FSxQFW32veibt/eh1Z7/8Y1Ks0PuXn9d6gfJ/m0Wa4ShO9q2qclHT/I7ZVqTWB14nQxQab/r3APolB2o5YflFiXveep9IJjyL5a0GZg5gpu5VQ2QAFwBk2dx/nyBZt+65Mpxs/WbPTvAfA8Af7bnFsxyxAZmkinKaikCuyUk9ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XHB4j0Wyhz1HKRc;
	Mon, 30 Sep 2024 14:29:41 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id CA92B18001B;
	Mon, 30 Sep 2024 14:33:36 +0800 (CST)
Received: from [10.174.176.125] (10.174.176.125) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 30 Sep 2024 14:33:35 +0800
Subject: Re: [bug report] KVM: arm64: vgic-v4: Occasionally issue VMOVP to an
 unmapped VPE on GICv4.1
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Marc Zyngier
	<maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<wanghaibin.wang@huawei.com>, <tangnianyao@huawei.com>,
	<wangzhou1@hisilicon.com>
References: <c182ece6-2ba0-ce4f-3404-dba7a3ab6c52@huawei.com>
 <f9ba0b4c-b7d6-40da-b84f-525cc0bc4a25@os.amperecomputing.com>
From: Kunkun Jiang <jiangkunkun@huawei.com>
Message-ID: <c53a63f1-0b68-ca65-c584-b559c42a2471@huawei.com>
Date: Mon, 30 Sep 2024 14:33:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f9ba0b4c-b7d6-40da-b84f-525cc0bc4a25@os.amperecomputing.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)

Hi Ganapat,

On 2024/9/30 13:18, Ganapatrao Kulkarni wrote:
> 
> Hi Kunkun,
> 
> On 29-09-2024 12:48 pm, Kunkun Jiang wrote:
>> Hi all,
>>
>> I found a problem with occasionally issuing VMOVP to an unmapped VPE 
>> on GICv4.1. In my test environment, operating an unmapped VPE will 
>> generate RAS, so I found this problem. The detailed analysis is as 
>> follows.
>>
> 
> May I know, what specific RAS errors you are getting?

The hardware checks whether the VPE in the VPE table is valid when 
processing the VMOVP. If the VPE is invalid, a RAS message is reported.

Thanks,
Kunkun Jiang
