Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B29C1B805
	for <kvmarm@lists.linux.dev>; Tue,  6 Feb 2024 20:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707251785; cv=none; b=aYfhstJZVmyegforrfBCMhlppEY1bKtrQa61Ehe6+K9Zk3hvDLrzdM/zH/0SNic3BMfgBmD90nzNvsyjGfMhpaWN5pENtFjgMdVY5R5nP9rKH11ASe1tBPTtBb1Eb++UkpLdymy7Q/2KrigMpZxwe51zUwaz8NAKWiE2+Grbk1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707251785; c=relaxed/simple;
	bh=se8P+Bqy2T9rM626GcSkDCI8mK7oGhCqfOiPGu9wZkE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=X+80P48EBedkSWxoqufz+CoWuvXL0Au0D3kLPB5WKNV55bI/9VS6SEhP6qrtMfkP+OObMfmMjkrxNKoRQDEhLjlejChAnKVo+6DRIBt+PfMmaKpDjcvjs2aYqJ1Rqy/FxfYA1Lb2SVAX/L41dw2pGUiDWwrD7vBfD51A/BkUoDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s3d1emGm; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s3d1emGm"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5c66a69ec8eso6652678a12.3
        for <kvmarm@lists.linux.dev>; Tue, 06 Feb 2024 12:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707251784; x=1707856584; darn=lists.linux.dev;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jzwz3V63szJHlExhCZvPC7c2dtOM+k/FDHvQAaa+NEw=;
        b=s3d1emGmZtGpsAYVqptx74j0blulz1uKO22eIplewXr0oGkZEp2QlpACaklxfglUWe
         muWPEsnug/yCnisqpYDcBtUvYj3HCm5QD2g4PhDZsr7LBzR4bsif/II2nOIcVgcpGpDP
         LW1vThh8KQNpoUgnLJoUXGtGKqEfOZpmk7YpTix2qYSe34rNguSPjZ1pIhISkWNnEH+3
         1rHHGMAeYPDua4bH+RSdHWnTIu+zyEZOdrs23zAe7pIGnpc3IAHQb5EcPOfme20tplUp
         hiIGLEedfddfFHr2MjiHA2SQHk+j6xrjWhiCNyJ8ykkAG/bAwLuQPz3yfyOmSALPZl9i
         McaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707251784; x=1707856584;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jzwz3V63szJHlExhCZvPC7c2dtOM+k/FDHvQAaa+NEw=;
        b=nMhvWb69NPJpEuV2LdMfDcJevvhnrJMe87Zucdzk1Kf74yxReTg47vN3phYGJQH4Id
         X/Z+qawUxCJbUIqZpa69BuLUCSu6QtGXmf7RI3Fl095zKppGxzYnV2mAzrM5Wp+cj1Wm
         BMF1luAN5VJGqGp+ncfEyOi1G8f3OqONEZE8yKJ7BR+MZW4DZE/FnESnIYtjuKAlOlCQ
         ZUESTfYBJtiezMRmtKFVfMC+3ScaCqrfvIhbPIRQ3Cw+I/i/uXDa5EMQ5xpe0iVa9W+R
         YTKvGd3ot8xAJQmYFlJoVL70/hXhCPEEnuwvvFK2QNrLsTdbyzBT29j7SW6xqWBNr4ag
         mZVA==
X-Forwarded-Encrypted: i=1; AJvYcCU9oI3xID33L1zeMwj1zvyVl+U/z0WbQwXwdi9lgbzKqsQM8t28V+1pUA7spRi8H24IF63Kwj8cmhU+T4YsKBmpOx1CD8Ne
X-Gm-Message-State: AOJu0Yy6psfo3sf0Bln2PFyk/tTr+yDTCEJ1X1zl8Jdfhg99TJKUBQar
	YsTJOGPNJXK7MugVP0vwVi3mAGADtvVXyHHXC18CfffMh7LAaWAAQ34wTg/ZkslCivgit3WJBNt
	nMw==
X-Google-Smtp-Source: AGHT+IE+O6nMTqNGYB/t77HMprboX4PQjl7+xgDRrny/aw5DBBLxjaHIIhAZ2fE2KVmSzCD1jBDPxM7Dmrc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:313:b0:5ca:45d0:dc1b with SMTP id
 bn19-20020a056a02031300b005ca45d0dc1bmr1646pgb.9.1707251783750; Tue, 06 Feb
 2024 12:36:23 -0800 (PST)
Date: Tue, 6 Feb 2024 12:36:22 -0800
In-Reply-To: <20240203000917.376631-11-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240203000917.376631-1-seanjc@google.com> <20240203000917.376631-11-seanjc@google.com>
Message-ID: <ZcKYRsNUAngWGy2a@google.com>
Subject: Re: [PATCH v8 10/10] KVM: selftests: Add a basic SEV smoke test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 02, 2024, Sean Christopherson wrote:
> +int main(int argc, char *argv[])
> +{
> +	TEST_REQUIRE(is_kvm_sev_supported());

This also needs

	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SEV));

to handle the case where the platform supports SEV, i.e. /dev/sev exists, but
KVM doesn't support SEV, e.g. if TDP is disabled, if SEV was explicitly disabled
via module param, etc.
