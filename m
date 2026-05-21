Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29ABA220F2A;
	Thu, 21 May 2026 12:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779367879; cv=none; b=hcmfV40P4wgNW/+hUlBupahoFnXhPqsqyONjkFjq0Lh6TmgmP8QjPgdznndmT/UqNjjmTWVreDdnrxnWaz2fN4VA+k50JNKXR/jacygY7PxANACrZ/IiyXqOFVPFA4GMtSVZCJOrzUNQINzPw/p/W6BiFpvUOkQpV8OcgnF/CAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779367879; c=relaxed/simple;
	bh=7jzHvKRd/On+GRBlud+zh/apk/tg0aHT5tC2fNXMtRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u2C2th/xhQMDEDG5r7H7tk1tRbSsLmZsA3bwkQwGW5jGmwzzXaVR3uIhVgtKoaKH1VAVG8GpJ0oU5W6/K2JiH/dqnQrL7H3EFxxvERPDhp6yvLbf1wn9qDk13LoSsPB+VqnzTW5oh8uoQO6iT2RhEtWF88xyvYW8OxkEJFMxpNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkToSujN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkToSujN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399F91F000E9;
	Thu, 21 May 2026 12:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779367877;
	bh=53MBMVpYsah1G6NU1zmq3jtKdic1Gk+mrU5myoZHcTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BkToSujNclyXcE88OzhY40ufvQn2cBGui3KuvHUppU/C9uik42OSCjbIQqlUp0FIf
	 01BFXGNtxBBf3a7CeCM8rndojcNt2MN8sA/1RQ2dVXcqPbR9TmXZXbD8RY7XQRqVuq
	 vzMNbPTwmKMeuUjg4JGCRHdyGZkz/GkwGF4/E12viTb43aA+fqmDHYM2cedyi5ikYR
	 ochACvQ3dea/2IQoJjm+7upgYdeJfdaaOItq8r+auwNgK3PZWxquM/lO3XeDuxEH7T
	 xRvHLTIceWp0qqY40Cg6lcme/SuObotCdw1AP8VMP9uTfFKj2C5PgG+k8k8rGhLdBR
	 BXz1IUF6qogcA==
Date: Thu, 21 May 2026 13:51:12 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	oupton@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	catalin.marinas@arm.com, jens.wiklander@linaro.org,
	sumit.garg@kernel.org, sebastianene@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v4 2/5] firmware: arm_ffa: Fix out-of-bound writes in
 ffa_setup_and_transmit()
Message-ID: <20260521-gleaming-shoebill-of-artistry-5d738c@sudeepholla>
References: <20260520204948.2440882-1-smostafa@google.com>
 <20260520204948.2440882-3-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520204948.2440882-3-smostafa@google.com>

On Wed, May 20, 2026 at 08:49:45PM +0000, Mostafa Saleh wrote:
> Sashiko (locally) reports multiple out-of-bound issues in
> ffa_setup_and_transmit:
> 1) Writing ep_mem_access->reserved can write out of bounds for FFA
>    versions < 1.2 as ffa_emad_size_get() returns 16 bytes in that case
>    while reserved has an offset of 24.
>    Instead of zeroing fields, memset the struct to zero first based on
>    the FFA version.
> 

Neat, I clearly missed taking this approach when I added zero-ing of
member initially.

> 2) Make sure there is enough size to write constituents.
> 
> While at it, convert the only sizeof() in the driver that uses a
> type instead of variable.
> 

Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>

-- 
Regards,
Sudeep
