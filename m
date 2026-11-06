Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962020;
	b=L6qBCj9QxlFiD9BAIc53XqQWUxIQCgXz3nM/TfztDkM8Y6QkFXVWPXkV8hJs09gkDheX
	 /bOQjSmPOh7GAq7HxBkUY2qM41ci4no/44ZHR2Ya5G59DuuJSkEqj3WFjUR4iYGlp4wsA
	 9UCPo4Omy4Wk2Y4d8z7A05u2FpxaefLLc4ZVASUvDovbSk2S3JahkA+j/aoul8v6mp84C
	 DTMHeZD/mMB+1Cixb+Fc97AgZJpEFop7/h/uU8G6nlh1ddIBFvi+mxBnzHUqu5AdW+wsR
	 b7m/ow3Ir8dXBRszQ2/jsAMJquvVkm9ylbwvoQs0yMlAI7M2EIalGwUiI4wN7VNvMJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962020;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=chII47/1+ntpuddMK/yMlIxPkKF4NybCV4vRHvKCUco=;
	b=wBQZCCBrTeMu7jbFaXLISXmv8y9CEDAV/jzL+TS3xu99PzEzZvKEyTilB96ivZNxXVuA
	 99FSpf7/wQU6rsKAtQQuikVB2nQuCNX25J9glJoDT4nG67RY7jZ4yw5vT/S3R0xYfB3XR
	 PIqsHsuvmg8E1q+8TFluBKloxdFbGOFOi7M22idzSUciO7bbofT4+pPZhbmbaM3lM+UFP
	 HOeZ+nnnJ5FDvaa88cdhHZlqMZEUJOoQvshGZT10VeYMsF8WV4Dkx5Z6iZ0K/WRbk4jbW
	 EkWAPOBcIMFwvdpEs1n8TMp+M3UIKeL1jxzuvlcdDafrlp7zIHavTrKRGkgIiDSxJVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	arc=none smtp.remote-ip=113.46.200.220
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90059606D80E
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 10:46:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90059606D80E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=chII47/1+ntpuddMK/yMlIxPkKF4NybCV4vRHvKCUco=;
	b=BqDcONYAZxAgTfJDTYNrFs6jHSYv6zk/Vd9HVV9Gc4jpKk7bHF5wANGASsXqZVJsiqlHE7zfM
	jkl7XbQ6nTxZpuQ5UxUo8xnTgQeizL5KZOpQI5eiSVryAQzZMBifNqfgeIuUFacPt72iGoSAs/C
	4bcCsxjE+JkUlaZv6zym+x4=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jLbTQ6VTTz12Lc0;
	Fri,  6 Nov 2026 18:46:50 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id DC11D2011D;
	Fri,  6 Nov 2026 18:46:48 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 6 Nov 2026 18:46:47 +0800
Message-ID: <191ab0e3-9913-4927-9f84-c861c8f3bcd5@huawei.com>
Date: Fri, 6 Nov 2026 18:46:46 +0800
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/15] KVM: arm64: Derive the VM hardware dirty mode
 from dirty logging
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <corbet@lwn.net>, <pbonzini@redhat.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yangjinqian1@huawei.com>,
	<caijian11@h-partners.com>, <liuyonglong@huawei.com>,
	<tangchengchang@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <fuad.tabba@linux.dev>, <mark.rutland@arm.com>,
	<seanjc@google.com>, <rdunlap@infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <skhan@linuxfoundation.org>
References: <20260929103655.85107-1-zhengtian10@huawei.com>
 <20260929103655.85107-13-zhengtian10@huawei.com> <auimPtktqZ1cwk3-@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <auimPtktqZ1cwk3-@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 11/2/2026 11:03 PM, Leonardo Bras wrote:
> On Tue, Sep 29, 2026 at 06:36:52PM +0800, Tian Zheng wrote:
>> Both HAFDBS and HDBSS flip VTCR_EL2.HD at memslot-update time. Two
>> independent toggles allow an intermediate HDBSS-set/HD-clear state,
>> an illegal combination, and need locking against concurrent updates.
>>
>> Replace both with kvm_arch_update_hw_dirty_mode(), a pure function
>> of the static capabilities and the number of logging memslots:
>>
>>    - logging && HDBSS-capable  -> HD|HA|HDBSS
>>    - logging, no HDBSS         -> off
>>    - !logging && HAFDBS-cap.   -> HD|HA
> 
> This last one is gone now, so I guess most of this patch has to be
> reworked, right?
> 
> Thanks!
> Leo

Hi Leo,

Yes, the last one is no longer needed as we discussed earlier in [1], so
I'll rework this patch.

[1] https://lore.kernel.org/all/attMtUqxNsuPooix@LeoBrasDK/

Thanks,
Tian
