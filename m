Return-Path: <SRS0=dYxC=VI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B853C74A4B
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jul 2019 10:07:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C7242208E4
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jul 2019 10:07:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="nOUvVPeS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C7242208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D9974A506;
	Thu, 11 Jul 2019 06:07:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id E+RRF0taZdiN; Thu, 11 Jul 2019 06:07:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7612D4A541;
	Thu, 11 Jul 2019 06:07:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA1DD4A4FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 05:59:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gUYbaHZtXJPE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jul 2019 05:59:14 -0400 (EDT)
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com
 [207.171.190.10])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C3364A369
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 05:59:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1562839154; x=1594375154;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=W+BY+BDHpadPTc6gpQ0QnhWpwEB27thoesZOWy03oIw=;
 b=nOUvVPeStvn0seGqfERbfs8TskcxJaQY7aL5LeKsIA65KUZa2/m1+Uy/
 r82I7NA3g7R7nBHgusm13gsCQPoeH8DtFTXtdAAO5naN6bNEtn8AnbKjC
 1uOdyNEdCv3jvrl3/eHjuhwcBO36wWZ79JBvUq0BqzCmPpGhJLSmjDzlH A=;
X-IronPort-AV: E=Sophos;i="5.62,478,1554768000"; d="scan'208";a="810609096"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO
 email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.22.38])
 by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP;
 11 Jul 2019 09:59:11 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
 by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS
 id 66878A209B; Thu, 11 Jul 2019 09:59:11 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 11 Jul 2019 09:59:10 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.30) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 11 Jul 2019 09:59:09 +0000
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To: Andre Przywara <andre.przywara@arm.com>, Paolo Bonzini
 <pbonzini@redhat.com>
References: <20190710132724.28350-1-graf@amazon.com>
 <20190710180235.25c54b84@donnerap.cambridge.arm.com>
 <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
 <1537a9f2-9d23-97dd-b195-8239b263d5db@amazon.com>
 <8c88eb2e-b401-42c7-f04f-2162f26af32c@redhat.com>
 <20190711104200.254073fb@donnerap.cambridge.arm.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <e1ea413e-a809-2a42-3888-204d7c037ab3@amazon.com>
Date: Thu, 11 Jul 2019 11:59:07 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190711104200.254073fb@donnerap.cambridge.arm.com>
Content-Language: en-US
X-Originating-IP: [10.43.161.30]
X-ClientProxiedBy: EX13D07UWB001.ant.amazon.com (10.43.161.238) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
X-Mailman-Approved-At: Thu, 11 Jul 2019 06:07:52 -0400
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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



On 11.07.19 11:42, Andre Przywara wrote:
> On Thu, 11 Jul 2019 09:52:42 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> Hi,
> 
>> On 11/07/19 07:49, Alexander Graf wrote:
>>>> I agree that it would belong more in qtest, but tests in not exactly the
>>>> right place is better than no tests.
>>>
>>> The problem with qtest is that it tests QEMU device models from a QEMU
>>> internal view.
>>
>> Not really: fundamentally it tests QEMU device models with stimuli that
>> come from another process in the host, rather than code that runs in a
>> guest.  It does have hooks into QEMU's internal view (mostly to
>> intercept interrupts and advance the clocks), but the main feature of
>> the protocol is the ability to do memory reads and writes.
>>
>>> I am much more interested in the guest visible side of things. If
>>> kvmtool wanted to implement a PL031, it should be able to execute the
>>> same test that we run against QEMU, no?
> 
> One of the design goals of kvmtool is to get away with as little emulation
> as possible, in favour of paravirtualisation (so it's just virtio and not
> IDE/flash). So a hardware RTC emulation sounds dispensable in this context.

The main reason to have a PL031 exposed to a VM is to make OVMF happy, 
so that it can provide wall clock time runtime services. I suppose that 
sooner or later you may want to run OVMF in kvmtool as well, no?

The alternative to the PL031 here is to do a PV interface, yes. I'm not 
really convinced that that would be any easier though. The PL031 is a 
very trivial device. The only real downside is that it will wrap around 
in 2038.


Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
