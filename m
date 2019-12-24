Return-Path: <SRS0=PUN/=2O=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A13BC2D0CF
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 13:47:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 89A2B20730
	for <kvmarm@archiver.kernel.org>; Tue, 24 Dec 2019 13:47:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89A2B20730
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE1434AF58;
	Tue, 24 Dec 2019 08:47:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KDH-G0dgW-AQ; Tue, 24 Dec 2019 08:47:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D81B84AF52;
	Tue, 24 Dec 2019 08:47:01 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 416A14AF1F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 08:46:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yDp08wQMYOkJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Dec 2019 08:46:16 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 41FA24AF3B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Dec 2019 08:46:16 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ijkVo-0003p4-RU; Tue, 24 Dec 2019 14:46:12 +0100
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 14/18] KVM: arm64: spe: Provide guest virtual
 interrupts for SPE
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Tue, 24 Dec 2019 13:46:12 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191224133647.GO42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-15-andrew.murray@arm.com>
 <867e2oimw9.wl-maz@kernel.org>
 <20191224115031.GG42593@e119886-lin.cambridge.arm.com>
 <1f3fbff6c9db0f14c92a6e3fb800fa0f@www.loen.fr>
 <20191224130853.GN42593@e119886-lin.cambridge.arm.com>
 <a2b8846377b3f5884feeb9728b16f826@www.loen.fr>
 <20191224133647.GO42593@e119886-lin.cambridge.arm.com>
Message-ID: <ddd39371e1aa95747d42efdb55f73b51@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, marc.zyngier@arm.com,
 catalin.marinas@arm.com, will.deacon@arm.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, sudeep.holla@arm.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 2019-12-24 13:36, Andrew Murray wrote:
> On Tue, Dec 24, 2019 at 01:22:46PM +0000, Marc Zyngier wrote:
>> On 2019-12-24 13:08, Andrew Murray wrote:

[...]

>> > This does feel like the pragmatic approach - a larger black hole 
>> in
>> > exchange
>> > for performance. I imagine the blackhole would be naturally 
>> reduced on
>> > machines with high workloads.
>>
>> Why? I don't see the relation between how busy the vcpu is and the 
>> size
>> of the blackhole. It is strictly a function of the frequency of 
>> exits.
>
> Indeed, my assumption being that the busier a system is the more
> interrupts, thus leading to more exits and so an increased frequency 
> of
> SPE interrupt evaluation and thus smaller black hole.

On a GICv4-enabled system, this isn't true anymore. My bet is that
people won't use SPE to optimize IO-oriented workloads, but more CPU
intensive workloads (that don't necessarily exit at all).

But never mind. Let's start with this approach, as it is simple and 
easy
to verify. If the black hole aspect becomes problematic, we know how
to reduce it (at the expense of entry/exit performance).

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
