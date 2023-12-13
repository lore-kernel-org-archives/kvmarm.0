Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C374119C
	for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 00:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="Ywp9KoD/"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-d9caf5cc948so6116759276.0
        for <kvmarm@lists.linux.dev>; Tue, 12 Dec 2023 16:50:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702428649; x=1703033449; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsP6D8T5vC4K0WLWKELqerL/h2k2GCGETaeygCJbK5E=;
        b=Ywp9KoD/a47ZVh1I09wJGESGaAGGdZ+RdHVq1t/DaImNgUerfFm6XWBGQ5iRhCUgsM
         QwLUO801aCEwGjpH4a2kh6SMUZW1QbWHsMxNs13WtwcG3GB0VoFsIwQxFPBxNsfBUgaS
         ABuyUiyvlWXnfflXMVo5IeUanUZmlqJTXmG0ZzXL3a45jNbCEhQ/OmmhdW8ywCUVqUSi
         ttKI2NHdcP2AqRSXx0zfvoRCfTXyYnZwhrIHiK2pQiRWpDFE9nEgZze4NA6IBmwOfWtA
         tZpJY4pwrEjyXnVVP4d/NOJz5A20shwe738z9cr488WhhEBoJIjHY8jvB/EodIGhs+C3
         7WfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702428649; x=1703033449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IsP6D8T5vC4K0WLWKELqerL/h2k2GCGETaeygCJbK5E=;
        b=FGMSBIPZg7UVSr0qR8I2RW4a+uig24PVnz4vxFdacvQWFPvc8ukiM1mkSF3roESF0M
         TwvsD5vcAAIYjGgW4UFtP7AQB4l3/J+y1l40hAIR63S+sJIGIcI5UDOIjgjiZ8Ie9w+a
         VYBxiILTxqlYIOBs3Regf0zdQvykyPw6VlyLJrEnPFT5sU6gT88rKya+skseqxNaB6z7
         Dam9F1Dv5V9sYb4URdxmrw0r8azEC+RJHEtp8vW2DYlPw1+fYuBx4v4Ciiw/I1saLc9w
         sK9nHtbyfDOSR38lKt0EQE2MLj5lWk5jt8M4Q2TcWfFHJAXdhPuVMk/J3kLWYtk3vqjv
         B/Xw==
X-Gm-Message-State: AOJu0Yywn5eo1X2LErtDMId0eK8ZWhw1TIan+2L6iqCiw9LiZSzdqrdu
	fCzGlod9ZsTDY56Fsj8OXsSo36s6DV+sp0tDZ1bFeQ==
X-Google-Smtp-Source: AGHT+IFg4hZCse8kzky6Y9/DVuxOtpUz/g7bXwrKJ9hF5mEV7x9P3i3TYFdKJnIuamiDiHUwxXUn6NjiQwKNsCzwWqw=
X-Received: by 2002:a25:8051:0:b0:db7:e91c:eb1d with SMTP id
 a17-20020a258051000000b00db7e91ceb1dmr4411297ybn.102.1702428649654; Tue, 12
 Dec 2023 16:50:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231122-arm64-gcs-v7-0-201c483bd775@kernel.org>
 <20231122-arm64-gcs-v7-2-201c483bd775@kernel.org> <CAKC1njSC5cC_fXnyNAPt=WU6cD-OjLKFxo90oVPmsLJbuWf4nw@mail.gmail.com>
 <d708b493-267a-4418-be91-9bde6b2cf50c@sirena.org.uk>
In-Reply-To: <d708b493-267a-4418-be91-9bde6b2cf50c@sirena.org.uk>
From: Deepak Gupta <debug@rivosinc.com>
Date: Tue, 12 Dec 2023 16:50:38 -0800
Message-ID: <CAKC1njSQPO8ja7AkTzQ724hhSsGjchH9dLbbH9LXP0ZiKj-zPQ@mail.gmail.com>
Subject: Re: [PATCH v7 02/39] prctl: arch-agnostic prctl for shadow stack
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
	Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>, 
	"Rick P. Edgecombe" <rick.p.edgecombe@intel.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Szabolcs Nagy <Szabolcs.Nagy@arm.com>, "H.J. Lu" <hjl.tools@gmail.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Florian Weimer <fweimer@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Thiago Jung Bauermann <thiago.bauermann@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 12, 2023 at 11:23=E2=80=AFAM Mark Brown <broonie@kernel.org> wr=
ote:
>
> On Tue, Dec 12, 2023 at 11:17:11AM -0800, Deepak Gupta wrote:
> > On Wed, Nov 22, 2023 at 1:43=E2=80=AFAM Mark Brown <broonie@kernel.org>=
 wrote:
>
> > > +/*
> > > + * Set the current shadow stack configuration.  Enabling the shadow
> > > + * stack will cause a shadow stack to be allocated for the thread.
> > > + */
> > > +#define PR_SET_SHADOW_STACK_STATUS      72
> > > +# define PR_SHADOW_STACK_ENABLE         (1UL << 0)
>
> > Other architecture may require disabling shadow stack if glibc
> > tunables is set to permissive mode.
> > In permissive mode, if glibc encounters `dlopen` on an object which
> > doesn't support shadow stack,
> > glibc should be able to issue PR_SHADOW_STACK_DISABLE.
>
> > Architectures can choose to implement or not but I think arch agnostic
> > code should enumerate this.
>
> The current implementation for arm64 and therefore API for the prctl()
> is that whatever combination of flags is specified will be set, this
> means that setting the status to something that does not include _ENABLE
> will result in disabling and we don't need a separate flag for disable.
> We have use cases that make active use of disabling at runtime.

A theoretical scenario (no current workloads should've this case
because no shadow stack)

- User mode did _ENABLE on the main thread. Shadow stack was allocated
for the current
  thread.
- User mode created a bunch worker threads to run untrusted contained
code. They shadow
  stack too.
- main thread had to do dlopen and now need to disable shadow stack on
itself due to
  incompatibility of incoming object in address space.
- main thread controls worker threads and knows they're contained and
should still be running
  with a shadow stack. Although once in a while the main thread needs
to perform writes to a shadow
  stack of worker threads for some fixup (in the same addr space).
main thread doesn't want to delegate
  this responsibility of ss writes to worker threads because they're untrus=
ted.

How will it do that (currently _ENABLE is married to _WRITE and _PUSH) ?

Please note that I am making up this scenario just for sake of discussion
And don't know if software would be using it in this manner.

>
> Please delete unneeded context from replies, it makes it much easier to
> find new content.

Sorry about that.
Noted.
