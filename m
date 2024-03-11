Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F31182CF
	for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 09:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710149233; cv=none; b=WQf3nWBdjSEZduQmutWSfWrFxVXsU7dAheIhZ/I0WWESoiPi8N96WLuLUeDbpNuTvjg5Nf323bgMtN/X6jurY7t5hcgWBbMQoG5D2T6Ob41vsP0UQKP9qUKAqghz6RYb4nQAnKJSDSsbYjBI0l0Sx7QB+25xkFaqEZ8Fjg4MTQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710149233; c=relaxed/simple;
	bh=8zth3mwh/cKPnkQ6EEGd+vNlUKFtCYJEHeMahy8I+ig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hXPAFqSD+TJcoN8gQpqgMTOHT631RkcwrBg793cU3Z746SezUTg31pc/zIwFdXX+6PJAN+rCrZDlbyND1dYsLR5hBqbThpwkDdD6F7p7ep321jGME6BoExmP5vHbKjlntIKqOCoFUTWWGE/e/8U+5AvB3bsvQh7N7B/E+aDUpt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PlKslLXY; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PlKslLXY"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2d26227d508so62471611fa.2
        for <kvmarm@lists.linux.dev>; Mon, 11 Mar 2024 02:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710149229; x=1710754029; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8zth3mwh/cKPnkQ6EEGd+vNlUKFtCYJEHeMahy8I+ig=;
        b=PlKslLXY43obBA1Ju5ApNZR+W3u6qj/cbHi+j/718+gZyPA+05DbPwzVQKyT/Hn3bt
         L6B/q90J678hxy6GvIeUXqpLm+4AFKFGdyIZlxepYTjzegCcmDmGjNe+C+quWGWvZzTJ
         NvKU2GnD1SbamFeyLxXAuLDUvwPsHdZ0tV1VA9Sb+6RQ8S3Qf1bcF+kw/XEUcr4vvs9n
         jGcL7u2C8Xiktvg6dkOL2R8N37INezSsTeJMZMHwiPAArkCHnqSDQSSVt1yLyo2voChL
         b7l/epN53O/fXVaKchTx0rR04XNqMMiecv7RGck800Jdku6sRNu51d8esRhoV7Dmqmp/
         V9yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710149229; x=1710754029;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8zth3mwh/cKPnkQ6EEGd+vNlUKFtCYJEHeMahy8I+ig=;
        b=eSULLekdKlYnsbkLXHB0H1Fh/8g/jMg05NhCWLNIZYcJkSWE5amqDPsyor5qn0rr1W
         maWcP9XklF0cP1zCjVUgW7u3Een/yAKntMDtPHkvH+DrsnFXGheRPaQSyG0OG7aqKmy2
         E7qs9aM0ix8Ln6A/dqsWg8tuTLmlEEcIofz500iilId3crO1fhQeGSDToQMDM7RjaylE
         VXIR3sYmA74xET/wXe/a1Uj6Qk2UDfVsvz1KtS/EYUEgMQm8qw4EKPqCLlQ4sBpW/jxc
         oaMDxTvJYA6plPJ8Bx4noY4bOuBHLQlJdohh+GrogRo8JeTIRBcoSocjCuaKIfcyzngZ
         TyPA==
X-Forwarded-Encrypted: i=1; AJvYcCUpFlJxaunQWffNR09cLevBv1kBDpdKBxbo1BhJs/gr/nLabH5BkzIkan5cc578dvMN2heKSHUwuNWqYLqKQitKp4bhpwbB
X-Gm-Message-State: AOJu0YwM/LjisV/ATZnLYG1fWKCbPlwCEXh12WRpPrOci+v5NZLgWhBK
	3S0X8HMwXk90XxTPf8QQj8/yRM30As9A9YNRLo2zXJohxwJBCcgHIY9ssMMOGQ79Nf7LahMBIDk
	s5M5ZObAn6XhAfYKfnNcoirFF+56kxzUITgDn
X-Google-Smtp-Source: AGHT+IFzr2Y971s9TIBNchuVSVv96nsdJjBYbviMit/edW0+/JwqZBjOrNfaM4862cuUg6dthFfgr61zIEYjCiYlE2E=
X-Received: by 2002:a05:6512:3baa:b0:513:b102:7d93 with SMTP id
 g42-20020a0565123baa00b00513b1027d93mr690098lfv.24.1710149229222; Mon, 11 Mar
 2024 02:27:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <335E21FA-7F1E-4540-8A70-01A63D8C72FA@amazon.com>
In-Reply-To: <335E21FA-7F1E-4540-8A70-01A63D8C72FA@amazon.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 11 Mar 2024 09:26:12 +0000
Message-ID: <CA+EHjTxpBM6LyqGfE_y--Uy1oR4oP7Ozcp3mBwFvAijOZe0i+Q@mail.gmail.com>
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
To: "Manwaring, Derek" <derekmn@amazon.com>
Cc: David Woodhouse <dwmw2@infradead.org>, David Matlack <dmatlack@google.com>, 
	Brendan Jackman <jackmanb@google.com>, "qperret@google.com" <qperret@google.com>, 
	"jason.cj.chen@intel.com" <jason.cj.chen@intel.com>, "Gowans, James" <jgowans@amazon.com>, 
	"seanjc@google.com" <seanjc@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"Roy, Patrick" <roypat@amazon.co.uk>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"lstoakes@gmail.com" <lstoakes@gmail.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>, "Graf (AWS), Alexander" <graf@amazon.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 8, 2024 at 9:05=E2=80=AFPM Manwaring, Derek <derekmn@amazon.com=
> wrote:
>
> On 2024-03-08 at 10:46-0700, David Woodhouse wrote:
> > On Fri, 2024-03-08 at 09:35 -0800, David Matlack wrote:
> > > I think what James is looking for (and what we are also interested
> > > in), is _eliminating_ the ability to access guest memory from the
> > > direct map entirely. And in general, eliminate the ability to access
> > > guest memory in as many ways as possible.
> >
> > Well, pKVM does that...
>
> Yes we've been looking at pKVM and it accomplishes a lot of what we're tr=
ying
> to do. Our initial inclination is that we want to stick with VHE for the =
lower
> overhead. We also want flexibility across server parts, so we would need =
to
> get pKVM working on Intel & AMD if we went this route.
>
> Certainly there are advantages of pKVM on the perf side like the in-place
> memory sharing rather than copying as well as on the security side by sim=
ply
> reducing the TCB. I'd be interested to hear others' thoughts on pKVM vs
> memfd_secret or general ASI.

The work we've done for pKVM is still an RFC [*], but there is nothing
in it that limits it to nVHE (at least not intentionally). It should
work with VHE and hVHE as well. On respinning the patch series [*], we
plan on adding support for normal VMs to use guest_memfd() as well in
arm64, mainly for testing, and to make it easier for others to base
their work on it.

Cheers,
/fuad

[*] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com
>
> Derek
>
