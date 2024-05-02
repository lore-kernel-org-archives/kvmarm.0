Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A445556B73
	for <kvmarm@lists.linux.dev>; Thu,  2 May 2024 10:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714644682; cv=none; b=ZIaO1b32hXrSm96W7JroPHvR6Ics34z3iwmFO3STNCbfF8cIolf31DCJkvT6ewSzxMJ6GUJRYJaAdpgxfeOFD4QAn5tRW96KEly+CRES7Fzgf2ZZj1MS8qrfAUZxrz8RmBCYdOUgJFmpn4gamsELsgvVp0E6MZn727E0tSpEnSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714644682; c=relaxed/simple;
	bh=7dcsPu7CPfetIHLBuly2zBTe/e14bVh8lZfmBoiZszk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R0MSQAEPpzD35F7gz76EavmaXvIu930Fuyaq5jNAlo4nMa1oHrioc+aSPDF2ZTjXeDM2vZaGZMFP9GGHEj8FNqZtHfrUQXN0UueGqf+MN094FScMh6Y+SRxg4FsClbtr0zC9v72+ru4w4n2nWrP+IsPG8WmF1YPilJmi5TfNkBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rUEu0fgN; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rUEu0fgN"
Message-ID: <c59146ec-fac3-47f5-ae2b-4f74db11b55c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714644677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bqolwl4lR31IKj9AKrAjAeQL2Yk/FzNTidMmKRxxIJ0=;
	b=rUEu0fgNmbFi4hEzKwX8HN+WPcJiZeWmLEHVMnqlei9k7tq2veUyb3cIlJzWbmcxCPt+Io
	cXTJnb5/8I0Q/BrGTdqmXNm5PDTzOVsX+bjx2KI/l06SP5guLZ+Jt/vhsN769ztGLKlxcU
	zZZZAnsQZPMEGQB4BnzvB2EgNTe2v7g=
Date: Thu, 2 May 2024 18:10:55 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [kvm-unit-tests PATCH] arm64: Default to 4K translation granule
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Andrew Jones <andrew.jones@linux.dev>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Huth <thuth@redhat.com>
References: <20240502074156.1346049-1-oliver.upton@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20240502074156.1346049-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2024/5/2 15:41, Oliver Upton wrote:
> Some arm64 implementations in the wild, like the Apple parts, do not
> support the 64K translation granule. This can be a bit annoying when
> running with the defaults on such hardware, as every test fails
> before getting the MMU turned on.

Yup, I had to manually specify the translation granule before building
(and running) these tests on M1.

./configure --arch=aarch64 --page-size={4k,16k} --cross-prefix=aarch64-elf-

> Switch the default page size to 4K with the intention of having the
> default setting be the most widely applicable one.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Acked-by: Zenghui Yu <zenghui.yu@linux.dev>
