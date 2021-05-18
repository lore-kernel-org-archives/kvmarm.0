Return-Path: <SRS0=6U3X=KN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3875C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 18 May 2021 17:25:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 60E02611BF
	for <kvmarm@archiver.kernel.org>; Tue, 18 May 2021 17:25:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60E02611BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C65014B116;
	Tue, 18 May 2021 13:25:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bm9GDxbxsn38; Tue, 18 May 2021 13:25:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B5CE24B440;
	Tue, 18 May 2021 13:25:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3BE24B116
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 May 2021 13:25:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6WITzNHFVNHA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 May 2021 13:25:38 -0400 (EDT)
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com
 [209.85.208.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 420414B07F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 May 2021 13:25:38 -0400 (EDT)
Received: by mail-lj1-f176.google.com with SMTP id v6so12499716ljj.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 May 2021 10:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=mSnQ4LBK1uIXV07PEAq0LLHlwweU24rztLmKUUxmtEw=;
 b=cVzaFjUacrAERsYDIZbRfiVBm3UJe9PfiIi7VMEBI4+mneYhTfREF32Ug/H7xsKLXF
 xipKw744Y+OPokHmPOwiIilZlVMYtdOjIl5i+xzJy7TSKI5AdyAp62xAFFvkz5aGK7IR
 rcFwa6FW0Zd3WOBHc48RIIAD4Evo4cCVo4dzA/EBc5YwUsnO0+ec80kxrOAFwBSHfz24
 4e/5s/iwhO092+JJCHv/Mly7vK5p7eUvyheKOSI7fXe24zmHVEHwIeyudrmdfiXjw4AW
 BgKIuFcumclXiaD/TAOYs9fp/I9XvbqU76xLXdbQq1MXVo7j4RToAD81UGguuU1ez9aX
 XYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=mSnQ4LBK1uIXV07PEAq0LLHlwweU24rztLmKUUxmtEw=;
 b=II+vAsjxgMRwQWoI77ZQ3db/4foFS2BalRexE78KdlC1HJRn5f0H/4aU846LWXPgu+
 9aBbcT6mZWiGwDanMKd+e31/JKVKxKX+cCnpMyc6gQzX4yUSjONWOeSX9SsC04bdjSWN
 tHPX3pzxIEeuCPj452D57/NjbapXCH7UB50aFs3QD4G64oa8vLyqd9Erz77xGhkeW+Ni
 ff+zkPHiUxCLW6bRkL9OdHEuV+h0p5A9UsMONOYyPs7FmuKIR+8zlmovPDXWvSwcuU8Z
 OmcJUXwm4X99vP6ERAQfq0BowKd28TTTEKyEhFEoTctngCXQn6jI0CApLBEfItA1S3qX
 gUpw==
X-Gm-Message-State: AOAM531zNWgZWI8iq9j1UgY3EmKdpf3O5mBi7OOhqvGDIrjjkhWbKegi
 knGmQ9kJewCzVse3wnN6wG10MzZNa0mAZDcOM+/bcw==
X-Google-Smtp-Source: ABdhPJwmvfrKFgUyKP/HRH4nFuJ9B6kEhZAEG5g+dr6hELyJdzM7GIR8aVIZG1uUChl8DfU1otU2kJaVQc2bMkV5kGM=
X-Received: by 2002:a2e:87ce:: with SMTP id v14mr4952952ljj.28.1621358736766; 
 Tue, 18 May 2021 10:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210517145314.157626-1-jingzhangos@google.com>
 <20210517145314.157626-2-jingzhangos@google.com>
 <CALzav=dGT7B7FWw_d5v3QaJxgfp6TZv7E4fdchG_7LKh+C17gg@mail.gmail.com>
 <CAAdAUtjyFhuh4iFJJOkkO20XXKqbcRO-S0ziFfUW1rHL-bkeZw@mail.gmail.com>
 <CALzav=dHjy8wnLckxifrjVDfVNBmqHcJgeS7PK6BnAp6UCyO5A@mail.gmail.com>
In-Reply-To: <CALzav=dHjy8wnLckxifrjVDfVNBmqHcJgeS7PK6BnAp6UCyO5A@mail.gmail.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 18 May 2021 12:25:24 -0500
Message-ID: <CAAdAUtiXE=CXU_LWG9SpnHsnqUBMC327jC2AvXAFX7-vwwoBog@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] KVM: stats: Separate common stats from
 architecture specific ones
To: David Matlack <dmatlack@google.com>
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
 Jim Mattson <jmattson@google.com>,
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

Hi David,

On Tue, May 18, 2021 at 11:27 AM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, May 17, 2021 at 5:10 PM Jing Zhang <jingzhangos@google.com> wrote:
> <snip>
> > Actually the definition of kvm_{vcpu,vm}_stat are arch specific. There is
> > no real structure for arch agnostic stats. Most of the stats in common
> > structures are arch agnostic, but not all of them.
> > There are some benefits to put all common stats in a separate structure.
> > e.g. if we want to add a stat in kvm_main.c, we only need to add this stat
> > in the common structure, don't have to update all kvm_{vcpu,vm}_stat
> > definition for all architectures.
>
> I meant rename the existing arch-specific struct kvm_{vcpu,vm}_stat to
> kvm_{vcpu,vm}_stat_arch and rename struct kvm_{vcpu,vm}_stat_common to
> kvm_{vcpu,vm}_stat.
>
> So in  include/linux/kvm_types.h you'd have:
>
> struct kvm_vm_stat {
>   ulong remote_tlb_flush;
>   struct kvm_vm_stat_arch arch;
> };
>
> struct kvm_vcpu_stat {
>   u64 halt_successful_poll;
>   u64 halt_attempted_poll;
>   u64 halt_poll_invalid;
>   u64 halt_wakeup;
>   u64 halt_poll_success_ns;
>   u64 halt_poll_fail_ns;
>   struct kvm_vcpu_stat_arch arch;
> };
>
> And in arch/x86/include/asm/kvm_host.h you'd have:
>
> struct kvm_vm_stat_arch {
>   ulong mmu_shadow_zapped;
>   ...
> };
>
> struct kvm_vcpu_stat_arch {
>   u64 pf_fixed;
>   u64 pf_guest;
>   u64 tlb_flush;
>   ...
> };
>
> You still have the same benefits of having an arch-neutral place to
> store stats but the struct layout more closely resembles struct
> kvm_vcpu and struct kvm.
You are right. This is a more reasonable way to layout the structures.
I remember that I didn't choose this way is only because that it needs
touching every arch specific stats in all architectures (stat.name ->
stat.arch.name) instead of only touching arch neutral stats.
Let's see if there is any vote from others about this.

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
