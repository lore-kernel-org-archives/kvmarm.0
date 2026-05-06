Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72FE3F23B5
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 16:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778084077; cv=none; b=AMXcVg4NcdOvIZEbQJWL8sJ/IsLcqFhiDA7wqeHEEnJNe+/PLksBnSHDv25V/GcszGGoxET7ryBo+S6XVrM3Xa6nKj9bfVRcZu0BJsYAQlEyWzRZQ6CFbalYcDoTFpanO0kjsBaA9sSZePMYrr61HYPxs4dO6nsp77jcgOB19cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778084077; c=relaxed/simple;
	bh=A0quAGCK/EpA/Nbo/d5YzQaDvSpRk944McU1GFhDxkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+BWXdZL7UhIwBZL4WoBSr3KtGqTrKzQC7d5U2iMHHKLd20D4I+7AzXgMqlQj1SaevggYaiUhAWHvbzibLFit0s8ocV+AyVupQRQ8+472KZhYJ7NoD90K+YScmRTj3AWLLETXOw7vb06l9dxOJkPZYRWU1R9F+m0LP/dIsTO5h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W2tcqdr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W2tcqdr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878CAC2BCF4;
	Wed,  6 May 2026 16:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778084075;
	bh=A0quAGCK/EpA/Nbo/d5YzQaDvSpRk944McU1GFhDxkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2tcqdr1OXMwzgVW+ML6e0udUsOw82v+LM6zMQ8UEzrumicQwEBVBnXTX9rPy8jlF
	 phbB/435SXxp/Ovuy4GpGmWJ9Ru/VRHvBZA+WJBlDKsruheQY9Qe4kGiQN6H/WiRYR
	 5U7qj6fNGAaNx2sMV/FnUGMRG+598BpUdt2A+y7RFFLpkXOMjoN31vV0fZuUtbhmTI
	 B5eRAn1pDoTD43ddHFqNLGReBz/vDphDCwvdFF1Gopaqm0VS2Zldo6x1pbrZ/i8YrM
	 Mt0uu03NamOjYbYzAkj3Xa4W3priDIDpYDTYvRzQUqb/RiPEpfvapJm+KTGUCcyBcU
	 6G5gisiA5IZTg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wKetN-00000000MI5-1ObS;
	Wed, 06 May 2026 16:14:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	tabba@google.com,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: mark.rutland@arm.com
Subject: Re: [PATCH v2] KVM: arm64: Handle permission faults with guest_memfd
Date: Wed,  6 May 2026 17:14:30 +0100
Message-ID: <177808404891.2712489.7110397022243564508.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260505094913.75317-1-alexandru.elisei@arm.com>
References: <20260505094913.75317-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, tabba@google.com, alexandru.elisei@arm.com, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 05 May 2026 10:49:13 +0100, Alexandru Elisei wrote:
> gmem_abort() calls kvm_pgtable_stage2_map() to make changes to stage 2. It
> does this for both relaxing permissions on an existing mapping and to
> install a missing mapping.
> 
> kvm_pgtable_stage2_map() doesn't make changes to stage 2 if there is an
> existing, valid entry and the new entry modifies only the permissions.
> This is checked in:
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Handle permission faults with guest_memfd
      commit: 9be19df816dea9eb7dfe1661b3690bed6a2cb146

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


