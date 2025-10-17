Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7202FDC38
	for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 22:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760740756; cv=none; b=MYbbmfzso3KfcdYlWY1MfwBhHEMilSZM5cnngJh3m65emyR/QivWPz1pZDMqzECTCVcupGCWSPEVDd0evBTpnUr3K2zJ7/TNJNLDAbFYdAd+MFghtyWWS9BHtBEwywVVzuGANsHfBdo37ED4eKS9/POe+fLOsqsCvmAzSd1WjhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760740756; c=relaxed/simple;
	bh=b9r/yE/BB1IF08a6BryFtLN5XeROQ9YihoNyBbj76Sw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RTjQJv7L9t/jz+q/6KFRYaq6XMWn5MhkFytPk3r+HVypb0fG2AxP7L4TlKthFZ3ygtDQZ3F0Alq8FSIK5CreatNqIza4/VrP19we+Y5I0YGowxTe74arIP5hXCpDFrZIsi0FYaqQvDgD6cpu4b4xqrTwM6bKG9WHIbRylcVMB4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3gAVpTZn; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3gAVpTZn"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-57da66e0dc9so2512788e87.0
        for <kvmarm@lists.linux.dev>; Fri, 17 Oct 2025 15:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760740753; x=1761345553; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoqzKQNFCddpnwTwWMxWSsHCHOracpeEvFEON9b+5D0=;
        b=3gAVpTZns62cdnwUE4CvONX6ECsusrOGQytzSSnTzCq2vy5+KTQoqrKTNmoEwYZE+6
         dx5/yXm1ck0PGA+CQMTPPJLrrYNdwnBSaLkCeyF+YBDc6xP1EVs6XPX/iDPQe6+qdnoD
         65YncjOVZa+bNN72DECFfrAIzBqFF41wFk04w1QOm5iQ+BcsZdq0XzEK4mnNhb/prnzz
         g/AxqiP0rywBmcwMr720bDJmPskEjKt6OUhDIE+s6x/ov3tulRpq4dbitjVFS7aETdb1
         gw+7Q8P1ufw1PvchdMzYa4u9LGlYMQVmAghk149CHgXDeLQemc86QMcvumFwAba6eRL8
         TZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760740753; x=1761345553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BoqzKQNFCddpnwTwWMxWSsHCHOracpeEvFEON9b+5D0=;
        b=Tr2xou7xfysbl4QCmDOjA8wpPDEmhPXvJLiUtbX+UKHg3Ohp6uOSSFieGkMLHYsz+e
         hb0sfLRyTHzp0SgXUrEWBqrEcLfcA62ASVzp6l4ftSfnOAB3XCTUtsgi+g8HUKuWrCNe
         OOFfvVJeeZRiCNfrXBjVgl7k8IJs3rPd/DqZri9O7nW8GKexOWc5LrGDfmsfL3bc9Pyj
         SjXO4CJSFqeYxt7AXEpbk6TII8nOP6ZWFlp+nZ6PLvLIQ2LZu4X21n/XFFfUvHKJ15WW
         xvqvqr3VXlfkYhcu4ArrBBhqw5XglasQG5JMNHmtcDt98ilzDK3IFmlCmk0XEQx52kmg
         Ovog==
X-Forwarded-Encrypted: i=1; AJvYcCUcqltbmzN8yChEELWOKAHdyh10zwdGPYGJceWeLn7ZPlwPd2c2vJheV1r8OPDoOhzaRXxX1W0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzY22mikCKyRkdECEy/CtSIgAUtAllh0c/HuJ2UqFRA6peakqt2
	lNQftWo08L0eAGXCLjZ9XclqiZI0byEyT0Iim2ICa44kxt8E8BP8JbFjN58OX1EDZKUABkfwc9T
	hLcXI4q7k6xd5npYJMzfle+bwMkVcNaIcf8hbarLL
X-Gm-Gg: ASbGnctiR/SxBnseU7K9zTJL/j70fFNCS5r8b7dcDoLDCSwojY6hTp1sTBdgb0SXnjH
	cTCLSYD+Sln2OLGt8edxMpMdamMUfLgnmwGp2j9G+85P25g3fAW/OdGMqvPTFtkLutPOEFOfylX
	BgKmKK5ivrodDnFHXXOxt/HwppWiFG52eE0WvVs+GfXoXNR5KCT9pis1IWDoa7bK/2WDNJ0DESZ
	gTxeS13A5Za4ZgjphpFZYm4OsH9vmZTDm+WBOfM9VMpH/90hhVF1jUxfCVjfA83vuADbDq8
X-Google-Smtp-Source: AGHT+IHS0n4/1zDhYDG11j/phEtQioVcSLIhzKZxyKRafka2oa60va2EzlIsG9E+0PXvk8E7U9fUvkCXKxOf+kRpoho=
X-Received: by 2002:a05:6512:131d:b0:590:6119:6b73 with SMTP id
 2adb3069b0e04-591d85aa092mr1710058e87.48.1760740752394; Fri, 17 Oct 2025
 15:39:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250501183304.2433192-1-dmatlack@google.com> <aBPhs39MJz-rt_Ob@google.com>
In-Reply-To: <aBPhs39MJz-rt_Ob@google.com>
From: David Matlack <dmatlack@google.com>
Date: Fri, 17 Oct 2025 15:38:45 -0700
X-Gm-Features: AS18NWAC2AsnIEyOuBJBf6AwyLhxj7CRd7TcYAURWBeq_wPcJYz0GvazO3M1Rc0
Message-ID: <CALzav=eqv0Fh9pzaBgjZ-fehwFbD4YscoLQz0=o0TKQT_zLTwQ@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: selftests: Convert to kernel-style types
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Eric Auger <eric.auger@redhat.com>, 
	James Houghton <jthoughton@google.com>, Colin Ian King <colin.i.king@gmail.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 1, 2025 at 2:03=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> On Thu, May 01, 2025, David Matlack wrote:
> > This series renames types across all KVM selftests to more align with
> > types used in the kernel:
> >
> >   vm_vaddr_t -> gva_t
> >   vm_paddr_t -> gpa_t
>
> 10000% on these.
>
> >   uint64_t -> u64
> >   uint32_t -> u32
> >   uint16_t -> u16
> >   uint8_t  -> u8
> >
> >   int64_t -> s64
> >   int32_t -> s32
> >   int16_t -> s16
> >   int8_t  -> s8
>
> I'm definitely in favor of these renames.  I thought I was the only one t=
hat
> tripped over the uintNN_t stuff; at this point, I've probably lost hours =
of my
> life trying to type those things out.

What should the next step be here? I'd be happy to spin a new version
whenever on whatever base commit you prefer.
