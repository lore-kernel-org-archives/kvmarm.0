Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72709C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 15:51:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E88D8206A4
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 15:51:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQbd4R8Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E88D8206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A18A74B0B5;
	Thu, 11 Jun 2020 11:51:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3M7RJdUCbMuA; Thu, 11 Jun 2020 11:51:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B12A54B181;
	Thu, 11 Jun 2020 11:51:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5E8C4B17F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 11:51:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0AmMzpL2a-dX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2020 11:51:42 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FDF64B132
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 11:51:42 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8073D2075E;
 Thu, 11 Jun 2020 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591890701;
 bh=buouFtbooRy71XGHmBWmTOUevELIfu0pjfzSCKPq8pY=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=bQbd4R8QZfbn7RGrBxQfn1ruYStXtOK6Z0q8MjEGMxIEzfjWZbv9wPvu4ao+MPfv8
 1J7TGdGcixpukgrpdY6nm/py23a0nU82XzHB+uJdHGeGlNwL3pBL6dyV251JqldMNo
 uWAaERT1/kzBgRGTtto5IPIqD+QhtGoVipYhyA0Q=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jjPUR-0029gk-Lg; Thu, 11 Jun 2020 16:51:40 +0100
MIME-Version: 1.0
Date: Thu, 11 Jun 2020 16:51:39 +0100
From: Marc Zyngier <maz@kernel.org>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 17/21] KVM: arm64: Use common code's approach for
 __GFP_ZERO with memory caches
In-Reply-To: <20200611154359.GF29918@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-18-sean.j.christopherson@intel.com>
 <6cc08074c289cbea7b9c1deeaf18c63f@kernel.org>
 <20200611154359.GF29918@linux.intel.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <12ec535821111d503773d6f623047d27@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, paulus@ozlabs.org,
 borntraeger@de.ibm.com, frankja@linux.ibm.com, pbonzini@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
 vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
 joro@8bytes.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org, pfeiner@google.com,
 pshier@google.com, junaids@google.com, bgardon@google.com,
 christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Ben Gardon <bgardon@google.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>
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

On 2020-06-11 16:43, Sean Christopherson wrote:
> On Thu, Jun 11, 2020 at 08:59:05AM +0100, Marc Zyngier wrote:
>> >diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> >index 9398b66f8a87..688213ef34f0 100644
>> >--- a/arch/arm64/kvm/mmu.c
>> >+++ b/arch/arm64/kvm/mmu.c
>> >@@ -131,7 +131,8 @@ static int mmu_topup_memory_cache(struct
>> >kvm_mmu_memory_cache *cache, int min)
>> > 	if (cache->nobjs >= min)
>> > 		return 0;
>> > 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
>> >-		page = (void *)__get_free_page(GFP_PGTABLE_USER);
>> >+		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT |
>> 
>> This is definitely a change in the way we account for guest
>> page tables allocation, although I find it bizarre that not
>> all architectures account for it the same way.
> 
> It's not intended to be a functional change, i.e. the allocations 
> should
> still be accounted:
> 
>   #define GFP_PGTABLE_USER  (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
>   |
>   -> #define GFP_PGTABLE_KERNEL        (GFP_KERNEL | __GFP_ZERO)
> 
>   == GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO
> 
> versus
> 
>   #define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)
> 
>     with __GFP_ZERO explicitly OR'd in
> 
>   == GFP_KERNEL | __GFP_ACCOUNT | __GFP_ZERO
> 
> I can put the above in the changelog, unless of course it's wrong and 
> I've
> missed something.

Ah, good point. Serves me right for judging the symbol at face value! 
;-)
I guess a quick mention in the changelog wouldn't hurt.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
