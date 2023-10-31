Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CA9273C2
	for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 22:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tLEvmLsh"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-32deb2809daso3919618f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 31 Oct 2023 15:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698792013; x=1699396813; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJWbuo+9TPVToDVPf96jeRxWUliwPBKXtZxQViTwJnU=;
        b=tLEvmLshDPHthgVrGIW1NzBEHFEB1LtAxwDTNX5dAoWsaXelswFwfg/oO3NG9jrgwS
         MIwJ5ZAFDG0N/P7lhwv7MmeC4TEjNLNR+FZrlC7zFTrbQs0lgpX+L1vAyuICysTJyCna
         5LFI0M2NjC9ES1Z8GjJ+hF3asa1Q0qz0ITmo4AwUDZDqn32V9Q5rU9IikMvVeqKgNHwU
         BNyiB3kJsa2N6jM7VHpYblWgbE0pt82hrve9gX8PzAB+r2mmPkWjFBX6XE/Anr7KysAl
         7tpKHu9yRqf1qoEQSkPzZB71niziT8I9qmXdNoXKIUnSVqQJ2MWHiHY8eX58/IlQv88G
         pkFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698792013; x=1699396813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJWbuo+9TPVToDVPf96jeRxWUliwPBKXtZxQViTwJnU=;
        b=LjoMw70OZfzHdLzZAISmnk6vmshbviXIwLYtvX2nnDvr7dmH5+4q8cQRTSXw0sZVr/
         OxF8MH1Zp7/qJVoptYrwLsBV8D4goXvLe+ljgeqGFhXiVq3nmsMJUAltmPQapOxgCJFj
         n0oex1YnrII3bTjEH16sxlnneKYiDBZ0fJOnvhJjsJhKd5zZt92EqBwcak0v/lKsWFhn
         sam6A5GTSwlbkvdAHIps0ZAMTcSvBu2IygXxYJA+AqndIJgdyuH7Nx/TQRutsuoZBUgA
         jibI7m+Nvf8U5IWG2DTDktt1K1Ixa+VNqwYmJm+qCUxvSN/YUJ8qykuFHD23ZGY05vbH
         EonQ==
X-Gm-Message-State: AOJu0YzqAv/gufGzg/pjAGdQVykE5dtaVj4goA6I9HDr6bH1Hg0wQFNY
	H4umC3xx/QBCb3YS7PvDYnyj9FMcxahPy/UJWooO5A==
X-Google-Smtp-Source: AGHT+IHkDiPkYLUipg1BNgD620eOceDAkQD+A32NnZclx+AVnVsN45AUMqsjx/qUof6Oj5kTmFWO4hEnjV9b1jDP2pc=
X-Received: by 2002:adf:d1ef:0:b0:32f:7db1:22fb with SMTP id
 g15-20020adfd1ef000000b0032f7db122fbmr8716023wrd.28.1698792012937; Tue, 31
 Oct 2023 15:40:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231027182217.3615211-1-seanjc@google.com> <20231027182217.3615211-17-seanjc@google.com>
 <ZUFGRyQEuWj4RJS0@google.com> <ZUFzZf-YmCRYP6qo@google.com>
In-Reply-To: <ZUFzZf-YmCRYP6qo@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 31 Oct 2023 15:39:42 -0700
Message-ID: <CALzav=d9eXZfK=op7A=UftbpuPpUbxqV6CmkqqxxBNuNsUU4nw@mail.gmail.com>
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

On Tue, Oct 31, 2023 at 2:36=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> On Tue, Oct 31, 2023, David Matlack wrote:
> > On 2023-10-27 11:21 AM, Sean Christopherson wrote:
> > > Introduce an ioctl(), KVM_CREATE_GUEST_MEMFD, to allow creating file-=
based
> > > memory that is tied to a specific KVM virtual machine and whose prima=
ry
> > > purpose is to serve guest memory.
>
> > Maybe can you sketch out how you see this proposal being extensible to
> > using guest_memfd for shared mappings?
>
> For in-place conversions, e.g. pKVM, no additional guest_memfd is needed.=
  What's
> missing there is the ability to (safely) mmap() guest_memfd, e.g. KVM nee=
ds to
> ensure there are no outstanding references when converting back to privat=
e.
>
> For TDX/SNP, assuming we don't find a performant and robust way to do in-=
place
> conversions, a second fd+offset pair would be needed.

Is there a way to support non-in-place conversions within a single guest_me=
mfd?
