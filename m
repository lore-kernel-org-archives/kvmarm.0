Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45D81B915
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 17:14:44 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-256e1d87998so851876a91.3
        for <kvmarm@lists.linux.dev>; Fri, 09 Jun 2023 10:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686330884; x=1688922884;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Sw7MOr+3hnVEmOQlDXydslwjILda+scHccINsHsaSw=;
        b=mG/nfttSkrdk7C0BSGSr7wCIQeMKSTBtKlye3RaAwU6LncIf6g/898kAUadZsiYvF7
         BhTF29dwuQ9nNl9vinDfD92+2MgGWOMm7zttIDy8YxDe517xcUNSl9DbkE4YxRbiys1I
         vOYHP+nVUrqKBaa2aPywvEWu0FyQvbZhbE7QHT5g1EobVzI/sj1wj7VExGmDGxFtQDBf
         r3nX/MjBQCZcP2edeA8njFSfACzGQFpjVct+LoAeQbQAcAKExT4YrtXGwvAhUva8nvSv
         NLLyCR0+eOSaxca/4wbZz3ndCR4g5TyLJZ6qgp+WfQ/+IRy4eqNpUIhAymSDJAjJweMY
         o+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686330884; x=1688922884;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8Sw7MOr+3hnVEmOQlDXydslwjILda+scHccINsHsaSw=;
        b=JJeIEjqazpuoeD2dkA7XMRyJ1weqn/rPdSANql4Fk9bTYRp1vvR6zJIPGjaouz8qqi
         CI++dsCdC3wioqNYiJS9g1ENyYY3JqiX1t9Lkl25nkvT3m9IQUYKSuh5yVMkPSV2MmMa
         5nJdDtBE0sRxMCH5mid+v4b9Y2W3opClmjX10z+1njXel97s5xfVsQfFknIiYCpWk6Kt
         qJ3aNpjSoHAPkhKcNT49BHShOOq52FIf4WtreZqXkeL3t8xOwawV8EblHrSwBM9z+UNs
         bYUTJ0+szMHyVXnQ9Ygi/bnqHm7dBl672TZPRiziuwHU2z5luF5ATP4cFVHIL2WnyHMk
         XEVg==
X-Gm-Message-State: AC+VfDyk5MPq6Nw6euObk2UvbViBkoceqgB9cwUd76LlTeN0T5V/IYWT
	8oLNPNfrqjN0PZqCyU3aoaE=
X-Google-Smtp-Source: ACHHUZ6LD2YKs6nr9I9wxjQHET90p4R47jYGk6zWEjv3TEEgWiIuKzmmbCdSsqb0wBL8oiyQndc+cQ==
X-Received: by 2002:a17:90a:7104:b0:255:d878:704a with SMTP id h4-20020a17090a710400b00255d878704amr1861381pjk.4.1686330883399;
        Fri, 09 Jun 2023 10:14:43 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id b16-20020a17090a551000b0024e026444b6sm6779121pji.2.2023.06.09.10.14.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2023 10:14:42 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH v6 28/32] arm64: Add support for efi in
 Makefile
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230609-2c01e3ece17d5c6b3005ee4e@orel>
Date: Fri, 9 Jun 2023 10:14:31 -0700
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>,
 kvm@vger.kernel.org,
 kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>,
 alexandru.elisei@arm.com,
 ricarkol@google.com,
 shahuang@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <E89A8FE9-E27D-422B-84FE-1F69AD3C239C@gmail.com>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-29-nikos.nikoleris@arm.com>
 <197A5432-65EA-49A7-AD6D-1AFCB58D30D0@gmail.com>
 <20230609-2c01e3ece17d5c6b3005ee4e@orel>
To: Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)



> On Jun 9, 2023, at 12:36 AM, Andrew Jones <andrew.jones@linux.dev> =
wrote:
>=20
> On Thu, Jun 08, 2023 at 01:41:58PM -0700, Nadav Amit wrote:
> ...
>>> +%.efi: %.so
>>> + $(call arch_elf_check, $^)
>>> + $(OBJCOPY) \
>>> + -j .text -j .sdata -j .data -j .dynamic -j .dynsym \
>>> + -j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
>>> + -j .reloc \
>>> + -O binary $^ $@
>>=20
>> I really appreciate your work Nikos, and I might be late since I see =
Drew
>> already applied it to his queue.
>=20
> It's not too late. arm/queue isn't stable so we can apply fixes while =
it
> bakes there.
>=20
>> So consider this email, my previous one, and
>> others that might follow more as grievances that can easily be =
addressed later.
>>=20
>> So: It would=E2=80=99ve been nice to keep the symbols and debug =
information in a
>> separate file. Something like:
>>=20
>> diff --git a/arm/Makefile.common b/arm/Makefile.common
>> index d60cf8c..f904702 100644
>> --- a/arm/Makefile.common
>> +++ b/arm/Makefile.common
>> @@ -69,7 +69,7 @@ FLATLIBS =3D $(libcflat) $(LIBFDT_archive) =
$(libeabi)
>> ifeq ($(CONFIG_EFI),y)
>> %.so: EFI_LDFLAGS +=3D -defsym=3DEFI_SUBSYSTEM=3D0xa --no-undefined
>> %.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds =
$(cstart.o)
>> -       $(CC) $(CFLAGS) -c -o $(@:.so=3D.aux.o) =
$(SRCDIR)/lib/auxinfo.c \
>> +       $(CC) $(CFLAGS) -c -g -o $(@:.so=3D.aux.o) =
$(SRCDIR)/lib/auxinfo.c \
>>                -DPROGNAME=3D\"$(@:.so=3D.efi)\" =
-DAUXFLAGS=3D$(AUXFLAGS)
>>        $(LD) $(EFI_LDFLAGS) -o $@ -T =
$(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
>>                $(filter %.o, $^) $(FLATLIBS) $(@:.so=3D.aux.o) \
>> @@ -78,6 +78,9 @@ ifeq ($(CONFIG_EFI),y)
>>   %.efi: %.so
>>        $(call arch_elf_check, $^)
>> +       $(OBJCOPY) --only-keep-debug $^ $@.debug
>> +       $(OBJCOPY) --strip-debug $^
>> +       $(OBJCOPY) --add-gnu-debuglink=3D$@.debug $^
>>        $(OBJCOPY) \
>>                -j .text -j .sdata -j .data -j .dynamic -j .dynsym \
>>                -j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j =
.rela* \
>=20
> This is nice, but I think it can wait and be posted later.
>=20

Sure thing. Thanks. I still got few problems I need to finish resolving,
and some other minor improvements, so I will post them all later.


