Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2230971B3D
	for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 20:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706646390; cv=none; b=HyS58S9t0tpta/kR07F99ohLEt/UdDh2cT4JPdopPl7r3xj+4TBtIP3HjvfSECq5VS5vOFkOoVe3clq5mMVTdINSOpawUWrtUDr7mazsdOF5ZGUUtle/j0W8+C9GuEUeSofhV5XMQX37msW4pGfLrerVf5WWb0gU9UMpWuPs110=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706646390; c=relaxed/simple;
	bh=61Oppu3AVzP+KtyffiFkREZRsy7hKLsaEdGCtMFJ2Tg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=is6hu+VoEVB2PrJNcJseX6nFalAA446ol3yDwoCp98Wc8KHHwxjuAixC+pXprPlA6gKEAL3Bv9IK+J96nByk4cJFGJgR7av4kUB1dd4KBRteJjvUFGfV91Mki2UXfc85y+DU1Wk38mWDmpHUQgbWNKnSfz4biE6xQcWOi5WZQ3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kN0R6Slu; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kN0R6Slu"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso6648669276.0
        for <kvmarm@lists.linux.dev>; Tue, 30 Jan 2024 12:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706646387; x=1707251187; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=h5pgpMcGME2v9VvnIy7lBJB+U5dgrFCMGRIIdlijbWk=;
        b=kN0R6SluLnMlAnN77jsp3DPWE2QKLd28KYyTth6VNolxgdajBRuP3cB8aKyiw9Ig0C
         QCkEFb/i9prT+VCbsbR0f0y8SrFY4WYcB7FwhqHThgpmzctW0qBr8Lo2je6nqVUjviFa
         6whFR8ckLZY/Anax/nJO4epsXONwvKOEWv1Qt3Id6LADI3EmlGEtfOc/8kt8WXX2yFwe
         c7QtYLqMphG0fk7PxH/R+NmEANH7BSIPdm1B72yU0q5gOl5bsD/LaczoxyEZBpJIixsP
         H2IdBMaV+VAp4mj+ou5y5X1CvFvq9v6aIvf33vHhPkc2Awi7Xg4BcqABpk3a6P+2MJNX
         wnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706646387; x=1707251187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h5pgpMcGME2v9VvnIy7lBJB+U5dgrFCMGRIIdlijbWk=;
        b=DeZSGn6xLbJjusb3HpiEzGDEmO0e55/HGov4HZYJXXmhqnmYsqGXioGc/f8SZE8f0w
         eTKLubak2+FIhawm7J3pH47PItjdwNaA/JyacIJdhqBXL/1Cbu9kbRQTcfWftHvk+Px1
         MoFDqbJT0qcKbZZ+B7M5a/FLAWARCrv+DUwy8Br31cvM8cK/YJiKjsQt6Kaw0Dv0vZHt
         1Vs06BjNZOucp3++J/75FuorPhTMkB7ZHkbxVqDXOoHKDCnQdFjdDqR6LbYh+ZOC5MtP
         31IbyPTSPbRzT0Vhcac9Oet47VSw5kNBZBtuBWmABtZTF9FGU+bbARBf/8buhGb45duv
         TKEA==
X-Gm-Message-State: AOJu0YzdB+y7qe/V3hx2qHBagNp6GX1PCEB1IMYCBGDUpQdQzaIGVycH
	Bl7BVXFJvpc5pOWRg+YFA3EFqBFdZ+jpTcrPJlPOfmH73SuyWlZukH6uUrfCLNPhBJRTpWUgfbn
	LFw==
X-Google-Smtp-Source: AGHT+IHckChIdOpRwfbWV8GrXqEqx1z1rCFc0PlXBsdw7+n8o4dfOUWIS0du0dp6kzjap7P3rhIB7Jyts0A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b8b:b0:dc2:3db1:da48 with SMTP id
 ei11-20020a0569021b8b00b00dc23db1da48mr590192ybb.13.1706646387146; Tue, 30
 Jan 2024 12:26:27 -0800 (PST)
Date: Tue, 30 Jan 2024 12:26:25 -0800
In-Reply-To: <20231206170241.82801-12-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206170241.82801-7-ajones@ventanamicro.com> <20231206170241.82801-12-ajones@ventanamicro.com>
Message-ID: <ZblbcUloeMqc-lR0@google.com>
Subject: Re: [PATCH 5/5] KVM: selftests: x86_64: Remove redundant newlines
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev, 
	anup@brainfault.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 06, 2023, Andrew Jones wrote:
> @@ -162,7 +162,7 @@ static void check_clocksource(void)
>  		goto out;
>  	}
>  
> -	TEST_ASSERT(!strncmp(clk_name, "tsc\n", st.st_size),
> +	TEST_ASSERT(!strncmp(clk_name, "tsc", st.st_size),

This newline is functionally necessary.  It's in the strncmp() (*#$@ sysfs appends
newlines to everything), not the TEST_ASSERT message.  I'll give you a pass and
fixup when applying since I'm guessing you don't have x86 hardware ;-)

I double checked the other arch patches and didn't see anything sneaky like this.
