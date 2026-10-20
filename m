Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792497092;
	b=fpmEOwcfLwTzFqtJmY2AjTOIPsoXEejvovtScvrbrdcySWm+JbAFec4SA8Qtv39PGgeJ
	 II7SBfNPMszpBbnh0DWopDP0Q2pOzY9cjDm+l99leBERMsa1ZZSuVvrn4e7+eDLGTx17U
	 osx4mQ45mnY+71Z3XSejMOqkrgzITRyfK6dWww7AfPxHG8kvawLSr7bKLwvXvB/NC5AOZ
	 FcnhRysGkmqcj2BqVj5Mnlw+jKN/K6GZD3rdMiVdPki/Hjx1SvFGhATK7YR6zHQUeX5YU
	 H8zXk4e9gBj9KVQWhVfsEPeJgmpQ9tjZj/ZIlbuNen/2xsoP3Y5L9qFiDotA/RfWjvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792497092;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=nNoA3+6wTNExlUkYZCt9HTAT9xEHjkyLUdvHdZCEN4Y=;
	b=btpcrTjvIIQ9JxjCAyCcCU0e65Avy4OvkXcAMmi0/rIF/3aAFJdZGh8mxa/jkd4SyTBO
	 hJB1vHbVMVkef8Z8eSmQuBpro7L+0hntXSkMU5n9aqIB5IZbQkZ1T+jGdT6YMdoxXGxye
	 JpOFc3dWZonIOWu+YI7mqNlCMkPF6cRb3sCPkkPzkkXmKZADtRSlCF1xtVAodVn/TK4yl
	 kCYK+7SyFsQxje/Slh8jH+FhkjVkbWv0fe5aX4axJxFX1rPastsrVjtOUCKOoFRuB83Tq
	 YRjp30hT8bb+IpHTmSG6KAFZMXgHwz3ydHWjKj0YLaF8jjCJ8REVLK+2iuJtGuw7Z3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k1oeeqEy;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4106606A31D
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 11:51:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4106606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k1oeeqEy
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE6E21596;
	Tue, 20 Oct 2026 04:51:27 -0700 (PDT)
Received: from [10.0.137.15] (XHFQ2J9959-5.cambridge.arm.com [10.0.137.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1F9A3F7B4;
	Tue, 20 Oct 2026 04:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792497090; bh=UFdHRBoQNmzK3J1KulBJN2N/STdJqV3Qy+2zaWTevg8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k1oeeqEyXO6BAXWERGM3PoBR163hq6VQuZgUfNyIwbgfcGU+dMXRc6ZiMZ8nIPUHE
	 hepPI5uQuoBLhfyK2T0O/Del6FpxrnjimRZS57vdorb4f0y7hQi1/BYwO9CNcBOF4p
	 xtMeabKTRqXJsmvVN6HMxF9dAnQOgKizG9dfxlgQ=
Message-ID: <95e0f9bd-0203-4c7a-9d09-622593bb3d4c@arm.com>
Date: Tue, 20 Oct 2026 12:51:26 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 12/15] vfio: Support VFIO devices that access the
 CPU MMU
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Alex Williamson <alex@shazbot.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Jean-Philippe Brucker <jpb@kernel.org>,
 Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-13-ryan.roberts@arm.com>
 <20261015164421.GD13920@nvidia.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20261015164421.GD13920@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Jason,


On 15/10/2026 17:44, Jason Gunthorpe wrote:
> On Thu, Oct 15, 2026 at 03:25:46PM +0100, Ryan Roberts wrote:
>> From: Jean-Philippe Brucker <jpb@kernel.org>
>>
>> Support devices that are attached to a CPU and perform DMA through a
>> MMU. They do not have an IOMMU and do not use a VFIO container.
>> The VMM needs device-specific knowledge in order to create a virtual
>> device (device tree, ACPI tables), so it also knows not to allocate a
>> container.
> 
> I'm not so excited to see new things built on top of the group
> interface.
> 
> Maybe in this case you just don't have to do a bind operation on the
> cdev to an iommufd? That feels kind of natural if you don't use a
> iommufd

Yes, that makes sense. I don't know enough to know what actually needs to change
to make this work, but will look in this direction.

> 
> However.. you still have to affirm which single mm is the mm that the
> device is going to be doing DMA against. The process the opens the fd
> should not be forced to be the mm that it gets linked to.

What is the mm representing here? Ultimately we want to install the KVM
instance's stage2 pgtables and (pinned) VMID. We currently get that via the
bound KVM instance (which looks like it still works using the cdev interface?)

The guest will then install the stage1 pgtables and (pinned) ASID associated
with the relevant (guest) mm_struct.

Do we _need_ an mm association in the host?

Thanks,
Ryan

> 
> From that perspective maybe you should create an iommufd and a special
> "SVA" IOAS that it can attach to. This is more complicated but it
> makes the mm linkage and blocking beahvior explicit and controlled by
> userspace.
> 
> Jason

