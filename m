Return-Path: <SRS0=HtNg=W7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFA4C3A5AA
	for <kvmarm@archiver.kernel.org>; Wed,  4 Sep 2019 16:02:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B86F2341E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Sep 2019 16:02:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B86F2341E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 405154A5A7;
	Wed,  4 Sep 2019 12:02:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1G3PHhso6wRQ; Wed,  4 Sep 2019 12:02:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A7064A56C;
	Wed,  4 Sep 2019 12:02:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6ECF4A542
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Sep 2019 12:02:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h8N1AM67wiJv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Sep 2019 12:02:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2C054A52C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Sep 2019 12:02:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7813828;
 Wed,  4 Sep 2019 09:02:06 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40F573F246;
 Wed,  4 Sep 2019 09:02:04 -0700 (PDT)
Subject: Re: [PATCH v4 00/10] arm64: Stolen time support
To: Andrew Jones <drjones@redhat.com>
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190903080348.5whavgrjki7zrtmd@kamzik.brq.redhat.com>
 <20190903084921.zikiucdruymfgfsq@kamzik.brq.redhat.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <6c68dd0c-5103-cd2d-4162-b37c6d10460b@arm.com>
Date: Wed, 4 Sep 2019 17:02:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903084921.zikiucdruymfgfsq@kamzik.brq.redhat.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 03/09/2019 09:49, Andrew Jones wrote:
> On Tue, Sep 03, 2019 at 10:03:48AM +0200, Andrew Jones wrote:
>> Hi Steven,
>>
>> I had some fun testing this series with the KVM selftests framework. It
>> looks like it works to me, so you may add
>>
>> Tested-by: Andrew Jones <drjones@redhat.com>
>>
> 
> Actually, I probably shouldn't be quite so generous with this tag yet,
> because I haven't yet tested the guest-side changes. To do that I'll
> need to start prototyping something for QEMU. I need to finish some other
> stuff first, but then I can do that.

Thanks for the testing, I'll wait for your other testing before adding
your Tested-by tag.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
