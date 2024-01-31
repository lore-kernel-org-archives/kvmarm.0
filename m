Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E9713BEBA
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 23:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706743244; cv=none; b=kMP56Xf+e+4Xirjsz/xTC2dNSkRMPXIek9BzYbUR4GzZ0xGl+C7QzcHbH5pTt+PRPLkTHec4r6boH8DfbZG/fRUt4xkYxwI/V87ND+56qUrm62Wb7z7cd7TsdeiE+L+hcTytXWkR/BLzG1hGXt8tOX+sADDOaQvj6j7QfvMAmOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706743244; c=relaxed/simple;
	bh=20/LowDbsSa6ybMupsfbqBknR9K6SfsjkkIXgL9bQ6g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ubZjb1X3GaaCoIf78N/wNAzcN36Iul3/EfonWpZZUGqKJQqsQ/u8C1kEGk/aipq86RxpPhyCGWrBoXoGYgFVWMiXxMIcfejNMa0OYJHkHMe2OBR1EPGPaUI61PL2B8IhwQWxJyLJmsmeYtC+Tk0jzGERQHSbXtCiM3Z6HVqdPCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lKbH3RSU; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lKbH3RSU"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-d9a541b720aso531166276.0
        for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 15:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706743242; x=1707348042; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4LraT2XeL3rEGwAPZd0fqZsj1phEA9uuSczA3YvOZb4=;
        b=lKbH3RSUMOaFx3aTvXD5rt96E9HzB2bOhHI1Gf0U1tCs4uvqacmdiMrPPOch4XRbmY
         TPleluDs5+Gh3ZQj1dEulvOM4iRt71nMqFU7vRepy49rOeyWYlD+32L1JIiK9reQB8FO
         c4XU8r4Qf93aw8w3vdyLA7hw9AvK1ZEftgQgOCiEuidEjEFwvxbMaAoINE7w9UkPAZWF
         J0A5x1lDBvEpo3o29WW2FIyKnjX8w/ViD6OUxgetlfm83POHMufRspAdC7QCmq4mMlw0
         OXjyDjMpk41BmHMYAC/YFmE9Z/UjHuyEz1MMwaml6FAQJDGiars0XvtTGHdK49C+ybTL
         zJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706743242; x=1707348042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4LraT2XeL3rEGwAPZd0fqZsj1phEA9uuSczA3YvOZb4=;
        b=kXgtHuS4SsBInnPFJ2sey/0RQWNG7CTDSTcuQ0br8CDvUA7j7qbBlcDZn1iPHzx49k
         hN+t1kv6YRxOeXW0pt4X3AoPuDczosr+j7zGtI0VFDiiCEIxhss86qJh90srn5oc0nt9
         h4MsRYuBXzR26uw7IskD3TMJ1Ps7HgrndMuHPwC7Ia2hlJmtObUZVgwe9oHMiUQE0hNm
         BZDF1s6cglfxmXqUnpO5VkPMohuhUkP2nHyDfnZBtxdc/d824V7uX2L92p1+QYTx3Kez
         GQLgOHcTdK3x2YEjJLO+mqaomVLxvfSU3YRVaf8JCl9bPDdFOGeGY9nTAXIVDtODrlXQ
         QOMQ==
X-Gm-Message-State: AOJu0YysCEhIT/cQgdhQ3di/ie0cmbH8wYhJaUfR0iv1bIwVQp4tMhW9
	rd2QheECVzA7oUihpEsn0zCSk01A6aGPt3r0owUXPzxTQWVPe8TUC9I61HKM8zTcBoLOsMPE5cz
	zhg==
X-Google-Smtp-Source: AGHT+IGN/AGCqkdJr6bpKzd1JOQ/JVcPRAqedMYNyR1G7Xg4nBku4fs5oM4yJkJ+BZj9xMDEHO8Wuiy2xjI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:920:b0:dc6:55ac:d08d with SMTP id
 bu32-20020a056902092000b00dc655acd08dmr832536ybb.5.1706743241894; Wed, 31 Jan
 2024 15:20:41 -0800 (PST)
Date: Wed, 31 Jan 2024 15:20:40 -0800
In-Reply-To: <20231102155111.28821-4-guang.zeng@intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231102155111.28821-1-guang.zeng@intel.com> <20231102155111.28821-4-guang.zeng@intel.com>
Message-ID: <ZbrVyB1Pj9KrH-Cl@google.com>
Subject: Re: [RFC PATCH v1 3/8] KVM: selftests: Add virt_arch_ucall_prealloc()
 arch specific implementation
From: Sean Christopherson <seanjc@google.com>
To: Zeng Guang <guang.zeng@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Zeng Guang wrote:
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index a18db6a7b3cf..dbaa2cf83c1c 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -917,6 +917,23 @@ static inline void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  	virt_arch_dump(stream, vm, indent);
>  }
>  
> +/*
> + * Virtual UCALL memory pre-processing
> + *
> + * Input Args:
> + *   ucall_gva - Guest virtual address point to memory of ucall pool
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   Processed guest virtual address point to memory of ucall pool
> + */

Please omit the massive comments, they are yet another misguided remnant in
selftests that we are purging.

> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 6f4295a13d00..525b714ee13c 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -388,6 +388,18 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  	}
>  }
>  
> +void *virt_arch_ucall_prealloc(uint64_t ucall_gva)
> +{
> +	unsigned short desc_cs;
> +
> +	asm volatile ("mov %%cs,%0" :  "=r" (desc_cs));

Strictly speaking, CS.DPL is not the source of truth for CPL, SS.DPL is.  But
that's probably a moot point, because I again think this is a hack that shows the
overall approach isn't maintainable.

Can you post the actual usage of userspace selftests, i.e. the "full" series?
It's really hard to build a mental model of how this all fits together without
seeing the actual usage.
