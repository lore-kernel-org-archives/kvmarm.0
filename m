Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A7C47DF98
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 16:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070938; cv=none; b=nGQh0nSpRpv7Va/a3u5QPmJ4DNB8lzaitmugQln1gQPI8mT+3dRjEbOyVmhE+UCUdA9RZh2XOUkpF2ucwOIOU8tLRxG+C4kLV/6UpynbslwiKgMJwIOamD/uNoGc63ggrKD20t9/PwdOmUgrTnVfJ7ZBcO6/cFOXrdo2RXkGbtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070938; c=relaxed/simple;
	bh=TLUh2AgF2HUY0yaiHSHh3FpsIeZehsLzdw65S1KlsIQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q05jaeDI3XcN8VoZicyjWFu43Qc2AL5dN8kqOz0ZN4znU3yAdw59b4DX3WrFj9IHcRJRaFcji8oPV2n0zDttrHYuVJtPDB/89DpyrZ4q+tbEqerduxEWT+5EWke2uDewjoQ0kfN9eu6OcuftZm02bX3pfgJPqZ4LOCsu2oGc4XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H1PTYWzM; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H1PTYWzM"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15d4bd2afeso59509466b.3
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787070934; x=1787675734; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y4s3SdzysyF0cpwVmIOh8j6ah+K+701R9CGnrq6hKDk=;
        b=H1PTYWzMw7YXa/SdaOxKR3QiIdu6t9ScKt3FYAux3ffn9Kb0KGv1kgFPqy70D0hpeZ
         SxkxnmeUNRaDwBQmgyYA/o4fueGvjfd7RC5D6DcsKM81Y77RRe+cXEOfDvMn+VokYihR
         +0crkBn7s45GigT4oYxkS7ShW+WyrzHJe2KV67H30BTvCnd0WXpA396Hm8LcEPFyf/lW
         R5cySPjl3Wxn+wvQnueGz7F4fn7uMxdzPBiMB1LsQaHzNcqOil1W98QQxo6+QdVEn+UN
         7noTPUvjN0jTTWFMiNqMx7KjD9kscE2KXAg2B06grVYLWwMahS/T7aWz0T0ruvohX5Rh
         q2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787070934; x=1787675734;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y4s3SdzysyF0cpwVmIOh8j6ah+K+701R9CGnrq6hKDk=;
        b=gg456bBtZRk0fU7Vlj+N7r4HActI+FE6Rf4uEWf7/8y/0tKORPJcP06Ei8158UIbDr
         xuoHnaIuuBYsI+gVHXDTc4ieeOUvRHQhMwMQjtfp1MXWfowydTq2JhWPob+iaT/y4Bi1
         3Yq2VzF2App09PajXP6GrVQOD2vQQREg14NR0lOR4mHnHG9aiUbhGsWTFr4ZNHHU7zlk
         Kp0M7i7HHzGTQrJnv12zeMkSTDLZ3eI+uCoK2s4k4fxRc+3ECWRgbFd5PQZCSZ+5/FkO
         eHVid/1GKO7c6BISZCFVJ9kuNx8brs35JjoyovqMzakt/pGgWHMZiskD8IiW5NIoVKIA
         9yCw==
X-Forwarded-Encrypted: i=1; AHgh+Rqa2ACKlaCOii81IZu4tSqmhZrGzwWOdn58STGNj+yQJEvwvQK1+kEYxvtiG4YO6HOFAZf4FJc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9T0w5JalbURyOfgpSYn2Hetb1pQSgywc1dfcPPDJvgf5RhCuv
	ps5JCIVPtgSd47YGfng1oSqsVHvQ9quKDltPSmejE5AwNO2j9ssxcUZKfX9bZs61e4JRL6QZGWd
	Gj3zk0/apyUkxTJu2ew==
X-Received: from ejcxb1.prod.google.com ([2002:a17:907:ba01:b0:c12:4f4d:9db6])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:94cf:b0:c16:101d:7afa with SMTP id a640c23a62f3a-c2188a83758mr569918666b.16.1787070934060;
 Tue, 18 Aug 2026 09:35:34 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:35:33 +0000
In-Reply-To: <9huzv79i6rff.fsf@tarunix.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-12-tarunsahu@google.com> <CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
 <9huzv79i6rff.fsf@tarunix.c.googlers.com>
Message-ID: <9huzbjazv12i.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 11/11] KVM: selftests: Add guest_memfd_preservation_test
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

Tarun Sahu <tarunsahu@google.com> writes:

> Ackerley Tng <ackerleytng@google.com> writes:
>
>> Tarun Sahu <tarunsahu@google.com> writes:
>>
>>> Add guest_memfd_preservation_test to verify that KVM VM state and guest
>>> memory backed by guest_memfd are preserved across a kexec reboot via Live
>>> Update Orchestrator (LUO).
>>>
>>> This test includes multiple tests
>>> - (A) Test to preserve non-guest_memfd, non-memfd which must fail (/dev/null)
>>> - (B) Test to preserve guest_memfd with no INIT_SHARED flag which must fail
>>> - (C) Test to allocate the guest_memfd memory after preservation because
>>>   preservation makes the guest_memfd frozen. Which must fail as well.
>>> - (D) Test to verify guest_memfd with INIT_SHARED flag preservation across
>>>   kexec: Below is the details of stages in this test.
>>>
>>
>> I think we should split this into multiple patches, where each patch
>> introduces 1 test.
>
> Got it. I will split them. I thought that this test already spawn a VM
> and other test can just reuse the same VM.

From upstream hypervisor liveupdate meeting, I realized you meant to be
same file but saperate commits. Sound good to me. I will take care of that.

>
>>
>>>
>>> [...snip...]
>>>
>>> +++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
>>> @@ -0,0 +1,357 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright (C) 2026, Google LLC.
>>> + *
>>> + * Author: Tarun Sahu <tarunsahu@google.com>
>>> + *
>>> + * Test for VM and guest_memfd preservation across kexec (Live Update) via LUO.
>>> + *
>>> + * NOTE: This is a MANUAL test and is excluded from automated CI/testing
>>> + * frameworks because Stage 1 daemonizes into the background to pin resources
>>> + * and requires a human operator to manually trigger kexec before Stage 2
>>> + * is executed. Running Stage 1 automatically would leak the background daemon
>>> + * and cause CI runners to falsely interpret it as a passed test.
>>> + *
>>
>> Usually there aren't many printfs in tests, but since this is a MANUAL
>> test, maybe that's ok?
>>
>> Would like to know what Sean thinks of this, and printfs in general.
>>
>>>
>>> [...snip...]
>>>
