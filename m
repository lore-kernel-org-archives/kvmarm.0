Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2609C18B18
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 17:19:49 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d10792c7582so3585266276.3
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 10:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690823989; x=1691428789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gdb7QzlYcOc7UWmxcegrKrVqMfFsYHZFCwi2LL3my64=;
        b=zBusOqyPc9Ltaaqmju2VylABq68z3gA0yH658LtIHqnM7muXRoiPK7Z+lJWtWm/VN7
         8whOaU6x9OiXazWcYr8fAVYmvIyO6TYz06QaVHcaE8EQS9KLvJWFds1kXHPR5gfyol/T
         hwExr3eIMCbASZqYoMXC5wv7UZF1Mp2U4BBszuz1saEchMHIrtLN7I0wmDOtomAyfGK4
         Jb/4sUIrkAMy5yEhhybvRPtzSFoc+rBWIZvDZCJzlFd/cD+b3RLT1Lug7yCp0xC4QWhy
         NI1FLe1nSeay7t1G8coFkWiO2qxxWysi0sKSxyJbI8pSaEUs+h67fGOJLF0xb0FIQUeT
         6ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690823989; x=1691428789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gdb7QzlYcOc7UWmxcegrKrVqMfFsYHZFCwi2LL3my64=;
        b=gbVPwQKqBoXAiHiOsN0QTsYTdUnYS6TA8x71bFR12BdfamohovcDhWHmNf0ULs7u/q
         jMPaI1xF6rE1rCTXm9CwRdL6dH/mFC39SHeQupVyBz/yaP6Ny27ary/KXZIcfge1gms4
         cV4FDyyfbhDGGo0zpBzs0cTGzbrlxAI6kEQJID6WaePY1gNZhDhBP5TfooSQksnZWAHL
         E5E8hl2V5UZZxcRhNjSWI7wIZBlwvF52hT6H9n/RoKmlPPAGSbZk0fcpjLKlFSQDzJi9
         CRnvowGtcCMtXQu4rKg4Xegg3qPJIeF8v4hldgfNLO+oZxFACprKfJWk+nZ9I7IxTCle
         BxMw==
X-Gm-Message-State: ABy/qLZoDGZYEPkoi4+n2qEUNFEAFEoktQCC0hAzETd8cesRT7yjru5r
	rTtlFzrd/Sa39xLHzkcBP2ofa4oXD2Q=
X-Google-Smtp-Source: APBJJlGDPfFjSpxr1qlDSkpPLfZlx10bTCXz+EMu9wyIQgv1N0AgtgkGqemxSj6OVMzULEQvuuVcsCXfoZ4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:abe3:0:b0:d22:4059:b2bd with SMTP id
 v90-20020a25abe3000000b00d224059b2bdmr62850ybi.1.1690823989036; Mon, 31 Jul
 2023 10:19:49 -0700 (PDT)
Date: Mon, 31 Jul 2023 10:19:47 -0700
In-Reply-To: <ZMfpgu8bHH0jA8Si@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230729003643.1053367-1-seanjc@google.com> <20230729003643.1053367-10-seanjc@google.com>
 <20230731-91b64a6b787ba7e23b285785@orel> <ZMfpgu8bHH0jA8Si@google.com>
Message-ID: <ZMftM3qz/VqalbPg@google.com>
Subject: Re: [PATCH v4 09/34] KVM: selftests: Add a selftest for guest prints
 and formatted asserts
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Thomas Huth <thuth@redhat.com>, 
	"Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=" <philmd@linaro.org>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 31, 2023, Sean Christopherson wrote:
> On Mon, Jul 31, 2023, Andrew Jones wrote:
> > diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> > index 4cf69fa8bfba..4adf526dc378 100644
> > --- a/tools/testing/selftests/kvm/include/ucall_common.h
> > +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> > @@ -6,8 +6,19 @@
> >   */
> >  #ifndef SELFTEST_KVM_UCALL_COMMON_H
> >  #define SELFTEST_KVM_UCALL_COMMON_H
> > +#include <linux/kvm.h>
> >  #include "test_util.h"
> >  
> > +#if defined(__aarch64__)
> > +#define UCALL_EXIT_REASON      KVM_EXIT_MMIO
> > +#elif defined(__x86_64__)
> > +#define UCALL_EXIT_REASON      KVM_EXIT_IO
> > +#elif defined(__s390x__)
> > +#define UCALL_EXIT_REASON      KVM_EXIT_S390_SIEIC
> > +#elif defined(__riscv)
> > +#define UCALL_EXIT_REASON      KVM_EXIT_RISCV_SBI
> > +#endif
> > +
> >  /* Common ucalls */
> >  enum {
> >         UCALL_NONE,
> > 
> > and then compiled the test for riscv and it passed. I also ran all other
> > riscv tests successfully.
> 
> Can I have your SoB for the ucall_common.h patch?  I'll write a changelog and fold
> in a separate prep patch for that change.

On second thought, I take that back.  I think it makes more sense to add a ucall.h
for each arch and #define the exit type there.  All then move all of the
ucall_arch_do_ucall() implementations to ucall.h (except maybe x86 while it has
the horrific save/restore GPRs hack...).  That way the #define is colocated with
the code that generates the exit reason.
