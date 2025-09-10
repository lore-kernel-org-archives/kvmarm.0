Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463C83101DE
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 08:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757493780; cv=none; b=eeyBJqQ6Pn+3MSLCkSaxrB6K06W8TwOqxU0gdBPDdzB6zSh8pBzbtRP2c07b87HThl6asjObb+8JJBtTd04IN6uo+GZsPLOHPmih1tNZ8BOzVyRssWj5fXkLTNfIl+d09dDxpckFK9n7Y7hB02HIIL93YI9vPEFfIL7H7SVT3dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757493780; c=relaxed/simple;
	bh=ZqK8x81xBqGjA4zevzTjnmg1gt3vQARNHK7AAZ1ABHE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NcEG02eHF5O0qNhX/YmjLCCNfIR9FaxjzsvTzEamvaE+mxCLFAy3pTpowOD1Zf5DBxR7KsxO6W0CJJR3lAhqUc9GpabDpTMDfEqRq+h83LRY9Kh4vdlVVvYcJEFdchxZbphxQk/U2ABoi3K6UW1Gw/9M6jbuBddx8Z0YuWugVLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aEmrQOuY; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aEmrQOuY"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b4bcb9638aso387881cf.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 01:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757493778; x=1758098578; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E+GVMVp49sN89TNRY1pR51HdfIG+sKzC0cYTWR8rn9c=;
        b=aEmrQOuYnvm0Bl3pXbHT+KjNbz/IPKfGkvQ3kSrtUbTpey1XTiE5p/jnYmOZ/dfVbA
         1sv3aj6VGW3DOyeEK+WqPg+e57jT8TElt9k5lBF1Zm2jLJAjvrQYx0Hge6Kl9jZm9/PA
         QtONj6SAd7wElARN8kp7XdVu2peqPuO9EvNeZ0vuorogCpd3EWp9zKOueUzxV1ZCmR7U
         2s5UjDR1JD8iBWNoRJjwsVpPBLfPuDpmbQuMcMDpr4i70h2A2wesHsVXMARMRq2aY+F5
         XRwOKt7cbjLJSEEH7SaFHmOKlOrnjaH+yDpRvwsPnRuMaqojd9cEvor9j5tkO9zFS3+W
         kQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757493778; x=1758098578;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E+GVMVp49sN89TNRY1pR51HdfIG+sKzC0cYTWR8rn9c=;
        b=LX7dPhTNp00q1I3dQ8TSuxIlUAV8oM3+NHw7XjcqOs4EANy0Zy0BhnQA/fE7RTpg0e
         X92HGdN910UDuzLvflyX3bWjyzRCOgyfyXwvnpihRYxLZN2XdoyOpC3TcRY/KeK15TTQ
         t9o15CVslkyQ5RBR5pQ4aKrJNkFSHQ6mV9yH9UIiCKPwc2QUJ9+BT7NjZ6cvBwDcL8+2
         Hf7klryCDSdAY68fkUlW8IOCm3yZ0H+s1cxnkBd2CFl05PErRelaca7ucvKyqiuU7h54
         OtWyTRew1bnUszFCGe8qK5AqXW0myWP0qIQdhH90a3P7iNlF69J6MIn8T7WUedqUS5C1
         f6pA==
X-Gm-Message-State: AOJu0YyamHdo/jSarW3DaKo/BwgyYUNNiuLFiNYSJJAbyIh5lEkjQGN8
	zI3zs73O/BD4D+flSkddSuJUWG0pSSZHV2XY/QyrAjvagRWN/RILER99OU5VkOJN2lQLt7wX8Cv
	pcrJuOZc6EhniRaRHHrbZG4P4BRfapznyznAtLjYC
X-Gm-Gg: ASbGncvF8q3RRbvSZP11WgRYqtKe5cFfNo9o87I4cfkbiJoeJsIccmQU914z7m6NIy9
	GzYdAcVw4WP/sgqKeRCsWNieog5p06/WKIkDX6rsVxeSjcHdmX70WK3071edX/NFoHEDIdmEXVD
	NcRi6grEo5UTaa2Sfrk/CXcXm5iTlRVe2EGO2tXSk4Zqsx3X5CmhGPAi5pCKu30B397cIQzCEeN
	qvYk/HP/e0uoe8=
X-Google-Smtp-Source: AGHT+IEl1qHCjtwGPJoxI/PfLa9X0mtc0AgLv0Zml465Cpf+BQz6lmjnBu+sGj/iRqROkYiQzMkZUxAyuxZezUMzUfA=
X-Received: by 2002:a05:622a:199d:b0:4b3:4947:242a with SMTP id
 d75a77b69052e-4b625236043mr3715451cf.12.1757493777772; Wed, 10 Sep 2025
 01:42:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250909072437.4110547-1-tabba@google.com> <5f26bc44-8bd6-4b98-af1f-0af828df9a4f@sirena.org.uk>
In-Reply-To: <5f26bc44-8bd6-4b98-af1f-0af828df9a4f@sirena.org.uk>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 10 Sep 2025 09:42:21 +0100
X-Gm-Features: AS18NWACwviPrScTMVeYLmQwqqOsfV8wFh5m9VgnliLfcZwmz7Zjl0m4mDWYK6Q
Message-ID: <CA+EHjTyq9tGgLiiwFz6vWLs1iE0ht-bSgVJUoMzyw9_=GBQ6BQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] KVM: arm64: Reserve pKVM VM handle during initial
 VM setup
To: Mark Brown <broonie@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Sept 2025 at 22:17, Mark Brown <broonie@kernel.org> wrote:
>
> On Tue, Sep 09, 2025 at 08:24:27AM +0100, Fuad Tabba wrote:
>
> > - Fix bug reported by Mark [2]. The existing call to pkvm_init_host_vm()
> >   wasn't gated by protected mode being enabled, unlike the call to
> >   pkvm_destroy_hyp_vm(). This imbalance caused failures in non-protected
> >   mode, especially when creating and destroying multiple VMs. Tested
> >   with kvm demand_paging_test using nvhe, vhe, and protected.
>
> I fed this into the testing that blew up with the prior version and it
> seems happy this time so:
>
> Tested-by: Mark Brown <broonie@kernel.org>

Thank you!
/fuad
