Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D38635C68E
	for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 13:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786368169; cv=none; b=KPsTc1kBJxZPdcX9CbpSmNKGbcIJ1PeShSdsVQu3SKRZDvdih5zZ4MDa9xTHhAPG9vsoTRuJ6guE+2bXsTKkDf2ekMwhaAcdaoZ1nAK1JWhzkCMzYMjTsKernA72/BbQRaQ9sCGgExBaqHa2YIwI3jx2pym3nf1jpo8uJDUbKbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786368169; c=relaxed/simple;
	bh=QgQ3h16t1I2y58P4HYcYNeAl6wbVQDA6rb4jfsvSqvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DF2l9axGNNGunJcpRMnKl3OgUnlbUD3D9mthrZ/f6hl3x1+EZd42wtz7hyBKxz1EzMlnBq+wgWhDBf0YF25KPFtPP7+vczr01Pi2BykGzlss9On6T/LQXW5Qqg+1Zq3ueU5WpiIMR9A+GlLveZYIzcnwe4rxmXF0JFBGxG1r4mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IwvM8Cav; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IwvM8Cav"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15c32294e1so167987466b.3
        for <kvmarm@lists.linux.dev>; Mon, 10 Aug 2026 06:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786368165; x=1786972965; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iM/Qa4ThtXGVoAOuESD7ZLMy4Hwa1Cb/UO9QtFpTQ7s=;
        b=IwvM8Cav+f/bvi5GnuYU6KSd0ylOhQ8n/npADDDryrw5UVQByD3WzWu5a7NZFqgjIz
         B5/mqTkyBleT8si4px8KYibtrf0CrUW2yPyYj0M0yFo4nnFSgyUjW650k82n1wl8INmY
         jC9m87h4ECVbVt5zN/VWqbkqoArxcTtxk1/lwYaldtzOKHb3iyINsawWKrfKXr/cMxNY
         5sEDf5mp0qBya1OZpfo72EAYKoXZ7F//0WNxMtET8ruQ5PX0FBS8NtVtJXTCZVJqyA9W
         XH986rj2YG2le/4c81z3vZv8+OftsDr6sHB0FQZ7+jh2O/CjfSxxQkJqTniDemiuBg90
         K8Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786368165; x=1786972965;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iM/Qa4ThtXGVoAOuESD7ZLMy4Hwa1Cb/UO9QtFpTQ7s=;
        b=Xq/xASO+bQBMMy45eKMqVbE/wF7NUA8gGqEmUZyILgZgKUlLD3SBnIzqXSnAzxOXJ/
         wt0Pl/ifpVIQgSlFayagcYVVNL0iRe+4aOe+IwgXWIAFv3UWBkYv45ZcbaeO8rJ0EugZ
         ozE8di8QvAwap2T/Z9PrCes1/D42zyx/df8OSj6vidYRKB9l8BDwvQWnWm2y4IZ5D+UF
         PhFj6HYAwnlq1IBRdqeMKXHCF9Jd9pqtqDMPEuuZQUZ18Mdhc14dzj3Oq2nCXmynn1bC
         i8CEOOD6hBd0ZDzHpMpBKgea8rTcS6bZLpFdEff/USH6IeLX9MpGomzbg6puk05rF7U9
         uMjw==
X-Forwarded-Encrypted: i=1; AHgh+RoNsTIM/ixbAyQBXWwNy2ru4CtyLNoLDPumNRfGE40Ohq3z74z36vsSeiyRrvUl7cS68fw/pN0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw485yt/qw/JX0Mcnx4Jy3sJDe1gERwAaoNR+YGKw1D9DfOiC1Z
	VYo2qEj+XU7MMvxj6R04bIvDYosNvqFkiTtREt9O6HybHxS1YTtJ8auoXu/STDuxqvaLd7Rb7f+
	Jmxhgyz6a8WdDjp5n7g==
X-Received: from edap32.prod.google.com ([2002:a05:6402:5020:b0:6a0:ddb8:db7f])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a5c1:20b0:6a1:f7f4:200b with SMTP id 4fb4d7f45d1cf-6a1f7f4278bmr5285938a12.12.1786368164940;
 Mon, 10 Aug 2026 06:22:44 -0700 (PDT)
Date: Mon, 10 Aug 2026 13:22:44 +0000
In-Reply-To: <CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-12-tarunsahu@google.com> <CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
Message-ID: <9huzv79i6rff.fsf@tarunix.c.googlers.com>
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

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> Add guest_memfd_preservation_test to verify that KVM VM state and guest
>> memory backed by guest_memfd are preserved across a kexec reboot via Live
>> Update Orchestrator (LUO).
>>
>> This test includes multiple tests
>> - (A) Test to preserve non-guest_memfd, non-memfd which must fail (/dev/null)
>> - (B) Test to preserve guest_memfd with no INIT_SHARED flag which must fail
>> - (C) Test to allocate the guest_memfd memory after preservation because
>>   preservation makes the guest_memfd frozen. Which must fail as well.
>> - (D) Test to verify guest_memfd with INIT_SHARED flag preservation across
>>   kexec: Below is the details of stages in this test.
>>
>
> I think we should split this into multiple patches, where each patch
> introduces 1 test.

Got it. I will split them. I thought that this test already spawn a VM
and other test can just reuse the same VM.

>
>>
>> [...snip...]
>>
>> +++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
>> @@ -0,0 +1,357 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2026, Google LLC.
>> + *
>> + * Author: Tarun Sahu <tarunsahu@google.com>
>> + *
>> + * Test for VM and guest_memfd preservation across kexec (Live Update) via LUO.
>> + *
>> + * NOTE: This is a MANUAL test and is excluded from automated CI/testing
>> + * frameworks because Stage 1 daemonizes into the background to pin resources
>> + * and requires a human operator to manually trigger kexec before Stage 2
>> + * is executed. Running Stage 1 automatically would leak the background daemon
>> + * and cause CI runners to falsely interpret it as a passed test.
>> + *
>
> Usually there aren't many printfs in tests, but since this is a MANUAL
> test, maybe that's ok?
>
> Would like to know what Sean thinks of this, and printfs in general.
>
>>
>> [...snip...]
>>
