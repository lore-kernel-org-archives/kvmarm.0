Received: from out-193.mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE175232
	for <kvmarm@lists.linux.dev>; Sat,  7 Oct 2023 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="p2Zqefet"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696697469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PD6DelPyIarsG358FrNcOASN0EK3MglrfUxEZjToTWo=;
	b=p2Zqefet/KQDqEGOuqt+c4679DOL9UU5X1TcP3Lww5fuoA3TszMTW2Cf+5a05vzJ+f8R77
	fGmXEsUFxZfav0vNG5y4lI/ixI0QlYLKr3iR5QuCi8TfpS2i7B06FEY4Yf5Q6qJULdH4Fs
	fSElB1Zx4qT7G23Paf9tZrphbFHAtFM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	james.morse@arm.com,
	wanghaibin.wang@huawei.com,
	maz@kernel.org,
	ricarkol@google.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH 1/2] KVM: arm64: selftest: Add the missing .guest_prepare()
Date: Sat,  7 Oct 2023 16:50:58 +0000
Message-ID: <169669744270.1461191.10624180670304369750.b4-ty@linux.dev>
In-Reply-To: <20231007124043.626-1-yuzenghui@huawei.com>
References: <20231007124043.626-1-yuzenghui@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sat, 7 Oct 2023 20:40:42 +0800, Zenghui Yu wrote:
> Running page_fault_test on a Cortex A72 fails with
> 
> Test: ro_memslot_no_syndrome_guest_cas
> Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
> Testing memory backing src type: anonymous
> ==== Test Assertion Failure ====
>   aarch64/page_fault_test.c:117: guest_check_lse()
>   pid=1944087 tid=1944087 errno=4 - Interrupted system call
>      1	0x00000000004028b3: vcpu_run_loop at page_fault_test.c:682
>      2	0x0000000000402d93: run_test at page_fault_test.c:731
>      3	0x0000000000403957: for_each_guest_mode at guest_modes.c:100
>      4	0x00000000004019f3: for_each_test_and_guest_mode at page_fault_test.c:1108
>      5	 (inlined by) main at page_fault_test.c:1134
>      6	0x0000ffff868e503b: ?? ??:0
>      7	0x0000ffff868e5113: ?? ??:0
>      8	0x0000000000401aaf: _start at ??:?
>   guest_check_lse()
> 
> [...]

Applied to kvmarm/next, thanks!

[1/2] KVM: arm64: selftest: Add the missing .guest_prepare()
      https://git.kernel.org/kvmarm/kvmarm/c/45c9683d5ce1
[2/2] KVM: arm64: selftest: Perform ISB before reading PAR_EL1
      https://git.kernel.org/kvmarm/kvmarm/c/a9c9864f3c2f

--
Best,
Oliver
