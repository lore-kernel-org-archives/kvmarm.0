Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43294C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 13:00:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A534B61104
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 13:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A534B61104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEFB14B2C0;
	Wed, 12 May 2021 09:00:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RAngonfQ3aZY; Wed, 12 May 2021 09:00:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 959C14B4A3;
	Wed, 12 May 2021 09:00:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AA804B28E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 09:00:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Zbwgw1+ZH-c for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 09:00:35 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C81A4B838
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 09:00:11 -0400 (EDT)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FgFF34cb2z1BLCm;
 Wed, 12 May 2021 20:57:27 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 20:59:59 +0800
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support for
 aarch64
To: Auger Eric <eric.auger@redhat.com>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-5-ricarkol@google.com> <87a6pcumyg.wl-maz@kernel.org>
 <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4f7f81f9-8da0-b4ef-49e2-7d87b5c23b15@huawei.com>
Date: Wed, 12 May 2021 20:59:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
 kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Eric,

On 2021/5/6 20:30, Auger Eric wrote:
> running the test on 5.12 I get
> 
> ==== Test Assertion Failure ====
>   aarch64/debug-exceptions.c:232: false
>   pid=6477 tid=6477 errno=4 - Interrupted system call
>      1	0x000000000040147b: main at debug-exceptions.c:230
>      2	0x000003ff8aa60de3: ?? ??:0
>      3	0x0000000000401517: _start at :?
>   Failed guest assert: hw_bp_addr == PC(hw_bp) at
> aarch64/debug-exceptions.c:105
> 	values: 0, 0x401794

FYI I can also reproduce it on my VHE box. And Drew's suggestion [*]
seemed to work for me. Is the ISB a requirement of architecture?

[*] https://lore.kernel.org/kvm/20210503124925.wxdcyzharpyzeu4v@gator.home/


Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
