Return-Path: <SRS0=cDTT=YQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D64CA9EB6
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 09:29:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3F80221A4C
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 09:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F80221A4C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C512A4A954;
	Wed, 23 Oct 2019 05:29:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Do-QL-ZmCXoj; Wed, 23 Oct 2019 05:29:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B100A4A95B;
	Wed, 23 Oct 2019 05:29:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4424A954
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Oct 2019 05:29:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XBnbWRz92HHW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Oct 2019 05:29:41 -0400 (EDT)
Received: from foss.arm.com (unknown [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9AA74A8EB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Oct 2019 05:29:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7286D15DB;
 Wed, 23 Oct 2019 02:29:21 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1A653F718;
 Wed, 23 Oct 2019 02:29:20 -0700 (PDT)
Date: Wed, 23 Oct 2019 11:29:19 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 09/15] KVM: Move memslot deletion to helper function
Message-ID: <20191023092919.GF2652@e113682-lin.lund.arm.com>
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-10-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20191022003537.13013-10-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
 James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

Hi Sean,

On Mon, Oct 21, 2019 at 05:35:31PM -0700, Sean Christopherson wrote:
> Move memslot deletion into its own routine so that the success path for
> other memslot updates does not need to use kvm_free_memslot(), i.e. can
> explicitly destroy the dirty bitmap when necessary.  This paves the way
> for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
> NULL for @dont.
> 
> Add a comment above the code to make a copy of the existing memslot
> prior to deletion, it is not at all obvious that the pointer will become
> stale due sorting and/or installation of new memslots.

nit: due to / during

> 
> Note, kvm_arch_commit_memory_region() allows an architecture to free
> resources when moving a memslot or changing its flags, i.e. implement
> logic similar to the dirty bitmap is handling, if such functionality is

nit: s/is handling/handling/

> needed in the future.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Otherwise looks good to me.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
