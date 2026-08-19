Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D29A948AE10
	for <kvmarm@lists.linux.dev>; Wed, 19 Aug 2026 16:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787157743; cv=none; b=iz35bxOxt/pmJ4wAnWC1tEkXZl59ksSHpahXVGWmc0pfu8Res+LlEOODwPT9e/6FZimFS7LEvPHT9npYDilAlX/lViKUTmM/5t7dJqAg27rca7W7QVHcd9u6K+v6Mpf54aLZOBpMs4YPqOEAlly0uYOX8QyQ3b94P8SPogfQAnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787157743; c=relaxed/simple;
	bh=W1ppSykwItkTQz0g17FZTvhSElTOeWoKXsJjVg7bfAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=GVqHwiBNvVY7tn/zz1mOdWaIU8XKAzJmZuuKwuzTFmbT0Xci8QrRP6XxkvdmucHaOTT51y+w18uHTTOdqDubB2yyUMdsJbpyAQiNtuAoU5wB87WzfS9lhrWFBUV497/vKCbHPxD6vltzwxqX7Xw28jI50b0utduIzyGLUGr06XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Figfs/0i; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Figfs/0i"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BBA214BF;
	Wed, 19 Aug 2026 09:42:17 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C8B53F85F;
	Wed, 19 Aug 2026 09:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787157741; bh=W1ppSykwItkTQz0g17FZTvhSElTOeWoKXsJjVg7bfAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Figfs/0iURS/KBp+1t5gW7r16MA/MdgyFtdE7+XSkDILZ+jObt5M3XdbCu8q0Tw+Y
	 leewidxQ6MOjHdQmZMl8u2WpTm5F93N2jFoBK0SH1ldOigAbLLQ0nO8e7h2Mi+vqpT
	 OhiiT+UaosXRFOevgQfIaD9La+GypT9TN/L+9wY0=
From: Leonardo Bras <leo.bras@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oupton@kernel.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v19 02/14] KVM: arm64: Fix FGT mapping for HFGITR_EL2.nGCSEPP
Date: Wed, 19 Aug 2026 17:42:16 +0100
Message-ID: <aoXc6FAZf9GFo0cg@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <aoW1ywZGCvJaYQqN@LeoBrasDK>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org> <20260812-arm64-gcs-v19-2-9105afd828ac@kernel.org> <aoW1ywZGCvJaYQqN@LeoBrasDK>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Aug 19, 2026 at 02:55:23PM +0100, Leonardo Bras wrote:
> On Wed, Aug 12, 2026 at 08:12:01PM +0100, Mark Brown wrote:
> > The encoding to trap mapping currently maps a FGT on OP_GCSPOPX to
> > HFGITR_EL2.nGCSEPP but as per DDI0601 2026-06 this FGT controls trapping
> > of GCSPUSHX and GCSPOPCX, and not the separate GCSPOPX instruction.
> > Update the mapping to reflect the architecture.
> 
> That information seems to match the one in Arm ARM version M.c.
> nGCSEPP, bit [59]
> 	When FEAT_GCS is implemented:
> 	Trap execution of any of the following AArch64 instructions at EL1 to EL2:
> 		• GCSPUSHX.
> 		• GCSPOPCX.
> 
> It looks like GCSPOPX can fault if the record is not a valid entry, but 
> there seems to be no trap register bit for that.
> 
> Thanks!
> Leo, 
> 
> 

Ah, FWIW:
Reviewed-by: Leonardo Bras <leo.bras@arm.com>

