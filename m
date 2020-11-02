Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26EAC00A89
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 09:29:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 165BA22272
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 09:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="UOBhySJ2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 165BA22272
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A444B5AA;
	Mon,  2 Nov 2020 04:29:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LnTSLkd+VOgA; Mon,  2 Nov 2020 04:29:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B8DF4B5BC;
	Mon,  2 Nov 2020 04:29:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE8004B59E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 04:29:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kGKaFGytBD4N for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 04:29:45 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 766CF4B589
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 04:29:45 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 0E8692223C;
 Mon,  2 Nov 2020 09:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604309384;
 bh=T/El0ov3kcySGtqMdNf16TinqhVt5VEHPjes7JQw5rQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=UOBhySJ2dtH28uNtKBxC0sR3S37pa5BzAUK9U+yfl3yZ0LqGDNbfTj27LbE8KIjb0
 4h0S0pOQTUW2ibzMnxAJhIHZSvSVXnSFmViA46FR8qorFbEJCl2y1M3ygBKh0xwOb+
 L8zuGMRsrizn+MsKTeLXuFKWSEjnGboaZ4l8hUYw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kZW9l-006c7H-VB; Mon, 02 Nov 2020 09:29:42 +0000
MIME-Version: 1.0
Date: Mon, 02 Nov 2020 09:29:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: Peng Liang <liangpeng10@huawei.com>
Subject: Re: VM live migration failed from Linux v5.9 to Linux v5.10-rc1
In-Reply-To: <05de753e-1845-e23f-7ab2-eaa8d53f0ac5@huawei.com>
References: <5ade34aa-e725-93e8-7b28-83fb25dcf896@huawei.com>
 <87blgieddu.wl-maz@kernel.org>
 <05de753e-1845-e23f-7ab2-eaa8d53f0ac5@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <eaeb38babfd8ba77d4bd09ffeb7622e9@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: liangpeng10@huawei.com, kvmarm@lists.cs.columbia.edu,
 xiexiangyou@huawei.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On 2020-11-02 03:12, Peng Liang wrote:
> Hi Marc,
> Sorry for my late reply.
> 
> On 10/31/2020 9:25 PM, Marc Zyngier wrote:
>> Hi Peng,
>> 
>> [+Will, as we hacked the new ECE (Ectoplasmic Control Enclosure) 
>> together]
>> 
>> On Sat, 31 Oct 2020 07:03:02 +0000,
>> Peng Liang <liangpeng10@huawei.com> wrote:
>>> 
>>> [...]
>>> 
>>> I found that the different register and the different field between
>>> source and destination is ID_AA64PFR0_EL1.CSV2. I searched in git log
>>> and found that the commit e1026237f9067 ("KVM: arm64: Set CSV2 for
>>> guests on hardware unaffected by Spectre-v2") may be the cause of the
>>> failure?
>> 
>> Thanks for the thorough analysis. Yes, this could well be the issue if
>> CSV2 isn't explicitly set at the source, and is now set on the target.
>> For confirmation, what is the value of ID_AA64PFR0_EL1.CSV2 on the
>> host?  What does /sys/devices/system/cpu/vulnerabilities/spectre_v2
>> contain?
> 
> On host:
>   ID_AA64PFR0_EL1.CSV2: 0
>   /sys/devices/system/cpu/vulnerabilities/spectre_v2: Not affected

Right. I guess this system supports WA1 and reports "not affected".

> 
>> 
>>> So do we need to make it possible to migrate VMs between Linux v5.9 
>>> and
>>> Linux v5.10-rc1 with QEMU?
>> 
>> We should fix the migration from 5.9 to 5.10. I don't plan to support
>> migrating in the other direction, which is consistent with new sysregs
>> and features appearing in the sysreg space over time (although I would
>> expect 5.9 -> 5.10 -> 5.9 to work once we fix this issue).
> 
> BTW, there always be new sysregs/features introduced to kernel over
> time.  If that happened, do we need to make migration successful from a
> older version without the new sysregs/features?  I think there is no
> reason to not allow migration from old version to new version if the
> source end and the destination end have the same hardware just because
> old version doesn't expose some sysregs/features to guest but new
> version does.

What if kernel 5.11 adds unconditional support for a feature and that
results in a new sysreg gets exposed? How do you plan to restore this
guest on 5.10?

In may work in limited cases, but it doesn't in general. To make that
work, you'd need to implement some explicit buy-in from userspace on
each and every feature that gets added to the hypervisor. This is
completely impractical, and I have no desire to support it.


         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
