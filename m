Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A635F1D0DEC
	for <kvmarm@lists.linux.dev>; Tue, 26 Nov 2024 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732636792; cv=none; b=dLu0eT+UIpHgvuROYhWaaIOHC10DhiqYjkooj+EQLJl/RI9Uxj/py05ghiO9qiyEIxRUgEtc04R7aLGh25dQlg9Uezv1Wv0dfme3ESx5qQKzXnnVC9+FefTFomTzZpky4ps9ARV/crF0aG5CuxGoTTJnVdzIbm7I5XqohYdyugU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732636792; c=relaxed/simple;
	bh=PAhgFFqdRVSQ2GKrCLoe0dYOx9zlLTLNf1wb3Pbh3Q8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dVfaheKfDcFQtPP5EwsZycT7TcbH4h+IE5Zaoj1Q4z1D43x7hStKrqJieMfVhSprZW2JchvQjylCE7xRMRbPKYjMWqHuz9Za+hNMCGPoeHrn0O6SD9WQgxKuO9cFf7YnoIZzcrnHa+2KmyGmitR+8DCWKgYfzg3nk5lYAnmXUhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lNz1k5GD; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lNz1k5GD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732636788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gkp2Sapys0kYO8jsfPFmjfn0MzZ+IuSBffwFi5s29j4=;
	b=lNz1k5GDxV0nlmh//gs1hBl4HHm7gCFmQducd817A/IXnbmXFuJkb+QtyHC/xBIJgfEM5O
	hvsfDcrU8QX7GgJ3Fs+u1bAzfSza5o/qal+47zDq9q8472Tk6N9/s0rCahMMaZLVN7y87v
	/mPYj1XotZzJ0WtrwPapnkedNlewzp0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Fix S1/S2 combination when FWB==1 and S2 has Device memory type
Date: Tue, 26 Nov 2024 07:59:26 -0800
Message-Id: <173263668483.68510.4488046767973544400.b4-ty@linux.dev>
In-Reply-To: <20241125094756.609590-1-maz@kernel.org>
References: <20241125094756.609590-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Mon, 25 Nov 2024 09:47:56 +0000, Marc Zyngier wrote:
> The G.a revision of the ARM ARM had it pretty clear that HCR_EL2.FWB
> had no influence on "The way that stage 1 memory types and attributes
> are combined with stage 2 Device type and attributes." (D5.5.5).
> 
> However, this wording was lost in further revisions of the architecture.
> 
> Restore the intended behaviour, which is to take the strongest memory
> type of S1 and S2 in this case, as if FWB was 0. The specification is
> being fixed accordingly.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Fix S1/S2 combination when FWB==1 and S2 has Device memory type
      https://git.kernel.org/kvmarm/kvmarm/c/6fc3a49f2385

--
Best,
Oliver
