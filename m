Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB9C28FE
	for <kvmarm@lists.linux.dev>; Sat,  3 Jun 2023 16:58:05 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1b026657a6fso28565085ad.0
        for <kvmarm@lists.linux.dev>; Sat, 03 Jun 2023 09:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685811485; x=1688403485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fD563CwulsYBsCRbMeiZXEqAZf28bpbXjXYl9VaY7hc=;
        b=pF6ZfHq7T5l8tFokkSNTb6TTd6Ye6x7tsjLJQr9KSp76luti9ceI8OH78+iAceFxGa
         NoE+0AHrVN4WRfrdNeTKbjeEAVsaZ5pFuT3eyol0PAUuZvcnITfBcgYgXyqvoa5dfKFz
         klwuEbfMcG8wgi4ZA+1K4gHF2097zdVzKrcdzmNqJfR2v3p4pK/sU2rFB7cRT5YhaPZY
         y0qKXDBbwOU46lYkBd5pVysSQZe1rhhRa1YNwDx7kgNuZ+3TFw2lBxgZQIaAUxuP1pC0
         jiHNwkE+YBprIHgcGC/dUSrYfcuTmrxuHxq9/43gaqzieWdevo+3BxWjTlHQEEbZ4PV2
         +Dcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685811485; x=1688403485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fD563CwulsYBsCRbMeiZXEqAZf28bpbXjXYl9VaY7hc=;
        b=Vt64HfrBLxX6atu15M96/ULXAHE78bzOBWd1PS/nlhMKH26zTsxaBqPd1w3lvJMeNQ
         T8zgYTOz5J4DjpUNF263WqkHvpcSbngM8bC7mN9Rj/4Jp6XCNE7Dgid0gPgWEs+TuHcG
         VQAuWcjjd4V6uNxXam+Rg76aUe8Y3Oqy9FO60PX+xRfyO3UBHtJeyGWqT1PAWbwVjdXj
         SiVlWXuNU6FDeHG9EkxSkOxU1vhi+6Km0gecXz/b69udkP5+N5R/KxB9yowP5Pss98lT
         xfA+50xuYDPPHxeBgzSKx29evNBBrjC9M6zpoKsy2eqSufbV8J0l4BCtQXd3iQl3kXEC
         PBLA==
X-Gm-Message-State: AC+VfDw1Lhv/fVVRvs4bJeqbTkTa5oig3aX5XrB4iauRkBcbfg2thXcM
	CaVqyckRbIWfMXO26vA7ESo=
X-Google-Smtp-Source: ACHHUZ5IKgb+gH993OmkKYdYvIAppWzeNOHH0sT3hZJoXPU1Cg1kghmJIMAHEoWJ5XwF+y858qAECQ==
X-Received: by 2002:a17:903:1cc:b0:1b0:2658:db20 with SMTP id e12-20020a17090301cc00b001b02658db20mr3275518plh.53.1685811484740;
        Sat, 03 Jun 2023 09:58:04 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902d70400b001a95f632340sm3433296ply.46.2023.06.03.09.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jun 2023 09:58:04 -0700 (PDT)
Date: Sat, 3 Jun 2023 09:58:02 -0700
From: Isaku Yamahata <isaku.yamahata@gmail.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
	robert.hoo.linux@gmail.com, jthoughton@google.com,
	bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
	isaku.yamahata@gmail.com
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <20230603165802.GL1234772@ls.amr.corp.intel.com>
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-4-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230602161921.208564-4-amoorthy@google.com>

On Fri, Jun 02, 2023 at 04:19:08PM +0000,
Anish Moorthy <amoorthy@google.com> wrote:

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index add067793b90..5b24059143b3 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6700,6 +6700,18 @@ array field represents return values. The userspace should update the return
>  values of SBI call before resuming the VCPU. For more details on RISC-V SBI
>  spec refer, https://github.com/riscv/riscv-sbi-doc.
>  
> +::
> +
> +		/* KVM_EXIT_MEMORY_FAULT */
> +		struct {
> +			__u64 flags;
> +			__u64 gpa;
> +			__u64 len; /* in bytes */


UPM or gmem uses size instead of len. Personally I don't have any strong
preference.  It's better to converge. (or use union to accept both?)

I check the existing one.
KVM_EXIT_IO: size.
KVM_EXIT_MMIO: len.
KVM_INTERNAL_ERROR_EMULATION: insn_size
struct kvm_coalesced_mmio_zone: size
struct kvm_coalesced_mmio: len
struct kvm_ioeventfd: len
struct kvm_enc_region: size
struct kvm_sev_*: len
struct kvm_memory_attributes: size
struct kvm_create_guest_memfd: size


> +		} memory_fault;
> +
> +Indicates a vCPU memory fault on the guest physical address range
> +[gpa, gpa + len). See KVM_CAP_MEMORY_FAULT_INFO for more details.
> +
>  ::
>  
>      /* KVM_EXIT_NOTIFY */


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
