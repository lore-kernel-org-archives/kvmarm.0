Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC454A24
	for <kvmarm@lists.linux.dev>; Sun, 14 Apr 2024 09:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713085284; cv=none; b=UvSNT9SpLW1oByhYhtFJDv/lcJoZmg7DSJ1a9TtAijueBMP7o5I414ORVnXD/aQluX3ohWAziR0ntJsifbHtUGggEKWfaJYoFrq00FjT9m5e7kgszsfH/Wbo576Hcw1FAO8XEc8KGR6vT3MxL+AmdXo8pDhO07Jbk0qfz7ZMaBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713085284; c=relaxed/simple;
	bh=epb4x2Rs/wpy2Kuu063h4bpiRKsNbMjgCafvxTgjijE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uWjw8cx14+bQkj6XgNOdkiWjdw7wwCYEW2fkqZNccgzwJd3ePHWua1Hp919bNHCEhz3KI4lFUxn7fvUpbjNb6+paE8+xbvTttJo5kusUToQLdNsVGuVso9CNrJ6kVw+qHt6Fpu4aRhMG7tPYN1lPLSZOKV0B6WDHI6AjSf3/KTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOKm6F83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOKm6F83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E88C2BD10;
	Sun, 14 Apr 2024 09:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713085284;
	bh=epb4x2Rs/wpy2Kuu063h4bpiRKsNbMjgCafvxTgjijE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OOKm6F83H7VMTz+pbNxvCSz44qTZjp67/n58YKSVdc7lovInuavPVncbtEYjtT70k
	 u8W3wiEFAnCIyQ8ZziG8uxwqDw5aS7s3VOVjLPS3f3KE95WIUIfoHfuLbo6GHve0Rw
	 okbqAdtqOnYZq38fu63exw72ee0lB07GEcp95BlLBjWTqDy+K0ayfbXh6sObwsqlxs
	 4favga5bsjV85YdmXPxrmpTBe6kaXyhcZCM8inc9+e6NZYJ2nDUIwDAHO+TDksnzrq
	 144JsJWf960LYZMS7IJAMRjYflKhBks7nOD75Y3wvujzz0zOI4kG6Tbe6GVcnuGxQg
	 RK4qV+FNxVFNA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rvvjJ-004Jvv-Er;
	Sun, 14 Apr 2024 10:01:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] KVM: arm64: Improve out-of-order sysreg table diagnostics
Date: Sun, 14 Apr 2024 10:00:50 +0100
Message-Id: <171308523905.3831784.4696133718079966571.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240410152503.3593890-1-maz@kernel.org>
References: <20240410152503.3593890-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 10 Apr 2024 16:25:03 +0100, Marc Zyngier wrote:
> Adding new entries to our system register tables is a painful exercise,
> as we require them to be ordered by Op0,Op1,CRn,CRm,Op2.
> 
> If an entry is misordered, we output an error that indicates the
> pointer to the entry and the number *of the last valid one*.
> 
> That's not very helpful, and would be much better if we printed the
> number of the *offending* entry as well as its name (which is present
> in the vast majority of the cases).
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Improve out-of-order sysreg table diagnostics
      commit: a88a9ec1729a4687370856567919e1ab79a02483

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


