Return-Path: <SRS0=o21O=7A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B645C433DF
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 11:37:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1F7F720709
	for <kvmarm@archiver.kernel.org>; Mon, 18 May 2020 11:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QA9aCMGY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F7F720709
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BAC84B152;
	Mon, 18 May 2020 07:37:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 05R1GtiXhIaK; Mon, 18 May 2020 07:37:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 665984B13A;
	Mon, 18 May 2020 07:37:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75D244B13C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 07:34:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HyZay0k-WwI7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 May 2020 07:34:52 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 753274B122
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 May 2020 07:34:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1589801692;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=axzfvw01wKGMv0XjT3WxiaIUsh/NNhfJTMtM8xCVCPM=;
 b=QA9aCMGY3bJDy6m2I2svakduPdfsD+31OcneLp6bfVaizFlFGkjdN5oWCtf3pVsKdkOOPq
 fn5G2dhzttd6f9bkJOswU2kDenNFDh2pWNGwkDl7PNj71SHYhoQR/lrEcIWReUL+i9tQoq
 z1FWPhANeU677gzQg32y0AhkytnK6tY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-c0bH51AyMhaUko4ZCwkNQw-1; Mon, 18 May 2020 07:34:48 -0400
X-MC-Unique: c0bH51AyMhaUko4ZCwkNQw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15009A0BD7;
 Mon, 18 May 2020 11:34:46 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.189])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 415415C1B5;
 Mon, 18 May 2020 11:34:39 +0000 (UTC)
Message-ID: <680e86ca19dd9270b95917da1d65e4b4d2bb18a9.camel@redhat.com>
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Anastassios Nanos
 <ananos@nubificus.co.uk>, Marc Zyngier <maz@kernel.org>
Date: Mon, 18 May 2020 14:34:38 +0300
In-Reply-To: <760e0927-d3a7-a8c6-b769-55f43a65e095@redhat.com>
References: <cover.1589784221.git.ananos@nubificus.co.uk>
 <c1124c27293769f8e4836fb8fdbd5adf@kernel.org>
 <CALRTab90UyMq2hMxCdCmC3GwPWFn2tK_uKMYQP2YBRcHwzkEUQ@mail.gmail.com>
 <760e0927-d3a7-a8c6-b769-55f43a65e095@redhat.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Mailman-Approved-At: Mon, 18 May 2020 07:37:28 -0400
Cc: Thomas Gleixner <tglx@linutronix.de>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Mon, 2020-05-18 at 13:18 +0200, Paolo Bonzini wrote:
> On 18/05/20 10:45, Anastassios Nanos wrote:
> > Being in the kernel saves us from doing unneccessary mode switches.
> > Of course there are optimizations for handling I/O on QEMU/KVM VMs
> > (virtio/vhost), but essentially what happens is removing mode-switches (and
> > exits) for I/O operations -- is there a good reason not to address that
> > directly? a guest running in the kernel exits because of an I/O request,
> > which gets processed and forwarded directly to the relevant subsystem *in*
> > the kernel (net/block etc.).
> 
> In high-performance configurations, most of the time virtio devices are
> processed in another thread that polls on the virtio rings.  In this
> setup, the rings are configured to not cause a vmexit at all; this has
> much smaller latency than even a lightweight (kernel-only) vmexit,
> basically corresponding to writing an L1 cache line back to L2.
> 
> Paolo
> 
This can be used to run kernel drivers inside a very thin VM IMHO to break up the stigma,
that kernel driver is always a bad thing to and should be by all means replaced by a userspace driver,
something I see a lot lately, and what was the ground for rejection of my nvme-mdev proposal.


Best regards,
	Maxim Levitsky


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
