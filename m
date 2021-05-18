Return-Path: <SRS0=6U3X=KN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECC6C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 18 May 2021 18:43:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACB7861261
	for <kvmarm@archiver.kernel.org>; Tue, 18 May 2021 18:43:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACB7861261
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CDA94B573;
	Tue, 18 May 2021 14:43:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YieLjC9ZyET9; Tue, 18 May 2021 14:43:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17BD64B563;
	Tue, 18 May 2021 14:43:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E70BC4B45B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 May 2021 12:27:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UEYOofoL03XR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 May 2021 12:27:35 -0400 (EDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com
 [209.85.208.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C18FB4B404
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 May 2021 12:27:34 -0400 (EDT)
Received: by mail-lj1-f169.google.com with SMTP id v5so12287273ljg.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 May 2021 09:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=oCHyX25nut1dXgrfKvPYZ4vLHkOFpNujX0A0DBHr6zA=;
 b=QQnYdPNPVB26qj7Ys12iD114pAArbDt9pCpdKRPqNfNWWhY6L+RXxxCV1QAy/7013Y
 rdZk/pvPuSWTxe5cV2yVN+qzIuhMHB4f9KgRvwVOE/0zgJoS7f6OtPQbeyQnK4rfmDao
 We7oSlerhFdZBoJUU0HWqL/We+yx8/1Dxdqx9Jnb4CK44kTGNedTGWoQSELf0ZxgymsI
 J5/nIa007Ed7SFBCwXhYwUMbb5gVF31pqKkXp8whelqyoYug4VtfNU8WqB1K1vW7oS2l
 S522kEQZFPyDnmehv/a8zHfx/8wTBn4kn/r33mvqZuzzfh4tlyZWPaiBDgcCUkvsH1yW
 0Y8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=oCHyX25nut1dXgrfKvPYZ4vLHkOFpNujX0A0DBHr6zA=;
 b=qdjwQRpYZNhIJLhF925iNAh4FseJoM8fyO6AcqqsJBevMCKYFAHRD6DJQoH6zey13Z
 +MjYaGpr0vPAwqHIXD488KJSpuTGilHGsmxW5x0PYxT/Sk0IX737Cfo0nsXnpX6pdZhH
 gUBrK4zvOSK93sjYubOHsB+wMiZaz40J66kZNj2gkDupi30h4zx7Zqt58h3yTwqCcTJn
 rxDfNlJM1e7Uu1JP1G9ogR6CVxnti3UapDc0KhJVksFe83EWScYzWDofJ6aF18fXqN0R
 pEhvpNd1pDqAfUmC0Iq0HcpjObJJjFk7pypzVwww+P/XDQO0wzqr6oXfH+5cBjWVUMy5
 m3iQ==
X-Gm-Message-State: AOAM533n/mrgX5MfTtflks7avGY1G2LxZiMM6TofWABGnpgEjrlNFstM
 bBPkkhYeWrW9x7i5tnMd07RIjMlyc9dGLOpJg/VtQQ==
X-Google-Smtp-Source: ABdhPJwMrV1eLucK07ggc7pKZYp2/4fRRvxCRtyoN4tBFxgPe2X3AL8Bz64jmu1CM19fdZ3EtBoPQ6h8vlutNeAyWRM=
X-Received: by 2002:a2e:81d0:: with SMTP id s16mr4934378ljg.74.1621355253213; 
 Tue, 18 May 2021 09:27:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210517145314.157626-1-jingzhangos@google.com>
 <20210517145314.157626-2-jingzhangos@google.com>
 <CALzav=dGT7B7FWw_d5v3QaJxgfp6TZv7E4fdchG_7LKh+C17gg@mail.gmail.com>
 <CAAdAUtjyFhuh4iFJJOkkO20XXKqbcRO-S0ziFfUW1rHL-bkeZw@mail.gmail.com>
In-Reply-To: <CAAdAUtjyFhuh4iFJJOkkO20XXKqbcRO-S0ziFfUW1rHL-bkeZw@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 18 May 2021 09:27:06 -0700
Message-ID: <CALzav=dHjy8wnLckxifrjVDfVNBmqHcJgeS7PK6BnAp6UCyO5A@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] KVM: stats: Separate common stats from
 architecture specific ones
To: Jing Zhang <jingzhangos@google.com>
X-Mailman-Approved-At: Tue, 18 May 2021 14:43:16 -0400
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

On Mon, May 17, 2021 at 5:10 PM Jing Zhang <jingzhangos@google.com> wrote:
<snip>
> Actually the definition of kvm_{vcpu,vm}_stat are arch specific. There is
> no real structure for arch agnostic stats. Most of the stats in common
> structures are arch agnostic, but not all of them.
> There are some benefits to put all common stats in a separate structure.
> e.g. if we want to add a stat in kvm_main.c, we only need to add this stat
> in the common structure, don't have to update all kvm_{vcpu,vm}_stat
> definition for all architectures.

I meant rename the existing arch-specific struct kvm_{vcpu,vm}_stat to
kvm_{vcpu,vm}_stat_arch and rename struct kvm_{vcpu,vm}_stat_common to
kvm_{vcpu,vm}_stat.

So in  include/linux/kvm_types.h you'd have:

struct kvm_vm_stat {
  ulong remote_tlb_flush;
  struct kvm_vm_stat_arch arch;
};

struct kvm_vcpu_stat {
  u64 halt_successful_poll;
  u64 halt_attempted_poll;
  u64 halt_poll_invalid;
  u64 halt_wakeup;
  u64 halt_poll_success_ns;
  u64 halt_poll_fail_ns;
  struct kvm_vcpu_stat_arch arch;
};

And in arch/x86/include/asm/kvm_host.h you'd have:

struct kvm_vm_stat_arch {
  ulong mmu_shadow_zapped;
  ...
};

struct kvm_vcpu_stat_arch {
  u64 pf_fixed;
  u64 pf_guest;
  u64 tlb_flush;
  ...
};

You still have the same benefits of having an arch-neutral place to
store stats but the struct layout more closely resembles struct
kvm_vcpu and struct kvm.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
