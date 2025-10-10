Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E5B26E714
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760118967; cv=none; b=Z8fV2+M+nbjZ/NYPmfujKrgNt6qet25UvWkrReHvJTFlOCB9aMPKWj7/VZTRvXFg4Q8HB3URDY52T4tK5AIGylG9fQKAUF33n3SbrE4WvN2QvFEhwwSlnuw/i8udE7x2JW4GUcrmkkpkTbt5ITp1FNwEpEwiBnT6t6a2eG2wgB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760118967; c=relaxed/simple;
	bh=4WCXyfTTCLJOyLXrUdyX+y0+hs9jTJ7a5FhgD26A9JM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DsyEENKMisozJBjJn6c5XgDIdTRmScEoRw8f07hsBi+05xU6HKNpg9PvifnQFQYR7d2jCUqFMKLqxDrQxAJ3fQKxJ/RKmw/ur9cptJG2EcMoxeHnAip61En15zDz7K645KT5iiaam/39Q47yK46fLoqZrV9hhBy/ZLgb3pTdmps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o7hRLGFZ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o7hRLGFZ"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28a5b8b12bbso88755975ad.2
        for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 10:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760118965; x=1760723765; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r+fNeysjSBqXJo83LMvpOWAm6fUtr/rW8XiVtt3RPUw=;
        b=o7hRLGFZJgqR0v/TnWH0HCWR0cI4ivZcaExxRrq0cBYeZM544/xMrECIzwD0aJ6Yxu
         pg66mN2JIhUIqfIvmsLC4hbb05+c7bOoted2T8FanX1DWKO1NTyP+JLlAj0lpDCEMplo
         uidjjvayxhg74bXVF4yed2MDBp/HfOCNIwHzeDxZDn8p7p8BQi/YtLcQxdIDK7ZeHT5C
         dy5E5zt42GcScFX8XRr/Kt6ob2ceoIafRZMpPJ6IzeIoKhsrXPP1v9t171QFvQMCshj1
         n/MelWWhNx3CKkVzWpBoI1saVVDicsemSJwiQUakzY3MrRldxnR48pnirPpA3TIeYtCs
         R7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760118965; x=1760723765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r+fNeysjSBqXJo83LMvpOWAm6fUtr/rW8XiVtt3RPUw=;
        b=aTyVUiiSOzt+ts6WIp5aklq1iHNJLvTPPR3pHWkKO4cQQLeh9BKB4RBmLPdyXvierO
         1nMQ/7aDYqlcOWYVLTwuNdPREIp47r2uJbkCuMJvysq7fHGyqCrogVqKq5XF5gqan/IC
         Ym13wVRGy5tH7BTOogFUnXtMWL3x0Vqq5huJe54V/cvKQdiIXQB0Z3ch8qluMX/pLBvs
         MisTGGVgJf7RJH+p2b1G/wRqcHvM0vqePZNCfpuJbsX54mcY0AE0ZXGfoTXn0NpyrCnq
         BIpjqKXijj5Sesbvom9NCNYsCLJd3vIhfH5ApyTzPq1W7i03i/RpBDgDjqTtvWzLsxhK
         9FcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZireJe92SdWboUJJ7Acs4GyhQQg6OlNcIQdKz6YbHOpTW91C6Oyxi2CYEue6I1ncOVjWxIhc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyo9QWOReGy3YuZyIgbwBnsPxXRt+JGtjN71V3wBvdZYdFkTdi+
	tIZzY+YQONdgZmhonIGBqVkHXMu0fYcr5FW//25cbyN6Ha9wdOEcmyjK1poTg1JNgaxCiOXpiFk
	7G5pnz5ulXAqY61WgbtU5DEdjbQ==
X-Google-Smtp-Source: AGHT+IGjclZ91N97ptCXAmoIKfA3u2zw8eqXw1SihXP/pw9xAZDrc7Put3tnbaSd6Ang0fIk2Ogt4e6D4jCqFIGlKA==
X-Received: from pjbsk7.prod.google.com ([2002:a17:90b:2dc7:b0:339:dc19:ae60])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2a8d:b0:24e:e5c9:ecfd with SMTP id d9443c01a7336-290273ffc74mr153940805ad.42.1760118965545;
 Fri, 10 Oct 2025 10:56:05 -0700 (PDT)
Date: Fri, 10 Oct 2025 10:56:04 -0700
In-Reply-To: <46f31ad5-be3b-4945-87d1-c280f76fba76@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251007221420.344669-1-seanjc@google.com> <diqz5xcniyhb.fsf@google.com>
 <46f31ad5-be3b-4945-87d1-c280f76fba76@amd.com>
Message-ID: <diqz347qhc97.fsf@google.com>
Subject: Re: [PATCH v12 00/12] KVM: guest_memfd: Add NUMA mempolicy support
From: Ackerley Tng <ackerleytng@google.com>
To: "Garg, Shivank" <shivankg@amd.com>, Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

"Garg, Shivank" <shivankg@amd.com> writes:

> On 10/10/2025 2:28 AM, Ackerley Tng wrote:
>> For future reference, these are the three specific patches:
>> 
>> [1] https://lore.kernel.org/all/20250827175247.83322-4-shivankg@amd.com/
>> [2] https://lore.kernel.org/all/20250827175247.83322-5-shivankg@amd.com/
>> [3] https://lore.kernel.org/all/20250827175247.83322-6-shivankg@amd.com/
>> 
>> Might have missed this, did we discuss how these 3 would get merged? I
>> noticed this patch was withdrawn, not sure what that means: [4]
>> 
>
> Andrew confirmed he's fine with these MM changes going through the KVM tree.
>
>> [4] https://lore.kernel.org/all/20250625000155.62D08C4CEE3@smtp.kernel.org/
>

Thanks Shivank and Andrew!

> Regarding [4]:
> https://lore.kernel.org/linux-mm/aFlHIjLBwn3LQFMC@casper.infradead.org/
