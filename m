Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BFA18B463
	for <kvmarm@lists.linux.dev>; Wed,  8 Jan 2025 10:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736331942; cv=none; b=IocIgKe3dHH1ZXMVQAozuscYPBHjEvtOYZ1mXAzpozJwURGEJR+xdZcNwSyIe5SQ4dy8ZDGT7EpaTLPJAPYEIt1BYpO2PpCMocZPUdo1MSMibbA2Qsx1mKUpDug/+LrDCyjzh40uw2XATesNrvq/vwvFFYzioai+qk8uqm8vYsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736331942; c=relaxed/simple;
	bh=rrBqcReRXKFNrbVbMrxQRcg9wk6B8nbqLR/simXMgRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R54+RWec+oIqZuo9Bpu1MeRkgeCR0ipaklawnLc7F+hFHhWVUJ7BTbRDu8/oOM5yDXH198qIqxk0n9qHGMZThJ8w3ID5gXUwoSnqYfO2O2Mv2p0hSnPaSEoSj4zhlkxElH15TZQN9fDQNPScVv+2ttP960LtkO7WEaWlXxUfT1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kM5VgwgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kM5VgwgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D16C4CEE3;
	Wed,  8 Jan 2025 10:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736331942;
	bh=rrBqcReRXKFNrbVbMrxQRcg9wk6B8nbqLR/simXMgRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kM5VgwgECS4gXI5zq8vdwJ2MZkh/c9BpGD1CnvAmph4RS5ne4FRU2nNgysuYY8Q4B
	 pau76eNGJ2LKvkUcQGcV1foNe9VtBkGm+1D3WUwWBmWLuz9hGR0w+C+PE8uJEVRv/k
	 q1Ecz08XO8VOlFUpcH7zeEJXujBD3Zivq8/CBai1lFK6MRBoQAU/06gC1OwDgVGtaP
	 pFQkL2X38pGRG5Xv+j0SJow4kXqeJSHabm4JvPqrNk60Ajja66jWgwCJKZQhF3sRV5
	 qjDqht3n+JHEBW7rxTfjIeEpO/TtXLl+obgct10m6PfY/KAyGAEzDKkRYaxsdlerNY
	 MgKYKfnctMqVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tVTFr-00A6DH-N7;
	Wed, 08 Jan 2025 10:25:39 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	Vladimir Murzin <vladimir.murzin@arm.com>
Cc: oliver.upton@linux.dev,
	tabba@google.com
Subject: Re: [PATCH] KVM: arm64: Fix FEAT_MTE in pKVM
Date: Wed,  8 Jan 2025 10:25:36 +0000
Message-Id: <173633192698.12207.924921858838622721.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250106112421.65355-1-vladimir.murzin@arm.com>
References: <20250106112421.65355-1-vladimir.murzin@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, vladimir.murzin@arm.com, oliver.upton@linux.dev, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 06 Jan 2025 11:24:21 +0000, Vladimir Murzin wrote:
> Make sure we do not trap access to Allocation Tags.
> 
> 

Applied to next, thanks!

[1/1] KVM: arm64: Fix FEAT_MTE in pKVM
      commit: b7f345fbc32afab0f0b03c71c7eaf48b9a0ad7ed

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


