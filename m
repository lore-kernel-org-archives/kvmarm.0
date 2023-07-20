Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC8718B07
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 15:14:50 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-cf4cb742715so776290276.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 08:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689866089; x=1690470889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jyO/GZcznauRS+IxFjefkQ411ageTxV8Pq4vykaVGvo=;
        b=zTnr2gXYIfqrhSL0WP50qLuqh3ZSH0gfVOnKmqwBvWYCge11/urc6Mcz48DQC5VeI6
         s/bgjrFlzBMXd0PxaHBdxoR2ZqKrVqjnkCnhcQbbSnTvJYQ3aBe8wGkYdi1iCIBydfGh
         kDBro1Ztm9Xs7cfFTvZ7Ey8Gxe05PCCIDn4nx9L+2nwHbFPbro9d3jap/zFGaLY9lF26
         GO0Vu5OUt+nUmBQOwJoSD8n40MC7ZQXlXpaj59Y1nIZxZy5/TzmEdTKZZXkcpmTSKYdO
         Y0fmzsgj8zCYsvUdMgpPWIv3Ur8RBp8NDUrrxEURomdLy8NcckIjCEtpSXTS4KS2mzFS
         29+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689866089; x=1690470889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jyO/GZcznauRS+IxFjefkQ411ageTxV8Pq4vykaVGvo=;
        b=Vj4CBtsZ/EVBbDNkrO2WOwgVjTWxwJ/lmeZWg3FrCVC2JRBmKie/UtHeKN1Nz6XGw/
         BuLDWrUKBCmHIxXfdLk6qt9Dqzg2dvKOy+70lRsbUino1D1ovg9nHXR7jUHW8DceFy6+
         i/dEkRfCHnPIVZsAZAMHkGioYi6kgTXkv7mcS6gVScaaV6wp12DsaGk+Av1W/FERSwji
         Mq2xyT95mp+fLM3hCvKuCcpEpynCj+qLK+yiW9qMm8HbDb9kRnnReAUZhDnRh6AMnWnc
         Pen+bicGwCmUp7u5eZa4GRUyVQu9LDMZMRqdxHmgkgt+6lRZaXhc2PITWyCMWcM5spEp
         3MHw==
X-Gm-Message-State: ABy/qLbXOAjcQw4m+4F9XpTzDuZyYgoKeFFq3XJHcYQucOGOmYIIVxLp
	5DpwDp8oJSmZx0SMNj5t8pBZC4tWUXw=
X-Google-Smtp-Source: APBJJlHgB47FmXfk0Rt+Hyu6ZgRaD/aSiXUWbAQerG5WzFKE3pY5cKaePpzhb9OPvUF/5F0XHeWF4GbW2oc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a105:0:b0:c65:8983:ac2 with SMTP id
 z5-20020a25a105000000b00c6589830ac2mr17912ybh.5.1689866089303; Thu, 20 Jul
 2023 08:14:49 -0700 (PDT)
Date: Thu, 20 Jul 2023 08:14:47 -0700
In-Reply-To: <83eb5c50-7287-7845-ffc3-a7c58e638ea5@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <20230718234512.1690985-13-seanjc@google.com>
 <83eb5c50-7287-7845-ffc3-a7c58e638ea5@intel.com>
Message-ID: <ZLlLx7wkE6iPTIcI@google.com>
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
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 20, 2023, Xiaoyao Li wrote:
> On 7/19/2023 7:44 AM, Sean Christopherson wrote:
> > @@ -5134,6 +5167,16 @@ static long kvm_vm_ioctl(struct file *filp,
> >   	case KVM_GET_STATS_FD:
> >   		r = kvm_vm_ioctl_get_stats_fd(kvm);
> >   		break;
> > +	case KVM_CREATE_GUEST_MEMFD: {
> > +		struct kvm_create_guest_memfd guest_memfd;
> > +
> > +		r = -EFAULT;
> > +		if (copy_from_user(&guest_memfd, argp, sizeof(guest_memfd)))
> > +			goto out;
> > +
> > +		r = kvm_gmem_create(kvm, &guest_memfd);
> > +		break;
> > +	}
> 
> Does it need a new CAP to indicate the support of guest_memfd?

Yeah, I meant to add that to the TODO list and forgot (obviously).

> This is patch series introduces 3 new CAPs and it seems any one of them can
> serve as the indicator of guest_memfd.
> 
> +#define KVM_CAP_USER_MEMORY2 230
> +#define KVM_CAP_MEMORY_ATTRIBUTES 231
> +#define KVM_CAP_VM_TYPES 232

The number of new caps being added is the main why I didn't just add another one.
On the other hand, we have room for a few billion caps, so one more isn't a big
deal.  So yeah, KVM_CAP_GUEST_MEMFD is probably the way to go.
