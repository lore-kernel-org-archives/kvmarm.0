Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19C1C4320E
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 10:22:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 49016610FE
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 10:22:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 49016610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C61BF4AC78;
	Wed,  4 Aug 2021 06:22:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4FtApmEqIh79; Wed,  4 Aug 2021 06:22:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDA2D4A500;
	Wed,  4 Aug 2021 06:22:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F5294A4E5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 06:22:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZI-7cnRh4bBb for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 06:22:39 -0400 (EDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com
 [209.85.167.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA8F44A4A4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 06:22:38 -0400 (EDT)
Received: by mail-lf1-f53.google.com with SMTP id z2so3629913lft.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 03:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=KeKqZfswV3Sb0AU8g0UPNhEdRtUw4ir+Xa9mBwdImhQ=;
 b=Sx8QK7m+vzLUPX7gwMaaMlpfLAgy9neplHDzBUyv9uNsaoqOSl1IYCGoAtYmWUIB0r
 mcpN8pzx3GClXZHioEL4F/x3ivqMmLOQ7BVi4CDxQ8EG3sz/yuttN1nBoQvpwG6tA6oP
 aB/xKpr90qG2ceJvP2f20MPyKWRYubGWo8oPlwRA7HJlUoao/JFWualIcemrFCxe6dU3
 BFXrUSR6d2YsnzwCBqVQWdcnBS/FmqxfR0Ogc0ZWjzgwooQfWsl5/ElVdtCBJ/UeXjFS
 hENab/eFfPPxqm1KmWzM3n2DzvGvp/36TlCZAkzJadr9O4rPeZKIitcswfL+VZz/xgi7
 wSfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=KeKqZfswV3Sb0AU8g0UPNhEdRtUw4ir+Xa9mBwdImhQ=;
 b=m4rYF/1k/ZF8ovlndPIQx2vrzh06NgoqoaKhHaeYPCWggd7eacZUPBBfmWOgybDaJm
 AIA9I1yRnV3vsMOISswISTQiABB8mK46zM8JnKM7yTZ8zKzYagVyIGPP2F/TNYmCXcMd
 0r0W/ktnrlsC1lC9IfzkiseJVh7Eosw6s4o+DRSLC+h6M2cquYURkroHQRXOyW5XN6kl
 k7oYmSa2+APmE6IOsHGjA7M3KmGxVf5gndO5p7XsWGEOf/DwRv6Bi38dSDHY+YtOPkKA
 FEUpZFkuuFdsyyGDFjq0t1BuC8lI4E44L1hQe/sAAFPt4oFFgqYlePENj4zIVEA329Ic
 B4oA==
X-Gm-Message-State: AOAM5335mnxV6W6duM6X9Jj7P1wMr1mOY4bgFnLSkoXGl3vLtfmhcJEz
 qqzcJ8AuiP7dUFg2/uuS+HvKfjpFHMIqkAOKSpVtpg==
X-Google-Smtp-Source: ABdhPJzB5JAVimicrB+LNM1WlhZujX7PYw4hx552TtO+zR1iDfLhqMpreHlla6ij7/LeLKw1/tY33IuZjyfFTZqjHcw=
X-Received: by 2002:ac2:57cd:: with SMTP id k13mr2429091lfo.117.1628072557209; 
 Wed, 04 Aug 2021 03:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-18-oupton@google.com>
 <20210804101743.bgkggw7a3wbx7woi@gator.home>
In-Reply-To: <20210804101743.bgkggw7a3wbx7woi@gator.home>
From: Oliver Upton <oupton@google.com>
Date: Wed, 4 Aug 2021 03:22:26 -0700
Message-ID: <CAOQ_Qsh9cQob1X=-39H4mMf7gYES5VnQP-t5C_R+HdRgk0WPeg@mail.gmail.com>
Subject: Re: [PATCH v6 17/21] KVM: arm64: Allow userspace to configure a
 guest's counter-timer offset
To: Andrew Jones <drjones@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

On Wed, Aug 4, 2021 at 3:17 AM Andrew Jones <drjones@redhat.com> wrote:
> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> > index a8815b09da3e..f15058612994 100644
> > --- a/arch/arm64/kvm/arch_timer.c
> > +++ b/arch/arm64/kvm/arch_timer.c
> > @@ -85,11 +85,15 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
> >  static u64 timer_get_offset(struct arch_timer_context *ctxt)
> >  {
> >       struct kvm_vcpu *vcpu = ctxt->vcpu;
> > +     struct arch_timer_cpu *timer = vcpu_timer(vcpu);
>
> This new timer variable doesn't appear to get used.

Ooops, this is stale. Thanks for catching that.

>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>

Thanks for the quick review!

--
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
