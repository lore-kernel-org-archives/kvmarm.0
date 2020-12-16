Return-Path: <SRS0=5C08=FU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816FEC4361B
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 10:23:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B44AE2313B
	for <kvmarm@archiver.kernel.org>; Wed, 16 Dec 2020 10:23:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B44AE2313B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E59974B502;
	Wed, 16 Dec 2020 05:23:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x-L1a-Uivgr8; Wed, 16 Dec 2020 05:23:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D04314B4D4;
	Wed, 16 Dec 2020 05:23:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 599E44B4D4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 05:23:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 35OyutvXX9ta for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Dec 2020 05:23:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50D834B4C4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Dec 2020 05:23:28 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B934F1FB;
 Wed, 16 Dec 2020 02:23:27 -0800 (PST)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03FF13F66B;
 Wed, 16 Dec 2020 02:23:25 -0800 (PST)
Subject: Re: [PATCH v5 0/2] MTE support for KVM guest
To: Haibo Xu <haibo.xu@linaro.org>
References: <20201119153901.53705-1-steven.price@arm.com>
 <CAFEAcA85fiqA206FuFANKbV_3GkfY1F8Gv7MP58BgTT81bs9kA@mail.gmail.com>
 <20201119184248.4bycy6ouvaxqdiiy@kamzik.brq.redhat.com>
 <db5ad775fa7cfe7defbd78d9ca6ccfd8@kernel.org>
 <c25c297e-e9b5-ab3f-e401-c21ddd4d2ad1@arm.com>
 <CAJc+Z1H7akXwDtVvQLiGVVyZ0DfmsxyJQhE7Sno6aAO9GaafEA@mail.gmail.com>
 <46fd98a2-ee39-0086-9159-b38c406935ab@arm.com>
 <CAJc+Z1EzaUjbQ0o8BSF_+PQy_KnwPp1NqO+94RMphvaUu=dnug@mail.gmail.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <29a7229d-a1ff-98a5-3007-1addcc85aa04@arm.com>
Date: Wed, 16 Dec 2020 10:22:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAJc+Z1EzaUjbQ0o8BSF_+PQy_KnwPp1NqO+94RMphvaUu=dnug@mail.gmail.com>
Content-Language: en-GB
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Juan Quintela <quintela@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 QEMU Developers <qemu-devel@nongnu.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>,
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

On 16/12/2020 07:31, Haibo Xu wrote:
[...]
> Hi Steve,

Hi Haibo

> I have finished verifying the POC on a FVP setup, and the MTE test case can
> be migrated from one VM to another successfully. Since the test case is very
> simple which just maps one page with MTE enabled and does some memory
> access, so I can't say it's OK for other cases.

That's great progress.

> 
> BTW, I noticed that you have sent out patch set v6 which mentions that mapping
> all the guest memory with PROT_MTE was not feasible. So what's the plan for the
> next step? Will new KVM APIs which can facilitate the tag store and recover be
> available?

I'm currently rebasing on top of the KASAN MTE patch series. My plan for 
now is to switch back to not requiring the VMM to supply PROT_MTE (so 
KVM 'upgrades' the pages as necessary) and I'll add an RFC patch on the 
end of the series to add an KVM API for doing bulk read/write of tags. 
That way the VMM can map guest memory without PROT_MTE (so device 'DMA' 
accesses will be unchecked), and use the new API for migration.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
