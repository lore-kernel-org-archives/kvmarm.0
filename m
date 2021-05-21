Return-Path: <SRS0=po47=KQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E473C4707E
	for <kvmarm@archiver.kernel.org>; Fri, 21 May 2021 19:04:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9FB91613DB
	for <kvmarm@archiver.kernel.org>; Fri, 21 May 2021 19:04:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FB91613DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A7034B381;
	Fri, 21 May 2021 15:04:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MoGatH2Ns6os; Fri, 21 May 2021 15:04:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E78344B32A;
	Fri, 21 May 2021 15:04:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB3B64B31A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 May 2021 15:04:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gLFwpEfvXFGs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 May 2021 15:04:24 -0400 (EDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com
 [209.85.208.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 840664B312
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 May 2021 15:04:24 -0400 (EDT)
Received: by mail-lj1-f170.google.com with SMTP id o8so25232455ljp.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 May 2021 12:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=4c0xpiDdquziT96yZl3BHBXwubR9WKTGBWbOrT+AaXw=;
 b=pECMVQG59uyASUJzijmFgULjtz0WeSXtfGqwCTJG2j+ImfbbJ7Idt9TYYFm4tIh5IH
 R9tWzg69i+hjy158g1MjSB7Mz7DEsW7oz5U8qy+v+8wWvW0wYfkBXTh5OX/GlD2LFPMi
 C8LAEMY7I+MRLp0N9IWZ0Vp4vhgE7loV0bxxYgzxSyXWT8/fH8aU2msbrP6jIKVQO7tf
 xM4kXdA4GPVanJXhvwhALX5tp1GxBbFsrxjmcutTR7FTNKSIP95t7AcRXZNV/25kLVNM
 OkzP7/ynTJ2xK6k9rq0UpyN6X3sUm8d+2LuQmwcc24FjbjaIDkK4azYIJ8RtyTmDymNU
 Ktnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=4c0xpiDdquziT96yZl3BHBXwubR9WKTGBWbOrT+AaXw=;
 b=Hdc+3t+dpuFGEyP6mS9MtcY6x6vTKZfHO4TJzFjbSTeh2FtQLfSiPkwRX69WDQ+LoE
 nBWCRdoTpfswxhKKV6dtC/ys+4XZClbyk7hK1ntjl34RPDI/9pU/ntVVTM1XUCbhhqKf
 pauvMsPsVv5XDI8BvcOf6oDWLBhR2JHYpa6fuE7DfdLG/5GbsOKpwjz4olbaA1SijIQg
 yBfCWVuyIUzI2M2bP1f6BaZaa8BjEJpa0UjOrh9Wewe6+tNRNdk1c8foziDVe9cVnFsJ
 Y6cdkQnsFivO7+cHRFq5zutB1SHtIjH8ZjSsus6D0ASuwS8p5XXVtIwkbctAf9YchCu5
 guhA==
X-Gm-Message-State: AOAM5338pxyVQivlKVf0k5imP6ZUL04NulpH6chpM3Qjo5fbZrtB4dwd
 L854vEdL8KA6FzaZmUOfcPZQU7G7LMdBQOOx+8kZZA==
X-Google-Smtp-Source: ABdhPJwOfE4Z7GOUzAJmeJCq4dABeShpU2xSSiKXlcHwytE83fbH1JNzJEVwiDFuyyhMC72fGkxyFOTVjHXM1e9tnqs=
X-Received: by 2002:a2e:a7c9:: with SMTP id x9mr7858164ljp.216.1621623862953; 
 Fri, 21 May 2021 12:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210517145314.157626-1-jingzhangos@google.com>
 <20210517145314.157626-2-jingzhangos@google.com>
 <CALzav=dGT7B7FWw_d5v3QaJxgfp6TZv7E4fdchG_7LKh+C17gg@mail.gmail.com>
 <CAAdAUtjyFhuh4iFJJOkkO20XXKqbcRO-S0ziFfUW1rHL-bkeZw@mail.gmail.com>
 <CALzav=dHjy8wnLckxifrjVDfVNBmqHcJgeS7PK6BnAp6UCyO5A@mail.gmail.com>
 <CAAdAUtiXE=CXU_LWG9SpnHsnqUBMC327jC2AvXAFX7-vwwoBog@mail.gmail.com>
 <24061be4-e1e1-e59b-d701-ea8723915e36@oracle.com>
In-Reply-To: <24061be4-e1e1-e59b-d701-ea8723915e36@oracle.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 21 May 2021 14:04:10 -0500
Message-ID: <CAAdAUtjDZGcmnubDw3x7tdNG=AFdu6sOG_4Z+AM63cmhQF3B8g@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] KVM: stats: Separate common stats from
 architecture specific ones
To: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Tue, May 18, 2021 at 1:40 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 5/18/21 10:25 AM, Jing Zhang wrote:
> > Hi David,
> >
> > On Tue, May 18, 2021 at 11:27 AM David Matlack <dmatlack@google.com> wrote:
> >> On Mon, May 17, 2021 at 5:10 PM Jing Zhang <jingzhangos@google.com> wrote:
> >> <snip>
> >>> Actually the definition of kvm_{vcpu,vm}_stat are arch specific. There is
> >>> no real structure for arch agnostic stats. Most of the stats in common
> >>> structures are arch agnostic, but not all of them.
> >>> There are some benefits to put all common stats in a separate structure.
> >>> e.g. if we want to add a stat in kvm_main.c, we only need to add this stat
> >>> in the common structure, don't have to update all kvm_{vcpu,vm}_stat
> >>> definition for all architectures.
> >> I meant rename the existing arch-specific struct kvm_{vcpu,vm}_stat to
> >> kvm_{vcpu,vm}_stat_arch and rename struct kvm_{vcpu,vm}_stat_common to
> >> kvm_{vcpu,vm}_stat.
> >>
> >> So in  include/linux/kvm_types.h you'd have:
> >>
> >> struct kvm_vm_stat {
> >>    ulong remote_tlb_flush;
> >>    struct kvm_vm_stat_arch arch;
> >> };
> >>
> >> struct kvm_vcpu_stat {
> >>    u64 halt_successful_poll;
> >>    u64 halt_attempted_poll;
> >>    u64 halt_poll_invalid;
> >>    u64 halt_wakeup;
> >>    u64 halt_poll_success_ns;
> >>    u64 halt_poll_fail_ns;
> >>    struct kvm_vcpu_stat_arch arch;
> >> };
> >>
> >> And in arch/x86/include/asm/kvm_host.h you'd have:
> >>
> >> struct kvm_vm_stat_arch {
> >>    ulong mmu_shadow_zapped;
> >>    ...
> >> };
> >>
> >> struct kvm_vcpu_stat_arch {
> >>    u64 pf_fixed;
> >>    u64 pf_guest;
> >>    u64 tlb_flush;
> >>    ...
> >> };
> >>
> >> You still have the same benefits of having an arch-neutral place to
> >> store stats but the struct layout more closely resembles struct
> >> kvm_vcpu and struct kvm.
> > You are right. This is a more reasonable way to layout the structures.
> > I remember that I didn't choose this way is only because that it needs
> > touching every arch specific stats in all architectures (stat.name ->
> > stat.arch.name) instead of only touching arch neutral stats.
> > Let's see if there is any vote from others about this.
>
>
> +1
>
> >
> > Thanks,
> > Jing
It is still not fun to change hundreds of stats update code in every
architectures.
Let's keep it as it is for now and see how it is going.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
