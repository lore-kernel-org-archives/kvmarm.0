Return-Path: <SRS0=pYg6=PQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB96C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 15:34:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7F803610CF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Oct 2021 15:34:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7F803610CF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFBB24B175;
	Thu, 28 Oct 2021 11:34:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s1hy9ClNC5VK; Thu, 28 Oct 2021 11:34:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E16794B1E3;
	Thu, 28 Oct 2021 11:34:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B1584B1DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 11:34:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id we-iu9lbz2Ry for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Oct 2021 11:34:26 -0400 (EDT)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E4364B1DA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 11:34:26 -0400 (EDT)
Received: by mail-pg1-f169.google.com with SMTP id c4so6717144pgv.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Oct 2021 08:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=ObU0mLn8cgLGt35bHM9Ve7PBUotjGGEWKnNtAqnV8Y0=;
 b=Dh2oRVWq7FNB4VxeeBx+DY+B7J6W36/D0YFmfA4JinPWULNj2JAyVIdGN5W95l+d90
 4Uu/ZwJdWUivmqUAxVTynE14t1JCgr4B8VIlvCnfQRBjV/9sZBN9FbtVQViBrcsIkfKk
 FKX6ULIrvBdeMPobrWIP7p55k83rg/EH2wU4GD4W9e2j7rIISQUbKASJH6T77kFM7m0Z
 Qtlmy8wjfeMDEMJrWpV2K5PFqGDN6VxYLPZtUxrtHEs4QyogxcvUebO7UVfiBHutG04k
 U0NkfKu6Je8Pt6shzy+xbyjZteg84KZAIk3v/fR91ZfKR/MAff+MA9k1aMrDIiCOqEqs
 s/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=ObU0mLn8cgLGt35bHM9Ve7PBUotjGGEWKnNtAqnV8Y0=;
 b=L5BXbm46P2lrcEGqgPHhh0biyE/rQlVIo+SjIWsCEpReX1LLfQsF5KA3TRicEkujox
 vEcJXds8TgZ0CSKBDLoMcRkNVWUY9cRwgBpVEhTC5rbQ1iJEXPpGR5q0MJUligEwML+P
 NAivVGZy2gQtYICPQLTYs/3AFd6xbGZXr8uHyqxEIzktIGXm+xMqa6OdBcZSYSfiKo42
 2/9VK/xnRBaeC6uYKF3thvcdRRFTHxynbBuPZ8iHFNdCIuB0UTOht8MYhm5gSxZHUevR
 CijcM9qO6it7Nk3E5zNlfFTzYXEaymPeGYuJTaGH53CcBkTi0BTsdz2HEfpAb/qqwNra
 GI3g==
X-Gm-Message-State: AOAM533sCTmGK+Eb/Ciu/yf4P5NsrM23oH50zkZbG745sCDcyc29n1td
 H+eMISQfXvOjrihUwrYxAQ9J3g==
X-Google-Smtp-Source: ABdhPJz6jdrYVfnN/6E/mwaWkSEy+zhYc5xKvC8pKY4AVCJGv9Uh9d4/rKPGgqsum0tyEq6Ye9Z/qw==
X-Received: by 2002:aa7:9427:0:b0:47c:3b8e:5253 with SMTP id
 y7-20020aa79427000000b0047c3b8e5253mr5166508pfo.69.1635435265242; 
 Thu, 28 Oct 2021 08:34:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id p12sm4586055pfh.52.2021.10.28.08.34.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 28 Oct 2021 08:34:24 -0700 (PDT)
Date: Thu, 28 Oct 2021 15:34:21 +0000
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 21/43] KVM: VMX: Clean up PI pre/post-block WARNs
Message-ID: <YXrC/X6b+tgn6cJ9@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-22-seanjc@google.com>
 <6b2bdfad87e268e861b6cc331d25790dade8e27b.camel@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6b2bdfad87e268e861b6cc331d25790dade8e27b.camel@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 linux-kernel@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Atish Patra <atish.patra@wdc.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Albert Ou <aou@eecs.berkeley.edu>, kvm-ppc@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Anup Patel <anup.patel@wdc.com>, linux-mips@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
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

On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > Move the WARN sanity checks out of the PI descriptor update loop so as
> > not to spam the kernel log if the condition is violated and the update
> > takes multiple attempts due to another writer.  This also eliminates a
> > few extra uops from the retry path.
> > 
> > Technically not checking every attempt could mean KVM will now fail to
> > WARN in a scenario that would have failed before, but any such failure
> > would be inherently racy as some other agent (CPU or device) would have
> > to concurrent modify the PI descriptor.

...

> Don't know for sure if this is desired. I'll would just use WARN_ON_ONCE instead
> if the warning spams the log.
> 
> If there is a race I would rather want to catch it even if rare.

Paolo had similar concerns[*].  I copied the most relevant part of the discussion
below, let me know if you object to the outcome.

Thanks for the reviews!

[*] https://lore.kernel.org/all/YXllGfrjPX1pVUx6@google.com/T/#u

On Wed, Oct 27, 2021 at 8:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 27/10/21 17:28, Sean Christopherson wrote:
> > On Wed, Oct 27, 2021, Paolo Bonzini wrote:
> > > On 27/10/21 16:41, Sean Christopherson wrote:
> > > > The other thing I don't like about having the WARN in the loop is that it suggests
> > > > that something other than the vCPU can modify the NDST and SN fields, which is
> > > > wrong and confusing (for me).
> > >
> > > Yeah, I can agree with that.  Can you add it in a comment above the cmpxchg
> > > loop, it can be as simple as
> > >
> > > 	/* The processor can set ON concurrently.  */
> > >
> > > when you respin patch 21 and the rest of the series?
> >
> > I can definitely add a comment, but I think that comment is incorrect.
>
> It's completely backwards indeed.  I first had "the hardware" and then
> shut down my brain for a second to replace it.
>
> > So something like this?
> >
> > 	/* ON can be set concurrently by a different vCPU or by hardware. */
>
> Yes, of course.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
