Return-Path: <SRS0=76eI=ZU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2348C432C3
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 11:16:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2DFDD21775
	for <kvmarm@archiver.kernel.org>; Thu, 28 Nov 2019 11:16:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2DFDD21775
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96A3D4AE8E;
	Thu, 28 Nov 2019 06:16:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fguDvO0+m0JU; Thu, 28 Nov 2019 06:16:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A47284AC7A;
	Thu, 28 Nov 2019 06:16:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77CA74AC7A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 06:16:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l-6WAqvoHjW9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Nov 2019 06:16:33 -0500 (EST)
Received: from huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 075954A7FE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Nov 2019 06:16:33 -0500 (EST)
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.57])
 by Forcepoint Email with ESMTP id B517DF91447D49C6887B;
 Thu, 28 Nov 2019 19:16:29 +0800 (CST)
Received: from dggeme765-chm.china.huawei.com (10.3.19.111) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 28 Nov 2019 19:16:29 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme765-chm.china.huawei.com (10.3.19.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 28 Nov 2019 19:16:29 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 28 Nov 2019 19:16:29 +0800
From: linmiaohe <linmiaohe@huawei.com>
To: Steven Price <steven.price@arm.com>, "maz@kernel.org" <maz@kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "rkrcmar@redhat.com"
 <rkrcmar@redhat.com>, "james.morse@arm.com" <james.morse@arm.com>,
 "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "christoffer.dall@arm.com"
 <christoffer.dall@arm.com>, "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "will@kernel.org"
 <will@kernel.org>, "andre.przywara@arm.com" <andre.przywara@arm.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH v2] KVM: vgic: Use wrapper function to lock/unlock all
 vcpus in kvm_vgic_create()
Thread-Topic: [PATCH v2] KVM: vgic: Use wrapper function to lock/unlock all
 vcpus in kvm_vgic_create()
Thread-Index: AdWl3KlyTD6n4fFd4E+DqrFstDRVng==
Date: Thu, 28 Nov 2019 11:16:28 +0000
Message-ID: <49f3dec1fa65498c84d0344e0ea629ce@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Steven Price wrote:
>>   
>>   	if (irqchip_in_kernel(kvm))
>> @@ -92,11 +92,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
>Extra context:
>
>	/*
>	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
>	 * vcpu->mutex.  By grabbing the vcpu->mutex of all VCPUs we ensure
>>   	 * that no other VCPUs are run while we create the vgic.
>>   	 */
>
>That comment no longer makes sense here - there's a very similar one already in lock_all_vcpus(). With that removed:
>
>Reviewed-by: Steven Price <steven.price@arm.com>
>
Many thanks for your review. That comment no longer makes sense as you figured out. I will
remove that. Thanks again.

>>   	ret = -EBUSY;
>> -	kvm_for_each_vcpu(i, vcpu, kvm) {
>> -		if (!mutex_trylock(&vcpu->mutex))
>> -			goto out_unlock;
>> -		vcpu_lock_idx = i;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
