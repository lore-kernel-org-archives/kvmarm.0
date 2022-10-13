Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68CFC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 13 Oct 2022 16:42:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27BA949DE3;
	Thu, 13 Oct 2022 12:42:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L-oIRJ0cjM0h; Thu, 13 Oct 2022 12:42:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C153B401AF;
	Thu, 13 Oct 2022 12:42:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ABBD401AF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 12:42:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H9wk2pfUE5zk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Oct 2022 12:42:39 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1168340159
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 12:42:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665679358;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=YBQyFVBuF/SKjPazJHlLgOwvTK+5LZv1rrMgf1acIpo=;
 b=UNh3qgWB0WuuTanztXND36jQumAVSFvJ10YaDwWQL+QxqSRI5zJ74YDtWVGeRMdGy+IFIV
 r9pbi25m+zt2xI306TlKicbWijDIwgiW7Y1xgQqHKHg7YHHOZIk7HU7Q11k/NZijfU9a8B
 kYH/scNUWkyTvMNgvD/f7F7gY0wNzg0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-564-b2nqHJPjMFKFAYfHoWm2bA-1; Thu, 13 Oct 2022 12:42:36 -0400
X-MC-Unique: b2nqHJPjMFKFAYfHoWm2bA-1
Received: by mail-wm1-f70.google.com with SMTP id
 k38-20020a05600c1ca600b003b49a809168so3171223wms.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Oct 2022 09:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=YBQyFVBuF/SKjPazJHlLgOwvTK+5LZv1rrMgf1acIpo=;
 b=ih/PctIQMSp/lCWTy8ppMsXJNsK9/Hn5sVoDFX2E9Gxvz+bh1+Z3TIOHRjYY73/ap2
 5t7qRxbeSF4HPhXPr+ut54/PY6oSJTzBLopMI3BcqdicVKtzAAhBDAaIhCNRvqpCNcfq
 x6ULGJawborZ+JFpeN0zsVU5oekKsDNW1Yw/aNvWlV4bdwd9aodFy3iCKSLHVz43HIOU
 cD2xU5abe1Pl530hOYlM1lCNpayu+uUJwJIAvflX673X5/eBqFOo/GgS4aIcU/s04cSG
 a/sFen5YUpjSYcqdR6exEhfsfhdB+MnPPMOmUPdqnE4hOlXmNlayjv2mChz2CiRcOAt2
 ACCw==
X-Gm-Message-State: ACrzQf25AsHK3vLThF+ZuQVKO/9wVmMpm7nudu+973sIhLMdaDiqg36L
 46bNOOE/2KIy7QNUMvmSPZCfU3N0eSAaZw/eHgKkypxv6t/ZnNjWBpxi0sID2O3+wBqbToZ+ZLn
 GcOLtt7vnz3N4Bv/FFkcfPtzN
X-Received: by 2002:a05:600c:1912:b0:3c6:e3cf:4335 with SMTP id
 j18-20020a05600c191200b003c6e3cf4335mr740381wmq.81.1665679354001; 
 Thu, 13 Oct 2022 09:42:34 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM63OJlvg+GZtxl6mLYfE9Y5CCeBv34c5qID7pyf4ZqxFTU/m9Khf2eRtYMqinx72PY+/mPmQQ==
X-Received: by 2002:a05:600c:1912:b0:3c6:e3cf:4335 with SMTP id
 j18-20020a05600c191200b003c6e3cf4335mr740365wmq.81.1665679353762; 
 Thu, 13 Oct 2022 09:42:33 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 h5-20020adfe985000000b002322bff5b3bsm52198wrm.54.2022.10.13.09.42.31
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 13 Oct 2022 09:42:32 -0700 (PDT)
Message-ID: <7f071249-b402-9534-c127-40af9379756d@redhat.com>
Date: Thu, 13 Oct 2022 18:42:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: arm64: vgic: fix wrong loop condition in
 scan_its_table()
To: Marc Zyngier <maz@kernel.org>, Eric Ren <renzhengeek@gmail.com>
References: <acd9f1643980fbd27cd22523d2d84ca7c9add84a.1665592448.git.renzhengeek@gmail.com>
 <87o7ughoyf.wl-maz@kernel.org>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <87o7ughoyf.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, kvmarm <kvmarm@lists.cs.columbia.edu>
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

Hi Eric,

On 10/12/22 20:33, Marc Zyngier wrote:
> Hi Eric,
> 
> Before I comment on this patch, a couple of things that need
> addressing:
> 
>> "Cc: marc.zyngier@arm.com, cdall@linaro.org"
> 
> None of these two addresses are valid anymore, and haven't been for
> several years.
> 
> Please consult the MAINTAINERS file for up-to-date addresses for
> current maintainers and reviewers, all of whom should be Cc'd on this
> email. I've now added them as well as Eric Auger who has written most
> of the ITS migration code, and the new mailing list (the Columbia list
> is about to be killed).
> 
> On Wed, 12 Oct 2022 17:59:25 +0100,
> Eric Ren <renzhengeek@gmail.com> wrote:
>>
>> Reproducer hints:
>> 1. Create ARM virt VM with pxb-pcie bus which adds
>>    extra host bridges, with qemu command like:
>>
>> ```
>>   -device pxb-pcie,bus_nr=8,id=pci.x,numa_node=0,bus=pcie.0 \
>>   -device pcie-root-port,..,bus=pci.x \
>>   ...
>>   -device pxb-pcie,bus_nr=37,id=pci.y,numa_node=1,bus=pcie.0 \
>>   -device pcie-root-port,..,bus=pci.y \
>>   ...
>>
>> ```
>> 2. Perform VM migration which calls save/restore device tables.
>>
>> In that setup, we get a big "offset" between 2 device_ids (
>> one is small, another is big), which makes unsigned "len" round
>> up a big positive number, causing loop to continue exceptionally.
> 
> You'll have to spell it out for me here. If you have a very sparse
> device ID and you are only using a single level device table, you are
> bound to have a large len. Now, is the issue that 'size' is so large
> that it is negative as an 'int'? Describing the exact situation you're
> in would help a lot.
> 
>>
>> Signed-off-by: Eric Ren <renzhengeek@gmail.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-its.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
>> index 24d7778d1ce6..673554ef02f9 100644
>> --- a/arch/arm64/kvm/vgic/vgic-its.c
>> +++ b/arch/arm64/kvm/vgic/vgic-its.c
>> @@ -2141,7 +2141,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
>>  			  int start_id, entry_fn_t fn, void *opaque)
>>  {
>>  	struct kvm *kvm = its->dev->kvm;
>> -	unsigned long len = size;
>> +	ssize_t len = size;
> 
> This feels wrong, really. If anything, all these types should be
> unsigned, not signed. Signed types in this context make very little
> sense...

After digging into the code back again, I realized I told you something
wrong. The next_offset is the delta between the current device id and
the next one. The next device can perfectly be in a different L1 device
table, - it is your case actually- , in which case the code is
definitely broken.

So I guess we should rather have a
while (true) {
	../..
	if (byte_offset >= len)
		break;
	len -= byte_offset;
}

You can add a Fixes tag too:
Fixes: 920a7a8fa92a ("KVM: arm64: vgic-its: Add infrastructure for table
lookup")
and cc stable@vger.kernel.org

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
