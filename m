Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7106547A87B
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 16:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070592; cv=none; b=M3+QZTEnWkwOQ7KNYm1vs/dIWy7U/AMLbtC4CKuyaltAoi+F05hTfLoTqn49HcUQtW3uroRj40Xm9YExUrRKKvmrKT6TSHLUROWgXOfn1nPsgPlGmekvxgza35Q/U9+YxMUoC8K35G+Ga/ATUNutodUfyI42nGHHC1pxAaSGReA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070592; c=relaxed/simple;
	bh=vC2RlolhkLS2+1s4l2UramjQAZbiE9X0zYRFDEG/2wo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QR2hl/kAPHavbGDZ8d4ZdPF5b+jVwlW6m8oOqETISd0gzrrEAVwU8CgPfGPtOvDjA49mQtPHKpb8SuMyaQ8H9tWAd8e8TRVthxUXdVtQ3GVYjq/4BDpm7f6d899CYA8oxEZihDkonMVzeX9Ec5NoPu8IUj7FYpv1av+4JtWYJSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jR8sXqg4; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tarunsahu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jR8sXqg4"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a3f8cbd9feso21682a12.2
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 09:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787070590; x=1787675390; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/eyzaZNjJLEyd0fKbeRAuoUQBuqF6sdPIInoyVaJmj0=;
        b=jR8sXqg4AqXeYJhPKdGeNX2GeybnAAxUboKHlzhVdFBbeBqQ/8gl/0MrzPyWBVc74L
         SnkR2xS83nPO9NEknhU80v4ur1dAlf1SOKoUUeOAUOppOaNQjaWEBSOJ1rkOxQyoPpgK
         9xHv9DdGcNrpiwxl7qrDLLJ7TH/Q1abJoEeTkFYaXX9rCE7BzRdXDaO+SYOSAT/0azfR
         UYvTloPuQKm9bVCnI6WoXDiCNMkBsLK8sgFu1v/Dpl6ZNh6mHIaGoOOBCOteoy6Xl8KG
         +gtgSYp68KvwkhGi5YCuJ4CLk05AiUptTlxvaq8sXhGZvRgcfViiy4iag5wFxD564Rhm
         h+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787070590; x=1787675390;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/eyzaZNjJLEyd0fKbeRAuoUQBuqF6sdPIInoyVaJmj0=;
        b=OrcxNBfKCJlhGN4MQ4Nw7l3mqEtELu//J6c78rzS154/EwyHo2BSJGGdvEIst0CWy2
         LCRGuxcPDz9l9zjJ3ktyL8RFkmBGueoAykuNQ51k8QqyBV1+/2kquh+26y+XjQLlNtJj
         lL0BAfbXPEq937QkX7RxQmjAwho7FK2Xeezve4EghaYv2kxO69pKrc1ZmOsUNxcDtmhw
         klSF9giasdD3KDSDQsozGf104o5mWvrKTcjV1zLX9RNa+9YjSuC05S9jRykwwsdbqW1Z
         hTkOb9IThLO/r0zubPLasHKbWA9lmzjflNPTNNaZelLLceOgzeG+6Tg9YCXaPF1Zo7+o
         Clrw==
X-Forwarded-Encrypted: i=1; AHgh+RplTGKDyeSp41YacWv/4HLT8GGNJtM7Wjd/CqWeK5hQz5dYliZlABALx+El1GQgesjZWP7kGwo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+yUi0UQrd2HdhGofujYrf71n+NIFuk8GRB0Hqm3FD3K8Q9Ywi
	AEUr2kcvjTZaUawkpTXhiakn2yEcGeyH3ZNZk1NXdZCnPiqs6xAuXuZq0FduQBtj8MEBZB7avgM
	Q0BlnOGxdqQM0UWRh9A==
X-Received: from edts26.prod.google.com ([2002:aa7:cb1a:0:b0:6a1:f410:2ec5])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:e85:b0:6a3:edb6:2228 with SMTP id 4fb4d7f45d1cf-6a3edb6285cmr3681617a12.17.1787070589499;
 Tue, 18 Aug 2026 09:29:49 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:29:48 +0000
In-Reply-To: <anpdYD1UaO0ffQgi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260728121138.1103610-1-tarunsahu@google.com>
 <20260728121138.1103610-5-tarunsahu@google.com> <anpdYD1UaO0ffQgi@google.com>
Message-ID: <9huzik57v1c3.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v4 04/11] KVM: Track weak reference to vm_file in struct kvm
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
>> - Add a weak reference 'vm_file' in struct kvm under
>
> "vm_file" is effectively already claimed by vm_area_struct.vm_file.  *If* we go
> this route, I would very strongly prefer to take a dependency on "vfio: Use
> file-based reference counting for KVM"[*].  I'll poke that thread, we really
> should land that one particular patch long before the s390-is-arm64
> insanity.

[*] Seem interesting way to solve this. So we will also have vm_file
directly in guest_memfd instead of struct kvm and refcounting on vm_file
instead struct kvm?

struct gmem_file {
-	struct kvm *kvm;
+	struct file *vm_file;
	struct xarray bindings;
	struct list_head entry;
};

>
> Empashish on "if" because this all feels backwards.

> It's not at all clear to
> me why liveupdate goes directly to guest_memfd, but then requires a token associated
> with the VM.

guest_memfd can be recreated without having the struct kvm, Which there
is no way to pass it on retrieval path. So the function
kvm_gmem_luo_retrieve() gets this VM token, find the vm_file (hence
struct kvm) associated with the preserved guest_memfd. Now it create a
fresh guest_memfd by calling kvm_gmem_create(..., kvm). And populate
preserved flags and folios to this guest_memfd.

>
> https://lore.kernel.org/all/20260731130902.654679-2-seiden@linux.ibm.com
