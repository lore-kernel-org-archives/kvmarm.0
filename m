Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05477F9E7
	for <kvmarm@lists.linux.dev>; Fri,  3 Nov 2023 23:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GbbjB2Oq"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5b31e000e97so36317827b3.1
        for <kvmarm@lists.linux.dev>; Fri, 03 Nov 2023 16:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699053445; x=1699658245; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wL2niLMenc8rXWamhCVdrH1GL3hMVyvGfUspx7X4DS0=;
        b=GbbjB2OqMSQ0n/lCTpDdY5BtncZxwuckpE/m/pEdm+n/MmANGJRkLiqC9ERMRgWr4t
         AflLSgP0Qkywl4M+SzeNaeYTrvh50u06wsqwifZhwnZ84rF0+vTJ/VS9mDGR5XT28QeN
         iWzJWg50mRoDjhNPYFIqiocY7yMXcS5rMrrGEH+6INBJX6UpJkYXlufCtxwHV7H895DA
         qDdbL5dnFZqvXBohZF/G6UljSzA1oNuLqZ7kJTZELOtslpM2o3cOdnGNPmTIvfRdAcMW
         uSsswPBbAcVL2r8rpE4yP6dp+HChkaaHrQ7Mq1ZVOCzhd8Wd7n272Z8qVisom1m+wlQl
         nGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699053445; x=1699658245;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wL2niLMenc8rXWamhCVdrH1GL3hMVyvGfUspx7X4DS0=;
        b=bjs1oEVV8Way0y4DkqKkFHumrXkR1wW4aIc/oi00Zfzy/8h+0s2X96JT4PSPyXaGnX
         Ss30GE6wxNDJ0YqjfCdh4l42ELB2ntpKHG9/v+o0D2vDf03P3bLKv5pTMS3pbFJU1yZ9
         cYSve1ckQI+eMkBHLeGnEjfs3lJ/21/Z1ACvDBGLVpk4ZFejFXWth8nTHBZv/J9JrfEn
         tJ/xswnCfUHl8DHWhJVOO7SiOnPefPxoen1BCXY3beE9YVYJUnIySAEXrzWSC4iK4dvp
         he99ERUzXKWd6HenTScGorYEGvfH3juZriZIi8uCPB3UAd9S2///iyRLV0FLPG8dpT0D
         rIsQ==
X-Gm-Message-State: AOJu0YxhSZG1i1qC+FkMoH/Gd/jeW1ww10SysTr4HpeuDqbL1TbsN5Ib
	ex2NZ71RcZIcpcJ17q7aefRky9GuqMc=
X-Google-Smtp-Source: AGHT+IGJDyi83TwJx+I35GsLQytKZmA4RJCyClEGAPsqdhhOEgS+Lm1oHaoRVNSHVuwQA3+7WVp40Ul4xUY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4958:0:b0:59f:3cde:b33a with SMTP id
 w85-20020a814958000000b0059f3cdeb33amr84737ywa.6.1699053444944; Fri, 03 Nov
 2023 16:17:24 -0700 (PDT)
Date: Fri, 3 Nov 2023 16:17:23 -0700
In-Reply-To: <CA+EHjTzGzXnfXHh0m5iHt9m3BxerkUS56EVPDA_az6n2FRnk3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-17-seanjc@google.com>
 <CA+EHjTzj4drYKONVOLP19DYpJ4O8kSXcFzw2AKier1QdcFKx_Q@mail.gmail.com>
 <ZUF8A5KpwpA6IKUH@google.com> <CA+EHjTwTT9cFzYTtwT43nLJS01Sgt0NqzUgKAnfo2fiV3tEvXg@mail.gmail.com>
 <ZULJYg5cf1UrNq3e@google.com> <CA+EHjTzGzXnfXHh0m5iHt9m3BxerkUS56EVPDA_az6n2FRnk3w@mail.gmail.com>
Message-ID: <ZUV_g1_3pj62OgF-@google.com>
Subject: Re: [PATCH v13 16/35] KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for
 guest-specific backing memory
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
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
	Jarkko Sakkinen <jarkko@kernel.org>, Anish Moorthy <amoorthy@google.com>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Maciej Szmigiero <mail@maciej.szmigiero.name>, David Hildenbrand <david@redhat.com>, 
	Quentin Perret <qperret@google.com>, Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 02, 2023, Fuad Tabba wrote:
> On Wed, Nov 1, 2023 at 9:55=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > E.g. a misbehaving userspace could prematurely delete a memslot.  And t=
he more
> > fun example is intrahost migration, where the plan is to allow pointing=
 multiple
> > guest_memfd files at a single guest_memfd inode:
> > https://lore.kernel.org/all/cover.1691446946.git.ackerleytng@google.com
> >
> > There was a lot of discussion for this, but it's scattered all over the=
 place.
> > The TL;DR is is that the inode will represent physical memory, and a fi=
le will
> > represent a given "struct kvm" instance's view of that memory.  And so =
the memory
> > isn't reclaimed until the inode is truncated/punched.
> >
> > I _think_ this reflects the most recent plan from the guest_memfd side:
> > https://lore.kernel.org/all/1233d749211c08d51f9ca5d427938d47f008af1f.16=
89893403.git.isaku.yamahata@intel.com

Doh, sitting in my TODO folder...

https://lore.kernel.org/all/20231016115028.996656-1-michael.roth@amd.com

> Thanks for pointing that out. I think this might be the way to go.
> I'll have a closer look at this and see how to get it to work with
> pKVM.
