Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BE05024E
	for <kvmarm@lists.linux.dev>; Wed,  1 May 2024 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714578097; cv=none; b=Rlx/L0SZtl+tiTLcT49NRD2iKMcsO+0FT6txp0nonZEnqD/MrbIiQej282MNpgq2p33Wzqley7/C3uocdHLW8AF+YrzNv0A532iMYfRPRxOcQddHHGJ3LgReQfPGGE7AjMQq1yi6gxWYnQdaI2a5bx8Z/+aOjN007XsaG6GWhcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714578097; c=relaxed/simple;
	bh=9Ee7q9KOS+Gjz6F7GATztOtK7jVn88zdtaN486f8Kj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DX1hOOQBVTnuTb4c1VbFYjJ5vtPec+IJF4nbl+4IiX567Jp8adbjsBuA79d+itdmdXEMx+Xjv4DhttulPxupi5mq8nhxzeP2Lx1nnMrOsIoSY/GgAfaDlzkUGcvngN+o2BDUXPLGYNcAbsgUNIc/ObckfhN/95IWDhQ8pyHidBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CUnDdufT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CUnDdufT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E29DC113CC;
	Wed,  1 May 2024 15:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714578097;
	bh=9Ee7q9KOS+Gjz6F7GATztOtK7jVn88zdtaN486f8Kj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUnDdufTznMX1TpN/cspx/vm1qBAr1wb+xXbfhoPICw1e0OefJEZlUDVMLAwU+3mL
	 mac3SRL4ijsJYAPV1BqrD7ZE0ZKZxcqv5J5nx3yy34mWjfcM3lVjmZRHArxuGtfDO6
	 lr9DtqULOuaklyA955ZGfrgN8NKDR2QhuMPDaZCADb2ZKClJqfWxSxMyDdwLp8SlkS
	 XliAgocOZGKjy4GPCGfzcGO3AnQ+22uH53b6/Wao5D+fFXbiFUlSTts57irwDkaFBz
	 zFyMviU4ZLRfjLrxf+JNROOfC1p4uM6HOF9otOk0Fy2h/LhOGtMDZA/7DWCkr/CZb7
	 XTixM/rjdhlqQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1s2C5O-009ksv-Lf;
	Wed, 01 May 2024 16:41:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: remove duplicated AA64MMFR1_EL1 XNX
Date: Wed,  1 May 2024 16:41:31 +0100
Message-Id: <171457808342.2893348.14914006409589344975.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <E1s2AxF-00AWLv-03@rmk-PC.armlinux.org.uk>
References: <E1s2AxF-00AWLv-03@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, catalin.marinas@arm.com, will@kernel.org, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 01 May 2024 15:29:05 +0100, Russell King (Oracle) wrote:
> Commit d5a32b60dc18 ("KVM: arm64: Allow userspace to change
> ID_AA64MMFR{0-2}_EL1") made certain fields in these registers writable,
> but in doing so, ID_AA64MMFR1_EL1_XNX was listed twice. Remove the
> duplication.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: remove duplicated AA64MMFR1_EL1 XNX
      commit: e8533e58cae02923e8cbffca516d3d821cee1649

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


