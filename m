Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4195874E26
	for <kvmarm@lists.linux.dev>; Tue, 26 Mar 2024 13:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460730; cv=none; b=sAUEDdJ9jcuPnlqVyItpG0edcyk3Aww6nQNfXH0gEr9Oc9otDDGrtl6hx5caJx87uM/lopkHMIp9QrLLEnVJGSlRlBIHXSceGRBmcwBiCtHksfdCyMPxcCvpTtzgYXAhz3RrjyY1bN0Fwn3960iqYPm0Yfju+Tj8xMlTLwgD61s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460730; c=relaxed/simple;
	bh=gAfJn70+/O13yr5TgLcsB9c+Q1+HlFFjPNvvLX7CW3w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NJR6kVD4UuonlwhinFnBuJuASRJlFNHegtz2INwkV/os3Pj6dDqoSaR/zanN7Y9Ee95cC9BZYbc3k0mFvgIHR31dtNsf5bMhGpnfOrFgzSA3FuTCHafLubV1IM3CZOCV/eFZMsXRD2SaOdg95FO2oFOgI5XGjzbcKui/bfJHWyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NTDlmbb2; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NTDlmbb2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1711460726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iy1638Gji5GqAHqWSkpCZNgx0ltTqhh5TBzza4vhEYA=;
	b=NTDlmbb2R/RlJMzjTVaIcjOySTqWPKoSlVjJL7DfPyUzGfZsRfZJQy+iCLUYoXHXGzQPAy
	sTlYCbb5/EKkyXAPO2LHUQhbDlHFe9sETWxtna9GjCN1tatezXsSJ16FVzS7kmJ4ZqKMkD
	0tyRhOUwb4EFTZuFOpqsFEZneqkn+oo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: Re: (subset) [PATCH 0/3] KVM: arm64: PMU fixes for nVHE, protected mode
Date: Tue, 26 Mar 2024 06:44:42 -0700
Message-Id: <171145902342.369115.4204778201448709312.b4-ty@linux.dev>
In-Reply-To: <20240305184840.636212-1-oliver.upton@linux.dev>
References: <20240305184840.636212-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Tue, 05 Mar 2024 18:48:37 +0000, Oliver Upton wrote:
> Series to address a couple of issues I've hit using the nVHE / protected
> mode configuration:
> 
>  - Host-programmed PMU events that run during guest execution do not
>    work if the VM doesn't have a vPMU.
> 
>  - PMU events do not work at all for non-protected VMs on the
>    protected-mode hypervisor
> 
> [...]

Just applying the commit that fixes nVHE, I'm happy to ignore the
pKVM issue until the 'real' vCPU context changes appear upstream.

Apologies if this email comes through garbled, I can't access my
usual workstation right now.

Applied to kvmarm/fixes, thanks!

[2/3] KVM: arm64: Fix host-programmed guest events in nVHE
      commit: e89c928bedd77d181edc2df01cb6672184775140

-- 
Best,
Oliver
