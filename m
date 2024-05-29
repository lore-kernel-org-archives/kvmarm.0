Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8A9181334
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 15:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716996566; cv=none; b=OM6mOZFylE0xowRM8fSQbkA4CNGRPMPLJHXz80ep0pE2GpeBNeVOGXpOtlcZaAYAgIe/sTeBCdDB7tN8+Aw+CrsBmO9S1+Tra1jGeTJaNpMfGDK80WeMfWX51zstoA4lpY2HR9N1wfGFb3yTcwm7D8jRQ888ctTHp2jntqyeCCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716996566; c=relaxed/simple;
	bh=5EAuE4m6aZKJdT/S8iDYy5RWTfH+qE69UIxaK12MGSw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=f79zfOvokOesA1gdYD+RyW9rEVYnQIzwmWzUmufS+9RiwPE/x6WduZOnEAOh8PLCL4Li1dAN0zCHlMdT3MKd9A4MKq3oC6JObAEv9o1pLvVgoNdKn1P1ysqVQLxKKWy6MbH1mqbpr889QmBkZG5r6ogeqvXBJbNBjZmraNO/EqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IK9Sd7eI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IK9Sd7eI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716996564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5EAuE4m6aZKJdT/S8iDYy5RWTfH+qE69UIxaK12MGSw=;
	b=IK9Sd7eIHCauNVOKbcgW8z2CBclAb5Ky44gSxh1do6Hx+NPlFNdgpINQhDfE9jqKZK13es
	wJHgCJG7sgfpi1sHTQO8MoeFNsfx5qg/JUaZ+NjHdSfGN1/4KSyXc4RWpZ6LcGH2ENPm8f
	/zRISdllAAkKRkrxPYKubAsTJn/zzX0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-Zu50P6LOMp-PSABR5aXarA-1; Wed, 29 May 2024 11:29:22 -0400
X-MC-Unique: Zu50P6LOMp-PSABR5aXarA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35559d30617so1767348f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 08:29:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716996561; x=1717601361;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5EAuE4m6aZKJdT/S8iDYy5RWTfH+qE69UIxaK12MGSw=;
        b=lQvQXbiqi+VADko6jPFbXGTAi4RVV3N7unY6yzk7BLKrTs9p9J7lmouYUmfouNdtEH
         ha/a26Bssedj1C4925+KF7egEc1Jn8j/eQrrwn32AuStcwC7W7ahvh7c6Dz1SkoDBtSb
         87irVzYsY7Cb//v2OIYG/mrBDtUa8v6e5v8E2d3qoVu7GSrX3gt9Eo7tAXuAwFtAcGOk
         SsNn2PELxJBDNL+EIW2hpFl1NVBVqNvTTYfgoeutwdTsH7t9/7UK03omEZ2egJ12V2rF
         fusZcxnZJoMUr1boO/56rZOTDd5ftwFCMjpLCbBEBzmsQrz+uuR5uZRyuc9zTAGgouSV
         CLjw==
X-Forwarded-Encrypted: i=1; AJvYcCWsxzCNvoAFemixZSQfTxcAL2FfI6pQstkioDQev+uinsDQ4Ayp879rce3kbDtP8ggeR1VmOxfDozazz99jJM2toU2tZRAS
X-Gm-Message-State: AOJu0YyO+5h1MbzijPsHW7ygoMfcebY30iabr91PjkgQApOmnGDA1ZSS
	gpw9ktbEFmoFzSBewJGOb68+ZppNMX9+zV4CYq+4zdpZl9Hmgl0za2mixanBEWwwvmInm6MwSWF
	/zIn6Uvch5CJpufhn3eL+lZz3ufRE7V6gDiMjXKk6M2EJYlYNIQp39A==
X-Received: by 2002:a5d:6991:0:b0:354:f286:4f0c with SMTP id ffacd0b85a97d-3552fe029a0mr12407207f8f.51.1716996561617;
        Wed, 29 May 2024 08:29:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRJjULm6jx6xOHCCpirutvbUnzT/a6jQusAfJO3XKjkkjlSGtoHgavcGj/S/fqDOvU0+uebQ==
X-Received: by 2002:a5d:6991:0:b0:354:f286:4f0c with SMTP id ffacd0b85a97d-3552fe029a0mr12407190f8f.51.1716996561221;
        Wed, 29 May 2024 08:29:21 -0700 (PDT)
Received: from rh (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35579d7dd73sm15045365f8f.18.2024.05.29.08.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 May 2024 08:29:20 -0700 (PDT)
Date: Wed, 29 May 2024 17:29:19 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Eric Auger <eauger@redhat.com>
cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>, 
    Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 5/6] KVM: arm64: rename functions for invariant sys
 regs
In-Reply-To: <b045f810-eb79-4de6-b149-0d64834d53d4@redhat.com>
Message-ID: <5a00647d-7d33-81a6-c783-2212ff73ca8b@redhat.com>
References: <20240514072252.5657-1-sebott@redhat.com> <20240514072252.5657-6-sebott@redhat.com> <b045f810-eb79-4de6-b149-0d64834d53d4@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hej Eric,

On Wed, 29 May 2024, Eric Auger wrote:
> On 5/14/24 09:22, Sebastian Ott wrote:
>> Invariant system id registers are populated with host values
>> at initialization time using their .reset function cb.
> get_##reg call read_sysreg(). I don't really understand the above
> sentence. Please could you elaborate?
>

struct sys_reg_desc has 2 function pointers (among others):
.reset and .get_user . The functions implementing these are
usually named accordingly. For invariant registers only
.reset is used but set to functions that are called get_*
(which is usually used to implement .get_user).

E.g.: invariant_sys_regs[0].reset == get_midr_el1

When trying to figure out this code I was confused by this, hence
this patch..

Sebastian

