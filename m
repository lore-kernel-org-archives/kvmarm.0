Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC4B47F2EA
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 16:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070805; cv=none; b=Vr7EZJwPxVHMlOkKVODlwAwFyO6iZxazp3Dq9bE7VHj9cz++LHAIL9bW+VS6XSE7Wl3nu9BF8/VgjwgRo+8YwCr2uoMKc0VbcIU8JSxPpRLBdr/ZXMGbSSjCxwuCeB9REL65G7HGL6aB4es/je6W4sXwH+usfQTdHcIl/zOtgNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070805; c=relaxed/simple;
	bh=0igr8Zes/VrYG9fBE3Cru4sD9Bym8t8t+dDC8+h+gAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sPep6ohgEeLbX2/Me8fICg/58bgGYVeNDV/SR3ZuOBrbZIB0m/sCPF6WOkWYAN4Sik5o4EMLBfGKSCNaYnl9Yb+fG4egyZ0Hg5uazj/Ud5Mge8bisHuygdxOjHgXfYFrRG7FYYjQSMMsrpP2CT/ISv/JHXuFr4ZRZmczo7xOhzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i+XIZYxm; arc=none smtp.client-ip=209.85.218.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i+XIZYxm"
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1f74261f67so73164366b.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787070802; x=1787675602; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NYCxMBx4BOPF4yBl5aKpfQIqd2cMC8x5BNz4F0URw58=;
        b=i+XIZYxmTw0lJoDfEtNDOtkkOG+PSleL2Jmmm8p2Y0v8sQfPuCZBNfOtYYrTKsCAp7
         ku/aHv60ZehxeFC8/y8tP3RQ6vK2ecR1WMxH8GIt9jjzArzWIe5ozsIzG6dk63fyQB+P
         qdf4gnbujMsSoi2qRqF4dZmF72dNwZC6kMIWjkaTZrKj4ssljacTN1mRjdScdphzhST+
         ifXWcUWbPXis1kJlINHj08bDupv5f6B9hSfc1JmMwRO1qVhzHSYTVWxKyL1f49PMePKH
         /A7RwNHKZ/sLOhXHlJS6Gw3uoYHqgt4ks/fSqml/9CytDx0ciL83SnL0+f8Z58+4Bpi6
         KYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787070802; x=1787675602;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NYCxMBx4BOPF4yBl5aKpfQIqd2cMC8x5BNz4F0URw58=;
        b=MevwBe4GP0App1YSoTBoL7DtB2szCWnBf6j+Hxifl4GWzscvv56fHB4EB+zy15It1D
         pY6s9a41dnLqKa6JjoIUj2PMKNPdICHc2w5J7RxPDsEmbKSzAzUOHlMBZm1bWVID7klR
         qZFOmjQZ9aix93U22yPu2PLVzqobOw4MRxEDbOJjG4A+JZvVdY2L33wNGS6nSPJLpVPb
         NxUF5KvXCJeepszzEPiE7TU5y1Nm0iCmABtb39sOONDHGxwsEpBOlUg3YCpd/xMjEaaz
         8mnSshI1HW8IhKbiryo3fWzo+RteusFhMvl9dZ3qGOA6Y63A1BhQLYh/H0zVby8Tfdhd
         Whpg==
X-Forwarded-Encrypted: i=1; AHgh+RpKGFiYpz14KVxOvR2waB7DNvaS98P/aFKEVkx3dE6IRxl1tt0ek8gj22ITGtgDhMozs4b26ew=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5+CwJYYAd7Eal4XIfZB88u5MxqJbzcv/Bc/iCVXpoJu7vSntY
	PGWcGSCawpXnsBJBD0Z2UYhaj3LNS344kuY4+WcBlnBtmKs5K1jzApSdwxPpFhZalaO54VxOYpq
	0mOlm3HQELbRDGhc8mw==
X-Received: from edea16.prod.google.com ([2002:a05:6402:a190:b0:697:8356:d9d6])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6938:a091:10b0:c15:a487:3482 with SMTP id a640c23a62f3a-c2188a9df89mr438613166b.21.1787070802257;
 Tue, 18 Aug 2026 09:33:22 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:33:21 +0000
In-Reply-To: <anpieno-RyRl54fp@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-8-tarunsahu@google.com> <anpieno-RyRl54fp@google.com>
Message-ID: <9huzfr0bv166.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
From: tarunsahu@google.com
To: Sean Christopherson <seanjc@google.com>
Cc: ackerleytng@google.com, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	linux-kselftest@vger.kernel.org, andre.przywara@arm.com, michael.roth@amd.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, will@kernel.org, 
	vannapurve@google.com, maz@kernel.org, fvdl@google.com, kvm@vger.kernel.org, 
	oliver.upton@linux.dev, kvmarm@lists.linux.dev, alexandru.elisei@arm.com, 
	skhawaja@google.com, aneesh.kumar@kernel.org, linux-doc@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, kexec@lists.infradead.org, 
	suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"

Sean Christopherson <seanjc@google.com> writes:

> On Tue, Jul 28, 2026, Tarun Sahu wrote:
>> +/**
>> + * kvm_gmem_freeze - Freeze or unfreeze a guest_memfd inode mapping.
>> + * @inode: The guest_memfd inode.
>> + * @freeze: True to freeze, false to unfreeze.
>> + *
>> + * This API is used strictly during the live update / preservation transition
>> + * window to prevent host userspace and guest-side faults from making any
>> + * mapping modifications (such as fallocate or page fault allocation)
>> + * to the guest_memfd page cache.
>> + *
>> + * Synchronization Strategy (Sleepable RCU):
>> + * To avoid high-contention VFS locks (like inode_lock or
>> + * filemap_invalidate_lock) on the vCPU page fault hot paths, this subsystem
>> + * implements a lightweight, system-wide Sleepable RCU (SRCU) mechanism
>> + * (`kvm_gmem_freeze_srcu`):
>> + *
>> + * Global vs. Per-Inode SRCU
>> + * ======================
>> + * A single system-wide global static `srcu_struct` is used instead of a
>> + * per-inode SRCU structure to completely prevent unprivileged users from
>> + * exhausting the host's per-CPU memory allocator. 
>
> This argument doesn't hold up given that each kvm structure has two SRCU structs.

Ohh okay. I was very skeptic that per-cpu structure are not counted in
cgroups and liveupdate is once in a while usecase So avoided making it
per-cpu. But otherwise I am fine with going with per-cpu. Will take care
of it in next revision.

Thanks
~Tarun

