Received: from mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D210947C0E1
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 10:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157841; cv=none; b=UaiZYBxb21LN2TO3SoqD7vH+CveEC37vsx+/2x7NflJMlp738qSCRMR0PDGg5fktJ1WU2Y3kUVb3XjHbMYb/bmYM8zZnRf2x1FVYkcWShiZXlibNAgmJARCrCwLIQH8Hd38NBiR1gRtjnmL3g3pFz+U+sSdRa4VwcS/zleJPsh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157841; c=relaxed/simple;
	bh=xyyxgX6Z2IBzQdllFbMd3l1KS0QkIUQEnt09r+FTDSw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sgbrYVbFInpjtXzA0NJgMOXpv9C56nGvgwybPU3MXLLtp1d57DPBUhsQ/BqF4vua6GvzxYUXyYcq5yXDXo61sosxF6Xx2RBch5cLPode8TM4pjSWSVtGNuPh6RbuwTHwMglmQkRY6T1al301peNXpfsZCNVxMzYLC3b0gRWZW3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w1XL8vr4; arc=none smtp.client-ip=91.218.175.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w1XL8vr4"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xyyxgX6Z2IBzQdllFbMd3l1KS0QkIUQEnt09r+FTDSw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790157836; v=1; x=1790762636;
 b=w1XL8vr4DX/F/SVohxkQna2KJfhkjuYXt02fDxrQxujKZBQh7jRuRg6mVjku4LNVJ5N6DXDz
 ig5jXYnE1ZiQ8xM4OO3vNLCdLqALQGFKi5mtDl1AQt5ycaToPGNqU/t7Tq1FXv89ruqjGuCurlf
 dT1vfOG7BNoo6G6zSGPEkun4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id d79fd0fbba03f54e;
	Wed, 23 Sep 2026 10:03:56 +0000
X-Mizu-Trace-ID: d79fd0fbba03f54e
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5b778bdb5b8so4413e87.1
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 03:03:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwzbeP55nn/XIpPWpdRAF9lOfwEixPLYEXAyPbnaK5FPpm9APr0dBUp6DSjIId0uTmOUE3NlWM=@lists.linux.dev
X-Gm-Message-State: AFuF++lvvRgPmsehgzn+g089nUObCw9fl14t+uB39Xoi4lzeRC8XuKTq
	oZJBAkR17F2ScosnWYrRM3mDuQVLhGb8N9slPnrYsyB4yfo75KbOBG4TRmwQgShzgcDyJj0uKOM
	gpofIZvq1FU6hPOdPRAq12OGHpkJ/RDUH6yQn2lAu
X-Received: by 2002:a05:6512:ba8:b0:5b6:bcb:26c4 with SMTP id
 2adb3069b0e04-5b8d885c755mr142676e87.16.1790157835308; Wed, 23 Sep 2026
 03:03:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
In-Reply-To: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 23 Sep 2026 11:03:19 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzpYRu2xq5VdoxodyDqLTJrcoaSrfGq=DXh283TYPJ-OQ@mail.gmail.com>
X-Gm-Features: AcwNN1Uc3FNAcNduJiv3v9IEKpsaLZzqL8bqap-uQ6FOvMoC3rZk-evpRR8tlZg
Message-ID: <CA+EHjTzpYRu2xq5VdoxodyDqLTJrcoaSrfGq=DXh283TYPJ-OQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Lorenzo,

On Tue, 22 Sep 2026 15:17:54 +0100, "Lorenzo Stoakes (ARM)"
<ljs@kernel.org> wrote:
> This series implements the KVM stage 2 page table pre-faulting feature for
> arm64.

There's likely going to be a respin for the arch hook, but FWIW,
tested as follows:

QEMU/arm64 -cpu max:
- guests boot on VHE, nVHE and protected-mode hosts, protected guests included
- pre_fault_memory_test (all guest modes, anonymous, THP, hugetlb and
shmem backing) and nv_pre_fault_memory_test pass
- pre-faulting an uninitialised vCPU returns -ENOEXEC
- dirty_log_test, demand_paging_test, mmu_stress_test and
stage2_block_transitions also pass

Apple M4 (nVHE, 4K and 16K pages):
- pre_fault_memory_test passes on the five guest modes available
there, with the same backings
- in protected mode (4K pages), the cap isn't advertised, the ioctl
returns -EOPNOTSUPP, and guests boot

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
