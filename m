Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CBC27F00
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 17:43:00 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c8f360a07a2so2020444276.2
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 10:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689961380; x=1690566180;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7DBmD+NWofmGocm5Vnh+WkykM6ONviwwjpnheMJOIK8=;
        b=Kleh8QpsTsNUhesVcFKaorRemH2b7oCPrjs/EZvvDbSIhnU646cwazqZifDUNyxi+Q
         5JqV9CUAW8QaG2YIfQCin1qnHve1MgXICSxbyDPLV8MjQRP2Kpasi9pL5sbB8O7UYjBa
         jgRp3U3UDnkkD6e19TR7wMGjHPVEilwKuPvhlll1BPS6C8DVpWehyFU2WczctGneBM1v
         8h/JnmhFLy8tlfXVq6NzVrFmSK26MkEiOaRidvtVK6eqi9qhd/VP0gDfCAxADqhE52gi
         5Uc2vJ9HkSFyp91F1M5r9W96Us+3KtG0sWvhTTO0jFsQ1GbEx81tOU6Kjmmi3SIi/0Fk
         yy7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689961380; x=1690566180;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7DBmD+NWofmGocm5Vnh+WkykM6ONviwwjpnheMJOIK8=;
        b=j7nnhVvAwV2ocLBtXnIjxF2TdpGP0v2gcPuSEKDHBz9lVvLyBruwZMgEIFIlBILolX
         aag9I8NlPvk3WnHVamkM/2fSs46TO+6VflU8jYmI4Ym4RplOSd2mKQorykIQSY7FpPT4
         yXNp4XelHm2KVbh9CdtE/KSLGrYaa05qNWEIDhOA/wTliaatwDR3w9ZI76CBOIiER0ZU
         Fc3YcmdCnXYcJYC1sqrHe+o3UeGoaVsvPOejs4JYy+f5/OS4WGWUln8t3PUQrLteB5Eg
         lecwIwYZUxNwmeIJ09fonTzanY1fL6kQ3PBBohlRg8a4HzP2TLZun83DDw+/jCDA4NY1
         HsNw==
X-Gm-Message-State: ABy/qLYV5zlrXYTWXJ8QuegCq6zP66Y4yFTqdDYBWVlMl0/P/sM0ZqRB
	N5AbpCDQX0MdvAlWEaNka09gtqkf8C8=
X-Google-Smtp-Source: APBJJlE/aF1pYHHKoAMy1+E4aY5+aL4FeQDb+p2ML0zhZVvr/Ah+OV80Lx1tRjSoeSb0qOhWhlHbRbztBVY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10cd:b0:c1c:df23:44ee with SMTP id
 w13-20020a05690210cd00b00c1cdf2344eemr19665ybu.0.1689961379855; Fri, 21 Jul
 2023 10:42:59 -0700 (PDT)
Date: Fri, 21 Jul 2023 10:42:58 -0700
In-Reply-To: <29baac45-7736-a28c-3b2d-2a6e45171b8b@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-13-seanjc@google.com>
 <fdc155f5-041b-a1b1-15aa-8f970180a13a@intel.com> <29baac45-7736-a28c-3b2d-2a6e45171b8b@intel.com>
Message-ID: <ZLrDopLH+3vN8rE6@google.com>
Subject: Re: [RFC PATCH v11 12/29] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, Vlastimil Babka <vbabka@suse.cz>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 21, 2023, Xiaoyao Li wrote:
> On 7/21/2023 11:05 PM, Xiaoyao Li wrote:
> > On 7/19/2023 7:44 AM, Sean Christopherson wrote:
> > > @@ -6255,12 +6298,17 @@ int kvm_init(unsigned vcpu_size, unsigned
> > > vcpu_align, struct module *module)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (r)
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_async=
_pf;
> > > +=C2=A0=C2=A0=C2=A0 r =3D kvm_gmem_init();
> > > +=C2=A0=C2=A0=C2=A0 if (r)
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_gmem;
> > > +
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_chardev_ops.owner =3D module;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_preempt_ops.sched_in =3D kvm_sched=
_in;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_preempt_ops.sched_out =3D kvm_sche=
d_out;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_init_debug();
> > > +=C2=A0=C2=A0=C2=A0 kvm_gmem_init();
> >=20
> > why kvm_gmem_init() needs to be called again? by mistake?
>=20
> I'm sure it's a mistake.

Yeah, definitely a bug.

> I'm testing the gmem QEMU with this series. SW_PROTECTED_VM gets stuck in=
 a
> loop in early OVMF code due to two shared page of OVMF get zapped and
> re-mapped infinitely. Removing the second call of kvm_gmem_init() can sol=
ve
> the issue, though I'm not sure about the reason.

Not worth investigating unless you want to satiate your curiosity :-)
