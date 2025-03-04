Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B03835946
	for <kvmarm@lists.linux.dev>; Tue,  4 Mar 2025 00:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741048701; cv=none; b=D/UjZrGDQ2Doyy4PhL8n8zD1F9m07FmpXlE+A3xVhBsGGuAgKtIcXdbE+tllWkQTe0bUXzr/pOBhJyxBGoQJNHT9ECmtowlcUSrkm0YUjoW776t5mBziAHm/ThHRUBi9wCv0QDLTU5lj8XC0EErho2cECv+/2bBnBFDTFjGo+YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741048701; c=relaxed/simple;
	bh=7RoPq9ddys8/BPSx9nAJBHesoRleCVq83HFxXGrTUd8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yze2d8cdFt8IRc9pUyAGOYfrR4npwqJOeezzGGipEyluhYW65jFc+agz5LHcDggMg1ZrrCpnfCg+uiUnXPBVtL1q/VuFhBtw/kCIytX+6ia8IM73cJ2mpb1wG4yUGfsaVqkbBmqAO3B7ytaZaJum8W46okqB4jyk45pRYxy04fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qCOJFsx1; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qCOJFsx1"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43bca0048c3so11515e9.1
        for <kvmarm@lists.linux.dev>; Mon, 03 Mar 2025 16:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741048698; x=1741653498; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U6X6RdB4UjE6/nuAZYBU8R5Fe+11M30bcPZso+kk5zo=;
        b=qCOJFsx1ft+rmaFo5Em4uYTOq8H8/Ho0DD19l5cyaiGVitd9gFBouyReuCyBVXgbQG
         QVThkH/Fjc4QF21gvKed4ACW98x4gh6FYUIwT3epw+JFOS3uBpA9k6wt9XV9QENi1UNN
         VOr5BX0hQlDrQJ27Vb6vVz6znwN37n1FbmIdP0sGEBjUxn8DJuQfHeFSa1P7bXTwpB2e
         PmEOy4S1iEIaWsgxinRM3k8MEylkGLCz6WY5k+W02fS6z2CH2MHVMCYSpI32tB8hIcVa
         P4Jl84QIC+h1j8MxagXW/scLrelqDPf6fVMkjkjxtCaB2MvaTYqGJM5PeDXVoX5An2gX
         kQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741048698; x=1741653498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6X6RdB4UjE6/nuAZYBU8R5Fe+11M30bcPZso+kk5zo=;
        b=lnNOqyoUcih3G9nu47nKEpomvqelIwokNCEqK/+psloEx9OCEZCJIwDtuj7JT1zNrx
         jSqBZFSjyRuRGdb+OeIqY8/ctHEY/GHtPLrtXFRMNTyZYHsVFjxc76B+f6Ryw4sthP7Q
         4rXPBTxzOelnrOxu865sCmSyCGSgklbXN/NqA3/QYyUIUbjEZZmCm3EbDh+5D7jx3Md6
         fo0IrbYHaLdaMct+Xa/2EO/cQWg+gLBIMz2K8B+gmgKSKc8AUAo/z+UEbYExhyTaoAuA
         uvfVt9c+F3bXRGuTeuhib3A/q86X3fTakDudJdiN4ck/1Wt9Xa4q6wVcaFqwmrM6U1MM
         c8vg==
X-Forwarded-Encrypted: i=1; AJvYcCXTWxaTD9v+TIIi+83FsJLC424iH3ARXNNoi04c85JEbGHZ8RBceM3ef4XG033Vh4/7ecHOmlE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2ogkyg5o/CXq21g03R8204om6bRBU1ddxTlQ3JJkJMyX0pyD9
	gvNKYAFZWZE7Z7uiRb4Z3s0tBXGDGh8zRZN7s9S5uYcjgj/MxnYQ4iWaJgyb1Q==
X-Gm-Gg: ASbGncu85F0VjyhW2Nw9n2y46muRg2Jlwc/HPXDYF3ughASN1n59PpMF88pqjpz5J4Y
	47K60z6qjNF0cPMcS4tF8IVca4oP2MOu40Ez+lJCn0wbBMKeyFec050Oqua+b3OxXgStg06PFjc
	f6CwLfxvVkMGGogZaBS3edGLuHNtMPWIQkCOnV6JMIMINQrlak/CYPI0UltiBgMBYCnWCWPiJJe
	YLVQOf0a71cWk1ZhPReMTGXw47O+inyAf6ln1z0liYPfCbMu9xSGx13nRkT9rvIxPTKWfio5utQ
	/juTjojcy61eb6/0u900U6TjBd7fwZ02anONuLL7KK7mI4TYr1IYBK/IxOUG3g1PuDe4YaOxY7D
	YTtrt8eBwf9r3
X-Google-Smtp-Source: AGHT+IE9Y0VrehBJlDbDHPyoWXw+m1J69GUEuvY40Y+njXxv5FVs5PR5YGF4xAoIWOX1sa7YhrCg7Q==
X-Received: by 2002:a05:600c:4295:b0:43b:c396:7405 with SMTP id 5b1f17b1804b1-43bcbe292f1mr260995e9.7.1741048698270;
        Mon, 03 Mar 2025 16:38:18 -0800 (PST)
Received: from google.com (100.235.22.34.bc.googleusercontent.com. [34.22.235.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e485dcc1sm15629062f8f.87.2025.03.03.16.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 16:38:17 -0800 (PST)
Date: Tue, 4 Mar 2025 00:38:15 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>,
	catalin.marinas@arm.com, joey.gouly@arm.com, oliver.upton@linux.dev,
	snehalreddy@google.com, suzuki.poulose@arm.com,
	vdonnefort@google.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v2 2/4] KVM: arm64: Move the ffa_to_linux definition to
 the ffa header
Message-ID: <Z8ZLdwmFzS-lnssj@google.com>
References: <20250227181750.3606372-1-sebastianene@google.com>
 <20250227181750.3606372-3-sebastianene@google.com>
 <20250227202557.d3fd6ylzbaho4pvx@bogus>
 <Z8DxZY-09R6lwEW3@google.com>
 <86wmdapei8.wl-maz@kernel.org>
 <20250303234426.GB30749@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303234426.GB30749@willie-the-truck>

On Mon, Mar 03, 2025 at 11:44:28PM +0000, Will Deacon wrote:
> On Fri, Feb 28, 2025 at 10:09:19AM +0000, Marc Zyngier wrote:
> > On Thu, 27 Feb 2025 23:12:37 +0000,
> > Sebastian Ene <sebastianene@google.com> wrote:
> > > 
> > > On Thu, Feb 27, 2025 at 08:25:57PM +0000, Sudeep Holla wrote:
> > > > On Thu, Feb 27, 2025 at 06:17:47PM +0000, Sebastian Ene wrote:
> > > > > Keep the ffa_to_linux error map in the header and move it away
> > > > > from the arm ffa driver to make it accessible for other components.
> > > > 
> > > > Do you plan to push/target these changes for v6.15 ? If not, I can take
> > > > this patch with other FF-A changes in my tree for v6.15. Otherwise, it
> > > > is must go along with other changes.
> > > > 
> > > 
> > > Yes, feel free to pick them with your changes and we can push them
> > > later.
> > 
> > So this series is not a 6.15 candidate?
> 
> I think this is 6.15 stuff once it's been reviewed. Sudeep's message is
> a little confusing as it refers to 6.15 twice (I guess he meant 6.14 the
> first time?).
> 

Right, I think it should be for 6.15 after it ticks the review boxes.

> Will

Thanks,
Seb
