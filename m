Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0339EC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 03:06:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 69AA84B274;
	Sun,  1 May 2022 23:06:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5HIYfVK40NSQ; Sun,  1 May 2022 23:05:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DC444B10C;
	Sun,  1 May 2022 23:05:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CF6749F5D
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 23:05:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7sUXYFSsoBtp for <kvmarm@lists.cs.columbia.edu>;
 Sun,  1 May 2022 23:05:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24D1249F44
 for <kvmarm@lists.cs.columbia.edu>; Sun,  1 May 2022 23:05:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651460755;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qfBorVSUOCzQ7q3zYlG2+R/WTZRAKdQmUnILyiogGHk=;
 b=EA1i97A2tlkcoU6h/5SpwqMb3V69yNYJ/7NNuYurlukYsjzHHPzNeXT+f8nmj3wG7dOBIW
 eVUX6LHAOMoWXguioIUpeaTR3oeuw6u9TM0RKkxCWsKZnNpHFxf30Aa6d/8iXQo9e1opDX
 F3LcapHA9QjIUpLzj2Chod7hOZgBSsg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-43-6GRA4kaIMLWNyA4Yy77asw-1; Sun, 01 May 2022 23:05:51 -0400
X-MC-Unique: 6GRA4kaIMLWNyA4Yy77asw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38EA61E13783;
 Mon,  2 May 2022 03:05:51 +0000 (UTC)
Received: from [10.72.12.86] (ovpn-12-86.pek2.redhat.com [10.72.12.86])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44B7040869CB;
 Mon,  2 May 2022 03:05:44 +0000 (UTC)
Subject: Re: [PATCH v6 15/18] KVM: arm64: Support SDEI_FEATURES hypercall
To: Oliver Upton <oupton@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-16-gshan@redhat.com> <Ym4uyaGGhPXlnkHQ@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <9a522677-cfee-5a72-af27-8a401546ad14@redhat.com>
Date: Mon, 2 May 2022 11:05:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Ym4uyaGGhPXlnkHQ@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Oliver,

On 5/1/22 2:55 PM, Oliver Upton wrote:
> On Sun, Apr 03, 2022 at 11:39:08PM +0800, Gavin Shan wrote:
>> This supports SDEI_FEATURES hypercall. It's used by guest to
>> retrieve the supported features, which are number of slots for
>> the interrupt binding events and relative mode for the event
>> handler. Currently, none of them is supported.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   arch/arm64/kvm/sdei.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sdei.c b/arch/arm64/kvm/sdei.c
>> index e1f6ab9800ee..ab0b7b5e3191 100644
>> --- a/arch/arm64/kvm/sdei.c
>> +++ b/arch/arm64/kvm/sdei.c
>> @@ -527,6 +527,23 @@ static unsigned long hypercall_reset(struct kvm_vcpu *vcpu, bool private)
>>   	return ret;
>>   }
>>   
>> +static unsigned long hypercall_features(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned long feature = smccc_get_arg(vcpu, 1);
>> +	unsigned long ret;
>> +
>> +	switch (feature) {
>> +	case 0: /* BIND_SLOTS */
>> +	case 1: /* RELATIVE_MODE */
> 
> Can you create macros for these?
> 

Surely I will do. Thanks for your review and comments :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
