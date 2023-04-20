Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1A78F44
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 18:23:49 +0000 (UTC)
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-2f939bea9ebso764751f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 11:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682015028; x=1684607028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1945gIeyUKxf634eLSB+UhkKwLsC3xo7b0I4NgmBVls=;
        b=5F9+meUbuKL3RiauX8BCJVKDSb1T6kfNGhz96hh/fWuOztbgnQQ274N6eOQiUPlvqu
         5vW4YctMX5rfg1GtYuurir7iGQwXklNUvitEdJn93MDysY+CjCAnHxB6plosAcsrVyXX
         FNrxtIfL+jFS+aJmc32SEmBvr0RlpccNdVvR79DN6Jf4FB0qBvPPJRmCWBH64gKY5HOM
         an11cwhv2lE/SHJzENIjaI/qyajrLmdqRliywUAVbGbM43B5ZFwzO/PABTOzenTGaBC+
         x3fEW2zLn7Ncs2JdM+E5UzAQ6nOgQnLzAnML0gbMMtyoci0S+wCiiherXsvw473Nolfl
         AzKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682015028; x=1684607028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1945gIeyUKxf634eLSB+UhkKwLsC3xo7b0I4NgmBVls=;
        b=jhHHJdETTAkWxtDwmVFpW0gQn6DRMTvXGeLp/vE0qIaMyswu3Iwq3xtO79OMsUAkuM
         o1Vp+pm1lcJRYef/KdY0bsMtb2WkuXLclJUVNsDMSykJe8/2jQw+vjLH4wpti/Nhm7ne
         mS94/0/CMWd3MMEQRo3UU6Ukzn2FXMNzmiYjZuesdlESqJy78+swR7aN6y+FIPVZWpZz
         4gN6gQlMIS3VDiSClqIkiLttOQKvkEK3xBootV/SPGVgxoeY/mP+EPmdN2xwQBM1jyQ+
         XNIcXgmWiQpUXmcRUmhmWpSq0+/1KG3LdovqWtvQacuvYA1YToPzqd9P+i+bbkSoeUDK
         fgsA==
X-Gm-Message-State: AAQBX9e5Edtpxs+VtedXfKEWwiTDtByNMPGSxdVw2jDfb00+XAXiJDBv
	jUJE5XGHXmgxLZzMW84QcFrt4N6Crc2alZtPflk/3A==
X-Google-Smtp-Source: AKy350aS/frzXk0mzLXwkFJVv8/EWEWXdE3KEmqrhkdHEnMgBbMXKq4FyvdmjQvx8/jHNs93jMEptZxwXOvhqztKBcQ=
X-Received: by 2002:a5d:6585:0:b0:2f5:953a:4f59 with SMTP id
 q5-20020a5d6585000000b002f5953a4f59mr1948320wru.5.1682015027841; Thu, 20 Apr
 2023 11:23:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-18-amoorthy@google.com>
 <8d974125-163c-f61c-a988-5e5e6d762d73@gmail.com>
In-Reply-To: <8d974125-163c-f61c-a988-5e5e6d762d73@gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 20 Apr 2023 11:23:11 -0700
Message-ID: <CAF7b7mqqDzD0wXC__KfCdY66tz2pQaw4=xJ=g4ECgCosb+jHcg@mail.gmail.com>
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
To: Hoo Robert <robert.hoo.linux@gmail.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, jthoughton@google.com, bgardon@google.com, 
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 7:00=E2=80=AFAM Hoo Robert <robert.hoo.linux@gmail.=
com> wrote:
> > +static inline bool kvm_slot_fault_on_absent_mapping(
> > +                                                     const struct kvm_=
memory_slot *slot)
>
> Strange line break.

Fixed: there's now a single indent on the second line.

> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index f3be5aa49829a..7cd0ad94726df 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1525,6 +1525,9 @@ static int check_memory_region_flags(const struct=
 kvm_userspace_memory_region *m
> >       valid_flags |=3D KVM_MEM_READONLY;
>
> Is it better to also via kvm_vm_ioctl_check_extension() rather than
> #ifdef __KVM_HAVE_READONLY_MEM?

Probably, that's unrelated though so I won't change it here
