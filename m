Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E899B3D9F
	for <kvmarm@lists.linux.dev>; Mon,  4 Sep 2023 13:26:44 +0000 (UTC)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-52bcd4db4cbso1929534a12.1
        for <kvmarm@lists.linux.dev>; Mon, 04 Sep 2023 06:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1693834003; x=1694438803; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/uL2B+XqPFUs3X1qoEJuP1SxRFKqVUX3leZ/vaoEUcA=;
        b=Muhv7OtniaNwg209M3mFWlOVoCb1Lgjyh03NHlhFrFD+naPXfiwrspjqXX7n+vLl8Z
         fQ//No5R5a6EkjzjoBq3ngstQKYJ7IS9ewPlBdy0S1vjApRRaFzObamZuj5/m1SMaJaN
         FQ3t/K/kILFiQw76lg1lXx5Ys8Xhd99QWNsQ6qiZfE1jWyOaaNkKZW0Dg9NNjsrshRvk
         +iqF4sXpN9OQV9Eb7a2wAXN4ASVx9QTIso5uNMRvrvcG1uy8s4VmcrSVe9XQyI0taCp7
         tMpEjJfO2K9Bt1ZfXPTD7+JtF300EVQ7ayPAf6q9iz2T1lIZLgXcxiSJL6ZTXwzRfKPg
         g30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693834003; x=1694438803;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/uL2B+XqPFUs3X1qoEJuP1SxRFKqVUX3leZ/vaoEUcA=;
        b=Y2Hv0t4m6HCd1z07QKl2wc/e2fi/kweIpANSYVki9CZEzDRLy3YDmm39TNfD47BKTR
         F6Jk5c/mptCBDpQNVtNrqaqa+xcJrb9n2d7dANlFG4126ldBnYTdWWZ1xa0hmoHXN9xn
         abhjnR30m/Ud+RI/c/LDDB5uYgZb708ylHzfx7ghxUmadf0PCpD0yok8Lw2zK9patMv2
         InyEO+5hoOx00HEH418Y109ejNhK/Atq0v/0ceo+RygVD9pnlFlu2D3XcV3HJWQrm+qJ
         wASnQ027Zuaviqxfn3vdrI+LQ44dh/pnyZZTSOoKssNuLywrbGWT8FryLz0pkLZ+goWF
         VtIg==
X-Gm-Message-State: AOJu0YxNCfepAOfYE2jvRICp4RhW7pt7GzPVI13oM1rWp96UE3X93qCt
	zD4vnQ7TR5xCs0SMRFc5FlPnrQ==
X-Google-Smtp-Source: AGHT+IGOFIwY6Wm7dsAMFZC9Eb7yEm5sipTomJmGwCL0leiifhPgy+OojWu1/AqpYEmyOm13m0TRlA==
X-Received: by 2002:a05:6402:17d7:b0:52c:84c4:a0bf with SMTP id s23-20020a05640217d700b0052c84c4a0bfmr4777586edy.30.1693834002867;
        Mon, 04 Sep 2023 06:26:42 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id n18-20020a056402515200b0052a3aa50d72sm5855572edd.40.2023.09.04.06.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 06:26:42 -0700 (PDT)
Date: Mon, 4 Sep 2023 15:26:41 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <haibo1.xu@intel.com>
Cc: xiaobo55x@gmail.com, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, Guo Ren <guoren@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
	wchen <waylingii@gmail.com>, Sean Christopherson <seanjc@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Vipin Sharma <vipinsh@google.com>, Aaron Lewis <aaronlewis@google.com>, 
	David Matlack <dmatlack@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Ackerley Tng <ackerleytng@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Lei Wang <lei4.wang@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Peter Gonda <pgonda@google.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>, 
	Thomas Huth <thuth@redhat.com>, Like Xu <likexu@tencent.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Michal Luczaj <mhal@rbox.co>, 
	zhang songyi <zhang.songyi@zte.com.cn>, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 3/8] tools: riscv: Add header file csr.h
Message-ID: <20230904-79306f36fc9cbe222eb0ef8f@orel>
References: <cover.1693659382.git.haibo1.xu@intel.com>
 <8173daae52720dbdabbd88a5d412f653e6706de1.1693659382.git.haibo1.xu@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8173daae52720dbdabbd88a5d412f653e6706de1.1693659382.git.haibo1.xu@intel.com>

On Sat, Sep 02, 2023 at 08:59:25PM +0800, Haibo Xu wrote:
> Borrow the csr definitions and operations from kernel's
> arch/riscv/include/asm/csr.h to tools/ for riscv.
> 
> Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
> ---
>  tools/arch/riscv/include/asm/csr.h | 521 +++++++++++++++++++++++++++++
>  1 file changed, 521 insertions(+)
>  create mode 100644 tools/arch/riscv/include/asm/csr.h
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
