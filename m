Return-Path: <SRS0=5lJd=ZN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AB95C432C3
	for <kvmarm@archiver.kernel.org>; Thu, 21 Nov 2019 09:06:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C8B5520748
	for <kvmarm@archiver.kernel.org>; Thu, 21 Nov 2019 09:06:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8B5520748
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BB6C4AEAA;
	Thu, 21 Nov 2019 04:06:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1p-yMuVpJIDP; Thu, 21 Nov 2019 04:06:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 333DC4AE9C;
	Thu, 21 Nov 2019 04:06:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 743964AE9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Nov 2019 04:06:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9Fr7UkCJs6Gm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Nov 2019 04:06:31 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 689764AC70
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Nov 2019 04:06:31 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1iXiPo-0004FK-NV; Thu, 21 Nov 2019 10:06:16 +0100
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/arm updates for 5.5
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Thu, 21 Nov 2019 09:06:16 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <3cde0da8-62a5-d1a5-b6b9-58baf890707a@redhat.com>
References: <20191120164236.29359-1-maz@kernel.org>
 <3cde0da8-62a5-d1a5-b6b9-58baf890707a@redhat.com>
Message-ID: <3d2382e6ed7ea25cb13303760a79091a@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com,
 mark.rutland@arm.com, drjones@redhat.com, kvm@vger.kernel.org,
 eric.auger@redhat.com, xypron.glpk@gmx.de, bigeasy@linutronix.de,
 suzuki.poulose@arm.com, christoffer.dall@arm.com, steven.price@arm.com,
 borntraeger@de.ibm.com, julien.grall@arm.com, graf@amazon.com,
 linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com,
 james.morse@arm.com, tglx@linutronix.de, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 Heinrich Schuchardt <xypron.glpk@gmx.de>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Steven Price <steven.price@arm.com>, Julien Grall <julien.grall@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 linux-arm-kernel@lists.infradead.org
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

On 2019-11-21 08:58, Paolo Bonzini wrote:
> On 20/11/19 17:42, Marc Zyngier wrote:
>> Paolo, Radim,
>>
>> Here's the bulk of KVM/arm updates for 5.5. On the menu, two new 
>> features:
>> - Stolen time is finally exposed to guests. Yay!
>> - We can report (and potentially emulate) instructions that KVM 
>> cannot
>>   handle in kernel space to userspace. Yay again!
>>
>> Apart from that, a fairly mundane bag of perf optimization, cleanup 
>> and
>> bug fixes.
>>
>> Note that this series is based on a shared branch with the arm64 
>> tree,
>> avoiding a potential delicate merge.
>>
>> Please pull,
>
> Pulled, thanks.  Note that the new capabilities had a conflict and 
> were
> bumped by one.

Not a problem, nothing has been merged into any userspace so far.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
