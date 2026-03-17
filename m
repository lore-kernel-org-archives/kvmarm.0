Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DEC358366;
	Tue, 17 Mar 2026 09:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773739069; cv=none; b=kdP8ZfSYgP6R9M4eXsPuse2PRopajtIy6Op9XEPEnCT48s8nODGX9VDllNEGamlXyTxA/aLnXLJVnSkG/wUBlCgoznCto4LNPCwpD934rZtcZJ9+mewskvj9RfiYLlWTKbbDG0IK9dTZpljC6mbLRFfj8JvYbA50nAtJxDL2LZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773739069; c=relaxed/simple;
	bh=2hcFEwJyOf2nX0PWgcKQNQ+3rAyX5VnYVAQvAbGsd9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fbgPzXacv94wrC6DPjq7mel4rSi8PBJXmVjKQVZeUNASsQ+jW3lCjDyhaQfmdjuz/sc1CiHSiG6GngSKUOGxQQDsXS/YXHvqJM80jezySp+VSwvEzz64sBzH8iktk3HFPqd0UHQcFzqu0MgWuJJ65Fy15cUfaW+JejekqqYuDmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qhFyvEGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qhFyvEGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757F6C19425;
	Tue, 17 Mar 2026 09:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773739068;
	bh=2hcFEwJyOf2nX0PWgcKQNQ+3rAyX5VnYVAQvAbGsd9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qhFyvEGuenOqVw1VHqqeC5SSSe3R6FlXODXdhtr38NwdofspNKh9nLjJ+j6zrB+lg
	 n/bFUbN1ikYDYIbC78NUzI1FxPK3UMTMp1e5RM9f14hHrH0Q+eVfcXmyfreUOIq6lO
	 NhL/C4jns9d9/Ve00PzYF2rOIvQT+R5Ze7GDFKgWpxPzY+Bh1ujfgptYQ9hEPTh64p
	 4gqNWbSWMf98kJ7UpOv44U+9stN8ZxtJXX8O5I3WvgQSOfshqgLfgLig7BMuXM9SjE
	 JYjgncEp6HjqZ/dKhIpQMpytwMJWNby7aQ3xmH+h6Q4JQS2mo7JcXlX+BBx/TM12+q
	 +K4Z5FKJ+lXWQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2QYc-00000002kiZ-1IBN;
	Tue, 17 Mar 2026 09:17:46 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: avoid unused-variable warning
Date: Tue, 17 Mar 2026 09:17:43 +0000
Message-ID: <177373904370.1873870.10413529929219722866.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260313094925.3749287-1-arnd@kernel.org>
References: <20260313094925.3749287-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, vdonnefort@google.com, arnd@kernel.org, arnd@arndb.de, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Fri, 13 Mar 2026 10:49:16 +0100, Arnd Bergmann wrote:
> The 'cpu' variable is only used inside of an #ifdef block and causes
> a warning if there is no user:
> 
> arch/arm64/kvm/hyp_trace.c: In function 'kvm_hyp_trace_init':
> arch/arm64/kvm/hyp_trace.c:422:13: error: unused variable 'cpu' [-Werror=unused-variable]
>   422 |         int cpu;
>       |             ^~~
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: avoid unused-variable warning
      commit: 8510d054b7e086a71a9191ac3399231290dfd272

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


