Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702221D319
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 18:22:57 +0000 (UTC)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-4fe426521adso217852e87.0
        for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 11:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690827775; x=1691432575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6BmQQ8xDHQ3qzVuwILJuAltF2TxUquAINpFxWwuR3w=;
        b=RTUp1GcE9TWV1qTvNE1C02wFkvp/rEJhtk+51nISvyjgPTusv53crdnWdpbT2WDNpC
         9czQGReCauWeNFu8mJtHkId8ASDjhvZWALHZh+SyhEMqoUTqhxssydzxa6uZBKj0qYrD
         vcyzEEjHdxO76TNZyKc9O24YAUeb5rdAfQi7xglRc7Oz8U/VK20seE+TqLxPiIUEF2AF
         p2ypuV+xtoforGGsa/Lt/KyL8w4KTS3XdMdpYfXyMrVCX/d56Us0p1xCWIGjqH506lyL
         NZbaDWWhUfPFLWX9TmHQaEyEA1UmGoVZusjLFfEFIf7D4qJ0RegD+CSe3GcPeA3rkzoJ
         xi6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690827775; x=1691432575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q6BmQQ8xDHQ3qzVuwILJuAltF2TxUquAINpFxWwuR3w=;
        b=dQw1O37BoYfMDr9qGJQnLfxPt2BlP71ADgq2Qlgl4p9k9bB1sjt8FeBW9QIBYd3SKP
         SeQjfnF3CyUyzKXQRNqnoMfTt0CzqSmmeuHy7HaPOIcQMxM2UyYMkQsrysgpVJmMIkhx
         H8hKbso0S6c59pvmjUOLMuNy1CjItHUln+6vFYYTD1R8MWL5ODicA7bFDFrmjnU6mCPy
         mjF5yCTSoz5TCgvfP2oOuYyEjmfKUdySMwhNdwf0UzoPlETFQZtD9E8iD89XpWqeuI0X
         Itf77H6TiSEsHU4HezEw7FgPbGSbSf+oeSiq13R+g80jxZ5cYWn0TjWnysQEtP5qYM8O
         W70A==
X-Gm-Message-State: ABy/qLb0aN5xq2RjZ4VqdAR2yCLfqrUNVAHURAyHqQmOSK/WW6Jc+igo
	LoTUyzHh4t8NYU5eudVpPalnAQ==
X-Google-Smtp-Source: APBJJlE51QtfiG+1ENPBZcz/MTN10/l7Xyhmr/3dD4Lp00ivZz+NffJEl0iYsoUxrdAsUIsDuqY10A==
X-Received: by 2002:ac2:5e34:0:b0:4fe:3e89:fcb1 with SMTP id o20-20020ac25e34000000b004fe3e89fcb1mr383296lfg.68.1690827775288;
        Mon, 31 Jul 2023 11:22:55 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id u7-20020a170906408700b0098de7d28c34sm6476150ejj.193.2023.07.31.11.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jul 2023 11:22:54 -0700 (PDT)
Date: Mon, 31 Jul 2023 20:22:54 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Thomas Huth <thuth@redhat.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, 
	Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v4 09/34] KVM: selftests: Add a selftest for guest prints
 and formatted asserts
Message-ID: <20230731-4335e61b2b2688a925025a9c@orel>
References: <20230729003643.1053367-1-seanjc@google.com>
 <20230729003643.1053367-10-seanjc@google.com>
 <20230731-91b64a6b787ba7e23b285785@orel>
 <ZMfpgu8bHH0jA8Si@google.com>
 <ZMftM3qz/VqalbPg@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZMftM3qz/VqalbPg@google.com>

On Mon, Jul 31, 2023 at 10:19:47AM -0700, Sean Christopherson wrote:
> On Mon, Jul 31, 2023, Sean Christopherson wrote:
> > On Mon, Jul 31, 2023, Andrew Jones wrote:
> > > diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> > > index 4cf69fa8bfba..4adf526dc378 100644
> > > --- a/tools/testing/selftests/kvm/include/ucall_common.h
> > > +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> > > @@ -6,8 +6,19 @@
> > >   */
> > >  #ifndef SELFTEST_KVM_UCALL_COMMON_H
> > >  #define SELFTEST_KVM_UCALL_COMMON_H
> > > +#include <linux/kvm.h>
> > >  #include "test_util.h"
> > >  
> > > +#if defined(__aarch64__)
> > > +#define UCALL_EXIT_REASON      KVM_EXIT_MMIO
> > > +#elif defined(__x86_64__)
> > > +#define UCALL_EXIT_REASON      KVM_EXIT_IO
> > > +#elif defined(__s390x__)
> > > +#define UCALL_EXIT_REASON      KVM_EXIT_S390_SIEIC
> > > +#elif defined(__riscv)
> > > +#define UCALL_EXIT_REASON      KVM_EXIT_RISCV_SBI
> > > +#endif
> > > +
> > >  /* Common ucalls */
> > >  enum {
> > >         UCALL_NONE,
> > > 
> > > and then compiled the test for riscv and it passed. I also ran all other
> > > riscv tests successfully.
> > 
> > Can I have your SoB for the ucall_common.h patch?  I'll write a changelog and fold
> > in a separate prep patch for that change.
> 
> On second thought, I take that back.  I think it makes more sense to add a ucall.h
> for each arch and #define the exit type there.  All then move all of the
> ucall_arch_do_ucall() implementations to ucall.h (except maybe x86 while it has
> the horrific save/restore GPRs hack...).  That way the #define is colocated with
> the code that generates the exit reason.

Yup, feel free to just take the above as inspiration and create a
different patch. If you decide you want an s-o-b for the above, though,
then here's one

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
