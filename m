Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C4C305669
	for <kvmarm@lists.linux.dev>; Sat,  4 Jul 2026 07:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783151201; cv=none; b=QkMJSKQqo/AT5smcIPKAq7EW+mKRkMfbTIGFhig9WIEYOJ8ssc5rJl9Epr43cyn6MzVFwgFKvkUGmzPZWmF+cqPr+l+jwnZsrqaIyDDTeWNaWM8USB/h7K1zPWXqXLCmY8fAjQ7UDN/5rLYu4Xu0p3a6TkDrS869eOmeHNOBnxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783151201; c=relaxed/simple;
	bh=34vNWbXe9tXff0tvnC0WcH98XXWhqm99ucJyEx2XldY=;
	h=To:CC:From:Subject:Message-ID:Date:MIME-Version:Content-Type; b=fIRoX+YKDrJWEL6d/OR1kS7YlaUrO7rhLuYTnvXqrZ+lwaahyDh1SvsTeujjGtbAr5eC7P+sNqp9fMCjoFZ2j1/Wmr2Mcc4lZhZ1FgpfXztD1JPTk1E7ws6VbnXNw73/ewTSzcc8rNEnqUfEipjFyuOoDv8S1IWYkbjn0YMv8l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=3lUxwxsO; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="3lUxwxsO"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=34vNWbXe9tXff0tvnC0WcH98XXWhqm99ucJyEx2XldY=;
	b=3lUxwxsODXylrwAAueb3Y3T+dtOigJ1WSNjGIlJ5lmfqowv7O6vWcBeZTjB8k6eK8FxQ4VZ67
	Ts2cepUHIT+r5Kk+WUNOP6VuJcOpgNS9M10jxIHlEsVgXsflpQqJyWQ3zhwCkKmkg+N4HjMyhAz
	FCfGcho3JiDDhzohIU0sXxA=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4gsjB62BhTzRhTy;
	Sat,  4 Jul 2026 15:37:02 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 86E4740594;
	Sat,  4 Jul 2026 15:46:12 +0800 (CST)
Received: from kwepemq500001.china.huawei.com (7.202.195.224) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 4 Jul 2026 15:46:12 +0800
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemq500001.china.huawei.com (7.202.195.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 4 Jul 2026 15:46:11 +0800
To: Marc Zyngier <maz@kernel.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<catalin.marinas@arm.com>, <will@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>
CC: "guoyang (C)" <guoyang2@huawei.com>, "huanglingyan (A)"
	<huanglingyan2@huawei.com>, "Wangzhou (B)" <wangzhou1@hisilicon.com>
From: Tangnianyao <tangnianyao@huawei.com>
Subject: Question about the "TLBs and I-cache are private to each vCPU"
 guarantee with VTTBR_EL2.CnP
Message-ID: <e85b957d-c8bc-aac0-b413-03441d05c3df@huawei.com>
Date: Sat, 4 Jul 2026 15:45:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500001.china.huawei.com (7.202.195.224)

Hi, all

I'm trying to understand the TLB and I-cache invalidation in
`kvm_arch_vcpu_load()` that is intended to "guarantee that both TLBs and
I-cache are private to each vCPU".

As I understand it, when `VTTBR_EL2.CnP == 1`, `__kvm_flush_cpu_context()`
only performs a local TLB and I-cache invalidation, which does not seem
sufficient to guarantee that property.

In fact, even if the invalidation were extended to the Inner Shareable
domain, it still seems difficult to guarantee “TLBs and I-cache are
private to each vCPU”, when `VTTBR_EL2.CnP == 1`, as long as multiple
vCPUs from the same VM may be running concurrently on different PEs.

So I have two questions:

1. What is the rationale behind the comment that "guarantee that both TLBs
and I-cache are private to each vCPU"?
2. Should the effect of `VTTBR_EL2.CnP` be taken into account when
reasoning about this guarantee?

Thanks
Nianyao Tang

