Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5697F5588E
	for <kvmarm@lists.linux.dev>; Thu, 29 Aug 2024 07:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724917042; cv=none; b=IHyi4VqQKTPNcE0FSueyibm4YvUc0X057xCrUwQz44t96fjghNwAvkb6zQWOPyYHOhq8L8P80N77Je2PAkyv2DVcPMerR0qmkGaO0jyE2LPYUQD0MVejdtwG6P8x1dYTs56WmbDQPWp//Q6oOecwQivMO0FtwwSXIMy5OIe2SFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724917042; c=relaxed/simple;
	bh=qHSJAySMkXeBS2Q9y9nADl98l8omCmwrtZ92Ty8R+qs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=frUsw2b+OcJnPhFwbmILtyS16nE6YfQoAjRYhzWVnOa+A2CFOhPlJdfxZBlYxIFMVaKhj0QA5nVInuWUzRcE/7xa3TR3a9aWGAD9bEH40ZY1kjL4FlVj1ZLVZ6jFAj15G0AKVF9wG9N2PivFh6vL492HyJ42/78e3DLfdeILKwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UfYZ0G6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UfYZ0G6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8B0C4CEC1;
	Thu, 29 Aug 2024 07:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724917040;
	bh=qHSJAySMkXeBS2Q9y9nADl98l8omCmwrtZ92Ty8R+qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfYZ0G6UD1TCQQfVH0m+4SBIdtRnbQ74fUagm/Ieyp1+7KvS1FuAn7FuKSaadOnk1
	 n09/vkx7B2rFDgm04G5LDZOsQjCbfXsn+pJRWJzm4a0NCjGjk8Jp0kNSEdYmJJ6y0U
	 YBIy3XcxDuK3w8K4glkSd4eiDeFujFsI6/GGwR+gI9KlzjbkdPuaaLb1zcMhH49Z0R
	 69j+SHatdSiIz7hJPh0y6cNyoCbD08IlymAWRgvKZQWNuq3HfvYROFx4ADXSyITYoj
	 YWY61YZ8+KeYbzyYsCuuVYDF3wMVGyfpN6XipI6WGp7K9eJ5l+w8HMJszkUzm/lLbj
	 g4wpTSp3jV27Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sjZiY-007ob7-OX;
	Thu, 29 Aug 2024 08:37:18 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] KVM: arm64: selftests: Cope with lack of GICv3 in set_id_regs
Date: Thu, 29 Aug 2024 08:37:15 +0100
Message-Id: <172491702780.3928846.3904800703855523246.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240829004622.3058639-1-oliver.upton@linux.dev>
References: <20240829004622.3058639-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 29 Aug 2024 00:46:22 +0000, Oliver Upton wrote:
> Broonie reports that the set_id_regs test is failing as of commit
> 5cb57a1aff75 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is
> presented to the guest"). The test does not anticipate the 'late' ID
> register fixup where KVM clobbers the GIC field in absence of GICv3.
> 
> While the field technically has FTR_LOWER_SAFE behavior, fix the issue
> by setting it to an exact value of 0, matching the effect of the 'late'
> fixup.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: selftests: Cope with lack of GICv3 in set_id_regs
      commit: 4641c7ea88d1029500ff64c4d0a1df0584b1bfcc

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


