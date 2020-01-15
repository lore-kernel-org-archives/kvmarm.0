Return-Path: <SRS0=diMM=3E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6624CC32771
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 17:16:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E0FDB24680
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jan 2020 17:16:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c1Tcc7kt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0FDB24680
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4980F4B10E;
	Wed, 15 Jan 2020 12:16:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9cgVbHr9HYWn; Wed, 15 Jan 2020 12:16:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C21E34B137;
	Wed, 15 Jan 2020 12:16:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FE574B12F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 12:16:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bxp97LcJMNrX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jan 2020 12:16:15 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7122A4B10E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 12:16:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579108575;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=egZNg4z+3DEsO7Uh92E/wohzRqRs+BEyWekqiG5mUKo=;
 b=c1Tcc7kt32z0CrSzSF/DHVaGMV8ssxdI+Y1KPBo6gIceatTgj2y/iKAMb7oT6CR3es5mqd
 yen9F0nfZsR1SYu6ok5W6pDGNA24hpv4Sk9aJlP1liWxdIxwxUS58Nr2DoPFccTTcghJwM
 Cg23VbgW1K9PjYHkmsS8QEh+F9O8fx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-EnYCrDZIOQ21-_2h5WbbuQ-1; Wed, 15 Jan 2020 12:16:11 -0500
X-MC-Unique: EnYCrDZIOQ21-_2h5WbbuQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94A881022902;
 Wed, 15 Jan 2020 17:16:09 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 946751081318;
 Wed, 15 Jan 2020 17:16:06 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 06/16] arm/arm64: ITS: Test BASER
To: Andrew Jones <drjones@redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-7-eric.auger@redhat.com>
 <20200113172110.27p3bgozit6djf7k@kamzik.brq.redhat.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <823a0516-6c20-b1f3-49ca-3c0379c353f3@redhat.com>
Date: Wed, 15 Jan 2020 18:16:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200113172110.27p3bgozit6djf7k@kamzik.brq.redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Cc: thuth@redhat.com, kvm@vger.kernel.org, maz@kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
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

Hi,

On 1/13/20 6:21 PM, Andrew Jones wrote:
> On Fri, Jan 10, 2020 at 03:54:02PM +0100, Eric Auger wrote:
>> Add helper routines to parse and set up BASER registers.
>> Add a new test dedicated to BASER<n> accesses.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v2 -> v3:
>> - remove everything related to memory attributes
>> - s/dev_baser/coll_baser/ in report_info
>> - add extra line
>> - removed index filed in its_baser
>> ---
>>  arm/gic.c                | 21 ++++++++++-
>>  arm/unittests.cfg        |  6 +++
>>  lib/arm/asm/gic-v3-its.h | 14 +++++++
>>  lib/arm/gic-v3-its.c     | 80 ++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 120 insertions(+), 1 deletion(-)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index adeb981..3597ac3 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -531,11 +531,26 @@ static void test_its_introspection(void)
>>  		    typer->collid_bits);
>>  	report(typer->eventid_bits && typer->deviceid_bits &&
>>  	       typer->collid_bits, "ID spaces");
>> -	report(!typer->hw_collections, "collections only in ext memory");
>>  	report_info("Target address format %s",
>>  			typer->pta ? "Redist basse address" : "PE #");
>>  }
>>  
>> +static void test_its_baser(void)
>> +{
>> +	struct its_baser *dev_baser, *coll_baser;
>> +
>> +	if (!gicv3_its_base()) {
>> +		report_skip("No ITS, skip ...");
>> +		return;
>> +	}
>> +
>> +	dev_baser = its_lookup_baser(GITS_BASER_TYPE_DEVICE);
>> +	coll_baser = its_lookup_baser(GITS_BASER_TYPE_COLLECTION);
>> +	report(dev_baser && coll_baser, "detect device and collection BASER");
>> +	report_info("device baser entry_size = 0x%x", dev_baser->esz);
>> +	report_info("collection baser entry_size = 0x%x", coll_baser->esz);
>> +}
>> +
>>  int main(int argc, char **argv)
>>  {
>>  	if (!gic_init()) {
>> @@ -571,6 +586,10 @@ int main(int argc, char **argv)
>>  		report_prefix_push(argv[1]);
>>  		test_its_introspection();
>>  		report_prefix_pop();
>> +	} else if (strcmp(argv[1], "its-baser") == 0) {
>> +		report_prefix_push(argv[1]);
>> +		test_its_baser();
>> +		report_prefix_pop();
>>  	} else {
>>  		report_abort("Unknown subtest '%s'", argv[1]);
>>  	}
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index bd20460..2234a0f 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -128,6 +128,12 @@ smp = $MAX_SMP
>>  extra_params = -machine gic-version=3 -append 'its-introspection'
>>  groups = its
>>  
>> +[its-baser]
>> +file = gic.flat
>> +smp = $MAX_SMP
>> +extra_params = -machine gic-version=3 -append 'its-baser'
>> +groups = its
> 
> Do these tests need to be run separately from the its-introspection tests
> for some reason? If not, then I'd combine them.
Not really. To me it is easier to debug and analyze when the fail
though. I will merge both.

Thanks

Eric
> 
> Thanks,
> drew
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
