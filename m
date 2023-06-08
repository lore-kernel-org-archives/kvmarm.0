Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE63A945
	for <kvmarm@lists.linux.dev>; Thu,  8 Jun 2023 09:58:50 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-30d181952a2so428620f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 08 Jun 2023 02:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686218329; x=1688810329;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bro8SCdRCjEHWuDcBtldZHsndfar0M9rwEdZ8SQ0W0s=;
        b=DWLlXBMjR+In9QMk6WByU+4r6ZJwRxIdZLTZafSYiCKOJbbbT6swcxcbDLzxBWXjSp
         1fbhQV7xgyvNNKARmYmQiulH1nZx4WLvUTDj3K4StImn2hgIxDj2+ikZyPIKdWisMOTf
         POkUvZLouPzWG0TFB+pG8Fqpf4v308cP9MheL82rSXAkIQHV8FTqswIFUo3ofKEZH1T5
         gBAYnPnURVTOhHfQfMReB4ybwIfvFPWb9VgzTP9BzQ4nEZKp69qw8Fh1mVAeJnQ4O6Qb
         hvdyiWTomMIhVCmxq/xcYY3sZSRGDpAgFxYDyLLQmROw3quJagxDYH4kZcjPI1PfZRLY
         vJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686218329; x=1688810329;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bro8SCdRCjEHWuDcBtldZHsndfar0M9rwEdZ8SQ0W0s=;
        b=GiFMcD0Pb8G5rclNiQvyODhIqTXcd+79YuMoqKko3XKwZDvCHdTGbBMrkw7xvnI2zl
         w32jKmK86QOj+mFwXfKPpWAgUxR5kxK5CONvsxMAapwjwWa5oyAVwqIFKFNO9PmTi+Q7
         32ScrrWMiWn+mwns/+wshlLdBCjq2RVzKy0zWENqSRYP6dxul+xYSkFQrxXpuYeOO69b
         4yLUDiDbogl6OISlm4+Oe2tv0eqCZ118tkms1VJXcbJxNO6EqVcyN7LeGBIc8QKHVjcc
         8WcqE2mlwPM8mBhcqUy+i9XVtZS+aWzIUvf3yL+zbUKnXbERE87SStEt693DEC/SIZJu
         R5oQ==
X-Gm-Message-State: AC+VfDywYHxpOouio3OuT9N3XJOdpnkfBLItgUpq9lhIgfKmvN4Uf96c
	8BovUOqYxlyrCa+RejANDZCAtw==
X-Google-Smtp-Source: ACHHUZ6f6RLGsz44l11hXuy9AWjs8GZ3O0KJYqBLOUqFSQ6jSeZDCKr+qhXxSeHoE89ty7CpeH4xmQ==
X-Received: by 2002:a5d:6550:0:b0:30a:9014:838d with SMTP id z16-20020a5d6550000000b0030a9014838dmr6419901wrv.11.1686218329062;
        Thu, 08 Jun 2023 02:58:49 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id q12-20020a05600000cc00b002ff2c39d072sm1065586wrx.104.2023.06.08.02.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 02:58:48 -0700 (PDT)
Date: Thu, 8 Jun 2023 11:58:47 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Haibo Xu <xiaobo55x@gmail.com>
Cc: Haibo Xu <haibo1.xu@intel.com>, maz@kernel.org, oliver.upton@linux.dev, 
	seanjc@google.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Shuah Khan <shuah@kernel.org>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, David Matlack <dmatlack@google.com>, 
	Ben Gardon <bgardon@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 11/11] KVM: riscv: selftests: Add get-reg-list test
Message-ID: <20230608-344953a953eeb63ef6c26fb8@orel>
References: <cover.1684999824.git.haibo1.xu@intel.com>
 <da390e6200e838fce320a2a43b2f87951b4e0bbb.1684999824.git.haibo1.xu@intel.com>
 <20230525-2bab5376987792eab73507ac@orel>
 <CAJve8okR_iH4vF9DV9zTkDaeYe25kP7KUcKQphmjG5q-iVb-KA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJve8okR_iH4vF9DV9zTkDaeYe25kP7KUcKQphmjG5q-iVb-KA@mail.gmail.com>

On Thu, Jun 08, 2023 at 05:45:21PM +0800, Haibo Xu wrote:
> On Fri, May 26, 2023 at 1:18 AM Andrew Jones <ajones@ventanamicro.com> wrote:
> >
> 
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CORE | KVM_REG_RISCV_CORE_REG(mode),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_REG(sstatus),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_REG(sie),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_REG(stvec),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_REG(sscratch),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_REG(sepc),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_REG(scause),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_REG(stval),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_REG(sip),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_REG(satp),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_CSR | KVM_REG_RISCV_CSR_REG(scounteren),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_REG_RISCV_TIMER_REG(frequency),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_REG_RISCV_TIMER_REG(time),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_REG_RISCV_TIMER_REG(compare),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_TIMER | KVM_REG_RISCV_TIMER_REG(state),
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_A,
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_C,
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_D,
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_F,
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_H,
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_I,
> > > +     KVM_REG_RISCV | KVM_REG_SIZE_U64 | KVM_REG_RISCV_ISA_EXT | KVM_RISCV_ISA_EXT_M,
> >
> > I think all the above should have the size KVM_REG_SIZE_ULONG. Please also
> > test with a 32-bit host.
> >
> 
> Hi Andrew,
> 
> Just noticed the RISC-V 32-bit kvm selftests was not supported currently.

Oh, right.

> Even though I tried to remove the below check for 32-bit, there were
> still many warning and error messages during compiling.
> It seems 32-bit KVM selftests was not supported either for ARM/x86. Do
> we have a plan to support it on risc-v?

No plan and, if there was, it would be super low priority. So for stuff
like using KVM_REG_SIZE_ULONG, we'll just have to try and get it right
without testing. If somebody adds 32-bit support to these tests someday,
then, hopefully, it'll just work (I'm allowed one overly optimistic
comment per day).

Thanks,
drew
