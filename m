Return-Path: <SRS0=oSDe=EA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0D4C388F7
	for <kvmarm@archiver.kernel.org>; Sun, 25 Oct 2020 22:27:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 31B74222C2
	for <kvmarm@archiver.kernel.org>; Sun, 25 Oct 2020 22:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cMOhFnV8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31B74222C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A99D4BB68;
	Sun, 25 Oct 2020 18:27:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gKWn-NsvidB3; Sun, 25 Oct 2020 18:27:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 80CFD4BB7D;
	Sun, 25 Oct 2020 18:27:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0DF24BB70
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Oct 2020 18:27:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ttXBZOr046Z for <kvmarm@lists.cs.columbia.edu>;
 Sun, 25 Oct 2020 18:27:45 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2A84BB68
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Oct 2020 18:27:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1603664865;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=fc6Wc/tM4Lhn+mkq5GzT0PLSJugPSj6zN4yvXTZ8zv0=;
 b=cMOhFnV8E8q6UEcTLFxCkLNBgcco5o3rg+CPd1Fi4bzqKdUGIZykdLIZb2/0Yx/uBGFn8P
 vXGLKLGTMHXfvPE0f0KWFRLBFoe8nOrT6kxRQWl26m58LxiW4cwUyEqwRF5/Oho4WclawT
 4F1ZqHL3cx8Z0yFR+vZk7pb2LdDzSj0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-SpX1ey7SPEentKBfC_fSzg-1; Sun, 25 Oct 2020 18:27:43 -0400
X-MC-Unique: SpX1ey7SPEentKBfC_fSzg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 063BF1006C8C;
 Sun, 25 Oct 2020 22:27:42 +0000 (UTC)
Received: from [10.64.54.35] (vpn2-54-35.bne.redhat.com [10.64.54.35])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 457A31043263;
 Sun, 25 Oct 2020 22:27:39 +0000 (UTC)
Subject: Re: [PATCH 2/3] KVM: arm64: Don't map PUD huge page if it's not
 available
To: Marc Zyngier <maz@kernel.org>
References: <20201025002739.5804-1-gshan@redhat.com>
 <20201025002739.5804-3-gshan@redhat.com> <87zh4aoc22.wl-maz@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <3d4b80e6-95c4-4634-5e7e-a53ef3af0d75@redhat.com>
Date: Mon, 26 Oct 2020 09:27:36 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87zh4aoc22.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Marc,

On 10/25/20 9:05 PM, Marc Zyngier wrote:
> On Sun, 25 Oct 2020 01:27:38 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>>
>> PUD huge page isn't available when CONFIG_ARM64_4K_PAGES is disabled.
>> In this case, we needn't try to map the memory through PUD huge pages
>> to save some CPU cycles in the hot path.
>>
>> This also corrects the code style issue, which was introduced by
>> commit <523b3999e5f6> ("KVM: arm64: Try PMD block mappings if PUD mappings
>> are not supported").
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index a816cb8e619b..0f51585adc04 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -787,9 +787,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>   		vma_shift = PAGE_SHIFT;
>>   	}
>>   
>> +#ifdef CONFIG_ARM64_4K_PAGES
>>   	if (vma_shift == PUD_SHIFT &&
>>   	    !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
>> -	       vma_shift = PMD_SHIFT;
>> +		vma_shift = PMD_SHIFT;
>> +#endif
>>   
>>   	if (vma_shift == PMD_SHIFT &&
>>   	    !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> 
> 
> I really don't buy the "CPU cycles" argument here either. Can you
> actually measure any difference here?
> 
> You have taken a fault, gone through a full guest exit, triaged it,
> and are about to into a page mapping operation which may result in a
> TLBI, and reenter the guest. It only happen a handful of times per
> page over the lifetime of the guest unless you start swapping. Hot
> path? I don't think so.
> 

Thanks for the explanation. Agreed and I will drop this in v2.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
