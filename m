Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A02208CF
	for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 18:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KHl7teRk"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1cc1e1e74beso42095965ad.1
        for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 11:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698776653; x=1699381453; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fA4BSuC8POmGjMQJ0k8vnna5BPAxY9Ekm8SCU7EDDBY=;
        b=KHl7teRkrXxTRwQxqPqAd0/PXp3HEl/k1muE3aGQ+1lQLF+vfKXCa31LKf5iDISOIZ
         ctWGH+1eUbIQ0Y+zwJYo6aGJFAo+o9H35Z/U35qK2vbvINjwArPxljaIkkZ95KroWuIw
         aYLhxpDBO6b1y79JA22wKlpRVglGF5QHbc5unF5HZ/s7/I1cohnxIkvzkC2EgKktRL3o
         3ubsJ7VjkZwLDAzBP1hFLE/h5g+HFOvdSRwlh3jIq1OeGzWP/RTYH+gQj2HRjton+r7m
         HK0H82Jd4Ub6eJhtupCJtnvCFvmA853RGLi7GUqlBQeCrU09yn448rw/+hvsK3an3lUm
         LsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698776653; x=1699381453;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fA4BSuC8POmGjMQJ0k8vnna5BPAxY9Ekm8SCU7EDDBY=;
        b=xJwafjpY89arCIiUvV5AfZoeMb/JSDnW/kpU36a0VpK3Unfb4nH/V7z9r3jPgvDpyM
         Oi90MwUH0jTaiFB8unp0Iwel/jrLHAgPKjJLEC/EAnk0cOq71v5MCxO15TA0SMjroeOO
         KZv/on2AxTwG5XTcGgOPOL+Xul4xmceOL5APnkU9oWAMpriQgi31Duj15Hb4oR5fnSM3
         OV54Aw4oNIyW1EA/4ZucwwkfHL+9l93v4IrH2tAM4kdKsrvhdcdZwACX3wempjXNdUve
         2glIfVaXkhu8/ABCqXStOiTUFHccwsAqxas1a3cMXvv5fJscOW/1qcngQutoWoWIlCiN
         H+9A==
X-Gm-Message-State: AOJu0YyUk/jbfIUtLRIaw2h56O9vwg/fgkYkEEodMPzjAUUTK+NI2iLa
	y+Bb2DinbfX6Kp9lVJqqy+4EyQ==
X-Google-Smtp-Source: AGHT+IFxkiDdZGGfHsdazjXYZcfW0cI1Huw/6T3VggKB9s0vUh/sA7Jolgtag5oCOtU2pTLnT1L5FA==
X-Received: by 2002:a17:902:ecca:b0:1cc:54b5:b4fa with SMTP id a10-20020a170902ecca00b001cc54b5b4famr5681643plh.18.1698776652868;
        Tue, 31 Oct 2023 11:24:12 -0700 (PDT)
Received: from google.com (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c20d00b001c5dea67c26sm1620267pll.233.2023.10.31.11.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 11:24:11 -0700 (PDT)
Date: Tue, 31 Oct 2023 11:24:07 -0700
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	Anish Moorthy <amoorthy@google.com>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Vlastimil Babka <vbabka@suse.cz>,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Maciej Szmigiero <mail@maciej.szmigiero.name>,
	David Hildenbrand <david@redhat.com>,
	Quentin Perret <qperret@google.com>,
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>,
	Liam Merwick <liam.merwick@oracle.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v13 16/35] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
Message-ID: <ZUFGRyQEuWj4RJS0@google.com>
References: <20231027182217.3615211-1-seanjc@google.com>
 <20231027182217.3615211-17-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231027182217.3615211-17-seanjc@google.com>

On 2023-10-27 11:21 AM, Sean Christopherson wrote:
> Introduce an ioctl(), KVM_CREATE_GUEST_MEMFD, to allow creating file-based
> memory that is tied to a specific KVM virtual machine and whose primary
> purpose is to serve guest memory.
> 
> A guest-first memory subsystem allows for optimizations and enhancements
> that are kludgy or outright infeasible to implement/support in a generic
> memory subsystem.  With guest_memfd, guest protections and mapping sizes
> are fully decoupled from host userspace mappings.   E.g. KVM currently
> doesn't support mapping memory as writable in the guest without it also
> being writable in host userspace, as KVM's ABI uses VMA protections to
> define the allow guest protection.  Userspace can fudge this by
> establishing two mappings, a writable mapping for the guest and readable
> one for itself, but that’s suboptimal on multiple fronts.
> 
> Similarly, KVM currently requires the guest mapping size to be a strict
> subset of the host userspace mapping size, e.g. KVM doesn’t support
> creating a 1GiB guest mapping unless userspace also has a 1GiB guest
> mapping.  Decoupling the mappings sizes would allow userspace to precisely
> map only what is needed without impacting guest performance, e.g. to
> harden against unintentional accesses to guest memory.
> 
> Decoupling guest and userspace mappings may also allow for a cleaner
> alternative to high-granularity mappings for HugeTLB, which has reached a
> bit of an impasse and is unlikely to ever be merged.
> 
> A guest-first memory subsystem also provides clearer line of sight to
> things like a dedicated memory pool (for slice-of-hardware VMs) and
> elimination of "struct page" (for offload setups where userspace _never_
> needs to mmap() guest memory).

All of these use-cases involve using guest_memfd for shared pages, but
this entire series sets up KVM to only use guest_memfd for private
pages.

For example, the per-page attributes are a property of a KVM VM, not the
underlying guest_memfd. So that implies we will need separate
guest_memfds for private and shared pages. But a given memslot can have
a mix of private and shared pages. So that implies a memslot will need
to support 2 guest_memfds? But the UAPI only allows 1 and uses the HVA
for shared mappings.

My initial reaction after reading through this series is that the
per-page private/shared should be a property of the guest_memfd, not the
VM. Maybe it would even be cleaner in the long-run to make all memory
attributes a property of the guest_memfd. That way we can scope the
support to only guest_memfds and not have to worry about making per-page
attributes work with "legacy" HVA-based memslots.

Maybe can you sketch out how you see this proposal being extensible to
using guest_memfd for shared mappings?
