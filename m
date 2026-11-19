Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092224;
	b=nLeqQY6BQ04hJnwnGntt+WuV7C0jzQk335uYLvlNK+eR50aCkWlNVEYI5/LAZHBP5fOQ
	 oI8TmYrEJq/UFBzWRYITCTgK2BMhhxHgj7AK8P632PgMABOGt0BJJ3ddwZouNahlTFomF
	 jRYqINauoRZkq2yrcBkqxenDQoPVCr+hgsyi1rilZEA9xT7rqAZAdfFbo6l8iXr/DkOYF
	 6qCUtRhEnhM+nYY809QEfrZzlMOqZ53app3XchDfSuK+i6Yz1xJxW8fxdIdnVDa5BeqCM
	 IB989yRgJC/6Xw1Bieh47yl3wEPOTVhalQMFhxRUO6GPsp9RBijT5iIh4pFbQlskd0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092224;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-SA-Exim-Connect-IP:X-SA-Exim-Rcpt-To:
	 X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=4r5PB0DQkXh3u33w6JsWbjKrFhzV4eOWaVXY4U6YmfM=;
	b=g5f5X2N+hQKfY7tqkrV/HUsHXXanMLWjnj+n5W9Aw5HQ5wFjH6ztoOubcQa/vcVSOsUM
	 Q7pJEAXnz6VoZyIMUZbd3lf6RSBV7g0Bv2rPfvd8xM7MZmh/M+1ky6zm1paoM6BPwjugB
	 T0i2rX/NHZk0mk0zJwDc78YzLnWGLQeTesRfNI8Ntf1emFPXB41kUNqEjRknGpF5xQUg9
	 3ZQ/ZUgSrGOtjry8wFIPlDHFKFzYL7cobDxkp1SWaCn/bWgTvWg8Dps1fW0JYu485ZpxB
	 aoCJ4cayJZr4oqz1gya1FhXGLwFSQDky72FMYdlenSKnzPcGrT3W2bS23cBmP8SrGBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HBRuEQyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAC6606A320;
	Thu, 19 Nov 2026 12:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HBRuEQyY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BBD1F000C8;
	Thu, 19 Nov 2026 12:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795092224;
	bh=4r5PB0DQkXh3u33w6JsWbjKrFhzV4eOWaVXY4U6YmfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBRuEQyYgb/ceb3U7Nk0J4WbPRthEECDLvswR6k5WI0mK1ju8s/lZFhZ5x1LPApkn
	 1pjw7ihXQvxY7XjZ0w1EMc3S9a6YtcuY5ZeaPPDW0Gj4zYQdm7O91H0CuELeROco6y
	 FK4MU95dsVf1k8EGF2AFD3J/kB9p33l5ia+AIB1c4B6Vl9ZtuuwEek4MJUqkOTGxUM
	 j7V6GI559mffl2b8Z+pIfCQClnK1cvshCsSSyRft96ckG07J7kvsnnQrixm8XvJXvV
	 vni4JQe5jEETDmfnSLttUQGHk9EgxxxjZgLBXfc0KNMkBE5tLjyW9Vq4mSnnJsHhhq
	 66JJCzlr66Pfg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xU1UM-00000000RvW-341d;
	Thu, 19 Nov 2026 12:43:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: Dan Carpenter <dan@pereq.eu>
Cc: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Jintack Lim <jintack.lim@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Karthik Bhargavan <karthik@pereq.eu>,
	=?UTF-8?q?Cl=C3=A9ment=20Blaudeau?= <clement@cryspen.com>
Subject: Re: [PATCH] KVM: arm64: nv: Ignore TLBI IPAS2E1 above the IPA limit
Date: Thu, 19 Nov 2026 12:43:32 +0000
Message-ID: <179509215932.3938200.1655577673517610015.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <av3FxJpUvpb_8qMC@stanley.mountain>
References: <av3FxJpUvpb_8qMC@stanley.mountain>
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
X-SA-Exim-Rcpt-To: dan@pereq.eu, oupton@kernel.org, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, christoffer.dall@arm.com, jintack.lim@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, karthik@pereq.eu, clement@cryspen.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 18 Nov 2026 18:35:32 +0300, Dan Carpenter wrote:
> In theory, an L1 hypervisor could issue a TLBI IPAS2E1 for an IPA
> above the host's IPA limit.  The s2_mmu_unmap_ipa() function would
> pass it to kvm_stage2_unmap_range(), the page table walk would fail
> with -ERANGE, and that would trigger the WARN_ON() in
> kvm_vm_stage2_unmap_range():
> 
> 	WARN_ON(stage2_apply_range(mmu, start, start + size, fn, may_block));
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: nv: Ignore TLBI IPAS2E1 above the IPA limit
      commit: 5f9cc7dcda69ed881a3041ad992afaac2a39d687

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


