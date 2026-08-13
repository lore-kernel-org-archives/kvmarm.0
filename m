Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F473955D8;
	Thu, 13 Aug 2026 13:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786627768; cv=none; b=fTIeDoTOCS3WTPx31iZ4CWR0uVLD7a6Y4lDJWYbgNpsE+gY9qzV2NtyAJQyMSLpianSZ21Q4pd0bLEqT1uy/vqOjUYTaDfVlb5WHMtlbts7WwOBRFNHsF9D69owtMo3Xzv/4O9gIkemBIo9EWRGvg8EoLeqUFu8UHGtj3PjBic8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786627768; c=relaxed/simple;
	bh=AKed/U4TNFSTZh6a3Rv3l3G8DmPfh2BrrZhWhKa9FyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXwib+jVKmlF9XMffqcqnLyxxqUXvi1xCGEWFAPmo4s8L/Gg3IXXifEC7yNV6/K6LAEPleFDYj3QDwK9SA55XjrbajmS6zurVcKB2LrB9pj+A6bpKo+uxGyWaDmxn9maW4ihi23rH0VXZ6lImEp7n5IjhysJkBUty6muL325sHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+OU4sZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+OU4sZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0FC1F000E9;
	Thu, 13 Aug 2026 13:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786627767;
	bh=9l2fIPZLHFgJqNwuV0KdR0UTgLh+ulZx4MD++p+v8R0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W+OU4sZ1+m5vKUvEdLuvvOtwX4zCPoAw5A8OenasDBVhPwbMJLjL7vZokUywkyIP0
	 /rHNgkSQvxsd1oDhZZsInulnty4lOkddo7+CKpZYDnSioGEwrHVunmSTYwRdCwO5IK
	 ZLLtiHbZgXLCjzUt69dz5gWdXKJrFNSvrvjPIMsNfDjLUp/DAcxUcAVFhD5SoH0QL5
	 gAZsvkQF4KESvhXiInPdftyYZQzDjSiPv1/SJPEhwbYPMpH034MKMgtw55Mn/y9Ryp
	 Y1iwBdMK1WmhIjRE1bgQUq2F1I0wM9cbgaoGULPbIGpTQCLkDpcLqadLpIKRBiIV9R
	 fKELr5JPI/oxw==
Date: Thu, 13 Aug 2026 14:29:20 +0100
From: Will Deacon <will@kernel.org>
To: Sebastian Ene <sebastianene@google.com>, maz@kernel.org,
	oupton@kernel.org
Cc: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com,
	korneld@google.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, mrigendra.chaubey@gmail.com,
	perlarsen@google.com, suzuki.poulose@arm.com, vdonnefort@google.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v8 0/7] KVM: arm64: Forward FFA_NOTIFICATION* calls to
 TrustZone
Message-ID: <an3GsM9YeoIUL77d@willie-the-truck>
References: <20260729121306.1519473-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729121306.1519473-2-sebastianene@google.com>

Hi Oliver, Marc,

On Wed, Jul 29, 2026 at 12:13:00PM +0000, Sebastian Ene wrote:
> Remove the FFA_NOTIFICATION* calls from the blocklist used by the pKVM
> FF-A proxy. This restriction was preventing the use of asynchronous
> signaling mechanisms defined by the Arm FF-A specification to
> communicate with the secure services.
> While these calls are markes as optional, there is no reason why the
> hypervisor proxy would block them because:
> 
> 1. Host is the Sole Non-Secure Endpoint: The Host operates as the
>    only Non-Secure VM ID (VM ID 0) recognized by the Secure World.
>    Because all forwarded notifications are inherently attributed to
>    the Host by the SPMC, there is no risk of VM ID spoofing
>    originating from the Normal World.
> 
> 2. No Memory Pointers or Addresses: The FFA_NOTIFICATION_* ABIs
>    operate strictly via register-based parameters, passing only
>    VM IDs, VCPU IDs, flags, and bitmaps. Because these calls do
>    not contain memory addresses, offsets, or pointers, forwarding
>    them doesn't pose a risk of memory-based confused deputy attack
>    (e.g., tricking the SPMC into overwriting protected memory).
> 
> The pKVM proxy behaves as a relayer and it doesn't currently have its
> own FF-A ID(only the host has the ID 0). The behavior of the setup
> flow is covered by the spec in the: '10.9 Notification support without
> a Hypervisor'.
> 
> While at it, enforce the MBZ/SBZ fields defined by the spec to prevent
> odd behavior when a new version starts making use of the reserved
> registers.
> 
> ---
> v8:
> - rebased on 7.2-rc3
> - no other changes

I suspect the mention of FF-A in $SUBJECT might have pushed this off
your priority list, but please could you consider picking these up?

They've all been acked and the code hasn't changed since v7 (posted end
of June). We're not in a huge rush, so 7.4 is fine if you're done for
7.3.

Cheers,

Will
