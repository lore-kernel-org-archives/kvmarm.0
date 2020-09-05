Return-Path: <SRS0=ERU5=CO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D28C43461
	for <kvmarm@archiver.kernel.org>; Sat,  5 Sep 2020 03:56:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E374920C56
	for <kvmarm@archiver.kernel.org>; Sat,  5 Sep 2020 03:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJPj2WVA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E374920C56
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D1024B2BB;
	Fri,  4 Sep 2020 23:56:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dTcHMiV8hnMQ; Fri,  4 Sep 2020 23:56:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DCB74B312;
	Fri,  4 Sep 2020 23:56:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 024E94B2BB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 23:56:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ma11v4YgmZ-Q for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 23:56:49 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5666E4B227
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 23:56:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599278209;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=AzVE8XsOaDOKlySyVREn2RUKhP9ET5IL66EaN6qbs7o=;
 b=EJPj2WVAW2nCmN5uAKuo2k6DH+cqudYETYjcM0lk+jRsXZOS8OK5ttnCHJfXT2/MthgX0W
 XyINqaZGOXe3/0ofUoLFHCWvpVs9rLY9PbL62L9g3ZKyIgnUTQ7DEqfQ3suxnYGXzAg94O
 ZvTRXQnLyXLacTganuRqzQ6wAdR40ks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-ilt8NMq-M8KOwLKmL9wI3w-1; Fri, 04 Sep 2020 23:56:47 -0400
X-MC-Unique: ilt8NMq-M8KOwLKmL9wI3w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A6301DDEA;
 Sat,  5 Sep 2020 03:56:45 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B0F97ED6F;
 Sat,  5 Sep 2020 03:56:42 +0000 (UTC)
Subject: Re: [PATCH v3 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
To: Marc Zyngier <maz@kernel.org>
References: <20200825093953.26493-1-will@kernel.org>
 <f7e20f9c-e14e-5314-f78f-1d73743da84c@redhat.com>
 <3f13fc6e-7234-6c53-cfaa-a5052fcabe6d@redhat.com>
 <29ec59b6-ca36-1bd0-0d19-097ecb999bb2@redhat.com>
 <20200903121651.GA7412@willie-the-truck>
 <5aa43d21-30a1-68c8-2620-60a25e4edfa2@redhat.com>
 <fa494886b9a88ec7b02141f2da44d5a7@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ad9bb6bc-63e1-af3b-4dfb-b32b11f8f356@redhat.com>
Date: Sat, 5 Sep 2020 13:56:39 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <fa494886b9a88ec7b02141f2da44d5a7@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

Hi Marc,

On 9/4/20 8:07 PM, Marc Zyngier wrote:
> On 2020-09-04 01:51, Gavin Shan wrote:
>> On 9/3/20 10:16 PM, Will Deacon wrote:
>>> On Thu, Sep 03, 2020 at 09:48:18PM +1000, Gavin Shan wrote:
>>>> On 9/3/20 9:13 PM, Gavin Shan wrote:
>>>>> On 9/3/20 5:34 PM, Gavin Shan wrote:
>>>>>> On 8/25/20 7:39 PM, Will Deacon wrote:

[...]

>>
>> Since the the following changes have been folded to v4, I reran the test cases
>> on v4 and everything works fine.
> 
> Thanks a lot for the great testing and reviewing effort!
> 
> <shameless ask>
> Since you obviously have a test rig setup for this: does your TX2 support 16kB
> pages? If so, could you please do another run with this page size on the host?
> </shameless ask>
> 

My TX2 machine doesn't support 16KB page size unfortunately. The
following output was seen from host when it has 16KB page size.
Sorry about it.

    CONFIG_ARM64_PAGE_SHIFT=14
    CONFIG_ARM64_VA_BITS_47=y
    CONFIG_ARM64_VA_BITS=47

Output from console on host
===========================
EFI stub: ERROR: This 16 KB granular kernel is not supported by your CPU

   Failed to boot both default and fallback entries.

Press any key to continue...
    
Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
