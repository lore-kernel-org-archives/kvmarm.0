Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6037F46D558;
	Mon, 14 Sep 2026 12:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789387454; cv=none; b=pTF7rghvK4eNNlj6eayLXpzNTmEvUbw86RFnEUmgwJnifI2bSm6AIKvbMQlmHGDSaomXdTsEFo4HapQNY3jsXq7/GSPkYyn/iamKah5Re+OEsHroMKKGWvJw8Xd3trdjygGdqoSP8KHPseu70DxJv87JsOL+cQzYpjQnFCSyhlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789387454; c=relaxed/simple;
	bh=ujTXEJ5QqG9fHvLurL4ibmVQt+EgQhe0PlPb/eqcYPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UP+jWghOgc8LbZHIbDqHhIvLJ81p9GWeNvpi6V0nFPkJiabkfgh8cLzEUiYgMFG2HdWHONZOaagtbN/U2TBwNv/+s3dHIiqE/mCK/fak7Vk8XI2w/K1Upibb+CCfa254gP59pfZyUO7Xrv9Y0wHEyMaouyxSe2vZ+ZR38F4q5qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3hzPDLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3hzPDLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12D31F000FF;
	Mon, 14 Sep 2026 12:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789387451;
	bh=zVYHIMr2xz9qPBrUfIaLsIVaDhVvuAdRJ8zubdosef4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3hzPDLg3C1XnvSDJ8U7xwm+8Bc7IuBHu3BPG4MBMyF1PwsjD0ntYdbSRlkcOMgx4
	 GXiwsDNeNm78+lEZUJAKhw6NIJWRb8zBn58DEoBcPxUlQ9WECTY0GN92FLE6lvo+9F
	 YxmmduAPCK7DlXgtcdWN6UslTPckhB++lilcp/AnJw4YGKG7yjEoIlrFt6uqOOedFN
	 Zs6503u1UvHAs6EoxrVqfzSY3qCKzQNLEmHIccAOpNzaWocggvhQGxglUUR1qj/o68
	 L7bDjNMtfrTo0s7NzdNqxMsXLdyN2d/SvAdLlwzntIgpExwQKE3C7EyOwXcQNHnkez
	 N5XwcUVPQ1KnA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1x65Pt-00000008bDw-3nd9;
	Mon, 14 Sep 2026 12:04:09 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oupton@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>
Cc: Quentin Perret <qperret@google.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Fix kvm_get_vtcr() kernel-doc
Date: Mon, 14 Sep 2026 13:04:09 +0100
Message-ID: <178938739479.3215146.13473104593022148871.b4-ty@b4>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910190528.4483-1-kmehltretter@gmail.com>
References: <20260910190528.4483-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, kmehltretter@gmail.com, qperret@google.com, fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 10 Sep 2026 21:05:28 +0200, Karl Mehltretter wrote:
> kvm_get_vtcr() takes a parameter named phys_shift, but its kernel-doc
> describes phys_shfit. This leaves the real parameter undescribed and
> adds an excess parameter description to the generated documentation.
> 
> Correct the spelling and describe phys_shift as the IPA size in bits.
> The value written to VTCR_EL2.T0SZ is 64 - phys_shift, rather than
> phys_shift itself.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Fix kvm_get_vtcr() kernel-doc
      commit: 57a7d86e2aa7ae6508ee8e08f32b42eaa314a2f5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


