Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DACCC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 10:01:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AABD723A9A
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 10:01:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AABD723A9A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE7AE4B0C3;
	Tue,  8 Dec 2020 05:01:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BZlZXUQl0XJa; Tue,  8 Dec 2020 05:01:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F40784B0B1;
	Tue,  8 Dec 2020 05:01:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E23C74B0B1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 05:01:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dUa9OaRaGOqa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 05:01:41 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB4994B093
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 05:01:41 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 6E8F9217A0;
 Tue,  8 Dec 2020 10:01:40 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kmZoQ-00H3In-Bb; Tue, 08 Dec 2020 10:01:38 +0000
MIME-Version: 1.0
Date: Tue, 08 Dec 2020 10:01:38 +0000
From: Marc Zyngier <maz@kernel.org>
To: Haibo Xu <haibo.xu@linaro.org>
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
In-Reply-To: <CAJc+Z1FRJR5LHw-xZvPpeYF6+v+ZOcLt99X41xOMAbFmB2DJ2A@mail.gmail.com>
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
 <CAJc+Z1FRJR5LHw-xZvPpeYF6+v+ZOcLt99X41xOMAbFmB2DJ2A@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <b77efceaec433dd98fdf2cd535a9cf40@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: haibo.xu@linaro.org, steven.price@arm.com,
 drjones@redhat.com, catalin.marinas@arm.com, quintela@redhat.com,
 richard.henderson@linaro.org, qemu-devel@nongnu.org, dgilbert@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 tglx@linutronix.de, will@kernel.org, Dave.Martin@arm.com,
 linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Juan Quintela <quintela@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>, Steven Price <steven.price@arm.com>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Dave Martin <Dave.Martin@arm.com>
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

On 2020-12-08 09:51, Haibo Xu wrote:
> On Mon, 7 Dec 2020 at 22:48, Steven Price <steven.price@arm.com> wrote:
>> 

[...]

>> Sounds like you are making good progress - thanks for the update. Have
>> you thought about how the PROT_MTE mappings might work if QEMU itself
>> were to use MTE? My worry is that we end up with MTE in a guest
>> preventing QEMU from using MTE itself (because of the PROT_MTE
>> mappings). I'm hoping QEMU can wrap its use of guest memory in a
>> sequence which disables tag checking (something similar will be needed
>> for the "protected VM" use case anyway), but this isn't something I've
>> looked into.
> 
> As far as I can see, to map all the guest memory with PROT_MTE in VMM
> is a little weird, and lots of APIs have to be changed to include this 
> flag.
> IMHO, it would be better if the KVM can provide new APIs to load/store 
> the
> guest memory tag which may make it easier to enable the Qemu migration
> support.

On what granularity? To what storage? How do you plan to synchronise 
this
with the dirty-log interface?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
