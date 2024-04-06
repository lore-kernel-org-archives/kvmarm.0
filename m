Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2891772F
	for <kvmarm@lists.linux.dev>; Sat,  6 Apr 2024 06:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712385274; cv=none; b=XZPSPPU1J6sbUNXG5kChVKf9zJDLm0jKHORme8hlx+VfGPQ6rdOlOuAGhX9h+u+70fW3CfG4t17AAh+eOKTrA1I1gukOAGsfV6Qtg7GLHvYGyy3wDwVSzEQyLoZlvOCMtkfGLLLT5H4jzf34+eV0B/+zI4aKSAzh0/NJmgqgc3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712385274; c=relaxed/simple;
	bh=w0zV6S/jtqpepUyL351B1h1ISsvSQFBhmHF+adO8uiQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Io2LWFle1gLICPvUE5LptWVYIl4QTpEPCIACSc8ZYd5ikLjwW/aQvfjpupW0R7VUv2V7dVvZQ98wN6brNQYI4SiS8fL1ok83pRgdbvB1WqfTNF2K615jB0QYrQyqsV7qv2tIBqr24Jyf6888uIvlpP+P4EHRfdQsJpMGYJiwb28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NC08IrP1; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NC08IrP1"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1e2987e9d06so24564525ad.2
        for <kvmarm@lists.linux.dev>; Fri, 05 Apr 2024 23:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712385272; x=1712990072; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JStnzUCrjKVc2+vxyRcSCMDwH6+PypfgeZAMMPE/SY=;
        b=NC08IrP15UvbwamNsZtsTiyd7owumGH5iWdaTeSjmrxpYF/Cl7GQa4yEpOdNPG2pcU
         jz653Vu0Hz2IAnZL/eAOw6wIV6dlRj529fhJjTdFK5AO2adHrG/O5aPG+tnVYvsF6euw
         qgTBLMF9JAvCM76H7SJFGuD7IeM7mu/44VWrtR0EXw8pEk2c76m0FIm0gURSSOd/AQAq
         xOL35eYSp9S6F6kuCZKG/MeI2l5ZLAN1dt3TlcPZZgj9JqVTd2cq2ZRt4Gwut2vON/ih
         lu1Pa5FkDe2yA7Fs/Nb/kXTOpaxOgZVrtK/b+rNHv5wa0hEF3yiiKS7mOQoGrc5e7atZ
         3S7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712385272; x=1712990072;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9JStnzUCrjKVc2+vxyRcSCMDwH6+PypfgeZAMMPE/SY=;
        b=AGdvJAHSbYYEU0fmAXeKRydq28/u1+JPfBbDtNfJIRd7fMiNUVZ62wplxVe9NdgAQm
         xztrvCkqCjqpFKznfNn/n2SFvCUmelIfWVcDj6wMX/Uyk5lfaoNOT3AivvueTNHuUh01
         WKEZZz6DGAVRbFgAEzHYlvbAbn3m39c8exouL16QpzjVezmj6wrtBnDQ4KUALvdmUPrw
         Oomvqyb/ouZfwewiVSCO0AqrTaiJbafEzZ0SNTbj5XUuFVPcP8eaQH5XOOikCX8KnyrX
         6PU+6lYPGjJW1uDF+HxUKT7yOMsR9zGfNDJxtXvdg8nvmskgQjZ+dSV6I6+ZKDnfrOaK
         GxPA==
X-Forwarded-Encrypted: i=1; AJvYcCUOEXEQUn/Ksawo1LGhV77+A5cTPBf3cCGUfdNmpmaUQWthxoBU33KMkSemd1bQsQoUNFTtHApjds5s0YwOsLmNbb/7g4cg
X-Gm-Message-State: AOJu0Yyzen85SuDAmJQ9723+rXy0KpYQI93somspopweXe2xcGBkXG04
	9tDzG9PR8mUhGsWOwzWXXreS9gporoo0XNslMVOKTdP/xXlHu8PP
X-Google-Smtp-Source: AGHT+IFZ1bnBFNa/f7mj9nWkwUcDhM7BYoeBvC8x+4h61aPwpJPSnjywqYCopFigwQM3malM/wYOgQ==
X-Received: by 2002:a17:902:f085:b0:1de:fbc3:8e4a with SMTP id p5-20020a170902f08500b001defbc38e4amr2782558pla.52.1712385271781;
        Fri, 05 Apr 2024 23:34:31 -0700 (PDT)
Received: from localhost (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id kj8-20020a17090306c800b001dd69aca213sm2677034plb.270.2024.04.05.23.34.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 23:34:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Apr 2024 16:34:21 +1000
Message-Id: <D0CTWX0N023S.3U58HCNRJDC1R@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Huth" <thuth@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>,
 "Nadav Amit" <namit@vmware.com>, "David Woodhouse" <dwmw@amazon.co.uk>,
 "Ricardo Koller" <ricarkol@google.com>, "rminmin" <renmm6@chinaunicom.cn>,
 "Gavin Shan" <gshan@redhat.com>, "Nina Schoetterl-Glausch"
 <nsg@linux.ibm.com>, "Sean Christopherson" <seanjc@google.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests RFC PATCH 00/17] add shellcheck support
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405-20fbe979a00acc8b9d161936@orel>
In-Reply-To: <20240405-20fbe979a00acc8b9d161936@orel>

On Fri Apr 5, 2024 at 11:59 PM AEST, Andrew Jones wrote:
> On Fri, Apr 05, 2024 at 07:00:32PM +1000, Nicholas Piggin wrote:
> > I foolishly promised Andrew I would look into shellcheck, so here
> > it is.
>
> Thanks! I hope you only felt foolish since it was recently April
> Fool's day, though.

Hah, no it was fine, it was a good idea and I've been mucking with
a lot of the bash so, no worries.

>
> >=20
> > https://gitlab.com/npiggin/kvm-unit-tests/-/tree/powerpc?ref_type=3Dhea=
ds
> >=20
> > This is on top of the "v8 migration, powerpc improvements" series. For
> > now the patches are a bit raw but it does get down to zero[*] shellchec=
k
> > warnings while still passing gitlab CI.
> >=20
> > [*] Modulo the relatively few cases where they're disabled or
> > suppressed.
> >=20
> > I'd like comments about what should be enabled and disabled? There are
> > quite a lot of options. Lots of changes don't fix real bugs AFAIKS, so
> > there's some taste involved.
>
> Yes, Bash is like that. We should probably eventually have a Bash style
> guide as well as shellcheck and then tune shellcheck to the guide as
> best we can.

+1

>
> >=20
> > Could possibly be a couple of bugs, including in s390x specific. Any
> > review of those to confirm or deny bug is appreciated. I haven't tried
> > to create reproducers for them.
> >=20
> > I added a quick comment on each one whether it looks like a bug or
> > harmless but I'm not a bash guru so could easily be wrong. I would
> > possibly pull any real bug fixes to the front of the series and describ=
e
> > them as proper fix patches, and leave the other style / non-bugfixes in
> > the brief format.  shellcheck has a very good wiki explaining each issu=
e
> > so there is not much point in rehashing that in the changelog.
> >=20
> > One big thing kept disabled for now is the double-quoting to prevent
> > globbing and splitting warning that is disabled. That touches a lot of
> > code and we're very inconsistent about quoting variables today, but it'=
s
> > not completely trivial because there are quite a lot of places that doe=
s
> > rely on splitting for invoking commands with arguments. That would need
> > some rework to avoid sprinkling a lot of warning suppressions around.
> > Possibly consistently using arrays for argument lists would be the best
> > solution?
>
> Yes, switching to arrays and using double-quoting would be good, but we
> can leave it for follow-on work after a first round of shellcheck
> integration.

Okay good, thanks for all the review on it.

Thanks,
Nick
