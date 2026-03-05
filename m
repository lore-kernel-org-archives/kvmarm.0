Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AB83AE703
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 17:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772731648; cv=pass; b=Uo8tpOu+1Hn07Ts2ViY8vujx6rGQbk3E6TOmIknfCbAoL5BeTjxf7Ux9FpjwJDJRp6JNZuC0dTe4DsXRHOIG4UH2tWKSsVoBDKw9x/SCJ2mD34YAS2ph6sJRHlaUbwaEL8SRzQVSldEoHWv8SlEdYVVxgHHi/RS/83kgkuVwUTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772731648; c=relaxed/simple;
	bh=9xcoW1uuOqJuCGhLK0+3X+GsY8ZmUZ0iw8x7VjTHzj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=po7dnPOYQUDl24TJsKT+Te8DGJjbfhjDIlO5d++PGCs/b8uvd+omkMd8eGrPQnd50dO0Y6LqzTaNZh7nmj3EexG9WO+tYY3pbD5VqNgMna3F0YpWsFgGkPIvwBWEbYa4FFEFe175idjs0BVqkPLSWC8Lx3ggICspKYoK/XXitFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FgGSxSio; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FgGSxSio"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-3870df2331aso69217991fa.1
        for <kvmarm@lists.linux.dev>; Thu, 05 Mar 2026 09:27:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772731646; cv=none;
        d=google.com; s=arc-20240605;
        b=eLwbLVXWHP6qCyt58vEmtLdz1ndk50pjgpiczL58OMxNt1FmcDWADTuOnQdCkXHZpE
         UwIVyvNfzvMwm3sJZT0J5vD2oQC6ebroQ7sfK4Ft4tiCFg98O8EKSEjgon/hbjpmPAcY
         LJNw1A7Jp+Iunjnxs7ZqpUYotc5ljt6thFWxMtT4GlfVTccD1pBvoDRF8d5PXngoBtVA
         DsS+sX/J9DwN/nA/ZDA5cSoLGkcGj8H72laxZtiJ+NKxRlthEnOs7B5DsgXW+FE+FBx0
         Md4lLi3kVkB9kV9AcaUJR/WD9BD8BqIT4p+Or5VwaVfSarO32O4rdd+qeEPMR11CYoCA
         ji7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9xcoW1uuOqJuCGhLK0+3X+GsY8ZmUZ0iw8x7VjTHzj4=;
        fh=zIGJ8VzhJZ6j13NsWgQlo2Qk+juCwhy0xpCP9yyJElQ=;
        b=I7mYeNUBjFF0FJSsuRb0NH1A4aMcSyHb0bT7aSHzGrSwPVUxHn3uCSjA/cIj8v9M5L
         FveIDIyy9RmBkMU3ZLetarpm18z9raHzf84jncsaTCzsaBnWAwisyGpu2jkGTANVSsgf
         D+PCv46c7EJSt/YJqKHeyknUQIFdUZsQK3raGb12IGeX+C6YUxexzmKWBRU+cNAGqOYv
         r7SQPKb54dzviJoh272daOftZn7K6oSM0v4d5VTRFc49a0F6U7jENLVKoh7o2yT7Nesl
         R5OziWuL+KERcbGmIdjd8So98Ygk9yCq3T5zqfZv761CjgZqLkewF3xl0e5ykzDVAJWA
         0nbg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772731646; x=1773336446; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9xcoW1uuOqJuCGhLK0+3X+GsY8ZmUZ0iw8x7VjTHzj4=;
        b=FgGSxSioHSGBCB2Y3UHDg4eLGv0j7nnkKFSO100nQqEKYJQITkiclTj20shr3nULab
         lBk+gcbn+PzeEI7wOGKCWwJj8X4EtFq5Wz7bSB6onqiWlZynycUe8tUgwEp7GMRfzXjV
         KHhdRMknVNfxf7Q5AJvd84dyhrKjrofjJOwdAXe7Xq2L/XIgr0ltrlT/8rlWTiOp86gT
         hNw5xhDkefhSlKJD1w+HkRpg7SZP/cQx6TH1E/EUA+7Vimw2N4CAGmZDrUToxXKXspYv
         Q/q0KF68Cr9b++D5leEOPEi2YRRRzmMBipTdimN7gcpWWiB6Dx/1nreL/OX9RXmGYQGC
         49Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772731646; x=1773336446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9xcoW1uuOqJuCGhLK0+3X+GsY8ZmUZ0iw8x7VjTHzj4=;
        b=eg4J+cWbuO+bj9R6mn8tCxNAkJZdqS1LyBvjy9izTCQxJOApwDeU2uNnwrhiXvUCl3
         1fag6u5enlEJ5LwP1enkEPEzTgj5RF3aZZbnyB9YefAgNzUcz9eipwBLDbmm3vsJ/74t
         KZqVPCelbIRfjk8wRPYNz7Jn/iFQioISuVImBY0ZJrt61kOjIWFEexxuKQIo+9dyNxV0
         mBfCtiS0VMskJt6jBN/kd+fktGdwXwULMCf+WCNHIfynpt3SdsFWp43FtbuFMFQQm6B3
         LMawDugymVgurV4D8h/BgNLVgv6N6SCnZt015RV5TKuWIpCiHTh8bu8SsjeyBIgLTXNq
         vDVg==
X-Forwarded-Encrypted: i=1; AJvYcCX/PNObCIM2ul9Zh0pWfWG5Jt2UNlRRXUHF9KjbKVeh+BwkZJggxudN4CWqe6VuMPz/TEHLcNQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzC1s2GBxLFp+SIJG2U87n7YnXpv6oOlMIemM4PP4J1PgUpMRuy
	dgoj2RJtXit4upxlbxjHbZ5/EV49/b/k91EXH6DGlQ9gwrtnuPTPg5Z8hFToNIyxvJ3kY71zvgx
	RBJouUTKwDCJwMuALKym8STnHNy9zy8jg/SB5k1mM
X-Gm-Gg: ATEYQzwrEWYWNqP4sgPJqAcDie29XDSKR/BBXJHWRm1tqpOi7/kxJVUfY2srLAb8Gi7
	QFB6zLC4C3XoLuQejXfIQp6h/a8iFYrwL/Dxb7FDWm94Vcr4YL0bmSEIgfEbDis46cf9ppndHf7
	hi+3Mw0EBO7/qhob8T+1ozb2JslCugaEQU6HAW4t15yz1U00YrvY/ZbcLofoX9AtB4Fdn3NOQaG
	LO4tBdAsu6kfKlajruDkD25m/1uwED8ZT8GA7AJbIOLhYpVGNxVN84JUtvOoOvRj0oPTHgMfNcP
	DGmkPDpY
X-Received: by 2002:a2e:9797:0:b0:387:5ea:e298 with SMTP id
 38308e7fff4ca-38a35158513mr8005261fa.8.1772731645158; Thu, 05 Mar 2026
 09:27:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260220004223.4168331-1-dmatlack@google.com> <20260220004223.4168331-5-dmatlack@google.com>
 <aam7JsCyQ5Oacvl5@google.com>
In-Reply-To: <aam7JsCyQ5Oacvl5@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 5 Mar 2026 09:26:57 -0800
X-Gm-Features: AaiRm51o6Q3ZTz6ECMDT5TdlqFdcggDf0j5vT0TJnm45bgTm8VbA0ynEnVZFATE
Message-ID: <CALzav=fV4NX=pxKfX7hH+tO3FBNcSF1KstXsKqprpCj64Ndx2Q@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] KVM: selftests: Use u64 instead of uint64_t
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

On Thu, Mar 5, 2026 at 9:19=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Feb 20, 2026, David Matlack wrote:
> > -static uint64_t pread_uint64(int fd, const char *filename, uint64_t in=
dex)
> > +static u64 pread_uint64(int fd, const char *filename, u64 index)
>
> I think it's also worth converting the function to pread_u64().

Good eye :). Yes agreed.
