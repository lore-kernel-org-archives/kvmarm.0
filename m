Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B07E10FD
	for <kvmarm@lists.linux.dev>; Sat, 16 Mar 2024 00:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710550309; cv=none; b=trxQ/SVxuyZcC9Pi9yplx/J7r23wbRZrxodukyBX31DFFXA+KTMgACbnttPXDOcOyendjpLHtAQ42/H0q6xBxyL6vhSL4PjX19aOBp48mNDU9MkCxikuBAXKkIoR1QkKhlZrhQpYKOT6Y+dtOcXkqKv7ohX5Sx9c9NNAoCYYFjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710550309; c=relaxed/simple;
	bh=veGHBF3H13JsJeE4FDnKI5tpEmZeeZRyQgx+bxMNAi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=acaE6kZQz1rKwbBYt4U9fuL39WldlZmAkR3AumAnHRju09GkMaX2xKUeqy9nZsayVnj3RAQlIQYa+GXsfN5qSlnJK4VIal+01lNDXExrNj74zh2gc1Q8Rh86Jg46J0eXPJTqeknqsWcFcpqPRusyCXlovnQdOeyt8XUSMtQJaBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qj61R53m; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qj61R53m"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-568a3292916so2854713a12.1
        for <kvmarm@lists.linux.dev>; Fri, 15 Mar 2024 17:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1710550303; x=1711155103; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=krWZ+WRoA2zaA7Cdw3TM52PMtly6Zf/um2GekWUiV7E=;
        b=Qj61R53mQnetmQ0Xub9thSbaKHGNm2muh+jx6cLXwSigboQmY6ONFOK0bU4633XqXk
         iPPBCyCVStWP/CEIcDySanB+K0bAjXMwQhtotV0SbXnDYltaA5Agu8QaedxJiIak5fn6
         dCr1axXkejfx4Bywc3F24IVAMoVV/h6yfqru0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710550303; x=1711155103;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=krWZ+WRoA2zaA7Cdw3TM52PMtly6Zf/um2GekWUiV7E=;
        b=lsVLf/Aqz0s6oIYnL0Z3q8P93a5plsExkuxNax+i8wu+b+Dljq+B6TCeEnMKhtBrWK
         i3urB4RLWURdLy4ox1ixgz1tKTyfmu4FFpHy/FuzYt+itsb3vuXhD9d7NqXBugkQYeR7
         LQMESyKc68t65w3Dk2856/doRgSx+8ur/0Vdt50iiIjp/lB3iBOTbnHTO9s7p3CnXXgO
         9J6lEw4Rl8UXIKXbob0b7q6XO+6Pf8slevkwgt2X2g74xZdjGkbGpg4OwjSBS7eGkJjb
         wM2WMoILhJLFweU6UEIDX6bhPfeWq1SxUkHLr+AAU0d2Yl0f/rZP6ZDK78rjKAoDGvdb
         JqDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpGBLQsRs+oCo1BzDYfRyQm8qDkzZwk7lbdz8fnH9U5Iunp0+1bpN1AVdZhVl9M0YY8CUECmeNuQ+aegcTty7UWcOQpyJc
X-Gm-Message-State: AOJu0Yz8LJvrISHCtQ+jYbFynZSIoIgTe0LVb1tIi7f4mIDWMHIQObQu
	0pazNXRAbXiLlEjQwDpqP3oap5mBMcmKSzIUg0AAebj4/gmxZZkZJPO5q0SIYmTGn5Vfis0LCLB
	FFdq0KA==
X-Google-Smtp-Source: AGHT+IFOIbuLBXqi/Hd1XC33AEdZACSlrVr8krNBUMD/LFV3yJXA/0DjuqBaTVeRFzk17rCZsev7ug==
X-Received: by 2002:a17:907:c706:b0:a46:23ea:79c1 with SMTP id ty6-20020a170907c70600b00a4623ea79c1mr5118307ejc.56.1710550303526;
        Fri, 15 Mar 2024 17:51:43 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id h21-20020a17090619d500b00a46447348e8sm2185661ejd.191.2024.03.15.17.51.42
        for <kvmarm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 17:51:42 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a466fc8fcccso308243966b.1
        for <kvmarm@lists.linux.dev>; Fri, 15 Mar 2024 17:51:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVXbnHT1mIhI+w3R7/rOxPvqU23Mz78ZdzoASxcitH1RXkti/eErtsAZ7nnmWYX1/O1ntsBzaJorU9MHDNFPmalEF0eVv2o
X-Received: by 2002:a17:906:eb0a:b0:a46:59c6:2a42 with SMTP id
 mb10-20020a170906eb0a00b00a4659c62a42mr4188815ejb.76.1710550302338; Fri, 15
 Mar 2024 17:51:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
 <20240316002457.3568887-1-oliver.upton@linux.dev>
In-Reply-To: <20240316002457.3568887-1-oliver.upton@linux.dev>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Mar 2024 17:51:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjJv-Y1ZXbusknXpQVTx_kWudtORoKQPc+Rh9F944+Rvw@mail.gmail.com>
Message-ID: <CAHk-=wjJv-Y1ZXbusknXpQVTx_kWudtORoKQPc+Rh9F944+Rvw@mail.gmail.com>
Subject: Re: [PATCH] Revert "KVM: arm64: Snapshot all non-zero RES0/RES1
 sysreg fields for later checking"
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 15 Mar 2024 at 17:25, Oliver Upton <oliver.upton@linux.dev> wrote:
>
> This reverts commits 99101dda29e3186b1356b0dc4dbb835c02c71ac9 and
> b80b701d5a67d07f4df4a21e09cb31f6bc1feeca.

Applied.  Thanks,

          Linus
