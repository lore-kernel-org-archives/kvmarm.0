Return-Path: <SRS0=0kEf=Z3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0A1C43603
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 09:37:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 81DF12464D
	for <kvmarm@archiver.kernel.org>; Thu,  5 Dec 2019 09:37:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dDwKcV9Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81DF12464D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 239DE4AC87;
	Thu,  5 Dec 2019 04:37:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z4kcUvUqixZR; Thu,  5 Dec 2019 04:37:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 37BFA4ACE6;
	Thu,  5 Dec 2019 04:37:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFD324AC87
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 04:37:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oTNbGzfmpCf0 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Dec 2019 04:37:34 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E118A4A8E8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Dec 2019 04:37:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1575538654;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=RgTZ0Y2VUw+Z4N1mKD1L2XaEnRTLuyDRai6jz97PnGk=;
 b=dDwKcV9Zx3Q5mEMc/LDYJ7bNkNwSmR52byGkqbjaxpmOoRBHuFrQL8Rn2ioJfo1pmPoSnh
 hJvyAOtkuJX/dUpnggM9AqOt8ti4+BhOQPJ4Q46/SLCKL7Ry8MTG1Coo8/BU+A6S1tocQv
 +mNQtbJJk/j5vpiaoo1fQG8sZgdibmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-79-4ieccuSzO8GpALfjAN5pKg-1; Thu, 05 Dec 2019 04:37:29 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 571BF800D5A;
 Thu,  5 Dec 2019 09:37:28 +0000 (UTC)
Received: from [10.36.116.117] (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D78A76E702;
 Thu,  5 Dec 2019 09:37:25 +0000 (UTC)
Subject: Re: [RFC 3/3] KVM: arm64: pmu: Enforce PMEVTYPER evtCount size
To: Will Deacon <will@kernel.org>
References: <20191204204426.9628-1-eric.auger@redhat.com>
 <20191204204426.9628-4-eric.auger@redhat.com>
 <20191205090232.GC8606@willie-the-truck>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <c1a876be-49ab-0b5f-8ddd-1a47bcf89300@redhat.com>
Date: Thu, 5 Dec 2019 10:37:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20191205090232.GC8606@willie-the-truck>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 4ieccuSzO8GpALfjAN5pKg-1
X-Mimecast-Spam-Score: 0
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

Hi Will,

On 12/5/19 10:02 AM, Will Deacon wrote:
> On Wed, Dec 04, 2019 at 09:44:26PM +0100, Eric Auger wrote:
>> ARMv8.1-PMU supports 16-bit evtCount whereas 8.0 only supports
>> 10 bits.
>>
>> On Seatlle which has an 8.0 PMU implementation, evtCount[15:10]
>> are not read as 0, as expected. Fix that by applying a mask on
>> the selected event that depends on the PMU version.
> 
> Are you sure about that? These bits are RES0 in 8.0 afaict, so this would be
> a CPU erratum. Have you checked the SDEN document (I haven't)?

You're right. It is RES0 and not RAZ. My mistake. Please ignore this patch.

Thank you for the feedback.

Eric
> 
> Will
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
