Return-Path: <SRS0=uTqP=2I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBDBC2D0D2
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 18:11:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F9F721582
	for <kvmarm@archiver.kernel.org>; Wed, 18 Dec 2019 18:11:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F9F721582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A19F24A7E4;
	Wed, 18 Dec 2019 13:11:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qi8-Kc59p9lJ; Wed, 18 Dec 2019 13:11:13 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C1284A52C;
	Wed, 18 Dec 2019 13:11:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0E54A52C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 13:11:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CmszIfCWgg-j for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Dec 2019 13:11:11 -0500 (EST)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 23EEE4A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Dec 2019 13:11:11 -0500 (EST)
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
 (envelope-from <maz@kernel.org>)
 id 1ihdmZ-0007pw-8W; Wed, 18 Dec 2019 19:10:47 +0100
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v4 00/19] KVM: Dynamically size memslot arrays
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Date: Wed, 18 Dec 2019 18:10:47 +0000
From: Marc Zyngier <maz@kernel.org>
In-Reply-To: <20191217204041.10815-1-sean.j.christopherson@intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
Message-ID: <3a6b03cc1300bc3cffd3904e22c09478@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, jhogan@kernel.org,
 paulus@ozlabs.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 pbonzini@redhat.com, david@redhat.com, cohuck@redhat.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org, christoffer.dall@arm.com, f4bug@amsat.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org);
 SAEximRunCond expanded to false
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, James Hogan <jhogan@kernel.org>,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 kvmarm@lists.cs.columbia.edu, Janosch Frank <frankja@linux.ibm.com>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

On 2019-12-17 20:40, Sean Christopherson wrote:
> The end goal of this series is to dynamically size the memslot array 
> so
> that KVM allocates memory based on the number of memslots in use, as
> opposed to unconditionally allocating memory for the maximum number 
> of
> memslots.  On x86, each memslot consumes 88 bytes, and so with 2 
> address
> spaces of 512 memslots, each VM consumes ~90k bytes for the memslots.
> E.g. given a VM that uses a total of 30 memslots, dynamic sizing 
> reduces
> the memory footprint from 90k to ~2.6k bytes.
>
> The changes required to support dynamic sizing are relatively small,
> e.g. are essentially contained in patches 17/19 and 18/19.
>
> Patches 2-16 clean up the memslot code, which has gotten quite 
> crusty,
> especially __kvm_set_memory_region().  The clean up is likely not 
> strictly
> necessary to switch to dynamic sizing, but I didn't have a remotely
> reasonable level of confidence in the correctness of the dynamic 
> sizing
> without first doing the clean up.
>
> The only functional change in v4 is the addition of an x86-specific 
> bug
> fix in x86's handling of KVM_MR_MOVE.  The bug fix is not directly 
> related
> to dynamically allocating memslots, but it has subtle and hidden 
> conflicts
> with the cleanup patches, and the fix is higher priority than 
> anything
> else in the series, i.e. should be merged first.
>
> On non-x86 architectures, v3 and v4 should be functionally 
> equivalent,
> the only non-x86 change in v4 is the dropping of a "const" in
> kvm_arch_commit_memory_region().

Gave it another go on top of 5.5-rc2 on an arm64 box, and nothing
exploded. So thumbs up from me.

Thanks,

        M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
