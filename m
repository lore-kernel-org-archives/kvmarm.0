Return-Path: <SRS0=Byl/=Z5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAFAC2D0C2
	for <kvmarm@archiver.kernel.org>; Sat,  7 Dec 2019 07:14:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 058C62245C
	for <kvmarm@archiver.kernel.org>; Sat,  7 Dec 2019 07:14:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 058C62245C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C49C4AF06;
	Sat,  7 Dec 2019 02:14:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x-ZVCMhURizx; Sat,  7 Dec 2019 02:14:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E9924AF08;
	Sat,  7 Dec 2019 02:14:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 827C14AF01
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 Dec 2019 02:14:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B-UIsEXYUNR8 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  7 Dec 2019 02:14:04 -0500 (EST)
Received: from huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88E0E4ACBE
 for <kvmarm@lists.cs.columbia.edu>; Sat,  7 Dec 2019 02:14:03 -0500 (EST)
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.53])
 by Forcepoint Email with ESMTP id 9DFD3EAF984A1CA80CEC;
 Sat,  7 Dec 2019 15:13:59 +0800 (CST)
Received: from dggeme766-chm.china.huawei.com (10.3.19.112) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 7 Dec 2019 15:13:59 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Sat, 7 Dec 2019 15:13:59 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Sat, 7 Dec 2019 15:13:59 +0800
From: linmiaohe <linmiaohe@huawei.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm: fix missing free_percpu_irq in
 kvm_timer_hyp_init()
Thread-Topic: [PATCH] KVM: arm: fix missing free_percpu_irq in
 kvm_timer_hyp_init()
Thread-Index: AdWszcSfbfmyPnL7QOOWA4e8Y3r2BA==
Date: Sat, 7 Dec 2019 07:13:58 +0000
Message-ID: <c856fab1586545cf9779e06aeaca294a@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.189.20]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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

Marc Zyngier <maz@kernel.org> wrote:
>On 2019-11-23 02:30, linmiaohe wrote:
>> From: Miaohe Lin <linmiaohe@huawei.com>
>>
>> When host_ptimer_irq request irq resource failed, we forget to release 
>> the host_vtimer_irq resource already requested.
>> Fix this missing irq release and other similar scenario.
>
>That's really not a big deal, as nothing but KVM can use the timers anyway, but I guess it doesn't hurt to be correct.

I think It's a good practice to release the never used resources though it may be harmless.

>>
>> -out_free_irq:
>> +
>> +out_free_ptimer_irq:
>> +	free_percpu_irq(host_ptimer_irq, kvm_get_running_vcpus());
>> +out_disable_gic_state:
>> +	if (has_gic)
>> +		static_branch_disable(&has_gic_active_state);
>
>Given that we're failing the init of KVM, this is totally superfluous. Also, this state is still valid, no matter what happens (the GIC is not going away from under our feet).
>

Would you like a v2 patch without out_disable_gic_state cleanup ? If so, I would send a new one. But if you
think this patch isn't worth to pick up, I would drop it.

Many thanks for your review.

>> +out_free_vtimer_irq:
>>  	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
>> +
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
