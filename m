Return-Path: <SRS0=67XK=W6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C1BC3A5A7
	for <kvmarm@archiver.kernel.org>; Tue,  3 Sep 2019 09:19:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A37D82077B
	for <kvmarm@archiver.kernel.org>; Tue,  3 Sep 2019 09:19:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A37D82077B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E17F84A594;
	Tue,  3 Sep 2019 05:19:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id APRP3mX9PQvW; Tue,  3 Sep 2019 05:19:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E59874A523;
	Tue,  3 Sep 2019 05:19:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 855D64A52D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Sep 2019 05:19:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v4LzDy3GltpU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Sep 2019 05:19:02 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5F4944A4FE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Sep 2019 05:19:02 -0400 (EDT)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 33C4E53355E7BE0D137C;
 Tue,  3 Sep 2019 17:18:58 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Sep 2019
 17:18:50 +0800
Subject: Re: [PATCH v4 05/10] KVM: arm64: Support stolen time reporting via
 shared structure
To: Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190830084255.55113-6-steven.price@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d55d091f-1c0f-9c47-b7b2-95c87285335d@huawei.com>
Date: Tue, 3 Sep 2019 17:14:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190830084255.55113-6-steven.price@arm.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

On 2019/8/30 16:42, Steven Price wrote:
> Implement the service call for configuring a shared structure between a
> VCPU and the hypervisor in which the hypervisor can write the time
> stolen from the VCPU's execution time by other tasks on the host.
> 
> The hypervisor allocates memory which is placed at an IPA chosen by user
> space.

It seems that no allocation happens in the hypervisor code.  User space
will do it instead?

> The hypervisor then updates the shared structure using
> kvm_put_guest() to ensure single copy atomicity of the 64-bit value
> reporting the stolen time in nanoseconds.
> 
> Whenever stolen time is enabled by the guest, the stolen time counter is
> reset.
> 
> The stolen time itself is retrieved from the sched_info structure
> maintained by the Linux scheduler code. We enable SCHEDSTATS when
> selecting KVM Kconfig to ensure this value is meaningful.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>

Thanks,
zenghui

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
