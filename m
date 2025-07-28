Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C959433C4
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 14:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753711725; cv=none; b=bV4mwvsmRWU0wSsu7MPhhxZQ8Etw2cgQIwOJDmYFm3m8mgAFisaElCCpf4jR4duybdORdmR3Iui6qLaJ0LTKz6a0PIl5DN8ap73StVCiyuB2d0G0dqkaqdY/N8HdTOmPufPQmjz+cV/9gGnqXu9RLLkEbM4EJFr+GCA53FvMX4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753711725; c=relaxed/simple;
	bh=4kahnbCUUVK18hvpSBxURKB9raQB46M0iQ5FOKtQghE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWvF2KnnCTvhQ510CBijGbIvbJEsCmoCjiIymrG/TdQfJfscWoYqz4VRnCBeR3kMsEROf+kYSa+zIHfoMmz3AKJim2aQpVJLj6mfgDhFFcuJCDp36puQfPWnVPHW0hD1STr43vNz4pi5noev3GZv6BFg6k11dPEnqMr4kVE7G48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=C559wDSm; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="C559wDSm"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4abd3627e7eso66132991cf.0
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 07:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753711723; x=1754316523; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4kahnbCUUVK18hvpSBxURKB9raQB46M0iQ5FOKtQghE=;
        b=C559wDSmPJulpG31WSKvuAZsusIH3s+Oj9hxMBMhOAXbmbElL9HwX1CuCuZrWvcxRu
         XjvEbIMfaQivMPnuaUE08YQsMn0w+12LfhhdhRFADGmi1ZkG9X/CylgUvu90OiXReX7P
         6L3S7t5y1/VjF77qjwD45dagL5pkQe3TBhKBQd7OF01tWUBrTdVqVVaF4zFn13iVA+AW
         lZF0UM3xvuRk7rwX4AudOsinUzIBi9UZyQMSBBHlNrdcQshUFNRGH1fywca7WXcCte6C
         lE7tvpj8WpagC4DDSkBjoOQTiLxwlHeos0eOwPZTy/z0HVYtgleZnn2eFA06sYuLInJn
         uJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753711723; x=1754316523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kahnbCUUVK18hvpSBxURKB9raQB46M0iQ5FOKtQghE=;
        b=AAbABeFcKwwJFtNUcLC/KBhjnWNYAHoANWSbXM70j/W5gqs+8rK6kNhyFMVp+kELFX
         hVhqpEce1XRfCIpgFAKxz6XAzLYEBMzL4oe7aXor5jqy5BTrRMCrNuVmtaPBZCZfkCva
         ono4lAW5HOS6XWnGHgeP5UpLX8P1+Er7zB3zFpqi8wQRumCv569c0jiE13NA6mZ9Wyub
         Z2uClCS8Hbtbv1u7wzBJI5PpAMM8qt0/k57FWoeVUegJQYUYVv1HNi4xKbz1usb4VO3J
         o9w/WZzWqvsgZI7NtKxa4Lv2HzDJowzNFj6TOe/PkfKbfSpXsRDDidRcvvHQHooDNuU1
         xPfg==
X-Forwarded-Encrypted: i=1; AJvYcCUkPtawhN2MOLrptO3D743M4oFI4SD6XQRn32GMhgDglLdzbbGyIN9M7E8Ohkb4vV6KdeJ8Yg4=@lists.linux.dev
X-Gm-Message-State: AOJu0YztDGoJ16tnCQrh9HtSEbp1yS7rWTJupF+uXB/2ZSqsFc2/xg25
	146aIcHoRL6L/q69PetZcj+uakRrAbxJjzNwK0Bn6VWwcRLAJpVbccKJ5VxJ7lEZkW8=
X-Gm-Gg: ASbGncur3uWx/CGkj21oSxNiuE6UtO3XOm7bW/iuE4zsEhJWr5nwWspUSdSWk4gTMqH
	NbatDQgmsHPG+IXABrbs1c9h0XfmZu0pmPtT2258xgwq1XNEFJDVsFpkGhxD4ub1meCcYk/0R83
	0pb+naW1RXrDIixQZaqYDHqd76KWX346ruuSbavhbJfmPvqTyIPv6SfqNpw87R5FnxjbEq+7aAT
	tb4NPFxaOsdM10paZaqegS6uK6siiZVzc4Lexwpx/UQvnes9xfPRXZ1iDVFC3hPBp3epupxMvat
	6YtUwkq8f9aygy+Qz/DvL681sWvMqC+uzlBrihLSyVcost0sYbVt+OzqhFGGtOkYeBcw8eUXBSX
	ftlK4dXMJnaB6Gr2tGXBpRRwo7HmuAk1vq4GtadLcaVYLsDivajoZH0ED4bcCht//orPF
X-Google-Smtp-Source: AGHT+IGXQH54g+OEuDAZ//VEsPFOF0VZ1eCHZSsCk3KsPn6dRKNeXLVClWZB7Vwu63ig1wAqfFoyFQ==
X-Received: by 2002:a05:6214:929:b0:707:4509:b6c1 with SMTP id 6a1803df08f44-7074509b794mr50900796d6.11.1753711722526;
        Mon, 28 Jul 2025 07:08:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70729c70979sm30626156d6.86.2025.07.28.07.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 07:08:41 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ugOWv-00000000APv-1G4L;
	Mon, 28 Jul 2025 11:08:41 -0300
Date: Mon, 28 Jul 2025 11:08:41 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 06/38] iommufd: Add and option to request for bar
 mapping with IORESOURCE_EXCLUSIVE
Message-ID: <20250728140841.GA26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-7-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728135216.48084-7-aneesh.kumar@kernel.org>

On Mon, Jul 28, 2025 at 07:21:43PM +0530, Aneesh Kumar K.V (Arm) wrote:
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

Why would we need this?

I can sort of understand why Intel would need it due to their issues
with MCE, but ARM shouldn't care either way, should it?

But also why is it an iommufd option? That doesn't seem right..

Jason
