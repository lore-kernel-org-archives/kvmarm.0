Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D57C433FE
	for <kvmarm@archiver.kernel.org>; Mon, 17 Oct 2022 22:52:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E121C4B74F;
	Mon, 17 Oct 2022 18:52:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2mPIjAOEgUa8; Mon, 17 Oct 2022 18:52:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBD7D4B752;
	Mon, 17 Oct 2022 18:52:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB7644B743
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 18:52:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XYhiMIY2dwPz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Oct 2022 18:52:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D79F44B71F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Oct 2022 18:52:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1666047130;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=BWe/EjtyWVO+y3GfQQyNMelxnpZ9v4boUm/j1qFurps=;
 b=KfCK5HB0tlZcnLs9mbo2C0maeT71rtyhSMgzWFOnMwv9YBtCNKW98iBPiLhfv1moQWKBAb
 1tfu8g5hFzgCGg1qQI/KdJn3nxyGTO3sfd8MYX0cFYc/rQSqQeqP/0n1941Qviapd9Fj1V
 1zIORPNFcJ6oz3VpW5G8NoXVXPguf6A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-4flLiffaMOGRRY96vvlOcA-1; Mon, 17 Oct 2022 18:52:06 -0400
X-MC-Unique: 4flLiffaMOGRRY96vvlOcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9F5D185A79C;
 Mon, 17 Oct 2022 22:51:58 +0000 (UTC)
Received: from [10.64.54.70] (vpn2-54-70.bne.redhat.com [10.64.54.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DBCA14657C0;
 Mon, 17 Oct 2022 22:51:34 +0000 (UTC)
Subject: Re: [PATCH 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
 sizes
To: Sean Christopherson <seanjc@google.com>,
 "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
References: <20221014071914.227134-1-gshan@redhat.com>
 <20221014071914.227134-6-gshan@redhat.com>
 <cebafa0d-a2dc-c3f7-64c8-2637a254e3d0@maciej.szmigiero.name>
 <Y03ScGUUCA1KwlLF@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <9781c88f-06f9-4d17-8fa6-3cd82a739ccb@redhat.com>
Date: Tue, 18 Oct 2022 06:51:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y03ScGUUCA1KwlLF@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 zhenyzha@redhat.com, shan.gavin@gmail.com, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, shuah@kernel.org, kvmarm@lists.cs.columbia.edu,
 ajones@ventanamicro.com
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

On 10/18/22 6:08 AM, Sean Christopherson wrote:
> On Mon, Oct 17, 2022, Maciej S. Szmigiero wrote:
>>> +#define MEM_EXTRA_SIZE		0x10000
>>
>> Also, an expression like "(64 << 10)" is more readable than a "1"
>> with a tail of zeroes (it's easy to add one zero too many or be one
>> zero short).
> 
> +1 to not open coding raw numbers.
> 
> I think it's high time KVM selftests add #defines for the common sizes, e.g. SIZE_4KB,
> 16KB, 64K, 2MB, 1GB, etc...
> 
> Alternatively (or in addition), just #define 1KB, 1MB, 1GB, and 1TB, and then do
> math off of those.
> 

Ok. I will have one separate patch to define those sizes in kvm_util_base.h,
right after '#define NSEC_PER_SEC 1000000000L'. Sean, could you let me know
if it looks good to you?

     #define KB         (1UL << 10)
     #define MB         (1UL << 20)
     #define GB         (1UL << 30)
     #define TB         (1UL << 40)

     /* Base page and huge page size */
     #define SIZE_4KB   (  4 * KB)
     #define SIZE_16KB  ( 16 * KB)
     #define SIZE_64KB  ( 64 * KB)
     #define SIZE_2MB   (  2 * MB)
     #define SIZE_32MB  ( 32 * MB)
     #define SIZE_512MB (512 * MB)
     #define SIZE_1GB   (  1 * GB)
     #define SIZE_16GB  ( 16 * GB)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
