Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4202773D4
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 17:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761844717; cv=none; b=lY/Xdh3sKIqGkf5Sl5bE/E2+X4rpeKbYvX/uT1UebmVh8IjgE5W/om//KcY+92XKeYc26vsSm/OIpiNJ/TWn9/Sn956BTCm0vP34RDTqFW6ECzw328f8oit0vlqLHjpMBUdlk+bh/WpH9LhKNigPKYyzdJVIPMPs3BMq+hb+W18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761844717; c=relaxed/simple;
	bh=VJLcmOospl0NvxJ/WTOkbujLbTnBJibWwvHUpjZ0/1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VY451rGsPM9RMgsCls3Wck88sJHUwPQ1ZWC2HvG54n5CTg9FMomv8DMLHpCIJ4yjnqsZppWdtJwdIgoJqD4dkhvz7qsGxcyPuKzmYHm/k1p2mFHqVhp3m2KeHqDF7EJjMKbwxd/JKlZ4gUQULCrngPgk16YSgw8VjtUb1EEZAOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CrHzVV/X; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CrHzVV/X"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4710d174c31so11061515e9.0
        for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 10:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761844713; x=1762449513; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0zIsYr/NZ5vBEDYePNHV7frUHCwl+Wvsd8lZxHFgSTA=;
        b=CrHzVV/Xd1JmNgG8XcgFxCzXBGYnrHbpH/Hq5VzCavsS8Llt1zFnHuGH5HgcwQ4tEA
         XqwYr4UVBv9RHhJpmN+eDYtzavxQyI4IAlGSTSRNwdX3rOdKDEgUQNEy77zBne9CtY4s
         XVUeARZZRzSD16TjYJnvZ2TmKmhjOqtLEFjzzEOSyNNHEwIcuVCeUKlkhvB2tXPJZQ9d
         a8Yw6n2fm6WnmCcJzulD0iQ6j/Lj8UJqoCzlzM/LC9Z1PlMr/t0Otmm65yNTFZawNBKi
         LuBOUNeKU+DACyXwzJ618XWpaBE5Ojo8nSn4b0A8KhTJD3duIZb8tLC46ox9UuUSzi8H
         j5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761844713; x=1762449513;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0zIsYr/NZ5vBEDYePNHV7frUHCwl+Wvsd8lZxHFgSTA=;
        b=HYCstDRUKtd+DIiFhHij5/wm5gHpwz2RSDX75MG+PGG6kAPhH20wqLJvscxdt4eS9d
         xS9QwSLTr4tfPXusAys91+0ssukocxjN2f3063YJSo/M3AZKK14RKLmKk8+eLv+zgHKN
         Gt3pMV3S9SSMnU/ggXx+rUFZSmSS44KrvC2ou7FpruWvtL8WTUB/dRxTWI9qLQ6uIPU9
         pasB2lUWjuGnTnJTA6sr3tY1ssojIfde54e0RrBBocyp+zUPXWhcq7Xb8qKZhH48Acen
         e//HlNA1aAA0QK800/pTFytMwqFyZsBua/bp99RWQX8iz8OWcHdZ55Oe9azBbuoEdy15
         rkLg==
X-Forwarded-Encrypted: i=1; AJvYcCUF8bMLOqZUtcSyN46p5GciD303Q3elpt206S3zE/GY04ZaBFGFOkFZqc8w14xcGrq9GwQ6jyg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOCReQcDfmBKN1qAjEXyOurOhMTCsQFvG571MNr4UFnbxpf+jt
	6zZRwrYnco/dnKvb8e2EIl6Dmy8vjK3ZCCYy9+cUUXYgUlzcLOjvCYGXuMlp0VSvZu/ECfgCaB5
	JiRe1oYSt+sAVRw==
X-Google-Smtp-Source: AGHT+IFXk6DKJ2LvWY2ZBOreY5EWyiD1FLIIWcEezkT9L8CiZAonL3OXc94rN18lwM8G/At6waViWG4yx0JY7g==
X-Received: from wmbka6.prod.google.com ([2002:a05:600c:5846:b0:470:ffaa:ae5e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b8b:b0:471:989:9d7b with SMTP id 5b1f17b1804b1-4773086d53amr4625785e9.21.1761844712453;
 Thu, 30 Oct 2025 10:18:32 -0700 (PDT)
Date: Thu, 30 Oct 2025 17:18:31 +0000
In-Reply-To: <20250924152214.7292-9-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk> <20250924152214.7292-9-roypat@amazon.co.uk>
X-Mailer: aerc 0.21.0
Message-ID: <DDVTTQZBJXAK.1OC7BTWCVCP9U@google.com>
Subject: Re: [PATCH v7 12/12] KVM: selftests: Test guest execution from direct
 map removed gmem
From: Brendan Jackman <jackmanb@google.com>
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"song@kernel.org" <song@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>, 
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed Sep 24, 2025 at 3:22 PM UTC, Patrick Roy wrote:
> Add a selftest that loads itself into guest_memfd (via
> GUEST_MEMFD_FLAG_MMAP) and triggers an MMIO exit when executed. This
> exercises x86 MMIO emulation code inside KVM for guest_memfd-backed
> memslots where the guest_memfd folios are direct map removed.
> Particularly, it validates that x86 MMIO emulation code (guest page
> table walks + instruction fetch) correctly accesses gmem through the VMA
> that's been reflected into the memslot's userspace_addr field (instead
> of trying to do direct map accesses).
>
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---
>  .../selftests/kvm/set_memory_region_test.c    | 50 +++++++++++++++++--
>  1 file changed, 46 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
> index ce3ac0fd6dfb..cb3bc642d376 100644
> --- a/tools/testing/selftests/kvm/set_memory_region_test.c
> +++ b/tools/testing/selftests/kvm/set_memory_region_test.c
> @@ -603,6 +603,41 @@ static void test_mmio_during_vectoring(void)
>  
>  	kvm_vm_free(vm);
>  }
> +
> +static void guest_code_trigger_mmio(void)
> +{
> +	/*
> +	 * Read some GPA that is not backed by a memslot. KVM consider this
> +	 * as MMIO and tell userspace to emulate the read.
> +	 */
> +	READ_ONCE(*((uint64_t *)MEM_REGION_GPA));
> +
> +	GUEST_DONE();
> +}
> +
> +static void test_guest_memfd_mmio(void)
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	struct vm_shape shape = {
> +		.mode = VM_MODE_DEFAULT,
> +		.src_type = VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,
> +	};
> +	pthread_t vcpu_thread;
> +
> +	pr_info("Testing MMIO emulation for instructions in gmem\n");
> +
> +	vm = __vm_create_shape_with_one_vcpu(shape, &vcpu, 0, guest_code_trigger_mmio);

When I run this test on my minimal config in a nested VM I get:

[root@testvm:~]# /nix/store/xlxd60n7v1qfr6s5zxda410zrzdd0xc2-kselftests/bin/run_kselftest.sh -t kvm:set_memory_region_test
TAP version 13
1..1
# timeout set to 120
# selftests: kvm: set_memory_region_test
# Random seed: 0x6b8b4567
# Testing KVM_RUN with zero added memory regions
# Testing MMIO during vectoring error handling
# Allowed number of memory slots: 32764
# Adding slots 0..32763, each memory region with 2048K size
# Testing MMIO emulation for instructions in gmem
# ==== Test Assertion Failure ====
#   lib/kvm_util.c:1118: region->mmap_start != MAP_FAILED
#   pid=614 tid=614 errno=19 - No such device
#      1	0x0000000000407b02: vm_mem_add at ??:?
#      2	0x000000000040a924: __vm_create at ??:?
#      3	0x000000000040ab16: __vm_create_shape_with_one_vcpu at ??:?
#      4	0x00000000004042cf: main at ??:?
#      5	0x00007faa6b08a47d: ?? ??:0
#      6	0x00007faa6b08a538: ?? ??:0
#      7	0x0000000000404384: _start at ??:?
#   mmap() failed, rc: -1 errno: 19 (No such device)

Here's the kconfig I'm using (basically defconfig+KVM): 

https://gist.githubusercontent.com/bjackman/4ea941ef5072606769211f3b000c8ed7/raw/73808882ddae6ff2ae8a0be85ac977b2980f7292/kconfig.txt

Sorry I'm too ignorant about KVM to know what I'm missing here but I
guess it's a missing TEST_REQUIRE()?

