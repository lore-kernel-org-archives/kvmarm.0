Return-Path: <SRS0=dYxC=VI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB980C74A4B
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jul 2019 07:52:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6E8D4208E4
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jul 2019 07:52:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E8D4208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDADE4A4A9;
	Thu, 11 Jul 2019 03:52:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yF+mIUtPUhJW; Thu, 11 Jul 2019 03:52:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5A474A4DF;
	Thu, 11 Jul 2019 03:52:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FEE64A4BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 03:52:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pttHkdsSF1Wu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jul 2019 03:52:45 -0400 (EDT)
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com
 [209.85.221.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E5ED4A4A9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 03:52:45 -0400 (EDT)
Received: by mail-wr1-f68.google.com with SMTP id p13so5114557wru.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 00:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=0eQT9U+ySDhN1Rp7c4eWQ7uBiGRgy3zkrcnHUZ9sazo=;
 b=gWB/l4RqSuZAh4xf9j19Dcr+GA5iTogqTmt/FucCDIjNswQs099yD2v0O++aW1jPGE
 /QebQ4/HDytII6jrC6au6Go1QUGIp1MM0TSILoWk8fLcBtbdIY8+4dYgG2vcYECw09ub
 BLchxEKZIQzbE1T+X4bICqv7t7hkLo+eUM9Kai+8d03efrbh9MqIDi2cS9Ah9rfiP++r
 o87SxeGNcXFR0PLf7a2lZuAr2K1V5PAoJDcKkfVRYALfNu8pZu1csd8Lxsmskuwd0/JH
 i023IKEmmzJAl3+RtyfSDv6qWsQfAE4juwa9DjRsWYkRGNJPkv/gZOamC/IXOBEbBFlC
 jbJw==
X-Gm-Message-State: APjAAAUYt+Hr1iKNn++tpuodQDH0eqxz/uXOo2VGE6VbtHT6NiW4vXOY
 ANjpQB4jg8+6V2qXSb0K4lIfboh6hF8=
X-Google-Smtp-Source: APXvYqzczFDh0c/gcZge3Wef96/ux6nizriw1jHvvaR0X6MGlzhO9gsosffCTmt+HhncNDC8NZeZ6w==
X-Received: by 2002:adf:ed41:: with SMTP id u1mr3098151wro.162.1562831564315; 
 Thu, 11 Jul 2019 00:52:44 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
 by smtp.gmail.com with ESMTPSA id f204sm5014690wme.18.2019.07.11.00.52.43
 (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
 Thu, 11 Jul 2019 00:52:43 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To: Alexander Graf <graf@amazon.com>, Andre Przywara <andre.przywara@arm.com>
References: <20190710132724.28350-1-graf@amazon.com>
 <20190710180235.25c54b84@donnerap.cambridge.arm.com>
 <35e19306-d31b-187b-185d-e783f8d5a51a@redhat.com>
 <1537a9f2-9d23-97dd-b195-8239b263d5db@amazon.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c88eb2e-b401-42c7-f04f-2162f26af32c@redhat.com>
Date: Thu, 11 Jul 2019 09:52:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1537a9f2-9d23-97dd-b195-8239b263d5db@amazon.com>
Content-Language: en-US
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 11/07/19 07:49, Alexander Graf wrote:
>> I agree that it would belong more in qtest, but tests in not exactly the
>> right place is better than no tests.
> 
> The problem with qtest is that it tests QEMU device models from a QEMU
> internal view.

Not really: fundamentally it tests QEMU device models with stimuli that
come from another process in the host, rather than code that runs in a
guest.  It does have hooks into QEMU's internal view (mostly to
intercept interrupts and advance the clocks), but the main feature of
the protocol is the ability to do memory reads and writes.

> I am much more interested in the guest visible side of things. If
> kvmtool wanted to implement a PL031, it should be able to execute the
> same test that we run against QEMU, no?

Well, kvmtool could also implement the qtest protocol; perhaps it should
(probably as a different executable that shares the device models with
the main kvmtool executable).  There would still be issues in reusing
code from the QEMU tests, since it has references to QEMU command line
options.

> If kvm-unit-test is the wrong place for it, we would probably want to
> have a separate testing framework for guest side unit tests targeting
> emulated devices.
> 
> Given how nice the kvm-unit-test framework is though, I'd rather rename
> it to "virt-unit-test" than reinvent the wheel :).

Definitely, or even just "hwtest". :)  With my QEMU hat I would prefer
the test to be a qtest, but with my kvm-unit-tests hat on I see no
reason to reject this test.  Sorry if this was not clear.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
