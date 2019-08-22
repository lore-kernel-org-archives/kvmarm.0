Return-Path: <SRS0=16Xb=WS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21928C3A5A2
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 15:46:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACCBA23404
	for <kvmarm@archiver.kernel.org>; Thu, 22 Aug 2019 15:46:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACCBA23404
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27C4A4A5E4;
	Thu, 22 Aug 2019 11:46:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7tT41m138GWu; Thu, 22 Aug 2019 11:46:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E32EF4A5E9;
	Thu, 22 Aug 2019 11:46:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E6994A5E2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 11:46:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iBIdgkZsIqL2 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Aug 2019 11:46:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 066084A5D8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Aug 2019 11:46:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A80BA337;
 Thu, 22 Aug 2019 08:46:13 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7BD53F718;
 Thu, 22 Aug 2019 08:46:11 -0700 (PDT)
Subject: Re: [PATCH v3 04/10] KVM: Implement kvm_put_guest()
To: Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190821153656.33429-1-steven.price@arm.com>
 <20190821153656.33429-5-steven.price@arm.com>
 <20190822152854.GE25467@linux.intel.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <e2abc69b-74c2-64ef-e270-43d93513eaae@arm.com>
Date: Thu, 22 Aug 2019 16:46:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822152854.GE25467@linux.intel.com>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On 22/08/2019 16:28, Sean Christopherson wrote:
> On Wed, Aug 21, 2019 at 04:36:50PM +0100, Steven Price wrote:
>> kvm_put_guest() is analogous to put_user() - it writes a single value to
>> the guest physical address. The implementation is built upon put_user()
>> and so it has the same single copy atomic properties.
> 
> What you mean by "single copy atomic"?  I.e. what guarantees does
> put_user() provide that __copy_to_user() does not?

Single-copy atomicity is defined by the Arm architecture[1] and I'm not
going to try to go into the full details here, so this is a summary.

For the sake of this feature what we care about is that the value
written/read cannot be "torn". In other words if there is a read (in
this case from another VCPU) that is racing with the write then the read
will either get the old value or the new value. It cannot return a
mixture. (This is of course assuming that the read is using a
single-copy atomic safe method).

__copy_to_user() is implemented as a memcpy() and as such cannot provide
single-copy atomicity in the general case (the buffer could easily be
bigger than the architecture can guarantee).

put_user() on the other hand is implemented (on arm64) as an explicit
store instruction and therefore is guaranteed by the architecture to be
single-copy atomic (i.e. another CPU cannot see a half-written value).

Steve

[1] https://static.docs.arm.com/ddi0487/ea/DDI0487E_a_armv8_arm.pdf#page=110
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
