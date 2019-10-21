Return-Path: <SRS0=mQ94=YO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40604CA9EAF
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 13:37:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B78B420873
	for <kvmarm@archiver.kernel.org>; Mon, 21 Oct 2019 13:37:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B78B420873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 260C24A9D5;
	Mon, 21 Oct 2019 09:37:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WBne+aNJLA1F; Mon, 21 Oct 2019 09:37:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F3F14A991;
	Mon, 21 Oct 2019 09:37:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 891654A96B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 09:37:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2Fc+uVBqmTCo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Oct 2019 09:37:29 -0400 (EDT)
Received: from foss.arm.com (unknown [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67E8A4A73A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Oct 2019 09:37:29 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 013AB493;
 Mon, 21 Oct 2019 06:37:09 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 87DD13F718;
 Mon, 21 Oct 2019 06:37:08 -0700 (PDT)
Date: Mon, 21 Oct 2019 15:37:07 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 0/2] Improve handling of stage 2 aborts without
 instruction decode
Message-ID: <20191021133707.GA2652@e113682-lin.lund.arm.com>
References: <20191011110709.2764-1-christoffer.dall@arm.com>
 <865zkjzpbf.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <865zkjzpbf.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: =?utf-8?B?IkRhbmllbCBQLiBCZXJyYW5nw6ki?= <berrange@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>,
 Stefan Hajnoczi <stefanha@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Sun, Oct 20, 2019 at 11:25:24AM +0100, Marc Zyngier wrote:
> Hi Christoffer,
> 
> On Fri, 11 Oct 2019 12:07:04 +0100,
> Christoffer Dall <christoffer.dall@arm.com> wrote:
> > 
> > When a guest accesses memory outside the memory slots, KVM usually
> > bounces the access back to userspace with KVM_EXIT_MMIO.  However, on
> > arm/arm64 systems, certain load/store instructions did not provide
> > decoding info for the hypervisor to emulate the instruction, and in this
> > case KVM has rather rudely returned -ENOSYS and printed a not overly
> > helpful error message:
> > 
> >   load/store instruction decoding not implemented
> > 
> > This patch series improves the error message and allows userspace to be
> > notified of this event instead of receiving -ENOSYS, and also allows
> > userspace to ask KVM to inject an external abort to the guest, which it
> > can use for any memory access that it either cannot handle.
> > 
> > One remaining case which this patch set does not address is if the guest
> > accesses an in-kernel emulated device, such as the VGIC, but using a
> > load/store instruction which doesn't provide decode info.  With these
> > patches, this will return to userspace for it to handle, but there's no
> > way for userspace to return the decoding information to KVM and have KVM
> > complete the access to the in-kernel emulated device.  I have no plans
> > to address this limitation.
> 
> You had some pending comments on patch 2, and you seem to indicate
> that you would respin the series. Do you have plans to do so in the
> coming days? I'd like to put that series into -next, but I can either
> wait for your respin, or queue it as it is and apply fixes on top.
> 

I think those for v2 and this is v3 which should address those concerns.
Did I miss something or manage to confuse mysel here?

Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
