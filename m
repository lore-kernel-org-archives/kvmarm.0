Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7A03126D2
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 21:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761859316; cv=none; b=EWTTDytu28N+2hleZsSgFW0K8JFQv3m3NQ3hqsxqsQRrBQO9H4+XB7H/f+sYHPfpZMnGdUmyU0GGvwhgvhlaV2mQndPkpYqEy5qYdWKRgdbk+WLJTcYSdIx7zzZl/BbPIrgIF8tbWA7BYRFMdzKTxwn9ttQmQV4Q2y5mC09KJJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761859316; c=relaxed/simple;
	bh=41yO0rIy9bUDs+0nOWpnQwIwChMHRHfPwl3EMAqji84=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NXW1lT2qpEZK63hBNU1AxXgzvZZs1Ia0NS0woFGIY79Sb2BfMyEFOj82mpDLWHoVSDz1OQu4oo+r9EnLbd0B2xQsWBBos6/9iDCFiGTsxS7VKJBoM6Hy+eYKJn15rcHloaTNDqZHpq0PfJGSjYGW6jEuJf92/tWmm8gmGnenbrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hiCL9DZv; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hiCL9DZv"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-475dbc3c9efso10776215e9.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 14:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761859313; x=1762464113; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3xUY9h0KJ8iAZKk6ldG2UouJ9y8peB0TN173ET5ZQ0=;
        b=hiCL9DZv8D/J01FsNiLOCwr7Nvu6WI49t13ZPjlzDQVDp0WDbtadOu63axoaN4xmB5
         88Ad/ezGPcYZBDuVd3nj2KGQDu8974G2/bqxGV11bPjVfxTmYaHsmj2//wrMLb+sqZcC
         6kbNPfp4d//F9dC5WWL7JujKJQh8IdDDng+00d2MvwZFHGTKW/5GPQXnIauMDANPG+QD
         CuuDz/OAbiR6jOQW2Ni7CD44w2P4YaQdMniN5wOaqWsKSJFqF/ceO3OlIEzxAjMFmj5c
         yR3lCDaFC5dSa79XuR/+LTALmLLRlrljfUjN/OZe0SbB2xewkNoTz88Gqtry4ECVUrG+
         tPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761859313; x=1762464113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C3xUY9h0KJ8iAZKk6ldG2UouJ9y8peB0TN173ET5ZQ0=;
        b=blkSo7ioTxxGHaUUGnJk/kk18HXa76R9y3UyA7/hR4zQH7PeyAJ+DPZ3U58M19/dmI
         lL7F51h4W6bb4eaVUdLSdYw8ZY3i6CIFLvzEuCiiH11znKbbtu4blIAWT8FSI0K7VxhP
         CtCM8oSPWOZ/s14JzFy96iOLaPUkqy5e9J0Hjfp0ACNO7HYIyOBl7CKXHJ77rGZxrQ+z
         Xp8AFxhxe6Cu1NsAZtgAIHZn1HUAkQVCihqv1kItHv+teEvYkeoK1PGcLn+V/OboAMEX
         F6+v8f1ZeNVKF+fUx0i+ZZaC7y9w0izbWbYZOmQv7rG9+0JdiCyjEmGVzhRdi4VrF4px
         auUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZmq/Nm0L0biFSrxgJE589iv93ddD6W/2fHLMtKXD76jZJSW6+Rig5jwDIK8jQ4ugJ9ExDDmE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4eQSLYi0XtUhroCfhr0Qy0t1ln77eNASYYAzgMNMaI2Huk9hD
	bqI7PzX5oLBlrZwKNalpHUTPiTy2ITcXPy7sFP79zT+cmJ5CLb9J2s4v
X-Gm-Gg: ASbGncvnCFVGSFp93VtxDSOKygNG4VF/9nIjK4aqYWd9H/1yOHUkBZ/g2zVhCzncYYu
	ec8+gMbtL3PGSR5vLMzBQr9kwNNtcV6JKJCtumqavQeNpdGRsDNTC1/LDBAk6jENxMQrQWZ+TNJ
	1b1Lqb3mFGYcNagG6bvv96IqU+GGsa6QsKIWIS5XWkwkFClUOItYJpucF9YIdqxEhTeyzBXndD+
	nJtw2kMRUpxbwYd0hFirH19sCE08SNcv9Z8Hvzp2U2ZoLvSykKgNJeJZXHm0aEF+ZiTa5I737Ni
	P4xha/y73ITJXOR1uoO6wxyt5l8EXgnRYaZ0c8yphFezeN3nV87oQpkIMIyGD33zdDdUVqP/I8l
	xMycx0rxJmJPfCMpnRqbnG+NfrqLXIldsKHtKUnXbzPqRyI71mpx+jsaU14W+JR0NftuLPfjbSy
	Nz8RCDKg5zCdNuca+OEpMGEXG2B4BWZfMdA/WLV1ZZSw==
X-Google-Smtp-Source: AGHT+IHRzVaOlp+5YsC2cfS+t1uX4CV5lhiv1MUcpedd26aU/rB1wa07+4lpdiM8MS3Ql59DtlOQRw==
X-Received: by 2002:a05:600c:3d9b:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-477307e2946mr11654555e9.15.1761859313090;
        Thu, 30 Oct 2025 14:21:53 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772fcf439bsm7028125e9.10.2025.10.30.14.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 14:21:52 -0700 (PDT)
Date: Thu, 30 Oct 2025 21:21:51 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Markus Elfring <Markus.Elfring@web.de>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, Catalin Marinas
 <catalin.marinas@arm.com>, David Brazdil <dbrazdil@google.com>, Joey Gouly
 <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, Suzuki Poulouse <suzuki.poulose@arm.com>, Will
 Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, LKML
 <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Miaoqian
 Lin <linmq006@gmail.com>
Subject: Re: [PATCH] KVM: arm64: Use pointer from memcpy() call for
 assignment in init_hyp_mode()
Message-ID: <20251030212151.352e9a8a@pumpkin>
In-Reply-To: <aQOlPy7W6xljdkJW@J2N7QTR9R3>
References: <6e962260-5069-490a-89fb-908a4342ccd9@web.de>
	<aQOlPy7W6xljdkJW@J2N7QTR9R3>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Oct 2025 17:49:51 +0000
Mark Rutland <mark.rutland@arm.com> wrote:

> On Thu, Oct 30, 2025 at 06:11:03PM +0100, Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Thu, 30 Oct 2025 18:01:41 +0100
> > 
> > A pointer was assigned to a variable. The same pointer was used for
> > the destination parameter of a memcpy() call.
> > This function is documented in the way that the same value is returned.
> > Thus convert two separate statements into a direct variable assignment for
> > the return value from a memory copy action.
> > 
> > The source code was transformed by using the Coccinelle software.
> > 
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > ---
> >  arch/arm64/kvm/arm.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 870953b4a8a7..feab88c31703 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -2600,8 +2600,8 @@ static int __init init_hyp_mode(void)
> >  			goto out_err;
> >  		}
> >  
> > -		page_addr = page_address(page);
> > -		memcpy(page_addr, CHOOSE_NVHE_SYM(__per_cpu_start), nvhe_percpu_size());
> > +		page_addr = memcpy(page_address(page), CHOOSE_NVHE_SYM(__per_cpu_start),
> > +				   nvhe_percpu_size());  
> 
> This change makes the code harder to read, and harder to modify. It
> saves no space.

It might save a register spill - but really isn't worth the effort.
memcpy() is really best treated as being 'void'.
Indeed most implementations would be better if it were 'void'.
Although you could define:
#define memcpy(d, s, l) ({ auto _d = d; void_memcpy(_d, s, l); _d})
so that the compiler would optimise away the save that memcpy() typically
has to do.

I even suspect that memcpy() is an old enough function that the return
value is 'what the implementation happened to leave in r0'.

	David


> 
> As Dan said [1]:
> 
> | No one will thank you for making these changes...  :(  Please don't do
> | it.
> 
> [1] https://lore.kernel.org/lkml/aQNsecHJSO2U68Fc@stanley.mountain/
> 
> Mark.
> 

