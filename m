Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D146C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 14:43:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98AA66120E
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 14:43:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 98AA66120E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 182894B14C;
	Thu,  9 Sep 2021 10:43:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UTw8lFHlHD1B; Thu,  9 Sep 2021 10:43:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0718A4B154;
	Thu,  9 Sep 2021 10:43:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15ED74B14C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 10:43:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t8O7EatPDwaZ for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Sep 2021 10:43:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 193414B08E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Sep 2021 10:43:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631198595;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=NXI4TwfF9ATuisncE0UeLZfKMl4lBSArTcS01RD5hDM=;
 b=Fh1HbL9mwPFTDMGnj0tCBBh0PsoVlk7z3OzkSBeKULFrIRxzg1PmsEnC6nFETkojHSHuRh
 e3URA96qlV0GIcalDuXGDlo67EiFOK6sc7JpEAod5hZJU9aSNO9FIudhjF44GjgG9n1hfD
 tPw80kLbgnrd1YwrjVEYoYWLRBQ++4Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-ooPbhaCKPOG-M97eYTveYA-1; Thu, 09 Sep 2021 10:43:14 -0400
X-MC-Unique: ooPbhaCKPOG-M97eYTveYA-1
Received: by mail-wr1-f69.google.com with SMTP id
 d10-20020adffbca000000b00157bc86d94eso580296wrs.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Sep 2021 07:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=NXI4TwfF9ATuisncE0UeLZfKMl4lBSArTcS01RD5hDM=;
 b=tTaZmStn7JlWQXI8LiyydcigivhkNoMUDXUJo0W5pG+UxEqt876v5IDCguRCQIHVe2
 LM7m6Yb/iOMFppuKvYhp3bnbakZwKdrGwaKiH0zh5ZM0DGRZ+FRyenNGXXrBFm9mD1MP
 o5oRrqzimJdzRcvoWY5f+r1ZEjAhW2L1bqyZE72fVcOCvgZxdQgidXViovzAs/fNnb9b
 kph5E6a80j2nuJ+McHt1bff5zYZu6ucvPmB9coZyhmG8Q2nKonoJRsCJq8vCxkY8iFtY
 FhJmzSoKY66mptrAtYUldsLuCAKbvz4h3jtG8ymIM00zRzcUS8kHx79EHdj5AJ5cmsO+
 jmRA==
X-Gm-Message-State: AOAM531eKNQeiq3NMS1IVv7Gp1jDQN7b63vDTfC9MdwpczE2hXbJNw4l
 Ckyy9RfUWQEUBnzn/zMOlzofoutH0QlSoeDAgMzCNfWsTTBW+jyaHmXti+0h449Pxggcud8hRYM
 4akpqVwE1g9148Mn0AWdaQgjL
X-Received: by 2002:adf:ea4d:: with SMTP id j13mr4019752wrn.86.1631198593659; 
 Thu, 09 Sep 2021 07:43:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1LuTiwsjnrgw/0AGWEEOKwqU3QmylhI8y8zAc70bSBImbu5FbUVlcZZAs/ShC2AxuK5Z4Jw==
X-Received: by 2002:adf:ea4d:: with SMTP id j13mr4019708wrn.86.1631198593387; 
 Thu, 09 Sep 2021 07:43:13 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id a5sm1748509wmm.44.2021.09.09.07.43.11
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Sep 2021 07:43:12 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, drjones@redhat.com
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <bd905ebe-f786-9d5b-d19d-03ff5fa1ba14@redhat.com>
Date: Thu, 9 Sep 2021 16:43:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

Hi,

On 9/9/21 12:20 PM, Alexandru Elisei wrote:
> Hi Ricardo,
>
> On 9/8/21 10:03 PM, Ricardo Koller wrote:
>> Extend vgic_v3_check_base() to verify that the redistributor regions
>> don't go above the VM-specified IPA size (phys_size). This can happen
>> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
>>
>>   base + size > phys_size AND base < phys_size
>>
>> vgic_v3_check_base() is used to check the redist regions bases when
>> setting them (with the vcpus added so far) and when attempting the first
>> vcpu-run.
>>
>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>> index 66004f61cd83..5afd9f6f68f6 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
>>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
>>  			rdreg->base)
>>  			return false;
>> +
>> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
>> +			kvm_phys_size(kvm))
>> +			return false;
> Looks to me like this same check (and the overflow one before it) is done when
> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set_redist_base()
> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as I can tell,
> kvm_vgic_addr() handles both ways of setting the Redistributor address.
To me vgic_check_ioaddr() does check the base addr but not the end addr.
So looks this fix is needed.
As I commented on the selftest patch, I think you should double check
your fix also handles the KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION case.

In vgic_v3_alloc_redist_region(), in this later case, we know the number
of redistributors in the region (count), so it would be easy to check
the end addr. But I think this would be a duplicate of your new check as
vgic_v3_check_base() also gets called in vgic_register_redist_iodev().
But better to check it ;-)

Thanks

Eric
>
> Without this patch, did you manage to set a base address such that base + size >
> kvm_phys_size()?
>
> Thanks,
>
> Alex
>
>>  	}
>>  
>>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
