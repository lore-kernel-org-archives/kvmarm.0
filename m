Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D59374FB
	for <kvmarm@lists.linux.dev>; Wed,  8 Nov 2023 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lrf090ma"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5af592fed43so3375337b3.2
        for <kvmarm@lists.linux.dev>; Wed, 08 Nov 2023 15:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699486645; x=1700091445; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oIcgmcP1EY6htEGo1pN6EVJRVE+qt/I8BKL1s/KEy5I=;
        b=Lrf090mabu0W+hlQ/Xzv+HUiFzdRgTojD1eZJqGusjWxhW0RGr0x94heXXmIoRCirr
         emMWGf21U/ieFGDaSmQySCB/moTE0B13YkfpjgdcZ/+hMiDhzTGAPEZh+J+FMerA7tit
         5WR+6oDZXR+cWb5zHKea5CzN/dQwjo8mLmRPgvmWblGAx9Sf8b9OREVSq525y7kw/pvS
         4ICPXFJom+ERefzydGhAFb/lbwJASy+OuxdacQiPaNIuUGZf/lKsjpkUClvNuDtJylsX
         1yYfIFg2hdAqMR0EqXsZEqdEfXsQuVTilEP22wUMVN8wi2uzdsi3q23dYbXlggpztcjx
         hLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699486645; x=1700091445;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oIcgmcP1EY6htEGo1pN6EVJRVE+qt/I8BKL1s/KEy5I=;
        b=ujSo2O9MaltWo5prWMbZpy3u355N55oaj/dgmntHU1IfCfzOoDCbtB8keAwCXO4+qj
         J8S/qshmhzKGmHn9rKt/0U1+7eMX3AcYyRknDpgn1q/9UWz3A3M7ULA/8q9PfRYPjhmz
         A6FijAzEacrkC7xj5zky5HwEfUp3e8XIIUiBIPwOfsOXvJ7Z8wIoZ3zNuZRhpdjtaZsZ
         OMIu1thxN//u/j8zx2hze+5CnZ7OZeOBFAh35rTWGvsb0NoQnb/IPdwvKYdGPCWb52/7
         OSsvInim+l/7Ja2QN2e3wmNGS5e1aE6ZiRG0dYPn6y5KwKTRQZF+0VTmxZMEhlDdJDnx
         Xu5Q==
X-Gm-Message-State: AOJu0YyBLFMMWSe3BLyY28D84SciMt4uXHGwt7aPkIH8kI53Bq2+PQSJ
	3QQDBfFEMLUnLOrRBWd704doiXnz1k0Fmg==
X-Google-Smtp-Source: AGHT+IEQyf2yih5ALlCfgSEkVLSLt0Zq5IBGBmP/Cna+y8K3zSa/6bcCrG6olPCsXpdGmctjh3MSlNk2LvNOvw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:102:b0:da3:723b:b2a4 with SMTP
 id o2-20020a056902010200b00da3723bb2a4mr72222ybh.7.1699486645232; Wed, 08 Nov
 2023 15:37:25 -0800 (PST)
Date: Wed,  8 Nov 2023 23:37:19 +0000
In-Reply-To: <CAF7b7mrGYuyjyEPAesYzZ6+KDuNAmvRxEonT7JC8NDPsSP+qDA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <CAF7b7mrGYuyjyEPAesYzZ6+KDuNAmvRxEonT7JC8NDPsSP+qDA@mail.gmail.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108233723.3380042-1-amoorthy@google.com>
Subject: Re: [PATCH 27/34] KVM: selftests: Introduce VM "shape" to allow tests
 to specify the VM type
From: Anish Moorthy <amoorthy@google.com>
To: amoorthy@google.com
Cc: ackerleytng@google.com, akpm@linux-foundation.org, anup@brainfault.org, 
	aou@eecs.berkeley.edu, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	chenhuacai@kernel.org, david@redhat.com, dmatlack@google.com, 
	isaku.yamahata@gmail.com, isaku.yamahata@intel.com, jarkko@kernel.org, 
	kirill.shutemov@linux.intel.com, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, liam.merwick@oracle.com, 
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	mail@maciej.szmigiero.name, maz@kernel.org, mic@digikod.net, 
	michael.roth@amd.com, mpe@ellerman.id.au, oliver.upton@linux.dev, 
	palmer@dabbelt.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	qperret@google.com, seanjc@google.com, tabba@google.com, 
	vannapurve@google.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, 
	wei.w.wang@intel.com, willy@infradead.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, yu.c.zhang@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 8, 2023 at 9:00=E2=80=AFAM Anish Moorthy <amoorthy@google.com> =
wrote:
>
> This commit breaks the arm64 selftests build btw: looks like a simple ove=
rsight?

Yup, fix is a one-liner. Posted below.

diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/=
testing/selftests/kvm/aarch64/page_fault_test.c
index eb4217b7c768..08a5ca5bed56 100644
--- a/tools/testing/selftests/kvm/aarch64/page_fault_test.c
+++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
@@ -705,7 +705,7 @@ static void run_test(enum vm_guest_mode mode, void *arg=
)
=20
 	print_test_banner(mode, p);
=20
-	vm =3D ____vm_create(mode);
+	vm =3D ____vm_create(VM_SHAPE(mode));
 	setup_memslots(vm, p);
 	kvm_vm_elf_load(vm, program_invocation_name);
 	setup_ucall(vm);
