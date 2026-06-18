Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643673242D8
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 20:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781814123; cv=none; b=bRKMXaFIzjZKRj9kFlAm/OHx73z5TUIHf+eOz8OOzhbJiYQEguw4Y6613cfB2dtLYANOZrXksQ1ZJQGaSsgQC0bPQGxNQuCaPkTz/P3lDE0pIHAUPK/wdvn8aSTZdhSBzCvdcoUbNlLzfIjKQI/wM4+F6zz7eEsyHVjtanrk+tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781814123; c=relaxed/simple;
	bh=oZHAxpIqUFadijIyqON+Dd9Hmvbr+/PPGnzg5RHUNoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uURIurWH6265G9M69SNC42NwKQoc4hkNwc/BBlwkXDY61OR3e2ywBo1rnprWvooCGsBBvKiZeu5WXIwGkzIMqMcd6ZpWa66JLcOCpoxZfGXQRYflmp6K6z7/lyCyfLp6+IoFXIvtt9IU0+hgtBiXrnxzN/tSwRW7RvZOC066tts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RZsVvMu3; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RZsVvMu3"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8453f568e84so1229671b3a.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 13:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781814122; x=1782418922; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R8xCK89QfRMaVvrkpnB5YO+Fnx8pGynYV6YoyF7gSgA=;
        b=RZsVvMu3q4ZPYrzed0JUHyyausQ+szjZLNMwV1jLbW69q3hnfXyoM+mFXZY8ws+zkg
         43hI10yBFIN3DbGUTI2JoDRBS4gfy6vN2hjc8Hq5c37Y4P3C/nGkyZRYq2Oyyv2cljbC
         U1kUTWh1NXNfG3curaKnSgd1xE7mHg38P6nTNjgD4ZezAUd2byUYBm+b1nnX2YERKyQ2
         xrQNEer7WlR3HP924YdWGXVoyy+oPJzKi4Ekyvapxa1RwbyJdu+OI/yxseiM5oLt0fOf
         OitxD881VOTCztljOqDQybUQ9wifgB0xQO8RKHdBOzUNF/JcbMS+zqLZTlrmouhVvY1K
         580g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781814122; x=1782418922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R8xCK89QfRMaVvrkpnB5YO+Fnx8pGynYV6YoyF7gSgA=;
        b=Nv9tzNu8EMNOAAWjmWMWPHmE2hQkil5In3LZxYm3EOarX7UVnGDqkhV8si5ZZR0zho
         YOthMfJX4HNHuojbNPFV9LRbH3+0YxHPb6VSvj3NJEkWGVKgvpwYD5aNQYsJuCzuc7pO
         B5XhX3zJo6hbyCFE2XLQ7qHwNSziaBlTJzXcucL5YW9KqT1erpg785Z8RDGreux1V9M5
         ZeTUUV5H/WUa5ivm377Vr25xBTdSx0t/BHYUVoA20zBeVDHRTZbf3jVfKVN9oR+DOolI
         XvLshE+Zo48MsX8Ed3IhzhGcm8PSx9SdoefrfKiER1pimMPVlclaANi9AG+jEGJQGEjt
         2x0A==
X-Forwarded-Encrypted: i=1; AFNElJ8FN2iCxUW7jScTg3qP/0iCzIPp9ZjlWrTYQ6QdkpivKLRQnrREYrLRX37H3lXTqsAFr5vt/Lw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyP0n467AI07M+3wL9ku66jCUQvrK8crZJWQI5a1lQhdVnOz+8y
	872WP+xIRrWmVoCv8gkbzDMyj0UOhdyq9nnfbDVJZZQEAQvoVfo2BDFlOEgVFFtxeY9Vltd0rVY
	QE1FdgQ==
X-Gm-Gg: AfdE7cnnAsVMzLyVKxyzL4jO6xNzGtfqWWqkrH8+4YQxwQhwsEEdiQvYNHqibhE8rB/
	keehzdBDhT4lWF9LgPfxg1vFDj4f9KfM1EHNWOukVDv0mqi0VRp2iAr20zWDbQZFDIY9KYWrnaO
	+8MWw1wQIpIb3mjmKG6KULNAsBeiWp3vms8p0tKmvMUwSpeBrggRrg0/82zQ1gpbEJiXkAOmBnL
	tgijk/0oVErB2CZ0cyrSjkwXAaXNjBvO7ci37/qCpPHbaryvTJu5otFPLxaLL7c0AAPJFi6d6QI
	L5Ckg1Gaw+wY6aE67M52gjDF3mpEe95NEimlmrFzPtmsCICkBRYO1tYwk38GNe+ix4ks7bdg9Ok
	STlm0YiVYrAbUiIV5y53KdeSuozt3U0p6yC4vjziz+YTOVmCGVeaBQ84xhBwcTGetRX2gRIcRKH
	TjEE+UMWYcKdH+ALQdOgh0PkzmBV3kHs+P+Mhk3yCfzMWFrEGWrA0=
X-Received: by 2002:a05:6a00:4fd1:b0:845:17a6:5741 with SMTP id d2e1a72fcca58-8455079c80amr485384b3a.1.1781814121017;
        Thu, 18 Jun 2026 13:22:01 -0700 (PDT)
Received: from google.com (56.149.168.34.bc.googleusercontent.com. [34.168.149.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8453a8c9770sm3735614b3a.40.2026.06.18.13.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 13:22:00 -0700 (PDT)
Date: Thu, 18 Jun 2026 20:21:56 +0000
From: David Matlack <dmatlack@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Josh Hilke <jrhilke@google.com>
Subject: Re: [PATCH v7 09/20] KVM: selftests: Add VFIO device support to
 eventfd IRQ test
Message-ID: <ajRTZNum3u7oVdRa@google.com>
References: <20260613002031.745413-1-seanjc@google.com>
 <20260613002031.745413-10-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260613002031.745413-10-seanjc@google.com>

On 2026-06-12 05:20 PM, Sean Christopherson wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Extend the eventfd IRQ test with a '-d' argument that takes a BDF (in the
> format segment:bus:device.function) of an interrupt-capable PCI(e) device
> bound to VFIO, and use said device to trigger interrupts instead of always
> synthesizing interrupts via direct writes to the eventfd.
> 
> Using a VFIO device to trigger interrupts validates the end-to-end delivery
> of IRQs for "real" devices, and when supported by hardware (and KVM), also
> validates interrupt delivery via IRQ bypass, i.e. via device posted IRQs.
> 
> Now that IOMMUFD is a thing, auto-probe IOMMUFD vs. "legacy" VFIO by
> temporarily opening /dev/iommufd, and skip the test if neither IOMMUFD nor
> legacy VFIO is available.  Add a '-t' option to the user override the probe
> logic, e.g. in case IOMMUFD is available but the system is configured for
> legacy usage.
> 
> Note, the device must have a VFIO selftest driver in order to work with
> the test.  A helper script to list supported devices will hopefully be
> available in the near future at
> tools/testing/selftests/vfio/scripts/list_supported_devices.sh[1].

> +static int vfio_setup_msi(struct vfio_pci_device *device)
> +{
> +	const int flags = MAP_SHARED | MAP_ANONYMOUS;
> +	const int prot = PROT_READ | PROT_WRITE;
> +	struct dma_region *region;
> +
> +	/* A driver is required to generate an MSI. */
> +	TEST_REQUIRE(device->driver.ops);

This series is probably going to race with merging another VFIO
selftests patch to make send_msi() optional [1]. Can you add a check for
that here?

  TEST_REQUIRE(device->driver.ops);
  TEST_REQUIRE(device->driver.ops->send_msi);

[1] https://lore.kernel.org/kvm/20260609232855.3808971-4-rubind@nvidia.com/
