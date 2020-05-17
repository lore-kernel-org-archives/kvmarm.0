Return-Path: <SRS0=26+9=67=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96699C433E0
	for <kvmarm@archiver.kernel.org>; Sun, 17 May 2020 09:24:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17B72206D5
	for <kvmarm@archiver.kernel.org>; Sun, 17 May 2020 09:24:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="RAU97g05"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17B72206D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB1404B0E6;
	Sun, 17 May 2020 05:24:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MxgT3ZUxWNPD; Sun, 17 May 2020 05:24:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6499F4B0EA;
	Sun, 17 May 2020 05:24:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C5584B0D3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 May 2020 05:24:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id S7biYBSEYnq2 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 May 2020 05:24:13 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC6C74B0C2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 May 2020 05:24:13 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 841CC206D5;
 Sun, 17 May 2020 09:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1589707452;
 bh=HrqBD8ywpNuI1L4Z2TzDt7T36IeiriWa+zcJeJTpAjU=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=RAU97g052QzaYdHC61/tZZXlJL0DoRKdsSu7QxHSAOBO1GMlCm6Z/s8DNNCr9md4p
 Kb/922k1NCiLBHmgx5B5j0PRfStuoBnDsRHtrJqXpAPSdmCc2Kg7JfDzn4wmXTZpoe
 M4ToQ6SQYW8GiXyGte4yJLJXnSIN2XU55soExoho=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jaFWk-00CyXM-M0; Sun, 17 May 2020 10:24:10 +0100
MIME-Version: 1.0
Date: Sun, 17 May 2020 10:24:10 +0100
From: Marc Zyngier <maz@kernel.org>
To: Roja Eswaran <reswara1@binghamton.edu>
Subject: Re: Performance of VM is better than Host
In-Reply-To: <CAGTfD8aY-oJ2J8+EYziHt1Ugy84kK8CU_mwfc0QYkVCMjnjgtw@mail.gmail.com>
References: <CAGTfD8aY-oJ2J8+EYziHt1Ugy84kK8CU_mwfc0QYkVCMjnjgtw@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <044c89beae309b69a991ba9ea76521ea@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: reswara1@binghamton.edu, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

[please do not post HTML messages, and stick to plain text]

On 2020-05-17 03:29, Roja Eswaran wrote:
> Hello,
> 
> I virtualized Raspi-4 and ran _sysbench  - Memory_ on bare metal and
> the VM.
> The performance of VM is better than Host (Increase by 11%)
> -> Both host and VM has the same OS
> -> No Background Processes are running when sysbench is executed
> -> Turned off Transparent huge pages in VM before booting
> Yet getting the same performance difference.
> Please let me know, What I am missing here

With this level of information, I can't tell you anything. Funnily 
enough
  you're not mentioning:

- what you are running (exact version and parameters of your benchmark)
- what you are running it on (host configuration, parameters of the VM
   itself and its vmm, as "virualized Raspi-4" doesn't mean much to me)
- which kernel versions
- how you are measuring this discrepancy
- the variability of the measurement

Things you could look at: using perf capture the various counters and
work out by yourself where the difference lies, look at the impact
of power management on the host, the impact of other kernel threads
running, the number of interrupts...

HTH,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
