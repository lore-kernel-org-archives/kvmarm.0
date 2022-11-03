Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C81C43219
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 15:30:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAFCD4B5F4;
	Thu,  3 Nov 2022 11:30:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fqqrl+Z42J4y; Thu,  3 Nov 2022 11:30:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C18E34B62D;
	Thu,  3 Nov 2022 11:30:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C7B84B269
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:30:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RZUd7YNdRVi6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 11:30:03 -0400 (EDT)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38AE84B210
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:30:03 -0400 (EDT)
Received: by mail-pf1-f179.google.com with SMTP id b29so1907548pfp.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 08:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=UyUe+HbRzSrTdJquQCMiaXWC2coZG28I37xguDaJaYg=;
 b=JxP3em5mMEo8M/seyYjwqQClKWueZhrkefM7iopEbtJ9U0ARhXsBBlBaHvB0YZ+mCq
 7I2lDIbzgsTnUJXXFFd+Mf2MRkvMQ3d/mi120+0k+co+feliF2fGnlDGLipP3oo4jHIs
 yhCQnzB0LNdLsoCiyP2ThdGCDug/wevVBzx4ZCIoRVJzM62ULFanZrMyKnrfoLhgGw7L
 LE3NJVvLI80qGdb5QUdNBUYtcEfD6sTxNonp/rLGuh5no7R8ACiBwreWQkoFJnyoE1Nq
 joZ/uzznkWHqO7mwwbSR52gm1kYa+vf+hliw2Y9f1o05+cN6N5swUWJ7vJszMr5BEKoW
 HTcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=UyUe+HbRzSrTdJquQCMiaXWC2coZG28I37xguDaJaYg=;
 b=WDrfsjs9muI1VY9sqiEag9Nj4uRF3UZy83DXSocnfA6E6H0dnEsljabidOI7FqkgZr
 bVhSYVB/7husId6rKtNnKS2vG+NmkYF66F7B0JHFCpM3UNpgbdasOFg170R7iFADLmu0
 gsbbVeHYxctrBIYq2u4ZcH7ZA2LqH1/YnAbQZQKhPxkt8BaLXCSwAbRS9eT+m5oMgV4/
 O1620m4YL5gXrl+um3oT8szb134bK2+gJM8F9tVBf08iO9cenZNvEE5gWjyC1Z4zSw4A
 sOSZFWDA0eowNGO+WlfvfSwtfe67KuoEbJTofhUBEIr7RdWlnkGRTu45lc4u0juFyirF
 el+A==
X-Gm-Message-State: ACrzQf3eprpGtKAxG4IF9PqDbnsZhGJWW7+A04JSV3oGErqIIHiqB0lQ
 7zOqF1pOGB8SEVzTupAI8j4HbQ==
X-Google-Smtp-Source: AMsMyM6by5WQXi0G4lBZGaavWsGrxKC8DeWyAUbAtvZsM8BboB9ucyemIyMYLKoI4FadI1MlyxYOPw==
X-Received: by 2002:a05:6a00:1996:b0:56d:a845:5789 with SMTP id
 d22-20020a056a00199600b0056da8455789mr17697890pfl.59.1667489402026; 
 Thu, 03 Nov 2022 08:30:02 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 f3-20020a170902f38300b0017a018221e2sm835452ple.70.2022.11.03.08.30.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 08:30:01 -0700 (PDT)
Date: Thu, 3 Nov 2022 15:29:58 +0000
From: Sean Christopherson <seanjc@google.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Subject: Re: [PATCH 17/44] KVM: arm64: Do arm/arch initialiation without
 bouncing through kvm_init()
Message-ID: <Y2Pedr1MYt/P1uL0@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-18-seanjc@google.com>
 <dd59d579-4a4e-6db2-eac4-6c5c3ab71fd3@linaro.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <dd59d579-4a4e-6db2-eac4-6c5c3ab71fd3@linaro.org>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Yuan Yao <yuan.yao@intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Chao Gao <chao.gao@intel.com>, Eric Farman <farman@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm@vger.kernel.org,
 Atish Patra <atishp@atishpatra.org>, kvmarm@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 Fabiano Rosas <farosas@linux.ibm.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 linuxppc-dev@lists.ozlabs.org
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

On Thu, Nov 03, 2022, Philippe Mathieu-Daud=E9 wrote:
> Hi Sean,
> =

> On 3/11/22 00:18, Sean Christopherson wrote:
> > Move arm/arch specific initialization directly in arm's module_init(),
> > now called kvm_arm_init(), instead of bouncing through kvm_init() to
> > reach kvm_arch_init().  Invoking kvm_arch_init() is the very first acti=
on
> > performed by kvm_init(), i.e. this is a glorified nop.
> > =

> > Making kvm_arch_init() a nop will allow dropping it entirely once all
> > other architectures follow suit.
> > =

> > No functional change intended.
> > =

> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/arm64/kvm/arm.c | 25 ++++++++++++++++---------
> >   1 file changed, 16 insertions(+), 9 deletions(-)
> =

> >   /* NOP: Compiling as a module not supported */
> >   void kvm_arch_exit(void)
> >   {
> > -	kvm_unregister_perf_callbacks();
> =

> Doesn't this belong to the previous patch?

No, but the above changelog is a lie, there is very much a functional chang=
e here.

The goal of the previous patch is to fix the error paths in kvm_arch_init()=
, a.k.a.
kvm_arm_init().  After fixing kvm_arch_init(), there are still bugs in the =
sequence
as a whole because kvm_arch_exit() doesn't unwind other state, e.g. kvm_arc=
h_exit()
should really look something like:

  void kvm_arch_exit(void)
  {
	teardown_subsystems();

	if (!is_kernel_in_hyp_mode())
		teardown_hyp_mode();

	kvm_arm_vmid_alloc_free();

	if (is_protected_kvm_enabled())
		???	=

  }

Becuase although the comment "NOP: Compiling as a module not supported" is =
correct
about KVM ARM always having to be built into the kernel, kvm_arch_exit() ca=
n still
be called if a later stage of kvm_init() fails.

But rather than add a patch to fix kvm_arch_exit(), I chose to fix the bug =
by
moving code out of kvm_arch_init() so that the unwind sequence established =
in the
previous patch could be reused.

Except I managed to forget those details when writing the changelog.  The c=
hangelog
should instead be:

  KVM: arm64: Do arm/arch initialization without bouncing through kvm_init()
  =

  Do arm/arch specific initialization directly in arm's module_init(), now
  called kvm_arm_init(), instead of bouncing through kvm_init() to reach
  kvm_arch_init().  Invoking kvm_arch_init() is the very first action
  performed by kvm_init(), so from a initialization perspective this is a
  glorified nop.
  =

  Avoiding kvm_arch_init() also fixes a mostly benign bug as kvm_arch_exit()
  doesn't properly unwind if a later stage of kvm_init() fails.  While the
  soon-to-be-deleted comment about compiling as a module being unsupported
  is correct, kvm_arch_exit() can still be called by kvm_init() if any step
  after the call to kvm_arch_init() succeeds.

  Add a FIXME to call out that pKVM initialization isn't unwound if
  kvm_init() fails, which is a pre-existing problem inherited from
  kvm_arch_exit().

  Making kvm_arch_init() a nop will also allow dropping kvm_arch_init() and
  kvm_arch_exit() entirely once all other architectures follow suit.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
