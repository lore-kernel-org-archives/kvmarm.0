Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AF736139;
	Tue, 13 Aug 2024 07:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723533378; cv=none; b=X9BaqDWAOikJVUmBdq0+hJ4rFNHcAS38j318lHLICnvZum4w7MTdiN29DUV6vs7WqS2K05TTtSbTDOgLLXVcxvjFSFUgeGEsSWpvyeO/Be1nx1fwUZ9H3gQXuGrZAtq7k/muiddSR2847asQYxS4fKSJTqbdH+0ehkc0Xq9mEow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723533378; c=relaxed/simple;
	bh=Zw38o+oLyow2tsJrgb+SA6FlgG4nHiNDqOq3Xu6bCOE=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=BjafUvxqzJFHtuuiygUvhF5z/MVY3dnd/By311fEG4KqWz5h3PmKUBDoFf/e1tKpFXdTaUvRJup4+NhRBcguNJKyKbO+j2ftrWX/UwTVA+GZrBMN25G2RihL88MoNneh1hr+ukUA1rvioG6efLUUa7bmhueq0EW2oLdXU7QrBpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQfshzgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQfshzgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB13C4AF09;
	Tue, 13 Aug 2024 07:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723533377;
	bh=Zw38o+oLyow2tsJrgb+SA6FlgG4nHiNDqOq3Xu6bCOE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oQfshzgBYzi06GWTwVnYuFQ3M2OJFuGmpSKXX2xposVRmUl+p/hkTjLGQitQoIj1O
	 Ra6aElb2eP9oQjEOzDt+h2rSVKUXHA61UlL83EveTxWSW3rNRzzZ4p/zNBn5qWBD+D
	 QZ+PQwQXITqEMtVzQO9eOXjjn1h8UQcjkBNg3vjj/XdPm6kuc41gkdSCG6C1y7lR6I
	 JS30VHXT4yf6F/DQSSFqFQ3quo9EMIWwucL1Kpd6DojwlhH3Q9AWJN24kz18jHw/KX
	 ublu3qxLW8rt88IMS1z6/l7TTnfvyQq7doYIi26FptgdASvmxrz8/gVBpYt9NRkSp+
	 VNFQdtt7aVF3g==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdllP-003F8N-7R;
	Tue, 13 Aug 2024 08:16:15 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 13 Aug 2024 08:16:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Oliver Upton
 <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K
 Poulose <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC 10/10] KVM: arm64: nv: Add new HDFGRTR2_GROUP &
 HDFGRTR2_GROUP based FGU handling
In-Reply-To: <6c479aba-10b9-46ba-92fa-d3b20cc82d61@arm.com>
References: <20240620065807.151540-1-anshuman.khandual@arm.com>
 <20240620065807.151540-11-anshuman.khandual@arm.com>
 <865xu3kh4r.wl-maz@kernel.org>
 <4d256df7-1ec7-4300-b5c8-355f46c0e869@arm.com>
 <878qyy35e5.wl-maz@kernel.org>
 <47dc4299-52cc-4f98-929b-fb86bd9757ae@arm.com>
 <86tthhi0nz.wl-maz@kernel.org>
 <c84d0081-5afa-4bc2-82f4-a6dd07b8ab87@arm.com>
 <86o76c1b8p.wl-maz@kernel.org>
 <d56735e2-3fee-4d91-84e1-a5b480ec0ce1@arm.com>
 <86bk2b198o.wl-maz@kernel.org>
 <fb9bef18-adf2-4d3a-8205-b22a65b0c6db@arm.com>
 <87sevk4kgr.wl-maz@kernel.org>
 <6c479aba-10b9-46ba-92fa-d3b20cc82d61@arm.com>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <39b14f98acfa1afcbdcb46950c62e6c7@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: anshuman.khandual@arm.com, linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2024-08-13 07:53, Anshuman Khandual wrote:
> On 8/4/24 16:35, Marc Zyngier wrote:
>> which shows that an SPMEVFILT2Rn_EL0 access from EL1 traps to EL2 if:
>> 
>> - either HDFGRTR2_EL2.nSPMEVTYPERn_EL0 == '0', (check)
>> - or MDCR_EL2.EnSPM == '0', (check)
>> - or SPMACCESSR_EL2<(UInt(SPMSELR_EL0.SYSPMUSEL) * 2) + 
>> 1:UInt(SPMSELR_EL0.SYSPMUSEL) * 2> == '00'
>> 
>> and that last condition requires some more handling as you need to
>> evaluate both SPMSELR_EL0.SYSPMUSEL and the corresponding field of
>> SPMACCESSR_EL2 to make a decision. It's not majorly complicated, but
>> it isn't solved by simply setting a static attribute.
> 
> So IIUC you are suggesting to handle SYS_SPMEVFILT2R_EL0() registers 
> via
> complex condition checks where the CGT_XXX can be directed to a 
> function
> callback instead ? For example, something like the following 
> (untested).

[...]

Something like that, yes.

         M.
-- 
Jazz is not dead. It just smells funny...
