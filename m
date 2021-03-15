Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924F9C433E0
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 11:44:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0C11264EB6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 11:44:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C11264EB6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80CA14B307;
	Mon, 15 Mar 2021 07:44:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2mrdkp-2vAV5; Mon, 15 Mar 2021 07:44:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AFE74B319;
	Mon, 15 Mar 2021 07:44:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B10414B319
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:44:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id taAd+pe0gEU3 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 07:44:18 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A34174B316
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:44:18 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EDB6061601;
 Mon, 15 Mar 2021 11:44:15 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lLldu-001dwX-27; Mon, 15 Mar 2021 11:44:14 +0000
MIME-Version: 1.0
Date: Mon, 15 Mar 2021 11:44:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH][stable-4.{4, 9, 14,
 19}] KVM: arm64: Fix exclusive limit for IPA size
In-Reply-To: <YE9FVw1PE9kClrdi@kroah.com>
References: <20210315110833.4135927-1-maz@kernel.org>
 <YE9FVw1PE9kClrdi@kroah.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <7ec2199ed2b2c8e6d881461398882751@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gregkh@linuxfoundation.org, kvmarm@lists.cs.columbia.edu,
 kernel-team@android.com, eric.auger@redhat.com, stable@vger.kernel.org,
 drjones@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 stable@vger.kernel.org
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

On 2021-03-15 11:30, Greg KH wrote:
> On Mon, Mar 15, 2021 at 11:08:33AM +0000, Marc Zyngier wrote:
>> Commit 262b003d059c6671601a19057e9fe1a5e7f23722 upstream.
>> 
>> When registering a memslot, we check the size and location of that
>> memslot against the IPA size to ensure that we can provide guest
>> access to the whole of the memory.
>> 
>> Unfortunately, this check rejects memslot that end-up at the exact
>> limit of the addressing capability for a given IPA size. For example,
>> it refuses the creation of a 2GB memslot at 0x8000000 with a 32bit
>> IPA space.
>> 
>> Fix it by relaxing the check to accept a memslot reaching the
>> limit of the IPA space.
>> 
>> Fixes: c3058d5da222 ("arm/arm64: KVM: Ensure memslots are within 
>> KVM_PHYS_SIZE")
>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Cc: stable@vger.kernel.org # 4.4, 4.9, 4.14, 4.19
>> Reviewed-by: Andrew Jones <drjones@redhat.com>
>> Link: 
>> https://lore.kernel.org/r/20210311100016.3830038-3-maz@kernel.org
>> ---
>>  virt/kvm/arm/mmu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> This file does not exist in 4.4.y or 4.9.y, so I can't apply it there 
> :(

Ah, git rename handling fixed that up for me, and I didn't pay
attention to the resulting path... Sorry about that.

I'll resend the patch for 4.4 and 4.9

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
