Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2203210
	for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 16:45:56 +0000 (UTC)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-54fb8a8a597so55052977b3.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Apr 2023 09:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682354755; x=1684946755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cogHEMsVVgTDAgj3gPVUEVuPljtJmFM5khAyIfbROPI=;
        b=IBOU6rK79gND4DciwLkfyHJXLICK+nm1hfqmlYcnXaImIV8xf915qrkhfvrtFQ1bD9
         8Z+ZDwfy6VoKjQweFXwu2Ekk2xB4sANXClY8YQV834aQDs+/FEV0pbYJdQjAAZN9rs34
         f57BlCx+WuwQCSpj22oE82Xg3qgAyLXwOjmFBUce3BRWppaPMfsXHqc33YIYcz+3VNi4
         XAZAp7pRNW06LclNSKJAgnoHgP+fH1wRI4+4eovVUts+kprnZi5lybCwL9Zgev3v81H7
         MVICvn7IiG51PLSmT4j4PcXlaBgIbQc7j8zZ0ZG9H7yZWRSpCFId5KXjqGEfZQLGW0Na
         Tk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682354755; x=1684946755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cogHEMsVVgTDAgj3gPVUEVuPljtJmFM5khAyIfbROPI=;
        b=NFeSb78xf30dEMIfBjBLnSPyvrrqS+VvBUzkX2QhrSNc0lblAceyNzKflkq3xWili6
         6R7/J8J6yAqSKnO5Bru+bHUY+FzfIKfo7fW6P/RcxozLrYlLyE2nPb5ryx+LQoDiwTCg
         D3EJoAjXst22ROuAfk1eFxBZiD7JVd9zGSexZW7lhIAXi3mNjuvLGX4orrC0d2L+/OA0
         BakQ5SfubqPV04YJfgSi+H54RdPrw0Kq7Fs7kN5ECksE6S4E0tjW2R+oddLjw9BpuCOF
         MApSpp9+zrmFRMdlye9Zd9jzxm90Fooh770bqJSYOJlxwIzi/l8zvIZglKzFiv3UStWQ
         83vw==
X-Gm-Message-State: AAQBX9eRJB6iHuMbNgKyfdTNH2V88z+tq4OE02K6mM8k2WSPzy/bVyOw
	UsCTFtvGUta6J6ECHepcbwRCdoqfNWPDYM3DpdK73w==
X-Google-Smtp-Source: AKy350bUMi1vCT3z4Q+q+kn/632Ww3gn+vAsPs+FHaqynFi9cqF64KYbnuQ/xodFFgeBsnoDvd5keBpYNYydhUX/nUI=
X-Received: by 2002:a0d:ccd0:0:b0:541:8735:171e with SMTP id
 o199-20020a0dccd0000000b005418735171emr9340453ywd.11.1682354754795; Mon, 24
 Apr 2023 09:45:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230421165305.804301-8-vipinsh@google.com> <202304220315.bpwbgH5n-lkp@intel.com>
In-Reply-To: <202304220315.bpwbgH5n-lkp@intel.com>
From: Vipin Sharma <vipinsh@google.com>
Date: Mon, 24 Apr 2023 09:45:18 -0700
Message-ID: <CAHVum0cp=wfDmuK87jq7+2t5FnK09v1LownwqgS41EisT4Gc1g@mail.gmail.com>
Subject: Re: [PATCH 7/9] KVM: mmu: Move mmu lock/unlock to arch code for clear
 dirty log
To: kernel test robot <lkp@intel.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com, 
	tsbogend@alpha.franken.de, anup@brainfault.org, atishp@atishpatra.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com, 
	ricarkol@google.com, oe-kbuild-all@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 21, 2023 at 12:43=E2=80=AFPM kernel test robot <lkp@intel.com> =
wrote:
>
> Hi Vipin,
>
> All warnings (new ones prefixed by >>):
>
>    arch/riscv/kvm/mmu.c: In function 'kvm_arch_mmu_enable_log_dirty_pt_ma=
sked':
> >> arch/riscv/kvm/mmu.c:399:9: warning: ISO C90 forbids mixed declaration=
s and code [-Wdeclaration-after-statement]
>      399 |         phys_addr_t base_gfn =3D slot->base_gfn + gfn_offset;
>          |         ^~~~~~~~~~~
>
>

I will fix it in v2.
