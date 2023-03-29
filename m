Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997942F30
	for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 16:26:31 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id l184so512931pgd.11
        for <kvmarm@lists.linux.dev>; Wed, 29 Mar 2023 09:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680107191;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xVyDMyZSpGCQ7MxCl/Op2Md4aBGMLAhdohsoe3DXYiw=;
        b=UwJSnq+CIN6vt1rJP+cxGSL8i84zh2WehYJsz5WddGu7tY0iZ9MWigqVu/UoA4Vg5C
         iHksoMOtr3avNPXC2tkZWY+uaKmYR2u7zk7pRDdUn+dr8yEQsGAw/O5g/OXrj5BQcodi
         P29XKfzbTlOzcp5sOURe0GBCEtm32s/mFD+cLkFf+K0X5Ak+aZqXTq+tuB26YgT5to+Z
         7+J8zOmODTQnmf0Y1TUUYr4bGm3SgGJ6yJzeHAfVWVuEHpBcUXYBIVceJsV4dQL9tznI
         jgY4ZlqyVOqhSKJpZ7B/CZ5fTnRv5TOLwSA1L2oNeHvBuKjvPa5Y7cDZ1nvBDh2NnyFu
         vpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680107191;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xVyDMyZSpGCQ7MxCl/Op2Md4aBGMLAhdohsoe3DXYiw=;
        b=MRXWiii5nPbiqpWg0fNhn8ctamuquA8R59Vis3aYAZ1F+wxr+deLuy7BUwdCA+tWnu
         TDAtLhkisyek2OJzUX6yr3ejZIe/dBiEwKFzo03juiaZu77+0ek4jfdNaoL0ubCRyAaE
         UNNdX9Sw7Xd6kCCynjqp6MkgpEYRrjkItef+eHvXhxAwh8eFzE+ucv4EEarRcQCYEPoD
         Grj8guAXKIdnYm2c1GLT5cWGO/ZDoc1vWDsBVjMd/fnz3AabTE1fGiUl7JzdOEWOYQhi
         h2FM9kFcSMsyGZmYZ3m0kWWEb9m9zHe9tlWkosuSbix5jGNmTrv/DnyjvGQ1Q179sK8I
         V8cQ==
X-Gm-Message-State: AAQBX9c54E78DZk10lkUdhTbMcUsT5IB6MdwcQb/Zd3pKAbHaY/NXRxz
	ReD7ZWsHkylpyKn7CCgGfScULCW2lV7K9oEafs6y3w==
X-Google-Smtp-Source: AKy350YvipsUiNBJuE6YBTyMPuwRu2a0VFb8e6m8DUE6BW/xhC9hc8gC85jEyUX2V5MoAyWcDuJKSLxWs+vAwycyHb0=
X-Received: by 2002:a05:6a00:99d:b0:5e6:f9a1:e224 with SMTP id
 u29-20020a056a00099d00b005e6f9a1e224mr10564721pfg.6.1680107190606; Wed, 29
 Mar 2023 09:26:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
 <20230317050637.766317-3-jingzhangos@google.com> <861qlaxzyw.wl-maz@kernel.org>
 <CAAdAUtjp1tdyadjtU0RrdsRq-D3518G8eqP_coYNJ1vFEvrz2Q@mail.gmail.com>
In-Reply-To: <CAAdAUtjp1tdyadjtU0RrdsRq-D3518G8eqP_coYNJ1vFEvrz2Q@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 29 Mar 2023 09:26:13 -0700
Message-ID: <CAAeT=FyJyip9NOhTjdh169+9jE_eP3uEHMTszEQa7VfUY9MS1Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] KVM: arm64: Save ID registers' sanitized value per guest
To: Jing Zhang <jingzhangos@google.com>
Cc: Marc Zyngier <maz@kernel.org>, KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

> > > +/*
> > > + * Set the guest's ID registers that are defined in id_reg_descs[]
> > > + * with ID_SANITISED() to the host's sanitized value.
> > > + */
> > > +void kvm_arm_set_default_id_regs(struct kvm *kvm)
> > > +{
> > > +     int i;
> > > +     u32 id;
> > > +     u64 val;
> > > +
> > > +     for (i = 0; i < ARRAY_SIZE(id_reg_descs); i++) {
> > > +             id = reg_to_encoding(&id_reg_descs[i]);
> > > +             if (WARN_ON_ONCE(!is_id_reg(id)))
> > > +                     /* Shouldn't happen */
> > > +                     continue;
> > > +
> > > +             if (id_reg_descs[i].visibility == raz_visibility)
> > > +                     /* Hidden or reserved ID register */
> > > +                     continue;
> >
> > Relying on function pointer comparison is really fragile. If I wrap
> > raz_visibility() in another function, this won't catch it. It also
> > doesn't bode well with your 'inline' definition of this function.
> >
> > More importantly, why do we care about checking for visibility at all?
> > We can happily populate the array and rely on the runtime visibility.
> Right. I'll remove this checking.

Without the check, calling read_sanitised_ftr_reg() for some hidden
ID registers will show a warning as some of them are not in
arm64_ftr_regs[] (e.g. reserved ones). This checking is needed
temporarily to avoid the warning (the check is removed in the following
patches of this series).  It would be much less fragile to call the
visibility function instead, but I don't think this is a also good way
to check the availability of the sanitized values for ID registers
either. I didn't found a good (proper) way to check that without
making changes in cpufeature.c, and I'm not sure if it is worth it
for this temporary purpose.

Thank you,
Reiji




> >
> > > +
> > > +             val = read_sanitised_ftr_reg(id);
> > > +             kvm->arch.id_regs[IDREG_IDX(id)] = val;
> > > +     }
> > > +}
> >
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
>
> Thanks,
> Jing
