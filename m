Return-Path: <SRS0=dYxC=VI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F09DC74A4B
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jul 2019 10:07:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E70AE208E4
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jul 2019 10:07:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="otF2lq3q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E70AE208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AD9C4A49C;
	Thu, 11 Jul 2019 06:07:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lnow3e4D-abS; Thu, 11 Jul 2019 06:07:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D3914A518;
	Thu, 11 Jul 2019 06:07:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEC844A52E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 01:49:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BDKy5mbZZ1Cr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jul 2019 01:49:54 -0400 (EDT)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com
 [207.171.184.29])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DD7E4A4FF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 01:49:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1562824194; x=1594360194;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=wHeGT4hyzwEYhrwtHzWbpeS08ZRBQe5s5SLIUut76AM=;
 b=otF2lq3qInyQoPQm4w5N8mnKDK40g0EhVx92kBaiS0iji9dWxKKCd+9g
 8pwYS3lk6jg8J35bPrCXoyNdhrIhhTXiCl7Ydr65dpnyuxtt9lY0BzWlU
 yXnk6kdYuvqa3V1xPKXGTk2Znyz+mpxRTT+8GPbcii4yB7xhZjxfj5+jb k=;
X-IronPort-AV: E=Sophos;i="5.62,476,1554768000"; d="scan'208";a="684877205"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO
 email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.47.22.34])
 by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP;
 11 Jul 2019 05:49:51 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
 by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS
 id EBF12A2402; Thu, 11 Jul 2019 05:49:49 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 11 Jul 2019 05:49:49 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.144) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 11 Jul 2019 05:49:47 +0000
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara
 <andre.przywara@arm.com>
References: <20190710132724.28350-1-graf@amazon.com>
 <20190710180235.25c54b84@donnerap.cambridge.arm.com>
 <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <1537a9f2-9d23-97dd-b195-8239b263d5db@amazon.com>
Date: Thu, 11 Jul 2019 07:49:45 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D19UWC002.ant.amazon.com (10.43.162.179) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Precedence: Bulk
X-Mailman-Approved-At: Thu, 11 Jul 2019 06:07:52 -0400
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
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



On 10.07.19 19:06, Paolo Bonzini wrote:
> On 10/07/19 19:02, Andre Przywara wrote:
>>> + * This test verifies whether the emulated PL031 behaves
>>> correctly.
>> ^^^^^^^^
>>
>> While I appreciate the effort and like the fact that this actually
>> triggers an SPI, I wonder if this actually belongs into
>> kvm-unit-tests. After all this just test a device purely emulated in
>> (QEMU) userland, so it's not really KVM related.
>>
>> What is the general opinion on this? Don't we care about this
>> hair-splitting as long as it helps testing? Do we even want to extend
>> kvm-unit-tests coverage to more emulated devices, for instance
>> virtio?
> 
> I agree that it would belong more in qtest, but tests in not exactly the
> right place is better than no tests.

The problem with qtest is that it tests QEMU device models from a QEMU 
internal view.

I am much more interested in the guest visible side of things. If 
kvmtool wanted to implement a PL031, it should be able to execute the 
same test that we run against QEMU, no?

If kvm-unit-test is the wrong place for it, we would probably want to 
have a separate testing framework for guest side unit tests targeting 
emulated devices.

Given how nice the kvm-unit-test framework is though, I'd rather rename 
it to "virt-unit-test" than reinvent the wheel :).


Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
