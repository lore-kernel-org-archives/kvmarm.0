Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CC42765E2
	for <kvmarm@lists.linux.dev>; Mon, 20 Oct 2025 16:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760978058; cv=none; b=T5fvuE0eHhZHAPYMJ4zFBoneCXDo0Du1wCXt4eXlUm6ZouGW3FJ66gOauYnBxGiN0KxUKgdMbHu1RzF7Gltw1/1OQ4ZD2bza3Z7rcvIVa9BWIEWk1oxEDxfbPqLmIGVnVZbK2EY3ngMyloJM2ciyX5ZX8QpqT/L2D1xe+pgLNG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760978058; c=relaxed/simple;
	bh=B8q5ZAlve72N7q6bvOSXGkHTppjdvye5yLKtODQe/Mo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MREYkwwLd3bzqtnoQMHIdXgMeXAFk57mauH5Bvx7+uwQnO5wJprxVxN2gxW+sDT8I2AX8CFCN5o+BahW9474gYQrYs7cAGTF0tPYxYW3RDGX9Dlasf+oARf/ZBjOjvEbMMuS4HT5L9v/dWkTP40VmsugQTGzWK1IL88SVJgMJJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l5DRFYU1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l5DRFYU1"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bb3b235ebso8889820a91.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Oct 2025 09:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760978056; x=1761582856; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U281t6YsVgadzh80Xr8uQlzQ8nsQRfoBdqQApEXayt4=;
        b=l5DRFYU1dEIqg1+YwSx7aEig6U73DzSHNVdSro51AmrODvM2yQELEgPW9Gy3vuEFAN
         Yd3Q3HRZFa+/aKvhjf9xaGSeyPHOcMcSaRRtLRUgD9ZWqNk5v8Sv1AksJZ+UxcE+0Tjc
         zywBVPDlx85lIXAvuMab0tuRGFF82W2OUZcHCkyTG3yi8rO7XJt7erG1U9MW/lt9o34T
         G1A1MCf19rIOIziifgHvmGuKGcRSKPLe9i/KdDI5qPSOYCWusTpCtZCWg9zidZF1zJsW
         NFV9T8IYTn9qTvCm7mxAgVXnHpsjVfsNNsNucvpnQVc/3TXHTGRjHSu9SdLx75ghtYhb
         cg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760978056; x=1761582856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U281t6YsVgadzh80Xr8uQlzQ8nsQRfoBdqQApEXayt4=;
        b=T+mUogkZofIsZeyAayhuUqUOp634LLEwV9ROYgBQZlX6jmNa6y8yFWeKlzdJa97GJn
         qhjyQpcdNHLFkDtvqc+t8YWnYOCoygxRLkfuZE59/mFjvlPbPW8+TzeLe++huOGWtn4D
         9qjDIh8oCp8CHPsFItAEjV0s1a2wFtr+KADa205el1hwGDvaqAZ3yoyS3sso7CHIVkDR
         OyRQbekyWJlXLRGGrQP9Toq/IIpeKwqGDa/c4AvN5gTv2GEhqj5E17/RrtzuuZR1wcVE
         CjZoNvqUjLGugRLrgIFTJRwS9jFQkXi39byG8mitpZOkrWhafg2qI/xRkPfVQweCSjQX
         5DBw==
X-Forwarded-Encrypted: i=1; AJvYcCUzp1MpExAeH3ElE+9i+L4tGP23QfnrTPWV+qhG6k33XUlYD8KV8OMwmIc7VHVOXHq7J487K2Q=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7moaxQ8OvQjOy+UwLlqOD/5uohxmvPAsy9no5k84OL+p/Ipj+
	6y3ZRoDSXCDrUUpKnZp6QCf+W4QT1wa6SN3o2h6gxmBTN/gU/hkW3BNjtZHG9BiCGHCJM3aNKCH
	vG5YVxg==
X-Google-Smtp-Source: AGHT+IH/2gIQckIGBvPLTgMI5nZTn9xen9JOJcaPgjLLw4FsDPxt8568zPXkGc37Szl9ifCv4T+uIb3eOmI=
X-Received: from pjoa3.prod.google.com ([2002:a17:90a:8c03:b0:32e:a549:83e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a49:b0:330:82b1:ef76
 with SMTP id 98e67ed59e1d1-33bcf914d79mr18775090a91.28.1760978056031; Mon, 20
 Oct 2025 09:34:16 -0700 (PDT)
Date: Mon, 20 Oct 2025 09:33:05 -0700
In-Reply-To: <20251016172853.52451-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251016172853.52451-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
Message-ID: <176097602114.439246.7705198528866990456.b4-ty@google.com>
Subject: Re: [PATCH v13 00/12] KVM: guest_memfd: Add NUMA mempolicy support
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>, Shivank Garg <shivankg@amd.com>, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="utf-8"

On Thu, 16 Oct 2025 10:28:41 -0700, Sean Christopherson wrote:
> Miguel, you got pulled in due to a one-line change to add a new iterator
> macros in .clang-format.
> 
> Shivank's series to add support for NUMA-aware memory placement in
> guest_memfd.  Based on kvm-x86/next.
> 
> Note, Ackerley pointed out that we should probably have testing for the
> cpuset_do_page_mem_spread() behavior.  I 100% agree, but I'm also a-ok
> merging without those tests.
> 
> [...]

Applied to kvm-x86 gmem, sans the .clang-format change.  Thanks!

[01/12] KVM: guest_memfd: Rename "struct kvm_gmem" to "struct gmem_file"
        https://github.com/kvm-x86/linux/commit/497b1dfbcacf
[02/12] KVM: guest_memfd: Add macro to iterate over gmem_files for a mapping/inode
        https://github.com/kvm-x86/linux/commit/392dd9d9488a
[03/12] KVM: guest_memfd: Use guest mem inodes instead of anonymous inodes
        https://github.com/kvm-x86/linux/commit/a63ca4236e67
[04/12] KVM: guest_memfd: Add slab-allocated inode cache
        https://github.com/kvm-x86/linux/commit/f609e89ae893
[05/12] KVM: guest_memfd: Enforce NUMA mempolicy using shared policy
        https://github.com/kvm-x86/linux/commit/ed1ffa810bd6
[06/12] KVM: selftests: Define wrappers for common syscalls to assert success
        https://github.com/kvm-x86/linux/commit/3223560c93eb
[07/12] KVM: selftests: Report stacktraces SIGBUS, SIGSEGV, SIGILL, and SIGFPE by default
        https://github.com/kvm-x86/linux/commit/29dc539d74ab
[08/12] KVM: selftests: Add additional equivalents to libnuma APIs in KVM's numaif.h
        https://github.com/kvm-x86/linux/commit/2189d78269c5
[09/12] KVM: selftests: Use proper uAPI headers to pick up mempolicy.h definitions
        https://github.com/kvm-x86/linux/commit/fe7baebb99de
[10/12] KVM: selftests: Add helpers to probe for NUMA support, and multi-node systems
        https://github.com/kvm-x86/linux/commit/e698e89b3ed1
[11/12] KVM: selftests: Add guest_memfd tests for mmap and NUMA policy support
        https://github.com/kvm-x86/linux/commit/38ccc50ac037
[12/12] KVM: guest_memfd: Add gmem_inode.flags field instead of using i_private
        https://github.com/kvm-x86/linux/commit/e66438bb81c4

--
https://github.com/kvm-x86/linux/tree/next
