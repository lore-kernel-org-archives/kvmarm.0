Return-Path: <SRS0=C/bf=LA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720DBC47096
	for <kvmarm@archiver.kernel.org>; Sun,  6 Jun 2021 10:10:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E3979613EF
	for <kvmarm@archiver.kernel.org>; Sun,  6 Jun 2021 10:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E3979613EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B3354A173;
	Sun,  6 Jun 2021 06:10:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QP80KrZoI35t; Sun,  6 Jun 2021 06:10:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19EB040870;
	Sun,  6 Jun 2021 06:10:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22B7A40839
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Jun 2021 06:10:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zDG2fETgvP8o for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Jun 2021 06:10:52 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C584940629
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Jun 2021 06:10:52 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AB58760FEE;
 Sun,  6 Jun 2021 10:10:51 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1lppk1-005kDE-KN; Sun, 06 Jun 2021 11:10:49 +0100
MIME-Version: 1.0
Date: Sun, 06 Jun 2021 11:10:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
In-Reply-To: <YLqzI9THXBX2dWDE@google.com>
References: <20210604181833.1769900-1-ricarkol@google.com>
 <YLqanpE8tdiNeoaN@google.com> <YLqzI9THXBX2dWDE@google.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <6d1f569a5260612eb0704e31655d168d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ricarkol@google.com, seanjc@google.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com,
 drjones@redhat.com, eric.auger@redhat.com, oliver.sang@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 kernel test robot <oliver.sang@intel.com>, pbonzini@redhat.com,
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

On 2021-06-05 00:11, Ricardo Koller wrote:
> On Fri, Jun 04, 2021 at 09:26:54PM +0000, Sean Christopherson wrote:
>> On Fri, Jun 04, 2021, Ricardo Koller wrote:
>> > Kernel test robot reports this:
>> >
>> > > /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:157: undefined reference to `vm_handle_exception'
>> > > /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:158: undefined reference to `vm_handle_exception'
>> > > collect2: error: ld returned 1 exit status
>> >
>> > Fix it by renaming vm_handle_exception to vm_install_vector_handler in
>> > evmcs_test.c.
>> >
>> > Fixes: a2bad6a990a4 ("KVM: selftests: Rename vm_handle_exception")
>> 
>> Belated code review...
> 
> Thanks for the review.
> 
>> Can we rename the helper to vm_install_exception_handler()?
>> 
>> In x86, "vector" is the number of the exception and "vectoring" is the 
>> process
>> of determining the resulting vector that gets delivered to software 
>> (e.g. when
>> dealing with contributory faults like #GP->#PF->#DF), but the thing 
>> that's being
>> handled is an exception.
> 
> Got it. What about this renaming:
> 
>   vm_handle_exception(vec) 		-> vm_install_exception_handler(vec)
>   vm_install_exception_handler(vec, ec)	-> vm_install_sync_handler(vec, 
> ec)
> 
>> 
>> arm appears to have similar terminology.  And looking at the arm code, 
>> it's very
>> confusing to have a helper vm_install_vector_handler() install into
>> exception_handlers, _not_ into vector_handlers.  Calling the 
>> vector_handlers
>> "default" handlers is also confusing, as "default" usually implies the 
>> thing can
>> be overwritten.  But in this case, the "default" handler is just 
>> another layer
>> in the routing.
>> 
>> The multiple layers of routing is also confusing and a bit hard to 
>> wade through
>> for the uninitiated.  The whole thing can be made more straightfoward 
>> by doing
>> away with the intermediate routing, whacking ~50 lines of code in the 
>> process.
>> E.g. (definitely not functional code):
> 
> I think that works and it does remove a bunch of code. Just need to 
> play
> with the idea and check that it can cover all cases.
> 
> For now, given that the build is broken, what about this series of
> patches:
> 
> 1. keep this patch to fix x86 kvm selftests
> 2. rename both arm and x86 to vm_install_exception_handler and
> vm_install_sync_handler
> 3. restructure the internals of exception handling in arm
> 
> Alternatively, I can send 1+2 together and then 3. What do you think?

This is becoming a bit messy. I'd rather drop the whole series from
-next, and get something that doesn't break in the middle. Please
resend the series tested on top of -rc4.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
