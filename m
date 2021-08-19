Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D55C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 18:43:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 64E4A610A5
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 18:43:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 64E4A610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3E9A4A5A0;
	Thu, 19 Aug 2021 14:43:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RO18Y32Rltfq; Thu, 19 Aug 2021 14:43:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0F3F4B0BD;
	Thu, 19 Aug 2021 14:43:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 533394ACC9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 14:43:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z6VS-0tAVymP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 14:43:50 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 466224A5A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 14:43:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1629398630;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=H/wl8m/9lH1CHxbJFAhOGRrmreud5t/3OP9MGx3avmE=;
 b=JTIhHJIB6ybC8A2SMKvNyxorFaMaY2Dr9j0/cGbjWafDOP2r+oxhAmJrpMblbfGg63jyV8
 QohTNIxudTWdeW0XYs4COQlrh1Wiy6w8rGvX8rR1OQV3F0AyLRvTn00ilT2GDmXj0ZFHr2
 i81DZYwsybSm/OzBtueB3JADLXEkFjA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-aKQUDwrROzmaDp7OcHlfzA-1; Thu, 19 Aug 2021 14:43:46 -0400
X-MC-Unique: aKQUDwrROzmaDp7OcHlfzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58EA1107ACF5;
 Thu, 19 Aug 2021 18:43:44 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-6.gru2.redhat.com [10.97.112.6])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C1C3F188E4;
 Thu, 19 Aug 2021 18:43:43 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
 id 054DB434F000; Thu, 19 Aug 2021 15:24:22 -0300 (-03)
Date: Thu, 19 Aug 2021 15:24:22 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v7 1/6] KVM: x86: Fix potential race in KVM_GET_CLOCK
Message-ID: <20210819182422.GA25923@fuller.cnet>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-2-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210816001130.3059564-2-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Mon, Aug 16, 2021 at 12:11:25AM +0000, Oliver Upton wrote:
> Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
> outside of the pvclock sync lock. This is problematic, as the clock
> value written to the user may or may not actually correspond to a stable
> TSC.
> 
> Fix the race by populating the entire kvm_clock_data structure behind
> the pvclock_gtod_sync_lock.

Oliver, 

Can you please describe the race in more detail?

Is it about host TSC going unstable VS parallel KVM_GET_CLOCK ? 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
