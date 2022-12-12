Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2D2C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 17:39:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8C5A4B963;
	Mon, 12 Dec 2022 12:39:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IfR8DgzbnYMT; Mon, 12 Dec 2022 12:39:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 770404B896;
	Mon, 12 Dec 2022 12:39:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 166EC4B889
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 12:39:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vW9UnqaNs4Xy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 12:39:43 -0500 (EST)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C4D64B87D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 12:39:43 -0500 (EST)
Received: by mail-pg1-f181.google.com with SMTP id 82so8724197pgc.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 09:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=9QS7ynIDmKRlIs3oQp3nNRq3SgpEDJuiT7l2fKUtqJA=;
 b=Q0nnG/dD12oshnk2CykCxq72d8uZrdzzqkuH5dft2uszejZpVFSnXayz+SB3Bwgro8
 BRpXeeCgbqfUn2wNBfcOZyX3qyFKQJ6SczkPWVABh1mpb57722xzOrsTLiE48vG5UkwV
 bWLck3WppDEGsIUBHKKGTEWgFtdCLpnoSQ2bevYVQ/nLcPPAgPGAlA/9ZOfUNOvgOGId
 G76GaBjjIODSpD0MI08sPApYWZ6pYb2TgRVicuKhWCGe6JSitmtMJPjC2xPhiXqe6dk1
 lh4RR1K4cJ0EETmdVRDXbjpYPE9b76QlJk+PQjM9eohHtNpBi7HjhEH0vhjhhqilbAjf
 2W6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=9QS7ynIDmKRlIs3oQp3nNRq3SgpEDJuiT7l2fKUtqJA=;
 b=MYMNzU5O1ry6X4F71qz6+YNdIr0MBHlCZvKAqX5dLlT6ksZc6pB2KmtuiuP21LbpXs
 uVmP9a5M2LJyJYaTUNXJvsFwzW0gqsn4xFskKXnCSWDdwOj38tgZ0vx1s4k4/9tOcfHf
 0bT5mxFQ9abBfH5I5wktYhj7YJyrxBff2Xi8H8yai6n4FEbxhhleANXaf4T5/VTh8D+7
 PRYFjnJ/nzwIsTkfyq2tRFpEdBcpdV8biCtwYk4/BcGMiz6sG8/OQqYW6P2yqtEoE1N4
 9PEwhXvGsHcroq23mjruXQ7Ur5nOk8tWOkCgyCoNF6ViQYDg18ghwV7y3AeIroZUQzix
 5RRg==
X-Gm-Message-State: ANoB5pnvRP4VmdMZfNPlfg3EeiHJx6OVZlytbtrHR8nUV/a2ndhsgH2k
 1UgPxn0wjjB6Z0vVMdzGmVWHJg==
X-Google-Smtp-Source: AA0mqf4fRjcF7yqcwPoqLk9QucrmsFbaTw1SZFxx+iK6d+zjxBOpK3Jkaq0gjsaSmdZVgYI9LkA78w==
X-Received: by 2002:a05:6a00:27a4:b0:576:22d7:fd9e with SMTP id
 bd36-20020a056a0027a400b0057622d7fd9emr657961pfb.0.1670866782130; 
 Mon, 12 Dec 2022 09:39:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 y10-20020aa793ca000000b0057555d35f79sm6092008pff.101.2022.12.12.09.39.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 12 Dec 2022 09:39:41 -0800 (PST)
Date: Mon, 12 Dec 2022 17:39:38 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [RFC PATCH 01/37] KVM: x86/mmu: Store the address space ID
 directly in kvm_mmu_page_role
Message-ID: <Y5dnWgJ0ine55/hN@google.com>
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-2-dmatlack@google.com>
 <22fe2332-497e-fe30-0155-e026b0eded97@intel.com>
 <Y5NvYmxpy6BPkmpW@google.com>
 <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALzav=eju4LYyX=ufNneSww+5sraYJ8cfQSi4LTOHfHWmddX9A@mail.gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Yang, Weijiang" <weijiang.yang@intel.com>, "Amit, Nadav" <namit@vmware.com>,
 Colin Cross <ccross@google.com>, Ben Gardon <bgardon@google.com>,
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
 Atish Patra <atishp@atishpatra.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
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

On Fri, Dec 09, 2022, David Matlack wrote:
> On Fri, Dec 9, 2022 at 9:25 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Fri, Dec 09, 2022 at 10:37:47AM +0800, Yang, Weijiang wrote:
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 4d188f056933..f375b719f565 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -5056,7 +5056,7 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
> > > >     union kvm_cpu_role role = {0};
> > > >     role.base.access = ACC_ALL;
> > > > -   role.base.smm = is_smm(vcpu);
> > > > +   role.base.as_id = is_smm(vcpu);
> > >
> > > I'm not familiar with other architectures, is there similar conception as
> > > x86 smm mode?
> 
> The notion of address spaces is already existing architecture-neutral
> concept in KVM (e.g. see uses of KVM_ADDRESS_SPACE_NUM in
> virt/kvm/kvm_main.c), although SMM is the only use-case I'm aware of.

Yes, SMM is currently the only use-case.

> Architectures that do not use multiple address spaces will just leave
> as_id is as always 0.

My preference would be to leave .smm in x86's page role.  IMO, defining multiple
address spaces to support SMM emulation was a mistake that should be contained to
SMM, i.e. should never be used for any other feature.  And with CONFIG_KVM_SMM,
even x86 can opt out.

For all potential use cases I'm aware of, SMM included, separate address spaces
are overkill.  The SMM use case is to define a region of guest memory that is
accessible if and only if the vCPU is operating in SMM.  Emulating something like
TrustZone or EL3 would be quite similar.  Ditto for Intel's TXT Private Space
(though I can't imagine KVM ever emulating TXT :-) ).

Using separate address spaces means that userspace needs to define the overlapping
GPA areas multiple times, which is inefficient for both memory and CPU usage.
E.g. for SMM,  userspace needs to redefine all of "regular" memory for SMM in
addition to memory that is SMM-only.  And more bizarelly, nothing prevents userspace
from defining completely different memslot layouts for each address space, which
might may not add complexity in terms of code, but does make it more difficult to
reason about KVM behavior at the boundaries between modes.

Unless I'm missing something, e.g. a need to map GPAs differently for SMM vs.
non-SMM, SMM could have been implemented with a simple flag in a memslot to mark
the memslot as SMM-only.  Or likely even better, as an overlay to track attributes,
e.g. similar to how private vs. shared memory will be handled for protected VMs.
That would be slightly less efficient for memslot searches for use cases where all
memory is mutually exclusive, but simpler and more efficient overall.

And separate address spaces become truly nasty if the CPU can access multiple
protected regions, e.g. if the CPU can access type X and type Y at the same time,
then there would need to be memslots for "regular", X, Y, and X+Y.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
