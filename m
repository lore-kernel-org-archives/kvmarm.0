Return-Path: <SRS0=rYk4=LP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20EDDC49EA2
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 17:42:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9861B61245
	for <kvmarm@archiver.kernel.org>; Mon, 21 Jun 2021 17:42:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9861B61245
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01E2A4066E;
	Mon, 21 Jun 2021 13:42:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H6SYrwrY8uiz; Mon, 21 Jun 2021 13:42:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6B04020A;
	Mon, 21 Jun 2021 13:42:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47B544020A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 13:42:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z2YDqsZLRn5H for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Jun 2021 13:42:46 -0400 (EDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F807401A4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 13:42:46 -0400 (EDT)
Received: by mail-lf1-f41.google.com with SMTP id j2so31578436lfg.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Jun 2021 10:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=qfK/SVz4it+B5UPXi3JJjfN4xS2rz4IlLdh/dhi7P/A=;
 b=pywx1GKnLV8rMPGg0yESPQxjjJELUUA6eFGxQfp1SLreFtlNjvMnVkBKCsMTmOd55H
 L2Ov1NYXG6PlckYJH8Gw//+mcOBRMDwUXKZ+OXAi5Nyj1KRLWBLsJCtqGFb1mQ50QAep
 +66Iks8s9xqkwilngZ/CjQPCJsYngQFefHmEiKXBRFcuGdGgcDy7nbwnYmWpFSIzb8JM
 Cjf5+S39y3LrfjOsEEnW09/kn8GvhArY29GOk3d0VywwjXhx383+3K6zA3KOodjnfkQi
 8CQsP6Ze09t1BHzCBmmEOfUrgWwOaLawqHrTy11NMe7lYNZNHRIg3ZSNWKHZDD1fW8kp
 ZZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qfK/SVz4it+B5UPXi3JJjfN4xS2rz4IlLdh/dhi7P/A=;
 b=d1hdFKraprS9Fd552F3f9a/YaNhcFZkCrjpbPOS+Rlz8H2MTbtVnClGOLeIsU9cH1T
 ksssr1SBB+xPK395r6taE+31ZyAJaC88MTD/yeqx4mdui1xhbeFLgjAkmMATTpOXxVMV
 E22bRDbWn81+5QN/9rhm73c+18wlCKqb5w0vxnbQB/4EaxDjpzcA1avJqjrYf67Y7VWE
 6R5lLJIk78TmeKfUkJ8T5A6vEuSnXscS7HHk6fEwZXJjiGocCQgKkSMyoYnN2c7U2O2g
 XAGdSjtu6kKosumFlH3ynKJfOlJTIhaDDVEDaDAeu+cvAEj6J5ZiTs2Nr1OLUtmmAldH
 SFIw==
X-Gm-Message-State: AOAM532la1etZ1zD3aLuPMVMgd3BfXuwVmad/2PMm1blOm9VhwQ5jN5n
 aDDACb+CWgFdDQOYqgZOQFHH1YfYbszwrPHfLTW9DA==
X-Google-Smtp-Source: ABdhPJze+ab86EoUTOPQeCvTUOFZdayN8Zdi+mpGgTYzSXakq0/1emu/tNIwi9+QdEI2rk/c2bFMigguUMCYbOuXxYw=
X-Received: by 2002:a05:6512:39ca:: with SMTP id
 k10mr15161030lfu.473.1624297364420; 
 Mon, 21 Jun 2021 10:42:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210618222709.1858088-1-jingzhangos@google.com>
 <20210618222709.1858088-5-jingzhangos@google.com>
 <d8bb52e6-3d1c-7008-388f-699f1a872e80@redhat.com>
In-Reply-To: <d8bb52e6-3d1c-7008-388f-699f1a872e80@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 21 Jun 2021 12:42:33 -0500
Message-ID: <CAAdAUtiC68ViKRH=1_N9VPzNszZHUN5Yc0GNXJ3BFL+8=tz0Gw@mail.gmail.com>
Subject: Re: [PATCH v12 4/7] KVM: stats: Support binary stats retrieval for a
 VCPU
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, Jun 21, 2021 at 11:46 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 19/06/21 00:27, Jing Zhang wrote:
> > +     struct kvm_vcpu_stat stat;
> >       struct kvm_dirty_ring dirty_ring;
> > +     char stats_id[KVM_STATS_NAME_SIZE];
>
> I think stats_id needs to be part of the usercopy region too.
>
> You can also use
>
> offsetofend(struct kvm_vcpu, stats_id) - offsetof(struct kvm_vcpu, arch)
>
> to compute the size.
Sure! Will do.
>
> Paolo
>

Thanks,
Jing
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
