Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45FE2F8EB8
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 21:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781818957; cv=none; b=FN8f7CcdHsundmR/LNJTKaYFqxsMceEnR94HMPhVzjgXeJJxpbEs/KUZCohwWm+AymBckZoHNtD+SxyCVkx/D97ojk3Qql4cQ8BzchJP0pHr/xsn6O+mgemlXJ5xWfHdiIiiRA0D3ORJwXVHTQLNlo7r1ze4Ya9fPRagMv5rC5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781818957; c=relaxed/simple;
	bh=erAt7Hebe5cIxFrAXhISXrNJA158nQ36dNCzkxhvulM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CAR5I3Lc2SvWx+8TnM3E5ySMPLEZKVhF5rZKGTJuATXTdIQ1RXFB1li27KONgplkwpa6uCSv3gTYmgExNVz0Qufrd0BWIh+sd8IqGov4zh3B5gODjGmQtIxJlsM/Kjd6UV3bDcUc8pJo5Cb2U+vwi6YtXwqzW1TBbIyKgcMnLDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wEdjfn/j; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wEdjfn/j"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8422f987f2eso2137759b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 14:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781818955; x=1782423755; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V8j94fpKwfXbxZh5xLHwe7ucGfUmxazlRZU8sB7HYkU=;
        b=wEdjfn/jwM8rBretw8RXEjKlsrpIyaLuyOqyCQOVVaAMs1L2gJLt2jWxmIqcx+1/xQ
         HQTyEQu/VfaeqaiEQXv7phyZJFAn1sJIADhB2JwRt1jn/vIKSW//pGWEpw4iuCH7ELkp
         8dcJoEjzM2rJudyxCXAEgUbWLvqFQkuAfaIfW06m1ycwt72beUwGhvisFvImOb6NYBj8
         ZLUU+3rUqdjckKreIkR/0xXwkWbZMbeVxwavX6zSBvRc3TimSdiU7KxSXclA6AdajGHi
         6VneVenNeu3G8SaXY5TS0ruQYPQVBHFksbDhIuSJpstIb+KtyjAOEK+OJaagG3Va/Rgj
         TLQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781818955; x=1782423755;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V8j94fpKwfXbxZh5xLHwe7ucGfUmxazlRZU8sB7HYkU=;
        b=iCumJLF8RgG3eiRTtbeNGZ5FAWEkKtQ5qyY8cjs2RX299Q5wCLtvScULKZaZJDurll
         F+ClhXQ2yJ7W73aVTEeuzZ4dANDTHaG2Qou+oAT+y4n2/yDgVCXdCZ3xN/eW2ntDapJl
         IQC7p7qnLGZn6/dOOu8FaFadeVr5yJi063x3drCKevQVEXuYy5Kg3o/+evVmrELlwUe5
         p/adyq8vdqKlFN+BGnYd6HNLLcltDpS/ApHXTzDLU+354ZkDnyK7K9kNZI6fsAPfUYjL
         chxJyJgZq5Mw44effsHT0CgqU11vRbYunqCXeo2gkPSQ2NE8LGkuWF6STpAoCP+Eqht5
         hddQ==
X-Forwarded-Encrypted: i=1; AFNElJ+rndPG5uarEvWfV+uMrrcRY4Hwl/Mjn0BEdASlsIBLB3J5XnFu/ekwnWhOsQDLj131bOtE8qk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrIw36hILwmaTM8G+HtyyDVA4q3Ft/W1+ilgR++SYhOXklaVa9
	IbDCci7CK3ND67uhgu+hLgAY3RmoiJ74hFldE/7Pv1qIWUwzbGPIACWolus+LP8GYmiaeh1mr/C
	mnJ93Rg==
X-Received: from pfbjc15.prod.google.com ([2002:a05:6a00:6c8f:b0:82f:20ed:8059])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:6c9c:b0:845:374f:4ee7
 with SMTP id d2e1a72fcca58-845507dabc4mr738565b3a.13.1781818954904; Thu, 18
 Jun 2026 14:42:34 -0700 (PDT)
Date: Thu, 18 Jun 2026 14:42:34 -0700
In-Reply-To: <ajRTZNum3u7oVdRa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260613002031.745413-1-seanjc@google.com> <20260613002031.745413-10-seanjc@google.com>
 <ajRTZNum3u7oVdRa@google.com>
Message-ID: <ajRmStVr-2-QgqGB@google.com>
Subject: Re: [PATCH v7 09/20] KVM: selftests: Add VFIO device support to
 eventfd IRQ test
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Josh Hilke <jrhilke@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 18, 2026, David Matlack wrote:
> On 2026-06-12 05:20 PM, Sean Christopherson wrote:
> > From: David Matlack <dmatlack@google.com>
> > 
> > Extend the eventfd IRQ test with a '-d' argument that takes a BDF (in the
> > format segment:bus:device.function) of an interrupt-capable PCI(e) device
> > bound to VFIO, and use said device to trigger interrupts instead of always
> > synthesizing interrupts via direct writes to the eventfd.
> > 
> > Using a VFIO device to trigger interrupts validates the end-to-end delivery
> > of IRQs for "real" devices, and when supported by hardware (and KVM), also
> > validates interrupt delivery via IRQ bypass, i.e. via device posted IRQs.
> > 
> > Now that IOMMUFD is a thing, auto-probe IOMMUFD vs. "legacy" VFIO by
> > temporarily opening /dev/iommufd, and skip the test if neither IOMMUFD nor
> > legacy VFIO is available.  Add a '-t' option to the user override the probe
> > logic, e.g. in case IOMMUFD is available but the system is configured for
> > legacy usage.
> > 
> > Note, the device must have a VFIO selftest driver in order to work with
> > the test.  A helper script to list supported devices will hopefully be
> > available in the near future at
> > tools/testing/selftests/vfio/scripts/list_supported_devices.sh[1].
> 
> > +static int vfio_setup_msi(struct vfio_pci_device *device)
> > +{
> > +	const int flags = MAP_SHARED | MAP_ANONYMOUS;
> > +	const int prot = PROT_READ | PROT_WRITE;
> > +	struct dma_region *region;
> > +
> > +	/* A driver is required to generate an MSI. */
> > +	TEST_REQUIRE(device->driver.ops);
> 
> This series is probably going to race with merging another VFIO
> selftests patch to make send_msi() optional [1]. Can you add a check for
> that here?
> 
>   TEST_REQUIRE(device->driver.ops);
>   TEST_REQUIRE(device->driver.ops->send_msi);

Ya, will do.
