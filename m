Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA485FF18
	for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 19:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="bl0QmnAH"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-dbc72b692adso4083327276.2
        for <kvmarm@lists.linux.dev>; Wed, 13 Dec 2023 11:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1702497596; x=1703102396; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s31Qnl2jy9dVbfR9SU0O1e0gpO4gYzM2ckO1KK9cNWQ=;
        b=bl0QmnAHmPu8o/te1JMGkoYvqpZ7jgvKMv0ADX9Vm4NbUrHyHc6IzVOks1irrl+kfO
         SINtEng/UXClv41ADhWXZhz6dkRFOG4MqIU04KlnGPDp1BluCSRxooExN6NlCDf6aCue
         EgaiQkKa4l0Tpp/rgTwxaAJ3no6tpVpLYqVV7dAsxrdWwaEG1wxkt9M00vIpBRRUQwTH
         g/3Qtd5xjxqgf53wAZCqFbDfKRWwq/hmStjBVuV2HlGsdjL3pYIWD0okR67Dayj8KAOy
         14h7LJTg9zu4QIDBuRqecd/ck3ZZTYC0AoF4dEFu4UZgGt366ZC40n8RCG2VWMOG7z7K
         cjxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702497596; x=1703102396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s31Qnl2jy9dVbfR9SU0O1e0gpO4gYzM2ckO1KK9cNWQ=;
        b=Z5QaLBNIphV+jW9uC1q6JbdxvpLWQLaBSELbWvKZxEf4UDjZ4GQ/wTkKwpW/ePMPA6
         pbHdKaNGt7frx4kIP8ihusW4P7ForMALzbxUJ1Wf45AC4jKlCTboFtx13Oj59q9Mz5+o
         cFSjSE3BXOXqJZsq6Qe/cX93wWDeQBSz/saOoKKe+GFhdKu89Du7wy0OwZhLNnfMWMUt
         Cb5mqgjTPgdA4s+OddczsJk+NzAPqtEZIMUUGA/RVMAaNPpfgZ1O1PW01bTZVvWVMGXL
         ryZh5YRRSB8Syz4KJPosBd+1q1p7RjsNOVXyEU9Vj08JQ37W7aD2HJS/wQX/b7IFcCnw
         4LgQ==
X-Gm-Message-State: AOJu0YyXfq22jmScNu8JouynXUfxyf3q/uaV8mpqtVBSawR5IG4kIfrC
	JrhARlyt+e4IjwO+nocSqnLTzAn8ndjkQ4e3IvvqQg==
X-Google-Smtp-Source: AGHT+IGoanEfSAfWqtQw7++5uapiVETyiSe4lA5KkKISTBsZpDDCHd2EgxZu4V1rN9q+R/qEjWhYJ9uGnGBTlEe8bKg=
X-Received: by 2002:a25:6ac4:0:b0:db7:dacf:3fb6 with SMTP id
 f187-20020a256ac4000000b00db7dacf3fb6mr4418808ybc.99.1702497596004; Wed, 13
 Dec 2023 11:59:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231122-arm64-gcs-v7-0-201c483bd775@kernel.org> <20231122-arm64-gcs-v7-20-201c483bd775@kernel.org>
In-Reply-To: <20231122-arm64-gcs-v7-20-201c483bd775@kernel.org>
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 13 Dec 2023 11:59:45 -0800
Message-ID: <CAKC1njQVB71A8fQBLmBnx++agM12XDLhS=7iL7-A4NTXSqUM+A@mail.gmail.com>
Subject: Re: [PATCH v7 20/39] arm64/gcs: Context switch GCS state for EL0
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

On Wed, Nov 22, 2023 at 1:45=E2=80=AFAM Mark Brown <broonie@kernel.org> wro=
te:
> +
> +/*
> + * Apply the GCS mode configured for the specified task to the
> + * hardware.
> + */
> +void gcs_set_el0_mode(struct task_struct *task)
> +{
> +       u64 gcscre0_el1 =3D GCSCRE0_EL1_nTR;
> +
> +       if (task->thread.gcs_el0_mode & PR_SHADOW_STACK_ENABLE)
> +               gcscre0_el1 |=3D GCSCRE0_EL1_RVCHKEN | GCSCRE0_EL1_PCRSEL=
;

If the intent is to disable, is the GCS stack freed or kept around?
I expect if libc is taking the decision to disable, kernel should free it u=
p.
Is it freed in some other flow?

> +
> +       if (task->thread.gcs_el0_mode & PR_SHADOW_STACK_WRITE)
> +               gcscre0_el1 |=3D GCSCRE0_EL1_STREn;
> +
> +       if (task->thread.gcs_el0_mode & PR_SHADOW_STACK_PUSH)
> +               gcscre0_el1 |=3D GCSCRE0_EL1_PUSHMEn;
> +
> +       write_sysreg_s(gcscre0_el1, SYS_GCSCRE0_EL1);
> +}
