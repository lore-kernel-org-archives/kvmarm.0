Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1B2C00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 12:30:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B05B54D8DD;
	Wed, 10 Aug 2022 08:30:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@efficios.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rNMUJK0rJ4TH; Wed, 10 Aug 2022 08:30:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8090B4D8DF;
	Wed, 10 Aug 2022 08:30:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE4F44D8DF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:30:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ch20gMMG65eh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 08:30:15 -0400 (EDT)
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DF334D8DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 08:30:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mail.efficios.com (Postfix) with ESMTP id 6761A43E865;
 Wed, 10 Aug 2022 08:30:15 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
 by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
 with ESMTP id C0olCMiwtd8x; Wed, 10 Aug 2022 08:30:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mail.efficios.com (Postfix) with ESMTP id E324A43EA38;
 Wed, 10 Aug 2022 08:30:14 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com E324A43EA38
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=default; t=1660134614;
 bh=B/qxBoi9o1gVsk6Eb1UYEgPxbL1rMsh9NZ46kRFuqiI=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=ZnWadkVDov0vTB6CEnrUksXNICt4XyoIbKAR3c4uKk8HwV3O0DaHjQq2u/PvgAaaD
 W3hRqGWplND4ju3MSOHu69aetic44PIzYZ+ljvscPnKijmjj2wmMfMa0enwC75acJU
 1LBG3LsY1C/AK+ALZ5jT9RHT8jcat7rkTkAQ+gneTHIPpdRf1RmL8fFRdGunfOWmxQ
 vY2LeFGXKCzmqrHWH587oVs9Fyc5KDKEUSgA1S4mfdOTKbC7/ZUT8DJpFbQxkvlsBn
 qDKxjQydYPR8wdmlkZfkI+fPsEo2aP++gCdrhOhPGeGSM8ddMgPvDglo3W3PL6Med0
 d36xj+4uG4qKQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
 by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
 with ESMTP id 2qdFW4ojRKgE; Wed, 10 Aug 2022 08:30:14 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
 by mail.efficios.com (Postfix) with ESMTP id D642243EA37;
 Wed, 10 Aug 2022 08:30:14 -0400 (EDT)
Date: Wed, 10 Aug 2022 08:30:14 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <264792101.376.1660134614855.JavaMail.zimbra@efficios.com>
In-Reply-To: <1e41a634-0419-e0a8-364c-2e30ed2dbe4d@redhat.com>
References: <20220810104114.6838-1-gshan@redhat.com>
 <20220810104114.6838-2-gshan@redhat.com>
 <876568572.367.1660134156963.JavaMail.zimbra@efficios.com>
 <1e41a634-0419-e0a8-364c-2e30ed2dbe4d@redhat.com>
Subject: Re: [PATCH v2 1/2] KVM: selftests: Make rseq compatible with
 glibc-2.35
MIME-Version: 1.0
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4372 (ZimbraWebClient - FF103
 (Linux)/8.8.15_GA_4372)
Thread-Topic: selftests: Make rseq compatible with glibc-2.35
Thread-Index: yiYIM7vHUMcuFpAstZPcUYWmBolt7g==
Cc: Florian Weimer <fweimer@redhat.com>, shan gavin <shan.gavin@gmail.com>,
 KVM list <kvm@vger.kernel.org>, maz <maz@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 andrew jones <andrew.jones@linux.dev>, yihyu <yihyu@redhat.com>,
 linux-kselftest <linux-kselftest@vger.kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

----- On Aug 10, 2022, at 8:29 AM, Paolo Bonzini pbonzini@redhat.com wrote:

> On 8/10/22 14:22, Mathieu Desnoyers wrote:
>>>
>>> 	/*
>>> 	 * Create and run a dummy VM that immediately exits to userspace via
>>> @@ -256,7 +244,7 @@ int main(int argc, char *argv[])
>>> 			 */
>>> 			smp_rmb();
>>> 			cpu = sched_getcpu();
>>> -			rseq_cpu = READ_ONCE(__rseq.cpu_id);
>>> +			rseq_cpu = READ_ONCE(__rseq->cpu_id);
>> #include <rseq.h>
>> 
>> and use
>> 
>> rseq_current_cpu_raw().
> 
> Thanks, I squashed it and queued it for -rc1 (tested on both
> glibc 2.34 and 2.35).

Thanks a lot Paolo,

Cheers! :)

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
