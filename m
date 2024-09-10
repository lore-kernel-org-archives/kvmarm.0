Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEE717C21B;
	Tue, 10 Sep 2024 07:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725953016; cv=none; b=Qh3DDEdOGM8PBlwAvH44sHMfFh2H3um5NQ1w2DW2bjuF1aojLY9KqCrd7ADc5JTKKYQ+tE741gdjfENTL1O1WglR+F4EVB2LIJQQFBoYfHbX4SVWv7FLRefA2dkLNspFTKcUHl2iH0Djxt8zL+OAaUYAe31K5K4glgR7K9OrYIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725953016; c=relaxed/simple;
	bh=vUfECv7ctn03IjEReexJXO2Br1c2qClMqTt0MQwi4tE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NtCMdfp9Fye6Xxv/pzwyw4G3fv/mi4gKPS6EZlZZLezLBeZ4DqwOlyMMU8IjUpaG0ZUVFllPvmbIShm5Gd9b48VxGzmTXJ4xA4awwekiD09wkzhZSKTEPNPVkJIFhrD4/UHkqOLDq/iCEiIixNqnG93lGtyD4W6hw315IoXJo3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehYqi6pY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehYqi6pY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61316C4CEC3;
	Tue, 10 Sep 2024 07:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725953015;
	bh=vUfECv7ctn03IjEReexJXO2Br1c2qClMqTt0MQwi4tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehYqi6pYEocvFz2Pgs95A2w7Pl8uLA1132KwSRPYx61vI/4lLVKl1FJCC/T8pyBvm
	 G/daIsxWYj+Lgq5Qa+R2VLSrW2icFkwRZFXhUsLQY4/S0cPAm9c0Mv+6gk6dNfC5dZ
	 7EXFTBzRg4boMibFv37g6kxhxRdqpq9UEUYzxhbBk22XXEVXGJrVuqIyWQpHTbBbdG
	 Qc7m7p5AprpLv1eFvscHfYjq4AZCBTyFO+g3jTloWggb/khQrmcZAj/ojxNOasx/wY
	 QxZGnaPP/4rSCR10mqWOreyFi8FHZmbhkm2kQvrOzpomvsSJyLTowh8zMT3Nbsjpfg
	 IQtivLBotYbeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1snvDp-00BdPu-2N;
	Tue, 10 Sep 2024 08:23:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>,
	Snehal Koukuntla <snehalreddy@google.com>
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sebastian Ene <sebastianene@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer
Date: Tue, 10 Sep 2024 08:23:14 +0100
Message-Id: <172595297831.336083.5203096550952682549.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240909180154.3267939-1-snehalreddy@google.com>
References: <20240909180154.3267939-1-snehalreddy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, snehalreddy@google.com, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, sudeep.holla@arm.com, sebastianene@google.com, vdonnefort@google.com, jean-philippe@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Mon, 09 Sep 2024 18:01:54 +0000, Snehal Koukuntla wrote:
> When we share memory through FF-A and the description of the buffers
> exceeds the size of the mapped buffer, the fragmentation API is used.
> The fragmentation API allows specifying chunks of descriptors in subsequent
> FF-A fragment calls and no upper limit has been established for this.
> The entire memory region transferred is identified by a handle which can be
> used to reclaim the transferred memory.
> To be able to reclaim the memory, the description of the buffers has to fit
> in the ffa_desc_buf.
> Add a bounds check on the FF-A sharing path to prevent the memory reclaim
> from failing.
> 
> [...]

Applied to next, thanks!

[1/1] KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer
      commit: 39dacbeeee703d29140aca7bc2826d4b1936ecb6

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


