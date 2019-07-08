Return-Path: <SRS0=Gv/P=VF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F035BC606AF
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jul 2019 12:41:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7EBFD20665
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jul 2019 12:41:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7EBFD20665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jonmasters.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E91344A537;
	Mon,  8 Jul 2019 08:41:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TwS+rO6GaWjI; Mon,  8 Jul 2019 08:40:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4ABD4A52B;
	Mon,  8 Jul 2019 08:40:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B9D14A50D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jul 2019 08:40:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AOh8u1Mdr9e4 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jul 2019 08:40:57 -0400 (EDT)
Received: from edison.jonmasters.org (edison.jonmasters.org [173.255.233.168])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7ECCF4A4EB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jul 2019 08:40:57 -0400 (EDT)
Received: from boston.jonmasters.org ([50.195.43.97]
 helo=tonnant.bos.jonmasters.org)
 by edison.jonmasters.org with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
 (Exim 4.71) (envelope-from <jcm@jonmasters.org>)
 id 1hkSwx-0005qi-MY; Mon, 08 Jul 2019 12:40:55 +0000
To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
References: <7dd77cea-d673-269a-044f-4df269db7e5e@jonmasters.org>
 <20190708093714.57t55inainky2zcq@shell.armlinux.org.uk>
From: Jon Masters <jcm@jonmasters.org>
Message-ID: <21412e56-a8cc-0e75-06e4-3dd1684839e2@jonmasters.org>
Date: Mon, 8 Jul 2019 08:40:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190708093714.57t55inainky2zcq@shell.armlinux.org.uk>
Content-Language: en-US
X-SA-Exim-Connect-IP: 50.195.43.97
X-SA-Exim-Mail-From: jcm@jonmasters.org
Subject: Re: FYI: Possible HPFAR_EL2 corruption (LPAE guests on AArch64 hosts)
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>
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

On 7/8/19 5:37 AM, Russell King - ARM Linux admin wrote:
> On Sun, Jul 07, 2019 at 11:39:46PM -0400, Jon Masters wrote:
>> Hi all,
>>
>> TLDR: We think $subject may be a hardware errata and we are
>> investigating. I was asked to drop a note to share my initial analysis
>> in case others have been experiencing similar problems with 32-bit VMs.
>>
>> The Fedora Arm 32-bit builders run as "armv7hl+lpae" (aarch32) LPAE
>> (VMSAv8-32 Long-descriptor table format in aarch32 execution state) VMs
>> on AArch64 hosts. Under certain conditions, those builders will "pause"
>> with the following obscure looking error message:
>>
>> kvm [10652]: load/store instruction decoding not implemented
> 
> Out of interest, because I'm running a number of 32-bit VMs on the
> Macchiatobin board, using a different 64-bit distro...
> 
> How often do these errors occur?  Have you been able to pinpoint any
> particular CPU core?  Does the workload in the VMs have any effect?
> What about the workload in the host?

It's a specific CPU core (not a Cortex design), running a 32-bit LPAE
kernel (needs to be LPAE to have an IPA >32-bit). In the course of a
weekend running stress tests, my test kernel fixed up hundreds of faults
that would otherwise have taken the guest system down.

Specifically, PGDs are allocated from a cache located in low memory (so
we never hit this condition for those), but PTEs are allocated using:

	alloc_pages(PGALLOC_GFP | __GFP_HIGHMEM, 0);

So at some point, we'll allocate a PTE from above 32-bit. When we later
take a fault on those during a stage 1 walk, we hit a problem.

My guess is we do the clock algorithm on the host looking to see for
recent accesses by unsetting access bits on the host (stage2) and since
on Armv8.0 we do a software trap for access bit updates we'll trap to
stage 2 during the stage 1 guest walk the next time around. So simply
pinning the guest memory isn't going to be sufficient to prevent it if
that memory is allocated normally with the host doing software LRU.

But the above is just what I consider the likely cause in my head.

Jon.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
