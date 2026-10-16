Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1922561A7;
	Fri, 16 Oct 2026 14:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792160493; cv=none; b=bH9sPWLxx+sXFaHejfTFLOoGs1osziaoMxPJr/MEda+vo+BQC5bzm0Rf0aindpfBe/tzS3uCZf5y0LaykYcOEUTw4a/maidHrUIO/nHhpGz/s96XAOhae4I9q4G9PjGwk8slsbKiZLWSkyym4sRMVhqgshOj0ZvXikVZ4VQqAKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792160493; c=relaxed/simple;
	bh=dFzBhwDkFPwOsZeLSfCKf0dx/m1DdSIIHK+HD+S+UUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B+irWSWG/2stx7/BNbHng3220Rwaokv0xhYifAl8BFuYXzS65rvSlh8lazihlzyVhqN6fMBZbruR+4kUIo0Z9ajovkE0kLsLX2XU3TcWLkASjVYOMIWwQyiVyaS9FlwxatGmwIbUm8ghJCYwpGNjQN4rQFYogYL3XYKJvNO5HtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EOSn+n0h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EOSn+n0h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45571F000C6;
	Fri, 16 Oct 2026 14:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792160491;
	bh=dFzBhwDkFPwOsZeLSfCKf0dx/m1DdSIIHK+HD+S+UUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EOSn+n0hToLCaX8bnSfZ3uWLYIdT4IAlXz2Qo5q957Yq5LYCfR8btLgeLMhLhOIEA
	 KZaX+OMp6nx5+stqC3rZ+dVKK3m1UKEpJvs9KokSXZ9Kln0UN+vCJ5V4QoQh/2FrpO
	 3xPGeNgSlJ0QaePJD4womy6BlYhaYD224akqz8j5t1cJD608Y/r0zoAAASfylt6OEy
	 MB8B/Zu84CKdUVL7z+xpXf2xKrrsMAqeRYWTns2ntNjR8E/22Sz9Sh+jwenrCVSFjr
	 EXYkQfI3VV9BJJAef6zdTB5t/ZaFwJrMDV2X2iGWlorUV9lvveYYcSZLUrpjouedIV
	 a/YQ2h9Is5Iaw==
Date: Fri, 16 Oct 2026 15:22:00 +0100
From: Jean-Philippe Brucker <jpb@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2 15/15] misc/arm-cla: Add vfio-mdev user interface
Message-ID: <CABCqBse_aZL-EH0us2uA5X10q6E4WP02MoHTYf+M9ezRZr26WQ@mail.gmail.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-16-ryan.roberts@arm.com>
 <20261015164102.GC13920@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015164102.GC13920@nvidia.com>
X-TUID: CePXLswkibsA

On Thu, 15 Oct 2026 at 17:41, Jason Gunthorpe <jgg@nvidia.com> wrote:
> I think I said this last time, please don't use vfio mdev for
> anything. There is nothing mediated about this.

We don't multiplex a device between guests, but the host driver must
control part of the device registers while the remainder is assigned to
a guest. The host configures accelerator access, stage-2 translation,
handles CPUHP and context save/restore. So we can't bind the device to
vfio-platform.

Thanks,
Jean
