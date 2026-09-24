Received: from mta0.migadu.com (out-160.mta0.migadu.com [91.218.175.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1483148DA
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 06:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790230150; cv=none; b=JJAuJDatOM1KJBmc9BeVs+9Xir96iAB42tMDAp8WoaIYVP7eYXeVSfsRvSkRJsxM9e1WdcojGDCaM3dqVopQezknXPoHlxkpHxU4nqrcIhp4kNXGWzCn/AFDXACDeVjmarIeIg1SYL+JECSgz97L4HoNOgHsw2HNpfUQ4z8J3Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790230150; c=relaxed/simple;
	bh=RyyiC0ofM8CGzkXnRUfQTw+HLZ/pLb7WijiCtVOlmu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PpnO1VAMKhVe+sqASCECX+X1NhCld9u67JDw82sS9qF3Qq+zWH7acy3MGJ7QAfNwmPDOkIgQPrHiVBehQvUPLkYcgUe6OiAI0JtLPq0elf9bxa7bAYYWCg2d9yZK6rd5hsiN+64tkPMyUqMLnXc6O+bdZ89680nLV8GueyCxfDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eNiVICVB; arc=none smtp.client-ip=91.218.175.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eNiVICVB"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=RyyiC0ofM8CGzkXnRUfQTw+HLZ/pLb7WijiCtVOlmu0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790230146; v=1; x=1790834946;
 b=eNiVICVBRhgDhGI3qlXj9Y3GWayqaaU9almBvG7o6AUNROowSRoUi7Uz2t+VHW5JOCdV2jm7
 jK/xSmgErZIn8LFr9K5wNBdVNTCi8qadSBVzif6+MKseJOGz/E/yB87Gab3Jf5ryBrbBsQ8NyhK
 5e2zrO/2+OkKWX1WYs0NPWgQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e4742196d6c9ef31;
	Thu, 24 Sep 2026 06:09:06 +0000
X-Mizu-Trace-ID: e4742196d6c9ef31
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b8c42da963so6105e87.0
        for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 23:09:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwEOi9kZk1XlEWNO4xkZfg2tbe6sdmWcvMpSPJn8rVUqWwKaYW+EqV9FOtLJDbmAEe4E/D5zDU=@lists.linux.dev
X-Gm-Message-State: AFuF++mfM70CBLMa5+DOUDWcmn2Q55IpVVgGQOK+RmuZqQgvicFHRZ7w
	yREqtWDImn8msQj/70YJ92N9nab08hRUcMiM+Pl+VGgWmCwp+0S0XM5ZOAmg6S979Jqe6ZlDDxL
	ejC3O427eQ1EJHgZjTKuoLJNrheQd5yFkCqlM6rvm
X-Received: by 2002:a05:6512:1358:b0:5b2:a967:c0e1 with SMTP id
 2adb3069b0e04-5b8dd6d2b18mr130595e87.0.1790230141441; Wed, 23 Sep 2026
 23:09:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260923-kvm-arm-prefault-v4-0-d4b0b4dfa8c3@kernel.org> <20260923-kvm-arm-prefault-v4-12-d4b0b4dfa8c3@kernel.org>
In-Reply-To: <20260923-kvm-arm-prefault-v4-12-d4b0b4dfa8c3@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 24 Sep 2026 07:08:25 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxAah=pvuTqSYE0-jkXmgWJBrVD33nCThS4SNJN-kfNmw@mail.gmail.com>
X-Gm-Features: AclHuK_kb7tirLzxpH1tqzJpHCuAErXckpMiZSE-Wc4zTJclc5slHcBac4UN3_w
Message-ID: <CA+EHjTxAah=pvuTqSYE0-jkXmgWJBrVD33nCThS4SNJN-kfNmw@mail.gmail.com>
Subject: Re: [PATCH v4 12/14] KVM: selftests: Enable pre_fault_memory_test for arm64
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Mark Rutland <mark.rutland@arm.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Jack Thomson <jackabt@amazon.com>, 
	Jack Thomson <jackabt.amazon@gmail.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Leo Soares Passos <Leo.Bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Sept 2026 at 16:18, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> From: Jack Thomson <jackabt@amazon.com>
>
> Enable the pre_fault_memory_test to run on arm64 by making it work with
> different guest page sizes and testing multiple guest configurations.
>
> Add an assert on the exit reason, comparing against UCALL_EXIT_REASON so
> the check is portable, as arm64 exits with KVM_EXIT_MMIO while x86 uses
> KVM_EXIT_IO.
>
> Signed-off-by: Jack Thomson <jackabt@amazon.com>
> [ljs: merge conflict resolution with commit c847704619da ("KVM: selftests:
>  Fix pre_fault_memory_test to run on s390"), commit message accuracy fixup]
> Reviewed-by: Oliver Upton <oupton@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
