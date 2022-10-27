Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BC0ECAAA1
	for <kvmarm@archiver.kernel.org>; Thu, 27 Oct 2022 14:33:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E27E40403;
	Thu, 27 Oct 2022 10:33:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2qaTOKZl9IHK; Thu, 27 Oct 2022 10:33:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05A3940FAC;
	Thu, 27 Oct 2022 10:33:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 055F640403
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 10:33:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sMDsb07zyb4u for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 10:33:51 -0400 (EDT)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
 [209.85.214.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D13C6403FD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 10:33:51 -0400 (EDT)
Received: by mail-pl1-f176.google.com with SMTP id d24so1686082pls.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 07:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=Th99Ltq5Y+36xmE1RZslN/6kaqbAEVsh5tTv0CHqHJU=;
 b=U00KASOoVyFwkGzNuVjZIbcfYjgpQNKvJ9qD3BXMrLpJ8M8wRmi9yT6lVAhgv/4mCK
 dP9gGqlppty4UUs6nhNCR/2j7Gko8Lf1CP3D/YjeXy37CvPa247V3ElP08S9g/U4REWD
 m/ibmPpRwi4es0am/BRxRFhOuCeHipzpn1fJaBclk+NZOfyKAc2QM/H87fefX1/HGwrr
 mbvRYmY3cj//loRBtoGubO++hAtq5Y7iRWAU9goP/T4kuezMVc0rMzgzyZUJRmcAbYTA
 /j8naF1ZvyiJ51dCEz47bCsohr3u5ik8OYoY/2GNnH24iGE1RyXMbWmySK9p8ye57dwx
 H6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Th99Ltq5Y+36xmE1RZslN/6kaqbAEVsh5tTv0CHqHJU=;
 b=jBiIJZQtd2s6Bn0yqxASTE/epdwwUws/eCwlOF7nbqF3YC8OBRr6fpD302uE0vYEzA
 yQrzWP4mT5Y9SwH8lzCHQUiYEebslppPbX5/QL05h5VBbHLfOXYEuG3sLZ2qLrwbES5d
 0pDyhc6dMiJEhapeaankr+3EZHRFfoNS++Q7r7czwaIOGRd4WEVJkm+xQe9doVeGTKTe
 gVTQvPOJqdoolxUps0QwOHmVCdPvaA+8M/KI+ALZHK95+0mYtciLLYrmHyKAmOMvtdS+
 yeT1Q6UcoCkX59O3RID7yo72WoYuuUf7E6zmhHqtb/1haCQGoGqX7iSvPRNbBSsG1i5/
 gOaA==
X-Gm-Message-State: ACrzQf1Owtl1YqLDb6KlS5zJXGb52S9ddc9hIdHQUttPuKqXwpMuQL07
 xjYH818Qxgeur/1ElzGJYOpMh8EBbKlk+XTc+6hWVA==
X-Google-Smtp-Source: AMsMyM4g3mDCx8r1Ss9FlKEj96MfTjIFNxzlQZEF8JZ0DWlJRFbXfBXt/4+KSp7jq7K2syVC2z/f7J5F0w7tjl0HO7Q=
X-Received: by 2002:a17:902:9049:b0:180:7922:ce36 with SMTP id
 w9-20020a170902904900b001807922ce36mr51136823plz.30.1666881230636; Thu, 27
 Oct 2022 07:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-2-maz@kernel.org>
 <CAAeT=Fz55H09PWpmMu1sBkV=iUEHWezwhghJskaWAoqQsi2N0A@mail.gmail.com>
 <86zgdlms58.wl-maz@kernel.org>
In-Reply-To: <86zgdlms58.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Thu, 27 Oct 2022 07:33:34 -0700
Message-ID: <CAAeT=FzbYp58Yw6QXqD92w4UMG8x+O81i6hoC+_jeOEL0vFjGA@mail.gmail.com>
Subject: Re: [PATCH 1/9] KVM: arm64: PMU: Align chained counter implementation
 with architecture pseudocode
To: Marc Zyngier <maz@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, kvm@vger.kernel.org
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

Hi Marc,

> > > +static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
> > > +                                     unsigned long mask, u32 event)
> > > +{
> > > +       int i;
> > > +
> > > +       if (!kvm_vcpu_has_pmu(vcpu))
> > > +               return;
> > > +
> > > +       if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> > > +               return;
> > > +
> > > +       /* Weed out disabled counters */
> > > +       mask &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> > > +
> > > +       for_each_set_bit(i, &mask, ARMV8_PMU_CYCLE_IDX) {
> > > +               u64 type, reg;
> > > +
> > > +               /* Filter on event type */
> > > +               type = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
> > > +               type &= kvm_pmu_event_mask(vcpu->kvm);
> > > +               if (type != event)
> > > +                       continue;
> > > +
> > > +               /* Increment this counter */
> > > +               reg = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) + 1;
> > > +               reg = lower_32_bits(reg);
> > > +               __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = reg;
> > > +
> > > +               if (reg) /* No overflow? move on */
> > > +                       continue;
> > > +
> > > +               /* Mark overflow */
> > > +               __vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
> >
> > Perhaps it might be useful to create another helper that takes
> > care of just one counter (it would essentially do the code above
> > in the loop). The helper could be used (in addition to the above
> > loop) from the code below for the CHAIN event case and from
> > kvm_pmu_perf_overflow(). Then unnecessary execution of
> > for_each_set_bit() could be avoided for these two cases.
>
> I'm not sure it really helps. We would still need to check whether the
> counter is enabled, and we'd need to bring that into the helper
> instead of keeping it outside of the loop.

That's true. It seems that I overlooked that.
Although it appears checking with kvm_vcpu_has_pmu() is unnecessary
(redundant), the check with PMCR_EL0.E is necessary.

Thank you,
Reiji
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
