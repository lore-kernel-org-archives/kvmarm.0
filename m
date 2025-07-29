Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0DE17A30F
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 21:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753824211; cv=none; b=tnCk7kjJI5yoPRln7W3SknBJeAtworlNDr37dYIcWH5Yshm5j2xYrSNOyMgQXrxopa4Cl92MZeGxfXk7iPmTRUNOTHuiaST8jFXuTJ6jyXClaOGe7TwzbHsu1nHQo7DbdRm+hcLuBzQ54ld2UwUH4AIpS6RohMBzfDyRfcCd9iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753824211; c=relaxed/simple;
	bh=YPw39hM0XPwwHdZLB+B/18nFgGiAdWO+RbYDk3eDt1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VzJGdPIA0OWXxYnlha704Uo8fxhuKsWWWZ0GMAvA3CkbIcEyT8WI4LROUXxJEqDHvk7Ofl7uHyT08jdwoX2rqb7Zjsi64Tz6AXyirzI6sFrap7HptTFWPi0I4jT/Cwqjz8h/68QP7DogVd5UvUsoVPF0r28BgSzQ617eBK5aUXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R9NTTjX+; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R9NTTjX+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753824207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KbTYZV5A/izXGKdYsYyam9domfvB6oEjtk6O72eaKBs=;
	b=R9NTTjX+rORwT+a6JEIYVzSVkSK/RdLskz6BUNFX0dC5BsyCafVhv2uhz1byrhsymuxQGR
	YPqf6IDP1I3oHmOLby3G/aQ8iLzsfJuE5kx9SeVn3eZ4BTbAQA1QMAQnuJhSDlAVA0pX51
	rCK0mNvbXaGok210uECSnNBoj2j9l0s=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Move bundling vLPI and vSGI to vgic_supports_direct_msis()
Date: Tue, 29 Jul 2025 14:23:16 -0700
Message-Id: <175382415249.3325682.6984441451099105450.b4-ty@linux.dev>
In-Reply-To: <20250729210644.830364-1-rananta@google.com>
References: <20250729210644.830364-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Tue, 29 Jul 2025 21:06:44 +0000, Raghavendra Rao Ananta wrote:
> Commit <c652887a9288> ("KVM: arm64: vgic-v3: Allow userspace to write
> GICD_TYPER2.nASSGIcap") bundles the vLPIs and vSGIs behind the
> GICD_TYPER2.nASSGIcap field. While the vGIC v4 initialization and
> teardown is handled correctly, it erroneously left out the cases when
> KVM sets/unset vGIC v4 forwarding, which leads to a kernel panic of the
> following nature:
> 
> [...]

Massaged the changelog a bit. Applied to fixes, thanks!

[1/1] KVM: arm64: Move bundling vLPI and vSGI to vgic_supports_direct_msis()
      https://git.kernel.org/kvmarm/kvmarm/c/7b8346bd9fce

--
Best,
Oliver
