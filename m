Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792506456;
	b=tvqbp+8hSAhQeAZ2g1Tu8y7JEyO2iYOYF0prXUfUJcDCXkvPwzkiwh+14Fj2xCv/83Wc
	 lXTOSdALcR8Sar2ml7pV2IH4vxfTB/in4OknCAvo6tQP0/PTqQEvNbOFe97LOfhZ12QoM
	 nlzHv4G5lQm2T0indRNcGMVNBzIeJ7Te1xXydjNY7QUTaRQV+5ZVTtTImxIibpRl7ylt7
	 S8IFfk1slMzK82NI1X4RgJQXFkFnvUfM16PXGCAUDbLAqrtOU5XG4FfKcrbPDrk5o9OlR
	 nDD9tvOtk6iPxacmNjb3ItjogTXDeRf9DdPLV6t391OC0w/5gU0by0a0JBcJbLsvHdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792506456;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Dd9e46BTrpHgF60mWtnGPE2/vPI3dSQPcJz11b4S1jk=;
	b=WpaC8h8HiYdMcYxnz/RJzQt1hTMtkp3AZZ7GnORZsKkwgHLs+HtYvQahAjobUXCopy2t
	 6A1RebPqra4ECIJz8v7ebrufcudcNrpMkI9nq0eJPeHo+yCdgudWfAGwpdQsjstOfjeOV
	 AYmeLm0eWR5wJWnMW99aD3cj5Y5njfsMBDGQClnUd4ZUK63JxCgbQmTIIbZRiQmcZc7pV
	 GKO8Kvjzn8BBBhQ1JikXlrHm+VWTnzg0TF1zlwdgMjbU0BR0iPeXkNKS5WHEZNcG1Egiz
	 +nYxi6kKPkLV5EA2k+cr12mARzQ20il7lPklLEEcOJagW7+eVVAUwY5ReJ8bHI9J1lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BPAHlMuP;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A8D606A330
	for <kvmarm@lists.linux.dev>; Tue, 20 Oct 2026 14:27:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52A8D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=BPAHlMuP
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4272616F8;
	Tue, 20 Oct 2026 07:27:31 -0700 (PDT)
Received: from [10.0.137.15] (XHFQ2J9959-5.cambridge.arm.com [10.0.137.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D2363F7D8;
	Tue, 20 Oct 2026 07:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792506454; bh=II7XzKF/T9a42uG8lOm7+KYJJnneubeimBS3uGSkock=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BPAHlMuPMZTzU3zfBQVYdzZx6EFum1IZ9tNdfI41BIOD1ynRavvH/BLSpoHVkwC7j
	 GsxOWywnQWifJ95J1IVxn6CyoFnm6HTr1FG1Zk1MR5LW8CW5zDQlNmBupLWLyCWxE6
	 +Tufm7Qk3l7H79TsgTEtkuAfPiAAvp+fpJIutrRk=
Message-ID: <08521420-5adb-4e3a-8110-4713bcd5dfa0@arm.com>
Date: Tue, 20 Oct 2026 15:27:28 +0100
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
Subject: Re: [RFC PATCH v2 15/15] misc/arm-cla: Add vfio-mdev user interface
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jean-Philippe Brucker <jpb@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Alex Williamson <alex@shazbot.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Oded Gabbay <ogabbay@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, devicetree@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-16-ryan.roberts@arm.com>
 <20261015164102.GC13920@nvidia.com>
 <CABCqBse_aZL-EH0us2uA5X10q6E4WP02MoHTYf+M9ezRZr26WQ@mail.gmail.com>
 <20261016144202.GG13920@nvidia.com>
 <375868af-d0bd-4278-83e6-f8429df130e9@arm.com>
 <20261020141540.GB3008132@nvidia.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20261020141540.GB3008132@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/10/2026 15:15, Jason Gunthorpe wrote:
> On Tue, Oct 20, 2026 at 11:41:57AM +0100, Ryan Roberts wrote:
>> On 16/10/2026 15:42, Jason Gunthorpe wrote:
>>> On Fri, Oct 16, 2026 at 03:22:00PM +0100, Jean-Philippe Brucker wrote:
>>>> On Thu, 15 Oct 2026 at 17:41, Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>>> I think I said this last time, please don't use vfio mdev for
>>>>> anything. There is nothing mediated about this.
>>>>
>>>> We don't multiplex a device between guests, but the host driver must
>>>> control part of the device registers while the remainder is assigned to
>>>> a guest. The host configures accelerator access, stage-2 translation,
>>>> handles CPUHP and context save/restore. So we can't bind the device to
>>>> vfio-platform.
>>>
>>> That's fine, you can make a proper vfio-cla driver.
>>
>> Hi Jason,
>>
>> Thanks for taking a look at this! I've been chewing on this comment and trying
>> to educate myself deeper on the subject. I have a proposal...
>>
>> Currently we create a struct device per CLA device instance. But multiple CLA
>> device instances cooperate within a domain and the domain is the "unit of
>> isolation"; 
> 
> Well that's weird and a bit confusing.

Yes; this conversation is helping me to see that... :)

I was originally trying to avoid creating any globally visible entity that
describes a "domain", since I thought there was a possibility that each process
might want to define it's own view of a domain. But in hindsight I don't think
that's helpful...

> 
>> we can't have some CLAs from a domain assigned to a VM, while others
>> from the same domain are used by the host. Therefore it didn't feel like the
>> correct model to unbind one of these devices from the native driver and rebind
>> it to a cla-vfio driver. mdev seemed to solve this problem nicely for us.
>>
>> But looking into it in more detail, I guess something like this might be a bit
>> more standard:
>>
>>  - Split the existing CLA driver into three components:
>>     - cla-core: Hardware discovery, domain configuration, struct device
>>       registration and CPU hotplug
>>     - cla-native driver: Provides the user space accelerator interfaces
>>     - cla-vfio driver: Enables domains to be assigned to virtual machines
>>  - Each domain has a struct device (created by the core)
>>     - An individual CLA is not represented by a struct device
>>  - Either cla-native or cla-vfio can then bind to a domain device
>>     - cla-native exposes a char device per domain, per accelerator class
>>     - cla-vfio
>>
>> For VFIO, I guess we could use one VFIO region per CLA, which would allow the
>> VMM to construct a device tree. But it would need to additionally determine
>> which CPU each CLA is bound to; perhaps that's a sysfs interface that cla-core
>> could expose?
> 
> I don't know alot about your CLA, but this sounds reasonable. There
> may be uses with containers to have the split exposed like this too.

...This all feels much clearer and simpler. I'll work on an approach like this.

Thanks,
Ryan

> 
> Jason

