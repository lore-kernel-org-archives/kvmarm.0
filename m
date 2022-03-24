Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381BCC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Mar 2022 17:54:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DD134B119;
	Thu, 24 Mar 2022 13:54:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hqqGeLXCZpyF; Thu, 24 Mar 2022 13:54:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 498394B0E6;
	Thu, 24 Mar 2022 13:54:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2204F4B0D6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 13:54:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3zhsbRYwOwPM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2022 13:54:53 -0400 (EDT)
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com
 [209.85.166.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0CB7E49E44
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 13:54:52 -0400 (EDT)
Received: by mail-io1-f43.google.com with SMTP id d62so6243796iog.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2022 10:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=gpG1idH+Yq/AlWXjwzOnwn1kVIZQXLkaIHYX97/MawQ=;
 b=MYpAl0OQXl6DvwrVD7oy+bSQQqNg8SzP7VXOO84WaYazJhr9XS2f5kxDw24CAaifTr
 XYAEnoOIj46wwuvT0rRDJAfb1aoGKUamh9vzpKSzPEOEY+bJYsaPhBoaINOBXhEmOAiw
 KiedNaBLZ3jdwTBxaM/VKdEvZdBAryD3zg3fpOvnZ4cB81KKHHb+eJhpWqpsj7Hn7cjJ
 m1i4GTvG4gz6KPMJIEu7blaa1fXR1yDB7K4DH0wCvMfRckd60AUbHwP+/DWoye89eoQc
 I7I5cSKenjipPbDxDB1h2Jg2wbo79tKxwivIUKIr25hGbyxwtosPkudzXi5SCnSnMA6G
 evRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=gpG1idH+Yq/AlWXjwzOnwn1kVIZQXLkaIHYX97/MawQ=;
 b=4PJZH2Bz85jwhkr7jx9w/TVYzZgQJtAanQu7W03WK/xnp04Mg1JX1iKF9dUuP4X2/c
 cy3qIUYID21HxB3+SUl2cirlcpD8HLKJm9QhizxPYaDFs2y9d3HMArn/8+tGpFBDwU0S
 PXhSzWB8sGQXKwF0HxURx8Cec0I6yX7TTaS0jcSkzzzd3+8wJQ1ZpZ+G4HU7fzGHeBpC
 CTm1WFS3lbH1ZNOGW9LiSJBDgM5U4KYGwZ0QMJPErmVtQ30G/KOxtZl4kDbXQc58pe5D
 J/aFYCfc1zww3OlCSsgIr/C37gynAMsZXwWtOoGhva8uHEpQuagLywpVE4Gtlq1inW+W
 KIZg==
X-Gm-Message-State: AOAM533KAKWPaMCOafIgc5RHHe1z/KHyNWCKFhdSSb6Ii6C1WD+EkACa
 yr1KHk18LYSlJleg+FfbnBPyNw==
X-Google-Smtp-Source: ABdhPJzbnF79TQYRTFkOeaXA/rSl336nRsKoUTSPeMgbge7b88rutsAZOrGq0gv9kjT12x/P/sclOg==
X-Received: by 2002:a05:6638:2651:b0:321:64e1:ef44 with SMTP id
 n17-20020a056638265100b0032164e1ef44mr3392957jat.202.1648144492021; 
 Thu, 24 Mar 2022 10:54:52 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 i81-20020a6bb854000000b00649c1b67a6csm1740776iof.28.2022.03.24.10.54.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 10:54:51 -0700 (PDT)
Date: Thu, 24 Mar 2022 17:54:48 +0000
From: Oliver Upton <oupton@google.com>
To: Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v6 02/25] KVM: arm64: Save ID registers' sanitized value
 per guest
Message-ID: <YjywaFuHp8DL7Q9T@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-3-reijiw@google.com>
 <YjtzZI8Lw2uzjm90@google.com>
 <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8adf6145-085e-9868-b2f8-65dfbdb5d88f@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

Hi Reiji,

On Thu, Mar 24, 2022 at 09:23:10AM -0700, Reiji Watanabe wrote:

[...]

> > > + */
> > > +#define KVM_ARM_ID_REG_MAX_NUM	64
> > > +#define IDREG_IDX(id)		((sys_reg_CRm(id) << 3) | sys_reg_Op2(id))
> > > +
> > >   struct kvm_arch {
> > >   	struct kvm_s2_mmu mmu;
> > > @@ -137,6 +144,9 @@ struct kvm_arch {
> > >   	/* Memory Tagging Extension enabled for the guest */
> > >   	bool mte_enabled;
> > >   	bool ran_once;
> > > +
> > > +	/* ID registers for the guest. */
> > > +	u64 id_regs[KVM_ARM_ID_REG_MAX_NUM];
> > 
> > This is a decently large array. Should we embed it in kvm_arch or
> > allocate at init?
> 
> 
> What is the reason why you think you might want to allocate it at init ?

Well, its a 512 byte array of mostly cold data. We're probably
convinced that the guest is going to access these registers at most once
per vCPU at boot.

For the vCPU context at least, we only allocate space for registers we
actually care about (enum vcpu_sysreg). My impression of the feature
register ranges is that there are a lot of registers which are RAZ, so I
don't believe we need to make room for uninteresting values.

Additionally, struct kvm is visible to EL2 if running nVHE. I
don't believe hyp will ever need to look at these register values.

[...]

> > Which itself is dependent on whether KVM is going to sparsely or
> > verbosely define its feature filtering tables per the other thread. So
> > really only bother with this if that is the direction you're going.
> 
> Even just going through for ID register ranges, we should do the check
> to skip hidden/reserved ID registers (not to call read_sanitised_ftr_reg).
> 
> Yes, it's certainly possible to avoid walking the entire system register,
> and I will fix it.  The reason why I didn't care it so much was just
> because the code (walking the entire system register) will be removed by
> the following patches:)

Let me go through the series again and see how this flows. If there is a
way to avoid rewriting code introduced earlier in the series I would
suggest going that route.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
