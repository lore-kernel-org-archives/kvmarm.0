Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C5218E025
	for <kvmarm@lists.linux.dev>; Sun, 25 Jan 2026 16:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769357993; cv=none; b=RfIOCnjXkwOGf3hNOrXKA1f77pzMvdvttT6FTZiQaoLLH5fVlnCT/wjfia379qSZb6/iNqFNXca72l8z45NGq7kukzMLc96KX9wyXt/FR77K0jq58ulkJLUj5EZ3Gk33/rXyHtW6OYl0oO3cACYFNhAqwgvFDFjOB2rU/naYI9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769357993; c=relaxed/simple;
	bh=dmuDrsMdNI2PUa85stdWzynrg+qhR+Xfy0prFZxMHUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ku7ZTxgC8SU5rWEuwy97swSj03mnhTyPgA1pKlfIO88a9se3oMIx8vyzd2+9MRU6CQ+wX8jDEwthbNb22zI8RNtJ127fvOwZ7MQ+99xb0aXUNY7PT75VkuK08yv9DGw/9YnWXUHCMOV9bepiT00XScr1RGokGJP9cKe//NaajV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qWg9PrZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qWg9PrZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D320C4CEF1;
	Sun, 25 Jan 2026 16:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769357993;
	bh=dmuDrsMdNI2PUa85stdWzynrg+qhR+Xfy0prFZxMHUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWg9PrZdl2em2STRbIMp25vdm7gOVRgjhakz1mpGalssjaEa0iPiIkTWc0DkFLh+g
	 rvthJ5Jc7uEEHuzGT4C9rfqNTWMIz0nAKiqg9cRa6fgxIg9+YUG5yvRqBHAWbCB8bO
	 sx0lziWUAyK/1NzagmMNr/fAPTGfGQXvyQkTLVJHXn8hr+jL/G9rGC0V4J7P3RRDnl
	 InCPXQ9/OtnCd7oDNSDoetClBn4aYvO4gpGIhdt/Av9DBg/HGWlG73IdIQHn4szSx1
	 zlzukk4o/iV+66VEbfyvsyMsxps1JcAAf83z1zFOU7H7QZIkWOHE1XjG3r6ckClfeX
	 e8bUNvLSQM0Lg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vk2q6-00000005UFI-49u2;
	Sun, 25 Jan 2026 16:19:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v2 0/5] ... and FWB for all
Date: Sun, 25 Jan 2026 16:19:47 +0000
Message-ID: <176935797657.961543.17468025675313258219.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123191637.715429-1-maz@kernel.org>
References: <20260123191637.715429-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, will@kernel.org, qperret@google.com, tabba@google.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 23 Jan 2026 19:16:32 +0000, Marc Zyngier wrote:
> [Yes, I have since learned that FWB doesn't always mean "Force Write
>  Back". I'm not judging.]
> 
> This is v2 for this small series teaching pKVM about the benefits
> (haha) of using FWB on the host S2 page-tables.
> 
> * From v1 [1]:
> 
> [...]

Applied to next, thanks!

[1/5] arm64: Add MT_S2{,_FWB}_AS_S1 encodings
      commit: d4236f1ef270347b26ed34bcd0eb28d285b86bcb
[2/5] KVM: arm64: Add KVM_PGTABLE_S2_AS_S1 flag
      commit: 17d7b15131f3ed7fff29f2a43b6ead547e495653
[3/5] KVM: arm64: Switch pKVM host S2 over to KVM_PGTABLE_S2_AS_S1
      commit: a373930ec9406aeb9f82b5b78db56ca8d0919d99
[4/5] KVM: arm64: Kill KVM_PGTABLE_S2_NOFWB
      commit: 4f27fe82aa304c50b24f92da72b4895cf73b54ba
[5/5] KVM: arm64: Simplify PAGE_S2_MEMATTR
      commit: 65d00e37b17f46a21e7a25e0fb211a4c33274a83

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


