Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DF4AD25
	for <kvmarm@lists.linux.dev>; Fri,  4 Nov 2022 20:15:40 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so9226453pjk.2
        for <kvmarm@lists.linux.dev>; Fri, 04 Nov 2022 13:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WwcH+iZxGlELoSFmbiG2F+LcSAfxo7d4BXkkQPL3oEI=;
        b=Feo7aLccvIiUFCz0IQvThwilRRuNsyrpZUnftVsZfjj8XYXQSFrIYH3rBJ9pl9AVd1
         0QBS4p0eS2Auk5grltqCZHhMy52m2eoOZ3Dyjvl6u7ksM+uKmfXQViJ2DXA8oC3D4Z34
         IZgMWO3NptjbIzmMH+7K07NkCucKQA3oBW+yQ9OuKRe0+DMXUgLl0Rs58L/pchkt3qwG
         SRvLV8FDseMonl0kTvvz0KTjPcnWljQWZJ8bRjD448LzwgH9ljB4ZZnYaguVVVZ5Rh/H
         Z656e04FZq7s/SPiTN5UXm2Xfu4LYQY2nb1iUEZCzGlvNIqMCMtTR0K0fg2+3idK7iEY
         /AAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwcH+iZxGlELoSFmbiG2F+LcSAfxo7d4BXkkQPL3oEI=;
        b=ohrSa9y1vypHVQSJaYP/qjRxtJQPDlzEYsNvUXugbD8U0T8a9r8RujnAwht+riyyne
         nT5myS0HN4zq8r9TTmD2bUvR860DvFyltqhfEVAl/Urf3Qfyyd6xT2cDf53qMmy39ltv
         i9el7eYticQuB0s6y/a8UaPmMenSiCdlpgBoQtmw4DF6GA5kNI+uoYst262vSRUjJbcS
         tFu+QSMQ82tITi6kK7Q0iq+o1tdQ8geL2sxPYD03+wty791hNZ8Q8xK/tz+A1s7/XgGK
         wwddnwRkKaHsiJ3gqGLT00cDSVSfiPmzny/ZWgH1Xo7heagtCCOYWUoTnuCOoYGzbUJ5
         B6dw==
X-Gm-Message-State: ACrzQf177Qn0E4U4lVgbNwdVEqt2nOZ0QR5TMo9Ve9aZVlrxFhZZjg7N
	gyYekRaxnqt/VbsJrgNwAQ5naQ==
X-Google-Smtp-Source: AMsMyM7LA9CKVJucdf56FhPBIDbY23ArzmJdn5v66cKOhKDCPGvtmHqu7FhmyFiehmOw+k0waEgaCQ==
X-Received: by 2002:a17:90a:2bc9:b0:212:8210:c92d with SMTP id n9-20020a17090a2bc900b002128210c92dmr38288471pje.38.1667592940349;
        Fri, 04 Nov 2022 13:15:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090332c700b00183c67844aesm166908plr.22.2022.11.04.13.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:15:39 -0700 (PDT)
Date: Fri, 4 Nov 2022 20:15:36 +0000
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Atish Patra <atishp@atishpatra.org>,
	David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Fabiano Rosas <farosas@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Gleixner <tglx@linutronix.de>, Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 02/44] KVM: Initialize IRQ FD after arch hardware setup
Message-ID: <Y2Vy6Eq89tQa+3bq@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-3-seanjc@google.com>
 <Y2Rfz+TIcdfcawxh@gao-cwp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2Rfz+TIcdfcawxh@gao-cwp>
Message-ID: <20221104201536.pdUCy-Xn7BnE8q9wUuTxI3mRH8HC8wm9Z26L6nQYRVA@z>

On Fri, Nov 04, 2022, Chao Gao wrote:
> On Wed, Nov 02, 2022 at 11:18:29PM +0000, Sean Christopherson wrote:
> > 
> >+	r = kvm_irqfd_init();
> >+	if (r)
> >+		goto err_irqfd;
> >+
> > 	r = kvm_async_pf_init();
> > 	if (r)
> >-		goto out_free_4;
> >+		goto err_async_pf;
> > 
> > 	kvm_chardev_ops.owner = module;
> > 
> >@@ -5927,6 +5926,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
> > 	kvm_vfio_ops_exit();
> > err_vfio:
> > 	kvm_async_pf_deinit();
> >+err_async_pf:
> >+	kvm_irqfd_exit();
> 
> >+err_irqfd:
> > out_free_4:
> 
> Do you mind removing one of the two labels?

Ah, I meant to tack on a patch at the very end to clean up these labels once the
dust had settled, e.g. to also resolve the "err" vs. "out" mess I created (on
purpose, because trying to describe the "out" path was frustrating and generated
too much churn).
