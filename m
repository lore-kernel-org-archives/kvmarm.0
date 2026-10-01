Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBFD3E40E4;
	Thu,  1 Oct 2026 16:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790872605; cv=none; b=k+x5EiDJqchzUZ+T0CVV35ryZJPgfEYACT55yp3O6fivo1X4BW5eBx2S3xBn8m6QVBV0G6kGv7rmxwZRzvQqAVdkeiXI4C4BSDbFsiXdR8BVmqnAN2YMJyAs/9Wd8A/lSaZDVP2UVPL/jbkQsNPKNtk4d2FWK2b0JtuSBRjX4Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790872605; c=relaxed/simple;
	bh=BXLMAg3FlhSPADp+jfcghXHh3xfR672rAp8rAyJvzVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5VIwmAZQ6sCFsFheDn/ciBqgtG19jkQJlvznXKX1fLjKh9Le9YyLnBRA/21MinPPTobgH0Mlsm1JDqccRFDu8oZbyIm2/6/uN9jRrPC90pfOGu4+MvTiZYbHe/unH+DuYroEpX3A9nbXliY0sIKLJUQL2WpM0bq7XhWb2XOC7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MI2RWpwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MI2RWpwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF1E1F000FF;
	Thu,  1 Oct 2026 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790872604;
	bh=BXLMAg3FlhSPADp+jfcghXHh3xfR672rAp8rAyJvzVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MI2RWpwaJp/wRl1dRcHeuajsqvY1oGk53fo/PNKRs874vC3Bu+RiWPn45D7au2Wry
	 6J+WxP1QK/S2chfk9HGMdhF6jToyBoWYT9aKw71o5zKTuuKs1hxgYeKQmFqeMrIjC9
	 6TjFR1H3Pq9pofIW5XS2U8Pv/7Vw3f+CHJyHek59TUX1nkUrwyg52gD7/AnbifIwKf
	 s2jpADjhYjtpkgBn8BY5zZy1BpXJPYeysTIR5OU8O7VT2wkHGf6J11GYrBiGTztNwB
	 bfAGwLW1/Vh3qIAiOZ2r2EajetCqfCxlPYcEypgpm6rzT6VQL/nlk+bnY0lYcF4PPk
	 1IP/QRrT3Zjwg==
Date: Thu, 1 Oct 2026 17:36:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Peter Maydell <peter.maydell@linaro.org>, 
	Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Subject: Re: [PATCH v21 11/15] KVM: selftests: arm64: Add GCS registers to
 get-reg-list
Message-ID: <ar6L9O-MGe12d95Z@gremlin>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
 <20260930-arm64-gcs-v21-11-3556644cd927@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260930-arm64-gcs-v21-11-3556644cd927@kernel.org>

On Wed, Sep 30, 2026 at 10:48:21PM +0100, Mark Brown wrote:
> GCS adds new registers GCSCR_ELx, GCSCRE0_EL1 and GCSPR_ELx. Add
> these to those validated by get-reg-list.
>
> Reviewed-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>

This looks obviously correct (TM) to me so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo
