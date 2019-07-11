Return-Path: <SRS0=dYxC=VI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031DAC74A51
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jul 2019 09:42:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E46B20872
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jul 2019 09:42:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E46B20872
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B0B54A518;
	Thu, 11 Jul 2019 05:42:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id do4mta8dGYCz; Thu, 11 Jul 2019 05:42:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A362A4A4F8;
	Thu, 11 Jul 2019 05:42:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A49174A4F8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 05:42:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id floUYAETKl6c for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jul 2019 05:42:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 292DA4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 05:42:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2951337;
 Thu, 11 Jul 2019 02:42:03 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3EC93F71F;
 Thu, 11 Jul 2019 02:42:02 -0700 (PDT)
Date: Thu, 11 Jul 2019 10:42:00 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
Message-ID: <20190711104200.254073fb@donnerap.cambridge.arm.com>
In-Reply-To: <8c88eb2e-b401-42c7-f04f-2162f26af32c@redhat.com>
References: <20190710132724.28350-1-graf@amazon.com>
 <20190710180235.25c54b84@donnerap.cambridge.arm.com>
 <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
 <1537a9f2-9d23-97dd-b195-8239b263d5db@amazon.com>
 <8c88eb2e-b401-42c7-f04f-2162f26af32c@redhat.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <graf@amazon.com>,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

On Thu, 11 Jul 2019 09:52:42 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

Hi,

> On 11/07/19 07:49, Alexander Graf wrote:
> >> I agree that it would belong more in qtest, but tests in not exactly the
> >> right place is better than no tests.  
> > 
> > The problem with qtest is that it tests QEMU device models from a QEMU
> > internal view.  
> 
> Not really: fundamentally it tests QEMU device models with stimuli that
> come from another process in the host, rather than code that runs in a
> guest.  It does have hooks into QEMU's internal view (mostly to
> intercept interrupts and advance the clocks), but the main feature of
> the protocol is the ability to do memory reads and writes.
> 
> > I am much more interested in the guest visible side of things. If
> > kvmtool wanted to implement a PL031, it should be able to execute the
> > same test that we run against QEMU, no?  

One of the design goals of kvmtool is to get away with as little emulation
as possible, in favour of paravirtualisation (so it's just virtio and not
IDE/flash). So a hardware RTC emulation sounds dispensable in this context.
 
> Well, kvmtool could also implement the qtest protocol; perhaps it should
> (probably as a different executable that shares the device models with
> the main kvmtool executable).  There would still be issues in reusing
> code from the QEMU tests, since it has references to QEMU command line
> options.

I had some patches to better abstract kvm-unit-tests from QEMU, basically
by splitting up extra_params into more generic options like memsize and
command_line, then translating them.
Sounds like the time to revive them.

> > If kvm-unit-test is the wrong place for it, we would probably want to
> > have a separate testing framework for guest side unit tests targeting
> > emulated devices.
> > 
> > Given how nice the kvm-unit-test framework is though, I'd rather rename
> > it to "virt-unit-test" than reinvent the wheel :).  
> 
> Definitely, or even just "hwtest". :)  With my QEMU hat I would prefer
> the test to be a qtest, but with my kvm-unit-tests hat on I see no
> reason to reject this test.  Sorry if this was not clear.

Fair enough, at the moment we have to trigger kvmtool tests manually
anyway. Just wanted to know what the idea is here, which I think you
answered.

Thanks,
Andre.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
