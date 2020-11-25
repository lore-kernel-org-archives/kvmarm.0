Return-Path: <SRS0=WvL8=E7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DBEC5519F
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 10:49:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 501FA2075A
	for <kvmarm@archiver.kernel.org>; Wed, 25 Nov 2020 10:49:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="v6vPS9fD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 501FA2075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B24D34B93E;
	Wed, 25 Nov 2020 05:49:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xV-hoWBvslU3; Wed, 25 Nov 2020 05:49:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A85914B932;
	Wed, 25 Nov 2020 05:49:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A5AE4B77D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 05:49:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id M-R9XOUcBXGh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Nov 2020 05:49:23 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E79864B73B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Nov 2020 05:49:22 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6802C2075A;
 Wed, 25 Nov 2020 10:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606301361;
 bh=k8JMumggIN1LUGGzTQSyZv3AZbIMuj0rpxQJfz5sL8I=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=v6vPS9fDI5hnTJ8ThHNAiwCD6PcSrZAAmxL3Jclalq593Krfgz9aISvSIn+UJKxU2
 KR5yjs019NW8WgI8ke2w2sp2+dJ8fu/SOTyL9K036/PMaH2UdpztAgikPjvoWYDsd+
 uLV7LUNmH768ZbUFhs3uTuiw0YGcY2BgUgIWEQtY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1khsMR-00DVTd-18; Wed, 25 Nov 2020 10:49:19 +0000
MIME-Version: 1.0
Date: Wed, 25 Nov 2020 10:49:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: David Brazdil <dbrazdil@google.com>
Subject: Re: [PATCH v2 06/24] kvm: arm64: Move hyp-init params to a per-CPU
 struct
In-Reply-To: <20201125103946.2unmclsdfqpr3eyk@google.com>
References: <20201116204318.63987-1-dbrazdil@google.com>
 <20201116204318.63987-7-dbrazdil@google.com> <87lfes5f54.wl-maz@kernel.org>
 <20201125103946.2unmclsdfqpr3eyk@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <643459b9146c5cdf91c3316bb1cb096e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 catalin.marinas@arm.com, will@kernel.org, dennis@kernel.org, tj@kernel.org,
 cl@linux.com, mark.rutland@arm.com, lorenzo.pieralisi@arm.com,
 qperret@google.com, ascull@google.com, qwandor@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Andrew Walbran <qwandor@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 2020-11-25 10:39, David Brazdil wrote:
> On Mon, Nov 23, 2020 at 02:20:07PM +0000, Marc Zyngier wrote:

[...]

>> > +
>> > +	/*
>> > +	 * Flush the init params from the data cache because the struct will
>> > +	 * be read while the MMU is off.
>> > +	 */
>> > +	__flush_dcache_area(params, sizeof(*params));
>> 
>> nit: please use kvm_flush_dcache_to_poc(), as it clearly indicates to
>> which point we are flushing.
> 
> Will change, but out of curiosity - how is it different? AFAICT, it is 
> just
> an alias with a single use in __clean_dcache_guest_page:
> 
>   #define kvm_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))

It is indeed the exact same thing, but it says clearly in the name that 
we
are cleaning to the "Point Of Coherency", as opposed to any other 
architectural level (Unification or Persistence).

It makes it clear that we are cleaning all the way to the point where it 
can
be accessed reliably with an uncacheable mapping, and not leaving the 
data
dangling at a shallower cache level.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
