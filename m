Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E843827EC7C
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764355865; cv=none; b=lU/7YmBfTID42N96PPHWl8mmAcP79ZDQOvDwuIUc4FdPMM76VZOL63+V5vvWCuhw2U053EqJTarWdrefjuyJP7bJlhD8Np5GUVrAX94hZBMhRqN5dBJryzCQBqU5mlH62hF1vZw/RHJlB5J3dagYLyttAb5NAVOg3bVr0qLvbRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764355865; c=relaxed/simple;
	bh=SIi6xlzvsm8cMl61j4v56v1YyXD+xeqIVgA2tZCE8FA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kpz3VAywpYdVCD3ZmIdLFEECPJvnem6MMBqhKSxk/Rd6tEAxSLR7z33oNmQ0znffdQvz3ICO5MNM22+1KxrJCMMtStrMtWsq+VPH5aHbAd4TIqnyXlksDD/dx0rt0+u2DrMtUJZb/Nyds6qLFRVYsNGPlcx40CNqaw4gVi/ZE0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qCEKmkIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qCEKmkIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DEBC116C6;
	Fri, 28 Nov 2025 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764355864;
	bh=SIi6xlzvsm8cMl61j4v56v1YyXD+xeqIVgA2tZCE8FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCEKmkIVtUHcHpsTbA/9xDVHBfWqtGGDZFW7aADLzdXaP7SiKGI+tZB5dYtDASWNY
	 UAR0wsSRrGuznwOnwztPSSKepCmMWtNGqkC3V4DA3LuAFbP1KGzDAvYLyTEuhiPQWh
	 TJa+DZARP2iOVDoDiY4qmHpN5OZ8vWUv8kXnPur14HrkuoKaQg+F9cb6SI/WNntYJB
	 lj/piguOGTYp16Z9HouP+LC3j99mHKMssEmr0v9Acohp+hyL8ELMrvWUtlKkGuxP7i
	 GanGD9IMcM/sGT0240ClA1RgM+EWGAbxJfMh3tLHWTsBscUIZfG/JRmebVzYgckCpg
	 GLbBI5QvLMwcg==
From: Oliver Upton <oupton@kernel.org>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	suzuki.poulose@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH 0/4] KVM: arm64: nv: HAF fixes
Date: Fri, 28 Nov 2025 10:51:00 -0800
Message-ID: <176435583514.14290.17319946187047529579.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128100946.74210-1-alexandru.elisei@arm.com>
References: <20251128100946.74210-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 28 Nov 2025 10:09:42 +0000, Alexandru Elisei wrote:
> Based on kvmarm's next branch.
> 
> HAF support for the software translation table walker was merged while I
> was in the process of reading the patches, so instead of comments I have
> these few fixes.
> 
> One thing I didn't touch is this sequence in hyp_set_prot_attr():
> 
> [...]

Applied to next, thanks!

[1/4] KVM: arm64: Document KVM_PGTABLE_PROT_{UX,PX}
      https://git.kernel.org/kvmarm/kvmarm/c/a3e927e1432a
[2/4] KVM: arm64: at: Use correct HA bit in TCR_EL2 when regime is EL2
      https://git.kernel.org/kvmarm/kvmarm/c/c560b0121d02

--
Best,
Oliver
