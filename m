Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889A31A58A
	for <kvmarm@lists.linux.dev>; Mon,  6 Nov 2023 11:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D7hVC0+O"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-66d0760cd20so36241206d6.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Nov 2023 03:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699271123; x=1699875923; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A3+w7KiTzzQhCpJeg/0ek2R61CW1ssLM/7mTLxlOjqg=;
        b=D7hVC0+OLb2hqIq24x2F6H8ocH7GcaHEGeQaWtu3nrNDCVJJgFSvp06zXv93wieUB6
         uV3RIvGsPtW67T+lIzp7e3MSIaS96zXq2yisx3O1dAsMHV110gfSR3+w5qxqINkwt5lb
         fYX/toBIN9K/nhSpZUG5R9cvtvNZ62X4+A/cOBPPdfeu9ajerfopmVEX9Ak71FC+Zthq
         uOtVBwZSrQefIDggg4t1ywunzyXtb3UnX89pe+vm+MIuvzD20yDC4z6XNXutxxKlqZS3
         LxumlfOsoAdA4x3NLUg11DHDG971bbuZJ438inBuTrgbRa1OStOqRhf3c4Kvyxa08TgK
         Ncjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699271123; x=1699875923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A3+w7KiTzzQhCpJeg/0ek2R61CW1ssLM/7mTLxlOjqg=;
        b=Et/BIxoGoRZ+TR8R7sHIvz8kVvXmNkWPvu0OicCnwzwajnx0pnMDxhy4196U0rPssi
         i5ZxA27lE9U+9QbV/J1PX+6EN8LSKdXgmT6QvquT3rM6NBUYfgD0cjBVsRgoMGAysyLO
         X/gf2wl3joEeON6He1CSoa3sIvie9VczTegSWaeDMRhClzugt2hbU8+A9c6DSKrDFtgy
         TOQ3gBJi/qF59iK3pe4n0ok2VCF03DEP+IGh7QAQR//bh18Eg8A2oWXeeofTF8Mk2rTm
         mit7onz0Tg9ej5EJGmeBCeQAbFf4w8usABSMtyopCE+1iINYgMsAj749VHOQQB9AU7Ep
         JX1A==
X-Gm-Message-State: AOJu0Yy9LnVlVIWY4WMy8+lzR0RGK2YzQCUXbjiqQYfepHKqxCuI9U1k
	RfGAyGRx7K5pEQcy0KcuZbsFGayzjZKF9Jdq7kE4gA==
X-Google-Smtp-Source: AGHT+IEl8/TeQ8yyhv97l+6UdWpd06zPBShx21QRSHFWAyL7jvCOyQqirpZN3XS/gBNGYYwpqQ32Yp/yP3xLHN3ZnjE=
X-Received: by 2002:a05:6214:252f:b0:66d:13c2:1c31 with SMTP id
 gg15-20020a056214252f00b0066d13c21c31mr13196146qvb.24.1699271123298; Mon, 06
 Nov 2023 03:45:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231105163040.14904-1-pbonzini@redhat.com> <20231105163040.14904-29-pbonzini@redhat.com>
In-Reply-To: <20231105163040.14904-29-pbonzini@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 6 Nov 2023 11:44:47 +0000
Message-ID: <CA+EHjTyxH9JNL67Kz0y90CjrP_HMhmePav7qukJvMOcJrk81pg@mail.gmail.com>
Subject: Re: [PATCH 28/34] KVM: selftests: Add GUEST_SYNC[1-6] macros for
 synchronizing more data
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
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
	Isaku Yamahata <isaku.yamahata@intel.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>, 
	David Hildenbrand <david@redhat.com>, Quentin Perret <qperret@google.com>, 
	Michael Roth <michael.roth@amd.com>, Wang <wei.w.wang@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 5, 2023 at 4:34=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> From: Sean Christopherson <seanjc@google.com>
>
> Add GUEST_SYNC[1-6]() so that tests can pass the maximum amount of
> information supported via ucall(), without needing to resort to shared
> memory.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20231027182217.3615211-31-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

>  tools/testing/selftests/kvm/include/ucall_common.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/t=
esting/selftests/kvm/include/ucall_common.h
> index ce33d306c2cb..0fb472a5a058 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -52,6 +52,17 @@ int ucall_nr_pages_required(uint64_t page_size);
>  #define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4) \
>                                 ucall(UCALL_SYNC, 6, "hello", stage, arg1=
, arg2, arg3, arg4)
>  #define GUEST_SYNC(stage)      ucall(UCALL_SYNC, 2, "hello", stage)
> +#define GUEST_SYNC1(arg0)      ucall(UCALL_SYNC, 1, arg0)
> +#define GUEST_SYNC2(arg0, arg1)        ucall(UCALL_SYNC, 2, arg0, arg1)
> +#define GUEST_SYNC3(arg0, arg1, arg2) \
> +                               ucall(UCALL_SYNC, 3, arg0, arg1, arg2)
> +#define GUEST_SYNC4(arg0, arg1, arg2, arg3) \
> +                               ucall(UCALL_SYNC, 4, arg0, arg1, arg2, ar=
g3)
> +#define GUEST_SYNC5(arg0, arg1, arg2, arg3, arg4) \
> +                               ucall(UCALL_SYNC, 5, arg0, arg1, arg2, ar=
g3, arg4)
> +#define GUEST_SYNC6(arg0, arg1, arg2, arg3, arg4, arg5) \
> +                               ucall(UCALL_SYNC, 6, arg0, arg1, arg2, ar=
g3, arg4, arg5)
> +
>  #define GUEST_PRINTF(_fmt, _args...) ucall_fmt(UCALL_PRINTF, _fmt, ##_ar=
gs)
>  #define GUEST_DONE()           ucall(UCALL_DONE, 0)
>
> --
> 2.39.1
>
>
