Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10DC4CEE53;
	Wed, 14 Oct 2026 12:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791979532; cv=none; b=qUGJLs7nj1Pcf7t/GS0PsecTqhoWzBYy0hc6GIVPqHmx7fizo5oN5azwTMTmsHhsnYjaSurgtt3HuxxhoAda256uup/eyEPhPHiEpE5IQ7X7Y2Ri2d0j9T9LSqVBxmDFRaXUELNm+ip/kYtcpzlruYqPPdTymgR9W2n3XXzv1Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791979532; c=relaxed/simple;
	bh=EwLyOUmKTq+Pgq4Fgui+4muIQaVAEfUm1kjOFtEVhZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lEFW3h9YAQLpmf0kiEPSkJoXP4B+MH3gy8ZBdx36SHXhwr31pBO/V6KkR/j9BwQSydCN/GkExg+My7mFYgF1Ww0+DuNs4yqLDqSgHZOQSyl+lyzGvC9C/1JniuAY3pd7am1GXBuygx45/FSfKJPcry86Ib7QuTDJT+04GcxN3FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=INvyDbEa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="INvyDbEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42C91F000FF;
	Wed, 14 Oct 2026 12:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791979531;
	bh=l3CyP6bumUd+D8iOczfm5+884GmGnnwhG0Qdoxeuly4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=INvyDbEa9+m4JQN5I3onIIUR1JZdRzUwHnkegHqxYhI7XoO+yiOFOD63um0yVj00T
	 +nhEsQg4JWQ1Sb3NgMhBZRmRlBGILXERpnuj0WXPRgz+TRCSGiq4Zsig7iWxjNYgEZ
	 F/blt2tWfCQqhltr12FM4lq3VEe+1cTd4yD5cNhp3Irinkkf1ocY2uV7z/WnLFBNtZ
	 HQH7ZqekWIoMHsdTRETNLmJZNBzeIPhQNPWVujn3QN+f8jmRJTwBm8FgmXEU1DPVNm
	 FwA3m26nDE9MPQlwUBOknpv2XyzL4inWVuvtGevWs4riCXNcetjHbTsdVXVYTOAZVm
	 g3BJ3Y291x8pA==
Date: Wed, 14 Oct 2026 13:05:25 +0100
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org,
	Sudeep Holla <sudeep.holla@kernel.org>, kvmarm@lists.linux.dev,
	maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
	joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
	linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
	jonathan.cameron@oss.qualcomm.com
Subject: Re: [PATCH v22 02/10] firmware: arm_rmm: Check for RMI support at
 init
Message-ID: <20261014-victorious-prompt-kelpie-cf3a87@sudeepholla>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-3-suzuki.poulose@arm.com>
 <2586e689-c27d-4e4c-8c69-03e24259cb96@redhat.com>
 <8be050e3-8af1-4f04-902f-9bc01b209dd0@arm.com>
 <3fbd4739-a4eb-4428-95ae-ead22e7cf9f2@redhat.com>
 <799fb810-c33e-4d0e-9a70-7092c0a681ff@arm.com>
 <0ceda99f-0352-474b-a30a-c5e79b817c2d@redhat.com>
 <ade8dd16-4f09-47d0-a821-636ca4c62565@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ade8dd16-4f09-47d0-a821-636ca4c62565@arm.com>

On Wed, Oct 14, 2026 at 12:06:54PM +0100, Suzuki K Poulose wrote:

[...]

> 
> Then it is RMM's problem if it doesn't check that the right level of
> SMCCC version is not implemented by the EL3. Also, where do we stop
> the checks ? e.g., We need SMCCC >= v1.3, when SVE is supported.
> And >= v1.4 if SME is supported. Shouldn't we leave this to the RMM
> to verify on init and fail the init ? I can raise this with the
> tf-RMM team.

Fair enough for v1.3+/SME/SVE checks, but RMI interface relying on more
that 8 input registers for one or more of it's interfaces (e.g.
RSI_ATTESTATION_TOKEN_INIT, RSI_MEASUREMENT_EXTEND, ...etc) indicate
it can't work with SMCCC v1.1 or below
.
So IMO check for v1.2+ is completely justified here.

-- 
Regards,
Sudeep
