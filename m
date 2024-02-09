Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035094C6D
	for <kvmarm@lists.linux.dev>; Fri,  9 Feb 2024 01:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707441260; cv=none; b=V4BB6jqoeUKx7iDsjommOBgkHuwb0BiDg7oW9vV1kEhDhAAcniEGy4QyqxkXDzSEuccGFhMdJHQr0LJvdBF5nrS06QNbbcnl83TU8PLf7yOlGqNBIJ3BNLd3eAfVLvxm7TnQNN2Mt/YYB09g2eVkeMzCQGrHJHZg50RobEWLtwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707441260; c=relaxed/simple;
	bh=w91A96XWL7bXEU1Sy7yi4pPndExcXO8TcSfVJwXM5fw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TvjZ00zluXrfaAQfVgeT41w4aQ72aQ7Ladjg5nHXkRYw6bf9qRkwdwr2FVRsi9ejljdc8Fmgxz2qZsLzXsYE74RbFW3BMGk4jVaSU4cTEFVI60t0lU+3XKbRrYgFqBgZzttuXdi7GGUO6kAP4lu3FI/X+8pATtRxRsFKPfivnUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MHdV64ZW; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MHdV64ZW"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-59502aa878aso180461eaf.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 17:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707441258; x=1708046058; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w91A96XWL7bXEU1Sy7yi4pPndExcXO8TcSfVJwXM5fw=;
        b=MHdV64ZWqUxcqDkEmG5ooDaYXDKRi7vperPF27q+jBVyZMXwVPpmjPRtRpOKN9XCr8
         1ePhpRI8YeWagGwLm/vaGvA8cAnG7WILVe0kndxvs/hopCBx9h3FckP27r8dAdECtlsY
         x801Ddd53vBNj/hW6vwsitFPCMkUvnILysKSmAepKwTTe9BfQjdDGSinDH3sJ1pQBNrH
         tS+hBY8+yPsgLet0WgY5cuhoXP4Bn90wb6CPUgXEy60FXdFnWKP5dlReI0h5Ias4KRrt
         siG/yni0KO5YmBm4Av2ksZj8YMEjkyVw/C7GSu0m49zzB2oO9fy7Xi02Ylfng+Z1i/Ev
         fJJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707441258; x=1708046058;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w91A96XWL7bXEU1Sy7yi4pPndExcXO8TcSfVJwXM5fw=;
        b=Kv56L1A0glu/xvcboK5ZgGAE3H8xz6KtjybpDsyJVP2ZGf37Zm6ilsdDdrUECOQ17A
         d4NpLvCkyFXyzIsh4yo9F97LV8xdML6A2wA6NzeHgN2LQzV4fjIc9fsLUVZKplvknCWl
         A4qQvwRImKfChbON1MO5XpE/GAErJEXjvpwBpDTl3hiS7h8fWBy8OfTDTWkluhGALYan
         yjOALku89zDNwZ9/2TK88xTFX3iKf1EQsrI3QjygW+5GMlzeZd2aaw75DfB/6oZiC/Yn
         ZNwPYe6YE8HffKdvQ9oOdVdQ+z7fPpPiJUAB0X3vf4l4iXidA3O717ZDHJqptXtRXI4p
         sWYQ==
X-Gm-Message-State: AOJu0YwaqbYdLi5NbzgbR94rkOBGY5MRG66AHv8CO7pWxZY2Qkx3w+4s
	D21CAgWrHvJWbInA84f7CHUArwNyjucl/inMlq9tEwn61R82Kn/zHM32kqI9tF7NIv8soiv8oyr
	sRMruEospm/AF5QZeUtbJABMmFrrsoWNuGJ5b
X-Google-Smtp-Source: AGHT+IF/dPQomLThdGkmMsZvizB3rgBhDo4q1hHHTNNlblZJaZhwg5OYQa91iqPD6DBwWLCvN0ZuA8WlvV4pvd2O164=
X-Received: by 2002:a4a:dfa7:0:b0:599:5575:bdaf with SMTP id
 k7-20020a4adfa7000000b005995575bdafmr222017ook.9.1707441257960; Thu, 08 Feb
 2024 17:14:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-9-amoorthy@google.com>
 <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
 <ZcOkRoQn7Q-GcQ_s@google.com> <ZcOysZC2TI7hZBPA@linux.dev>
 <CAF7b7mqOCP2NiMsvzfpYaEaKWm4AzrRAHSGgQT9BWhRD1mcBcg@mail.gmail.com> <ZcP_JHsMJUlvjAs1@linux.dev>
In-Reply-To: <ZcP_JHsMJUlvjAs1@linux.dev>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 8 Feb 2024 17:13:40 -0800
Message-ID: <CAF7b7mqvAMR3G9Y6nq8SV+DBQ8oz9te0fdg40J97mOw_t3=fhg@mail.gmail.com>
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

Ah, I finally see what I'm being beaten over the head with- the
kvm_prepare_memory_fault_exit() is a feature of
KVM_CAP_MEMORY_FAULT_INFO, not EXIT_ON_MISSING. You're right of course

Ok, so for this commit in the next version of the series I'm thinking
the following description

> KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO and annotate fault in the
> stage-2 fault handler
>
> At the moment the only intended use case for KVM_CAP_MEMORY_FAULT_INFO
> on arm64 is to annotate EFAULTs from the stage-2 fault handler, so
> add that annotation now.
