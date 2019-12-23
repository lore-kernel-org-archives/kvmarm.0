Return-Path: <SRS0=P9fm=2N=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80024C2D0C0
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 12:18:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2665D20715
	for <kvmarm@archiver.kernel.org>; Mon, 23 Dec 2019 12:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2665D20715
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A62204AF28;
	Mon, 23 Dec 2019 07:18:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RkYn35v-ItJS; Mon, 23 Dec 2019 07:18:18 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88ACF4AF53;
	Mon, 23 Dec 2019 07:18:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23DA94AF44
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 07:18:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e4xKULQbUuog for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Dec 2019 07:18:17 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23CDD4AF28
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Dec 2019 07:18:17 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ijMf8-0003iS-Ut; Mon, 23 Dec 2019 13:18:14 +0100
To: Andrew Murray <andrew.murray@arm.com>
Subject: Re: [PATCH v2 15/18] perf: =?UTF-8?Q?arm=5Fspe=3A=20Handle=20gues?=
 =?UTF-8?Q?t/host=20exclusion=20flags?=
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Mon, 23 Dec 2019 12:18:14 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191223121002.GB42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-16-andrew.murray@arm.com>
 <865zi8imr7.wl-maz@kernel.org>
 <20191223121002.GB42593@e119886-lin.cambridge.arm.com>
Message-ID: <0c806e4f5bb465f5b3fb54d167293706@www.loen.fr>
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

On 2019-12-23 12:10, Andrew Murray wrote:
> On Sun, Dec 22, 2019 at 12:10:52PM +0000, Marc Zyngier wrote:
>> On Fri, 20 Dec 2019 14:30:22 +0000,
>> Andrew Murray <andrew.murray@arm.com> wrote:
>> >
>> > A side effect of supporting the SPE in guests is that we prevent 
>> the
>> > host from collecting data whilst inside a guest thus creating a 
>> black-out
>> > window. This occurs because instead of emulating the SPE, we share 
>> it
>> > with our guests.
>> >
>> > Let's accurately describe our capabilities by using the perf 
>> exclude
>> > flags to prevent !exclude_guest and exclude_host flags from being 
>> used.
>> >
>> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
>> > ---
>> >  drivers/perf/arm_spe_pmu.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/drivers/perf/arm_spe_pmu.c 
>> b/drivers/perf/arm_spe_pmu.c
>> > index 2d24af4cfcab..3703dbf459de 100644
>> > --- a/drivers/perf/arm_spe_pmu.c
>> > +++ b/drivers/perf/arm_spe_pmu.c
>> > @@ -679,6 +679,9 @@ static int arm_spe_pmu_event_init(struct 
>> perf_event *event)
>> >  	if (attr->exclude_idle)
>> >  		return -EOPNOTSUPP;
>> >
>> > +	if (!attr->exclude_guest || attr->exclude_host)
>> > +		return -EOPNOTSUPP;
>> > +
>>
>> I have the opposite approach. If the host decides to profile the
>> guest, why should that be denied? If there is a black hole, it 
>> should
>> take place in the guest. Today, the host does expect this to work, 
>> and
>> there is no way that we unconditionally allow it to regress.
>
> That seems reasonable.
>
> Upon entering the guest we'd have to detect if the host is using SPE, 
> and if
> so choose not to restore the guest registers. Instead we'd have to 
> trap them
> and let the guest read/write emulated values until the host has 
> finished with
> SPE - at which time we could restore the guest SPE registers to 
> hardware.
>
> Does that approach make sense?

Yes, this would be much better. All of this can be found out at 
vcpu_load()
time, and once you've moved most of the SPE sysreg handling there, it 
will
just follow the normal scheduling flow.

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
