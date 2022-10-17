Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A258BC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 23:39:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 248EC4B795;
	Mon, 17 Oct 2022 19:39:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ni9gioYooQik; Mon, 17 Oct 2022 19:39:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA2364B743;
	Mon, 17 Oct 2022 19:39:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B8784B712
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 19:39:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DwuKQiwS8ZW6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 19:39:38 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A099A4B703
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 19:39:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666049978;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WwpNKvZ1k9hvxd4EsdsmzQsZ3dK8aE102L/H4wxIMmw=;
 b=djVvf9pev5IbSXHAM1PE5RW43F/oF4l1UIeVMc71okdG9Nvpxy2c9uowczzUxo6UIAmW2V
 NkvWQc2ywa+edKvDY8QGCXlf+jSd+74nTvyQMDDwhbkm2vBk/Zmmk29cpGzuduh15fH03G
 sO7DdUhzH+oQYiIuhUm7S6vohKuyYYw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-nxcmOr-ONWiUw7eVpjW6dw-1; Mon, 17 Oct 2022 19:39:33 -0400
X-MC-Unique: nxcmOr-ONWiUw7eVpjW6dw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62BD985A583;
 Mon, 17 Oct 2022 23:39:32 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A55D111D795;
 Mon, 17 Oct 2022 23:39:26 +0000 (UTC)
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
To: Sean Christopherson <seanjc@google.com>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
 <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
 <93529fb7-f558-cc5f-d5bd-7923eb4b492c@maciej.szmigiero.name>
 <fd6287fc-c56f-4c08-0885-8ab32fdfeb7e@redhat.com>
 <Y03l+kwGxNW1Icp/@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <c1442e8f-e86e-abee-fb4e-6f4a95697d17@redhat.com>
Date: Tue, 18 Oct 2022 07:39:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y03l+kwGxNW1Icp/@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Cc: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>, kvm@vger.kernel.org,
 maz@kernel.org, linux-kernel@vger.kernel.org, zhenyzha@redhat.com,
 shan.gavin@gmail.com, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu, ajones@ventanamicro.com
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
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 10/18/22 7:32 AM, Sean Christopherson wrote:
> On Tue, Oct 18, 2022, Gavin Shan wrote:
>> On 10/18/22 6:56 AM, Maciej S. Szmigiero wrote:
>>> On 18.10.2022 00:51, Gavin Shan wrote:
>>>> On 10/18/22 6:08 AM, Sean Christopherson wrote:
>>>>> On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
>>>>>>> +#define MEM_EXTRA_SIZE=A0=A0=A0=A0=A0=A0=A0 0x10000
>>>>>>
>>>>>> Also, an expression like "(64 << 10)" is more readable than a "1"
>>>>>> with a tail of zeroes (it's easy to add one zero too many or be one
>>>>>> zero short).
>>>>>
>>>>> +1 to not open coding raw numbers.
>>>>>
>>>>> I think it's high time KVM selftests add #defines for the common size=
s, e.g. SIZE_4KB,
>>>>> 16KB, 64K, 2MB, 1GB, etc...
>>>>>
>>>>> Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, =
and then do
>>>>> math off of those.
>>>>>
>>>>
>>>> Ok. I will have one separate patch to define those sizes in kvm_util_b=
ase.h,
>>>> right after '#define NSEC_PER_SEC 1000000000L'. Sean, could you let me=
 know
>>>> if it looks good to you?
>>>>
>>>>  =A0=A0=A0=A0 #define KB=A0=A0=A0=A0=A0=A0=A0=A0 (1UL << 10)
>>>>  =A0=A0=A0=A0 #define MB=A0=A0=A0=A0=A0=A0=A0=A0 (1UL << 20)
>>>>  =A0=A0=A0=A0 #define GB=A0=A0=A0=A0=A0=A0=A0=A0 (1UL << 30)
>>>>  =A0=A0=A0=A0 #define TB=A0=A0=A0=A0=A0=A0=A0=A0 (1UL << 40)
> =

> Any objection to prefixing these with SIZE_ as well?  IMO it's worth burn=
ing the
> extra five characters to make it all but impossible to misinterpret code.
> =


'SIZE_' prefix works for me either.

>>>>  =A0=A0=A0=A0 /* Base page and huge page size */
>>>>  =A0=A0=A0=A0 #define SIZE_4KB=A0=A0 (=A0 4 * KB)
>>>>  =A0=A0=A0=A0 #define SIZE_16KB=A0 ( 16 * KB)
>>>>  =A0=A0=A0=A0 #define SIZE_64KB=A0 ( 64 * KB)
>>>>  =A0=A0=A0=A0 #define SIZE_2MB=A0=A0 (=A0 2 * MB)
>>>>  =A0=A0=A0=A0 #define SIZE_32MB=A0 ( 32 * MB)
>>>>  =A0=A0=A0=A0 #define SIZE_512MB (512 * MB)
>>>>  =A0=A0=A0=A0 #define SIZE_1GB=A0=A0 (=A0 1 * GB)
>>>>  =A0=A0=A0=A0 #define SIZE_16GB=A0 ( 16 * GB)
>>>
>>> FYI, QEMU uses KiB, MiB, GiB, etc., see [1].
>>>
>>
>> Right. I checked QEMU's definitions and it makes sense to use
>> KiB, MiB, GiB, TiB. I don't think we need PiB and EiB because
>> our tests don't use that large memory.
> =

> Ha!  I had typed out KiB, etc... but then thought, "nah, I'm being silly"=
.  KiB
> and friends work for me.
> =


Thanks for your confirm, Sean.

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
