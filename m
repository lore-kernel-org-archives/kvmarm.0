Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F5F3E120F
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 17:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731614; cv=pass; b=YGfnmzWziqoqg6chwBq1HvW4ReITpW1ChJuSh5f4QP885EUksvRxm/MnmUMA9buil3EYWHk0WHZREKGztjYUQbxZ+4NN+8NXDZjyk6CTARNcKcxNzVf7aoxhGLu5Yvb+JSqix/yOfOuy3hcZu/PpoLEbdMlZ3in50W+PiRdWcns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731614; c=relaxed/simple;
	bh=XOVsdktOF6nyNimRfFhPjPXph4/eizuY/zAJWFeEW6o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pTIizKZK0WeRGTtCOkkfMvYcbpvDxx4hVpv1uIPNOxfqZKXAJFoum2DxhLBhRmYRrT163SWXVVo/Af7qKghUK85bDC3Z/U0dH1oMsUY7L3Rq+SaQx92HyzHTH7S7+0ukSCPK+xZjXhGf8zNf/HlJRU5BAy8mCcDxcZkA5WUPSa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1sFg6rVr; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1sFg6rVr"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-59e4a04f059so2677007e87.2
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 09:26:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772731611; cv=none;
        d=google.com; s=arc-20240605;
        b=e3V2An2clGEKcpOPjNJE8xVPJsdUY+F1GN5qPYH8yTbH/m8zNE26j6nUR8wKCuJc+T
         u0wKk7y1rjJQV3t2tVhea6cnESO6Oubm3uldTWPe6QGH5ULpRMrJ65FptqnCmWNPZvMs
         gIlSjZ1x2TWGhq1JGk/il1gK3Kcx8A1L+sB4cIUbXjLv58QdvRTJjWAHhomfP9DVgZZ+
         JztST/eswtBNXW6uEICJ3Doa7asAd8q2yoef/BsCmMs/kpvBhhrsNAoEQMay+gD0uoNB
         3IWWtYXpAJP0J2ROrXeMfB3/IrHlJve5NfZHn8jILFrIN3Z5/AmGh1qz4uBNIP3VngPC
         ORog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6jfkQGEN2Pma+dwki2mI0eTQpR2nMlH81M8JJrATtW4=;
        fh=nuxjztxEMR81PqZ/zuTM5Ipl3HI1MiSjszbNOc31oDw=;
        b=Nvz7SnehTZQxbpUB1ui447az5dhnQp2Tjzx1xSaaok36lhZBMSXcTE++Z/3zmtI7D8
         E2P8sglmJtrkeai7VnzTLvRJphWQzROpmCnInMcaXNUVxRXmYVVigQeMts5BYAjntip/
         6pbEyg/WqCYGL3iqlSxp7zfVoYi7TGn4UtZRMgShF0M0lYN3OopehQz2d+Eahnb063R1
         bBv/glGMNXlrMeJQPnjy/ST+Kqs4jh8m/oXw5cSRfgdhnZrWSYiTsNHT3ZLOONmHhz+h
         t9ezMBEs5TAzaBHaakHANV8gTe3orLKdjbtWG1u+Otarh+TlcqG9DABXWnHgZCdtcjGB
         90QQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772731611; x=1773336411; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jfkQGEN2Pma+dwki2mI0eTQpR2nMlH81M8JJrATtW4=;
        b=1sFg6rVr610kMpiCOyxBF5yQC4uz7Pw5dCsfWirB5URLASZ4E5xoUGkTl/EIQXGsq/
         tvnh9T033QauoXrfG7YmUJ0thDtITHTkJ6oEqhS/nvf60kaEm89zOTXfPDE6CT+v2hiS
         kA/lCXtO/t2N5am0oQf+XT5GJEeAA8E+DIw/1RflRrEr/jPmm9O92TlGnynEe95pX8+W
         lXqhuPoi9C344Ezo6V84uBCsqZHQlNwnMtpX15HAKtXC+GncUSSzWIwZQUXaJXku5Qii
         ViaOjLO9RVxiLAKNPSqGCXXuWvkONBbbEaEtveEgH6gpD5xYbH0LxEGvd5Ce/e1hWjB3
         zepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772731611; x=1773336411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6jfkQGEN2Pma+dwki2mI0eTQpR2nMlH81M8JJrATtW4=;
        b=j7bp2LIJ1S9zcrPZMyRh/9waw5KNAX1vfAbBdmAqVCDtAvZvV12XZkuMBZWcIqmhDe
         dpRc3fT2l0vjAz37n5phAmFiMNJAHgHGx8ExOTovNKQRR+YAfHP6CQr4a2WyWrO/ky0B
         Lr40pwfLUKqs8MTdxsXNuidcLfJu63ZCZ/fAgxlWKr/4UvqZf4b47GOtqeJlVIyxk5cS
         5uUZ/uhxllDL4gBB5Av3VPmp0TyPOsTf2EQ5V0+ELnBAsOrAKQzW2iHmz+BMS9/VSlUm
         OfE3p6UEepJksghd4c7Qoui3WGeKgI53NfL8w6ekiV6MTGjGLvTepSRchexT5akQCILR
         mW0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWtcAImFFVA3df7ZRTbsyE1ab+4UInoCIPVogR++G/77cC0ONXR9PX4IGtbrxDNCEJwrrc0cbo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxYgBqROtRNW6Hf2QIg29dPPkiIC+IyAqcwBTMyaA+MXnomiGy
	Pgz551SBCsxe3SGDYGooX7btIeVqjiAKNldEIa8Z87CxaH23CkgbNc6d1CxM8C/u9bl3KYrEty9
	7ePia5kTzofjKcmiy5ZwJ7+PSTd3vNUkDoaleBeTu
X-Gm-Gg: ATEYQzzDbd3v+QTQcJdbeEnUTImrCYFHrea880H73EcNAONSlThwHBgDKbVVOM1u9UY
	vMJ6u/Tws+L3V/lfYKkhbFhTqQTjYdJt5g+RkIZbv2EEuFklvMaNhNRQBwq9usDsLWB5D3IFxvV
	r/qhDSi+oq+naGEoar+Iz3tadKRhCgnVJWzBZYl/fcVtEk73dADLkAueNrKg+sPc+DROr+3ZuUC
	0+w6vN0Ijbs5wPy5ZYn3UnUkVuRMAbC1PaUIAZB5yVsiRcUXSU0DvNjUAgfHDhan+oC4maXxgtL
	H0ztCFfB
X-Received: by 2002:a05:6512:696:b0:5a1:2f18:5e19 with SMTP id
 2adb3069b0e04-5a12f185e8bmr1324271e87.22.1772731610293; Thu, 05 Mar 2026
 09:26:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com> <aam77t8fe5RKSr2Q@google.com>
In-Reply-To: <aam77t8fe5RKSr2Q@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 5 Mar 2026 09:26:22 -0800
X-Gm-Features: AaiRm52LsX1aPJ2JM5xqUBPHr_QH0uBSIJaRMA7nyUfm3apWkfHV7m2i8095U3w
Message-ID: <CALzav=etzo9A7FNQrbLCmj=pNLN5fO-a5isP1k6MuTDkJw1bqQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/10] KVM: selftests: Use kernel-style integer and
 g[vp]a_t types
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ackerley Tng <ackerleytng@google.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrew Jones <ajones@ventanamicro.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, Bibo Mao <maobibo@loongson.cn>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Colin Ian King <colin.i.king@gmail.com>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org, 
	Lisa Wang <wyihan@google.com>, loongarch@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Nutty Liu <nutty.liu@hotmail.com>, 
	Oliver Upton <oupton@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Pratik R. Sampat" <prsampat@amd.com>, Rahul Kumar <rk0006818@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Wu Fei <wu.fei9@sanechips.com.cn>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 5, 2026 at 9:22=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Feb 20, 2026, David Matlack wrote:
> > This series renames types across all KVM selftests to more align with
> > types used in the kernel:
> >
> >   vm_vaddr_t -> gva_t
> >   vm_paddr_t -> gpa_t
> >
> >   uint64_t -> u64
> >   uint32_t -> u32
> >   uint16_t -> u16
> >   uint8_t  -> u8
> >
> >   int64_t -> s64
> >   int32_t -> s32
> >   int16_t -> s16
> >   int8_t  -> s8
> >
> > The goal of this series is to make the KVM selftests code more concise
> > (the new type names are shorter) and more similar to the kernel, since
> > selftests are developed by kernel developers.
> >
> > v2:
> >  - Reapply the series on top of kvm/queue
> >
> > v1: https://lore.kernel.org/kvm/20250501183304.2433192-1-dmatlack@googl=
e.com
>
> Sorry, I was too slow and missed the window to get this into kvm/next wit=
hout
> causing a disaster of merge conflicts.
>
> I don't think you need to send a v3 though.  I'll prep a v3, a branch, an=
d send
> Paolo a pull request during the next merge window.

Sounds good, thanks Sean.
