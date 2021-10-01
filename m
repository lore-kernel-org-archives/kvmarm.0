Return-Path: <SRS0=fGD+=OV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D92C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 10:33:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 25B9761A81
	for <kvmarm@archiver.kernel.org>; Fri,  1 Oct 2021 10:33:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 25B9761A81
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D7D5407D1;
	Fri,  1 Oct 2021 06:33:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2we1MALd6k2t; Fri,  1 Oct 2021 06:33:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8219D4A98B;
	Fri,  1 Oct 2021 06:33:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3921A407D1
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 06:33:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2ysQfkx7mTSA for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Oct 2021 06:33:55 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4549F40630
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Oct 2021 06:33:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1633084435;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QSuR70xnv39bycvobYUkYW+O6E+zsW6wFcCu0xUN0TI=;
 b=dJjWDDu6WBBKGG1EMXtRTnejaAf4tZHKObdmyBmeFnhZz1pva5ZYOSv17LhMHyEU711/X+
 0j1H0vK99RSP0MyYNjRR8naBcm1uie/gPaai883FG/B3KRPs8vAkMeKnz7iDXh9bAsf6p+
 7MgwJGT+onkr4sPfYmFR2k5cRLEtBpI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-QXwW9Tt8MzW1jONRM1vepQ-1; Fri, 01 Oct 2021 06:33:53 -0400
X-MC-Unique: QXwW9Tt8MzW1jONRM1vepQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74D621927800;
 Fri,  1 Oct 2021 10:33:51 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 93B5A18AD4;
 Fri,  1 Oct 2021 10:33:50 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
 id 3FC70416CE5D; Fri,  1 Oct 2021 07:32:00 -0300 (-03)
Date: Fri, 1 Oct 2021 07:32:00 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v8 7/7] KVM: x86: Expose TSC offset controls to userspace
Message-ID: <20211001103200.GA39746@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-8-oupton@google.com>
 <20210930191416.GA19068@fuller.cnet>
 <48151d08-ee29-2b98-b6e1-f3c8a1ff26bc@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <48151d08-ee29-2b98-b6e1-f3c8a1ff26bc@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Peter Shier <pshier@google.com>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Will Deacon <will@kernel.org>,
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

On Fri, Oct 01, 2021 at 11:17:33AM +0200, Paolo Bonzini wrote:
> On 30/09/21 21:14, Marcelo Tosatti wrote:
> > > +   new_off_n = t_0 + off_n + (k_1 - k_0) * freq - t_1
> > Hi Oliver,
> > 
> > This won't advance the TSC values themselves, right?
> 
> Why not?  It affects the TSC offset in the vmcs, so the TSC in the VM is
> advanced too.
> 
> Paolo

+4. Invoke the KVM_SET_CLOCK ioctl, providing the kvmclock nanoseconds
+   (k_0) and realtime nanoseconds (r_0) in their respective fields.
+   Ensure that the KVM_CLOCK_REALTIME flag is set in the provided
+   structure. KVM will advance the VM's kvmclock to account for elapsed
+   time since recording the clock values.

You can't advance both kvmclock (kvmclock_offset variable) and the TSCs,
which would be double counting.

So you have to either add the elapsed realtime (1) between KVM_GET_CLOCK
to kvmclock (which this patch is doing), or to the TSCs. If you do both, there
is double counting. Am i missing something?

To make it clearer: TSC clocksource is faster than kvmclock source, so
we'd rather use when possible, which is achievable with TSC scaling 
support on HW.

1: As mentioned earlier, just using the realtime clock delta between
hosts can introduce problems. So need a scheme to:

	- Find the offset between host clocks, with upper and lower
	  bounds on error.
	- Take appropriate actions based on that (for example,
	  do not use KVM_CLOCK_REALTIME flag on KVM_SET_CLOCK
	  if the delta between hosts is large).

Which can be done in userspace or kernel space... (hum, but maybe
delegating this to userspace will introduce different solutions
of the same problem?).

> > This (advancing the TSC values by the realtime elapsed time) would be
> > awesome because TSC clock_gettime() vdso is faster, and some
> > applications prefer to just read from TSC directly.
> > See "x86: kvmguest: use TSC clocksource if invariant TSC is exposed".
> > 
> > The advancement with this patchset only applies to kvmclock.
> > 
> 
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
