Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8646E359A9B
	for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 15:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792250718; cv=pass; b=GjZW/wr0YloO0sm6eWIdhI/RYz/BI3VWZQOzGZ7isuW02qe9uX0/pM8Mg0sqCG4Ls3j7Vy2FpblR9XzwUfCoYiEpm/EvejHrmmZWdzPSNjMgDhqeYUSae8wVS6TMCEsmMrlYJy2pkPTgR93D/rhRep6k/OESzgqCSzKAKUQcICg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792250718; c=relaxed/simple;
	bh=Jm8AzdPrPR6BhXQyJz2nZ42hfc8fkKPUPVq/AoDXHaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b4rGHywkStUcv5v/gAGDSjjzAU8DtvOZQc5bCdMJ9FNCqX85zo5dJZYhi9CXa0ZioeDPeW34BEmouSrHyDNhHbQBVIRlL67k02KQc0+Zte9sTly5VGy3K3tlAA+UG1SsOXG7vSAVJlGAKez7HATjvtkw5APnLznX/Qo9vRgOjjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TNvTNfQg; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TNvTNfQg"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-53381e53b80so10275781cf.1
        for <kvmarm@lists.linux.dev>; Sat, 17 Oct 2026 08:25:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792250716; cv=none;
        d=google.com; s=arc-20260327;
        b=gMj+Z0ks0rOTVvlkovZ9DvB045SnuXKZ4iRQCfV2XtFglkb+es/ZXtxPljXPwOaBbQ
         EY/ashZm5ABJrMHi+4HUkGJmSMmX2hzZT96Z6kRveV/L5Jc/tIxwT+EcGMQa4poCYV51
         tbmGuuJTQtF/C0bAskwzW1vA6pM7H6A6UxpUjrhFEjAFL0OQOYRt4FD9vDfRvGSQitUO
         jCTCFbTH83PSlv8lCiqMv0/nV4RyMYdPot3Yf74UN2fjerGSGN2qS+I+2XQSX/m5S/CB
         Z5am/0zg31cHAmzP4HWgs5NvlSW0cSjS6faR0tO+2OzoEXP723svGJGUzDm4jkJmnBUO
         a6dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cBiNZFwCvoEsAVFQ+85lVVDF8nZW55yFDyjuRN5OJEE=;
        fh=Agrz8sg+acyaGKC1iM9y7czNziKEeF0UYSLnabEYrdA=;
        b=DtGFq6oFTE6w9oOodE1MkSKkvuITanQ4sERqdKP4hrTuwrpfSNeykNcZMrll6BRIYp
         RsrayX4LeiovAYKtAjsmZvNpotXxQ2Lnsih8CpT8y3d08ZKGYtuZ5duYXEDpiE8zSPvL
         8CuxhQc7gBmW9GNk4EGfhHNISdiBToPB/zpsfRFwfh/83c+AQHHtiMJfD9maTNr5hlEQ
         ed7hKWlup+ph4n5SSDXB0ucBXqsNzjMX+4vgZDj8F7L6i2wojhH6N1NKkK1Vbs46CeKc
         GT10IjuSBlYG5hB/0gO4L3AuODVF8NQ14o0xDGEpQvtqo5h2PMEvBLjVTqC/heTprCrj
         RYdw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792250716; x=1792855516; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cBiNZFwCvoEsAVFQ+85lVVDF8nZW55yFDyjuRN5OJEE=;
        b=TNvTNfQgrVqftZU52z50fM+CX2Qr3JNttkGI9hLMW0XqQHXpYDIZ5viZcw6AsLbufE
         V0r97ytQwEGtSK35YnGlYGY3M2aDtLPwT5OCkLYE8nNYj/4lsoHVKK+dufbFa4W6nlE9
         vV7ptqsFz7oFzBrKc5K0GHoFAJ2Wljo5JkoXheZ6kOqPlmFm8sD34kbm0WftnNNeR32J
         SxiPqcEcHDPJYQ0MB2N51cHmUASaR9F32iud5faLjZc/gWjaH9TrwoLlIQR/GtKW0N5e
         js3+0zH4HtI2GZmOOT7eMOztfOoZ+hmrrbVH8e3PC2bkZtXwyOoW01iXXvBU8o8DmM4c
         zIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792250716; x=1792855516;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cBiNZFwCvoEsAVFQ+85lVVDF8nZW55yFDyjuRN5OJEE=;
        b=YhtTyaUc5NbhAUg8UQ7iXlPbs3382JVxwhS+Kk8V8ZAUglBjLEYvf3iosO6CUy9t/0
         g6o6ICdFrW9iNN3eH9ptirr2z+I3gdjdiJkq7Ed6cvnDvrCkDiefIuF1R63+J+fWqrY7
         1/Hm2eJag4cGdCzS/bs4ysjh+h2t046O5X06yLEXUJAi6k1cjyicRUfxo69k9uRuy3Ua
         W6lmY4G+UfI94yJPZv0JsUm677984FH44mxpAu5hjHZ4euv5FTIhbCmVUBl6fCGFXxtM
         dFCG0ds5GsGRyAKjMcVA4cLmbGcmULzNpkawwRGdk9EISsq5kPG1YWZtxT8Bj+aA6gYy
         QEFg==
X-Forwarded-Encrypted: i=1; AKwUvBzTB21uYawx4HIsxCNKlYgK9n7dA+qPMz1gsOnri9t10GU+QN5useXP7vhaPMRmLJSi0Au77G8=@lists.linux.dev
X-Gm-Message-State: AFq9FYIXqA2zX4gM53mOGp18Y0E0yFnWlqQwaw6R0BsFmgeJghFBgekg
	krCXH0UXwh/TYpWSh6bX+Xxnjo+yQjuv2446SS1tcBXrNi5kYtW10RXy0LZm4yvFltywRAtjmJt
	K+3+tYAv86wxpsc3Xm+0jZQkOMqn8+NM=
X-Gm-Gg: AYBFou3bueXy+DbbHsApb8H2eSZy2q9L4VwG1fI9R33uNNVuQgN0BjXd/paluzSEopB
	frtCnEOhwnoPTM27mwTlxs5SfJ4ckXcbHZtXm0n2g3XSaWBECSqcvHZwVLDvTe1gYyDsiHOmTn2
	4mVzvKor6+hIEHUFte/T50a7PaZQO0wLe8AG9XWB3XEsaiG++tV+afiN+LXCtGN+KOBTd498BQ3
	FBBM3Rf5sIP+398JWfnhN9GZjEztZx+apKcuOnLEDQkhuQYGnPbZOck8gWhs8/s8K5LH343kFmL
	c81MyscMZD0B2NPYhNZWMhKPb/bQV93vwqwvX3rFL2p/V1k/MvLhPmL5SmVth8p6wl3EznEYiNn
	VnSwLqwtA6UHDB1L9RTMPNWH9y3Cl938nnPehRcRWi9koVw==
X-Received: by 2002:a05:620a:2783:b0:93e:d051:8f19 with SMTP id
 af79cd13be357-93f29ced575mr485953085a.40.1792250716444; Sat, 17 Oct 2026
 08:25:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261017110213.46199-1-tharitt97@gmail.com> <20261017110213.46199-6-tharitt97@gmail.com>
In-Reply-To: <20261017110213.46199-6-tharitt97@gmail.com>
From: Tharit Tangkijwanichakul <tharitt97@gmail.com>
Date: Sat, 17 Oct 2026 22:25:04 +0700
X-Gm-Features: AclHuK8Bu8EDo40zZmiyUcWdeJAzBkx4-shpMZtTbASYDmEugT246DxrXg3J2Ik
Message-ID: <CACak8wNa-dbNMGO=4U=JpTqSYWdk9MC+DWZS3WxRwuRRvC1T7g@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: selftests: Test protection of the ucall MMIO region
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel-mentees@lists.linux.dev, 
	skhan@linuxfoundation.org, me@brighamcampbell.com, jkoolstra@xs4all.nl
Content-Type: text/plain; charset="UTF-8"

> +#define CLOBBERED_SLOT         TEST_MEM_SLOT_BASE
Upon self-review, this should have been hardcoded to 1 (to clobber the
reserved ucal mmio).

> +       ret = __vm_set_user_memory_region2(vm, CLOBBERED_SLOT, 0,
> +                                          vm->ucall_mmio_addr, slot_size, slot_mem, 0, 0);
> +       TEST_ASSERT(ret == -1 && errno == EEXIST,
> +                   "Expected the ucall GPA overlap to be rejected: ret=%d errno=%d",
> +                   ret, errno);
This should have been errno == EINVAL check to catch writing to the
exiting read-only slot.

The earlier test accidentally passed because it used a different slot
ID (=2, not reserved) and received EEXIST for overlapping the reserved
ucall GPA. It therefore tested GPA overlap rejection, not the intended
rejection of overwriting slot 1.

I will fix it in v2
