Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711180;
	b=TkGxPTJ2xuvQSMgTeUDUYmnhIJ269YROsTFw9mbGpsYzTl6+eKfvZHmgKBtFUxntdY2P
	 h9d0hcq0g7b+YUWfCvvNkvJH1adXZvHmqqRLAERfuj18sH+sZ6fPVOLylqcwvKEe0qacz
	 HGLEobk0K+jK3AF20f1uVSS2IbuT1PJpmZbneUBZPtIp6UPYrBYV6lNDbowaUE5G3wlHk
	 8vccFbc8ovksHDEswFKN19plXUCllN5A4zR2hiqoHzB81EbDiHfsYvZUpC0Iy1KSjVYIw
	 kgL4EUuPwPddMH95C6mSutfctBJY3KZkgIO+nAuY1QgwezP+jwFBQCmrn8iX5iYjxaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711180;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=PnFjXjJFl+0s212g4Biiqwpc+pB9dQcS8Fb86q6L9HY=;
	b=wpRwLxpyak880WcMvS7wJHjPcHqUn+Br4qRtISwi9Bm6nY7YoKjtbAUEtX+wmjdVOVe3
	 hIRgidZdNNnNGHGxVBIJlJmgWrnU61vAqDloL2Lb3YuPPJ0nUdMPAHb3z5Vtf62nkd6/v
	 Yph5wHqsF4Ky2IVYtOZFgaDAN5kia50ORlthlXMQ3mQauasrCpUTehxz3FXiMH500HHFg
	 c/aXbEj9C6y+urCZmgZ4gWClA0tnBr+eJ8l7GPOdUy7QnGfTd8NanXWB5n860mG9LsVzP
	 xnQYgKBrhnwSrub1sPnDj9Pmm1LmrqWEKy73VO1hn41csbObzYxl1rlcsn166PJrrdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ANpPfrIH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D27D606A33B;
	Tue,  3 Nov 2026 13:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ANpPfrIH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4035D1F00A27;
	Tue,  3 Nov 2026 13:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711180;
	bh=PnFjXjJFl+0s212g4Biiqwpc+pB9dQcS8Fb86q6L9HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANpPfrIHCAge/uSyxNnFgZxKhSto2HW0O7QLNo0Qv/8kxySUPqBrBR+fOpXwENvy5
	 oTGBzxQ3jG44qtd+IA8z7Mu3/Sc8fHJR08dno0XjmCj1c4QgAaGzZ9J0v4SvYrDvnd
	 y7OJUQiSGidZjlzCW1zTgr38fIdSNbupFOPo4MCYQGHGKW69bu5HZrKPE0Xu9Wi/+a
	 hXV/u6beCI8TlPJ5ZyPzTo7MC/3Ss+0qS58DEURhZ/dmTxHAiXzkga/qSQRgS5+rat
	 gHFUfLq7NPEsOhLTFrf9xfbaKPl4/dr5qbMTbZQ/4lep5kVuQ2YVRPiexA2mAfgcrp
	 NpD7TDGrZkwwQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xOEDS-0000000ATWs-2689;
	Tue, 03 Nov 2026 13:06:18 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Arnd Bergmann <arnd@arndb.de>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] KVM: arm64: Support FEAT_LS64_ACCDATA in guests
Date: Tue,  3 Nov 2026 13:05:34 +0000
Message-ID: <179371111281.2844725.13648407938600355335.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025075138.2919734-1-fuad.tabba@linux.dev>
References: <20261025075138.2919734-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, fuad.tabba@linux.dev, catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, seiden@linux.ibm.com, mark.rutland@arm.com, yangyicong@hisilicon.com, wangzhou1@hisilicon.com, arnd@arndb.de, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 25 Oct 2026 07:51:33 +0000, Fuad Tabba wrote:
> Changes since v1 [1]:
>   - Support FEAT_LS64_ACCDATA in guests instead of capping
>     ID_AA64ISAR1_EL1.LS64 at LS64_V. A saved VM keeps its level, so
>     restore no longer has to accept older kernels' levels, and v1's
>     set_id_regs patch goes. (Marc)
>   - Add an arm64.nols64 option. (Marc)
>   - Retitled the series to match.
> 
> [...]

Applied to fixes, thanks!

[1/5] arm64: Add override for ID_AA64ISAR1_EL1.LS64
      commit: 699edee85fb9f4403b5bc939f3f84374f841b33b
[2/5] KVM: arm64: Add ACCDATA_EL1 to the sysreg array
      commit: 8b5bcf2e799c24906b813f4a63081e68721a026b
[3/5] KVM: arm64: Add context-switch of ACCDATA_EL1
      commit: c122ea1564b41326d8c09c64005d38ec2fa6dd8f
[4/5] KVM: arm64: Enable ST64BV0 for guests with FEAT_LS64_ACCDATA
      commit: e2412d6a90a4b39e3fc464eeab8637a7f4eccc10
[5/5] KVM: arm64: selftests: Add ACCDATA_EL1 to get-reg-list
      commit: b7bb9e9425dd7772cba9ac4392e982f541cccfac

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


