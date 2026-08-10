Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F8E268690
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 10:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786356854; cv=none; b=hrUqrqBohJsLm6kWMIcfmTGPicxB+uLVt53V9ddYLjkL96/Ww0ouy0un96+gT+4MN+8RYZ7UbN2okP2SyZ+mCiBUjHqj2/Uqqwxku7C0JOgjU8X07UasZMWyLFKGnG4AzgulVjg9RJUEbg2CN4s4omXo+JcfhO6JEP6j67Filf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786356854; c=relaxed/simple;
	bh=KhRqqZzkzINqMrhJjmlawWrpCrwFP6oGdf7PTZcoZUI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L7/Yr7B2B8otYo2syo0yTyrE+aaBW1bBBWJieUwbarA+flR4VopkWD8Yv29kHpvQ2lnmbreinvyIm9dFPdZMiISfg1pHt5Y6Auv5bAWcaangNh8YZtdVUCbJeO7B8NRpu2VT/P1Rfcx8SkOjBpuPXc/zpk3sW6NqIShegAJafb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FJxvJxGM; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FJxvJxGM"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-69cd6606b19so1410672a12.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 03:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786356851; x=1786961651; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q7bDX99X8heKfUMDjEOLpp44Kc2HBY4XoCrDNhJpdWw=;
        b=FJxvJxGMvKvH0otiIC1YpuwhZUW1xPbF4WY6ohHRL9sLplk4pUKptDBKeNvIMDFTv6
         SZRzeFyKcAtirgA0iAlA//WB8UHKJmqZgKo2jvAkxw+bOMCufWh41APqCQh5yRvDBzMN
         Fj0sznXSEv2jK1H8+ZQn/rC7RbqnUJXEABDiocKk565DN8ZY64lOqyPjlxdKRwbYpT7g
         a5ZmwnTh8XNwUfM2RcoyREcOzhGRNmw89FXS496To+hMmyzO7ydHXHAfXqozQ+ztCTeZ
         2PKsn8q8tn50SzdHIivNA/Gr0X0Me0G8rVjMWeLVu3proseNpx+sf2fobjGuTqMkrftM
         p6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786356851; x=1786961651;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q7bDX99X8heKfUMDjEOLpp44Kc2HBY4XoCrDNhJpdWw=;
        b=am4CL/H+yZy9RiE2fAowYvEL5+h1tmqfQ15aJu58dpzdT9oZ42gIY/U95hjc9yWYyZ
         EeVyoA90ckOu7hzfZM2m41S0j7cwZ1IHwXX1E5RL0+g0ZYFu1h7zI8vHnoapCi0rMcyY
         ljF1TIuBGln+cEu3Qzfa2btWVYCWrAw8BL2j1E8eQoYFi4rPJ3W7qviNL4dh4HqG/tz6
         YP368i1G5rOdDG4reriRy+6Di+M5/F2P867MD2FgLhpe8nqgRjyW8fnGewK+/CfGqdUC
         112+OJWYwPTlnu7Lt3XytNn+67GTkbbCVvB8NUraJl0iWZb6XJGM1OVr54wutPm299OX
         PHVQ==
X-Forwarded-Encrypted: i=1; AHgh+RoGDRaYKPiDVGnwKFzF90z7IqGE1sbE92I7/yMKRLkBmqCFfYoy2L6BzPZAaypBQODsktNWwI0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVMv6ydzUeKEkOOtx2cZeqIT3b2xwd/6P4V3fFx/ZXFmfzLX90
	vQEJrpgBoHOFdHQYQs3yE5OpHodf3bQu7N8LtKccPaPX7DEy1bJlJRIJSURNQ1njkAxNRy61OiV
	F8yVjsB8ei5Oa4oDaJg==
X-Received: from edtp18.prod.google.com ([2002:aa7:cc92:0:b0:69a:bfa3:e91d])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a00e:b0:6a1:fb92:b3c3 with SMTP id 4fb4d7f45d1cf-6a355e19d23mr437843a12.12.1786356851307;
 Mon, 10 Aug 2026 03:14:11 -0700 (PDT)
Date: Mon, 10 Aug 2026 10:14:10 +0000
In-Reply-To: <CAEvNRgGazT2D-G7sEem4RD5nUEj7dmcg8vx2=3bpatS_o5uE+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-3-tarunsahu@google.com> <CAEvNRgGazT2D-G7sEem4RD5nUEj7dmcg8vx2=3bpatS_o5uE+g@mail.gmail.com>
Message-ID: <9huzh5l28eq5.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 02/11] KVM: Introduce kvm_create_vm_file() helper
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> - Move ITOA_MAX_LEN to kvm_mm.h for reuse by upcoming kvm_luo code.
>> - Introduce kvm_create_vm_file() to wrap kvm_create_vm() and
>>   anon_inode_getfile(), providing a unified VM file creation API.
>>
>
> I think these should be 2 separate patches.

Okay, I will split them. Thanks
>
>>
>> [...snip...]
>>
