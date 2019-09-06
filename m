Return-Path: <SRS0=tFZo=XB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2987BC43331
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 13:41:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5F1320842
	for <kvmarm@archiver.kernel.org>; Fri,  6 Sep 2019 13:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="V103KYjn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5F1320842
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 279F74A557;
	Fri,  6 Sep 2019 09:41:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K04b0J2ZRvUX; Fri,  6 Sep 2019 09:41:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCA5D4A5BB;
	Fri,  6 Sep 2019 09:41:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C84534A568
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 09:41:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id knrMNjkHf0pt for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Sep 2019 09:41:31 -0400 (EDT)
Received: from smtp-fw-4101.amazon.com (smtp-fw-4101.amazon.com [72.21.198.25])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CC7A4A5BA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Sep 2019 09:41:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
 t=1567777289; x=1599313289;
 h=subject:to:cc:references:from:message-id:date:
 mime-version:in-reply-to:content-transfer-encoding;
 bh=XMIKAY1xJL7NYmAZNKLAmXbXU9LqB+oBH7gwXT7mxi8=;
 b=V103KYjnlek9k+nL+OVEjDwuZdjOUKzrO7ByegAxEQKVOm42LtsYvtP3
 lXtO6IOeT223cMU8QZzIQ1Um0sHXjjGdeGlbBpP7YAjBprowS5UkW/4Qp
 5VShguIqxbuW+n6jUwLtiG0vRh/1CTThdgTgHMR0xO6ZWZof+DT0tsOJg 8=;
X-IronPort-AV: E=Sophos;i="5.64,473,1559520000"; d="scan'208";a="783639180"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.124.125.6])
 by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP;
 06 Sep 2019 13:41:26 +0000
Received: from EX13MTAUWC001.ant.amazon.com
 (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
 by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS
 id 5EB25A17B2; Fri,  6 Sep 2019 13:41:25 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 6 Sep 2019 13:41:24 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.218) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 6 Sep 2019 13:41:22 +0000
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
To: Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall
 <christoffer.dall@arm.com>
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <86r24vrwyh.wl-maz@kernel.org>
 <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
 <86mufjrup7.wl-maz@kernel.org>
 <CAFEAcA9qkqkOTqSVrhTpt-NkZSNXomSBNiWo_D6Kr=QKYRRf=w@mail.gmail.com>
 <20190905092223.GC4320@e113682-lin.lund.arm.com>
 <4b6662bd-56e4-3c10-3b65-7c90828a22f9@kernel.org>
 <20190906080033.GF4320@e113682-lin.lund.arm.com>
 <a58c5f76-641a-8381-2cf3-e52d139c4236@amazon.com>
 <20190906131252.GG4320@e113682-lin.lund.arm.com>
 <CAFEAcA9vwyhAN8uO8=PpaBkBXb0Of4G0jEij7nMrYcnJjSRVjg@mail.gmail.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <28c5c021-7cb0-616b-4215-dd75242c16e6@amazon.com>
Date: Fri, 6 Sep 2019 15:41:20 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA9vwyhAN8uO8=PpaBkBXb0Of4G0jEij7nMrYcnJjSRVjg@mail.gmail.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.218]
X-ClientProxiedBy: EX13D16UWB004.ant.amazon.com (10.43.161.170) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Precedence: Bulk
Cc: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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



On 06.09.19 15:31, Peter Maydell wrote:
> On Fri, 6 Sep 2019 at 14:13, Christoffer Dall <christoffer.dall@arm.com> wrote:
>> I'd prefer leaving it to userspace to worry about, but I thought Peter
>> said that had been problematic historically, which I took at face value,
>> but I could have misunderstood.
>>
>> If QEMU, kvmtool, and whatever the crazy^H cool kids are using in
>> userspace these days are happy emulating the exception, then that's a
>> viable approach.  The main concern I have with that is whether they'll
>> all get it right, and since we already have the code in the kernel to do
>> this, it might make sense to re-use the kernel logic for it.
> 
> Well, for QEMU we've had code that in theory might do this but
> in practice it's never been tested. Essentially the problem is
> that nobody ever wants to inject an exception from userspace
> except in incredibly rare cases like "trying to use h/w breakpoints
> simultaneously inside the VM and also to debug the VM from outside"
> or "we're running on RAS hardware that just told us that the VM's
> RAM was faulty". There's no even vaguely commonly-used usecase
> for it today; and this ABI suggestion adds another "this is in
> practice almost never going to happen" case to the pile. The
> codepath is unreliable in QEMU because (a) it requires getting
> syncing of sysreg values to and from the kernel right -- this is
> about the only situation where userspace wants to modify sysregs
> during execution of the VM, as opposed to just reading them -- and
> (b) we try to reuse the code we already have that does TCG exception
> injection, which might or might not be a design mistake, and

That's probably a design mistake, correct :)

> (c) as noted above it's a never-actually-used untested codepath...

Sounds like an easy thing to resolve using kvm-unit-tests?

> So I think if I were you I wouldn't commit to the kernel ABI until
> somebody had at least written some RFC-quality patches for QEMU and
> tested that they work and the ABI is OK in that sense. (For the
> avoidance of doubt, I'm not volunteering to do that myself.)
> I don't object to the idea in principle, though.
> 
> PS: the other "injecting exceptions to the guest" oddity is that
> if the kernel *does* find the ISV information and returns to userspace
> for it to handle the MMIO, there's no way for userspace to say
> "actually that address is supposed to generate a data abort".

I think we're converging here. My proposal is that "inject a fault" 
should not be something special cased for the "I can't decode the 
instruction" case, but rather that we need a more generic mechanism.

Whether that's a new ioctl, a flag we set on entry or something else is 
an implementation detail I'll be happy to leave for discussion.

The only thing I'd like to avoid seeing is that we create a new user 
space ABI that makes it easy to inject a single, particular exception, 
but not solve all of the other cases while creating extra work to just 
implement instruction decoding in user space.


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
