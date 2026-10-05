Received: from mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2703932D3
	for <kvmarm@lists.linux.dev>; Mon,  5 Oct 2026 08:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791188916; cv=none; b=eNZiZrbb+hxPpInLXIupiG4G8X8Y18n+1wtIH34Nvn01OE1x5KNkwewetrDCVs16K0yHNGvBO0sCXlY6fuBDrJgyOO29qjgH6FlwflHausTbrDui7wN/hRPhwZeERS8ohnwpHaRQ9K9m0MRSp/8SsfCKaW3jAIUx9zTOBXCERS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791188916; c=relaxed/simple;
	bh=azL6RWzxNPLFbjqexUqOSuUWiCvD6BgcwHGYwvXeEQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M2o/GljEp/cWRT51KQ+KBP6T/1/8Wbzmq15KxyvGMcFjh8f6k6Ykx64va0vRMIlav3LT3Fgbrz3dpX9hPXY6ygzkncdvYBIglZp4G3HSyjx1x3icGnRcvW7tUelxuPCOfCOczIeka2/NCmH7RC6XuJFJLCuZgFC2XjyBJd/lIks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RefDkvbg; arc=none smtp.client-ip=95.215.58.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RefDkvbg"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=azL6RWzxNPLFbjqexUqOSuUWiCvD6BgcwHGYwvXeEQQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791188906; v=1; x=1791793706;
 b=RefDkvbgGSmLsOec0nyqeXVejqLTmL2t6WKYsfipdd+7xBNCQjjZ2I8vEjANuKmA46dONAHw
 73y1z+TFgJiCIisfbhJNBqPWSMEzvjP3vAXXzz5mrUaTQv3yYzzeUvLU3NdBhfn2JAQtnOGW66Y
 fxtsdGcFeC4KNCyq8fqLPB/A=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 814c23d57508982f;
	Mon, 05 Oct 2026 08:28:26 +0000
X-Mizu-Trace-ID: 814c23d57508982f
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so6049e87.1
        for <kvmarm@lists.linux.dev>; Mon, 05 Oct 2026 01:28:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByx187qfb7/Tz72WphgQBEfnvWVYhvODXHjDNreXinpSAfjHQJd0YwHWh/FTWNHxsZHVNX7JHQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYLkywqSo4I6zqmtFOP78D9Ee2nWym30AkhfZpAQXqXkIr/BxdOE
	pInP1Ou6VsUnUmxGBcfgqlWtDh+j0+uGzBhYLLTDXLs/oXMkMl1td1lcKZ9HyHmtmhb4SKk7mZD
	0GM1W4+Uva8GB/ulvKKP1VxWPwIe6YPujJzu6C+47
X-Received: by 2002:a05:6512:440e:b0:5bc:b531:51ea with SMTP id
 2adb3069b0e04-5bcb62cfb9dmr110049e87.13.1791188905794; Mon, 05 Oct 2026
 01:28:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261005050349.836795-1-fuad.tabba@linux.dev> <asNdAXGkxagm88Su@kernel.org>
In-Reply-To: <asNdAXGkxagm88Su@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 5 Oct 2026 10:27:49 +0200
X-Gmail-Original-Message-ID: <CA+EHjTxG=JUc7qERzdkOE4hEMUVSWK2AUtcR1JJ-k6S0m_RxqA@mail.gmail.com>
X-Gm-Features: AclHuK_skcmiWKYt-g9sV07lqcK6sGjUvRohlQWsrIQerdG0YwJX1vJl3n2KYq4
Message-ID: <CA+EHjTxG=JUc7qERzdkOE4hEMUVSWK2AUtcR1JJ-k6S0m_RxqA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: selftests: Check SError is not pending
 after delivery
To: Oliver Upton <oupton@kernel.org>
Cc: maz@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	vdonnefort@google.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Oliver,

On Mon, 5 Oct 2026 at 10:17, Oliver Upton <oupton@kernel.org> wrote:
>
> Hi Fuad,
[...]
>
> Can you add coverage for the vCPU events state to all the test cases? In
> addition to the case where the SError is taken, it'd be good to assert
> that the SError remains pending if the guest masked it.

Will do,
/fuad

> Thanks,
> Oliver
