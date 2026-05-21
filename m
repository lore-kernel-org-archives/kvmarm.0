Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A1922E3E9;
	Thu, 21 May 2026 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368119; cv=none; b=sd6tenLWzWpR83WSPxbCN05X84a8w3v65rLXM5YTqAS1ADDgOGe/vFhGcZseZy1L7+NgSwElRTBjXHEj1mcVwJUlqy/ne4LX4othWZtcW73R0VtazH0uhUQ6kC6nd4ffoMYUoqVaBCibxM11jr1TTe4HkBJsWIZA3iflnAfz6oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368119; c=relaxed/simple;
	bh=oNESJaglCL1dzgX1GFakHoQU9tj1dtl7uwau92+WcXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QFR99TepSAaa9n5qKeKo8OX/bg/42JfCWQq5Jybs10hWTBydfSczB6TR5NQOoxfHcrc2zVx+PAPpeTBarUDM1W+aS9/0AhDvjuWkhrAvGMdMkEVtaefkdjfoEsoZzhQqCxw3YOPqjENkBWMRlsq8as2/khFcWj3fpCanjyxsy38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpgFNDcZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpgFNDcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B23E1F000E9;
	Thu, 21 May 2026 12:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368117;
	bh=Yr/9hqel5Ty7gJs+k9crOmQVKqRYap/VGhhoyrbDA9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XpgFNDcZjIVY1mOkaN0Kgu/WBJ513yFFIh2BykmcZhcM0Ly8zIOzBatosDmsUVOtf
	 9WlpeZpBVuqp58MnGm57uDZ/B9TA1HUAyX3LLDbZk1cvWvT6XDr+UcTNEaUsN0TeUH
	 8MzKqr+28wazSELnUGFpFEJjLWTLsyl86+yJosRYlvhlWFYKarbvrku9JD9aeEp9ud
	 XaLXCSNQ923dEvXzPQPJ6DbW5t0hJA94ProbfTBUWOnRSgJBdCV0b9m55kIEr1LCp6
	 TXyAPDKwbYRzzWRQiFtv/VLqsMOf3saXZrXsGkbKbVUbOMYSRZF6NAtVHk6BmW2zdv
	 BOfYgZe4dRE9g==
Date: Thu, 21 May 2026 13:55:13 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	catalin.marinas@arm.com, jens.wiklander@linaro.org,
	sumit.garg@kernel.org, sebastianene@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v4 3/5] firmware: arm_ffa: Fix Endpoint Memory Access
 Descriptor offset calculation
Message-ID: <20260521-lynx-of-uncanny-intensity-9e37a1@sudeepholla>
References: <20260520204948.2440882-1-smostafa@google.com>
 <20260520204948.2440882-4-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520204948.2440882-4-smostafa@google.com>

On Wed, May 20, 2026 at 08:49:46PM +0000, Mostafa Saleh wrote:
> From: Sebastian Ene <sebastianene@google.com>
> 
> Use the descriptor's `ep_mem_offset` to calculate the start of the endpoint
> memory access array and to comply with the FF-A spec instead of defaulting
> to `sizeof(struct ffa_mem_region)`.
> This requires moving `ffa_mem_region_additional_setup()` earlier in the setup
> flow.
> Also, add sanity checks to ensure the calculated descriptor offsets do not
> exceed `max_fragsize`.
> 

Core change remains same as v3 except improved error checking, so my
review still applies.

Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>

-- 
Regards,
Sudeep
