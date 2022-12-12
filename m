Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1BF7C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 18:17:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ECBD4B97F;
	Mon, 12 Dec 2022 13:17:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oajV0pFRTBnj; Mon, 12 Dec 2022 13:17:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9339E4B947;
	Mon, 12 Dec 2022 13:17:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 841204B943
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 13:17:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JcKeldxpncat for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 13:17:48 -0500 (EST)
Received: from out-142.mta0.migadu.com (out-142.mta0.migadu.com
 [91.218.175.142])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E6424B93F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 13:17:48 -0500 (EST)
Date: Mon, 12 Dec 2022 18:17:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1670869065;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=a9Id/GViUZAo9zRK46q4+Dpl7Meohnepciy9W7jEdXE=;
 b=fE9WRJWJ8x2O7m5Gd09O9tkOQ7F6YcPGusN7I2RL/OS2Rivtpch9NFEYCzf1v/E4NtmVv2
 FLeZtByUzGij7gtzYD2aTQDXJlv0CdgVRUMS8Aas8M3DkxaG3WKtYQ+564OB8J8mbI1PHJ
 LneF0SsRvU08OUrrniHIKR30jQw8fVg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
Message-ID: <Y5dwQEJHNiTPE+jz@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
 <Y5dnWgJ0ine55/hN@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Y5dnWgJ0ine55/hN@google.com>
X-Migadu-Flow: FLOW_OUT
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Yang, Weijiang" <weijiang.yang@intel.com>, "Amit, Nadav" <namit@vmware.com>,
 Ben Gardon <bgardon@google.com>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Atish Patra <atishp@atishpatra.org>, David Matlack <dmatlack@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 Colin Cross <ccross@google.com>,
 "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Mon, Dec 12, 2022 at 05:39:38PM +0000, Sean Christopherson wrote:
> On Fri, Dec 09, 2022, David Matlack wrote:
> > On Fri, Dec 9, 2022 at 9:25 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > On Fri, Dec 09, 2022 at 10:37:47AM +0800, Yang, Weijiang wrote:
> > > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > > index 4d188f056933..f375b719f565 100644
> > > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > > @@ -5056,7 +5056,7 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
> > > > >     union kvm_cpu_role role = {0};
> > > > >     role.base.access = ACC_ALL;
> > > > > -   role.base.smm = is_smm(vcpu);
> > > > > +   role.base.as_id = is_smm(vcpu);
> > > >
> > > > I'm not familiar with other architectures, is there similar conception as
> > > > x86 smm mode?
> > 
> > The notion of address spaces is already existing architecture-neutral
> > concept in KVM (e.g. see uses of KVM_ADDRESS_SPACE_NUM in
> > virt/kvm/kvm_main.c), although SMM is the only use-case I'm aware of.
> 
> Yes, SMM is currently the only use-case.
> 
> > Architectures that do not use multiple address spaces will just leave
> > as_id is as always 0.
> 
> My preference would be to leave .smm in x86's page role.  IMO, defining multiple
> address spaces to support SMM emulation was a mistake that should be contained to
> SMM, i.e. should never be used for any other feature.  And with CONFIG_KVM_SMM,
> even x86 can opt out.

+1

I don't think something is architecture-neutral by virtue of it existing
in virt/kvm/*.

> Emulating something like TrustZone or EL3 would be quite similar.

/me shudders

I know it is for the sake of discussion, but for posterity: please no!

-- 
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
