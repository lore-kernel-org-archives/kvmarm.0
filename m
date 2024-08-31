Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37530339A1
	for <kvmarm@lists.linux.dev>; Sat, 31 Aug 2024 03:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725075279; cv=none; b=N+h8bu6h5w49EaSBZpVcOLGO6W5c4Y2KHFeseSbEmM7DwmB0nCelhyM5rvWnj/QRoz0OcOaKzClPjrvNHba2EEm3LAvHmd0uHUMQylXvzp5SCltkc5sSZ/PdQ3T2OCJIuFMwuZ3dLWTQ2dF+8c/sxBB5UC/rCXEaBcKlxGpEgt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725075279; c=relaxed/simple;
	bh=YltV/0iNRbAaRXpOfmEmP8UsZ/sW8fSYhZql7v+iiOI=;
	h=To:CC:From:Subject:Message-ID:Date:MIME-Version:Content-Type; b=SytjQNVUBzfhdr3LmHVMObi1i8sM3lrKqXIaDgNwpHladaZdotlgUvdVOAEzPW+xNph9f0CVgxDJCptdfyu6v2HAJqVKKu6WlJwNY+91+ip6LX8JcRUtbFQBrgtVqUIuaGd3DRUeqer/P5LGxSRbutwlJPzDQshMDvN+xZfb5mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WwgVs5tMgzQr9c;
	Sat, 31 Aug 2024 11:29:41 +0800 (CST)
Received: from kwepemd500014.china.huawei.com (unknown [7.221.188.63])
	by mail.maildlp.com (Postfix) with ESMTPS id 934FD1401E9;
	Sat, 31 Aug 2024 11:34:34 +0800 (CST)
Received: from [10.67.146.137] (10.67.146.137) by
 kwepemd500014.china.huawei.com (7.221.188.63) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 31 Aug 2024 11:34:34 +0800
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	<oliver.upton@linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <kvmarm@lists.linux.dev>
CC: "guoyang (C)" <guoyang2@huawei.com>
From: Tangnianyao <tangnianyao@huawei.com>
Subject: Question on get random long worse in VM than on host
Message-ID: <214e37e9-7aba-1e61-f63f-85cb10c9a878@huawei.com>
Date: Sat, 31 Aug 2024 11:34:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd500014.china.huawei.com (7.221.188.63)

Hi, all

On ARM64 server(Kunpeng), performance of some syscall cases (like fork

and open) in guest, which need random u64, are 10~20% worse than

those on host. Because CONFIG_ARCH_HAS_ELF_RANDOMIZE=y and

CONFIG_STACKPROTECTOR=y, guest kernel need random u64 and

require them from host kvm using hvc.

If FEAT_RNG is supported and EL3 firmware not support smccc trng, host

kvm finally return random u64 using RNDRRS to guest.

Shall we firstly let guest get random u64 from RNDRRS to avoid hvc trap?

For example, if host find smccc trng not available, then tell guest smccc

trng not available when guest check trng version.


Thanks for your help.

Nianyao

