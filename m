Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D84D63CC
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 15:57:48 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-d81486a0382so4854692276.0
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 08:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695052667; x=1695657467; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=s17YssV/eLMk3v6BQw21PztJLVQ1uDSUDnGyHA0nJic=;
        b=o0IENACE1jMyAufmCVKBiAEdbDmM1r4DviWVQu4Eu6bkFp9TYvkMjgk9wNkS0CaPp3
         rWaXGi2S4TpPg1L7Xb5q0JMSGgbKNc6t3z0q7eWPoVz7/sjwv6ZLmjLfIaj4yUfkF5wB
         Ev7rnHwPyv9K8MSgjMB/CRZuGJiJXyfLp5O53CIr2HTa6JQ3kHEJaK+YlQH8ahuECzRW
         oHyrrIyxPa5IQTpKuXkoiDamm+WXePmlzT8NM0zeawetJsFROAKxjp0mDBrEMUXNlGxX
         gJ+TzCbNcDdPkaS8Gs5nV5KNALHTe1BH3O3zsVtigD8yySVHg8zpph6j+od8j7BcWiqY
         V2Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695052667; x=1695657467;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s17YssV/eLMk3v6BQw21PztJLVQ1uDSUDnGyHA0nJic=;
        b=VlNhOe8FhwxfKH4fXET2otuDSKSavm8HrUQ0It8ltP3PunmevUXsA4E3ztJXBqBznp
         +ohYsga+BI4GG490MKKxcyOGpMhJ2P7gH7L/pR1AfhyZfMg4PveVCGhYi/QcTWSYZjw1
         3wMFiqpW4QLGWuPTgVASQNOtGBQ6InpUJDlaUWePGR685q7kIr2UyVV9HmNGcymM46xs
         XEpLXPutoDexqJ+7S8T59dPA92Eq15ARfaXBhHEv6wVZ+/6cf7+pXh+BVybplVpuKJ7V
         OcTdyAxpmd3wyx6Mnkyd0CEkFTszcEJ5t6XakT8hWKxhubyPr+HvyNDtQd22cLCx1JvY
         SoWw==
X-Gm-Message-State: AOJu0Yw5iFjVQspxkuth9O+4LDS5btBpnYWTLUoZ+lHHwAeNON8JwdIJ
	xZTNaAxRc5QRfn5itpSw/bzkyr0Am8s=
X-Google-Smtp-Source: AGHT+IFqXVMaW5EWUR3sn7RRHAULv1S9Ax+JzluU+Y462jgw29bgpZAEkbL739S68Hx7QOlYkiFqSLcGAUw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4cf:b0:d7f:f3e:74ab with SMTP id
 v15-20020a05690204cf00b00d7f0f3e74abmr227961ybs.1.1695052667494; Mon, 18 Sep
 2023 08:57:47 -0700 (PDT)
Date: Mon, 18 Sep 2023 08:57:45 -0700
In-Reply-To: <9925e01b-7fa9-95e4-dc21-1d760ef9cde4@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-11-seanjc@google.com>
 <9925e01b-7fa9-95e4-dc21-1d760ef9cde4@linux.intel.com>
Message-ID: <ZQhzeQLbB5zz2yIc@google.com>
Subject: Re: [RFC PATCH v12 10/33] KVM: Set the stage for handling only shared
 mappings in mmu_notifier events
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xu Yilun <yilun.xu@intel.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 18, 2023, Binbin Wu wrote:
> 
> 
> On 9/14/2023 9:55 AM, Sean Christopherson wrote:
> > Add flags to "struct kvm_gfn_range" to let notifier events target only
> > shared and only private mappings, and write up the existing mmu_notifier
> > events to be shared-only (private memory is never associated with a
> > userspace virtual address, i.e. can't be reached via mmu_notifiers).
> > 
> > Add two flags so that KVM can handle the three possibilities (shared,
> > private, and shared+private) without needing something like a tri-state
> > enum.
> 
> How to understand the word "stage" in short log?

Sorry, it's an idiom[*] that essentially means "to prepare for".  I'll rephrase
the shortlog to be more straightforward (I have a bad habit of using idioms).

[*] https://dictionary.cambridge.org/us/dictionary/english/set-the-stage-for
