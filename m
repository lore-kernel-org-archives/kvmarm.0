Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9F718D656
	for <kvmarm@lists.linux.dev>; Thu, 16 Oct 2025 02:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760580024; cv=none; b=mNw3fG69g54I9/qZOVdVsH6sGsAWFIBXw3bgm0aC/Pgw2pLDsVjUw0oKNJv9OmZNhzzX0AVfoezSv+XGhwscIgaF0EHXbpwAdG8qtC89fNbsBHrXrHjhTiLZYd2QehQQvV//BFF2lxBftb7t6HOeSIlolidsE8bHYjU0w+BhH74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760580024; c=relaxed/simple;
	bh=YW36qZrDdDxLfRhtuQX2WvWZx4/obGYux/G0hx1ooZ4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=DO9lypZfVdbO2ZIc+rvFBKL4xZSVUlvSz/VPjRzs+97EvhLzG34ygMruU97j8DbsUEaUOA+b/XpI735KP29M/VQPXfImmQwBJ3gLoKYQx50bhqL2CqOGClnd5zragFTrwzdvgzQI3UDHFQ0lmocxvfFb+4D25Ln9BHFHKPBgJJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4cnB3d0q7szRhs2;
	Thu, 16 Oct 2025 09:59:57 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0AF111402F2;
	Thu, 16 Oct 2025 10:00:18 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 16 Oct 2025 10:00:13 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 16 Oct 2025 10:00:13 +0800
Message-ID: <866aca63-1f6b-2109-fa76-6d68cb7c547a@hisilicon.com>
Date: Thu, 16 Oct 2025 10:00:07 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
From: Zhou Wang <wangzhou1@hisilicon.com>
Subject: Question about heterogeneous VM live migration
To: <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200004.china.huawei.com (7.202.195.237)

Hi,

We are now trying to do heterogeneous VM live migration among HiSilicon ARM
servers, seems there are problems about disabling a feature in guest.

For a feature, if we disable it in VM by configure related ID register field,
we should make it actually been disabled, e.g. configure related control
register in EL2 or trap EL0/EL1 access to EL2.

Possible problems:

1. Some features can not be disabled actually in EL0/EL1, e.g. FEAT_AFP,
   FEAT_RPRES, FEAT_CSSC, FEAT_LRCPC3...

   Disabling it by ID can not avoid a stupid user to directly use it without ID
   checking, which may bring subtle problem in heterogeneous VM live migration.

2. For some features, it can be trapped, but KVM does not support yet. Not sure
   if we should support them in future.

   E.g. If we disable ID of FEAT_HAFT for guest, we need configure
        HCRX_EL2.TCR2En to 0, so access to TCR2_EL1.HAFT will be trapped.

        For FEAT_PAN3, it instroduces EPAN to SCTLR_EL1，if we disable ID of
	FEAT_PAN3, we need make SCTLR_EL1 to trap by setting HFGRTR_EL2.SCTLR_EL1.

   Seems there are no trap setting in above cases. Just a quick look, maybe I
   miss something.

I am not sure if we already consider above problems, any help will be appreciated.

Best,
Zhou
