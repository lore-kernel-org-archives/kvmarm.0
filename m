Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF88CC433FE
	for <kvmarm@archiver.kernel.org>; Sun, 15 May 2022 10:40:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 475084B178;
	Sun, 15 May 2022 06:40:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A2kF308g3v6A; Sun, 15 May 2022 06:40:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00F2849DFF;
	Sun, 15 May 2022 06:40:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDCF940015
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 06:40:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qlmWuPq0Jy6P for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 May 2022 06:40:05 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB41F4076A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 06:40:05 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 06FF860F18;
 Sun, 15 May 2022 10:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6653DC385B8;
 Sun, 15 May 2022 10:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652611203;
 bh=724eTmZLQCkMZqxbg8w9wSa28+2siNjvrzvYcImWISo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Civ013UXfcbnIinMDINQ7M8bBOYYfAhRF7mJRAwfxMO+4o1ffyMrSB3Zl2fq3hBV+
 B6CV+DN3eQ/tB9Hd2CeXKQlomZax+UIDWaLX3GV7P7rfcaeyDyiFeYItEpqFnbpBN2
 xvHmrw7/qGllgA47o8oMrLk4cBM9w5eYIT1pavMXkshzzFV3EQyywVi1aiq/im0+wD
 ff03HdK7mXgyLMKrpPd8pxGX16GJKqOPa+DsToLeLzYkfbF16WvcztcbNz7BfHv6lR
 xCFGVpdnV9QwtKVTIsdKHHW0K4ZoG7SMg18GS5uxqV+Xs4z0WIIf8yxnLN+G1i++k5
 W5kVd0c5OTj8Q==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nqBfM-00BPhw-Hy; Sun, 15 May 2022 11:40:00 +0100
MIME-Version: 1.0
Date: Sun, 15 May 2022 11:40:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] selftests: KVM: aarch64: Let hypercalls use UAPI
 *_BIT_COUNT
In-Reply-To: <688a817f-b2e2-4620-ef4b-f3c5f73ae34d@redhat.com>
References: <20220504184415.1905224-1-rananta@google.com>
 <YnLa8uH55/epyjlS@google.com> <87zgjw6v9k.wl-maz@kernel.org>
 <688a817f-b2e2-4620-ef4b-f3c5f73ae34d@redhat.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <3015731497c79a051779ce531155e5b5@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oupton@google.com, rananta@google.com,
 drjones@redhat.com, james.morse@arm.com, alexandru.elisei@arm.com,
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org,
 pshier@google.com, ricarkol@google.com, reijiw@google.com,
 jingzhangos@google.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Peter Shier <pshier@google.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022-05-05 14:32, Paolo Bonzini wrote:
> On 5/5/22 14:04, Marc Zyngier wrote:
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h 
>> b/arch/arm64/include/uapi/asm/kvm.h
>> index e523bb6eac67..3cde9f958eee 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -342,6 +342,10 @@ struct kvm_arm_copy_mte_tags {
>>     enum {
>>   	KVM_REG_ARM_STD_BIT_TRNG_V1_0	= 0,
>> +	/*
>> +	 * KVM_REG_ARM_STD_BMAP_BIT_COUNT will vary as new services
>> +	 * are added, and is explicitely not part of the ABI.
>> +	 */
>>   	KVM_REG_ARM_STD_BMAP_BIT_COUNT,
>>   };
> 
> That seems like a bad idea.  Perhaps you can wrap it in #ifdef
> __KERNEL_OR_SELFTESTS__?  I can't find any prior art.

Yeah. I've dropped this patch and sprinkled a bunch of
'#ifdef __KERNEL__' instead. We can revisit this later,
or hack the test to temporarily define __KERNEL__, which
is just as bad...

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
