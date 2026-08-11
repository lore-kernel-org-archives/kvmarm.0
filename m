Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC252EEE63
	for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 13:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786454769; cv=none; b=KefkHiElCpQPxhKlCwFNlCq3YOQWuo+q9yd7hE63sRkjUNKA0yNpqG7Llrc66AKtk8QBI4Wje3WSNSApxhd6GbvdgWASKoZ2Jn5V4M7GHaUndDGfgaB5Ay9oUI/lmaWXi2MYvJFTCKsn59sXeZtVzPT9k3YehnIUBpihQQxEbRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786454769; c=relaxed/simple;
	bh=PcviRXye7natTlINzT+MvBO3x69BTv0hYr7HauJL144=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pJgxfK8jStFaJDjs13njRn/uwoPZjeKJ3u+XquyyTfN/e1j99mJFjeUmZekb0y8PIueY0iW1kN83qVJhxgcipzFcmBizv+n1P5CY8SpMKoBZe9C1OCNQroPrEBrPDe3DBSf0VY9oteSvcDspIrkEE3/I4TpZudmCK7GxfCOeTdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PnbSaMqj; arc=none smtp.client-ip=209.85.208.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PnbSaMqj"
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-698b899b53cso2583724a12.3
        for <kvmarm@lists.linux.dev>; Tue, 11 Aug 2026 06:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786454766; x=1787059566; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W70NQ8qweOhk0vfOOOPEvDwhbPTM+yme1ctvOdIAjTY=;
        b=PnbSaMqjuWlJc48b/PsDxtxS2YEgjTM4YBIsNjBzFxgZm9/daHd4J2ASHR7oNgdz2O
         dppPy3kuTmDRJssJOHBqS8BluNd/OIqSUsrUpqcdTyrKbEpxhHrGWyYEsICsfm6m5ZP5
         hQQFUsPzHAW/ofZAjK/5d5ssKIlUk03hFAGpVXrPs+xVnoTm4uU+A46/OWYzQO5timaT
         9tELM3+tNWP676m0YB4Ery4R+RJjmE0714wYdW64DUBdnp3oYse3dzrH2C2Ac7n4DjA/
         CV80W4J6x7vwu+1xB6ySVRaDyeYvng2wsXr7nu5+eIIpab5/mEIzau7bGSYRc3Dqcyir
         kvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786454766; x=1787059566;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W70NQ8qweOhk0vfOOOPEvDwhbPTM+yme1ctvOdIAjTY=;
        b=ZHOkcmn9EsRUTfbtMjuDSuJGfWNYjzSfbN7Bv3pRpeDiqQ1Z1RppoQ6ID0BI07ydvz
         kOPKjXnnGb6CUJQsHt+qWok8fui2phStw2EQgU466Nv2iI8Qj+MT/5g4w67aLqHtnDuu
         pe2LryQeTE7CBHM6VuCLA9d2r3k0zM9MSuQ4wKYE/sjBoMRZciW/12gCJJsn2XQu07ak
         2C5XkyJUFmxaUiCooUv8AmTsDXE5qRAW383XrDhJ8hPMxyPyi5ePu1arL2vzINbkVDy6
         GNE8YTrIrVezyFCdY8yON9c/wJmGcBqaTX37uUuJ7tl6si4mmCm+bVpnSwCX0rwoN8xw
         a63g==
X-Forwarded-Encrypted: i=1; AHgh+RrmdMBDjQuWDUNu7SNcGJ9ZfVO2WNs9MxHNX+o7HlRUx61Iq/1cpqm3fhtxwSTtDrRy4GGPlM4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfyS9/B/UYIZEAo5/hMy556K0WjvqmR4d9ZvqjvbgTFT13oAFm
	5bZpCaFX4GOuqgawH5kduR7GOcLXXkfimNOONVv+vcjrB1u93uJM2aaXw71549tVY1LlsSDgb/p
	HFBaSsgTfjHe0XnOczQ==
X-Received: from edqs15.prod.google.com ([2002:aa7:d78f:0:b0:698:b78e:8827])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:158b:b0:6a1:e59c:62c6 with SMTP id 4fb4d7f45d1cf-6a364525fe5mr1952585a12.18.1786454765239;
 Tue, 11 Aug 2026 06:26:05 -0700 (PDT)
Date: Tue, 11 Aug 2026 13:26:04 +0000
In-Reply-To: <anpXjM_lg_UTpl0q@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-2-tarunsahu@google.com> <anpXjM_lg_UTpl0q@google.com>
Message-ID: <9huzqzk4zt3n.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 01/11] liveupdate: Add LIVEUPDATE_GUEST_MEMFD config option
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
>> Introduce the LIVEUPDATE_GUEST_MEMFD Kconfig option. This option
>> enables live update support for KVM guest_memfd files, enabling
>> guest_memfd-backed memory preservation across kernel upgrades.
>> 
>> Currently this support only guest_memfd files that are full-shared
>> (INIT_SHARED and no support for private_mem).
>
> Why?  Specifically, why do we need/want a separate Kconfig for guest_memfd
> liveupdate versus KVM liveupdate?  I can _maybe_ see a KVM-wide Kconfig, but
> even that seems like a stretch given that (AFAIK) hypervisors are the one and
> only use-case for liveupdate.

LIVEUPDATE is used in many subsystem. It is possible to enable
liveupdate and kvm without enabling KVM_GUEST_MEMFD. So GUEST_MEMFD
preservation must depend on CONFIG_LIVEUPDATE and KVM_GUEST_MEMFD both.
LIVEUPDATE_GUEST_MEMFD Kconfig is wrapper on both of them. It need not
to be visible in menu, So I can make it hidden. WDYT?

Also, KVM VM_FILE preservation and GUEST_MEMFD preservation both depends
on LIVEUPDATE_GUEST_MEMFD in this patch series. [PATCH 05/11]*
Which is wrong. So I will update KVM VM_FILE preservation to depend only
on CONFIG_LIVEUPDATE.

*https://lore.kernel.org/all/20260728121138.1103610-6-tarunsahu@google.com/#Z31virt:kvm:Makefile.kvm

~Tarun
