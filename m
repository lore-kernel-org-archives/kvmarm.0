Return-Path: <SRS0=/m9d=NY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19423C433F5
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 17:52:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A5DF610CC
	for <kvmarm@archiver.kernel.org>; Thu,  2 Sep 2021 17:52:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9A5DF610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 171BD4B0BF;
	Thu,  2 Sep 2021 13:52:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sEa3YE9QmKFG; Thu,  2 Sep 2021 13:52:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD0994B0DD;
	Thu,  2 Sep 2021 13:52:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB4284B0BF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 13:52:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J-FjgyV5JePn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Sep 2021 13:52:16 -0400 (EDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com
 [209.85.219.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 64D9A4B0BA
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Sep 2021 13:52:16 -0400 (EDT)
Received: by mail-yb1-f176.google.com with SMTP id c6so5415369ybm.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 02 Sep 2021 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=xAUZw7IrrctnJdeQBEtbAhv9xiy70VOpKzIZyk6KqAA=;
 b=iyKqthjIRwPONyCS4/FKOde7Qj8MPxzxsMuN8Ti/E5d4o95dMRFhXGD0ZN2pu7RPVp
 JwWUX/2NUc7y4oxHWdsjIHW4i99GjxckLQGR8lyOsGYMBoUAf4tdI8Tc2b2WN05V78s1
 1ci/XTZoMbCx+VULa5z5tq7lKuPFjEOFL2ewyVdnHWMbRBr8zMXxtFQ47bECS/S778Vd
 uWYSbkDI5Q7wCUKjWhT936QxX63P6W5fUF+RE1aax17r7lqa+ihcXphy+D1BQzgYmBOh
 74HWpCi3vjxnYhTz4SIltFZH+bMTbuiVxuEulZmZgyDq40oAz76TRf9JSIgTAEM3wNC2
 3lXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=xAUZw7IrrctnJdeQBEtbAhv9xiy70VOpKzIZyk6KqAA=;
 b=TWzEMtTt8R7HKaOD1MXLiY5DPIaJ4I45vTHYlCjrP365+ZD5jgJwisgnsDVn5XVedi
 DVEcRg7cfE73t4AX5l8obv1mJf1l9SaQlRMEYGBxeOZyQH7VXDuDubP4Q7k5komTSpsC
 ZIOsmRWvTERQqRL8Czd7gxjxn0/Fm/0zIr2WNMScV3+QvHwk/mvS95bDXeTIuqYsDuJY
 /XEaQzyFRnZQL6fKy3mF8JrsLHn/Shzr9byUNa+8zuOEIxsZj49w6Z5fVy4KSQhCTEMP
 79fSKGEtpInFm+vD1pc0bRdwLwHNHfI3ccIMfJg1cMNiA+DUTtkecTyEeWmYXynai9h4
 ziVA==
X-Gm-Message-State: AOAM533tq/94Fid3TW+uqQRLqVZIfUonXblrcpIwp8HAS5LtrANR/kcN
 F6tcccxwFjpDn+wOqettGHsMrDaoO1ffwoUHhyVKug==
X-Google-Smtp-Source: ABdhPJwQXtJzqbxl4gNeMNvhKYFqgI/uCi3/Up5vD6artyFiw1jvBI/+9aQ5dnuQX2F2LGGKUfF/T1/Eh5NonYuxIbU=
X-Received: by 2002:a25:4f87:: with SMTP id d129mr5967977ybb.359.1630605135660; 
 Thu, 02 Sep 2021 10:52:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-8-rananta@google.com>
 <YTARPBhMHXjgcPlg@google.com> <20210902123656.lfzwqrlw5kbvckah@gator>
In-Reply-To: <20210902123656.lfzwqrlw5kbvckah@gator>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 2 Sep 2021 10:52:05 -0700
Message-ID: <CAJHc60xQYiOsQcZ64SVsVRarnb2b+fefRYq+xQ8FeqGxH0fY2w@mail.gmail.com>
Subject: Re: [PATCH v3 07/12] KVM: arm64: selftests: Add support to get the
 vcpuid from MPIDR_EL1
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Sep 2, 2021 at 5:37 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Wed, Sep 01, 2021 at 11:48:12PM +0000, Oliver Upton wrote:
> > On Wed, Sep 01, 2021 at 09:14:07PM +0000, Raghavendra Rao Ananta wrote:
> > > At times, such as when in the interrupt handler, the guest wants to
> > > get the vCPU-id that it's running on. As a result, introduce
> > > get_vcpuid() that parses the MPIDR_EL1 and returns the vcpuid to the
> > > requested caller.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  .../selftests/kvm/include/aarch64/processor.h | 19 +++++++++++++++++++
> > >  1 file changed, 19 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > index c35bb7b8e870..8b372cd427da 100644
> > > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > > @@ -251,4 +251,23 @@ static inline void local_irq_disable(void)
> > >     asm volatile("msr daifset, #3" : : : "memory");
> > >  }
> > >
> > > +#define MPIDR_LEVEL_BITS 8
> > > +#define MPIDR_LEVEL_SHIFT(level) (MPIDR_LEVEL_BITS * level)
> > > +#define MPIDR_LEVEL_MASK ((1 << MPIDR_LEVEL_BITS) - 1)
> > > +#define MPIDR_AFFINITY_LEVEL(mpidr, level) \
> > > +   ((mpidr >> MPIDR_LEVEL_SHIFT(level)) & MPIDR_LEVEL_MASK)
> > > +
> > > +static inline uint32_t get_vcpuid(void)
> > > +{
> > > +   uint32_t vcpuid = 0;
> > > +   uint64_t mpidr = read_sysreg(mpidr_el1);
> > > +
> > > +   /* KVM limits only 16 vCPUs at level 0 */
> > > +   vcpuid = mpidr & 0x0f;
> > > +   vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 1) << 4;
> > > +   vcpuid |= MPIDR_AFFINITY_LEVEL(mpidr, 2) << 12;
> > > +
> > > +   return vcpuid;
> > > +}
> >
> > Are we guaranteed that KVM will always compose vCPU IDs the same way? I
> > do not believe this is guaranteed ABI.
>
> I don't believe we are. At least in QEMU we take pains to avoid that
> assumption.
>
> >
> > For the base case, you could pass the vCPU ID as an arg to the guest
> > function.
> >
> > I do agree that finding the vCPU ID is a bit more challenging in an
> > interrupt context. Maybe use a ucall to ask userspace? But of course,
> > every test implements its own run loop, so its yet another case that
> > tests need to handle.
> >
> > Or, you could allocate an array at runtime of length KVM_CAP_MAX_VCPUS
> > (use the KVM_CHECK_EXTENSION ioctl to get the value). Once all vCPUs are
> > instantiated, iterate over them from userspace to populate the {MPIDR,
> > VCPU_ID} map. You'd need to guarantee that callers initialize the vGIC
> > *after* adding vCPUs to the guest.
>
> I agree with this approach. It may even make sense to create a common
> function that returns a {cpu_id,vcpu_index} map for other tests to use.
>
Interesting idea. I'll look into this.

Regards,
Raghavendra

> Thanks,
> drew
>
> >
> > --
> > Thanks,
> > Oliver
> >
> > >  #endif /* SELFTEST_KVM_PROCESSOR_H */
> > > --
> > > 2.33.0.153.gba50c8fa24-goog
> > >
> > _______________________________________________
> > kvmarm mailing list
> > kvmarm@lists.cs.columbia.edu
> > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> >
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
