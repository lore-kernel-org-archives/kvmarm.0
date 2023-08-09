Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F09ECE
	for <kvmarm@lists.linux.dev>; Wed,  9 Aug 2023 03:26:50 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2b9bb097c1bso97762431fa.0
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 20:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691551609; x=1692156409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bDtqmE5WaBwuWbcG5niee6vR0Dh8gvhaHzvoiNOQiws=;
        b=owAHMA78RpdKw7tQgsXJuS/elEyAp7vSGAzfHHJ5z4MmckA+NQrtCeJ+W8B7PUvc2D
         I/WpHW66G3aWUjJpuletY1j0z6aKy1xgec4upQFXMpwU9ycs+tCk/ePKYCi6Nbx+Tq5H
         Qy6MPyf/gtpxrwP1m2i9XoznQjE+jLj5ZwBSTijY/98bVmFXY24MFJCymc8ScA3Nxj2n
         fSOujTjvaaQVXxt/vcJYEAVtUVvyYiN2uWpHFHiII9KFwlpZWIDhDRw8t4Y/QmWWdq4T
         tB+UNi3v3GnHUI0r44M6p5HgP9APdJozCrZvNY2C87aDLO+gxiwTpgoEZWh+gs2IkgG7
         f6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691551609; x=1692156409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bDtqmE5WaBwuWbcG5niee6vR0Dh8gvhaHzvoiNOQiws=;
        b=J7i9AaXa7RQuqQVEEkMkJyLo98mnkIuiRCC8bsahvPlieYAF7sjdDbxVZKDLfKcKL5
         mOJ1/5xG/C4D2wzpqyyNOIqpljom8DXGuSqCEczAJsGQHIg45nSZs3f6aZ39kyFfIjwB
         kPk+QxSKwi027xxo3qPAkdMTgsm3VH43Sv52K1Tg1gLzijxTB+6QxHkhu0a+gvCkKuIy
         WvMQd0KzYbC9PPG58MgIKnLYaSoWO9iQdcNhR92kwW/eXWHu4lAr94jq+zjGsr/j1pqK
         u2wecse08/SkrQDFP3NTHBDSYbNbfannvd0buh6tXjwF8Uq6i0/MZUWFhPPGZOnR1rQ1
         6Wug==
X-Gm-Message-State: AOJu0Yx9jQueN73M8Dkt7VwQBIbTvqPc5CrtnK3OsSkRhI2/0EdYq4PR
	DYo2o1ZnWVjP1Uw7+9Th8enPC5Th/UZEn+0fbsU=
X-Google-Smtp-Source: AGHT+IH2bKTSsX7/6xPrKfrQgho5P8O/hWC3nUT0gNKKQQAzMu/0fuX80th8S70Ytqj3VHXYwT6+ychP6EtQ0Fkfu08=
X-Received: by 2002:a2e:a16e:0:b0:2b5:9d78:213e with SMTP id
 u14-20020a2ea16e000000b002b59d78213emr935818ljl.22.1691551608635; Tue, 08 Aug
 2023 20:26:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1690273969.git.haibo1.xu@intel.com> <CAAhSdy0yug=J0nxnnPoLYL=0MiT0w6qgPYOcv0QwMRe+fsQn8Q@mail.gmail.com>
 <87y1ilpz3m.wl-maz@kernel.org>
In-Reply-To: <87y1ilpz3m.wl-maz@kernel.org>
From: Haibo Xu <xiaobo55x@gmail.com>
Date: Wed, 9 Aug 2023 11:26:36 +0800
Message-ID: <CAJve8onZuOHkAUVY3=QeBPMx5n2F1fGgn57rPp7MB1Q5=vXasA@mail.gmail.com>
Subject: Re: [PATCH v6 00/13] RISCV: Add KVM_GET_REG_LIST API
To: Marc Zyngier <maz@kernel.org>
Cc: Anup Patel <anup@brainfault.org>, oliver.upton@linux.dev, ajones@ventanamicro.com, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Shuah Khan <shuah@kernel.org>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Ricardo Koller <ricarkol@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Like Xu <likexu@tencent.com>, Vipin Sharma <vipinsh@google.com>, 
	David Matlack <dmatlack@google.com>, Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, 
	Haibo Xu <haibo1.xu@intel.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 8, 2023 at 7:12=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 07 Aug 2023 04:48:33 +0100,
> Anup Patel <anup@brainfault.org> wrote:
> >
> > Hi Marc, Hi Oliver,
> >
> > On Tue, Jul 25, 2023 at 2:05=E2=80=AFPM Haibo Xu <haibo1.xu@intel.com> =
wrote:
> > >
> > > KVM_GET_REG_LIST will dump all register IDs that are available to
> > > KVM_GET/SET_ONE_REG and It's very useful to identify some platform
> > > regression issue during VM migration.
> > >
> > > Patch 1-7 re-structured the get-reg-list test in aarch64 to make some
> > > of the code as common test framework that can be shared by riscv.
> > >
> > > Patch 8 move reject_set check logic to a function so as to check for
> > > different errno for different registers.
> > > Patch 9 move finalize_vcpu back to run_test so that riscv can impleme=
nt
> > > its specific operation.
> > > Patch 10 change to do the get/set operation only on present-blessed l=
ist.
> > > Patch 11 add the skip_set facilities so that riscv can skip set opera=
tion
> > > on some registers.
> > > Patch 12 enabled the KVM_GET_REG_LIST API in riscv.
> > > patch 13 added the corresponding kselftest for checking possible
> > > register regressions.
> > >
> > > The get-reg-list kvm selftest was ported from aarch64 and tested with
> > > Linux v6.5-rc3 on a Qemu riscv64 virt machine.
> > >
> > > ---
> > > Changed since v5:
> > >   * Rebase to v6.5-rc3
> > >   * Minor fix for Andrew's comments
> > >
> > > Andrew Jones (7):
> > >   KVM: arm64: selftests: Replace str_with_index with strdup_printf
> > >   KVM: arm64: selftests: Drop SVE cap check in print_reg
> > >   KVM: arm64: selftests: Remove print_reg's dependency on vcpu_config
> > >   KVM: arm64: selftests: Rename vcpu_config and add to kvm_util.h
> > >   KVM: arm64: selftests: Delete core_reg_fixup
> > >   KVM: arm64: selftests: Split get-reg-list test code
> > >   KVM: arm64: selftests: Finish generalizing get-reg-list
> > >
> > > Haibo Xu (6):
> > >   KVM: arm64: selftests: Move reject_set check logic to a function
> > >   KVM: arm64: selftests: Move finalize_vcpu back to run_test
> > >   KVM: selftests: Only do get/set tests on present blessed list
> > >   KVM: selftests: Add skip_set facility to get_reg_list test
> > >   KVM: riscv: Add KVM_GET_REG_LIST API support
> > >   KVM: riscv: selftests: Add get-reg-list test
> >
> > Are you okay for this series to go through the KVM RISC-V tree ?
>
> Sure, seems fine from my point of view. But please put it on an
> immutable topic branch so that we can also merge it in the arm64 tree,
> should we need to resolve any conflicts.
>

Hi Marc,

Thanks for your review!

Which topic branch do you prefer or suggest to use?
I can do a rebase on it and fix any potential conflicts.

Regards,
Haibo

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
