Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AE045FFA2;
	Mon, 14 Sep 2026 12:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387452; cv=none; b=RKSkKZJoQa1e3IpuFPt2JQdqSihhRUhmhx/d9eLW8+Dl3zRxAOfpiV1eXQiGxSTcCjI1/32He90jx6LUTtr2ipfyMZ7AaVwYxj2qbfL3wL4yw+SEYuOZbFaHpuldLrGX5UEFq2AFMOyBcUlBKBG/tzIyptQDw6TxAJP9+LxECXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387452; c=relaxed/simple;
	bh=kCYV9CElak+J1g77IvQxlloHjoeV9dqKukLcVJsi5n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B+z7GYcW7kBsfYyfn7RkMOgD8hz8bzwgVdoSbBweiuku1XRv+wBMyrxZd2Iod5pgM7kCzOsUpqvy08WtAOETERJaKGINnh4Cb46kvrZ3L8oV874YDP4NnXo5ZTI29f1q/WdetDCOToF9Eq3N8cA96cQObbNwtC6FRwRexVKS0lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kNoC9Hjs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kNoC9Hjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C181F00898;
	Mon, 14 Sep 2026 12:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387450;
	bh=u+yDfqBxNt5OV+T6PZqZiS7nL1HytwBiRDoPfzTD1/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNoC9Hjsk5euB/8R3Y3e6c58cblZuCb9WSV/bAunrUbAP6QCtDufxeFEKiDDg16c9
	 IlmD1NAspyhsZ0KaRSkzwQOA4o2gRL7Uxsb3Wa6N7eZgeQpdD3BoN1qYo5OOj5CFU6
	 y9F2Xbu/131+3E1DKVuemYmvs5ZjV5745ZutD6gdPRb3Up9YthnbSAdBBfv09QA6g4
	 1EKMIxA+zXyjHNaebznEnI3xzg3X9X0pY15kR5KKcaylTjUq7a2rP492zcHBk4jYUv
	 R20IJaxo1Kxrby87qmgEN6nSWK1gXUtgQOo9VI03tIvtC4/5Js6yGWccWWFYT9GnKg
	 h0KOUbOBdw6VQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Ps-00000008bDm-3VrX;
	Mon, 14 Sep 2026 12:04:08 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: kvmarm@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] Documentation: KVM: Fix the struct kvm_arm_device_addr name
Date: Mon, 14 Sep 2026 13:04:08 +0100
Message-ID: <178938739484.3215146.11955163340723222437.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260905090655.40683-1-kmehltretter@gmail.com>
References: <20260905090655.40683-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kmehltretter@gmail.com, kvmarm@lists.linux.dev, pbonzini@redhat.com, kvm@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org, skhan@linuxfoundation.org, rdunlap@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sat, 05 Sep 2026 11:06:55 +0200, Karl Mehltretter wrote:
> KVM_ARM_SET_DEVICE_ADDR takes struct kvm_arm_device_addr; the document
> names it struct kvm_arm_device_address, which does not exist.
> 
> Use the real name.

Applied to next, thanks!

[1/1] Documentation: KVM: Fix the struct kvm_arm_device_addr name
      commit: 068df88a7d8900fedda1621435518c0f2db9e53a

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


