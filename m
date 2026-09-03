Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD47484221
	for <kvmarm@lists.linux.dev>; Thu,  3 Sep 2026 14:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788445850; cv=none; b=hJFuFVnDSpnRy46b7k7yVNkgddwcxpHKVar499gZ8HE7dMa+foW6sj1C1FioRAMRhvxPo03eMR7lAw693a87Z9udN6hEcHYsw53+rCi5+FbD8JCMe+Rl9pRbINHCBzW2ujDPAV5WFJQw3BwuKdprZw0NFpdlCq4kkozUp+WVkHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788445850; c=relaxed/simple;
	bh=nqFrkxbwZnIGD0jt6PBMdWC/YYiKHoC8Dbvm0EmPTSA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mzMtKCUlRqCkkCi1O9A6bbp3Xr0HdCSIJWf0UdhxOspaQZ/oF7LpjY8rphUg3s8yMyVnBCL0Y02y5PAKwsq9MjvYSCxAamm781u/9yRqLCQSN+P9pwAKF4F7cTXpDuRqqVzeXGdEOi8W4baf+N/5H4fWNfEDIx9dDuR3p+x8KFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DzRrMZEa; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DzRrMZEa"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8535db07af9so1262696b3a.2
        for <kvmarm@lists.linux.dev>; Thu, 03 Sep 2026 07:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788445838; x=1789050638; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KU72ElW/WJuvWFFEt8qn0cRYWtv7/uUdQgw0J+lE/vo=;
        b=DzRrMZEa64l++842GrDQc7tF4HdsBML11nLC8DF/srponDFt/z87dP0B1Xznt3Mt/+
         c4B40r8P475svij4VUyCFy6dJ3XOb6uYwyPm5jKQCduSU4FGare8tTfm6NNdG0kA60Cu
         MQGGoHmXHnGglNHsdhbUjgDr2eiQpvbNc9hXPyHOQT4SbYUNEfmCAjXnAWguf5GkBe/L
         rfU9vgHClIzKRqOA0IsH29OaJ9cFEy6uglyfuy49MCzbeabRSGzFPvoXiv52wNYq12J1
         /B48D8cyxA5V6dHsvSUxYhtSUVT6PnxWyBqIjna7c7O+NfB9slsHRS4lclINPgO7GnlE
         NSnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788445838; x=1789050638;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KU72ElW/WJuvWFFEt8qn0cRYWtv7/uUdQgw0J+lE/vo=;
        b=NVhd0Fbkvbq3TvHiBV5de5N9akLJO/Ev7TMs+G5jCT6MGipLZCc5pD2+K7lIW0kZJm
         etgb1I0L1XDeS7+xkg9vHfRwkDonfeCH6AznsP2yxpMKCF7EKgZDTKus/MngWm9fddZg
         qBT6cAGTPesJr3RnEO8L8rFGaKI7XZ5vdhLrNlUZGS8nMFfIYlirLlqvBb6F04eVOPLO
         ZwfCFkGqgZKGp8Di5vzgDNIzXd4sh6WmaTzYCMC9DHNoyxqA/hYwhDf/H/dDr2sDev7b
         YIPNcxzTRGB6hr9lA/dLqovctTOJFa3GhW9OTLlzbVaYLgKq7af12SLF05bTqLwcEkir
         ZNRg==
X-Forwarded-Encrypted: i=1; AKwUvByNH3DRShwHxsIe1LvzHSgzerALcixosdZxqEVW962FDR1Iojw930FQMWSNapdEUbT0amuRL64=@lists.linux.dev
X-Gm-Message-State: AFuF++nx9j9898Z/F9GPx5jfEq+6ObPXkUm9hsHSMxbkau9QNa/iP7hf
	kKB2zbR7Q+BtADoLJg1U00HDNLLRGWrOkAiWMAuhuZ8HHXO9sOrDzz8VrgjGVY+3v1Ct5GPzAUP
	qg08Lxg==
X-Received: from pfll28.prod.google.com ([2002:a05:6a00:159c:b0:84d:f9cf:1f3d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4106:b0:847:8449:2ba6
 with SMTP id d2e1a72fcca58-85ed23def83mr20907159b3a.8.1788445836362; Thu, 03
 Sep 2026 07:30:36 -0700 (PDT)
Date: Thu, 3 Sep 2026 07:30:35 -0700
In-Reply-To: <20260903114241.33034-C-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260831144802.834315-1-seiden@linux.ibm.com> <20260831144802.834315-3-seiden@linux.ibm.com>
 <apdweRfqt4dTxcU9@google.com> <20260902075028.231001-D-seiden@linux.ibm.com>
 <aphLXQL1H2zYZgTi@google.com> <20260903114241.33034-C-seiden@linux.ibm.com>
Message-ID: <apmEi1NmOUvmUBFP@google.com>
Subject: Re: [PATCH v7 02/23] KVM: Make device name configurable
From: Sean Christopherson <seanjc@google.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Andreas Grapentin <gra@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Friedrich Welter <fritz@linux.ibm.com>, Fuad Tabba <tabba@google.com>, 
	Gautam Gala <ggala@linux.ibm.com>, Hariharan Mari <hari55@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Hendrik Brueckner <brueckner@linux.ibm.com>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Nico Boehr <nrb@linux.ibm.com>, 
	Nina Schoetterl-Glausch <oss@nina.schoetterlglausch.eu>, Oliver Upton <oupton@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Sep 03, 2026, Steffen Eiden wrote:
> On Wed, Sep 02, 2026 at 09:14:21AM -0700, Sean Christopherson wrote:
> > And taking things a few steps further, we can solve the MMIO issue in a more
> > elegant way, and eliminate the runtime string building in this patch (after looking
> > more closely, that code needs to be jettisoned no matter what, there's simply no
> > reason to specify the names at runtime since they're separate compilation units).
> > 
> > Rather than splatter #defines throughout header files, deal with the bulk of the
> > pain in Makefile.kvm.  By feeding conditionals into Makefile.kvm, the s390+arm64
> > build can easily omit coalesced_mmio.o and async_pf.o, define __KVM_HAVE_ARCH_MMIO
> > programatically without having to change other architectures, and solve the naming
> > stuff.
> 
> Yes, this is a great idea. Thank you. I second you, this looks more clean
> and stable than the stuff we came up with :) 

Looking more at arch/s390/kvm/Kconfig and virt/kvm/Kconfig, we might need/want to
to build out infrastructure to handle this sort of thing in a more generic fashion?

Which probably isn't that much infrastructure?  It's more just changing how arch
code communicates with common KVM?  I.e. instead of providing boolean configs in
virt/kvm/Kconfig, formalize communicating HAVE-type macros through the Makefile.
That might even be a net positive in the long run, as it will make it easier to
provide defaults for the common cases.

I say that because unless there's magic I'm unaware of these Kconfigs also needs
to be configured per-KVM, not per-kernel:

  - KVM_MMU_LOCKLESS_AGING, otherwise aging on arm64 will unintentionally be done
    outside of mmu_lock.

  - KVM_GENERIC_PRE_FAULT_MEMORY, so that arm64 doesn't need to provide a stub
    for something it doesn't support

  - HAVE_KVM_MSI, because presumably it's needed for arm64 support.

  - HAVE_KVM_READONLY_MEM, same story as HAVE_KVM_MSI.

Which isn't _that_ many knobs, but add in KVM_MMIO, KVM_ASYNC_PF, and
KVM_ASYNC_PF_SYNC, and it's enough that I think we should think about the big
picture and not play whack-a-mole.

Actually, thinking about this more, what I've proposed here, plus the pattern of
#define-ing macros in arch-specific kvm_host.h files, should suffice.  For things
like __KVM_HAVE_ARCH_VM_FREE, it absolutely makes sense to #define the macro in
kvm_host.h since it's very directly tied to an arch callback.  Whereas with KVM_MIO
and KVM_ASYNC_PF, because they enable compilation of C files, it makes sense to
define them in Makefiles.

So I think the "gap" is purely that the four knobs listed above need handling
(and arguably KVM_MMU_LOCKLESS_AGING is ok as-proposed).  But I do think we should
try our best to be more thoughtful than we usually are when deciding how to enable
common code, because obviously s390+arm64 is adding wrinkles no one has had to deal
with before.
