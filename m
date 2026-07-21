Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B79439354
	for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 23:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784675255; cv=none; b=FGgSBKuuiCcrSA8MzQqcUmbbTluxfjHPeg3KnQc4V0O2U5C487oz14n4YC8SX8W83IBVv10aB/vkeUjm8ewG4EcfBUiCtY3GYi03F2bnSHitdT6O/Yzvhdf4BDjhXCZEYslC2ZeTlUkTQEl6/FIGtHWNlEk/oTgl2YHlR9EVGIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784675255; c=relaxed/simple;
	bh=1n3N+WI8h8PhUv3mfjqFCSH44YtN+KKWZYX3l8X+oWE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=JsTFKFsRiykqgnmNbxsu3pwMheXg0r86TbB6flO+3rb+cB9/gWNwQMLAmBuMPDaArsk+njAzd4GC5UwG9qt1a3I8GFawIJ+aaTNROuBxo5FS+yCIrrVUjRgRcsjaU7WG/cO2JdiHugSXq2ucRNfTjNalaqgEUgMeopEjLcVv4Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G9QYUMgk; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G9QYUMgk"
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7eb6a8c61deso9059999a34.3
        for <kvmarm@lists.linux.dev>; Tue, 21 Jul 2026 16:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784675253; x=1785280053; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QXklq3z1zPJM73DGXfVs9Rwe/LHFVQt6fqyhM9xa818=;
        b=G9QYUMgk+zGE4p8fRqw0r6KErU2ibMtT+1K+cA8BwVTBD9sNFhh+x0BLBfezDZG8Ih
         BXU1xj83//L0OBNmvUWji3hp4vgykXcdQwX99d43muwnX2by4Y1iDMa1YhYx7aA4AhYs
         vk+rj/4vMt3AvajHs96IjvwgBfYJ053cD2+tKgc/CG7tkOnurYFrvjkEwFU//uOwGcgm
         VuseyXdgENZ5uux+X6AfVp41jdYLCgnkP2i0sNtYoU/GAjQv1NYKUXJImP8DO983Aprn
         +r60vzTodqq0O3zB3RTUzMFnTfKXbAkZhO/33ZxSWiUHihqLQ/O8EpxdrzcqGFb1oqdq
         djRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784675253; x=1785280053;
        h=content-type:cc:to:from:subject:message-id:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QXklq3z1zPJM73DGXfVs9Rwe/LHFVQt6fqyhM9xa818=;
        b=AB1mCCMZ/tJauWVElmH64y09F/beDO4Go0/XahhKICpGj+BGEDcnIvM/WElyV4GScf
         DT8+5aX4zsuwZhnaS7mzNKj09eoctbp65R8UD9zY2hW6CMjH3oQT541Tnq8Dk2YQlspB
         ACdFegzi4sgv0RjNbUysgyU9mYEZST6GO0CtbmIb9hIALMGo4NOcibYLgB9ZWkUCXboi
         vfmK6Tsduko2sfRaQJOacLV+lnEwmIxzkfAQI5VWMhWwU/7cNxUBeWQhZGIPqti2sSop
         gR5rAJGY6eV4ZMu84EAcVkEOB8rAoEiExuM2u5a2IXDnnPeiTuS40OkG/eeeLazs4y/H
         GEsw==
X-Forwarded-Encrypted: i=1; AHgh+RoDXAsAZ8MmUO2iefhWu2AoES/TNA6AdOqgAKN5Hmo6GzKe6RwozLzabC/xD9SV7b2eyaEg4gM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+8AIzlzjMjmpuMhMXJ6SWIP5Yo5sow1zrqjjQUGiW5B8LsHN5
	pGnwBS/aKMaaZY2TDyxjHP3d+MSjIyNGVGsIuVOSbuGfaml9nLbwZzI5R7a8CMktp2Aw8fKAmw4
	Usn/NgaezZg5htFDmnI1F7FU1ew==
X-Received: from ilnt5.prod.google.com ([2002:a92:dc05:0:b0:503:9301:3c0f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:15a7:b0:4a4:25b4:a0be with SMTP id 5614622812f47-4a4d0344556mr13073948b6e.2.1784675253077;
 Tue, 21 Jul 2026 16:07:33 -0700 (PDT)
Date: Tue, 21 Jul 2026 23:07:32 +0000
In-Reply-To: <lxhagolfvr6w5h5xujrhq33pzx7hb6db5ihga46z6qn3dba4nx@q5b2fdclitqs>
 (message from Andrew Jones on Tue, 21 Jul 2026 10:58:08 +0200)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Message-ID: <gsnt5x2854cr.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH] Makefile: efi: preserve .dynstr section
 for LLVM objcopy compatibility
From: Colton Lewis <coltonlewis@google.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: pbonzini@redhat.com, alexandru.elisei@arm.com, eric.auger@redhat.com, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Thanks Andrew!

Andrew Jones <andrew.jones@linux.dev> writes:

> On Thu, Jul 16, 2026 at 05:33:15PM +0000, Colton Lewis wrote:
>> When building EFI binaries with llvm-objcopy, keeping sections with
>> '-j .dynamic -j .dynsym' without '-j .dynstr' fails with:

>>    llvm-objcopy: error: 'arm/spinlock-test.so': section '.dynstr'
>>    cannot be removed because it is referenced by the section '.dynamic'

>> Include '.dynstr' in the list of preserved sections across
>> arm/Makefile.common, riscv/Makefile, and x86/Makefile.common so that
>> EFI binaries can be built cleanly using llvm-objcopy.

>> Assisted-by: Gemini:gemini-next
>> Signed-off-by: Colton Lewis <coltonlewis@google.com>
>> ---
>>   arm/Makefile.common | 2 +-
>>   riscv/Makefile      | 2 +-
>>   x86/Makefile.common | 2 +-
>>   3 files changed, 3 insertions(+), 3 deletions(-)


> Pushed.

> Thanks,
> drew
