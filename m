Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793804971;
	b=V8jUgUNwrMOhdHIMP6SJ/Gvfe1U/NHx9qfXah/VutMt6xXH2vmWJAUTh5a/WmVhEbata
	 lYCDD0YJBR/Tj5q4cpCjZ01lOevx+oHBRmO268bcKoSeEjvqIUqc81lnJbp0rXbe14rJO
	 DhZeqcYTeArO55Lxj1mjAfmBY0TLOiIlClLvCzrrH0frP3cpuF5sZsIhnERPpFdYsOST4
	 mtcS8IPPitBXnn9RC/qyMlOsFC7nwQmNF5hsLa48K0zU5DIE07pfqnbmKuYd2o23D53pl
	 bQZZ2teMW0khK7DV74W+aFBoA8MYLK+3hvXE00XIE7MOySEvRs6bDmCH7NS/KrbQD6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793804971;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BFGjOyP5UIQiJBxM/VFU684BMQoEd0KQaBTYoIf/jec=;
	b=rmC2amJBZ+bTELzX+RyzfGdC4CNhAXg8155IB58bGnuQUeH81gUJe3rUfXo/MQdSJ4Ut
	 ClEKhkcz0HyyyawppoDSeIb3hnCVoopTZimwbJfcjVW5utFa5K8CawijsmdkC7SUmUulA
	 T12LicSo2O58CYfQfgxXimrTVlDw7FLdsOIPX5p379D6uP78fdd5jtAe6ZuLgnoCNhk4O
	 3plkBiqZhG09LwGIin0dV04RLv8tlRwkgHPxrDob3WxSKqs7KWqVP9rdCheHjzaTzzlRn
	 2sfMAMelLIxDzmcKvVdCEASKNdzJDkaE1XjmFinzNviZt+yyRWm7Stt2l+ewmQhIFvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MikdqmwL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C2B606A335;
	Wed,  4 Nov 2026 15:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MikdqmwL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CDA1F00A02;
	Wed,  4 Nov 2026 15:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793804970;
	bh=BFGjOyP5UIQiJBxM/VFU684BMQoEd0KQaBTYoIf/jec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MikdqmwL0zghAEx2caid1swCm7g3GXwsdv3H7ISWA6PMwbbp18mgRC71GTVXDaZdp
	 Exq1UpQ2I5D35E9K9/i5jEsZiRyjQIAufLiJqfUcJfGZelAI8H2IwcwK6rcav4yw+s
	 6SJzuQcTygDY66L5tYG6ssqTjXgPz1rXTO+TEM94=
Date: Wed, 4 Nov 2026 16:09:29 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@nvidia.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: Re: [BUMP] [RFC PATCH v2 00/15] Arm Core Local Accelerator Driver
Message-ID: <2026110454-conjure-unfasten-1fe3@gregkh>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <80b69632-dbe1-405b-910a-c17a943d8fc2@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80b69632-dbe1-405b-910a-c17a943d8fc2@arm.com>

On Wed, Nov 04, 2026 at 02:41:59PM +0000, Ryan Roberts wrote:
> Hi All,
> 
> Just a polite bump; now that -rc1 is out, if anyone can spare any time to cast
> an eye and offer opinions, I'd be grateful. At this point, I'm most interested
> in feedback on the arm64 integration aspect; If you see blockers I'd like to
> discuss early.

We are _drowning_ in real patches right now, RFC ones go to the bottom
of the pile.  Please work to make this good enough that you feel it is
no longer a RFC and submit it that way.

thanks,

greg k-h
