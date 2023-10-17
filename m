Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3342D044
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 16:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XyUaKJBU"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1c9c145bb5bso1605ad.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 09:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697561360; x=1698166160; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbOnMkAmys4ATC1jemLgDhyPYnDB7jZJzNIoSnmf3pM=;
        b=XyUaKJBUiRDoycjvnStgm9dheQYeFJIN7TH9dXqLObC7d/ELH+y66lvQeFxecYkDGs
         RBOIvFjqnujBaqUnCpS4ZEi395KQRyHQMC4KU58sGuMoNuesDn7irgictr8iNbt9ACtV
         1or9VmgH2FcKOuUM1l7tP0vztrLh1t29U7GTyeN7CaQI2BcmGqwaehmGrRb9LPn2ritV
         WvXe+v89N8XqvduXkoYfIG/RgGJ6Ec3KvyRhsLGarCFYHuTDNXMREMAoRJwZwOy1c4eE
         Li4ahxKQlFTPdA+LQPKSMqIaP5axeCfkMm306YpSSSuqAXhUljkQBzXwTM25Z8cbv1mJ
         0vPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697561360; x=1698166160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lbOnMkAmys4ATC1jemLgDhyPYnDB7jZJzNIoSnmf3pM=;
        b=YIDEwWzP90tVnDYAHgTwzWE3zQiVdOSti/rcToVb21ds+9sG/KDhjEVXtzgvDo7Gex
         jqvf7ix8eEOtxs8SmR7YemGGaw7DteFOncnJjgBuf92U5QTlkh/e4JMdjCXxwAQwzUO9
         5iimPvyOqT3WQOHmITnQ8ZczDNve/k0uMbh9PeqkomSRHuyNvF8S5j41Y9Y7K9/8R717
         bJdFGro4d+H31me7m9yWsa+2q+R5i5mj1Z/Fn0q/5kCDlbOVxaWTNiLMK3rs8PNG5KzY
         bBdBI5+7ofHKdIsOLT7MUWWurjqR4Mj+D0cBkTWfp29ngJMOhc8cTQjjvFU5FUCMwDor
         FcMw==
X-Gm-Message-State: AOJu0YyMTtg0fvuczu/+NshTj4Hs3MJqrElAILD3oTi0GJVJn1TP/e/4
	1udD3fy/7AICar4j0ZVhXQV0ZX6eXoTJy4EkDPDQ4g==
X-Google-Smtp-Source: AGHT+IHBs3xzGbOBxozI0mr9y6ZRlkWvaDBFuz2bQqZAf7GpLb7JfbwGUaiEHntwkG/81KgXoUiV2DoZ3Q51zSTkyZo=
X-Received: by 2002:a17:903:290:b0:1ca:16b8:b541 with SMTP id
 j16-20020a170903029000b001ca16b8b541mr2851plr.24.1697561359975; Tue, 17 Oct
 2023 09:49:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-9-rananta@google.com>
 <5d35c9f3-455e-6aa9-fd6a-4433cf70803a@redhat.com>
In-Reply-To: <5d35c9f3-455e-6aa9-fd6a-4433cf70803a@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 17 Oct 2023 09:49:07 -0700
Message-ID: <CAJHc60z7U1-irTy-6URb_V0PTW+TYS4qodf2akSg33_7CJgjyw@mail.gmail.com>
Subject: Re: [PATCH v7 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To: Sebastian Ott <sebott@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17, 2023 at 8:52=E2=80=AFAM Sebastian Ott <sebott@redhat.com> w=
rote:
>
> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
> > +                 u64 val)
> > +{
> > +     struct kvm *kvm =3D vcpu->kvm;
> > +     u64 new_n, mutable_mask;
> > +
> > +     mutex_lock(&kvm->arch.config_lock);
> > +
> > +     /*
> > +      * Make PMCR immutable once the VM has started running, but do
> > +      * not return an error (-EBUSY) to meet the existing expectations=
.
> > +      */
>
> Why should we mention which error we're _not_ returning?
>
Oh, it's not to break the existing userspace expectations. Before this
series, any 'write' from userspace was possible. Returning -EBUSY all
of a sudden might tamper with this expectation.

Thank you.
Raghavendra
>
> > +     if (kvm_vm_has_ran_once(vcpu->kvm)) {
> > +             mutex_unlock(&kvm->arch.config_lock);
> > +             return 0;
> > +     }
>
