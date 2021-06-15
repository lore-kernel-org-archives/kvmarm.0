Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E019AC48BE5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 15:31:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4CD746143A
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 15:31:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CD746143A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B41F64B0A5;
	Tue, 15 Jun 2021 11:31:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1TVHT+WjIdVg; Tue, 15 Jun 2021 11:31:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFC0F49F83;
	Tue, 15 Jun 2021 11:31:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71CC34B0C8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 11:15:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8sl5xcnsoWRd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 11:15:55 -0400 (EDT)
Received: from smtp-fw-4101.amazon.com (smtp-fw-4101.amazon.com [72.21.198.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 017734B08C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 11:15:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
 t=1623770155; x=1655306155;
 h=message-id:subject:from:to:cc:date:mime-version:
 content-transfer-encoding;
 bh=fkt7Bvgek3X6TUulfVwMz38yglu8hsWNnWc6UhT3cGY=;
 b=FTZK1ZKOf7vSBSuSA8wuYN2jUby5h21aSBn+UA7i27nalhB5gzRTbmqQ
 axlmRTHE17raFHaTMsmS9ewXuu9BqsJVvrdHvqxs5qHEZTP5TZGWA97sk
 272K5zsXrj26Yb05cuznJy7b62olUqUnH5b330BUx60r9s3yJRZz+fXkE g=;
X-IronPort-AV: E=Sophos;i="5.83,275,1616457600"; d="scan'208";a="114413176"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.6])
 by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 15 Jun 2021 15:15:46 +0000
Received: from EX13D39EUC002.ant.amazon.com
 (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
 by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS
 id 5707CA21D8; Tue, 15 Jun 2021 15:15:45 +0000 (UTC)
Received: from laptop (10.43.162.111) by EX13D39EUC002.ant.amazon.com
 (10.43.164.187) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Jun
 2021 15:15:41 +0000
Message-ID: <322843db2f986f418d4175ca9c10e0904aa81d7a.camel@amazon.de>
Subject: Re: KVM: arm64: pmu: Reset sample period on overflow handling
From: Aman Priyadarshi <apeureka@amazon.de>
To: Marc Zyngier <maz@kernel.org>, Andrew Murray <andrew.murray@arm.com>,
 <kvmarm@lists.cs.columbia.edu>
Date: Tue, 15 Jun 2021 17:15:28 +0200
Security: Personal
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-Originating-IP: [10.43.162.111]
X-ClientProxiedBy: EX13D07UWA002.ant.amazon.com (10.43.160.77) To
 EX13D39EUC002.ant.amazon.com (10.43.164.187)
X-Mailman-Approved-At: Tue, 15 Jun 2021 11:31:52 -0400
Cc: Alexander Graf <graf@amazon.com>, Ali Saidi <alisaidi@amazon.com>, Aman
 Priyadarshi <apeureka@amazon.de>
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

Hey,

I have been chasing down a regression on guest side related to pmu cycle
counters, and I found that reverting these two patches help:

- 30d97754b2d1 ("KVM: arm/arm64: Re-create event when setting counter
value")
- 8c3252c06516 ("KVM: arm64: pmu: Reset sample period on overflow
handling")

However, I do not yet fully understand the underlying problem.

Regression can be reproduced by running simple userspace processes
consuming 100% of cpus and checking the number of pmu cycles.

```
$ cat foo.c
#include <stdio.h>

int main()
{
    while (1) ;
    return 0;
}


$ gcc -o foo foo.c
$ for x in {0..63}; do ./foo & done
$ sudo perf stat -A -a -e cpu-clock:pppH,cycles -- sleep 10
CPU0        22,397,323,233      cycles                    #    2.240 GHz
CPU1         6,444,741,327      cycles                    #    0.644 GHz
CPU2        17,029,444,425      cycles                    #    1.703 GHz
CPU3         4,298,054,663      cycles                    #    0.430 GHz
CPU4         6,444,769,216      cycles                    #    0.644 GHz
CPU5         6,045,456,891      cycles                    #    0.605 GHz
CPU6         4,298,204,814      cycles                    #    0.430 GHz
CPU7         6,444,346,686      cycles                    #    0.644 GHz
CPU8         4,298,012,726      cycles                    #    0.430 GHz
CPU9         6,445,547,392      cycles                    #    0.645 GHz
CPU10        4,297,996,144      cycles                    #    0.430 GHz
...
```

Expected behavior is to have all cores around 2.5GHz on all CPUs given that
all CPUs are 100% in the guest.

The nonsensical values reported by the pmu counters is only observed on
certain combination of host and guest kernel.

I was able to reproduce it on v5.4.34 and v5.13.0-rc5 running on the host
side, and 4.14.10 on the guest side.

I am running Ubuntu 18.04 cloud image with 4.14.10 kernel headers
installed:

https://cloud-images.ubuntu.com/releases/bionic/release/ubuntu-18.04-server-cloudimg-arm64.img

Note, cloud image comes with 4.15.y kernel installed, which does not show
any regression.

I can also confirm that reverting the mentioned commits on either tree
(v5.4.34 or v5.13.0-rc5) fixes the problem.
```
CPU51          25020026126      cycles                    #    2.497 GHz
CPU52          25020153183      cycles                    #    2.497 GHz
CPU53          25011934659      cycles                    #    2.496 GHz
CPU54          25020521670      cycles                    #    2.497 GHz
CPU55          25015920340      cycles                    #    2.497 GHz
CPU56          25020176871      cycles                    #    2.497 GHz
CPU57          25013646763      cycles                    #    2.497 GHz
CPU58          25020736379      cycles                    #    2.497 GHz
CPU59          25019495291      cycles                    #    2.497 GHz
CPU60          25020988560      cycles                    #    2.497 GHz
CPU61          25021343608      cycles                    #    2.497 GHz
CPU62          25018942029      cycles                    #    2.497 GHz
CPU63          25019514949      cycles                    #    2.497 GHz

      10.020502287 seconds time elapsed

root@ubuntu:~# cat /proc/version  # Guest
Linux version 4.14.10-041410-generic (kernel@kathleen) (gcc version 7.2.0
(Ubuntu/Linaro 7.2.0-6ubuntu1)) #201712291810 SMP Fri Dec 29 18:37:30 UTC
2017
root@ubuntu:~# QEMU: Terminated
ubuntu@ip-10-0-98-166:~/images$ cat /proc/version  # Host
Linux version 5.13.0-rc5 (ubuntu@ip-10-0-98-166) (gcc (Ubuntu 9.3.0-
17ubuntu1~20.04) 9.3.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #2 SMP Mon
Jun 14 21:05:25 UTC 2021
```

Regards,
Aman Priyadarshi




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
