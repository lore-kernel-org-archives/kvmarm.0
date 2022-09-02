Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFAFC54EE9
	for <kvmarm@archiver.kernel.org>; Fri,  2 Sep 2022 13:41:59 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6CAE4B28C;
	Fri,  2 Sep 2022 09:41:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C+X7lXPlYJRM; Fri,  2 Sep 2022 09:41:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E2514B2AA;
	Fri,  2 Sep 2022 09:41:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7B7F4B21C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 09:41:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uOe6B0MOalJy for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Sep 2022 09:41:55 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A5DB4B19D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Sep 2022 09:41:55 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 4C80DB82A96;
 Fri,  2 Sep 2022 13:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C0EC433C1;
 Fri,  2 Sep 2022 13:41:51 +0000 (UTC)
Date: Fri, 2 Sep 2022 14:41:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v3 5/7] KVM: arm64: unify the tests for VMAs in memslots
 when MTE is enabled
Message-ID: <YxIIG4SNfiqT38kS@arm.com>
References: <20220810193033.1090251-1-pcc@google.com>
 <20220810193033.1090251-6-pcc@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220810193033.1090251-6-pcc@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Cornelia Huck <cohuck@redhat.com>, Steven Price <steven.price@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Evgenii Stepanov <eugenis@google.com>
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

On Wed, Aug 10, 2022 at 12:30:31PM -0700, Peter Collingbourne wrote:
> Previously we allowed creating a memslot containing a private mapping that
> was not VM_MTE_ALLOWED, but would later reject KVM_RUN with -EFAULT. Now
> we reject the memory region at memslot creation time.
> 
> Since this is a minor tweak to the ABI (a VMM that created one of
> these memslots would fail later anyway), no VMM to my knowledge has
> MTE support yet, and the hardware with the necessary features is not
> generally available, we can probably make this ABI change at this point.

I don't think that's a noticeable ABI change. As you said, such VMs
would fail later anyway when trying to access such page.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
