Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B24321A427;
	Tue,  6 May 2025 08:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746520796; cv=none; b=bKkhRZBpu3e558T3190oHj639Iwy6kvtCOThaYSUIwkZZS00LxdTJSQj4aaKPqZVKstY2V62It5veKE23TgzPT3Hz08ZgJJq20XVrAwf7g6Oc/A6ZO39c7Bq4PKL/qk9SuEMaky/O5fOf8QpStFtNRK1YiARPL/zhtEZF4Z7Rng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746520796; c=relaxed/simple;
	bh=R/t6fC8BgZ5UGdDoJP9eN+Jq6tu4AHWylYBkIjZvB30=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mL6CuHzz+99PZhqqJObrLUzcTE+JEvn7EIWi9SiPTaEaMF48lv5pVL/WG8WPLtDZsihonFhLyitHV9jURGrlicnTv0tp5RiLwU5G6ANYqeKmq8zg8SGiPOE6g/NwYWuQQ2xSFNQnB51tb+5QoR2l9IO9Bio+w1pXiLYdJYXOwrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRSTsY5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRSTsY5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD75C4CEE4;
	Tue,  6 May 2025 08:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746520794;
	bh=R/t6fC8BgZ5UGdDoJP9eN+Jq6tu4AHWylYBkIjZvB30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRSTsY5LuJkkIY9zFfEo0+imGmpxP0qCMWRRx1CLhWW/GFA7jcIbnxSjOMe9jmpZM
	 STHSWL7V19PlSxKqKVjmL58P/cPDCTKJAJmEaqrlq6PTGduSpQ9RwKaU/YH2QypP1p
	 R5svl3kG87xcom0CWV/q+/h+tBjJB12yEJzH+9FyWRup7uNTTtuw6XjD1KCGcNAIRm
	 7xqhV21ksPpOFXpEsIZIxptRmMdN7kVcqSr06B2R9UTOR/fPpFtksdfy/TJDk2ugQh
	 QZYgAceEpQiefLtcrPMCfftTDcKJNIYBMUSsAeQCP4Zpdu/HoebMAEcWf05WNBP6Oy
	 rFf81znN24FIw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCDqC-00C9CL-B9;
	Tue, 06 May 2025 09:39:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: will@kernel.org,
	catalin.marinas@arm.com,
	yuzenghui@huawei.com,
	suzuki.poulose@arm.com,
	joey.gouly@arm.com,
	oliver.upton@linux.dev,
	Seongsu Park <sgsu.park@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	cpgs@samsung.com
Subject: Re: [PATCH] arm64: kvm: Replace ternary flags with str_on_off() helper
Date: Tue,  6 May 2025 09:39:47 +0100
Message-Id: <174652075464.339217.18009123147130751247.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1891546521.01744691102904.JavaMail.epsvc@epcpadp1new>
References: <CGME20250415012410epcas1p42b48977934c21b5db0b19f4185f7a63c@epcas1p4.samsung.com> <1891546521.01744691102904.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: will@kernel.org, catalin.marinas@arm.com, yuzenghui@huawei.com, suzuki.poulose@arm.com, joey.gouly@arm.com, oliver.upton@linux.dev, sgsu.park@samsung.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, cpgs@samsung.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 15 Apr 2025 10:24:05 +0900, Seongsu Park wrote:
> Replace repetitive ternary expressions with the str_on_off() helper
> function. This change improves code readability and ensures consistency
> in tracepoint string formatting
> 
> 

Applied to kvm-arm64/misc-6.16, thanks!

[1/1] arm64: kvm: Replace ternary flags with str_on_off() helper
      commit: d2f14174f9e839e1128664ab339bbe17c333208b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


