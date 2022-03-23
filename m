Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D491EC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 06:06:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F94A49EFD;
	Wed, 23 Mar 2022 02:06:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hrIPaMaiIlap; Wed, 23 Mar 2022 02:06:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D805349EEE;
	Wed, 23 Mar 2022 02:06:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0F2049EE1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 02:06:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xj6YjYzuR+km for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 02:06:43 -0400 (EDT)
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com
 [209.85.215.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8733540FD6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 02:06:43 -0400 (EDT)
Received: by mail-pg1-f170.google.com with SMTP id w21so336832pgm.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 23:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=TMWiPpce5uJfh5LzsvNs4pu3d9Ouof0td3tYTU99XWs=;
 b=IIhYlZ7oqlN50w8829NZbQWoQVTXirqX5nU75Rn4DIelpKnnabo4vhfhTRghOT3Lsy
 IHS+m3wOF6J+qKDaQAd0SecMGmCZNy3MO63+dq/jihkgpo7zqYXQu+lM8ZlRttU6Quxn
 vf+FBSUGMA6AsqhR9YijSmZdTf5yC2XkYYWWFbweimamoEGui2N8zVtPwu8HQlIl6oX6
 16AtwxQIPCm0IrPx2W6BHLEJOwnnRQ4Xi+oxTnWCyINyEa5fbbUoVhjaom50a+yOKA0A
 7qLGKTTz5eMooPmo4owBQ66yUfdeNy9nq+KAnb0GS0Kb/Gdmk5UXvdRszu3xGdXA9s1K
 f4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=TMWiPpce5uJfh5LzsvNs4pu3d9Ouof0td3tYTU99XWs=;
 b=ftC5WfR3dYmbKYj/zlgxtbkh37Ggrng0miK4jGD+mi0dUnh/dOMeKZEG+97Ta4t0lD
 EwY5kUn+qqWBAQ4kj0tq/B3aep8xiv2MVWeERMOk7ZIb5GMvlcJE2wvnPHMwrA3kvUji
 97CIFyC1mE0dyX+jXqbBHpEyfIGHdtwhTGFU7h6AFXXhznRm1SASyAathX6oa5JrIiCK
 J9vTRmqVn4ranrgyv8d5uWU+WsajopyQ2z59f/C5ZSTw9pMlGtdVPRASeMaXeHC8Xbmu
 nT3yXgi+BWj3SDptyN4d3U/gaiHLpnAvIBzlHXwjKKsSPBcXZ4+r8piTtMtsUgSOZdn/
 uLSw==
X-Gm-Message-State: AOAM5319O1WOZbcrVA/evFgp2jMc+KCWimX40cYSeSq9oU5Gc27CmHTZ
 d656Z6BNARtDnlleHMiZww+8d6ykxS0QHhHlNQ6X6Q==
X-Google-Smtp-Source: ABdhPJwNbKfJfwy5ZfdKLw8GsZcf5H537Ft+zyRd4ak95P8c0qpFksGdD+XpYydsR28b0ysDQ/QKtSB9iVawGVPv9ko=
X-Received: by 2002:a05:6a00:2355:b0:4fa:9cae:b3c9 with SMTP id
 j21-20020a056a00235500b004fa9caeb3c9mr14907772pfj.82.1648015602442; Tue, 22
 Mar 2022 23:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-2-reijiw@google.com>
 <Yjl96UQ7lUovKBWD@google.com>
In-Reply-To: <Yjl96UQ7lUovKBWD@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Tue, 22 Mar 2022 23:06:26 -0700
Message-ID: <CAAeT=FzELqXZiWjZ9aRNqYRbX0zx6LdhETiZUS+CMvax2vLRQw@mail.gmail.com>
Subject: Re: [PATCH v6 01/25] KVM: arm64: Introduce a validation function for
 an ID register
To: Oliver Upton <oupton@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Oliver,

> On Thu, Mar 10, 2022 at 08:47:47PM -0800, Reiji Watanabe wrote:
> > Introduce arm64_check_features(), which does a basic validity checking
> > of an ID register value against the register's limit value, which is
> > generally the host's sanitized value.
> >
> > This function will be used by the following patches to check if an ID
> > register value that userspace tries to set for a guest can be supported
> > on the host.
> >
> > The validation is done using arm64_ftr_bits_kvm, which is created from
> > arm64_ftr_regs, with some entries overwritten by entries from
> > arm64_ftr_bits_kvm_override.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
>
> I have some concerns regarding the API between cpufeature and KVM that's
> being proposed here. It would appear that we are adding some of KVM's
> implementation details into the cpufeature code. In particular, I see
> that KVM's limitations on AA64DFR0 are being copied here.

I assume "KVM's limitation details" you meant is about
ftr_id_aa64dfr0_kvm.
Entries in arm64_ftr_bits_kvm_override shouldn't be added based
on KVM's implementation.  When cpufeature.c doesn't handle lower level
of (or fewer) features as the "safe" value for fields, the field should
be added to arm64_ftr_bits_kvm_override.  As PMUVER and DEBUGVER are not
treated as LOWER_SAFE, they were added in arm64_ftr_bits_kvm_override.
Having said that, although ftr_id_aa64dfr0 has PMUVER as signed field,
I didn't fix that in ftr_id_aa64dfr0_kvm, and the code abused that....
I should make PMUVER unsigned field, and fix cpufeature.c to validate
the field based on its special ID scheme for cleaner abstraction.
(And KVM should skip the cpufeature.c's PMUVER validation using
 id_reg_desc's ignore_mask and have KVM validate it locally based on
 the KVM's special requirement)


> Additionally, I think it would be preferable to expose this in a manner
> that does not require CONFIG_KVM guards in other parts of the kernel.
>
> WDYT about having KVM keep its set of feature overrides and otherwise
> rely on the kernel's feature tables? I messed around with the idea a
> bit until I could get something workable (attached). I only compile
> tested this :)

Thanks for the proposal!
But, providing the overrides to arm64_ftr_reg_valid() means that its
consumer knows implementation details of cpufeture.c (values of entries
in arm64_ftr_regs[]), which is a similar abstraction problem I want to
avoid (the default validation by cpufeature.c should be purely based on
ID schemes even with this option).

Another option that I considered earlier was having a full set of
arm64_ftr_bits in KVM for its validation. At the time, I thought
statically) having a full set of arm64_ftr_bits in KVM is not good in
terms of maintenance.  But, considering that again, since most of
fields are unsigned and lower safe fields, and KVM doesn't necessarily
have to statically have a full set of arm64_ftr_bits (can dynamically
generate during KVM's initialization), it may not be that bad.
So, I am thinking of exploring this option.

More specifically, changes in cpufeature.c from patch-1 will be below
and remove all other newly added codes from cpufeature.c.
(Need more changes in KVM)

---
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3357,9 +3357,9 @@ static const struct arm64_ftr_bits
*get_arm64_ftr_bits_kvm(u32 sys_id)
  * scheme, the function checks if values of the fields in @val are the same
  * as the ones in @limit.
  */
-int arm64_check_features_kvm(u32 sys_reg, u64 val, u64 limit)
+int arm64_check_features(u32 sys_reg, const struct arm64_ftr_bits *ftrp,
+                            u64 val, u64 limit)
 {
-       const struct arm64_ftr_bits *ftrp = get_arm64_ftr_bits_kvm(sys_reg);
        u64 exposed_mask = 0;

        if (!ftrp)
---

Thanks,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
