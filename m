Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B3D1F4735;
	Mon,  3 Mar 2025 23:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741045474; cv=none; b=itSNC6NnNoKV1LnBojL3PGPaxFgakkAE6TSn3sm/sfMEY54YWSsnMjDJIeuAUIIqKV2SFn6i9PcmUqCZIKvyQ7fFYqLz37vp3n1zeqJwPhchwuvF65CsS+9vvrbZpwRS237rUEn+Y1yTHq3r5nigZAkbmd2QMH/GYW01O/b9fPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741045474; c=relaxed/simple;
	bh=mYuhDBxNc/e89ws6z4cdoCMAAbClP8hLNaC+xBDI57E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EqlUJ1RGjvvU+B7UCUmVc9Xh+0epRREvDgBX4gFske5AA0lA7Qd92nZfWiknBwqtevdp98HZN4XX+0etLeH41KZ6kC72ta9WH+ocY4HO8/in3TCrlKaIKipyCzkICNwmZbZnVrkCnAQNVEZkdhgffytWE7/5MEI/J7H3RrMmEuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o31MaesC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o31MaesC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14BAC4CEE8;
	Mon,  3 Mar 2025 23:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741045474;
	bh=mYuhDBxNc/e89ws6z4cdoCMAAbClP8hLNaC+xBDI57E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o31MaesClDbhQ7BppcXMKmMs6N/dQaiDATGICBZiGtiO6FycEHFyv3Nhx8qQCqSjj
	 3xlP2WcD7i2kRRK4XemY3j54us/Dlx1x5kgB66WVjeERbGVE98/ARiHcYFwynH7AVw
	 O5sVHJPRhV32fJQ+pK85kZMgyc4I+NZGHOUbYC+nx1UXnNZJUGJLdWeRSDlE8P5TVX
	 2unjRESVuJIrVcj1r4b3+VcgKxQHTuvIvT9KW6WBiM5u2GFuecGi2z1yZG9zmuRg5o
	 hlfQLUJHa08c9U7rQH0quO5M6Un+KhIuXjZpHwOtBt8tY6UR4k7YXwL9ZCH6pfC/uv
	 sGoOZZp9lu/lg==
Date: Mon, 3 Mar 2025 23:44:28 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: Sebastian Ene <sebastianene@google.com>,
	Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
	joey.gouly@arm.com, oliver.upton@linux.dev, snehalreddy@google.com,
	suzuki.poulose@arm.com, vdonnefort@google.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: Move the ffa_to_linux definition to
 the ffa header
Message-ID: <20250303234426.GB30749@willie-the-truck>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-3-sebastianene@google.com>
 <20250227202557.d3fd6ylzbaho4pvx@bogus>
 <Z8DxZY-09R6lwEW3@google.com>
 <86wmdapei8.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86wmdapei8.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Feb 28, 2025 at 10:09:19AM +0000, Marc Zyngier wrote:
> On Thu, 27 Feb 2025 23:12:37 +0000,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > On Thu, Feb 27, 2025 at 08:25:57PM +0000, Sudeep Holla wrote:
> > > On Thu, Feb 27, 2025 at 06:17:47PM +0000, Sebastian Ene wrote:
> > > > Keep the ffa_to_linux error map in the header and move it away
> > > > from the arm ffa driver to make it accessible for other components.
> > > 
> > > Do you plan to push/target these changes for v6.15 ? If not, I can take
> > > this patch with other FF-A changes in my tree for v6.15. Otherwise, it
> > > is must go along with other changes.
> > > 
> > 
> > Yes, feel free to pick them with your changes and we can push them
> > later.
> 
> So this series is not a 6.15 candidate?

I think this is 6.15 stuff once it's been reviewed. Sudeep's message is
a little confusing as it refers to 6.15 twice (I guess he meant 6.14 the
first time?).

Will
