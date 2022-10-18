Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3884C8A
	for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 16:21:16 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id fy4so33498791ejc.5
        for <kvmarm@lists.linux.dev>; Tue, 18 Oct 2022 09:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DMD6KRfAh8gLsTdSq1azk8KGRzliZHblOOH99fliBBo=;
        b=eBasbqc45ny3TsN5xHvPYR0nIt0QFeQUPu9c7yPZZOds5097P3BJ2iGt4wRvIS9tEs
         MQXUQQUsNjgY0fpAODB0YF3wYff2bSXANslnUInSERSXgNnTuN5AIVlIdXP/iz/aI3X+
         GpQJ3Rs0eYEM+gfkzYqhYJfC46Px/ETHHCZsR7P0im57GjJyGQG1iBRY1b88haggOhOg
         1qBG96EWS/D8Vm75+m1lJZ3sDzKcFMccO7Dwzdyd0eOs+FHM9TASIL+jgiicEDBZuNhV
         RwL9DybM9+ce3O9iDMzolgdPgxOhI5kXqeP1WGQ70AQkXlbD5KDc5OFbEUaBjCOtaGYE
         zozg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMD6KRfAh8gLsTdSq1azk8KGRzliZHblOOH99fliBBo=;
        b=KpZl/RHcOPAav1kcstql6BUaTmkhtABpoCI5WzY8lqy4hIgvU3cYYZJ6NNiEurbcB4
         8aVQyUhwIr3G0if7dL8AEmN7MkmQKLAPPTdcBnPNmaELHgzKJQwNgfFQNANEdgSwhpbC
         ga1ow+5a/LGf01YpxFWIHN3CKS3egIXrSZTynNC8vkRFO6m6dveThqdooTu5cRy6g5vb
         9WTRnMMEnNTdPUDaDsDmnkRcC2fVY6CJk9TMz9aQth5ekvKy9yNehGJI+poinYkNP7X0
         DcHeZyH8bAh2+VR9R1h/lXEnll0/Q+AkZW4Mm9+57A6F1vUFPMa/0Oniddis3r71GZQL
         Jlbg==
X-Gm-Message-State: ACrzQf0XlVZq0wK+LAbh4FzLIHBIUeEeE7mgq7o/RRUL9ZbbTcjqE7EJ
	KZBnppn07D/+3902F6AFPJ2IwQ==
X-Google-Smtp-Source: AMsMyM4R1wfcxR2Oe0g2nQCwfd6EAIfKtbPVegiEAjUE+BZ0OMN8V8O7plKwhNwKvZQiCe6VCI2RRA==
X-Received: by 2002:a17:906:8a4b:b0:78d:d475:ff74 with SMTP id gx11-20020a1709068a4b00b0078dd475ff74mr2983068ejc.131.1666110074863;
        Tue, 18 Oct 2022 09:21:14 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id fy19-20020a170906b7d300b00781dbdb292asm7716920ejb.155.2022.10.18.09.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 09:21:14 -0700 (PDT)
Date: Tue, 18 Oct 2022 16:21:11 +0000
From: Quentin Perret <qperret@google.com>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <Y07Sd6lVfD4IUywQ@google.com>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017115209.2099-13-will@kernel.org>

On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> +struct pkvm_hyp_vm {
> +	struct kvm kvm;
> +
> +	/* Backpointer to the host's (untrusted) KVM instance. */
> +	struct kvm *host_kvm;
> +
> +	/*
> +	 * Total amount of memory donated by the host for maintaining
> +	 * this 'struct pkvm_hyp_vm' in the hypervisor.
> +	 */
> +	size_t donated_memory_size;

I think you could get rid of that member. IIUC, all you need to
re-compute it in the teardown path is the number of created vCPUs on
the host, which we should have safely stored in
pkvm_hyp_vm::kvm::created_vcpus.

> +	/* The guest's stage-2 page-table managed by the hypervisor. */
> +	struct kvm_pgtable pgt;
> +
> +	/*
> +	 * The number of vcpus initialized and ready to run.
> +	 * Modifying this is protected by 'vm_table_lock'.
> +	 */
> +	unsigned int nr_vcpus;
> +
> +	/* Array of the hyp vCPU structures for this VM. */
> +	struct pkvm_hyp_vcpu *vcpus[];
> +};

Cheers,
Quentin
