Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FBD4A12
	for <kvmarm@lists.linux.dev>; Sat, 23 Dec 2023 05:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LwAm0j3Z"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-35fb96f3404so10391175ab.2
        for <kvmarm@lists.linux.dev>; Fri, 22 Dec 2023 21:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703308735; x=1703913535; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XnwDpdbEms0r9ctWFykUHT4Fg9JnNMIjKFVXl1aMRgY=;
        b=LwAm0j3Z1e22zCtj4JnTYG2TeI6m62WdILjRxbg+oc3PFsz8ggrlwux3abbx9vRKrO
         jdtLGYjAkXRrF//YMJKruurBX7310JqUgDSc117Et1/kZ1ogMIE0GKdJzMFK2YOjDJag
         krBzRyoZDz22PtqHPq5sGGQPGVIzNAq5XhHhQx9524AwZUUCmI+MJ5ciI4KuIG/DtxPC
         A8Hpgdchoa3FSws8k6VMm29N6zS9QZ1ebYfzfQKXKWhTt/tsVHLsXOlROaE2H5X7tMJj
         cpW8EIyvpEzPk1VSwAilVoBrzpeFlaLn2Q5/i4zTkFIoH3hiwyrhaYkZPCpDML72I43P
         0CcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703308735; x=1703913535;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XnwDpdbEms0r9ctWFykUHT4Fg9JnNMIjKFVXl1aMRgY=;
        b=sKgWHS9wrzyKN4ZjIKMJ2gVQni8M1tfqJb8Mp64Bxcean/QMOa+occjQex15ZnGXdA
         rlg4zD3wwTtdkpMu/x0Ji+1+HcgJAHwjYQ6JMD07hRWJxEI76Jb0W2jR55bN8wYhe+UI
         /7vDsQqwWuldzm05udoBG9e3M3IlkjjLWHxT18j+G/phkAWo3SsNgu4wf7AHGps+WlN3
         8STvJIasN36SBalZeWG9v4klWKJkOUG8cTrBxNsd8Jl3yjQkJpOptN53q6Pv4ryBR/g9
         kcxUrRxEg6Jh8CH5hv2j8IkTa4Z5RB9PzDfvjuH8Dx/xQsfgCk+aw1YHR5lJ1q03Od+c
         eLFA==
X-Gm-Message-State: AOJu0YwvjU10RsFTb2Bxfg/Ef6TaDaXKa2Zj0kkckEEmKetnL+4YggSJ
	iKl+tgPIXU3Lt11ZD6h61o0=
X-Google-Smtp-Source: AGHT+IFaHzlucHRk+1cz9vp3pAi/3gV++IZOiVArAG66rH8YvEuO0wUOoZEKgYXgJDJX2cMfaNfq+A==
X-Received: by 2002:a05:6e02:1707:b0:35f:e71f:4c60 with SMTP id u7-20020a056e02170700b0035fe71f4c60mr2472288ill.13.1703308735520;
        Fri, 22 Dec 2023 21:18:55 -0800 (PST)
Received: from localhost ([203.220.145.68])
        by smtp.gmail.com with ESMTPSA id c6-20020a17090a020600b0028aed79c244sm3641553pjc.1.2023.12.22.21.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Dec 2023 21:18:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 23 Dec 2023 15:18:45 +1000
Message-Id: <CXVGJUAN6935.1L9WYI8NQ4R0O@wheely>
Cc: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>, "Laurent
 Vivier" <lvivier@redhat.com>, "Shaoqin Huang" <shahuang@redhat.com>,
 "Andrew Jones" <andrew.jones@linux.dev>, "Nico Boehr" <nrb@linux.ibm.com>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Alexandru Elisei"
 <alexandru.elisei@arm.com>, "Eric Auger" <eric.auger@redhat.com>, "Janosch
 Frank" <frankja@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
 <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH 1/9] s390x: clean lib/auxinfo.o
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>
X-Mailer: aerc 0.15.2
References: <20231222135048.1924672-1-npiggin@gmail.com>
 <20231222135048.1924672-2-npiggin@gmail.com>
 <20231222160414.5175ebba@p-imbrenda>
In-Reply-To: <20231222160414.5175ebba@p-imbrenda>

On Sat Dec 23, 2023 at 1:04 AM AEST, Claudio Imbrenda wrote:
> On Fri, 22 Dec 2023 23:50:40 +1000
> Nicholas Piggin <npiggin@gmail.com> wrote:
>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  s390x/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/s390x/Makefile b/s390x/Makefile
> > index f79fd009..95ef9533 100644
> > --- a/s390x/Makefile
> > +++ b/s390x/Makefile
> > @@ -227,7 +227,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-o=
ffsets)
> > =20
> > =20
> >  arch_clean: asm_offsets_clean
> > -	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*o=
bj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-=
key)
> > +	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*o=
bj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d lib/aux=
info.o $(comm-key)
>
> it seems other architectures don't need to do the cleanp? what are we
> doing wrong?

x86 does clean it via cflatobjs. arm and powerpc never build the .o
AFAIKS.

Thanks,
Nick
