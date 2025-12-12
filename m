Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A4B2E8B6B
	for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 22:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765580109; cv=none; b=lcCtW55upVfhNehENF3alEOy9u/Baa0CPo5TRPZILSgwVUaMXNDcjj+GhHTrSj94STUQh7dpGZtCtvrWgsbuXlp7OE/Qe0ZST++U6r89VH3VtgMKWRy2zsETTvuFtL2+AcLGMy1xiF2EO22Db4vV7lpcE7geECXZaD+PeAuCPsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765580109; c=relaxed/simple;
	bh=bIF6Bo2epqbYmITgIckR0PAV4EA02NE1jjQfw25p3QM=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=qtdxH8rTgaGQ9q3WY58E0ykaHAU8E8fxp6NUiOcxhMyvLwKIReZS9dlN0CgDIgCupKckseTN4TJ0f3kxjXOSo2YyCZbZhI3c2DHpKdbv3WRrR61Vv1u7pYpI1vQe/KCVy7s66YKXaR3jD1hMJ1K63l4JJqvmDkvCtam1EHpoJ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uu1WNMwP; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uu1WNMwP"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7c70268301aso1532157a34.3
        for <kvmarm@lists.linux.dev>; Fri, 12 Dec 2025 14:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765580107; x=1766184907; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Gf9nzt/AIijA0v6SQzCygaqS4FyyvskIif7ML2SRzkU=;
        b=uu1WNMwPPK/CRehG2YSYycegE25eUIDsf2+wTvGwU/NJsvp8XvRzRCXJwDb7saLDlv
         eY15lCE2CVATDA+k2GzIp4c/9T+sgNZM9Nma+3EhecmvsmufkdqNbUMjDokq8ZNy/Exj
         NngAMGbNbhwnd77oj5y04xRJGxtHmojAvISBHY31ogrdd/sO/ljUMpfn3LB0gwB80nrY
         Upuwkjo5UR1uvNzFA97NcsR/ZLtx643Ut3Yc9Gk0nFXUWE5vgno2y7wCSUlgxbHBTJZi
         f4mD4jlIw09+as95ugRBCQkSAE9Z6aNPMH1koNJYPAkVCt4DRUnWGcQKN1QKCjC/IOIy
         +7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765580107; x=1766184907;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gf9nzt/AIijA0v6SQzCygaqS4FyyvskIif7ML2SRzkU=;
        b=e5ZudyoFnFFQtwT6bL1TpkWv2boMHHL1sIpRn15SBhq3TNFoZ4ENnKBtxAyPHFJ/7j
         62k6586oOqG9ZVRGcqkFmbZUqGEXk6QYsu/yFPhrjsGWk8T6pWBtQetZHG07q19NTXMW
         eEXu6k+0TcavqUJs0WD56azHT9afnlowW7xyD4X96MSTlxVW3orTg9glua6sX2nMyaqS
         04APBQJMPGXN9OCKZtVoGwjxFbxuaa4LVSN3KbviyZo2i8uX1WdAC5GQ/kzwdWgxu/7j
         l7QxItj8f5/Cy9G/iMetBVeNPMixroQURh7NVmAW7qn7iZgDWIQ/Kb07DvoeRUqtPUDe
         taXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZFxPP/keA4czF5413O5rfe+To4aY3vi8xc+lvW5coImN1WXc8F/oTBCx0fHEPcvY+BHibCSM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxR6C/slLJvoVNKcme9zzEttr/SqAmz8K9wGJfq2gz2KM/8ASNY
	oCsujg2EnUbMBMYLg5YFIrw4ZGnsLDAwqVCUAv6zF93iZm/xOwxyQcU98dsaKbjm2wYgXxLt0s5
	3IZA+5aG/DgerW2eVGGGmHxgOow==
X-Google-Smtp-Source: AGHT+IGW0I1EN/TmF7XRt1Ne1xEDcpx6Or2Kw9UCPmMzkWNCsmyBQjelpeiy18twJajc3tFWP5QaNlfD3CTKO6VqfQ==
X-Received: from ilbbd1.prod.google.com ([2002:a05:6e02:3001:b0:438:1345:e9c3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:162a:b0:65b:25e8:13f1 with SMTP id 006d021491bc7-65b4529af0dmr1939098eaf.73.1765580107018;
 Fri, 12 Dec 2025 14:55:07 -0800 (PST)
Date: Fri, 12 Dec 2025 22:55:06 +0000
In-Reply-To: <aTioEWHu0ZbFCjR6@kernel.org> (message from Oliver Upton on Tue,
 9 Dec 2025 14:52:01 -0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt8qf72tv9.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v5 21/24] KVM: arm64: Inject recorded guest interrupts
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oupton@kernel.org>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oupton@kernel.org> writes:

> In no situation should KVM be injecting a "recorded" IRQ. The overflow
> condition of the PMU is well defined in the architecture and we should
> implement *exactly* that.

When I say "record" I just meant "updating the virtual overflow register
to reflect an overflow".

Do you think I'm not implementing the condition correctly in
kvm_pmu_part_overflow_status()?

> On Tue, Dec 09, 2025 at 08:51:18PM +0000, Colton Lewis wrote:
>> +/**
>> + * kvm_pmu_part_overflow_status() - Determine if any guest counters  
>> have overflowed
>> + * @vcpu: Ponter to struct kvm_vcpu
>> + *
>> + * Determine if any guest counters have overflowed and therefore an
>> + * IRQ needs to be injected into the guest.
>> + *
>> + * Return: True if there was an overflow, false otherwise
>> + */
>> +bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
>> +{
>> +	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
>> +	u64 mask = kvm_pmu_guest_counter_mask(pmu);
>> +	u64 pmovs = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
>> +	u64 pmint = read_pmintenset();
>> +	u64 pmcr = read_pmcr();

> How do we know that the vPMU has been loaded on the CPU at this point?

Because this is only called by kvm_pmu_update_state which is only called
by kvm_pmu_update_state <- kvm_pmu_{flush,sync}_hwstate <-
kvm_arch_vcpu_ioctl_run after a vcpu_load.

>> +
>> +	return (pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint);
>> +}

> I'd rather reuse kvm_pmu_overflow_status(), relying on the accessors to
> abstract away the implementation / location of the guest PMU context.

Agreed on making some generic accessors.

> Thanks,
> Oliver
