Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A74E2236E9
	for <kvmarm@lists.linux.dev>; Mon, 23 Jun 2025 22:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716272; cv=none; b=BvOhIDrwgIaFG8vA3sQOs1FKXFSMVM4a8VRfDghf2PkbkVP/vjuXPW8YN+1jfb/NqwxM9eEBsZ/aTB9OE4UxW1sgvgp8fSXq4UCp5QjpnP4FG6YidqVinhhuto1aQNl4+daA/6iR3KBgENSlwG0ZS8LwC2IfAKykWQkaS8tzwEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716272; c=relaxed/simple;
	bh=f/UyJP6vQx4TVd+AM6JjhbEHevJGuFxqlVA/YhTlF/s=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=JPbb4DClVRQdPgm25JQIlMV5leiIT1H2BkjW2NVbYyJ46suLMOFlAGijSBFGR9Xen5xdCAOGpt+65ICSr6j+ZN+H4Ykrc+LlqqVMEXaqYzdwv8xAvFxUSd01FYZ/Zt16n7UCQi/aOXfvmDSG6cZqkBGvG5YU15lr3IlF8z3oyRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cnavarL5; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cnavarL5"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-735a87c1601so3273185a34.1
        for <kvmarm@lists.linux.dev>; Mon, 23 Jun 2025 15:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750716270; x=1751321070; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XtLVtTxbmHrCBpSNsrNTm3SDGLbs218ttvI0elQ1Q/A=;
        b=cnavarL5BmELpOR+Ks4jMdECtFvci0MB0jC6C6tvIspvsxZ1NUvvVk4L2AunBNE+uy
         bAfBSYezrCsS8mFbymMW2g5IxVg8aNlAFCoC+xPmNRKDi/CYTf7AkRG/q9lIrM2MRc2X
         YKSUwJBvF6dulKyTv72vMeX9Gwzl5aYZkmHO6jHjIs3IrjewHPV1cfm6ilp4rBy1FceW
         2zlBH+2eRNYs08m5oFLyZhQrW/ibc8ccnbJTK9QO3qCoPT5tmgQsQgZ2Bt4ndzxfyXI/
         /0++FwRdJ2DOUplObW/LFI4jAeIG68I54+tb5vvg6H3ZclQ4zT7Srg0g0UGq4mEYJ5AN
         u0eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750716270; x=1751321070;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XtLVtTxbmHrCBpSNsrNTm3SDGLbs218ttvI0elQ1Q/A=;
        b=YY3VGTnyjDnslgGwdZ2QWYbm+kjti8tpwbr7F1HRKyKC14TisBOSPzDMONrunfoEef
         iBTZRyQQBBQQIP+msb7gAZDfPaHEt47N/6z+ZOuaSiS5mMh5e2RuBSiQsbuc3W5ViZ4L
         s+8bPSQ8ZxsTxIeddFXexzppa22IR7EzgWV4SK+Vo+ip0KF+fKGHtuIg/Dzzzz8Scjhf
         dju74gtH4+lXsX4ES2uBKL1qmGj+Gi5+QME123C16Ob3OS7fHWQJ8zY/t/4whDPHKhLQ
         nNqCAjA0uwAAyKxUijNpfF9L37rAFYz2Zh+8VZ/04eloZKOAlUV8IL/1wgg6rODa0ok5
         t87A==
X-Forwarded-Encrypted: i=1; AJvYcCW2/x3EJTVCO5yDwMcDCVyY8nQGD+gUR/VOop9EPBXp56isfnmMmh5esIws/pwE3PE/Pdn3OBc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzSfza5sqoybF1lkYkBsCFm9liBbeuYMMNP1za28MbkV18MGdc
	3cVLwUqudpfshx3jKntPo19tYm2PWPXcC/1A6zsCu1thnij1IZLEGAy82nitAqGjQQbx4hbIfBy
	DBI4EgIIkavYf7pTzlz4rno2T/A==
X-Google-Smtp-Source: AGHT+IFkDmfiUvq4ze8ArvjRNaiH+ZXYtlXJVVDDWXvRxwvqUxfAjNMLJj1dksngCu/MtTNVejcjEvPTGswxYjYzFQ==
X-Received: from otbbx10.prod.google.com ([2002:a05:6830:600a:b0:72b:88be:33e6])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:d8a:b0:73a:8d4d:426f with SMTP id 46e09a7af769-73acbd8e287mr1029204a34.2.1750716270304;
 Mon, 23 Jun 2025 15:04:30 -0700 (PDT)
Date: Mon, 23 Jun 2025 22:04:29 +0000
In-Reply-To: <202506212205.NmAR3sAH-lkp@intel.com> (message from kernel test
 robot on Sat, 21 Jun 2025 22:56:09 +0800)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsntjz529ksy.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v2 05/23] KVM: arm64: Cleanup PMU includes
From: Colton Lewis <coltonlewis@google.com>
To: kernel test robot <lkp@intel.com>
Cc: kvm@vger.kernel.org, oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

>     drivers/perf/arm_pmuv3.c: In function 'armv8pmu_enable_event_counter':
>>> drivers/perf/arm_pmuv3.c:680:2: error: implicit declaration of  
>>> function 'kvm_set_pmu_events' [-Werror=implicit-function-declaration]
>       680 |  kvm_set_pmu_events(mask, attr);
>           |  ^~~~~~~~~~~~~~~~~~
>     drivers/perf/arm_pmuv3.c: In function 'armv8pmu_disable_event_counter':
>>> drivers/perf/arm_pmuv3.c:702:2: error: implicit declaration of  
>>> function 'kvm_clr_pmu_events' [-Werror=implicit-function-declaration]
>       702 |  kvm_clr_pmu_events(mask);
>           |  ^~~~~~~~~~~~~~~~~~
>     drivers/perf/arm_pmuv3.c: In function 'update_pmuserenr':
>>> drivers/perf/arm_pmuv3.c:757:6: error: implicit declaration of  
>>> function 'kvm_set_pmuserenr' [-Werror=implicit-function-declaration]
>       757 |  if (kvm_set_pmuserenr(val))
>           |      ^~~~~~~~~~~~~~~~~
>     cc1: some warnings being treated as errors

Looks like some dummy definitions didn't make it into a non-KVM config.

I fixed this and a similar problem I found with kvm_host_pmu_init().
