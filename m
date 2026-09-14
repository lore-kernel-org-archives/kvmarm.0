Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8133A46EC95;
	Mon, 14 Sep 2026 12:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387456; cv=none; b=YbSBkgxOgnsATl5judpgWHQa9XthDO7EmVIFMnzZlxB3xRenqL8TJJZQfonL+aGxJ0lb03mJfuj9Ptsjcsmia+mPikKBCKzf4EH/Km2NB0VFq32JlN+U/cPa0kstosItrQeJPeXauPXrLXoZcQua1ZH4AzNYw6v8MJZHjZEu5yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387456; c=relaxed/simple;
	bh=xThnZ8v/hjFxHaUwR0ualAjiM6ae7854G1dZiH+7mH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GyKerissfUI5rNxwP02gDqTEBzjAm06sfrYOVQXx2sgaHv41lGb8tZlvFcCcgpicSsGbzrIMewcG2NBTpy8XrwGzLY/tHt9VHiiSb6Zk1Aw/eG0Oi9FIrnuqdu1ydq4+KFVdfRrFF5rl9cHiJWeNeDIXYbURXRE0sVjD+bWtbq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TuWxPxBF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TuWxPxBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631091F000FF;
	Mon, 14 Sep 2026 12:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387454;
	bh=xL+w0A7odYZKbgPjD3LYTg1FkJZDU1JNwqhLQiGIknU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuWxPxBFHC9LoXlGOw7d4y5OVtsciOJkh+MEpI8FnXpIiYxyAZAm3orwr0GMDIg2s
	 EjscSw1hHlwqk38h29QvcTXRW3wPjDM+cKNm4gVHQFqvvg605sbIhmidwQeZKc+EF9
	 mM7kBsRvzSrhkWX0tMF0CehBYZLkQF1RIFi+aZoBdrn9JEVb25bhl5nXjBKdd+s7ig
	 VN59yc0yTGSjGk7W2qLqsjVydnzU9nTyfQpEdOlVb3dDigsyYsIcbOGiPWrLWFVH9h
	 RSErhL7bb2yOLF1OTYx7ElCokfgnLWHKMwyJo7tKPcLXpR6PQFQUtxscz2VkWS2ysm
	 lfSuaLz81QQzw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Pw-00000008bEQ-2nlv;
	Mon, 14 Sep 2026 12:04:12 +0000
From: Marc Zyngier <maz@kernel.org>
To: catalin.marinas@arm.com,
	oupton@kernel.org,
	fuad.tabba@linux.dev,
	will@kernel.org,
	Sebastian Ene <sebastianene@google.com>
Cc: joey.gouly@arm.com,
	korneld@google.com,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	android-kvm@google.com,
	mrigendra.chaubey@gmail.com,
	perlarsen@google.com,
	suzuki.poulose@arm.com,
	vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v9 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to TrustZone
Date: Mon, 14 Sep 2026 13:04:11 +0100
Message-ID: <178938739472.3215146.2334012997642467231.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171930.4037166-1-sebastianene@google.com>
References: <20260907171930.4037166-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: catalin.marinas@arm.com, oupton@kernel.org, fuad.tabba@linux.dev, will@kernel.org, sebastianene@google.com, joey.gouly@arm.com, korneld@google.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, android-kvm@google.com, mrigendra.chaubey@gmail.com, perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 07 Sep 2026 17:19:22 +0000, Sebastian Ene wrote:
> Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> FF-A proxy. This restriction was preventing the use of asynchronous
> signaling mechanisms defined by the Arm FF-A specification to
> communicate with the secure services.
> While these calls are markes as optional, there is no reason why the
> hypervisor proxy would block them because:
> 
> [...]

Applied to next, thanks!

[1/7] KVM: arm64: Forward FFA_NOTIFICATION_BITMAP calls to Trustzone
      commit: 5224e6f027ee8ba0ebc825ce80c45c0a7b716ff3
[2/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host handler
      commit: 85e44f7eeaec6c303fd6cb2d775cbfecebeb6802
[3/7] KVM: arm64: Support FFA_NOTIFICATION_UNBIND in host handler
      commit: 69fde06ec15936551f97e67c7bdc93427e8b08a6
[4/7] KVM: arm64: Support FFA_NOTIFICATION_SET in host handler
      commit: e3ba9aec202ae2911ae1166654e21bbbd41ff29d
[5/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host handler
      commit: 88180874ee3474ce866a00297aa238c64fc2ea85
[6/7] KVM: arm64: Support FFA_NOTIFICATION_INFO_GET in host handler
      commit: 0aa3b20bbb2bf165d32fd802204a558fa461b130
[7/7] KVM: arm64: Enforce strict SBZ checks in the FF-A proxy
      commit: 3e9df0b0ebd57e42b43842c996271275588660a2

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


