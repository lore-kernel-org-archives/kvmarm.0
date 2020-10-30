Return-Path: <SRS0=VJ1f=EF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B30C00A89
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 17:52:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1EE6F20706
	for <kvmarm@archiver.kernel.org>; Fri, 30 Oct 2020 17:52:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TacmuVx0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EE6F20706
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 541184B525;
	Fri, 30 Oct 2020 13:52:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dp-5vqCyfVJF; Fri, 30 Oct 2020 13:52:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33FCD4B4D5;
	Fri, 30 Oct 2020 13:52:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A5594B4D5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 13:52:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MIj7VzwuFhDV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Oct 2020 13:52:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49E784B4D2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Oct 2020 13:52:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604080341;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0FU3xcVw/tCjOujHkebRL7DZ5Z6n1GJwYGiBCXs4HDk=;
 b=TacmuVx0d6Mu6aPLfEfzNUUHlYcuuzXuM1S1TDHSvREsmf+HECzQbgqyFm0mVM/hstFrC6
 4s9qpcHtXBFNvSaeR+ejaRpHtvctCgTqbQzxp3Qdb+oSGYHtncGhP69EMTBgIdVsiOSpFL
 98qU911nItEYpfK/b94eM46lpk6F53g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-q7IxCAUYOg6sYhrR9OGljQ-1; Fri, 30 Oct 2020 13:52:18 -0400
X-MC-Unique: q7IxCAUYOg6sYhrR9OGljQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30BFE802B7A;
 Fri, 30 Oct 2020 17:52:17 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B03DD5C22D;
 Fri, 30 Oct 2020 17:52:10 +0000 (UTC)
Subject: Re: [kvm-unit-tests RFC PATCH v2 3/5] arm64: spe: Add introspection
 test
To: Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-4-alexandru.elisei@arm.com>
 <5745ad18-be1a-da91-7289-a48682ad59a5@redhat.com>
 <66ff5a16-1771-9423-9205-5aabb4635c1b@arm.com>
 <c78da5aa-f429-d651-c460-b6cc46d6f188@redhat.com>
 <96204ef8-7afc-2dd4-f226-8efcbacaa564@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <7963b995-78f4-d1cd-54d1-64df42dd26e3@redhat.com>
Date: Fri, 30 Oct 2020 18:52:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <96204ef8-7afc-2dd4-f226-8efcbacaa564@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: pbonzini@redhat.com
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

Hi Alexandru,

On 10/30/20 6:50 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 10/30/20 5:09 PM, Auger Eric wrote:
>> Hi Alexandru,
>>
>> On 10/30/20 4:59 PM, Alexandru Elisei wrote:
>> [..]
>>>>> +	spe.align = 1 << spe.align;
>>>>> +
>>>>> +	pmsidr = read_sysreg_s(SYS_PMSIDR_EL1);
>>>>> +
>>>>> +	interval = (pmsidr >> SYS_PMSIDR_EL1_INTERVAL_SHIFT) & SYS_PMSIDR_EL1_INTERVAL_MASK;
>>>>> +	spe.min_interval = spe_min_interval(interval);
>>>>> +
>>>>> +	spe.max_record_size = (pmsidr >> SYS_PMSIDR_EL1_MAXSIZE_SHIFT) & \
>>>>> +		      SYS_PMSIDR_EL1_MAXSIZE_MASK;
>>>>> +	spe.max_record_size = 1 << spe.max_record_size;
>>>>> +
>>>>> +	spe.countsize = (pmsidr >> SYS_PMSIDR_EL1_COUNTSIZE_SHIFT) & \
>>>>> +			SYS_PMSIDR_EL1_COUNTSIZE_MASK;
>>>>> +
>>>>> +	spe.fl_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FL_SHIFT);
>>>>> +	spe.ft_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FT_SHIFT);
>>>>> +	spe.fe_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FE_SHIFT);
>>>> Why did you remove the report_info() section? I think those human
>>>> readable info can be useful.
>>> I made them part of the test. Since the architecture says they are 1, I think
>>> making sure their value matches is more useful than printing something that the
>>> architecture guarantees.
>> OK for those caps which are always 1 anyway but I was more thinking about
>>
>> report_info("Align= %d bytes, Min Interval=%d Single record Max Size =
>> %d bytes", spe.align, spe.min_interval, spe.maxsize);
>>
>> I'd prefer to keep it.
> 
> Oh, I think I see what you mean, I chose to print them using printf in main().
> This is very similar to what the timer test does, only it does it directly in
> main(), instead of calling another function (print_timer_info(), in the case of
> the timer test). I can move the printfs to spe_probe() if that's what you prefer.
Ah OK I did not notice. Whatever the place if those traces are there I
am fine.

Thanks

Eric
> 
> Thanks,
> 
> Alex
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
