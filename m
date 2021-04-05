Return-Path: <SRS0=Uj0Q=JC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041C2C43460
	for <kvmarm@archiver.kernel.org>; Mon,  5 Apr 2021 16:28:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 739016139E
	for <kvmarm@archiver.kernel.org>; Mon,  5 Apr 2021 16:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 739016139E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 080A94BB71;
	Mon,  5 Apr 2021 12:28:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gFVWiJbfVfHW; Mon,  5 Apr 2021 12:28:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB2404BBA9;
	Mon,  5 Apr 2021 12:28:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E1064BB23
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Apr 2021 12:28:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wl0fn9oyO9rw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Apr 2021 12:28:12 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A875B4BB0C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Apr 2021 12:28:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617640092;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=hDd+iS7d84828C4DpW9QT8Bs3288njEXcR/TmjGMo4A=;
 b=IL2a6ZR/bRP8Q61sHuN9vhwJvMEFudAptRlD5aOmOgpQHAG6gC9Wl4jvodl6Ul/ZQztJQb
 dwnwz3I1hcHT3IpgYPymy0HqnTqBTxh1T7eBdWPUYkq6fb4UdkKKELjRgYa4Mgpfx12jSd
 UpCVDXUOICp5SisBrTJUDIbNHxUI8pY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-NRQnBzeRMQywXtGu3YgRkw-1; Mon, 05 Apr 2021 12:28:08 -0400
X-MC-Unique: NRQnBzeRMQywXtGu3YgRkw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E81258189C6;
 Mon,  5 Apr 2021 16:28:06 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FA9310016DB;
 Mon,  5 Apr 2021 16:28:00 +0000 (UTC)
Subject: Re: [PATCH v5 7/8] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for
 userspace
To: Marc Zyngier <maz@kernel.org>
References: <20210404172243.504309-1-eric.auger@redhat.com>
 <20210404172243.504309-8-eric.auger@redhat.com>
 <878s5xf3ed.wl-maz@kernel.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <f9788cb1-59c4-f936-89a2-40784a1c1500@redhat.com>
Date: Mon, 5 Apr 2021 18:27:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <878s5xf3ed.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: kvm@vger.kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

Hi Marc,

On 4/5/21 12:10 PM, Marc Zyngier wrote:
> On Sun, 04 Apr 2021 18:22:42 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> Commit 23bde34771f1 ("KVM: arm64: vgic-v3: Drop the
>> reporting of GICR_TYPER.Last for userspace") temporarily fixed
>> a bug identified when attempting to access the GICR_TYPER
>> register before the redistributor region setting, but dropped
>> the support of the LAST bit.
>>
>> Emulating the GICR_TYPER.Last bit still makes sense for
>> architecture compliance though. This patch restores its support
>> (if the redistributor region was set) while keeping the code safe.
>>
>> We introduce a new helper, vgic_mmio_vcpu_rdist_is_last() which
>> computes whether a redistributor is the highest one of a series
>> of redistributor contributor pages.
>>
>> With this new implementation we do not need to have a uaccess
>> read accessor anymore.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v4 -> v5:
>> - redist region list now is sorted by @base
>> - change the implementation according to Marc's understanding of
>>   the spec
>> ---
>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 58 +++++++++++++++++-------------
>>  include/kvm/arm_vgic.h             |  1 +
>>  2 files changed, 34 insertions(+), 25 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index e1ed0c5a8eaa..03a253785700 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -251,45 +251,52 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
>>  		vgic_enable_lpis(vcpu);
>>  }
>>  
>> +static bool vgic_mmio_vcpu_rdist_is_last(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	struct vgic_redist_region *iter, *rdreg = vgic_cpu->rdreg;
>> +
>> +	if (!rdreg)
>> +		return false;
>> +
>> +	if (vgic_cpu->rdreg_index < rdreg->free_index - 1) {
>> +		return false;
>> +	} else if (rdreg->count && vgic_cpu->rdreg_index == (rdreg->count - 1)) {
>> +		struct list_head *rd_regions = &vgic->rd_regions;
>> +		gpa_t end = rdreg->base + rdreg->count * KVM_VGIC_V3_REDIST_SIZE;
>> +
>> +		/*
>> +		 * the rdist is the last one of the redist region,
>> +		 * check whether there is no other contiguous rdist region
>> +		 */
>> +		list_for_each_entry(iter, rd_regions, list) {
>> +			if (iter->base == end && iter->free_index > 0)
>> +				return false;
>> +		}
> 
> In the above notes, you state that the region list is now sorted by
> base address, but I really can't see what sorts that list. And the
> lines above indicate that you are still iterating over the whole RD
> regions.
> 
> It's not a big deal (the code is now simple enough), but that's just
> to confirm that I understand what is going on here.

Sorry I should have removed the notes. I made the change but then I
noticed that the list was already sorted by redistributor region index
as the API forbids to register rdist regions in non ascending index
order. So sorting by base address was eventually causing more trouble
than it helped.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
