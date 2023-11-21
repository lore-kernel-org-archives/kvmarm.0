Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCB07469
	for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 17:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Db909ZoJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700586072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v93FwVXoTzkwCTHloTDbAyzgq12DcyzYpNvU8V0mZJE=;
	b=Db909ZoJYbcT2G6LLjfnci8yQDj6GeiSOnWmAa8m+VFijTu30q9djImk6aFIkpMgVdtS+Z
	c236IoYSFo0aEGPv7aYu++U66M0qv/B5ysNWiKeSjLp9LM0SBhlioFeP1Qc6bg1nFu6Qit
	IQjR/wgf7I/405DltkwXG0Kbe5KyMSs=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-TMtES6H6Og-fxDIS-EDj9g-1; Tue, 21 Nov 2023 12:01:09 -0500
X-MC-Unique: TMtES6H6Og-fxDIS-EDj9g-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-581dc6915b5so6075028eaf.1
        for <kvmarm@lists.linux.dev>; Tue, 21 Nov 2023 09:01:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700586069; x=1701190869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v93FwVXoTzkwCTHloTDbAyzgq12DcyzYpNvU8V0mZJE=;
        b=TVwDQErhG0m25Sd/zedcOtAeuYvzN0N5gneFO2ojWKKNwILvGSGMddKm7on6bpACVB
         GOhn30awbMpfI2Autx+mW1bQXe6rIYlLB/hUrq9W31kU2dLPG2wcNVBVMem+3ZAmF7W1
         dv15B371Tzyud035HnFXUGljCeiWDs+3OtscYxeL/EBhK0ja+/uzsmR2CASGDAIajPXn
         MW0f/G3HduQ7CTqy0+Ngi+hqtU3/siYNet52SLh4cdORbHzbsTWBmifeRQ24x70SG/Bl
         VeqFC34ifbykpUJI1tUd6drlYl0OSEduniAdaewg4moCAhJZBmppSxAmNwxUFqVG38J3
         XZHg==
X-Gm-Message-State: AOJu0YyTyslZZHcd7dDbobmTzUf3XMdnShqwrSVcAh2uATfUYzvgif4r
	uX6psrnIEbYBY3ked+byuh/vZvvnI2ZK20T66lDW6X4jyCxYQtF7JmZSHyBH/4j/PAQhFONFaf7
	+Jz9RjRKH9db/a9SEDGl0VulobyWYPCQV
X-Received: by 2002:a05:6358:7e47:b0:169:a9d4:3faf with SMTP id p7-20020a0563587e4700b00169a9d43fafmr12581511rwm.11.1700586069072;
        Tue, 21 Nov 2023 09:01:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzwqwXTcQOMVq6+W/ToO1AFQnqdGCzNKV3DK3CezCKFyIOZTTVBddsfYxnVHAme/q2N84DW6rxhPtI5xPi31c=
X-Received: by 2002:a05:6358:7e47:b0:169:a9d4:3faf with SMTP id
 p7-20020a0563587e4700b00169a9d43fafmr12581454rwm.11.1700586068588; Tue, 21
 Nov 2023 09:01:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-35-pbonzini@redhat.com>
 <CAF7b7mpmuYLTY6OQfRRoOryfO-2e1ZumQ6SCQDHHPD5XFyhFTQ@mail.gmail.com> <13677ced-e464-4cdb-82ae-4236536e169c@sirena.org.uk>
In-Reply-To: <13677ced-e464-4cdb-82ae-4236536e169c@sirena.org.uk>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 21 Nov 2023 18:00:56 +0100
Message-ID: <CABgObfZdk9Jn60QLJGweVZMN_yWsxo1d7W3Mu-NNTPZVO0uCnw@mail.gmail.com>
Subject: Re: [PATCH 34/34] KVM: selftests: Add a memory region subtest to
 validate invalid flags
To: Mark Brown <broonie@kernel.org>
Cc: Anish Moorthy <amoorthy@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Xu Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	David Matlack <dmatlack@google.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 20, 2023 at 3:09=E2=80=AFPM Mark Brown <broonie@kernel.org> wro=
te:
>
> On Wed, Nov 08, 2023 at 05:08:01PM -0800, Anish Moorthy wrote:
> > Applying [1] and [2] reveals that this also breaks non-x86 builds- the
> > MEM_REGION_GPA/SLOT definitions are guarded behind an #ifdef
> > __x86_64__, while the usages introduced here aren't.
> >
> > Should
> >
> > On Sun, Nov 5, 2023 at 8:35=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.c=
om> wrote:
> > >
> > > +       test_invalid_memory_region_flags();
> >
> > be #ifdef'd, perhaps? I'm not quite sure what the intent is.
>
> This has been broken in -next for a week now, do we have any progress
> on a fix or should we just revert the patch?

Sorry, I was away last week. I have now posted a patch.

Paolo

