Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B483C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:18:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C9068208B8
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:18:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ifrTjFg/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9068208B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FE674B1D1;
	Wed, 27 May 2020 03:18:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cmvejE0gaZ22; Wed, 27 May 2020 03:18:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D0264B20A;
	Wed, 27 May 2020 03:18:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69E994B173
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 22:55:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cGGs-uNO+z8H for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2020 22:55:19 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77E1F4B14B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 22:55:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1590548119;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=l4K9Ld8nvFhhrcUkF46+uYVzHz+spBxIeBhQGnUCsLs=;
 b=ifrTjFg/lYKP850PBruJP5HOdVr23YW4PXY/JiCW4ETN9jdneMScnnlHbjmY4u7cxIKK9l
 92TvwyZK92z5lc1E2ZEl/dwAfZwNkwYWfWSLNvrSva0FhDUIZLIK//KHtOpkiXPwNaDEUx
 xUh9erK3+ZwPLO2MKMxM7p4s/fPb1Cs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-vg8k3xqlP2uyYE5pKH1NJA-1; Tue, 26 May 2020 22:55:15 -0400
X-MC-Unique: vg8k3xqlP2uyYE5pKH1NJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B61EC10753FB;
 Wed, 27 May 2020 02:55:13 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-130.bne.redhat.com
 [10.64.54.130])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2852E5D9E7;
 Wed, 27 May 2020 02:55:06 +0000 (UTC)
Subject: Re: [PATCH RFCv2 4/9] kvm/arm64: Detach ESR operator from vCPU struct
To: Mark Rutland <mark.rutland@arm.com>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-5-gshan@redhat.com>
 <20200526105154.GD1363@C02TD0UTHF1T.local>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <4cda1e43-8f96-4e48-2642-39a5545905c0@redhat.com>
Date: Wed, 27 May 2020 12:55:04 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200526105154.GD1363@C02TD0UTHF1T.local>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mailman-Approved-At: Wed, 27 May 2020 03:18:39 -0400
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Mark,

On 5/26/20 8:51 PM, Mark Rutland wrote:
> On Fri, May 08, 2020 at 01:29:14PM +1000, Gavin Shan wrote:
>> There are a set of inline functions defined in kvm_emulate.h. Those
>> functions reads ESR from vCPU fault information struct and then operate
>> on it. So it's tied with vCPU fault information and vCPU struct. It
>> limits their usage scope.
>>
>> This detaches these functions from the vCPU struct. With this, the
>> caller has flexibility on where the ESR is read. It shouldn't cause
>> any functional changes.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h     | 83 +++++++++++-------------
>>   arch/arm64/kvm/handle_exit.c             | 20 ++++--
>>   arch/arm64/kvm/hyp/switch.c              | 24 ++++---
>>   arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  7 +-
>>   arch/arm64/kvm/inject_fault.c            |  4 +-
>>   arch/arm64/kvm/sys_regs.c                | 12 ++--
>>   virt/kvm/arm/arm.c                       |  4 +-
>>   virt/kvm/arm/hyp/aarch32.c               |  2 +-
>>   virt/kvm/arm/hyp/vgic-v3-sr.c            |  5 +-
>>   virt/kvm/arm/mmio.c                      | 27 ++++----
>>   virt/kvm/arm/mmu.c                       | 22 ++++---
>>   11 files changed, 112 insertions(+), 98 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
>> index bd1a69e7c104..2873bf6dc85e 100644
>> --- a/arch/arm64/include/asm/kvm_emulate.h
>> +++ b/arch/arm64/include/asm/kvm_emulate.h
>> @@ -270,10 +270,8 @@ static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
>>   	return vcpu->arch.fault.esr_el2;
>>   }
>>   
>> -static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
>> +static __always_inline int kvm_vcpu_get_condition(u32 esr)
> 
> Given the `vcpu` argument has been removed, it's odd to keep `vcpu` in the
> name, rather than `esr`.
> 
> e.g. this would make more sense as something like esr_get_condition().
> 
> ... and if we did something like that, we could move most of the
> extraction functions into <asm/esr.h>, and share them with non-KVM code.
> 
> Otherwise, do you need to extract all of these for your use-case, or do
> you only need a few of the helpers? If you only need a few, it might be
> better to only factor those out for now, and keep the existing API in
> place with wrappers, e.g. have:
> 
> | esr_get_condition(u32 esr) {
> | 	...
> | }
> |
> | kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
> | {
> | 	return esr_get_condition(kvm_vcpu_get_esr(vcpu));
> | }
> 

Sure, I'll follow approach#1, to move these helper functions to asm/esr.h
and with "vcpu" dropped in their names. I don't think it makes sense to
maintain two sets of helper functions for the simple logic. So the helper
function will be called where they should be, as below:

    esr_get_condition(u32 esr) { ... }
    
    bool __hyp_text kvm_condition_valid32(const struct kvm_vcpu *vcpu)
    {
         int cond = esr_get_condition(kvm_vcpu_get_esr(vcpu));
         :
    }

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
