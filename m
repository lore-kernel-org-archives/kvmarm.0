Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4125AC4321E
	for <kvmarm@archiver.kernel.org>; Thu,  1 Dec 2022 22:49:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A74144A0DA;
	Thu,  1 Dec 2022 17:49:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IWyQmO7jA+wO; Thu,  1 Dec 2022 17:49:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFAA94B1AD;
	Thu,  1 Dec 2022 17:49:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF5154A0D8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 17:49:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qHlEd2OpKNOc for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 17:49:12 -0500 (EST)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
 [209.85.216.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 908C349E4B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 17:49:12 -0500 (EST)
Received: by mail-pj1-f41.google.com with SMTP id
 e7-20020a17090a77c700b00216928a3917so6595824pjs.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 14:49:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=mKF7ACqUicTgwRFQrz4oBsMFvmn+mRrenbI3VwK9VtA=;
 b=Lo1VVBU0quIBqwSjUL/IX6jsQ3Rcbq3kNXFx1b09LmjnR9bQqqs8Qnjl452IWYkBSY
 P1KTyvwrHEdLgoshrms0r4SI8z1ngo83OqCHRxrURyBE+yArcM+Cs5TCeq44GobVkF0m
 IuDj+iWRP2zVVwjI1HJslgwJO64iafu01Owc+4A3/mvkEjyzFr8iFAR19fNs0LBLJTf3
 Kg1ZIMc5fZ0ipGhmHdhLOXnD8uVTRyQX02DQttBjsyjAKjRvEJFav2gCuZ5FSQ6cpVhK
 zD3GLCkmoDFgDHZV7t7XBqH0jElTPRdTcydGeJqtHoccQFH5HqfiAwKx6tg04wXmDFCc
 QADQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=mKF7ACqUicTgwRFQrz4oBsMFvmn+mRrenbI3VwK9VtA=;
 b=yxRYhqHjA5pD2ouL6Ri6FQIFF22t3y5iR5Q6j3JawBghH5CBjkdpeeLsuW6sncb629
 2cdW96ZDVUSpl6ditvWaFoa+3fa4yg43uxmE0/o14ydmhpg3Y2pj5ngxm9xifltQG6H2
 lDp9195jEcILeOreSJPRh6ayNDS20LO6quOQIeNOsZYrtqHibcH5NdIxAkqwn1H4/Sgm
 a+wQyn1g/ITNdx1KJVrwluQdZ+14u/grn72Z2bopbUooRzTP0luGy7BHgVp6sgUX81Sp
 GURwSoSj13MLBTK90nJ4cO/0Pqw1HX9s3PdCKX7ldk2SyNAk41oFDRbGvR/aOX05eimf
 FJqA==
X-Gm-Message-State: ANoB5pmxrs3esM6spgRD3H2osIhs5shMpCf79qigQAcKa+HUBH7b+KcW
 EtlYqPHSge25lkujbcWsJF1ujg==
X-Google-Smtp-Source: AA0mqf4Wt8uYV/bEa16p+0WrrISPwxZH3fHAX4g+Oh8a2UKzOEMh4LEyPBB3ZTgiAtA3/myS/mdVQA==
X-Received: by 2002:a17:903:32ce:b0:189:a0eb:4a26 with SMTP id
 i14-20020a17090332ce00b00189a0eb4a26mr13829305plr.162.1669934951343; 
 Thu, 01 Dec 2022 14:49:11 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 c73-20020a624e4c000000b0056bc742d21esm3854175pfb.176.2022.12.01.14.49.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Dec 2022 14:49:10 -0800 (PST)
Date: Thu, 1 Dec 2022 22:49:06 +0000
From: Sean Christopherson <seanjc@google.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Subject: Re: [PATCH v2 21/50] KVM: MIPS: Hardcode callbacks to hardware
 virtualization extensions
Message-ID: <Y4kvYlCbhj87rceF@google.com>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-22-seanjc@google.com>
 <beb697c2-dfad-780e-4638-76b229f28731@linaro.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <beb697c2-dfad-780e-4638-76b229f28731@linaro.org>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Paul Durrant <paul@xen.org>,
 Yuan Yao <yuan.yao@intel.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Kai Huang <kai.huang@intel.com>, Michael Ellerman <mpe@ellerman.id.au>,
 linux-riscv@lists.infradead.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Thu, Dec 01, 2022, Philippe Mathieu-Daud=E9 wrote:
> On 1/12/22 00:09, Sean Christopherson wrote:
> > Now that KVM no longer supports trap-and-emulate (see commit 45c7e8af4a=
5e
> > "MIPS: Remove KVM_TE support"), hardcode the MIPS callbacks to the
> > virtualization callbacks.
> > =

> > Harcoding the callbacks eliminates the technically-unnecessary check on
> > non-NULL kvm_mips_callbacks in kvm_arch_init().  MIPS has never support=
ed
> > multiple in-tree modules, i.e. barring an out-of-tree module, where
> > copying and renaming kvm.ko counts as "out-of-tree", KVM could never
> > encounter a non-NULL set of callbacks during module init.
> > =

> > The callback check is also subtly broken, as it is not thread safe,
> > i.e. if there were multiple modules, loading both concurrently would
> > create a race between checking and setting kvm_mips_callbacks.
> > =

> > Given that out-of-tree shenanigans are not the kernel's responsibility,
> > hardcode the callbacks to simplify the code.
> > =

> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/mips/include/asm/kvm_host.h |  2 +-
> >   arch/mips/kvm/Makefile           |  2 +-
> >   arch/mips/kvm/callback.c         | 14 --------------
> >   arch/mips/kvm/mips.c             |  9 ++-------
> >   arch/mips/kvm/vz.c               |  7 ++++---
> >   5 files changed, 8 insertions(+), 26 deletions(-)
> >   delete mode 100644 arch/mips/kvm/callback.c
> > =

> > diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/k=
vm_host.h
> > index 28f0ba97db71..2803c9c21ef9 100644
> > --- a/arch/mips/include/asm/kvm_host.h
> > +++ b/arch/mips/include/asm/kvm_host.h
> > @@ -758,7 +758,7 @@ struct kvm_mips_callbacks {
> >   	void (*vcpu_reenter)(struct kvm_vcpu *vcpu);
> >   };
> >   extern struct kvm_mips_callbacks *kvm_mips_callbacks;
> =

> IIUC we could even constify this pointer.

Good point.  Protecting the pointer itself is a bit gross, but it is a nice
stopgap until the callbacks are gone.  I'll fold this in.  Thanks!

  extern const struct kvm_mips_callbacks * const kvm_mips_callbacks;
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
