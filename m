Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AF031B833;
	Tue, 19 May 2026 15:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779204210; cv=none; b=etzdSeA5LvfEqKA7pw0Y2u6if6ZFjq+8pxMZ3oJdft+jayJWVytK5cp3eZU/lV7RlRwzZ1M2XKE5f1TChexe8As44Wn3D5udPs/BclqqR44dnT8pwmS3lHv05wWIzDkZzq9k4EqpTPC7XPDYqvExJ0l4goftwwWTUye+TfPhmNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779204210; c=relaxed/simple;
	bh=RW7D8ZLEfralQAVgdgCnYlUdObMNdbDPf8t4NO+5ZKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NQ/Y+8oADwYhXETrZzjD8t0sdTZ6CceH28rVzb2RiXVKb9zBjs2EZqP6GD+Ds2Q4ja7asvnCDWE1xedo8klST9kaeYPtxuyJ8HPIKknFdR03uJUd/UeC+IXZx+l2zxsVhndXrV8BmDRtIUKuOGAKq5fkhdWuDTlXHJmJmL6FKy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oZkQ1pvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oZkQ1pvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22FCC2BCB3;
	Tue, 19 May 2026 15:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779204209;
	bh=RW7D8ZLEfralQAVgdgCnYlUdObMNdbDPf8t4NO+5ZKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZkQ1pvE+K4eJaqVM44Ja56YcmI03uDDQxwzeAA3i2nrjI2u6as51sKr19VOycrAW
	 pom+OmFJXBX6IpnaMKLrtGPSKfNvE9OR4IUEGczk9EFa1yOo/HzHCxLe8zCbyqGZsK
	 gIRI9nBre4n8pgfoTutRHzqYN4N+1110cTOvUgLSSWP/n5je0pvETx/Oj1aD5Sc71R
	 AdvlR1eQxy38bhOj4K4VgJldlcHfibwfJKe7ZSZq1OL/TEj6IqZzwQx6ooDJcQpdJI
	 eFwW23ivDv4fmUJQRfNbgoIzNY26yvhgND9TyFMq7mKPKyhtuR2ATLpav3gSHfmDlg
	 dX5jJacHo3/lg==
From: Will Deacon <will@kernel.org>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>
Cc: catalin.marinas@arm.com,
	kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool v8 0/6] arm64: Nested virtualization support
Date: Tue, 19 May 2026 16:22:51 +0100
Message-ID: <177919534202.841805.3550054062593794368.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518124556.164739-1-andre.przywara@arm.com>
References: <20260518124556.164739-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 18 May 2026 14:45:50 +0200, Andre Przywara wrote:
> v8 of the nested virt support series is just rebasing on top of current
> master, to accommodate the meanwhile merged userland PSCI series.
> Changelog below.
> ========================================================
> 
> Thanks to the imperturbable efforts from Marc, arm64 support for nested
> virtualization has now reached the mainline kernel, which means the
> respective kvmtool support should now be ready as well.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/6] arm64: Initial nested virt support
      https://git.kernel.org/will/kvmtool/c/7e43347c0114
[2/6] arm64: nested: Add support for setting maintenance IRQ
      https://git.kernel.org/will/kvmtool/c/fe4c35a8dcce
[3/6] arm64: Add counter offset control
      https://git.kernel.org/will/kvmtool/c/1b44d7a4b99b
[4/6] arm64: Add FEAT_E2H0 support
      https://git.kernel.org/will/kvmtool/c/ab9ae1411622
[5/6] arm64: Generate HYP timer interrupt specifiers
      https://git.kernel.org/will/kvmtool/c/e9456310e1af
[6/6] arm64: Handle virtio endianness reset when running nested
      https://git.kernel.org/will/kvmtool/c/6c2de8d9531c

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
