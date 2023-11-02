Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76361CF86
	for <kvmarm@lists.linux.dev>; Thu,  2 Nov 2023 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xB11KmQf"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4084e49a5e5so10012335e9.3
        for <kvmarm@lists.linux.dev>; Thu, 02 Nov 2023 09:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698942533; x=1699547333; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=20owt2l3/cxGLzLA2xbevoL+xSQuNASMB596X3+ow7c=;
        b=xB11KmQfFQmpdeEk4hqf9avUVJ/5S6ctHqu6YSO/vnsLLCdyUyJay2UrMV28u7PytH
         1veyRwl8IHbt5WV4awh2c8DJrM45JerWbkqKcAGFlxxUxfAJTqQQsH5vMGmK2r/sZoOz
         pYQxCs5EaidRa5IBiJyBalojjOWNR07ARTMlXdSSeCr45Z9ZeXKXGwp/Zmy8PC/C7ohz
         wAcT4CvuNmt1RvhGC32WolxeAHlRcjzn0qip02UxRuWWmdtQ7VKOq1H+b5AdhYYRi6d1
         E9KzFmCNZeii7rg6hrJWkMKmYWdPXcp1UzlFgMpnjBws/f9DNI7RVN+ec+xwtZrCHtSM
         FByw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698942533; x=1699547333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=20owt2l3/cxGLzLA2xbevoL+xSQuNASMB596X3+ow7c=;
        b=sDvaJAgD9dC22huIrcpLt6AObZx3NS8hjQBtr5yUq2NZ3bI6kbHPVDbdWccyOjkliX
         /EZEfU3Xj+CpnSzFvARA4gr5OIUMTBEsiI1Mkmk3NPoXi68Jp6hDQKfAWw0sscuyWt/z
         geW5od8L70w/uxzdXfxtdZwfQ+woab0re3Sm0JRBhxOfwKKPf1H+ShV0oc+bxSOM2h8k
         lixgA7ARL4B/FNwFpVRFTfF89/xzqHfge/wQwOhWKMYWVFyfE07kBcCAbjek1iGuWz5F
         mW/nT8hrVXSQjvz32yYYSe4RIpPRyb/jJxw+Tg6xtC9mnCZQD97H2p4uT4MAX2PURRhH
         Nybw==
X-Gm-Message-State: AOJu0YwliMemEzSq2yp3CKSsW3HzZdjGdWxSBeh+TTpWl875VfzRvJrS
	iItDzmJZ2GSIEFgo8bm1BQHj6KaWfasjtfOW/VkGqA==
X-Google-Smtp-Source: AGHT+IGzC+UPQWsYSxEKly7WToGYHThIxdsAXI0NVkPIoloyom3O4LGBjzNagfuu2dI4j91jKOVPOWF7c1N4gZ20sPc=
X-Received: by 2002:a5d:4b51:0:b0:32d:8e54:29f6 with SMTP id
 w17-20020a5d4b51000000b0032d8e5429f6mr14415276wrs.47.1698942532901; Thu, 02
 Nov 2023 09:28:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-17-seanjc@google.com>
 <ZUFGRyQEuWj4RJS0@google.com> <ZUFzZf-YmCRYP6qo@google.com>
 <CALzav=d9eXZfK=op7A=UftbpuPpUbxqV6CmkqqxxBNuNsUU4nw@mail.gmail.com>
 <6642c379-1023-4716-904f-4bbf076744c2@redhat.com> <ZUPIXt1XzZrriswG@google.com>
In-Reply-To: <ZUPIXt1XzZrriswG@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 2 Nov 2023 09:28:23 -0700
Message-ID: <CALzav=eaVc5rzmHwnQr7aotyTKi9Agdte7NAL0NvBeE+f6zYoA@mail.gmail.com>
Subject: Re: [PATCH v13 16/35] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Anish Moorthy <amoorthy@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 2, 2023 at 9:03=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Nov 02, 2023, Paolo Bonzini wrote:
> > On 10/31/23 23:39, David Matlack wrote:
> > > > > Maybe can you sketch out how you see this proposal being extensib=
le to
> > > > > using guest_memfd for shared mappings?
> > > > For in-place conversions, e.g. pKVM, no additional guest_memfd is n=
eeded.  What's
> > > > missing there is the ability to (safely) mmap() guest_memfd, e.g. K=
VM needs to
> > > > ensure there are no outstanding references when converting back to =
private.
> > > >
> > > > For TDX/SNP, assuming we don't find a performant and robust way to =
do in-place
> > > > conversions, a second fd+offset pair would be needed.
> > > Is there a way to support non-in-place conversions within a single gu=
est_memfd?
> >
> > For TDX/SNP, you could have a hook from KVM_SET_MEMORY_ATTRIBUTES to gu=
est
> > memory.  The hook would invalidate now-private parts if they have a VMA=
,
> > causing a SIGSEGV/EFAULT if the host touches them.
> >
> > It would forbid mappings from multiple gfns to a single offset of the
> > guest_memfd, because then the shared vs. private attribute would be tie=
d to
> > the offset.  This should not be a problem; for example, in the case of =
SNP,
> > the RMP already requires a single mapping from host physical address to
> > guest physical address.
>
> I don't see how this can work.  It's not a M:1 scenario (where M is multi=
ple gfns),
> it's a 1:N scenario (wheren N is multiple offsets).  The *gfn* doesn't ch=
ange on
> a conversion, what needs to change to do non-in-place conversion is the p=
fn, which
> is effectively the guest_memfd+offset pair.
>
> So yes, we *could* support non-in-place conversions within a single guest=
_memfd,
> but it would require a second offset,

Why can't KVM free the existing page at guest_memfd+offset and
allocate a new one when doing non-in-place conversions?

> at which point it makes sense to add a
> second file descriptor as well.  Userspace could still use a single guest=
_memfd
> instance, i.e. pass in the same file descriptor but different offsets.
