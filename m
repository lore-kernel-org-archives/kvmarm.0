Return-Path: <SRS0=Tw+U=OS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B74B4C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:53:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 076DB61246
	for <kvmarm@archiver.kernel.org>; Tue, 28 Sep 2021 18:53:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 076DB61246
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D9074B0F5;
	Tue, 28 Sep 2021 14:53:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id htkPXVR6RuTs; Tue, 28 Sep 2021 14:53:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 716324B0CC;
	Tue, 28 Sep 2021 14:53:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E331E4B0BD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:53:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kfjiGxq3Ko62 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Sep 2021 14:53:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE3D64B0BA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Sep 2021 14:53:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632855233;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=BW3DcANbaIeRGt53kKhrZ73VLTbnr1HV+49+aFBS5+U=;
 b=fpiEB53BOvayNS0V0wQziuGjydZSO7lJzH0SeNkpPqal/E0U5Z48gU+voqT+d22DdNUqqQ
 ls9Chx9OC72hz8eF7e3DJPknzHK/cT52BLQQa/JhLxA0L/kat+Ulp4RYu0CZc98jWPb7If
 Pd3r5ToMFUJQBRzW6gpcvDMx8QpZjKw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-igZCvVubPYCdQeZRJCG22g-1; Tue, 28 Sep 2021 14:53:52 -0400
X-MC-Unique: igZCvVubPYCdQeZRJCG22g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDA36100C660;
 Tue, 28 Sep 2021 18:53:49 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A54C19D9D;
 Tue, 28 Sep 2021 18:53:48 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
 id 82048416CE49; Tue, 28 Sep 2021 15:53:43 -0300 (-03)
Date: Tue, 28 Sep 2021 15:53:43 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in
 KVM_GET_CLOCK
Message-ID: <20210928185343.GA97247@fuller.cnet>
References: <20210916181538.968978-1-oupton@google.com>
 <20210916181538.968978-5-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210916181538.968978-5-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, David Matlack <dmatlack@google.com>,
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

On Thu, Sep 16, 2021 at 06:15:35PM +0000, Oliver Upton wrote:
> Handling the migration of TSCs correctly is difficult, in part because
> Linux does not provide userspace with the ability to retrieve a (TSC,
> realtime) clock pair for a single instant in time. In lieu of a more
> convenient facility, KVM can report similar information in the kvm_clock
> structure.
> 
> Provide userspace with a host TSC & realtime pair iff the realtime clock
> is based on the TSC. If userspace provides KVM_SET_CLOCK with a valid
> realtime value, advance the KVM clock by the amount of elapsed time. Do
> not step the KVM clock backwards, though, as it is a monotonic
> oscillator.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  Documentation/virt/kvm/api.rst  | 42 ++++++++++++++++++++++++++-------
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/x86.c              | 36 +++++++++++++++++++++-------
>  include/uapi/linux/kvm.h        |  7 +++++-
>  4 files changed, 70 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a6729c8cf063..d0b9c986cf6c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -993,20 +993,34 @@ such as migration.
>  When KVM_CAP_ADJUST_CLOCK is passed to KVM_CHECK_EXTENSION, it returns the
>  set of bits that KVM can return in struct kvm_clock_data's flag member.
>  
> -The only flag defined now is KVM_CLOCK_TSC_STABLE.  If set, the returned
> -value is the exact kvmclock value seen by all VCPUs at the instant
> -when KVM_GET_CLOCK was called.  If clear, the returned value is simply
> -CLOCK_MONOTONIC plus a constant offset; the offset can be modified
> -with KVM_SET_CLOCK.  KVM will try to make all VCPUs follow this clock,
> -but the exact value read by each VCPU could differ, because the host
> -TSC is not stable.
> +FLAGS:
> +
> +KVM_CLOCK_TSC_STABLE.  If set, the returned value is the exact kvmclock
> +value seen by all VCPUs at the instant when KVM_GET_CLOCK was called.
> +If clear, the returned value is simply CLOCK_MONOTONIC plus a constant
> +offset; the offset can be modified with KVM_SET_CLOCK.  KVM will try
> +to make all VCPUs follow this clock, but the exact value read by each
> +VCPU could differ, because the host TSC is not stable.
> +
> +KVM_CLOCK_REALTIME.  If set, the `realtime` field in the kvm_clock_data
> +structure is populated with the value of the host's real time
> +clocksource at the instant when KVM_GET_CLOCK was called. If clear,
> +the `realtime` field does not contain a value.
> +
> +KVM_CLOCK_HOST_TSC.  If set, the `host_tsc` field in the kvm_clock_data
> +structure is populated with the value of the host's timestamp counter (TSC)
> +at the instant when KVM_GET_CLOCK was called. If clear, the `host_tsc` field
> +does not contain a value.

If the host TSCs are not stable, then KVM_CLOCK_HOST_TSC bit (and
host_tsc field) are ambiguous. Shouldnt exposing them be conditional on 
stable TSC for the host ?

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
