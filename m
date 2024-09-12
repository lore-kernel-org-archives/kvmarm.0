Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B40F18A6A9
	for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726132294; cv=none; b=hmtP2ZKjVjkQlNAqTSbms5oAxiRPApG02/a5YeiT4foj19I8oJ6pgXavgCq6vOYHa7HNH7Tyxq1vVgxrDGkDM6W2YfRrsNTm9Lbp/yYEROdmzWjVlmiL+eJQsrnSMhnAzsCHzb1v/Vrtc9Rcrdbem6d0MtJWYmBXG6UyRiwc1+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726132294; c=relaxed/simple;
	bh=9rBEz/3jZQ2qE0fBtpr1iiAKAP97cuv1yvGYvb/WCo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0hnb5XmbqbvmQg00w85IMXaZTxRivi9hxm2jl/0AYYM1xcCEcY713PvvlCr03NUd0W+ntOg00hV9sXz6HHkvo6A4bFa8CiLVskU/kd6CdwyuLFlKZNnsoVJNwjsEaS6EZRZ1pU+5KzryCNbggmMHfy8Rf8rOeHn/97ZuXFcW08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=JqF7Pc9c; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="JqF7Pc9c"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c3d20eed0bso804165a12.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Sep 2024 02:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1726132291; x=1726737091; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KDYukj80mIHPYCgHSB2w3O30EP7PG7QCtWy9R/+4O+8=;
        b=JqF7Pc9cHJrS9dHDi1aAZfa0WG/9LqTOg9/WrgP1Vm/XEUYpRAfPQB26+/66UJH9PE
         KjeUOoNabKajrY1h10DnwsQgEwm9z+fX8/f5/fIyld0QgmcpotEs48z7AoTX49jCbdx4
         7sp1nlrv4qZA6JqV8NmHhYERTKpRzmbSOmLrgjgEjolOAk96I4Da/b+Fdq/AKEC9aIkp
         9ODwgQ4ZUrv65ZUno4+ehMgBY78eNb7OPB6ISUlbNIx5W1gKcrQvNhXznwdqxcgh58e5
         Ve+cXsxPR7DtF5Zk9W+j17Ba/oSoRTXq5syi5YBNzuU+Rm8DJywNeH8Zq1umZ0TrdUzX
         MIRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726132291; x=1726737091;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDYukj80mIHPYCgHSB2w3O30EP7PG7QCtWy9R/+4O+8=;
        b=VWRSHMt0ifZrnf6e+VXlAYB7XNyb5pO2tXhr0QTttAlUkMex33m87WtB1CSkdWMujb
         5Juje9ITkAff105aHWJ+fAq2Mqleyjx4Xx8ch9p5JXDA8etcwpg3ZkIMmFetCNCsQQEJ
         r2wSzrzcjJJO+3p+EWojKdBos6SnteDllZY+ONsucw/PK50E+sHlw3ffcVGAkmyrWU/X
         D9WVUifSI2W1zuY4qtOS5n13kIRixkGLBRAap9amzaEscaBRYYMTAl7Sb8bF19kSiZ98
         CPtfMN7M4XdeYx86rFTlF85W+z9LWx2gFGvhfXcfcHXao3j5yf2fAkw0jK3YxUONQe+U
         RSXA==
X-Forwarded-Encrypted: i=1; AJvYcCUFW74KaoTtuKT+1ItGfZqbJmAA3yyhqfa/nYrpd6tqej67NtIZbVFufgZ49AoKijyoHzlkJfk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8GUNz5wwjlxCcqsNGJQmKnS3wxEd/5jOBU5PUBRkaad1oNcSs
	fJ5QaT32R5edY8kBpA/UAeOycCBw7jjy2C6FIcaYW4noR+RTr35CGMSKI7NQoYE=
X-Google-Smtp-Source: AGHT+IFYGstY7Ee7hZURlNK3JZABLF8M1RnLjnl2KXSy/Qm7bwNeqA+fGuOPSyrnOfiIz4Olnre2Gw==
X-Received: by 2002:a50:cdd4:0:b0:5c2:1f74:114f with SMTP id 4fb4d7f45d1cf-5c413e54913mr1194735a12.34.1726132289759;
        Thu, 12 Sep 2024 02:11:29 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3ebd467desm6239500a12.40.2024.09.12.02.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 02:11:29 -0700 (PDT)
Date: Thu, 12 Sep 2024 11:11:28 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Subject: Re: [PATCH v2 02/13] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
Message-ID: <20240912-a3894135370bf3fe551ed018@orel>
References: <20240911204158.2034295-1-seanjc@google.com>
 <20240911204158.2034295-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911204158.2034295-3-seanjc@google.com>

On Wed, Sep 11, 2024 at 01:41:47PM GMT, Sean Christopherson wrote:
> Return a uint64_t from vcpu_get_reg() instead of having the caller provide
> a pointer to storage, as none of the KVM_GET_ONE_REG usage in KVM selftests

"none of the vcpu_get_reg() usage"

(There is KVM_GET_ONE_REG usage accessing larger registers, but those are
 done through __vcpu_get_reg(). See get-reg-list.c)

> accesses a register larger than 64 bits, and vcpu_set_reg() only accepts a
> 64-bit value.  If a use case comes along that needs to get a register that
> is larger than 64 bits, then a utility can be added to assert success and
> take a void pointer, but until then, forcing an out param yields ugly code
> and prevents feeding the output of vcpu_get_reg() into vcpu_set_reg().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/aarch64/aarch32_id_regs.c   | 10 +--
>  .../selftests/kvm/aarch64/debug-exceptions.c  |  4 +-
>  .../selftests/kvm/aarch64/hypercalls.c        |  6 +-
>  .../testing/selftests/kvm/aarch64/psci_test.c |  6 +-
>  .../selftests/kvm/aarch64/set_id_regs.c       | 18 ++---
>  .../kvm/aarch64/vpmu_counter_access.c         | 19 +++---
>  .../testing/selftests/kvm/include/kvm_util.h  |  6 +-
>  .../selftests/kvm/lib/aarch64/processor.c     |  8 +--
>  .../selftests/kvm/lib/riscv/processor.c       | 66 +++++++++----------
>  .../testing/selftests/kvm/riscv/arch_timer.c  |  2 +-
>  .../testing/selftests/kvm/riscv/ebreak_test.c |  2 +-
>  .../selftests/kvm/riscv/sbi_pmu_test.c        |  2 +-
>  tools/testing/selftests/kvm/s390x/resets.c    |  2 +-
>  tools/testing/selftests/kvm/steal_time.c      |  3 +-
>  14 files changed, 77 insertions(+), 77 deletions(-)
>

Other than the commit message not being quite right,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew
