Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D697A24DCF1
	for <kvmarm@lists.linux.dev>; Tue,  3 Jun 2025 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748987222; cv=none; b=nZoUFWDag2mg/zilrzi3iHCFD7xe8cj5DEKpcIASrFhn+7mQb3DhR716vqC6hwYHettqqIOVz0oRWsNucbYn20/Q/MViTL6H8KvrBks2EHjtrgMDQMtGc9ulo2/6+Z2/so4L2OUps5x0aNIkaZbael0CVEXCQRPQhXeEJj8TElI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748987222; c=relaxed/simple;
	bh=7OkVmia+kAhC2psjz5g/UQyEwFQL6hlzlynJfKibJrY=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=PENIxUmfrmMe8Fqgo8Deiv+Q5kRI4fHUuyucUwY2CXclCTiXw+4fN2bQ9gm4yDrsH2eg7ApD+v1zh12XCzqUBgmFD8eEsoa0sJLPMkkg6r2XMWUSWVVX0QqpcvvemNMYKERELVJ1BUamTpuNEhdqOSAXLMhf/JkDn05cPgbYM3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dsXeB7Sw; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dsXeB7Sw"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-72bc3351885so5778299a34.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Jun 2025 14:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748987215; x=1749592015; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LccXvjPYPBUKmolpHX2IrRx+++KKrUgiEoyHX8qZbOw=;
        b=dsXeB7Sw+s/E8nbOBBexMU2As/cO7x68OW3QvgaI/X15yzAtVaqQRGx4AEqnAUEZEi
         cbKFx+dbUB/ICue+cATYpcGqxr+7jf/oTPMS46oNLgEt9Z89wJdPNCac6vy5i9rvt5Pk
         6vS2gVoCw5M8z71wJ27Lh/pJFsgHx06maDnReSGVGdckFo799SXNDKZqdQ74TGhNWbhg
         HcBr3vbBZCvicXINP3wKL1eaRFMgyXvsV6r3/Y87rjPEj6tsLJcQlFYHgs3I5sbXBE5Q
         bkzltiB7KjRj6jzPOneREH9kVvwJulZ884L7/RLTflfNkLaWjuwJQNAd07ZdHY0AkJq5
         nXHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748987215; x=1749592015;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LccXvjPYPBUKmolpHX2IrRx+++KKrUgiEoyHX8qZbOw=;
        b=j54XamQULTlUk1nd+zuLeq4A+x51ZPdkPIqlQloCcHgqlBdqVyWhX4oLJg7xM4DoeC
         yADGmCReW1xPMIaYCxzXskM28neTT0gSOWXJ3mdGwfbOo47MkujUacc/yR3hOk1KWiId
         d55I5k04E2GzsHEAkqE0nbT5gwb3MxCKzWF9yqRQbtgRxPBLuKshLOiwpvC/ThQywtW0
         kx5xvBpp5wZrBFeVEYzzzYNRwGAVJbzfFH4rMrxmQDyDOkFMzUiJQulpXUsnZEE+XqqS
         JsEakmgexYAQ7OmZEo6mrXrZtq3WFrvs0b08x9umz5wxY8Q7Eibr813ftIlfOPx9HFO5
         z46A==
X-Forwarded-Encrypted: i=1; AJvYcCWW1k/feJ+RNQaQFgG45AgmLtcFRkDX5M2pc+TC9a78jqkckFud26nP7xTSJ7r5bZSyWVlYeCw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxPaiKQPl4MwVWov1+KOdHGBKem2jDMkk+K9CKZgyNn07wZb6cZ
	l8mDEoQmk6mBWTGJb0glrvaOo4NGWKhsI90OzVdpNsLnjuJ3kWuHTpk06PHJv6xWkamVn38PFHp
	xMlJMSgtBICnS7d345+aAD87jBQ==
X-Google-Smtp-Source: AGHT+IGVKt5ILqjSdW8OtKLqE/y3WeywMj3vX4/DzsQoxvrjy7RrNHS3PkxJz64AV7HAzQffHQulShSVI5b7iylTEA==
X-Received: from oobdi8.prod.google.com ([2002:a05:6820:1e88:b0:60f:868:60e1])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:4882:b0:735:ebf8:b241 with SMTP id 46e09a7af769-73869d7c158mr529938a34.14.1748987214770;
 Tue, 03 Jun 2025 14:46:54 -0700 (PDT)
Date: Tue, 03 Jun 2025 21:46:54 +0000
In-Reply-To: <aD4oS1_tnMPlgDJ6@linux.dev> (message from Oliver Upton on Mon, 2
 Jun 2025 15:40:11 -0700)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt1ps033ch.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 16/17] KVM: arm64: Add ioctl to partition the PMU when supported
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, 
	maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, mark.rutland@arm.com, shuah@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> On Mon, Jun 02, 2025 at 07:27:01PM +0000, Colton Lewis wrote:
>> +	case KVM_ARM_PARTITION_PMU: {

> This should be a vCPU attribute similar to the other PMUv3 controls we
> already have. Ideally a single attribute where userspace tells us it
> wants paritioning and specifies the PMU ID to use. None of this can be
> changed after INIT'ing the PMU.

Okay

>> +		struct arm_pmu *pmu;
>> +		u8 host_counters;
>> +
>> +		if (unlikely(!kvm_vcpu_initialized(vcpu)))
>> +			return -ENOEXEC;
>> +
>> +		if (!kvm_pmu_partition_supported())
>> +			return -EPERM;
>> +
>> +		if (copy_from_user(&host_counters, argp, sizeof(host_counters)))
>> +			return -EFAULT;
>> +
>> +		pmu = vcpu->kvm->arch.arm_pmu;
>> +		return kvm_pmu_partition(pmu, host_counters);

> Yeah, we really can't be changing the counters available to the ARM PMU
> driver at this point. What happens to host events already scheduled on
> the CPU?

Okay. I remember talking about this before.

> Either the partition of host / KVM-owned counters needs to be computed
> up front (prior to scheduling events) or KVM needs a way to direct perf
> to reschedule events on the PMU based on the new operating constraints.

Yes. I will think about it.
